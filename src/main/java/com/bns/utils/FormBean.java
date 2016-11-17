package com.bns.utils;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.BaseEntity;

public class FormBean extends BaseEntity<FormBean>{
	private static final long serialVersionUID = -6948393725334646497L;
	
	//单条记录
	private Map<String,Object> bean = new PaginationMap();
	//多条记录
	private List<Map<String,Object>> list = Lists.newArrayList();
	public List<Map<String, Object>> getList() {
		return list;
	}

	public void setList(List<Map<String, Object>> list) {
		this.list = list;
	}

	public FormBean() {
	}
	
	public FormBean(Map<String, Object> bean) {
		this.bean = bean;
	}

	public Map<String, Object> getBean() {
	
		return bean;
	}

	public void setBean(Map<String, Object> bean) {
		this.bean = bean;
	}

    @Override
    public void preInsert()
    {
    }

    @Override
    public void preUpdate()
    {
    }  
}
