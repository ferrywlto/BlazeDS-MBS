package com.grandtech.ldap;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;

public class ContextEnvironment
{
	public enum ENCRYPTION_METHOD 
	{ 
		SIMPLE, 
		DIGEST_MD5 { public String toString() { return "DIGEST-MD5"; } }
	}
	
	private Hashtable<String,String> environmentObj;
	
	public ContextEnvironment(String ldapURL, ENCRYPTION_METHOD encryptionMethod)
	{
		environmentObj = ContextEnvironmentFactory.getEnvironmentObject(encryptionMethod.toString());
		environmentObj.put(Context.PROVIDER_URL, ldapURL);
	}
	
	public DirContext getContext(String username, String password)
	{
		environmentObj.put(Context.SECURITY_PRINCIPAL, username);
		environmentObj.put(Context.SECURITY_CREDENTIALS, password);
		try	
			{ return new InitialDirContext(environmentObj); }
		catch(NamingException nex) 
			{ ErrorLogger.write(nex); }
		return null;
	}
}
