<%@ page import="com.kvartali.Kvartal" %>
<%@ page import="com.kvartali.Opinion" %>
<%@ page import="com.kvartali.SampleResults" %>
<%@ page import="com.kvartali.OfyHelper" %>
<%@ page import="com.kvartali.FileReaderSite" %>

<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Random" %>

<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.logging.Level" %>
<%@ page import="java.util.logging.Logger" %>


<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>kvartali.info</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">

        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/icomoon-social.css">
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700,600,800' rel='stylesheet' type='text/css'>

        <link rel="stylesheet" href="css/leaflet.css" />
		<!--[if lte IE 8]>
		    <link rel="stylesheet" href="css/leaflet.ie.css" />
		<![endif]-->
		<link rel="stylesheet" href="css/main.css">
		<link rel="stylesheet" href="./css/style.css" type="text/css" />
    </head>
    <jsp:include page="header.jsp" />
    
    <body>
        <!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->
    </body>
    

    <center> <b> Моля, изберете квартал </b>
    
    <form accept-charset="UTF-8" onsubmit="kvartal.jsp" method="post">
	<select class="kvartal" name="kvartal">
	<option value="">Квартал</option>
		<% 		request.setCharacterEncoding( "UTF-8" );			
				response.setHeader("Content-Encoding", "utf-8");
				
				FileReaderSite tmpReader = new FileReaderSite();
				LinkedList<String> kvartali_names = new LinkedList<String>();
				
				if(session.getAttribute("kvartali_names") == null){
					kvartali_names = tmpReader.readListFromFile("kvartali.txt");
					session.setAttribute("kvartali_names", kvartali_names);
				}
				else 
				{
					try{
						kvartali_names = (LinkedList<String>) session.getAttribute("kvartali_names");
					}
					catch (Exception ex){
						kvartali_names = tmpReader.readListFromFile("kvartali.txt");
					}
				}
				for(int i = 0; i < kvartali_names.size(); i++) {
				%> 
					<option value="<%=kvartali_names.get(i)%>"> <%=kvartali_names.get(i)%> </option> 
				<% }%>			
		
		</select>
	<input type="submit" class="selected_btn" value="Избери"/>
</form>
</center>
		
    <%
	    Random rand = new Random();
    	int randKvartal = rand.nextInt((kvartali_names.size()));
	    String kvartalName = "";
	    
	    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
	    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));

	    if(request.getParameter("kvartal") != null){
	    	session.setAttribute("kvartal", (String)request.getParameter("kvartal"));
	    }
	    
		if(session.getAttribute("kvartal") == null) {	
			 while 	(!syncCache.contains(kvartali_names.get(randKvartal))){
				 randKvartal = rand.nextInt(kvartali_names.size());
			 }
			 kvartalName = kvartali_names.get(randKvartal);
		}
		else{
			kvartalName = (String)session.getAttribute("kvartal");
		}
		final Logger LOG = Logger.getLogger(Kvartal.class.getName());
		
	    Kvartal next = (Kvartal) syncCache.get(kvartalName); // Read from cache.
	    if(next == null){  //no info in cache so try to load from database
	    	
	    	if(session.getAttribute(kvartalName)!= null) {
	    		next = (Kvartal)session.getAttribute(kvartalName);
	    	}
	    	else{
		    	Key<Kvartal> getKvartalKey = Key.create(Kvartal.class, kvartalName);
		    	next = 	ObjectifyService.ofy()
						.load().type(Kvartal.class).filterKey(getKvartalKey).first().now();
		    	
		    	if(next == null){
		    		next = new Kvartal();
		    		next.setName(kvartalName);
		    	}

	    	}
    	} 
		
		double[] stats = next.returnStatistics();
 	 %>   		    		

<form>	
<table id="insured_list" class="tablesorter"> 
<thead> 
<tr> 
       <th>Квартал</th>
	  <th>Местоположение</th>      
	  <th>Паркове, зеленина</th>
	  <th>Сигурност</th>
	  <th>Инфраструктура</th>
	  <th>Транспорт</th>
	  <th>Учреждения</th>
	  <th>Сграден фонд</th>
	  <th>Магазини</th>
	  <th>Средна оценка</th>
	  <th>Брой мнения</th>
</tr> 
</thead> 
<tbody> 

<tr> 
    <td><%=next.getName()%></td> 
    <% for(int j = 0; j<next.NUMBER_STATISTICS; j++) {%>
    <td><%=stats[j]%></td>
  	<% }%>
    
    <td><%=next.allStatistics%></td>
	
</tr> 
</tbody> 
</table> 
</form>

<center>
	<b> Въведени мнения от потребителите: </b> 
</center>
<br> 

<% 
String firstOpinion = "";
String secondOpinion ="";
String thirdOpinion = "";

for(int i = 0; i < next.opinions.size(); i+=3){ 
	firstOpinion = next.opinions.get(i);
	
	if( i < next.opinions.size() - 1) {
		secondOpinion = next.opinions.get(i+1);
	}
	
	if( i < next.opinions.size() - 2) {
		thirdOpinion = next.opinions.get(i+2);
	}
%>

<div class="section">
	        <div class="container">
	        	<div class="row">
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=firstOpinion%></p>
		        		</div>
	        		</div>
	        		<%if(secondOpinion.length()>0) {%>
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=secondOpinion%></p>
		        		</div>
	        		</div>
	        		<%} %>
	        		<%if(thirdOpinion.length()>0){%>
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=thirdOpinion%></p>
		        		</div>
	        		</div>
	        		<%} %>
	        	</div>
	        </div>
	    </div>

<% }%>
	
	<script defer="defer">
	$(document).ready(function() 
    { 
        $("#insured_list")
		.tablesorter({widthFixed: true, widgets: ['zebra']})
		.tablesorterPager({container: $("#pager")}); 
    } 
	); 
</script>
			
	
     <jsp:include page="footer.jsp" />
    
</html>