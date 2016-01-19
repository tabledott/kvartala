package com.kvartali;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class AddInfoKvartalServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	// Process the http POST of the form
	  @Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		  	
		  	String kvartalName = req.getParameter("kvartal");
		  	if(kvartalName == null){
		  		kvartalName = (String)req.getSession(false).getAttribute("kvartal");
		  	}
		  	
		  	String objectName = req.getParameter("objectName");
		  	if(objectName == null || objectName.length() ==0){
		  		objectName = "invalid";
		  	}
		  		
		  	String category = req.getParameter("category");
		  	String address = req.getParameter("objectAddress");
		  	String opinion = req.getParameter("opinion");
		  	byte evaluation = 0;
		  	
		    if (req.getParameter("evaluation")!=null&& req.getParameter("evaluation").length()>0){
		    	evaluation = Byte.parseByte(req.getParameter("evaluation"));
		    }

	    	Key<Kvartal> getKvartalKey = Key.create(Kvartal.class, kvartalName);
	    	Key<OpinionObject> getOpinionObjectKey = Key.create(OpinionObject.class, objectName);
	    	
	    	OpinionObject nextObject;

	    	nextObject = ObjectifyService.ofy()
					.load().type(OpinionObject.class).ancestor(getKvartalKey).filterKey(getOpinionObjectKey).first().now();
	    	
	    	if(nextObject == null){
	    		nextObject = new OpinionObject();
	    	}
		    
	    	nextObject.AddOpinionObject(objectName, category, address, opinion, evaluation);
	    	
		    ObjectifyService.ofy().save().entity(nextObject).now(); //Update DB
		  	
		    resp.sendRedirect("/kvartal.jsp?kvartal="+kvartalName);
	  }

}
