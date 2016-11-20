package com.bns.modules.bill.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bns.modules.bill.dao.RedLineDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
@Service
@Transactional(readOnly = true)
public class RedLineService extends BaseService{
	@Autowired
	private  RedLineDao redLineDao;
	
	public Page<Map<String, Object>> list(Page<Map<String, Object>> page, FormBean formbean) {
		PaginationMap map = (PaginationMap) formbean.getBean();
		map.setPage(page);
		List<Map<String, Object>> list = redLineDao.list(map);
		page.setList(list);
		return page;
	}
	
	public Map<String, Object> get(String numId) {
        Map<String, Object> map = redLineDao.get(numId);
        return map;
    }
    
    public void save(Map<String, Object> bean) {
        String id = MapUtils.getString(bean, "GUUID");
        if (StringUtils.isEmpty(id)) {
            bean.put("GUUID", UUID.randomUUID().toString());
            redLineDao.insert(bean);
        } else {
            redLineDao.update(bean);
        }
    }
    
    public void delete(String numId) {
        redLineDao.delete(numId);
    }
}
