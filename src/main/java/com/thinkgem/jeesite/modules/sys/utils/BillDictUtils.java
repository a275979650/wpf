package com.thinkgem.jeesite.modules.sys.utils;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;

import com.thinkgem.jeesite.common.utils.CacheUtils;
import com.thinkgem.jeesite.common.utils.SpringContextHolder;
import com.thinkgem.jeesite.modules.sys.dao.DictDao;

public class BillDictUtils{
    
    private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);
    
    //账单类型缓存
    public static final String CACHE_BILL_LABEL_LIST = "billLabelList";
    
    
    @SuppressWarnings("unchecked")
    public static List<Map<String,Object>> getBillLabelList() {
        String cacheKey = CACHE_BILL_LABEL_LIST;
        List<Map<String,Object>> labelList = (List<Map<String,Object>>)CacheUtils.get(cacheKey);//getCache(cacheKey);
        if (labelList == null) {
            labelList = dictDao.findBillLabelList();
            CacheUtils.put(cacheKey, labelList);
        }
        return labelList;
    }
    
  //账单类型解码。
    public static  List<Map<String, Object>>  getLabelAll(){
        return getBillLabelList();
    }
    public static String getBillLabelBySeparator(String value,String separator, String defaultValue){
        StringBuffer label = new StringBuffer(100);
        if (StringUtils.isNotBlank(value)){
            String[] values = StringUtils.split(value,(StringUtils.isEmpty(separator)?",":separator));
            List<Map<String, Object>> bl = getLabelAll();
            for (String val : values) {
                for (Map<String, Object> dict : bl){
                    if (StringUtils.equals(MapUtils.getString(dict, "ID"), val)){
                        label.append(MapUtils.getString(dict, "NAME")).append(",");
                        break;
                    }
                }
            }
        }
        if (label.length()>0) {
            label.deleteCharAt(label.length()-1);
        }
        return (label.toString().length() > 0 ? label.toString() : defaultValue);
    }

}
