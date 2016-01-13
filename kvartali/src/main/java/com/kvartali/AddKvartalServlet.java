package com.kvartali;

import java.io.IOException;
import java.util.logging.Level;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.memcache.MemcacheService;
import com.googlecode.objectify.ObjectifyService;

public class AddKvartalServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	// Process the http POST of the form
	  @Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    	    
		req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html; charset=utf-8");
		
	    String name = req.getParameter("kvartal");
	    if(name == null) { name = "";}
	    
	    byte location = 0;
	    if (req.getParameter("location")!=null&& req.getParameter("location").length()>0){
	    	location = Byte.parseByte(req.getParameter("location"));
	    }
	    byte parks = 0;
	    if (req.getParameter("parks")!=null&& req.getParameter("parks").length()>0){
	    	parks = Byte.parseByte(req.getParameter("parks"));
	    }
	    
	    byte crime = 0;
	    if (req.getParameter("crime")!=null&& req.getParameter("crime").length()>0){
	    	crime = Byte.parseByte(req.getParameter("crime"));
	    }
	    
	    byte infrastructure = 0;
	    if (req.getParameter("infrastructure")!=null&& req.getParameter("infrastructure").length()>0){
	    	infrastructure = Byte.parseByte(req.getParameter("infrastructure"));
	    }
	    
	    byte transport = 0;
	    if (req.getParameter("transport")!=null&& req.getParameter("transport").length()>0){
	    	transport = Byte.parseByte(req.getParameter("transport"));
	    }

	    byte facilities = 0;
	    if (req.getParameter("facilities")!=null && req.getParameter("facilities").length()>0){
	    	facilities = Byte.parseByte(req.getParameter("facilities"));
	    }
	 
	    byte shops = 0;
	    if (req.getParameter("shops")!=null && req.getParameter("shops").length()>0){
	    	shops = Byte.parseByte(req.getParameter("shops"));
	    }
	    
	    byte buildings = 0;
	    if (req.getParameter("buildings")!=null && req.getParameter("buildings").length()>0){
	    	buildings = Byte.parseByte(req.getParameter("buildings"));
	    }

		  String opinion = req.getParameter("opinion");
		    if(opinion == null) { opinion = "";}		      
		    
		    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
		    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));
		    Kvartal next = (Kvartal) syncCache.get(name); // Read from cache.
		  
		    if (next == null) {
		    	next = new Kvartal();
		    }
		    
		    next.addKvartal(name, location, parks, crime, transport, infrastructure, facilities, buildings, shops, opinion);
		    syncCache.put(name, next); // Populate cache.
		 
		    // Add to the database
		    ObjectifyService.ofy().save().entity(next).now();

		    /*
		    SampleResults tmp = new SampleResults();
		    Kvartal[] kvartals = tmp.generateData();
		    for( int i = 0; i < kvartals.length; i++){
		    // Add to the database
		    	next = kvartals[i];
		    	//System.out.println("Writing in the database: " + next.getName());
		    	ObjectifyService.ofy().save().entity(next).now();
		    }
		    */
		    resp.sendRedirect("/kvartali.jsp");

	  }

}
