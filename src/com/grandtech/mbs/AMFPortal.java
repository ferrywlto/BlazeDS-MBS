package com.grandtech.mbs;

import java.util.Hashtable;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.grandtech.mbs.vo.UserInfo;

import flex.messaging.FlexContext;
import flex.messaging.FlexSession;

public class AMFPortal implements HttpSessionListener{

	public String getStartupTime(){
		return Initializer.context.getAttribute("servletStartupTime").toString();
	}
	
	public String getStats(){
		MBSLogger.log("getStat called");
		MBSLogger.log("return:" + Initializer.getAllFlexSession().size());
		return "Session Count: " +Initializer.getAllFlexSession().size();
	}
 	
	// Must call this method before any other AMF call form Flex client
	public String createSession(){
		Hashtable<String, FlexSession> flexSessions = Initializer.getAllFlexSession();		
		FlexSession fSession = FlexContext.getFlexSession();
		String sessionID = fSession.getId();
		String ipAddr = FlexContext.getHttpRequest().getRemoteAddr();

		// if blazeds return the same sessionID, just keep using it as the app server still maintain this session
		if(!flexSessions.containsKey(sessionID)) {
			Initializer.getDatabaseConnector().dbCallNewSession(sessionID,ipAddr);
			synchronized (flexSessions){
				flexSessions.put(sessionID, fSession);
			}
		}
		MBSLogger.log("createSession called:"+fSession.getId());
		return sessionID;
	}
	
	public static boolean isSessionValid(String sessionID){
		if(sessionID == null || sessionID == "")
			return false;
		else 
			return Initializer.getAllFlexSession().containsKey(sessionID);
	}
	
	public boolean logout(String sessionID){
		MBSLogger.log("removeSession called:"+sessionID);
		if(isSessionValid(sessionID)) {
			Hashtable<String, FlexSession> flexSessions = Initializer.getAllFlexSession();
			FlexSession session = flexSessions.get(sessionID);
			session.invalidate();
	
			MBSLogger.log("return:" + true);
			return true;
		}
		MBSLogger.log("return:" + false);
		return false;
	}
	
	public UserInfo login(String session, String login, String password){
		if(isSessionValid(session)){
			return Initializer.getLoginHandler().login(session, login, password);
		}
		return null;
	}

	public String testDB() {
		return Initializer.getDatabaseConnector().testDB();
	}
	
	public int testSP(){
		return Initializer.getDatabaseConnector().testSP();
	}
	
	public void sessionCreated(HttpSessionEvent sessionEvent) {
		String sessionID = sessionEvent.getSession().getId();
		if(isSessionValid(sessionID)){
			MBSLogger.log("Session "+sessionID+" created.");
		}
	}
	
	// remove expired flex session
	public void sessionDestroyed(HttpSessionEvent sessionEvent){
		String sessionID = sessionEvent.getSession().getId();
		if(isSessionValid(sessionID)){
			if(Initializer.getDatabaseConnector().dbCallEndSession(sessionID)) {
				Hashtable<String, FlexSession> flexSessions = Initializer.getAllFlexSession();
				synchronized (flexSessions){ flexSessions.remove(sessionID); }
				MBSLogger.log("Session "+sessionID+" invalidated.");
			} else {
				MBSLogger.log("Session "+sessionID+" invalidated but did not update in DB.");
			}
		} /** not necessary 
		else {
			MBSLogger.log("Session "+sessionID+" cannot invalidate because it does not exist.");
		} */
	}
}
