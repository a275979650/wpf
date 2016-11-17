package com.bns.modules.demo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.demo.service.DemoService;
import com.bns.utils.FormBean;
import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.excel.ExportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

@Controller
@RequestMapping(value = "${adminPath}/demo")
public class DemoControl extends BaseController {

    @Autowired
    private DemoService demoServiceService;

    @RequestMapping(value = { "list", "" })
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
    	Page<Map<String, Object>> page = 
    	        demoServiceService.list(new Page<Map<String, Object>>(request, response), formbean);
    	model.addAttribute("page", page);
    	model.addAttribute("map", formbean);
    	return "modules/demo/demoList";
    }
    
    /**
     * 导出
     * @param formbean
     * @param request
     * @param response
     * @param redirectAttributes
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "export")
    public String exportRoster(FormBean formbean,String APPLY_IDS,HttpServletRequest request, 
            HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception{
    	String fileName = "";
    	String templeteName = "";
        fileName = "基本信息"+ ".xlsx";
        templeteName = "base.xlsx";
        String[] coName  =  new String[]{
    			"NAME","SID","ID_CODE","DEPT_NAME","STATUS_NAME","STAFF_SORT_NAME","POST_NAME",
    			"WORK_DATE","INSCHOOL_DATE","HIGH_SCH","MOBILE_PHONE","EMAIL" };   
        List<Map<String, Object>> list1 = demoServiceService.getList(formbean.getBean());
        for(Map<String, Object> map : list1){
            map.put("STATUS_NAME", DictUtils.getDictLabel(
                    MapUtils.getString(map, "STATUS"), "HR_STF_STATUS", ""));
            map.put("STAFF_SORT_NAME",DictUtils.getDictLabel(
                    MapUtils.getString(map, "STAFF_SORT"), "HR_SUSTC_STAFF_SORT", ""));
            map.put("DEPT_NAME",DictUtils.getOfficeLabelBySeparator(
                    MapUtils.getString(map, "DEPT_ID"), "", ""));
        }
    	try{
    		List<String> list = Lists.newArrayList();
    		ExportExcel exportExcel = new ExportExcel(null, list,"org",templeteName);
    		//设置开始写入行索引
    		exportExcel.setRownum(2);
    		exportExcel.setDataList(list1,coName).write(response, fileName).dispose();
    	}catch(Exception e){
    		addMessage(redirectAttributes, "导出失败！失败信息：" + e.getMessage());
    	}
    	return null;
    }

}
