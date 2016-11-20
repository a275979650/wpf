package com.bns.modules.bill.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.bill.service.RedLineService;
import com.bns.utils.FormBean;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

@Controller
@RequestMapping(value = "${adminPath}/bill/redline")
public class RedLineControl extends BaseController {

    @Autowired
    private RedLineService redLineService;

    @RequestMapping(value = { "list", "" })
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
    	Page<Map<String, Object>> page = 
    	        redLineService.list(new Page<Map<String, Object>>(request, response), formbean);
    	model.addAttribute("page", page);
    	model.addAttribute("map", formbean);
    	return "modules/bill/redLineList";
    }
    
    @RequestMapping(value = "form")
    public String form(HttpServletRequest request, HttpServletResponse response,Model model,
            String numId){
        
        Map<String, Object> bean = Maps.newHashMap();
            bean = redLineService.get(numId);
        model.addAttribute("bean", new FormBean(bean));
        return "modules/bill/redLineForm";
    }
    
    @RequestMapping(value = "save")
    public String save(FormBean formbean, HttpServletRequest request, HttpServletResponse response,
            Model model,RedirectAttributes redirectAttributes){
        
        redLineService.save(formbean.getBean());
        addMessage(redirectAttributes, "保存成功");
        return "redirect:" + Global.getAdminPath() + "/bill/redline/list";
    }
    
    @RequestMapping(value = "delete")
    public String delete(FormBean formbean, HttpServletRequest request,HttpServletResponse response,String numId, Model model) {
        if(StringUtils.isNotBlank(numId)){
            redLineService.delete(numId);
            model.addAttribute("message", "删除成功");
        }else{
            model.addAttribute("message", "参数错误");
        }
        Page<Map<String, Object>> page = redLineService.list(
                new Page<Map<String, Object>>(request, response), formbean);//可扩展做查询
        model.addAttribute("page", page);
        model.addAttribute("map", formbean);
        return "modules/bill/redLineList";
    }
    

}
