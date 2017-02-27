package com.grandtech.mbs;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Date;
import java.util.Enumeration;

import com.grandtech.mbs.vo.GroupInfo;
import com.grandtech.mbs.vo.GroupMemberList;
import com.grandtech.mbs.vo.UserGroupList;
import com.grandtech.mbs.vo.UserInfo;
import com.grandtech.mbs.vo.ValueObject;

public class DatabaseConnector {
	protected CallableStatement 
		cContent, 	
		cContentCategory,  
		cGroup,		
		cGroupAssignment, 
		cRole, 		
		cRoleAssignment, 
		cFolder, 	
		cUser, 				
		cStatusCode,
		
		dContent,	
		dContentCategory,	
		dGroup,		
		dGroupAssignment,
		dRole,		
		dRoleAssignment,
		dFolder,	
		dUser,
		csDelSession,	
		dStatusCode,
		
		rContentCategoryAll,
		rContentCategory,
		rContent,
		rFolder,
		rGroupAssignmentByGroup,
		rGroupAssignmentByUser,
		rGroup,
		rIDFromLogin,
		rRoleAssignment,
		rRole,
		csGetSession,
		rStatusCode,
		rUserByID,
		rUserByLogin,
		csLogin,
		
		uContent,
		uContentCategory,
		uFolder,
		uGroup,
		uRole,
		uStatusCode,
		uUser,
		csSessionEnd,
		csSessionNew;
	
	protected Connection dbConn;
	protected String connStr, userName, password;

	protected DatabaseConnector(String connectionString, String userName, String password){
		//dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mbs", "root", "password");
		connStr = connectionString;
		this.userName = userName;
		this.password = password;
		MBSLogger.log("DatabaseConnector created.");
		initialize();
	}
	
