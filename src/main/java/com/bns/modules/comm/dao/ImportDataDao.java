package com.bns.modules.comm.dao;

import java.util.List;
import java.util.Map;

import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface ImportDataDao {
    /**
     * 
     * <p>Discription:[导入表配置信息]</p>
     * @param dicId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    Map<String, Object> getTableInfo(String dicId);
    
    /**
     * 
     * <p>Discription:[导入配置字段信息（必填字段:返回逗号相隔字符串）]</p>
     * @param dicId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    Map<String, Object> getRequiredFieldString(String dicId);
    
    /**
     * 
     * <p>Discription:[导入配置字段信息（所有字段）]</p>
     * @param dicId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
	List<Map<String, Object>> listFieldInfo(String dicId);
	
	/**
     * 
     * <p>Discription:[导入配置字段信息（必填字段）]</p>
     * @param dicId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    List<Map<String, Object>> getRequiredField(String dicId);

	/**
	 * 
	 * <p>Discription:[模板下载查询用户已选字段信息]</p>
	 * @param para
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	List<Map<String, Object>> getTemplateFieldList(Map<String, Object> para);

	/**
	 * 
	 * <p>Discription:[读取导入文件的表头获取数据库对应字段信息]</p>
	 * @param para
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	Map<String, Object> findFieldByCHName(Map<String, Object> para);

	List<Map<String, Object>> getEntity(Map<String, Object> uqmap);
	
    void insertImportBatch(List<Map<String, Object>> insertList);

    void updateImportBatch(List<Map<String, Object>> updateList);
    
    /**
     * 
     * <p>Discription:[导入结果信息保存]</p>
     * @param map
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    void insertImportResult(Map<String, Object> map);

    /**
     * 
     * <p>Discription:[导入结果历史查询]</p>
     * @param map
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    List<Map<String, Object>> listHistory(PaginationMap map);

}
