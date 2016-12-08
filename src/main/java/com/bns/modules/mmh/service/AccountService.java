package com.bns.modules.mmh.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bns.modules.mmh.dao.AccountDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.security.Digests;
import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.common.utils.Encodes;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Service
public class AccountService extends BaseService{

    public static final int SALT_SIZE = 8;
    
    @Autowired
    private AccountDao accountDao;
    /**
     * 
     * <p>Discription:[站点登录分页数据获取]</p>
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
        List<Map<String, Object>> list = accountDao.list(map);
        page.setList(list);
        return page;
    }
    
    /**
     * 
     * <p>Discription:[站点登录不分页数据获取]</p>
     * @param formbean
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public Object list(FormBean formbean){
        return accountDao.list(formbean.getBean());
    }

    /**
     * 
     * <p>Discription:[站点登录信息保存,添加操作人信息]</p>
     * @param bean
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public int save(Map<String, Object> bean){
        //进行加密处理
        String pwd = MapUtils.getString(bean,"PWD");
        if(StringUtils.isNotBlank(pwd))bean.put("PWD", entryptPassword(pwd));
        if(StringUtils.isNotBlank(MapUtils.getString(bean, "ID"))){
            bean.put("CZR", UserUtils.getUser().getNo());
            return accountDao.update(bean);
        }else{
            bean.put("ID", UUID.randomUUID().toString());
            bean.put("CREATOR", UserUtils.getUser().getNo());
            return accountDao.insert(bean);
        }
    }
    

    /**
     * 
     * <p>Discription:[通过id获取站点登录信息]</p>
     * @param id
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public Map<String, Object> get(String id){
        return accountDao.getById(id);
    }

    /**
     * 
     * <p>Discription:[通过id删除站点登录信息]</p>
     * @param deleteId
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public int delete(String deleteId){
        return accountDao.delete(deleteId);
    }

    /**
     * 
     * <p>Discription:[根据id获取密码信息]</p>
     * @param id
     * @return
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public String getPwd(String id){
        String pwd = accountDao.getPwd(id);
        if(pwd!=null && pwd.length()>16){
            pwd = pwd.substring(16);
            return Encodes.decodeBase64String(pwd);
        }else{
            return "";
        }
        
    }

    private String entryptPassword(String pwd){
        byte[] salt = Digests.generateSalt(SALT_SIZE);
        return Encodes.encodeHex(salt)+Encodes.encodeBase64(pwd);
    }

}
