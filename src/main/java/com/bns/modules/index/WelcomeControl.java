package com.bns.modules.index;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
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
@RequestMapping(value = "${adminPath}/index")
public class WelcomeControl extends BaseController {

    @RequestMapping(value = "welcome")
    public String list(FormBean formbean, HttpServletRequest request, 
            HttpServletResponse response, Model model) {
        model.addAttribute("ucn", UserUtils.getUser().getName());
        return "modules/index/welcome";
    }
}
