package com.bns.modules.bill.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bns.modules.bill.dao.ReportDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
@Service
@Transactional(readOnly = true)
public class ReportService extends BaseService{
	@Autowired
	private  ReportDao reportDao;
	
	public Page<Map<String, Object>> monthTotalList(Page<Map<String, Object>> page, FormBean formbean) {
		PaginationMap map = (PaginationMap) formbean.getBean();
		map.setPage(page);
		List<Map<String, Object>> list = reportDao.monthTotalList(map);
		page.setList(list);
		return page;
	}
	/**
	 * 
	 * <p>Discription:[月账单的统计信息，总值、平均值]</p>
	 * @param bean
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public Map<String, Object> statistical(Map<String, Object> bean){
        return reportDao.statistical(bean);
    }

    public List<Map<String, Object>> monthLabelTotal(Map<String, Object> bean){
        return reportDao.monthLabelTotal(bean);
    }

	
}
