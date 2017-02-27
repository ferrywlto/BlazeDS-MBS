 package com.grandtech.ldap.mbs;

import javax.naming.NamingEnumeration;
import javax.naming.directory.SearchResult;
import com.grandtech.ldap.ErrorLogger;

public class FlashRemotingGateway {
	final static String username = "ldap_query@solutions.grandtech.com.hk";
	final static String password = "abc123!@#";
	final static String contextRoot = "CN=Users,DC=solutions,DC=grandtech,DC=com,DC=hk";
	final static String filter = "cn=f*";
	final static String[] returnAttr = {"sn"};
	public boolean attemptBind(String username, String password)
	{
		return (QueryProcessor.getInstance().getUserBindContext(username, password) != null);
	}
	
	/**
	 * 
	 * @param username
	 * @param password
	 * @param contextRoot
	 * @param filter
	 * @param returnAttributes
	 * null indicates that all attributes will be returned. An empty array indicates no attributes are returned.
	 * @return
	 */
	public String[] bindAndSearch(String username, String password, String contextRoot, String filter, String[] returnAttributes)
	{
		// better check the return attributes passed from Flash carefully
		if(returnAttributes!=null)
		{
			ErrorLogger.write("[return attrs:]");
			for(int j=0; j<returnAttributes.length; j++)
				ErrorLogger.write(returnAttributes[j]);
			ErrorLogger.write("[return attrs END]");
			// if null passed, thats good. if empty string passed, it sucks and lets make it back to null
			if(returnAttributes.length == 1 && returnAttributes[0].equals(""))
				returnAttributes = null;
		}	
		try
		{
			NamingEnumeration<SearchResult> results = QueryProcessor.getInstance().search(username, password, contextRoot, filter, returnAttributes);
			if(results != null)
			{
				String[] resultsX = ResultPackager.packResultForAS3Remoting(results);
				for(int i=0; i<resultsX.length; i++)
					ErrorLogger.write(resultsX[i]);
				return resultsX;
			}
		}
		catch(Exception e) 
			{ ErrorLogger.write(e);}
		return null;
	}
	
	//Each call from Flash Client will instantiate one new object.... :(
	public FlashRemotingGateway(){}

	// just for debug and testing purpose
	public static void main(String[] args)
	{
		FlashRemotingGateway gateway = new FlashRemotingGateway();
		boolean isBind = gateway.attemptBind(username, password);
		System.out.println(isBind+"");
		String[] results = gateway.bindAndSearch(username, password, contextRoot, filter, null);
		for(int i=0; i<results.length; i++)
			System.out.println(results[i]);
	}
}

