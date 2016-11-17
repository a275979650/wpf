package com.bns.utils;

import java.util.HashMap;
import java.util.Map;

import com.thinkgem.jeesite.common.persistence.Page;

public class PaginationMap extends  HashMap<String, Object>{
	
	private static final long serialVersionUID = -6604162875842642063L;
	
	protected Page<Map<String, Object>> page;

	public Page<Map<String, Object>> getPage() {
		return page;
	}

	public void setPage(Page<Map<String, Object>> page) {
		this.page = page;
	}
}
