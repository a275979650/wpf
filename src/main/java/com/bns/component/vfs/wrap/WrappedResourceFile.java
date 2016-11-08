package com.bns.component.vfs.wrap;

import java.net.URL;
import java.util.List;

import org.apache.commons.vfs.FileContent;
import org.apache.commons.vfs.FileName;
import org.apache.commons.vfs.FileObject;
import org.apache.commons.vfs.FileSelector;
import org.apache.commons.vfs.FileSystem;
import org.apache.commons.vfs.FileSystemException;
import org.apache.commons.vfs.FileType;
import org.apache.commons.vfs.NameScope;
import org.apache.commons.vfs.operations.FileOperations;

public class WrappedResourceFile implements FileObject {
  private FileObject internalRoot;
  private FileObject internalFile;

  /**
   * Creates a non-root file.
   * 
   * @throws FileSystemException
   */
  protected WrappedResourceFile(final WrappedResourceFileSystem fileSystem, final FileObject internalRoot,
      final FileName name) throws FileSystemException {
    this.internalRoot = internalRoot;
    String path = name.getPathDecoded();
    if (path.indexOf("..") == 0) {
      throw new RuntimeException("��Ȩ��������Ŀ¼�������Դ��");
    }
    if (path.indexOf("/") == 0) {
      path = path.substring(1);
    }
    this.internalFile = internalRoot.resolveFile(path);
  }

  /**
   * Returns the local file that this file object represents.
   */
  protected FileObject getInternalRoot() {
    return internalRoot;
  }

  /**
   * Returns the local file that this file object represents.
   */
  protected FileObject getInternalFile() {
    return internalFile;
  }

  public boolean canRenameTo(FileObject newfile) {
    return this.getInternalFile().canRenameTo(newfile);
  }

  public void close() throws FileSystemException {
    this.getInternalFile().close();

  }

  public void copyFrom(FileObject srcFile, FileSelector selector) throws FileSystemException {
    this.getInternalFile().copyFrom(srcFile, selector);
  }

  public void createFile() throws FileSystemException {
    this.getInternalFile().createFile();
  }

  public void createFolder() throws FileSystemException {
    this.getInternalFile().createFolder();
  }

  public boolean delete() throws FileSystemException {
    return this.getInternalFile().delete();
  }

  public int delete(FileSelector selector) throws FileSystemException {
    return this.getInternalFile().delete(selector);
  }

  public boolean exists() throws FileSystemException {
    return this.getInternalFile().exists();
  }

  public FileObject[] findFiles(FileSelector selector) throws FileSystemException {
    return this.getInternalFile().findFiles(selector);
  }

  @SuppressWarnings("unchecked")
  public void findFiles(FileSelector selector, boolean depthwise, List selected) throws FileSystemException {
    this.getInternalFile().findFiles(selector, depthwise, selected);

  }

  public FileObject getChild(String name) throws FileSystemException {
    return this.getInternalFile().getChild(name);
  }

  public FileObject[] getChildren() throws FileSystemException {
    return this.getInternalFile().getChildren();
  }

  public FileContent getContent() throws FileSystemException {
    return this.getInternalFile().getContent();
  }

  public FileOperations getFileOperations() throws FileSystemException {
    return this.getInternalFile().getFileOperations();
  }

  public FileSystem getFileSystem() {
    return this.getInternalFile().getFileSystem();
  }

  public FileName getName() {
    return this.getInternalFile().getName();
  }

  public FileObject getParent() throws FileSystemException {
    return this.getInternalFile().getParent();
  }

  public FileType getType() throws FileSystemException {
    return this.getInternalFile().getType();
  }

  public URL getURL() throws FileSystemException {
    return this.getInternalFile().getURL();
  }

  public boolean isAttached() {
    return this.getInternalFile().isAttached();
  }

  public boolean isContentOpen() {
    return this.getInternalFile().isContentOpen();
  }

  public boolean isHidden() throws FileSystemException {
    return this.getInternalFile().isHidden();
  }

  public boolean isReadable() throws FileSystemException {
    return this.getInternalFile().isReadable();
  }

  public boolean isWriteable() throws FileSystemException {
    return this.getInternalFile().isWriteable();
  }

  public void moveTo(FileObject destFile) throws FileSystemException {
    this.getInternalFile().moveTo(destFile);
  }

  public void refresh() throws FileSystemException {
    this.getInternalFile().refresh();
  }

  public FileObject resolveFile(String path) throws FileSystemException {
    return this.getInternalFile().resolveFile(path);
  }

  public FileObject resolveFile(String name, NameScope scope) throws FileSystemException {
    return this.getInternalFile().resolveFile(name, scope);
  }

}
