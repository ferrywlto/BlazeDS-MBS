package com.grandtech.mbs;

import com.grandtech.mbs.vo.UserInfo;

public class BasicLoginHandler implements ILoginHandler {

	@Override
	public UserInfo login(String session, String login, String password) {
		UserInfo userInfo = Initializer.getDatabaseConnector().loginSession(session, login, password);
		if(userInfo != null){
			Initializer.getAllFlexSession().get(session).setAttribute("user", userInfo.id);
			return userInfo;
		}
		return null;
	}

}
