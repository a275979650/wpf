package com.bns.component.vfs;

import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.vfs.FileSystemManager;
import org.apache.commons.vfs.cache.DefaultFilesCache;
import org.apache.commons.vfs.impl.DefaultFileSystemManager;
import org.apache.commons.vfs.impl.StandardFileSystemManager;
import org.apache.commons.vfs.provider.FileProvider;

import com.bns.component.vfs.wrap.WrappedResourceFileProvider;


/**
 * 虚拟文件系统构件工厂实现
 */
public class DefaultVFSFactory implements VFSFactory{
  
  private Log logger = LogFactory.getLog(DefaultVFSFactory.class);
  
  protected StandardFileSystemManager fsmToWrap;
  
  protected DefaultFileSystemManager fsm;

  /**
   * {@inheritDoc}
   */
  public void init(Properties prop) {
    // 创建一个标准的文件系统管理器，该管理器将会被封装起来
    fsmToWrap = new StandardFileSystemManager();

    if(prop == null)return;
    
    //初始化标准的文件系统管理器，添加特殊的FileProvider
    try{
      //文件缓存设置
      fsmToWrap.setFilesCache(new DefaultFilesCache());
      //文件系统初始化
      fsmToWrap.init();

      for (int i = 0;; i++) {
        String name = prop.getProperty("internalProvider." + i + ".name");
        String clazz = prop.getProperty("internalProvider." + i + ".class");

        if(name == null || name.length() == 0){
          break;
        }
        
        if(clazz == null || clazz.length() == 0){
          throw new RuntimeException("InternalProvider class is null.");
        }
        
        //创建FileProvider
        FileProvider provider = (FileProvider)Class.forName(clazz).newInstance();
        
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
      
      for (int i = 0;; i++) {
        try {
          // 读取设置
          String name = prop.getProperty("fileSystem." + i + ".name");
          String url = prop.getProperty("fileSystem." + i + ".url");

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

  /**
   * {@inheritDoc}
   */
  @Override
  public void destroy() {
    fsm = null;
  }

  /**
   * {@inheritDoc}
   */
  @Override
  public FileSystemManager getFileSystemManager() {
    return fsm;
  }

  @Override
  public void addProvider(String name, String url){
	try {
		// 路径注册到对外的文件系统管理器
		fsm.addProvider(name, new WrappedResourceFileProvider(fsmToWrap, url));
	} catch (Exception e) {
		throw new RuntimeException(e);
	}
  }
  
  public void upload(){
	 
  }
}

