package com.grandtech.mbs;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.Date;

public class MBSLogger {
	
	public static void log(String msg){		
			try {
				FileWriter fw = new FileWriter("C:\\test.txt", true);
				
				fw.write(new Date().toString()+" | ");
				fw.write(msg+"\n");
				fw.close();
			} 
			 catch (FileNotFoundException e) {
				e.printStackTrace();
			 }
			catch (IOException e) {
				e.printStackTrace();
			}
	}
	public static void logError(Exception ex){
		String msg = "";
		StackTraceElement[] stackTrace = ex.getStackTrace();
		for(int i=0; i<stackTrace.length; i++)
			msg += stackTrace[i].toString() +"\n";
		log(msg);
	}
	protected String getNowString(){
		Calendar cal = Calendar.getInstance();
		return cal.get(Calendar.YEAR) + "/" +
		cal.get(Calendar.MONTH) + "/" +
		cal.get(Calendar.DATE) + " " +
		cal.get(Calendar.HOUR_OF_DAY) + ":" +
		cal.get(Calendar.MINUTE) + ":" +
		cal.get(Calendar.SECOND) + "." +
		cal.get(Calendar.MILLISECOND);
	}
}
