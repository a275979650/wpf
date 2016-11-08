package com.bns.component.vfs;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.io.IOUtils;
import org.apache.commons.vfs.FileObject;
import org.apache.commons.vfs.FileSystemException;
import org.apache.commons.vfs.FileSystemManager;
import org.springframework.web.multipart.MultipartFile;
/**
 * 虚拟文件系统构件
 */
public class VFSManager {
  private static VFSFactory vfsFactory;
  private static UploadFactory uploadFactory;
  private static DownloadFactory downloadFactory;

  /**
   * 初始化
   */
  public static void init(VFSFactory vfsFactory, UploadFactory uploadFactory, DownloadFactory downloadFactory) throws FileSystemException {
	  VFSManager.vfsFactory = vfsFactory;
	  VFSManager.uploadFactory = uploadFactory;
	  VFSManager.downloadFactory = downloadFactory;
	  
  }

  
  /**
   * 获取FileSystemManager
   */
  public static FileSystemManager getFileSystemManager(){
    //未初始化
    if(vfsFactory == null || vfsFactory.getFileSystemManager() == null){
      throw new RuntimeException("VFSFactory not init.");
    }
    
    return vfsFactory.getFileSystemManager();
  }

  
  /**
   * 注册一个路径
   * 如注册引用名为xxx，封装路径为c:\aaa\bbb\，
   * 那么读取文件xxx://ccc.txt时，真正访问的是c:\aaa\bbb\ccc.txt
   * @param name 路径的引用名
   * @param url 引用名所封装的路径
   */
  public static void addProvider(String name, String url){
    //未初始化
    if(vfsFactory == null || vfsFactory.getFileSystemManager() == null){
      throw new RuntimeException("VFSFactory not init.");
    }
    
    vfsFactory.addProvider(name, url);
  }

    /**
     * 上传文件
     * @param baseDir 文件存放目录
     * @param request HttpServletRequest对象
     * @param maxMemorySize 上传文件大小限制
     * @return 返回已上传的文件对象（列表）
     */
	public static List<FileObject> upload(FileObject baseDir, HttpServletRequest request, long maxMemorySize){
		return uploadFactory.upload(baseDir, request, maxMemorySize);
	}
	
	/**
     * 上传文件（使用这个方法可设置更多参数）
     * @param baseDir 文件存放目录
	 * @param context HttpServletRequest的封装上下文
	 * @param upload 文件上传对象
	 * @return 返回已上传的文件对象（列表）
	 */
	public static List<FileObject> upload(FileObject baseDir, RequestContext context, FileUpload upload){
		return uploadFactory.upload(baseDir, context, upload);
	}
	 /**
     * 上传文件
     * @param baseDir 文件存放目录
     * @param request HttpServletRequest对象
     * @param maxMemorySize 上传文件大小限制
     * @return 返回已上传的文件对象（列表）
     */
	public static FileObject upload(FileObject baseDir,MultipartFile file, long maxMemorySize) throws Exception{
		return uploadFactory.upload(baseDir, file,maxMemorySize);
	}
	
	/**
	 * 文件下载
	 * @param file 用于下载的文件对象
	 * @param response HttpServletResponse对象
	 */
	public static void download(FileObject file, HttpServletResponse response){
		downloadFactory.download(file, response);
	}
	

	/**
	 * 文件流复制
	 * @param istream 输入流
	 * @param ostream 输出流
	 */
	public void copy(InputStream istream, OutputStream ostream) {
		try {
			IOUtils.copy(istream, ostream);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}
