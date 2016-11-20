package com.bns.modules.bill.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.bill.service.BillService;
import com.bns.utils.FormBean;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/bill")
public class BillControl extends BaseController {

    @Autowired
    private BillService billService;

    /**
     * 
     * <p>Discription:[账单信息列表页面及数据获取]</p>
     * @param formbean
     * @param request
     * @param response
     * @param model
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = { "list", "" })
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        Map<String, Object> st3 = billService.statistical(formbean.getBean());
    	Page<Map<String, Object>> page = 
    	        billService.list(new Page<Map<String, Object>>(request, response), formbean);
    	model.addAttribute("page", page);
    	model.addAttribute("map", formbean);
    	model.addAttribute("st3", st3);
    	return "modules/bill/billList";
    }
    
    /**
     * 
     * <p>Discription:[账单信息表单页面（新增|修改）]</p>
     * @param request
     * @param response
     * @param model
     * @param numId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = "form")
    public String form(HttpServletRequest request, HttpServletResponse response,Model model,
            String numId){
        
        Map<String, Object> bean = Maps.newHashMap();
        if(StringUtils.isNotBlank(numId)){
            bean = billService.get(numId);
        }else{
            bean.put("BLONG", UserUtils.getUser().getLoginName());
            bean.put("BLONG_NAME", UserUtils.getUser().getName());
        }
        model.addAttribute("bean", new FormBean(bean));
        return "modules/bill/billForm";
    }
    
    /**
     * <p>Discription:[账单查看信息页面]</p>
     * @param request
     * @param response
     * @param model
     * @param numId
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    @RequestMapping(value = "view")
    public String view(HttpServletRequest request, HttpServletResponse response,Model model,
            String numId){
        Map<String, Object> bean = billService.get(numId);
        model.addAttribute("bean", bean);
        return "modules/bill/billDetail";
    }
    
    @RequestMapping(value = "save")
    public String save(FormBean formbean, HttpServletRequest request, HttpServletResponse response,
            Model model,RedirectAttributes redirectAttributes,@RequestParam(value = "file") MultipartFile file){
        String path = request.getSession().getServletContext().getRealPath("/static/images/billImage");
        billService.save(formbean.getBean(), file, path);
        addMessage(redirectAttributes, "保存成功");
        return "redirect:" + Global.getAdminPath() + "/bill/list";
    }
    
    @RequestMapping(value = "delete")
    public String delete(FormBean formbean, HttpServletRequest request,HttpServletResponse response,String numId, Model model) {
        if(StringUtils.isNotBlank(numId)){
            billService.delete(numId);
            model.addAttribute("message", "删除成功");
        }else{
            model.addAttribute("message", "参数错误");
        }
        Page<Map<String, Object>> page = billService.list(
                new Page<Map<String, Object>>(request, response), formbean);//可扩展做查询
        model.addAttribute("page", page);
        model.addAttribute("map", formbean);
        return "modules/bill/billList";
    }
    

}
