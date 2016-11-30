package com.bns.modules.mmh.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.mmh.service.MmhSiteService;
import com.bns.utils.FormBean;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 
 * <p>Description: [站点信息控制类]</p>
 * Created on 2016年11月20日
 * @author  <a href="mailto: zkai163m@163.com">朱凯</a>
 * @version 1.0 
 * Copyright (c) 2016 朱凯
 */
@Controller
@RequestMapping(value = "${adminPath}/mmh/site")
public class MmhSiteController extends BaseController{
    
    @Autowired
    private MmhSiteService siteService; 
    
    @RequestMapping(value = "list")
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        Page<Map<String, Object>> page = 
                siteService.list(new Page<Map<String, Object>>(request, response), formbean);
        model.addAttribute("page", page);
        model.addAttribute("map", formbean);
        return "modules/mmh/siteList";
    }
    
    @RequestMapping(value = "form")
    public String form(HttpServletRequest request, HttpServletResponse response,Model model,
            String id){
        
        Map<String, Object> bean = Maps.newHashMap();
        if(StringUtils.isNotBlank(id)){
            bean = siteService.get(id);
        }
        model.addAttribute("bean", new FormBean(bean));
        return "modules/mmh/siteForm";
    }
    
    @RequestMapping(value = "save")
    public String save(FormBean formbean, HttpServletRequest request, HttpServletResponse response,
            Model model,RedirectAttributes redirectAttributes){
        siteService.save(formbean.getBean());
        addMessage(redirectAttributes, "保存成功");
        return "redirect:" + Global.getAdminPath() + "/mmh/site/list";
    }
    
    @ResponseBody
    @RequestMapping(value = "delete")
    public String delete(String deleteId) {
        String message = "";
        if(StringUtils.isNotBlank(deleteId)){
            siteService.delete(deleteId);
            message = Global.CONTROLLER_RETURN_SUCCESS;
        }else{
            message = "参数错误!";
        }
        return message;
    }

}
