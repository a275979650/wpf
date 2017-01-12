package com.bns.modules.bill.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bns.modules.bill.service.BillChartService;
import com.bns.utils.FormBean;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/bill/chart")
public class BillChartControl extends BaseController {

    @Autowired
    private BillChartService billChartService;

    /**
     * 
     * <p>Discription:[统计图表分析首页]</p>
     * @param formbean
     * @param request
     * @param response
     * @param model
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = "index")
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        //查询条件初始化赋值，查询登录者下参与统计数据
        formbean.getBean().put("BLONG", UserUtils.getUser().getLoginName());
        formbean.getBean().put("BLONG_NAME", UserUtils.getUser().getName());
        model.addAttribute("map", formbean);
    	return "modules/bill/billChartTotal";
    }
    
    @ResponseBody
    @RequestMapping(value = "monthTotalData")
    public Map<String, Object> delete(FormBean formBean, HttpServletRequest request,HttpServletResponse response,Model model) {
        return billChartService.monthTotalData(formBean.getBean());
    }
    

}
