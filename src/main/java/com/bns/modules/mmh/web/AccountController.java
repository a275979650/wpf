package com.bns.modules.mmh.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bns.modules.mmh.service.AccountService;
import com.bns.utils.FormBean;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;

/**
 * 
 * <p>Description: [站点登录信息控制类]</p>
 * Created on 2016年11月20日
 * @author  <a href="mailto: zkai163m@163.com">朱凯</a>
 * @version 1.0 
 * Copyright (c) 2016 朱凯
 */
@Controller
@RequestMapping(value = "${adminPath}/mmh/account")
public class AccountController extends BaseController{
    
    @Autowired
    private AccountService accountService; 
    
    @RequestMapping(value = "list")
    public String list(String siteId, FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        if(StringUtils.isNotBlank(siteId)){
            if(formbean==null)formbean = new FormBean();
            formbean.getBean().put("SITE_ID", siteId);
        }
        model.addAttribute("accountList", accountService.list(formbean));
        model.addAttribute("map", formbean);
        return "modules/mmh/accountList";
    }
    
    @RequestMapping(value = "form")
    public String form(String siteId, HttpServletRequest request, HttpServletResponse response,
            Model model, String id){
        
        Map<String, Object> bean = Maps.newHashMap();
        if(StringUtils.isNotBlank(id)){
            bean = accountService.get(id);
        }else{
            bean.put("SITE_ID", siteId);
        }
        model.addAttribute("bean", new FormBean(bean));
        return "modules/mmh/accountForm";
    }
    
    @RequestMapping(value = "save")
    public String save(FormBean formbean, HttpServletRequest request, HttpServletResponse response,
            Model model,RedirectAttributes redirectAttributes){
        accountService.save(formbean.getBean());
        addMessage(redirectAttributes, "保存成功");
        return "redirect:" + Global.getAdminPath() + "/mmh/account/list?siteId="
            + MapUtils.getString(formbean.getBean(), "SITE_ID");
    }
    
    @ResponseBody
    @RequestMapping(value = "delete")
    public String delete(String deleteId) {
        String message = "";
        if(StringUtils.isNotBlank(deleteId)){
            accountService.delete(deleteId);
            message = Global.CONTROLLER_RETURN_SUCCESS;
        }else{
            message = "参数错误!";
        }
        return message;
    }
    
    @ResponseBody
    @RequestMapping(value = "getInfo")
    public String getInfo(String id) {
        String message = "";
        if(StringUtils.isNotBlank(id))
            message = accountService.getPwd(id);
        return message;
    }

}
