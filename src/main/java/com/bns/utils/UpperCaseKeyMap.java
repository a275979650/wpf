package com.bns.utils;

import java.sql.SQLException;
import java.util.HashMap;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.druid.proxy.jdbc.ClobProxyImpl;

public class UpperCaseKeyMap<T> extends HashMap<String, T> {

	/** serialVersionUID */
	private static final long serialVersionUID = 812064927267651841L;
	private Object colbstr;

	protected String parseKey(Object key) {
		if (key == null) {
			return null;
		} else if (key instanceof String) {
			String keyStr = (String) key;
			return keyStr.toUpperCase();
		} else {
			return key.toString();
		}
	}

	@SuppressWarnings("unchecked")
	public T put(String key, T value) {
		T val = value;
		if (StringUtils.contains(value.toString(), "oracle.sql.CLOB")) {
			ClobProxyImpl clob = (ClobProxyImpl) value;
			colbstr = null;
			try {
				colbstr = (clob == null || clob.length() == 0) ? null : clob
						.getSubString((long) 1, (int) clob.length());
			} catch (SQLException e) {
				e.printStackTrace();
			}
			val = (T) colbstr;
		}
		return super.put(parseKey(key), val);
	}

	public T get(Object key) {
		return super.get(parseKey(key));
	}

	public T remove(Object key) {
		return super.remove(parseKey(key));
	}

	public boolean containsKey(Object key) {
		return super.containsKey(parseKey(key));
	}
}
