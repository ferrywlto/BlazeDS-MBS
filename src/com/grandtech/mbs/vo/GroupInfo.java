package com.grandtech.mbs.vo;

import java.util.Date;

public class GroupInfo extends ValueObject {
	public short id;
	public String name;
	public String description;
	public byte status;
	public Date createdAt;
	public Date modifiedAt;
	public Date validAt;
	public Date expireAt;
	public int homeFolderID;
}
