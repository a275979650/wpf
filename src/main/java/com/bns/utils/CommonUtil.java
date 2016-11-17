package com.bns.utils;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.ObjectUtils;


/** 
  * @ClassName: CommonUtil 
  * @Description: TODO[通用工具类]
  * @author heyishan from GCI
  * @since V1.0
  * @date 2014年7月24日 下午4:53:02  
  */ 

/**
 * @author yi-w
 *
 */
public class CommonUtil {
	
	private static final String PG_CACHE = "pgCache";
	
	/**
	 * java插入到xml特殊字符的转换 字符 转义后 & &amp; ' &apos; " &quot; > &gt; < &lt;
	 * 
	 * @param request
	 * @return
	 */
	public static void xmlSpecialCharConvert(Map<String, Object> map) {
		String[] charArray = new String[] { "&", "'", "\"", ">", "<" };
		String[] convertArray = new String[] { "&amp;", "&apos;", "&quot;",
				"&gt;", "&lt;" };
		Set<String> keys = map.keySet();
		for (String key : keys) {
			Object obj = map.get(key);
			if (obj != null && obj instanceof String) {
				String str = ObjectUtils.toString(obj);
				map.put(key, org.apache.commons.lang3.StringUtils.replaceEach(
						str, charArray, convertArray));
			}
		}
	}

	public static void  xmlSpecialCharConvert(List<Map<String,Object>>... lists){
		for (List<Map<String, Object>> list : lists) {
			for (Map<String, Object> map2 : list) {
				xmlSpecialCharConvert(map2);
			}
		}
	}
	public static void main(String[] args) {
		System.out.println(org.apache.commons.lang3.StringUtils.replaceEach("abcdefcba", new String[]{"a","b","f"}, new String[]{"c","iii","yyyyyyy"}));
		//org.apache.commons.lang3.StringUtils.replaceEachRepeatedly(text, searchList, replacementList)
	}

	public static String getJspNameByRequestUrl(HttpServletRequest request){

		StringBuffer url = request.getRequestURL();
		
		int indexStart = url.lastIndexOf("/")+1;
		int indexEnd = url.lastIndexOf(".");
		String jspName = url.substring(indexStart, indexEnd);
		
		return jspName;
	}
	
	public static String getValueByIndex(String[] array,int i){
		if(i>=array.length){
			return null;
		}else{
			return array[i];
		}
	}
	/**
	 * 获得服务器，操作系统
	 * 
	 * @return
	 */
	public static String osType() {
		Properties props = System.getProperties();
		return props.getProperty("os.name").toUpperCase();
	}
	
	public static BatisMap getRequestData(HttpServletRequest request){
		Map parameters = request.getParameterMap();
		Set set = parameters.keySet();
		BatisMap entity = null;
		if (set!=null&&set.size()>0) {
			entity = new BatisMap(set.size());	
		}else {
			entity = new BatisMap(1);
		}
		for (Iterator iter = set.iterator(); iter.hasNext();) {
			String key = (String) iter.next();
            String[] values = (String[])parameters.get(key);
            entity.put(key, values[0]);
		}
		return entity ;
	}
}
