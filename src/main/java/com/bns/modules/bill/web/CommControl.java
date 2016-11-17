package com.bns.modules.bill.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bns.modules.bill.service.CommService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.web.BaseController;

@Controller
@RequestMapping(value = "${adminPath}/bill/comm")
public class CommControl extends BaseController {

    @Autowired
    private CommService commService;
    
    @RequiresUser
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
        response.setContentType("application/json; charset=UTF-8");
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<Map<String, Object>> list = commService.getLabelTreeData(extId);
        for (int i=0; i<list.size(); i++){
            Map<String, Object> e = list.get(i);
            Map<String, Object> map = Maps.newHashMap();
            map.put("id", MapUtils.getString(e, "ID"));
            map.put("pId", MapUtils.getString(e, "PID"));
            map.put("name", MapUtils.getString(e, "NAME"));
            mapList.add(map);
        }
        return mapList;
    }
}
