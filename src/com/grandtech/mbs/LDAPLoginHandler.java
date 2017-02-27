package com.grandtech.mbs;

import com.grandtech.mbs.vo.UserInfo;

public class LDAPLoginHandler implements ILoginHandler {

	@Override
	public UserInfo login(String session, String login, String password) {
		// auth at LDAP server
		// if succ
		//	get user info from LDAP server
		//	see if DB has this entry
		//	if no then create a new entry in DB
		//	get corresponding uID from DB
		//	login session
		//	done
		return null;
	}

}
