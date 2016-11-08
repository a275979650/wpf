package com.bns.utils;

import java.util.HashMap;

/**
 * 为了解决参数有时候大写有时候小写的问题，特意创建了这个类<br>
 * 如果key是字符串，则统一把key都换成小写字符串存入，获取数据的时候忽略key的大小写
 */
public class LowerCaseKeyMap<T> extends HashMap<String, T> {

	/** serialVersionUID */
	private static final long serialVersionUID = 812064927267651841L;

	/**
	 * 统一把key都换成小写字符串存入
	 */
	protected String parseKey(Object key) {
		if (key == null) {
			return null;
		} else if (key instanceof String) {
			String keyStr = (String) key;
			return keyStr.toLowerCase();
		} else {
			return key.toString();
		}
	}

	public T put(String key, T value) {
		return super.put(parseKey(key), value);
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
