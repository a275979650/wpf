package com.bns.component.vfs;

import java.util.Properties;

import org.apache.commons.vfs.FileSystemManager;

/**
 * 虚拟文件系统构件工厂接口
 */
public interface VFSFactory {

  /**
   * 初始化对象
   */
  void init(Properties prop);

  /**
   * 关闭对象
   */
  public void destroy();
  
  /**
   * 获取FileSystemManager实例
   */
  FileSystemManager getFileSystemManager();
  
  /**
   * 注册一个路径，
   * 如注册引用名为xxx，封装路径为c:\aaa\bbb\，
   * 那么读取文件xxx://ccc.txt时，真正访问的是c:\aaa\bbb\ccc.txt
   * @param name 路径的引用名
   * @param url 引用名所封装的路径
   */
  void addProvider(String name, String url);
}