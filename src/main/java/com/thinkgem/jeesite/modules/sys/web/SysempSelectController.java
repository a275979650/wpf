package com.thinkgem.jeesite.modules.sys.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bns.utils.FormBean;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.service.SysempSelectService;

@Controller
@RequestMapping(value = "${adminPath}/sys/empSelect")
public class SysempSelectController extends BaseController {

	@Autowired
	private SysempSelectService sysempSelectService;
	
	@RequestMapping(value = "listEmployee")
	public String listEmployee(FormBean formbean,String checked ,String sortValue,
			HttpServletRequest request, HttpServletResponse response, Model model){
		if(StringUtils.isNotEmpty(sortValue)){
			formbean.getBean().put("SORTVALUE", sortValue);
		}
		Page<Map<String, Object>> page = null;
		page = sysempSelectService.listEmployee(new Page<Map<String, Object>>(request,response), formbean);
		if(StringUtils.isNotEmpty(sortValue)){
			for(int i=0;i<page.getList().size();i++){
				if(MapUtils.getString(page.getList().get(i), "EMPLOYEE_ID").equals(sortValue))
					page.getList().get(i).put("CH", "1");
				
			}
		}
		model.addAttribute("page", page);
		model.addAttribute("checked", checked); // 是否可复选
		model.addAttribute("value", sortValue); // 选择值  排最前 
		model.addAttribute("map", formbean);
		return "modules/sys/tagEmployeeselect";
	}
	
}