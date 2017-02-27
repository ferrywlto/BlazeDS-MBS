package com.grandtech.mbs;

public enum ReturnCode {
	NO_ERROR(0), ERROR_DEFAULT(-1);
	
	public final int value;
	
	ReturnCode(int _value){
		this.value = _value;
	}
}
