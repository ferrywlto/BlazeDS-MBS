package com.grandtech.ldap;

import java.util.Hashtable;

import javax.naming.Context;

abstract class ContextEnvironmentFactory
{
	private static final String INITIAL_CONTEXT_CLASS = "com.sun.jndi.ldap.LdapCtxFactory";
	
	protected static final Hashtable getEnvironmentObject(String encryptionMethod)
	{
		Hashtable environmentObj = new Hashtable<String,String>();
		environmentObj.put(Context.INITIAL_CONTEXT_FACTORY,  INITIAL_CONTEXT_CLASS);
		environmentObj.put(Context.SECURITY_AUTHENTICATION, encryptionMethod);
		environmentObj.put("javax.security.sasl.qop","auth-conf");
		environmentObj.put("javax.security.sasl.strength","high");
		environmentObj.put("com.sun.jndi.ldap.trace.ber", System.err); //remove comment and <String,String> to debug.
		return environmentObj;
	}
}
