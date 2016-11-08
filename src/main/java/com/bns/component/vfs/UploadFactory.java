package com.bns.component.vfs;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.vfs.FileObject;
import org.springframework.web.multipart.MultipartFile;


/**
 * 文件上传构件工厂
 */
public interface UploadFactory {
    /**
     * 上传文件
     * @param baseDir 文件存放目录
     * @param request HttpServletRequest对象
     * @param maxMemorySize 上传文件大小限制
     * @return 返回已上传的文件对象（列表）
     */
	List<FileObject> upload(FileObject baseDir, HttpServletRequest request, long maxMemorySize);

	/**
     * 上传文件（使用这个方法可设置更多参数）
     * @param baseDir 文件存放目录
	 * @param context HttpServletRequest的封装上下文
	 * @param upload 文件上传对象
	 * @return 返回已上传的文件对象（列表）
	 */
	List<FileObject> upload(FileObject baseDir, RequestContext context, FileUpload upload);
	
	FileObject upload(FileObject baseDir, MultipartFile file,long maxMemorySize) throws Exception;
	
}
