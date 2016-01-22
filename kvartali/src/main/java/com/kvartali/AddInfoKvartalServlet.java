package com.kvartali;

import java.io.IOException;
import java.util.List;
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
		  		kvartalName = (String)req.getSession(true).getAttribute("kvartal");
		  	}
		  	
		  	String objectName = req.getParameter("objectName");
		  	if(objectName == null || objectName.length() ==0){
				req.getSession(true).setAttribute("kvartal", kvartalName);
			    resp.sendRedirect("/kvartal.jsp");
			    return;
		  	}
		  		
		  	String category = req.getParameter("category");
		  	if(category == null){
		  		category = "";
		  	}

		  	String opinion = req.getParameter("opinion");
		  	byte evaluation = 0;
		  	
		    if (req.getParameter("evaluation")!=null&& req.getParameter("evaluation").length()>0){
		    	evaluation = Byte.parseByte(req.getParameter("evaluation"));
		    }

	    	Key<Kvartal> getKvartalKey = Key.create(Kvartal.class, kvartalName);
	    	Key<OpinionObject> getOpinionObjectKey = Key.create(OpinionObject.class, objectName);
	    	
	    	OpinionObject nextObject = null;

	    	nextObject = ObjectifyService.ofy()
					.load().type(OpinionObject.class).filterKey(getOpinionObjectKey).first().now();
	    	
	    	if(nextObject == null){
	    		nextObject = new OpinionObject(getKvartalKey, objectName);
	    	}
		    
	    	//no address as of now
	    	nextObject.AddOpinionObject(objectName, category, "", opinion, evaluation);    	
		    ObjectifyService.ofy().save().entity(nextObject).now(); //Update DB
		    			
			req.getSession(true).setAttribute("kvartal", kvartalName);
			
		    resp.sendRedirect("/kvartal.jsp");
	  }

}
