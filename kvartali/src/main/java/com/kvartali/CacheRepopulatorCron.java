package com.kvartali;

import java.io.IOException;
import java.util.LinkedList;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class CacheRepopulatorCron extends HttpServlet{
	private static final long serialVersionUID = 1L;

	// Process the http POST of the form
	  @Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		  
		final Logger LOG = Logger.getLogger(AddKvartalServlet.class.getName());
		MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));

		
		FileReaderSite tmpReader = new FileReaderSite();
		LinkedList<String> kvartali_names = new LinkedList<String>();
		kvartali_names = tmpReader.readListFromFile("kvartali.txt");

		LOG.warning("Running cron repopulator!");

		for(int i = 0; i<kvartali_names.size(); i++){
			if (syncCache.contains(kvartali_names.get(i))){
			}
			else{
				// Getting the information from the database
				Key<Kvartal> getKvartalKey = Key.create(Kvartal.class, kvartali_names.get(i));
		    	Kvartal next = 	ObjectifyService.ofy()
						.load().type(Kvartal.class).filterKey(getKvartalKey).first().now();
		    	
		    	if(next == null){
		    		next = new Kvartal();
		    		next.setName(kvartali_names.get(i));
		    	}
				syncCache.put(kvartali_names.get(i), next);
			}

		}
	  }
}
