package com.bns.component.vfs;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.vfs.FileObject;

/**
 * 文件下载构件工厂实现
 */
public class DefaultDownloadFactory implements DownloadFactory{
  
	private Log logger = LogFactory.getLog(DefaultDownloadFactory.class);

	public void init(Properties prop) {
	}

	@Override
	public void download(FileObject file, HttpServletResponse response) {
		BufferedOutputStream bos = null;
		BufferedInputStream bis = null;

		try {
			bos = new BufferedOutputStream(response.getOutputStream());
			bis = new BufferedInputStream(file.getContent().getInputStream());

			IOUtils.copy(bis, bos);
			IOUtils.closeQuietly(bis);
			IOUtils.closeQuietly(bos);
			file.close();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}
