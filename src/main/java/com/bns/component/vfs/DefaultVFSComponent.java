package com.bns.component.vfs;

import java.util.Iterator;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.vfs.FileSystemManager;
import org.apache.commons.vfs.cache.DefaultFilesCache;
import org.apache.commons.vfs.impl.DefaultFileSystemManager;
import org.apache.commons.vfs.impl.StandardFileSystemManager;
import org.apache.commons.vfs.provider.FileProvider;

import com.bns.component.vfs.wrap.WrappedResourceFileProvider;


public class DefaultVFSComponent implements VFSComponent{
  
  private static final Log logger = LogFactory.getLog(DefaultVFSComponent.class);
  
  protected FileSystemManager fsm;
  
  public DefaultVFSComponent(Map<String, FileProvider> providers, Map<String, String> fileSystems){
	  // 创建一个标准的文件系统管理器，该管理器将会被封装起来
    StandardFileSystemManager fsmToWrap = new StandardFileSystemManager();
    
    //初始化标准的文件系统管理器，添加特殊的FileProvider
    try{
      //文件缓存设置
      fsmToWrap.setFilesCache(new DefaultFilesCache());
      //文件系统初始化
      fsmToWrap.init();

      for (Iterator<Map.Entry<String, FileProvider>> it = providers.entrySet().iterator(); it.hasNext();) {
        Map.Entry<String, FileProvider> entry = it.next();
        String name = entry.getKey();
        FileProvider provider = entry.getValue();

        //添加FileProvider到标准的文件系统管理器中
        fsmToWrap.addProvider(name, provider);

        logger.info("VFS provider successfully registered: " + name);
      }
    } catch(Exception e){
      throw new RuntimeException(e);
    }
    
    
    // 创建对外的文件系统管理器
    DefaultFileSystemManager fsmWrapped = new DefaultFileSystemManager();
    //初始化对外的文件系统管理器
    try{
      //文件缓存设置
      fsmWrapped.setFilesCache(new DefaultFilesCache());
      //文件系统初始化
      fsmWrapped.init();

      for (Iterator<Map.Entry<String, String>> it = fileSystems.entrySet().iterator(); it.hasNext();) {
        try {
          Map.Entry<String, String> entry = it.next();
          String name = entry.getKey();
          String url = entry.getValue();

          if (StringUtils.isEmpty(name)) {
            break;
          }
          if (StringUtils.isEmpty(url)) {
            throw new RuntimeException("URL value is empty.");
          }

          // 路径注册到对外的文件系统管理器
          fsmWrapped.addProvider(name, new WrappedResourceFileProvider(fsmToWrap, url));

          logger.info("VFS resource successfully registered: " + name);
        } catch (Exception e) {
          logger.error("Error when registering a resource to VFS: " + e);
          throw e;
        }
      }
    } catch(Exception e){
      throw new RuntimeException(e);
    }
    fsm = fsmWrapped;
  }
  
  
  @Override
  public FileSystemManager getFileSystemManager() {
    return fsm;
  }

}
