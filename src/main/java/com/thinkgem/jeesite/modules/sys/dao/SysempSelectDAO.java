package com.thinkgem.jeesite.modules.sys.dao;

import java.util.List;
import java.util.Map;

import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface SysempSelectDAO {
	
	List<Map<String, Object>> listEmployee(PaginationMap map);

}