	protected void initialize(){
		try {
			Class.forName("com.mysql.jdbc.Driver");
			dbConn = DriverManager.getConnection("jdbc:mysql://"+connStr, userName, password);
			MBSLogger.log("connect to '"+connStr+"' success");
			//pre-construct expensive prepareCall() for future reuse.
			csSessionNew = dbConn.prepareCall("{call sessionNew(?, ?, ?)}");
			csSessionEnd = dbConn.prepareCall("{call sessionEnd(?, ?)}");
			csGetSession = dbConn.prepareCall("{call getSession(?, ?)}");
			csDelSession = dbConn.prepareCall("{call delSession(?, ?)}");
			csLogin = dbConn.prepareCall("{call login(?, ?, ?, ?)}");
						
			cContent = dbConn.prepareCall("{call addContent(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}"); 	
			uContent = dbConn.prepareCall("{call modContent(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			rContent = dbConn.prepareCall("{call getContentInfo(?, ?)}");
			dContent = dbConn.prepareCall("{call delContent(?, ?)}");
			
			cContentCategory = dbConn.prepareCall("{call addContentCategory(?, ?, ?)}");  
			uContentCategory = dbConn.prepareCall("{call modContentCategory(?, ?, ?, ?)}");
			rContentCategory = dbConn.prepareCall("{call getContentCategory(?, ?)}");
			rContentCategoryAll = dbConn.prepareCall("{call getAllContentCategory(?)}");
			dContentCategory = dbConn.prepareCall("{call delContentCategory(?, ?)}");
			
			cGroup = dbConn.prepareCall("{call addGroup(?, ?, ?, ?, ?, ?)}");		
			uGroup = dbConn.prepareCall("{call modGroup(?, ?, ?, ?, ?, ?)}");
			rGroup = dbConn.prepareCall("{call getGroupInfo(?, ?)}");
			dGroup = dbConn.prepareCall("{call sessionNew(?, ?)}");
			
			cGroupAssignment = dbConn.prepareCall("{call addGroupAssignment(?, ?, ?)}"); 
			rGroupAssignmentByGroup = dbConn.prepareCall("{call getGroupAssignmentByGroup(?, ?)}");
			rGroupAssignmentByUser = dbConn.prepareCall("{call getGroupAssignmentByUser(?, ?)}");
			dGroupAssignment = dbConn.prepareCall("{call delGroupAssignment(?, ?, ?)}");
			
			cRole = dbConn.prepareCall("{call addRole(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)}"); 		
			uRole = dbConn.prepareCall("{call modRole(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)}");
			rRole = dbConn.prepareCall("{call getRoleInfo(?, ?)}");
			dRole = dbConn.prepareCall("{call delRole(?, ?)}");
			
			cRoleAssignment = dbConn.prepareCall("{call addRoleAssignment(?, ?, ?)}"); 
			dRoleAssignment = dbConn.prepareCall("{call delRoleAssignment(?, ?, ?)}");
			rRoleAssignment = dbConn.prepareCall("{call getRoleAssignment(?, ?, ?)}");
			
			cFolder = dbConn.prepareCall("{call addFolder(?,?,?, ?,?,?, ?,?,?)}"); 	
			uFolder = dbConn.prepareCall("{call modFolder(?,?,?, ?,?,?, ?,?,?)}");
			rFolder = dbConn.prepareCall("{call getFolderInfo(?, ?)}");
			dFolder = dbConn.prepareCall("{call delFolder(?, ?)}");
			
 			cUser = dbConn.prepareCall("{call addUser(?,?,?, ?,?,?, ?,?,?, ?,?,?,?)}"); 				
 			uUser = dbConn.prepareCall("{call modUser(?,?,?, ?,?,?, ?,?,?, ?,?,?, ?,?,?)}");
 			dUser = dbConn.prepareCall("{call delUser(?, ?)}");
			
			rUserByID = dbConn.prepareCall("{call getUserByID(?, ?)}");
			rUserByLogin = dbConn.prepareCall("{call getUserByLogin(?, ?)}");
			rIDFromLogin = dbConn.prepareCall("{call getIDFromLogin(?, ?, ?)}");
			
			cStatusCode = dbConn.prepareCall("{call addStatusCode(?, ?, ?)}");
			uStatusCode = dbConn.prepareCall("{call modStatusCode(?, ?, ?, ?)}");
			rStatusCode = dbConn.prepareCall("{call getStatusCode(?, ?)}");
			dStatusCode = dbConn.prepareCall("{call delStatusCode(?, ?)}");
			
		} catch (ClassNotFoundException e) {
			MBSLogger.log("class not found:" + e.getMessage());
		} catch (SQLException e) {
			MBSLogger.log("store proc init failed:" + e.getMessage());
		} 
	}
	
	public void close(){
		// should be called only at initializer servlet context destroyed.
		// This manually deregisters JDBC driver, which prevents Tomcat 7 from complaining about memory leaks wrto this class
		try {        
			dbConn.close();
			Enumeration<Driver> drivers = DriverManager.getDrivers();
			while (drivers.hasMoreElements()) {
				Driver driver = drivers.nextElement();
                DriverManager.deregisterDriver(driver);
			}
			MBSLogger.log("MySQL JDBC Driver deregistered successfully.");
        } catch (SQLException e) {
        	MBSLogger.logError(e);
        }
	}
	
	protected void checkConnection(){
		try {
			if(dbConn == null || dbConn.isClosed()) {
				initialize();
			}
		} catch (SQLException e) {
			MBSLogger.log("exception when check dbConn.isClosed():" + e.getMessage());
		}
	}
	
	public void dbCallGetRole(short userID, short contentID) {
		checkConnection();
		try {
			rRole.setShort("userID", userID);
			rRole.setShort("contentID", contentID);
			rRole.registerOutParameter("returnCode", Types.TINYINT);
			rRole.execute();
			
			if(rRole.getByte("returnCode") == 0) {
				ResultSet rs = rRole.getResultSet();
				
				rs.first(); //only one row will be retrieved
				UserInfo result = new UserInfo();
				result.id = rs.getShort("id");
				result.name = rs.getString("displayName");
				result.description = rs.getString("description");
				result.firstName = rs.getString("firstName");
				result.lastName = rs.getString("lastName");
				result.title = rs.getString("title");
				result.email = rs.getString("email");
				result.phone = rs.getString("phone");
				result.status = rs.getByte("status");
				result.createdAt = rs.getTimestamp("createdAt");
				result.modifiedAt = rs.getTimestamp("modifiedAt");
				result.validAt = rs.getTimestamp("validAt");
				result.expireAt = rs.getTimestamp("expireAt");
				result.birthday = rs.getTimestamp("birthday");
				rs.close();
			}
			
		} catch (SQLException e) {
			MBSLogger.logError(e);
		}
		
	}
	
	public boolean dbCallNewSession(String sessionID, String ipAddress){
		checkConnection();
		try {
			csSessionNew.setString("sessionID", sessionID);
			csSessionNew.setString("ipAddress", ipAddress);		
			return (executeSP(csSessionNew) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	public boolean dbCallEndSession(String sessionID){
		checkConnection();
		try {
			csSessionEnd.setString("sessionID", sessionID);
			return (executeSP(csSessionEnd) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	
	protected static final String RETURN_PARAM_NAME = "returnCode";
	protected static final byte OK = 0, ERROR = -1;
	
	protected byte executeSP(CallableStatement sp){
		try{
			sp.registerOutParameter(RETURN_PARAM_NAME, Types.TINYINT);
			sp.execute();
			return sp.getByte(RETURN_PARAM_NAME);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return ERROR;
	}
	public UserInfo getUserInfo(short userID){
		try {
			rUserByID.setShort("userID", userID);
			if(executeSP(rUserByID) == OK) {
				UserInfo vo = new UserInfo();
				ResultSet rs = rUserByID.getResultSet();
				rs.first();
					vo.id 	= rs.getShort("id");
					vo.name 	= rs.getString("name");
					vo.status 	= rs.getByte("status");
					vo.validAt 	= rs.getDate("validAt");
					vo.expireAt 	= rs.getDate("expireAt");
					vo.createdAt 	= rs.getDate("createdAt");
					vo.modifiedAt 	= rs.getDate("modifiedAt");
					vo.description 	= rs.getString("description");
					vo.homeFolderID = rs.getInt("homeFolderID");
					vo.birthday = rs.getTimestamp("birthday");
					vo.phone = rs.getString("phone");
					vo.email = rs.getString("email");
					vo.title = rs.getString("title");
					vo.firstName = rs.getString("firstName");
					vo.lastName = rs.getString("lastName");
				rs.close();
				return vo;
			}
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return null;
	}
	protected java.sql.Date convertDate(Date date){
		return new java.sql.Date(date.getTime());
	}
	
	public short addUser(String login, String password, String firstName, String lastName, String title, String email, String phone, Date birthday,
			String displayName, String description, Date validAt, Date expireAt){
		try {
			cUser.setString("login", login);
			cUser.setString("password", password);
			cUser.setString("firstName", firstName);
			cUser.setString("lastName", lastName);
			cUser.setString("title", title);
			cUser.setString("email", email);
			cUser.setString("phone", phone);
			cUser.setDate("birthday", convertDate(birthday));
			cUser.setString("displayName", displayName);
			cUser.setString("description", description);
			cUser.setDate("validAt", convertDate(validAt));
			cUser.setDate("expireAt", convertDate(expireAt));
			cUser.registerOutParameter("newUserID", Types.SMALLINT);
			if(executeSP(cUser) == OK)
				return cUser.getShort("newUserID");
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return ERROR;
	}
	public short addGroup(String displayName, String description, Date validAt, Date expireAt) {
		try {
			cGroup.setString("displayName", displayName);
			cGroup.setString("description", description);
			cGroup.setDate("validAt", convertDate(validAt));
			cGroup.setDate("expireAt", convertDate(expireAt));
			cGroup.registerOutParameter("newGroupID", Types.SMALLINT);
			if(executeSP(cGroup) == OK)
				return cGroup.getShort("newGroupID");
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return ERROR;
	}
	protected boolean updateUser(short id, String displayName, String description, Date validAt, Date expireAt, byte status,
			String login, String password, String firstName, String lastName, String title, String email, String phone, Date birthday){
		try{
			uUser.setShort("id", id);
			uUser.setByte("status", status);
			uUser.setString("displayName", displayName);
			uUser.setString("description", description);
			uUser.setDate("validAt", convertDate(validAt));
			uUser.setDate("expireAt", convertDate(expireAt));
			uUser.setDate("birthday", convertDate(birthday));
			uUser.setString("login", login);
			uUser.setString("password", password);
			uUser.setString("firstName", firstName);
			uUser.setString("lastName", lastName);
			uUser.setString("title", title);
			uUser.setString("email", email);
			uUser.setString("phone", phone);
			return (executeSP(uUser) == OK);
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return false;
	}
	protected boolean updateGroup(short id, String displayName, String description, Date validAt, Date expireAt, byte status){
		try{
			uGroup.setShort("id", id);
			uGroup.setByte("status", status);
			uGroup.setString("displayName", displayName);
			uGroup.setString("description", description);
			uGroup.setDate("validAt", convertDate(validAt));
			uGroup.setDate("expireAt", convertDate(expireAt));			
			return (executeSP(uGroup) == OK);
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return false;
	}
	protected boolean deleteUser(short id){
		try{
			dUser.setShort("userID", id);
			return (executeSP(dUser) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	protected boolean deleteGroup(short id){
		try{
			dGroup.setShort("groupID", id);
			return (executeSP(dGroup) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	protected GroupInfo getGroupInfo(short groupID){
		try {
			rGroup.setShort("groupID", groupID);
			if(executeSP(rGroup) == OK){
				GroupInfo vo = new GroupInfo();
				ResultSet rs = rGroup.getResultSet();
				rs.first();
					vo.id 	= rs.getShort("id");
					vo.name 	= rs.getString("name");
					vo.status 	= rs.getByte("status");
					vo.validAt 	= rs.getTimestamp("validAt");
					vo.expireAt 	= rs.getTimestamp("expireAt");
					vo.createdAt 	= rs.getTimestamp("createdAt");
					vo.modifiedAt 	= rs.getTimestamp("modifiedAt");
					vo.description 	= rs.getString("description");
					vo.homeFolderID = rs.getInt("homeFolderID");
				rs.close();
				return vo;
			}
		} catch (Exception ex) {MBSLogger.logError(ex);}
		return null;
	}
	public boolean addGroupAssignment(short groupID, short userID) {
		try{
			cGroupAssignment.setShort("groupID", groupID);
			cGroupAssignment.setShort("userID", userID);
			return (executeSP(cGroupAssignment) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	
	public boolean deleteGroupAssignment(short groupID, short userID){
		try{
			dGroupAssignment.setShort("groupID", groupID);
			dGroupAssignment.setShort("userID", userID);
			return (executeSP(dGroupAssignment) == OK);
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return false;
	}
	
	public UserGroupList getGroupAssignmentByUser(short userID){
		try{
			rGroupAssignmentByUser.setShort("userID", userID);
			if(executeSP(rGroupAssignmentByUser) == OK) {
				ResultSet rs = rGroupAssignmentByUser.getResultSet();
				UserGroupList list = new UserGroupList();
				list.userID = userID;
				while(rs.next())
					list.groups.add(rs.getShort("group"));
				rs.close();
				return list;
			}
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return null;
	}
	public GroupMemberList getGroupAssignmentByGroup(short groupID){
		try{
			rGroupAssignmentByGroup.setShort("groupID", groupID);
			if(executeSP(rGroupAssignmentByGroup) == OK) {
				ResultSet rs = rGroupAssignmentByGroup.getResultSet();
				GroupMemberList list = new GroupMemberList();
				list.groupID = groupID;
				while(rs.next())
					list.members.add(rs.getShort("user"));
				rs.close();
				return list;
			}
		} catch (Exception ex) { MBSLogger.logError(ex); }
		return null;
	}
	protected UserInfo loginSession(String sessionID, String login, String password){
		checkConnection();
		try {
			csLogin.setString("sessionID", sessionID);
			csLogin.setString("login", login);
			csLogin.setString("password", password);
			csLogin.registerOutParameter("returnCode", Types.TINYINT);
			csLogin.execute();
			if(csLogin.getByte("returnCode") == OK) {
				UserInfo result = new UserInfo();
				ResultSet rs = csLogin.getResultSet();
				rs.first(); //only one row will be retrieved
					result.id = rs.getShort("id");
					result.name = rs.getString("displayName");
					result.description = rs.getString("description");
					result.firstName = rs.getString("firstName");
					result.lastName = rs.getString("lastName");
					result.title = rs.getString("title");
					result.email = rs.getString("email");
					result.phone = rs.getString("phone");
					result.status = rs.getByte("status");
					result.createdAt = rs.getTimestamp("createdAt");
					result.modifiedAt = rs.getTimestamp("modifiedAt");
					result.validAt = rs.getTimestamp("validAt");
					result.expireAt = rs.getTimestamp("expireAt");
					result.birthday = rs.getTimestamp("birthday");
				rs.close();
				return result;
			}
		} catch (SQLException e) { MBSLogger.log("csLoginSession failed: "+e.getMessage()); }
		return null;
	}


	public String testDB() {
		MBSLogger.log("testDB called:");
		String result = "";
		try {
			Statement statement = dbConn.createStatement();
			ResultSet rs = statement.executeQuery("SELECT * FROM mbs.contentcategory");
			
			while(rs.next()){
				result += "{"+rs.getShort(1)+"}`{"+rs.getString(2)+"}`{"+rs.getString(3)+"}~";
			}
			
			rs.close();
			statement.close();
			MBSLogger.log("return:" + result);
			return result;
			
		} catch (SQLException e) {
			MBSLogger.log(e.getMessage());
			return "";
		}
	}
	
	public int testSP(){
		MBSLogger.log("testSP called:");
		try {
			CallableStatement cStmt = dbConn.prepareCall("{call addStatusCode(?, ?, ?)}");
			cStmt.setString("name", "U");
			cStmt.setString("description", "Unknown");
			cStmt.registerOutParameter("returnCode", Types.BIT);
			cStmt.execute();
			if(cStmt.getUpdateCount() == 1){
				return cStmt.getInt("returnCode");
			}
			return -1;
		} catch (SQLException e) {
			MBSLogger.log(e.getMessage());
			return -1;
		}
	}
	
	public Statement getQueryStatement(){
		try {
			return dbConn.createStatement();
		} catch (SQLException e) {
			MBSLogger.log(e.getMessage());
			return null;
		}
	}
}
