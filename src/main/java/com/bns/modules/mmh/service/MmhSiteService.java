package com.bns.modules.mmh.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bns.modules.mmh.dao.MmhSiteDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Service
public class MmhSiteService extends BaseService{

    @Autowired
    private MmhSiteDao siteDao;
    /**
     * 
     * <p>Discription:[站点分页数据获取]</p>
     * @param page
     * @param formbean
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public Page<Map<String, Object>> list(Page<Map<String, Object>> page,
            FormBean formbean){
        PaginationMap map = (PaginationMap) formbean.getBean();
        map.setPage(page);
        List<Map<String, Object>> list = siteDao.list(map);
        page.setList(list);
        return page;
    }

    /**
     * 
     * <p>Discription:[站点信息保存,添加操作人信息]</p>
     * @param bean
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public int save(Map<String, Object> bean){
        if(StringUtils.isNotBlank(MapUtils.getString(bean, "ID"))){
            bean.put("CZR", UserUtils.getUser().getNo());
            return siteDao.update(bean);
        }else{
            bean.put("ID", UUID.randomUUID().toString());
            bean.put("CREATOR", UserUtils.getUser().getNo());
            return siteDao.insert(bean);
        }
    }

    /**
     * 
     * <p>Discription:[通过id获取站点信息]</p>
     * @param id
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public Map<String, Object> get(String id){
        return siteDao.getById(id);
    }

    /**
     * 
     * <p>Discription:[通过id删除站点信息，多记录删除使用逗号进行id分隔，删除需检查是否还有关联数据]</p>
     * @param deleteId
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public int delete(String deleteId){
        return siteDao.delete(deleteId);
    }

}
