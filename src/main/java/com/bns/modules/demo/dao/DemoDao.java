package com.bns.modules.demo.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface DemoDao {
	List<Map<String, Object>> list(Map<String, Object> map);
	
}
