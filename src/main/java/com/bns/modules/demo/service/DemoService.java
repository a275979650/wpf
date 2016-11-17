package com.bns.modules.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bns.modules.demo.dao.DemoDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
@Service
@Transactional(readOnly = true)
public class DemoService extends BaseService{
	@Autowired
	private  DemoDao demoDao;
	
	public Page<Map<String, Object>> list(Page<Map<String, Object>> page, FormBean formbean) {
		PaginationMap map = (PaginationMap) formbean.getBean();
		map.setPage(page);
		List<Map<String, Object>> list = demoDao.list(map);
		page.setList(list);
		return page;
	}
	
	
	public List<Map<String, Object>> getList(Map<String, Object> map) {
		List<Map<String, Object>> list = demoDao.list(map);
		return list;
	}
}
