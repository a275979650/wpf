package com.thinkgem.jeesite.modules.sys.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.modules.sys.dao.SysempSelectDAO;

/**
 *  单位管理Service
 *	@author wenz
 *	@date 2015-08-20
 *
 */
@Component
@Transactional(readOnly = true)
public class SysempSelectService extends BaseService {
	
	@Autowired
	private SysempSelectDAO sysempSelectDAO;
	
	/**
	 * 查询 
	 * 人员
	 * 列表
	 * 
	 */
	public Page<Map<String, Object>> listEmployee(Page<Map<String, Object>> page,
			FormBean formbean) {
		PaginationMap map =(PaginationMap) formbean.getBean();
		map.setPage(page);
		page.setList(sysempSelectDAO.listEmployee(map));
		return page;
	}
	
	
	
}