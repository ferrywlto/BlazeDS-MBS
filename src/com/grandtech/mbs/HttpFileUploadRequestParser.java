package com.grandtech.mbs;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/** @Singleton */
public class HttpFileUploadRequestParser {
	
	protected static HttpFileUploadRequestParser self;
	protected ServletFileUpload fileUploadHandler;
	protected DiskFileItemFactory factory;
	protected File tmpUploadFolder;
	
	protected HttpFileUploadRequestParser(){
		tmpUploadFolder = new File(Initializer.getConfiguration().get(ApplicationField.UPLOAD_FOLDER_TEMP));
		
		factory = new DiskFileItemFactory();
		factory.setRepository(tmpUploadFolder);
		//factory.setSizeThreshold(1024*1024*100);
		
		fileUploadHandler = new ServletFileUpload(factory);
		fileUploadHandler.setSizeMax(1024*1024*100); // just for test, 100MB should sufficient			
	}

	@SuppressWarnings("unchecked")
	public List<FileItem> parseRequest(HttpServletRequest request) {
		try {
			return (List<FileItem>)fileUploadHandler.parseRequest(request);
		} catch (FileUploadException e) {
			MBSLogger.logError(e);
			return null;
		}
	}
	
	public static HttpFileUploadRequestParser getInstance(){
		if(self == null){
			return new HttpFileUploadRequestParser();
		}
		return self;
	}
}
