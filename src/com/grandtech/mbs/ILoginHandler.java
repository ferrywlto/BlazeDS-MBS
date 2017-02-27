package com.grandtech.mbs;

import com.grandtech.mbs.vo.UserInfo;

public interface ILoginHandler {
	public UserInfo login(String sessiond, String login, String password);
}
