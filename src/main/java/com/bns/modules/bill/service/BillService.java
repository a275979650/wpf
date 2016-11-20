package com.bns.modules.bill.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.vfs.FileObject;
import org.apache.commons.vfs.VFS;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.bns.component.vfs.VFSManager;
import com.bns.modules.bill.dao.BillDao;
import com.bns.utils.FormBean;
import com.bns.utils.PaginationMap;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.BaseService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
/**
 * 
 * <p>Description: [账单信息业务处理类]</p>
 * Created on 2016年6月25日
 * @author  <a href="mailto: zkai163m@163.com">朱凯</a>
 * @version 1.0 
 * Copyright (c) 2016 朱凯
 */
@Service
@Transactional(readOnly = true)
public class BillService extends BaseService{
	@Autowired
	private  BillDao billDao;
	
	/**
	 * 
	 * <p>Discription:[账单列表数据获取]</p>
	 * @param page
	 * @param formbean
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public Page<Map<String, Object>> list(Page<Map<String, Object>> page, FormBean formbean) {
		PaginationMap map = (PaginationMap) formbean.getBean();
		map.setPage(page);
		List<Map<String, Object>> list = billDao.list(map);
		page.setList(list);
		return page;
	}
	/**
	 * 
	 * <p>Discription:[获取列表查询的统计信息]</p>
	 * @param bean
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public Map<String, Object> statistical(Map<String, Object> bean){
        return billDao.statistical(bean);
    }
	
	/**
	 * 
	 * <p>Discription:[根据Id获取账单信息]</p>
	 * @param numId
	 * @return
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
	public Map<String, Object> get(String numId) {
        Map<String, Object> map = billDao.get(numId);
        return map;
    }
    
	/**
	 * 
	 * <p>Discription:[账单信息保存和修改]</p>
	 * @param bean
	 * @author:[朱凯]
	 * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
	 */
    public void save(Map<String, Object> bean, MultipartFile file, String path) {
        String id = MapUtils.getString(bean, "GUUID");
        //检查图片是否需要进行更新
        String fu = MapUtils.getString(bean, "FU");
        if("1".equals(fu)){
            String oldImage = MapUtils.getString(bean, "oldImage");
            String saveName = oldImage;
            if(file!=null){
                try {
                    //删除旧文件
                    if(StringUtils.isNotBlank(oldImage)) {
                        FileObject oldFile = VFS.getManager().resolveFile(path + "\\" + oldImage);
                        if (oldFile.exists()) {
                            oldFile.delete();
                        }
                    }
                    //执行上传操作
                    FileObject baseDir = VFS.getManager().resolveFile(path);
                    FileObject files = VFSManager.upload(baseDir, file, 1024*1024*5);
                    saveName = files.getName().getBaseName();
                }catch (Exception e) {
                    e.printStackTrace();
                }
            }
            bean.put("IMAGE", saveName);
        }
        //更新保存账单信息
        if (StringUtils.isEmpty(id)) {
            bean.put("GUUID", UUID.randomUUID().toString());
            bean.put("CREATE_BY", UserUtils.getUser().getLoginName());
            bean.put("CREATE_DATE", new Date());
            billDao.insert(bean);
        } else {
            billDao.update(bean);
        }
    }
    
    /**
     * 
     * <p>Discription:[删除账单信息]</p>
     * @param numId
     * @author:[朱凯]
     * @update:[日期YYYY-MM-DD] [更改人姓名][变更描述]
     */
    public void delete(String numId) {
        billDao.delete(numId);
    }

}
