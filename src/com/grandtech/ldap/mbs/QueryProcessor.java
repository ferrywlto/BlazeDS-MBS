package com.grandtech.ldap.mbs;
import java.io.IOException;
import java.util.Properties;

import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import com.grandtech.ldap.ContextEnvironment;
import com.grandtech.ldap.ErrorLogger;

public class QueryProcessor {
	protected static final String CONFIG_FILE_PATH = "conf.properties";
	protected static ContextEnvironment contextEnv;
	protected static QueryProcessor self;
	protected static String ldapURL = "";
	protected Properties configFile;
	
	protected void loadConfigFile()
	{
		configFile = new Properties();
		try 
			{configFile.load(this.getClass().getClassLoader().getResourceAsStream(CONFIG_FILE_PATH));}
		catch (IOException e) 
			{ErrorLogger.write(e);}
	}
	protected static QueryProcessor getInstance()
	{
		if(self == null)
			self = new QueryProcessor();
		return self;
	}
	protected QueryProcessor()
	{
		loadConfigFile();
		ldapURL = configFile.getProperty("ldapURL");
		contextEnv = new ContextEnvironment(ldapURL, ContextEnvironment.ENCRYPTION_METHOD.DIGEST_MD5);
	}
	public DirContext getUserBindContext(String username, String password)
	{
		return contextEnv.getContext(username, password);
	}

	public NamingEnumeration<SearchResult> search(String username, String password, String contextRoot, String filter, String[] returnAttributes)
	{
		DirContext dirContext = getUserBindContext(username, password);
		if(dirContext != null)
		{
			NamingEnumeration<SearchResult> results = search(dirContext, contextRoot, filter, returnAttributes);
			try 
				{ if(results.hasMore()) return results; }
			catch(NamingException nex)
				{ ErrorLogger.write(nex); }
		}
		return null;
	}
	
	protected NamingEnumeration<SearchResult> search(DirContext dirContext ,String contextRoot, String filter, String[] returnAttributes)
	{
		SearchControls sctrl = new SearchControls();
		sctrl.setSearchScope(SearchControls.SUBTREE_SCOPE);
		
		sctrl.setReturningObjFlag(true);
		sctrl.setReturningAttributes(returnAttributes);
		try 
			{ return dirContext.search(contextRoot, filter, sctrl); }
		catch(NamingException nex)
			{ ErrorLogger.write(nex); }
		return null;
	}
}
