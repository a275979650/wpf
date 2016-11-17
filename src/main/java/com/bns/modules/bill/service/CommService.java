package com.bns.modules.bill.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.modules.sys.utils.BillDictUtils;

@Service
@Transactional(readOnly = true)
public class CommService extends BaseService{

    public List<Map<String, Object>> getLabelTreeData(String extId){
        return BillDictUtils.getBillLabelList();
    }
	
}
