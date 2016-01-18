package com.kvartali;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.memcache.ErrorHandlers;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.memcache.MemcacheService;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class AddInfoKvartalServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	// Process the http POST of the form
	  @Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		  	
		  	String kvartalName = req.getParameter("kvartal");
		    resp.sendRedirect("/kvartal.jsp?name="+kvartalName);
	  }

}
