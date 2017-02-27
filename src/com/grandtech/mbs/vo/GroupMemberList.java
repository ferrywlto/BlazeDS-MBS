package com.grandtech.mbs.vo;

import java.util.Vector;

public class GroupMemberList extends ValueObject{
	public short groupID;
	public Vector<Short> members = new Vector<Short>();
}
