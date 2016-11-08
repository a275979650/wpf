package com.bns.component.vfs;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.vfs.FileObject;
import org.springframework.web.multipart.MultipartFile;

public class CommonFileUploadFactory implements UploadFactory{
	  
	private Log logger = LogFactory.getLog(CommonFileUploadFactory.class);
	
	public void init(Properties prop) {
		
	}

	@Override
	public List<FileObject> upload(FileObject baseDir, HttpServletRequest request, long maxMemorySize) {
		if (!ServletFileUpload.isMultipartContent(request)) {
			return null;
		}

		// Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();

		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);

		// Set overall request size constraint
		upload.setSizeMax(maxMemorySize);
		
		return this.upload(baseDir, new ServletRequestContext(request), upload);
	}
	
	@Override
	public List<FileObject> upload(FileObject baseDir, RequestContext context, FileUpload upload) {
		List<FileObject> files = null;
		try {
			List<FileItem> items = upload.parseRequest(context);
			files = new ArrayList<FileObject>();
			
			// Process the uploaded items
			Iterator<FileItem> iter = items.iterator();
			while (iter.hasNext()) {
				FileItem item = iter.next();
				FileObject file = processUpload(baseDir, item);
				files.add(file);
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return files;
	}
	
	@Override
	public FileObject upload(FileObject baseDir, MultipartFile multFile, long maxMemorySize) throws Exception{
		if (multFile == null ) {
			return null;
		}
		FileObject file = null;
		BufferedOutputStream bos = null;
		BufferedInputStream bis = null;

		//生成文件名，并创建文件
		synchronized(this){
			while(true) {
				String ext = this.getFileExt(multFile.getOriginalFilename());
				String fileName = this.generateFileName() + (ext == null ? "" : "." + ext);
		
				file = baseDir.resolveFile(fileName);
				
				if (!file.exists()){
					file.createFile();
					break;
				}
			}
		}
		
		bos = new BufferedOutputStream(file.getContent().getOutputStream());
		bis = new BufferedInputStream(multFile.getInputStream());
		
		IOUtils.copy(bis, bos);
		IOUtils.closeQuietly(bis);
		IOUtils.closeQuietly(bos);
		file.close();
		return file;
	}


	/**
	 * 上传处理
	 */
	protected FileObject processUpload(FileObject baseDir, FileItem item) throws Exception {
		if (item.getName() == null || item.getName().length() == 0) {
			return null;
		}
		FileObject file = null;
		BufferedOutputStream bos = null;
		BufferedInputStream bis = null;

		//生成文件名，并创建文件
		synchronized(this){
			while(true) {
				String ext = this.getFileExt(item.getName());
				String fileName = this.generateFileName() + (ext == null ? "" : "." + ext);
		
				file = baseDir.resolveFile(fileName);
				
				if (!file.exists()){
					file.createFile();
					break;
				}
			}
		}
		
		bos = new BufferedOutputStream(file.getContent().getOutputStream());
		bis = new BufferedInputStream(item.getInputStream());
		
		IOUtils.copy(bis, bos);
		IOUtils.closeQuietly(bis);
		IOUtils.closeQuietly(bos);
		file.close();
		return file;
	}
	
	/**
	 * 生成唯一的标识，用于文件名
	 */
	protected String generateFileName() {
		// 当前时间
		long time = (new Date()).getTime();
		Random random = new Random();
		int randomInt = random.nextInt(100000);
		String fileName = String.valueOf(time) + String.valueOf(randomInt);
		return fileName;
	}
	
	/**
	 * 获取文件扩展名
	 */
	protected String getFileExt(String fileName) {
		if(fileName == null)return null;
		
		int idx = fileName.indexOf(".");
		if(idx >= 0){
			return fileName.substring(idx + 1);
		} else {
			return null;
		}
	}
}
