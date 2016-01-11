package com.kvartali;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

public class AddKvartalServlet extends HttpServlet {

	  // Process the http POST of the form
	  @Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    Kvartal kvartal;

	/*    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();  // Find out who the user is.
*/

	    String name = req.getParameter("kvartal");
	    if(name == null) { name = "";}
	    
	    short location = 0;
	    if (req.getParameter("location")!=null&& req.getParameter("location").length()>0){
	    	location = Short.parseShort(req.getParameter("location"));
	    }
	    short parks = 0;
	    if (req.getParameter("parks")!=null&& req.getParameter("parks").length()>0){
	    	parks = Short.parseShort(req.getParameter("parks"));
	    }
	    short crime = 0;
	    if (req.getParameter("crime")!=null&& req.getParameter("crime").length()>0){
	    	crime = Short.parseShort(req.getParameter("crime"));
	    }
	    
	    short infrastructure = 0;
	    if (req.getParameter("infrastructure")!=null&& req.getParameter("infrastructure").length()>0){
	    	infrastructure = Short.parseShort(req.getParameter("infrastructure"));
	    }
	    
	    short transport = 0;
	    if (req.getParameter("transport")!=null&& req.getParameter("transport").length()>0){
	    	transport = Short.parseShort(req.getParameter("transport"));
	    }

	    short facilities = 0;
	    if (req.getParameter("facilities")!=null && req.getParameter("facilities").length()>0){
	    	facilities = Short.parseShort(req.getParameter("facilities"));
	    }
	 
	    short shops = 0;
	    if (req.getParameter("shops")!=null && req.getParameter("shops").length()>0){
	    	shops = Short.parseShort(req.getParameter("shops"));
	    }
	    
	    short buildings = 0;
	    if (req.getParameter("buildings")!=null && req.getParameter("buildings").length()>0){
	    	buildings = Short.parseShort(req.getParameter("buildings"));
	    }

		  String opinion = req.getParameter("opinion");
		    if(opinion == null) { opinion = "";}
		    
		    kvartal = new Kvartal(name,  location, parks,  crime,
		    				 transport,  infrastructure, facilities,  buildings,  shops, opinion);
	    // Use Objectify to save the greeting and now() is used to make the call synchronously as we
	    // will immediately get a new page using redirect and we want the data to be present.
	    ObjectifyService.ofy().save().entity(kvartal).now();

	    resp.sendRedirect("/kvartali.jsp");
	  }

}
