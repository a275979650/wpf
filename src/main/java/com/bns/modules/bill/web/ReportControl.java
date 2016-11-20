package com.bns.modules.bill.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bns.modules.bill.service.BillService;
import com.bns.modules.bill.service.ReportService;
import com.bns.utils.FormBean;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;

@Controller
@RequestMapping(value = "${adminPath}/report")
public class ReportControl extends BaseController {

    @Autowired
    private ReportService reportService;
    
    @Autowired
    private BillService billService;

    /**
     * 
     * <p>Discription:[月账单统计列表]</p>
     * @param formbean
     * @param request
     * @param response
     * @param model
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = "monthTotal")
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        Map<String, Object> st3 = reportService.statistical(formbean.getBean());
    	Page<Map<String, Object>> page = 
    	        reportService.monthTotalList(new Page<Map<String, Object>>(request, response), formbean);
    	model.addAttribute("page", page);
    	model.addAttribute("map", formbean);
    	model.addAttribute("st3", st3);
    	return "modules/bill/monthTotal";
    }
    
    /**
     * 
     * <p>Discription:[月账单中的详细]</p>
     * @param formbean
     * @param request
     * @param response
     * @param model
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = "monthDetail")
    public String monthDetail(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        List<Map<String, Object>> labelTotal = reportService.monthLabelTotal(formbean.getBean());
        Map<String, Object> st3 = billService.statistical(formbean.getBean());
        Page<Map<String, Object>> page = 
                billService.list(new Page<Map<String, Object>>(request, response), formbean);
        model.addAttribute("page", page);
        model.addAttribute("map", formbean);
        model.addAttribute("labelTotal", labelTotal);
        model.addAttribute("st3", st3);
        return "modules/bill/monthDetail";
    }
    
}
