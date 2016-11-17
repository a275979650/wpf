package com.bns.modules.comm.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bns.modules.comm.dao.ImportDataDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.excel.entity.HeaderCellEntity;
import com.thinkgem.jeesite.common.utils.excel.entity.HeaderEntity;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Service
public class ImportDataService {

	@Autowired
	private ImportDataDao importDataDao;

	public final String IMPORT_SUCCESS = "1";
	public final String IMPORT_FAIL = "0";
	private int startLine = 2;

	public Map<String, Object> getTableInfo(String dicId){
        return importDataDao.getTableInfo(dicId);
    }
	
	public List<Map<String, Object>> listFieldInfo(String dicId) {
		return importDataDao.listFieldInfo(dicId);
	}

	/**
	 * 
	 * <p>Discription:[模板下载查询用户已选字段信息]</p>
	 * @param dicId
	 * @param fields
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public List<Map<String, Object>> getTemplateFieldList(String dicId, String fields){
	    Map<String, Object> para = new HashMap<String, Object>();
        para.put("dicId", dicId);
        para.put("fields", fields);
	    return importDataDao.getTemplateFieldList(para);
	}
	
	public Map<String, Object> getRequiredFieldString(String dicId) {
        return importDataDao.getRequiredFieldString(dicId);
    }
	
	/**
	 * 
	 * <p>Discription:[模板下载，自动生成表头对象]</p>
	 * @param dicId
	 * @param fields
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public HeaderEntity getHeader(String dicId, String fields) {
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("dicId", dicId);
		para.put("fields", fields);
		List<Map<String, Object>> fieldList = importDataDao.getTemplateFieldList(para);
		int len = fieldList.size();
		HeaderEntity headerEntity = new HeaderEntity(len);
		for (int i = 0; i < len; i++) {
			String title = MapUtils.getString(fieldList.get(i), "FIELD_NAME");
			headerEntity.addCol(new HeaderCellEntity(title, 0, 0));
		}
		return headerEntity;
	}

	/**
	 * 
	 * <p>Discription:[导入文件记录数检查]</p>
	 * @param workBook
	 * @param dicId
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public String importBase(Workbook workBook, String dicId) {
		try {
			Sheet sheet = workBook.getSheetAt(0);
			List<Map<String, Object>> fieldList = this.findField(sheet, dicId);
			List<Map<String, Object>> required = importDataDao.getRequiredField(dicId);
			if (fieldList.containsAll(required)) {
				int baseNum = sheet.getLastRowNum();
				if (baseNum < startLine) {
					this.saveImportResult(null, "无导入数据，请添加数据后导入！", this.IMPORT_FAIL, dicId);
					return "无导入数据，请添加数据后导入！";
				} else if (baseNum > 1002) {
					this.saveImportResult(null, "导入数据过多，请小于1000条！请分批次处理！", this.IMPORT_FAIL, dicId);
					return "导入数据过多，请小于1000条！请分批次处理！";
				} else {
					return this.importData(fieldList, sheet, dicId);
				}
			} else {
				this.saveImportResult(null, "导入文件中的必须字段缺失，请重新下载模板！", this.IMPORT_FAIL, dicId);
				return "导入文件中的必须字段缺失，请重新下载模板！";
			}
		} catch (Exception e) {
			this.saveImportResult(null, e.getMessage(), this.IMPORT_FAIL, dicId);
			return "导入失败：" + e.getMessage();
		}
	}

	/**
	 * 
	 * <p>Discription:[遍历excel进行数据检查并插入或更新信息表]</p>
	 * @param fieldList
	 * @param sheet
	 * @param dicId
	 * @return
	 * @throws Exception
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	@Transactional(rollbackFor={RuntimeException.class, Exception.class})
	private String importData(List<Map<String, Object>> fieldList, Sheet sheet, String dicId) throws Exception {
	    StringBuffer checkString = new StringBuffer("");
        StringBuffer noempString = new StringBuffer("");
        StringBuffer repeatString = new StringBuffer("");
        String uq = "SID";//唯一数据判断依据
        String pk = "ID";//主键字段
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Pattern pattern = Pattern.compile("^-?[0-9]+(.[0-9]{1,3})?$");
		String importId = UUID.randomUUID().toString();
		int baseNum = sheet.getLastRowNum();
		int fieldNum = fieldList.size();
		int insertNum = 0, updateNum = 0;
//		List<Map<String, Object>> fundList = importDataDao.getFundList();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		for (int m = startLine; m <= baseNum; m++) {
		    StringBuffer rowcheck = new StringBuffer();
			Map<String, Object> para = new HashMap<String, Object>();
			// 读取一行记录数据
			for (int n = 0; n < fieldNum; n++) {
				Cell colCell = sheet.getRow(m).getCell(n);// 取出单元格
				if (colCell != null) {// 数据值处理
					String colValue = this.getCellValue(colCell);
					// 有必要代码集进行转码处理
					Object codeSort = fieldList.get(n).get("CODE_SORT");
					Object fieldType = fieldList.get(n).get("FIELD_TYPE");
					if(StringUtils.isNotBlank(colValue) || 
                            "1".equals(MapUtils.getString(fieldList.get(n), "REQUIRED"))){
    					if (codeSort != null && !"".equals(codeSort)) {
    						if ("SYS_OFFICE".equals(codeSort)) {// 部门情况处理
    							String code = DictUtils.getOfficeIdByName(colValue, "");
    							if ("".equals(code)) {// 部门代码无法查询到对应的值
    							    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME") 
                                            + "无法找到编码,");
                                    continue;
    							}else{
    								para.put(MapUtils.getString(fieldList.get(n), "FIELD_ID"), code);
    							}
    						}/*else if ("T_WAGE_SOURCE".equals(codeSort)) {// 经费来源情况处理
                                String code = "";
                                for(Map<String, Object> fund : fundList){
                                    if(colValue.equals(MapUtils.getString(fund, "FUND_NAME"))){
                                        code = MapUtils.getString(fund, "WAGE_FUND_ID");
                                        break;
                                    }
                                }
                                if ("".equals(code)) {// 经费来源代码无法查询到对应的值
                                    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
                                            + "无法找到编号,");
                                    continue;
                                } else {
                                    para.put(MapUtils.getString(fieldList.get(n), "FIELD_ID"), code);
                                }
                            }*/ else {
    							String code = DictUtils.getDictValue(colValue, (String) codeSort, "");
    							if ("".equals(code)) {// 代码集无法查询到对应的值
    							    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
                                            + "无法找到编号,");
                                    continue;
    							} else {
    								para.put(MapUtils.getString(fieldList.get(n), "FIELD_ID"), code);
    							}
    						}
    					}else{
    						if (fieldType != null && "DATE".equals(fieldType)) {
    							try {
    							       if(colValue.length()==7){
    							           colValue += "-01";
    							           simpleDateFormat.parse(colValue);
    							       }else if(colValue.length()==10){
    									   simpleDateFormat.parse(colValue);
    							       }else{
    							           rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
    	                                            + "时间格式不正确,");
    	                                    continue;
    							       }
    								
    							} catch (Exception e) {
    							    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
                                            + "时间格式不正确,");
                                    continue;
    							}
    						}else if (fieldType != null && "NUMBER".equals(fieldType)) {
    						    if(!pattern.matcher(colValue).matches()){
                                    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
                                            + "数字格式不正确,");
                                    continue;
                                }
    						} else if ("1".equals(MapUtils.getString(fieldList.get(n), "REQUIRED"))) {
    							if (colValue == null || "".equals(colValue)) {
    							    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME")
                                            + "缺失,");
                                    continue;
    							}
    						}
    						para.put(MapUtils.getString(fieldList.get(n), "FIELD_ID"), colValue);
    					}
					}else{
					    para.put(MapUtils.getString(fieldList.get(n), "FIELD_ID"), null);
					}
				} else if ("1".equals(MapUtils.getString(fieldList.get(n), "REQUIRED"))) {
				    rowcheck.append(MapUtils.getString(fieldList.get(n), "FIELD_NAME") + "缺失,");
                    continue;
				}
			}
			if(rowcheck.length()>0){
                checkString.append(m+1+"行：").append(rowcheck);
            }
            if(checkString.length()>2000){
                checkString=new StringBuffer(checkString.substring(0, 1980)+"后面检查省略。。。");
                break;
            }
            
            ///////////////////////////////////////////////////////////////////////////////////////////
            ////检查的数据没有出现过不合要求才将数据进行收集
            if(checkString.length()==0){
                //查找是否已存在该记录
                //检查唯一字段
                Map<String, Object> uqmap = new HashMap<String, Object>();
                uqmap.put("dicId", dicId);
                uqmap.put("uqString", "SID = '" + (String) para.get(uq) + "'");//此处如果含有特殊字符会出错
                
                List<Map<String, Object>> entity = importDataDao.getEntity(uqmap);
                if(entity==null || entity.isEmpty()){
                    insertNum++;
                    para.put(pk, UUID.randomUUID().toString().substring(0, 32));
                    insertList.add(para);
                }else{
                    updateNum++;
                    para.put(pk, entity.get(0).get(pk));
                    updateList.add(para);
                }
            }
		}
		
		
            ////////////////////////////////////////////////////////////////////////////////////////
            /////检查结束看是否有不如何要求的数据：有则不修改数据库返回；数据全部符合检查则插入数据
            if(checkString.length()>0){ 
                String returnString = "导入数据不合格：<br>"+checkString.toString();
                if (noempString.length() > 0) {
                returnString += "<br>其中：" + noempString + "无教职工基本信息未导入修改。";
                }
                if (repeatString.length() > 0) {
                returnString += "<br>其中：" + repeatString + "有重复数据未导入修改。";
                }
                this.saveImportResult(importId, returnString, this.IMPORT_FAIL, dicId);
                return returnString;
            }else{
                // 导入数据和历史记录，顺序注意不能变换
                if (insertList.size() > 0) {
                    importDataDao.insertImportBatch(insertList);
                }
                if (updateList.size() > 0) {
                    importDataDao.updateImportBatch(updateList);
                }
            String returnString = "导入成功：";
            if (insertNum > 0) {
                returnString += "共计新增" + insertNum + "条记录;";
            }
            if (updateNum > 0) {
                returnString += "共计更新" + updateNum + "条记录。";
            }
            if (noempString.length() > 0) {
                returnString += "<br>其中：" + noempString + "无必需的基本信息。";
            }
            if (repeatString.length() > 0) {
                returnString += "<br>其中：" + repeatString + "数据重复未导入修改。";
            }
            this.saveImportResult(importId, returnString, this.IMPORT_SUCCESS, dicId);
            return returnString;
		}
	}

	private String getCellValue(Cell cell) {
		String ret;
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		switch (cell.getCellType()) {
		case Cell.CELL_TYPE_BLANK:
			ret = "";
			break;
		case Cell.CELL_TYPE_BOOLEAN:
			ret = String.valueOf(cell.getBooleanCellValue());
			break;
		case Cell.CELL_TYPE_ERROR:
			ret = null;
			break;
		case Cell.CELL_TYPE_FORMULA:
			Workbook wb = cell.getSheet().getWorkbook();
			CreationHelper crateHelper = wb.getCreationHelper();
			FormulaEvaluator evaluator = crateHelper.createFormulaEvaluator();
			ret = getCellValue(evaluator.evaluateInCell(cell));
			break;
		case Cell.CELL_TYPE_NUMERIC:
			if (DateUtil.isCellDateFormatted(cell)) {
				Date theDate = cell.getDateCellValue();
				ret = simpleDateFormat.format(theDate);
			} else {
				ret = NumberToTextConverter.toText(cell.getNumericCellValue());
			}
			break;
		case Cell.CELL_TYPE_STRING:
			ret = cell.getRichStringCellValue().getString();
			break;
		default:
			ret = null;
		}
		return ret;
	}

	/**
	 * 获取自定义模板的表头信息
	 * 
	 * @param sheet
	 * @return
	 */
	private List<Map<String, Object>> findField(Sheet sheet, String dicId) throws Exception {
		List<Map<String, Object>> fieldList = new ArrayList<Map<String, Object>>(); // 表字段信息
		for (int i = 0;; i++) {
			Map<String, Object> columnsMap = new HashMap<String, Object>();
			Cell colCell = sheet.getRow(1).getCell(i);// 取出导入表的表头值
			if (colCell != null && !"".equals(colCell.getStringCellValue())) {
				String colValue = colCell.getStringCellValue();
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("dicId", dicId);
				para.put("name", colValue);
				columnsMap = importDataDao.findFieldByCHName(para); // 根据表头中文名查询数据库对应的字段
				if (columnsMap == null) {
					throw new RuntimeException("文档中" + colValue + "字段名称错误,请按照模版导入文件，或重新下载模板!");
				} else {
					fieldList.add(columnsMap);
				}
			} else {
				break;
			}
		}
		return fieldList;
	}

	public void saveImportResult(String importId, String result, String flag, String dicId) {
		User user = UserUtils.getUser();
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(importId)) {
			map.put("IMPORT_ID", importId);
		}else{
		    map.put("IMPORT_ID", UUID.randomUUID().toString());
		}
		map.put("USER_ID", user.getLoginName());
		map.put("USER_NAME", user.getName());
		map.put("SUCCESS_FLAG", flag);
		map.put("IMPORT_RESULT", result);
		map.put("DIC_ID", dicId);
		importDataDao.insertImportResult(map);
	}

    public Page<Map<String, Object>> listHistory(Page<Map<String, Object>> page,
            FormBean formbean){
        PaginationMap map =(PaginationMap) formbean.getBean();
        map.setPage(page);
        page.setList(importDataDao.listHistory(map));
        return page;
    }

}
