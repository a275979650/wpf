package com.bns.modules.mmh.dao;

import java.util.List;
import java.util.Map;

import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface MmhSiteDao{

    List<Map<String, Object>> list(PaginationMap map);

    int update(Map<String, Object> bean);

    int insert(Map<String, Object> bean);

    Map<String, Object> getById(String id);

    int delete(String deleteId);

}
