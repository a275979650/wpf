package com.bns.component.vfs.servlet;

import javax.servlet.ServletContext;

import org.apache.commons.vfs.FileSystemException;
import org.apache.commons.vfs.VFS;

import com.bns.component.vfs.wrap.WrappedResourceFileProvider;

public class ServletContextFileProvider extends WrappedResourceFileProvider{
  public ServletContextFileProvider(ServletContext servletContext) throws FileSystemException{
    super(VFS.getManager(), servletContext.getRealPath("/"));
  }
}
