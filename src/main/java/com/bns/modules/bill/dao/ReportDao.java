package com.bns.modules.bill.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface ReportDao {
    
	List<Map<String, Object>> monthTotalList(Map<String, Object> map);

    List<Map<String, Object>> monthLabelTotal(Map<String, Object> map);

    Map<String, Object> statistical(Map<String, Object> bean);
}
