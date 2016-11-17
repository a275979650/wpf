package com.bns.modules.comm.web;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.comm.service.ImportDataService;
import com.bns.utils.FormBean;
import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.excel.ExportExcel;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 自定义导入 
 * @author 朱凯
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/comm/import")
public class importDataController extends BaseController{
	
	@Autowired
	private ImportDataService importDataService;
	
	/**
	 * 跳转导入主页面
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "index")
	public String index(String dicId, HttpServletRequest request, HttpServletResponse response, Model model)
			throws Exception {
		String requiredFieldString = "";
		if(dicId!=null && !"".equals(dicId)){
			Map<String, Object> required = importDataService.getRequiredFieldString(dicId);
			requiredFieldString = MapUtils.getString(required, "REQUIRED_FIELD");
		}
		model.addAttribute("requiredFieldString", requiredFieldString);
		return "modules/comm/import";
	}
	
	/**
	 * 跳转模板下载主页面
	 * @param formbean
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "template")
	public String baselist(String dicId,HttpServletRequest request, HttpServletResponse response, Model model)
			throws Exception {
		List<Map<String,Object>> fields = importDataService.listFieldInfo(dicId);
		model.addAttribute("fields", fields);
		return "modules/comm/template";
	}
	
	/**
	 * 下载自定义模板
	 * @param formbean
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "downloadTemplate")
	public String downloadTemplate(FormBean formbean,HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes, Model model) throws Exception{
	    String dicId = MapUtils.getString(formbean.getBean(),  "dicId");
        String fields = MapUtils.getString(formbean.getBean(),"FIELDS");
        String tableName = MapUtils.getString(importDataService.getTableInfo(dicId), "TABLE_NAME");
        if(StringUtils.isBlank(tableName)){tableName = "";}
	    /*try {
			HeaderEntity header = importDataService.getHeader(dicId, fields.substring(1));
			new ExportExcel(tableName+"导入模板", header).write(response, tableName+"导入模板.xlsx").dispose();
		} catch (Exception e) {
			model.addAttribute("message", "导出失败！失败信息：" + e.getMessage());
			model.addAttribute("message", "导出失败，请检查下载模版配置再进行导出！");
			return "modules/comm/importResult";
		}
		return null;*/
	    /**
	     * 防止身份证号变成科学计数法
	     * 防止日期变成英文
	     */
	    
		List<Map<String, Object>> fieldList = importDataService.getTemplateFieldList(dicId, fields.substring(1));
		List<String> list = Lists.newArrayList();
		for(Map<String, Object> field : fieldList){
		    String value  = MapUtils.getString(field, "FIELD_NAME");
		    list.add(value);
		}
		try {
		    
			ExportExcel exportExcel= new ExportExcel(tableName+"导入模板", list,"org","T_COMMON.xlsx");
			exportExcel.write(response, tableName+"导入模板.xlsx").dispose();
		} catch (Exception e) {
			model.addAttribute("message", "导出失败，请检查下载模版配置再进行导出！");
			return "modules/comm/importResult";
		}
		return null;
	}
	
	/**
	 * 导入信息
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "importBase", method=RequestMethod.POST)
    public String importBase(MultipartFile file, String dicId, Model model, RedirectAttributes redirectAttributes) {
		Workbook workBook = null;
		String fileName = file.getOriginalFilename();
		String importInfo = "";
		if(StringUtils.isBlank(dicId)){
			importInfo = "导入失败！失败信息：传入数据有误，请刷新页面后重试！";
		}else{
			//检查文件
		    InputStream stream = null;
			try {
				if (StringUtils.isBlank(fileName)){
					importInfo = "导入失败！失败信息：导入文档为空!";
				}else if(fileName.toLowerCase().endsWith("xls")){  
				    stream = file.getInputStream();
					workBook = new HSSFWorkbook(stream);  
		        }else if(fileName.toLowerCase().endsWith("xlsx")){  
		            stream = file.getInputStream();
		        	workBook = new XSSFWorkbook(stream);
		        }else{  
		        	importInfo = "导入失败！失败信息：文档格式不正确!";
		        }
				stream.close();
				if(workBook != null){
					if(workBook.getNumberOfSheets()<0){
						importInfo = "导入失败！失败信息：文档中没有工作表!";
					}else{
						importInfo = importDataService.importBase(workBook, dicId);
						model.addAttribute("message", importInfo);
						return "modules/comm/importResult";
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				importInfo ="导入失败！请认真检查一次，是否符合数据标准，再做导入，如果不行，请您重新下载模版重新填写数据，再进行导入！";
				importDataService.saveImportResult(null, importInfo, importDataService.IMPORT_FAIL, dicId);
				model.addAttribute("message", importInfo);
				return "modules/comm/importResult";
			}
		}
		importDataService.saveImportResult(null, importInfo, importDataService.IMPORT_FAIL, dicId);
		model.addAttribute("message", importInfo);
		return "modules/comm/importResult";
	}
	
	/**
	 * 
	 * <p>Discription:[导入结果历史查看]</p>
	 * @param formbean
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	@RequestMapping(value = "history")
    public String list(FormBean formbean,HttpServletRequest request, HttpServletResponse response, Model model)
            throws Exception {
        Page<Map<String, Object>> page = importDataService.listHistory(
                new Page<Map<String, Object>>(request, response), formbean);
        model.addAttribute("map", formbean);
        model.addAttribute("page", page);
        return "modules/comm/importHistoryList";
    }
}
