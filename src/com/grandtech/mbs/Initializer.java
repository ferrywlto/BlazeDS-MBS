package com.grandtech.mbs;

import java.util.Date;
import java.util.Hashtable;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;


import flex.messaging.FlexSession;


public class Initializer implements ServletContextListener{

	protected static ServletContext context;
	
	public void contextInitialized(ServletContextEvent contextEvent){
		context = contextEvent.getServletContext();
		context.setAttribute(ApplicationField.CONFIG, ApplicationConfiguration.getInstance());
		context.setAttribute(ApplicationField.SERVLET_START_UP_TIME, new Date().toString());
		context.setAttribute(ApplicationField.FLEX_SESSION, new Hashtable<String, HttpSession>());
		
		context.setAttribute(ApplicationField.DATABASE_CONNECTOR, 
				new DatabaseConnector(
						getConfig(ApplicationField.DATABASE_URL), 
						getConfig(ApplicationField.DATABASE_USER),
						getConfig(ApplicationField.DATABASE_PASSWORD)));
		
		context.setAttribute(ApplicationField.UPLOAD_REQUEST_PARSER, HttpFileUploadRequestParser.getInstance());
		
		ThumbnailGenerationTaskDispatcher dispatcher = ThumbnailGenerationTaskDispatcher.getInstance();
		dispatcher.initialize(getConfig(ApplicationField.FFMPEG_EXE_PATH));
		dispatcher.addPreset("sqcif", "00:01:00", "1280x960", "0.5");
		dispatcher.addPreset("half720", "00:01:00", "640x360", "0.3");
		
		MBSLogger.log("Context loaded successfully. "+this.toString());
		MBSLogger.log("context path:"+context.getContextPath());
		MBSLogger.log("real path:"+context.getRealPath("/"));
		MBSLogger.log("real path2:"+context.getRealPath(context.getContextPath()));
		MBSLogger.log(getConfiguration().get("mbs"));
		
		if(Boolean.parseBoolean(getConfig(ApplicationField.LDAP_AUTHENTICATION))) {
			context.setAttribute(ApplicationField.COMPONENT_LOGIN, new LDAPLoginHandler());
		} else {
			context.setAttribute(ApplicationField.COMPONENT_LOGIN, new BasicLoginHandler());
		}
	}
	
	public void contextDestroyed(ServletContextEvent contextEvent){
		getDatabaseConnector().close();
		MBSLogger.log("Context unloaded successfully.");
	}
	public static ILoginHandler getLoginHandler() {
		return (ILoginHandler)context.getAttribute(ApplicationField.COMPONENT_LOGIN);
	}
	@SuppressWarnings("unchecked")
	public static Hashtable<String, FlexSession> getAllFlexSession(){
		return (Hashtable<String, FlexSession>)context.getAttribute(ApplicationField.FLEX_SESSION);
	}
	public static DatabaseConnector getDatabaseConnector(){
		return (DatabaseConnector)context.getAttribute(ApplicationField.DATABASE_CONNECTOR);
	}
	public static HttpFileUploadRequestParser getUploadRequestParser(){
		return (HttpFileUploadRequestParser)context.getAttribute(ApplicationField.UPLOAD_REQUEST_PARSER);
	}
	public static ApplicationConfiguration getConfiguration(){
		return (ApplicationConfiguration)context.getAttribute(ApplicationField.CONFIG);
	}
	public static String getConfig(String key){
		return getConfiguration().get(key);
	}
}
