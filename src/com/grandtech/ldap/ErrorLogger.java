package com.grandtech.ldap;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;

public class ErrorLogger 
{
	public static void write(String msg)
	{
		try {
			FileWriter fw = new FileWriter(new File("C:\\errorLog.txt"),true);
			fw.append(Calendar.getInstance().getTime().toString()+":"+msg+"\n");
			fw.close();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}
	public static void write(Exception e)
	{
		String error = e.getMessage()+"\n";
		StackTraceElement[] ste = e.getStackTrace();
		for(int i=0; i<ste.length; i++)
			error+=ste[i].toString()+"\n";
		write(error);
	}
}
