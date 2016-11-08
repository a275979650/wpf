package com.bns.component.vfs.wrap;

import java.util.Collection;

import org.apache.commons.vfs.FileName;
import org.apache.commons.vfs.FileObject;
import org.apache.commons.vfs.FileSystemException;
import org.apache.commons.vfs.FileSystemManager;
import org.apache.commons.vfs.FileSystemOptions;
import org.apache.commons.vfs.provider.AbstractFileSystem;

public class WrappedResourceFileSystem extends AbstractFileSystem  {
  /** serialVersionUID */
  private static final long serialVersionUID = 3854480314717755211L;
  private FileObject internalRoot;
  private FileSystemManager fileSystemManager;

  /**
   * @param rootName
   * @param fileSystemOptions
   * @throws FileSystemException
   */
  protected WrappedResourceFileSystem(final FileSystemManager fsm, final FileSystemOptions fso,
      final FileName rootName, final String rootFile) throws FileSystemException {
    super(rootName, null, fso);
    this.fileSystemManager = fsm;
    this.internalRoot = fileSystemManager.resolveFile(rootFile);
  }

  /**
   * ��ȡһ���ļ�����
   */
  protected FileObject createFile(FileName name) throws Exception {
    return new WrappedResourceFile(this, internalRoot, name);
  }

  @SuppressWarnings("unchecked")
  protected void addCapabilities(Collection caps) {
    caps.addAll(WrappedResourceFileProvider.capabilities);
  }

  /**
   * Close the RAMFileSystem
   */
  public void close() {
    this.internalRoot = null;
    super.close();
  }
}
