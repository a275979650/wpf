package com.bns.modules.bill.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface BillDao {
	List<Map<String, Object>> list(Map<String, Object> map);
	
	Map<String, Object> statistical(Map<String, Object> bean);
	
	Map<String, Object> get(String GUUID);

    void insert(Map<String, Object> bean);

    void update(Map<String, Object> bean);

    void delete(String numId);

}