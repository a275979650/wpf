package com.bns.utils;

import java.text.ParseException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;

public class FormBeanUtils {
	/**
	 * 如果key对应的值为空，则
	 * 
	 * @param bean
	 * @param key
	 * @param value
	 */
	public static void put4null(Map<String, Object> bean, String key, Object value) {
		if (!bean.containsKey(key) || bean.get(key) == null
				|| (bean.get(key) instanceof String && StringUtils.isEmpty((String) bean.get(key)))) {
			bean.put(key, value);
		}
	}

	/**
	 * 将给定字段对应的值转换成日期
	 * 
	 * @param bean
	 * @param keys
	 */
	public static void parseDate(Map<String, Object> bean, String... keys) {
		String key1 = null;
		try {
			for (String key : keys) {
				key1 = key;
				String val = MapUtils.getString(bean, key);
				if (StringUtils.isNotEmpty(val)) {
					bean.put(key, DateUtils.parseDate(val, "yyyy-MM-dd HH:mm:ss","yyyy-MM-dd", "yyyy-MM", "yyyy"));
				}
			}
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 将yyyy-MM-dd|yyyy-MM格式字符串转换成日期类型
	 * 
	 * @param bean
	 * @param ignorKeys
	 *            忽略的字段
	 * @return
	 */
	public static Map<String, Object> parse(Map<String, Object> bean, String... ignorKeys) {
		Set<String> ignorSet = new HashSet<String>();
		if (ignorKeys != null) {
			for (String key : ignorKeys) {
				ignorSet.add(key);
			}
		}
		Pattern pattern = Pattern.compile("[0-9]{4}-[0-9]{2}(-[0-9]{2})?( [0-9]{2}:[0-9]{2}:[0-9]{2})?");
		Pattern pattern1 = Pattern.compile("[0-18]{4}-[0-18]{2}-[0-18]{2} [0-18]{2}:[0-18]{2}:[0-18]{2}");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			for (String key : bean.keySet()) {
				Object val = bean.get(key);
				if (!ignorSet.contains(key) && val != null && val instanceof String 
						&& (pattern.matcher((String) val).matches()
								|| 
							pattern1.matcher((String) val).matches()
							)) {
					val = DateUtils.parseDate((String) val, "yyyy-MM-dd HH:mm:ss","yyyy-MM-dd", "yyyy-MM");
				}
				result.put(key, val);
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return result;
	}
}
