<%@ page import="com.kvartali.Kvartal" %>
<%@ page import="com.kvartali.Opinion" %>
<%@ page import="com.kvartali.OpinionObject" %>
<%@ page import="com.kvartali.OfyHelper" %>
<%@ page import="com.kvartali.FileReaderSite" %>

<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
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
    
<div id="SelectorKvartal">   
<center>
 <b> Моля, изберете квартал </b>
    
  <form accept-charset="UTF-8" action="/addinfokvartal" method="post">  

	<select class="kvartal" name="kvartal">
	
		<% 		request.setCharacterEncoding( "UTF-8" );			
				response.setHeader("Content-Encoding", "utf-8");
				
			    String kvartalName = "";
				FileReaderSite tmpReader = new FileReaderSite();
				LinkedList<String> kvartali_names = new LinkedList<String>();
			    MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
			    syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));
				final Logger LOG = Logger.getLogger(Kvartal.class.getName());

			    if(request.getParameter("kvartal") != null){
			    	session.setAttribute("kvartal", (String)request.getParameter("kvartal"));
			    }
			    
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
			    
			    Random rand = new Random();			  
				int randKvartal = rand.nextInt((kvartali_names.size()));

				if(session.getAttribute("kvartal") == null) {	
					 while 	(!syncCache.contains(kvartali_names.get(randKvartal))){
						 randKvartal = rand.nextInt(kvartali_names.size());
					 }
					 kvartalName = kvartali_names.get(randKvartal);
					 session.setAttribute("kvartal", kvartalName);
				}
				else{
					kvartalName = (String)session.getAttribute("kvartal");
				}
				%>
				
			  	<option value="<%=kvartalName%>" selected><%=kvartalName%></option>
				<% 
				for(int i = 0; i < kvartali_names.size(); i++) {
				%> 
					<option value="<%=kvartali_names.get(i)%>"> <%=kvartali_names.get(i)%> </option> 
				<% }%>			
		
		</select>

<input type="submit" class="selected_btn" value="Избери"/>
</center>
</form>
		
</div>

<!-- Аdding specific information about kvartal -->

<div id="Evaluator">
<center>
<b> Въведете информация за обектите или специалистите в квартала Ви</b>

<form accept-charset="UTF-8" action="/addinfokvartal" method="post">		
<select class="category" name="category">
<option value="">Категория</option>
		<%
		tmpReader = new FileReaderSite();
		LinkedList<String> category_names = tmpReader.readListFromFile("categories.txt");
		for(int i = 0; i < category_names.size(); i++){
		%>	
			<option value="<%=category_names.get(i)%>"><%=category_names.get(i)%></option>
		<%} %>
		
</select>
<input type="hidden" name="kvartal" value="<%=session.getAttribute("kvartal")%>">

<br />
  Име на обекта<br>
  <input type="text" size="35" name="objectName"><br />
 
<select class="evaluation" name="evaluation">
			<option value="">Оценка</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>	
</select>

<br />
Моля, въведете мнение за обекта, който оценихте:
<br>

<textarea  class="opinion" rows="4" cols="50" name="opinion">
</textarea>
<br /><br />
<input type="submit" class="selected_btn" value="Добави оценките и мнението"/>
</center>
<br />
</form>

</div>

    <%
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

<div id="sortedtable">
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
</div>

<div id="opinions" class="opinions">
	<b> Въведени мнения от потребителите: </b> 
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
	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=firstOpinion%></p>
		        		</div>
	        		</div>
	        		<%if(secondOpinion.length()>0) {%>
	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=secondOpinion%></p>
		        		</div>
	        		</div>
	        		<%} %>
	        		<%if(thirdOpinion.length()>0){%>
	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%=thirdOpinion%></p>
		        		</div>
	        		</div>
	        		<%} %>
	        	</div>
	        </div>
	    </div>

<% } %>
	
	<%
	Key<Kvartal> getKvartalKey = Key.create(Kvartal.class, kvartalName);
	System.out.println("Kvartal: "+ kvartalName);
	
	List<OpinionObject> opinionObjects = ObjectifyService.ofy()
			.load().type(OpinionObject.class).ancestor(getKvartalKey).list();
	
	if (opinionObjects == null){
		opinionObjects = new LinkedList<OpinionObject>();
	}
	
	OpinionObject firstOpinionObject = null;
	OpinionObject secondOpinionObject = null;
	OpinionObject thirdOpinionObject = null;

	for(int i = 0; i < opinionObjects.size(); i+=3){ 
		firstOpinionObject = opinionObjects.get(i);
		
		if( i < opinionObjects.size() - 1) {
			secondOpinionObject = opinionObjects.get(i+1);
		}
		
		if( i < opinionObjects.size() - 2) {
			thirdOpinionObject = opinionObjects.get(i+2);
		}
	%>
	
	<div class="section">
	        <div class="container">
	        	<div class="row">

	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=kvartalName%></h3>
		        			<p><%="Име на обекта: "+ firstOpinionObject.name%></p>
		        			<p><%="Категория: "+ firstOpinionObject.getBusinessCategory()%></p>
		        			<p><%="Оценка: "+ firstOpinionObject.getMark()%></p>
		        			<% for (String s: firstOpinionObject.getOpinions()) {%>		        
		        			<p><%="Мнение: "+ s%></p>		        			 
		        			<%}%>       
		        		</div>
	        		</div>

	        		<%if(secondOpinionObject!=null) {%>
	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%="Име на обекта: "+ secondOpinionObject.name%></p>
		        			<p><%="Категория: "+secondOpinionObject.getBusinessCategory()%></p>	
		        			<p><%="Оценка: "+ secondOpinionObject.getMark()%></p>
		        			<% for (String s: secondOpinionObject.getOpinions()) {%>		        
		        			<p><%="Мнение: "+ s%></p>		        			 
		        			<%}%>       
		        				        		
		        		</div>
	        		</div>
	        		<%} %>
	        		<%if(thirdOpinionObject!=null){%>
	        		<div class="col-md-3 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=next.getName()%></h3>
		        			<p><%="Име на обекта: "+ thirdOpinionObject.name%></p>
		        			<p><%="Категория:" + thirdOpinionObject.getBusinessCategory()%></p>		
		        			<p><%="Оценка: "+ thirdOpinionObject.getMark()%></p>
		        			<% for (String s: thirdOpinionObject.getOpinions()) {%>		        
		        			<p><%="Мнение: "+ s%></p>		        			 
		        			<%}%>       
		        		</div>
	        		</div>
	        		<%} %>
	        	</div>
	        </div>
	    </div>
	<%} %>	
</div>

<script defer="defer">
	
	$(document).ready(function() 
    { 
        $("#insured_list")
		.tablesorter({widthFixed: true, widgets: ['zebra']})
		.tablesorterPager({container: $("#pager")}); 
    } 
	); 
</script>

<script type="text/javascript">
    $(document).ready(function() {
        $("#selection").change(function() {
            location = $("#selection option:selected").val();
        });
    });
	</script>
			
	
     <jsp:include page="footer.jsp" />
    
</html>