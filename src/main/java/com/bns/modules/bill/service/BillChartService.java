package com.bns.modules.bill.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bns.modules.bill.dao.ReportDao;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.service.BaseService;

@Service
public class BillChartService extends BaseService{
    
    @Autowired
    private  ReportDao reportDao;
    
    /**
     * 
     * <p>Discription:[统计图表月统计数据获取]</p>
     * @param bean
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public Map<String, Object> monthTotalData(Map<String, Object> bean){
        Map<String, Object> data = Maps.newHashMap();
        bean.put("DESC", " ");
        List<Map<String, Object>> monthList = reportDao.monthTotalList(bean);
        int length = monthList.size();
        double yEndValue = 0.0;
        String[] xData = new String[length];
        double[] yIncomeData = new double[length];
        double[] yOutData = new double[length];
        double[] ySubData = new double[length];
        for(int i=0; i<length; i++){
            xData[i] = MapUtils.getString(monthList.get(i), "MONTH");
            yIncomeData[i] = MapUtils.getDouble(monthList.get(i), "INCOME");
            yOutData[i] = MapUtils.getDouble(monthList.get(i), "OUTCOST");
            ySubData[i] = MapUtils.getDouble(monthList.get(i), "TOTAL");
            if(yIncomeData[i] > yEndValue)yEndValue = yIncomeData[i];
            if(yOutData[i] > yEndValue)yEndValue = yOutData[i];
        }
        data.put("xData", xData);
        //设置默认显示最近一年的数据
        if(length > 0){
            data.put("xStartValue", length>12?xData[length-12]:xData[0]);
            data.put("xEndValue", xData[length-1]);
        }else{
            data.put("xStartValue", null);
            data.put("xEndValue", null);
        }
        data.put("yEndValue", yEndValue);
        data.put("yIncomeData", yIncomeData);
        data.put("yOutData", yOutData);
        data.put("ySubData", ySubData);
        return data;
    }

}
