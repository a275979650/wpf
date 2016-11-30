package com.bns.modules.mmh.dao;

import java.util.List;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;

@MyBatisDao
public interface AccountDao{

    List<Map<String, Object>> list(Map<String, Object> map);

    int update(Map<String, Object> bean);

    int insert(Map<String, Object> bean);

    Map<String, Object> getById(String id);

    int delete(String deleteId);

}
