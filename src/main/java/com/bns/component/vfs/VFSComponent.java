package com.bns.component.vfs;

import org.apache.commons.vfs.FileSystemManager;

public interface VFSComponent {

	 /**
	   * 获取FileSystemManager实例
	   */
  FileSystemManager getFileSystemManager();
}
