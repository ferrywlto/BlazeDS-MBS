package com.grandtech.ldap.mbs;

import java.util.Vector;

import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchResult;

import com.grandtech.ldap.ErrorLogger;

public class ResultPackager 
{
	protected ResultPackager(){}
	public static String[] packResultForAS3Remoting(NamingEnumeration<SearchResult> namingEnum)
	{
		try
		{
			ErrorLogger.write("[Return]");
			Vector<String> results = new Vector<String>();
			while (namingEnum.hasMore()) 
			{
				SearchResult sr = (SearchResult) namingEnum.next();
				Attributes attributes = sr.getAttributes();

				NamingEnumeration<? extends Attribute> attrs = attributes.getAll();
				ErrorLogger.write("\t [result]");
				Vector<String> resultStr = new Vector<String>();
	        	while(attrs.hasMore())
	        	{
	        		Attribute attrX = (Attribute)attrs.next();
	        		if(attrX.size() == 1)
	        		{
		        		String value = (String)attrX.get();
		        		resultStr.add(attrX.getID()+":"+value);
		        		ErrorLogger.write("\t\t[value]"+attrX.getID()+":"+value);
	        		}
	        		else if(attrX.size()>1)
	        		{
	        			NamingEnumeration multivalues = attrX.getAll();
	        			while(multivalues.hasMore())
	        			{
	        				String value = (String)multivalues.next();
	        				resultStr.add(attrX.getID()+":"+value);
	        				ErrorLogger.write("\t\t[multivalue]"+attrX.getID()+":"+value);
	        			}
	        		}
	        	}
	        	if(resultStr.size()> 1)
	        	{
	        		String str = resultStr.get(0);
	        		for(int i=1; i<resultStr.size(); i++)
	        		{
	        			str += ","+resultStr.get(i);
	        		}
	        		results.add(str);
	        	}
	        	else if(resultStr.size() == 1)
	        	{
	        		results.add(resultStr.get(0));
	        	}
	        	ErrorLogger.write("\t[result end]");
			}
			namingEnum.close();
			ErrorLogger.write("[End Return]");
	        return results.toArray(new String[results.size()]);
        }
		catch(NamingException nex)
		{
			ErrorLogger.write(nex);
			nex.printStackTrace();
			return null;
		}
	}
}
