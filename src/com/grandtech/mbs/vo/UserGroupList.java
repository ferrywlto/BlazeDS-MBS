package com.grandtech.mbs.vo;

import java.util.Vector;

public class UserGroupList extends ValueObject
{
	public short userID;
	public Vector<Short> groups = new Vector<Short>();
}
