package com.bns.component.vfs;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.vfs.FileObject;

/**
 * 文件下载构件工厂
 */
public interface DownloadFactory {

	/**
	 * 文件下载
	 * @param file 用于下载的文件对象
	 * @param response HttpServletResponse对象
	 */
	void download(FileObject file, HttpServletResponse response);
}
