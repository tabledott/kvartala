<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@page pageEncoding="UTF-8" %>

<%@page import="java.util.HashMap"%>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>

<%@ page import="com.kvartali.Kvartal" %>
<%@ page import="com.kvartali.Opinion" %>
<%@ page import="com.kvartali.SampleResults" %>
<%@ page import="com.kvartali.OfyHelper" %>
<%@ page import="com.kvartali.FileReaderSite" %>


<%@ page import="java.util.logging.Level" %>

<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>
<%@ page import="com.google.appengine.api.log.*" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.google.appengine.api.log.*" %>
<%@ page import="java.util.logging.Logger" %>

<jsp:directive.page contentType="text/html;charset=UTF-8"
  language="java" isELIgnored="false" />
  
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>kvartali.info - Всичко за Вашия квартал!</title>
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
		<script type="text/javascript" src="./js/jquery-1.3.1.min.js"></script>
		<script type="text/javascript" src="./js/jquery.tablesorter.js"></script>
		<script type="text/javascript" src="./js/jquery.tablesorter.pager.js"></script>
		
        <script src="./js/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    </head>
<body>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- kvartali.info -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-9935344527344739"
     data-ad-slot="9429895603"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>

<jsp:include page="header.jsp" />

 <center>	
 	Разберете какво мислят хората за вашия квартал. Kvartali.info предлага статистики и мнения за кварталите на София. <br>  <br>
</center>

	
<form accept-charset="UTF-8" action="/kvartali.jsp" method="get">	
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
<%
request.setCharacterEncoding( "UTF-8" );
response.setCharacterEncoding( "UTF-8" );
//get the names from the text file.
FileReaderSite tmpReader = new FileReaderSite();
LinkedList<String> kvartali_names = tmpReader.readListFromFile("kvartali.txt");

MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));

//parsing kvartalite
Kvartal tmp;
int countKvartali = 0;

for (int i =0; i<kvartali_names.size(); i++ ){
	if (syncCache.contains(kvartali_names.get(i))){
		countKvartali++;// Read from cache.
	}
}

//syncCache.delete("Полигона");

//initial initialization from database because sometimes data is lost.
if (countKvartali < 50) {
    final Logger LOG = Logger.getLogger(Kvartal.class.getName());
    
	List<Kvartal> kvartali = ObjectifyService.ofy()
		.load()
		.type(Kvartal.class).list(); // Taking all kvartali from the database!

		//we assume the database has the correct results!
		for(int i =0; i < kvartali.size(); i++){

			if(kvartali.get(i).getName()!=null){
				syncCache.put(kvartali.get(i).getName(), kvartali.get(i));
			}
		}

		/*
		List<Opinion> opinions = ObjectifyService.ofy()
				.load()
				.type(Opinion.class).list(); // Taking all opinions from the database!

	syncCache.put("opinions", opinions); //update cache
	*/
	//not including samples
	/*
	SampleResults sample = new SampleResults();
	Kvartal[] samples = sample.generateData();
	for(int i = 0; i <samples.length; i++){
		syncCache.put(samples[i].getName(), samples[i]);
	}
	*/
}

LinkedList<Opinion> opinions  = new LinkedList<Opinion>();

//visualize the data for each Kvartal
	for (int i =0; i<kvartali_names.size(); i++ ){
		
		if (syncCache.contains(kvartali_names.get(i))){
			tmp = (Kvartal) syncCache.get(kvartali_names.get(i)); 
		}
		else{
			tmp = new Kvartal(); //empty kvartal
		}
		for(int k = 0; k < tmp.opinions.size(); k++){
			if( tmp.opinions.get(k).length() > 12){
				opinions.add( new Opinion(kvartali_names.get(i),tmp.opinions.get(k), new Date()) );
			}
		}
		double[] averages = tmp.returnStatistics();
%>

<tr> 
    <td><%=kvartali_names.get(i)%></td> 
    <% for(int j = 0; j<tmp.NUMBER_STATISTICS; j++) {%>
    <td><%=averages[j]%></td>
  	<% }%>
    
    <td><%=tmp.allStatistics%></td>
	<% }%>
</tr> 

</tbody> 
</table> 
</form>
<center>
	<div id="pager" class="pager">
	<form accept-charset="UTF-8">
		<img src="images/first.png" class="first"/>
		<img src="images/prev.png" class="prev"/>
		<input type="text" class="pagedisplay"/>
		<img src="images/next.png" class="next"/>
		<img src="images/last.png" class="last"/>
		<select class="pagesize">
			<option value="5">5 на страница</option>
			<option value="10" selected="selected">10 на страница</option>
			<option value="20">20 на страница</option>
			
		</select>
	</form>
</div>

</center>

<br> 
<center>
Добави оценка за кварталите:
<br><br>

<form accept-charset="UTF-8" action="/addkvartal" method="post">

<select class="kvartal" name="kvartal">
<option value="">Квартал</option>
			<%
			request.setCharacterEncoding( "UTF-8" );			
			response.setHeader("Content-Encoding", "utf-8");
			
			for(int i = 0; i < kvartali_names.size(); i++) {
					%> 
					<option value="<%=kvartali_names.get(i)%>"> <%=kvartali_names.get(i)%> </option> 
					<%
				}
				
		%>		
</select>

<select class="location" name="location">
			<option value="">Местоположение</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>	
</select>
<select class="parks" name="parks">
			<option value="">Паркове и зеленина</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>
<select class="infrastructure" name="infrastructure"">
			<option value="">Инфраструктура</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>

<select class="crime" name="crime"">
			<option value="">Сигурност</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>
<select class="transport" name="transport"">
			<option value="">Транспорт</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
	
</select>
<select class="facilities" name="facilities">
			<option value="">Учреждения</option>
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>

<select class="buildings" name="buildings">
			<option value="">Сграден фонд</option>
	
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>
<select class="shops" name ="shops">
			<option value="">Магазини</option>
	
			<% for(int k = 2; k<=6; k++) { %> 
			<option value="<%=k%>"><%=k%></option>
			<%} %>
</select>

</center>
<br><br>

<center>
Моля, въведете мнение за квартала, който оценихте:
<br>

<textarea  class="opinion" rows="4" cols="50" name="opinion">
</textarea>
<br /><br />
<input type="submit" class="selected_btn" value="Добави оценките и мнението"/>

</form>
</center>


<br> 
<center>
Въведени мнения от потребителите: 
</center>
<br> 

<% 
Opinion firstOpinion = new Opinion();
Opinion secondOpinion = new Opinion();
Opinion thirdOpinion = new Opinion();

for(int i = 0; i < opinions.size(); i+=3){ 
	firstOpinion = opinions.get(i);
	
	if( i < opinions.size() - 1) {
		secondOpinion = opinions.get(i+1);
	}
	else{
		secondOpinion = new Opinion();
	}
	
	if( i < opinions.size() - 2) {
		thirdOpinion = opinions.get(i+2);
	}
	else{
		thirdOpinion = new Opinion();
	}
%>

<div class="section">
	        <div class="container">
	        	<div class="row">
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=firstOpinion.getKvartal()%></h3>
		        			<p><%=firstOpinion.getComment()%></p>
		        		</div>
	        		</div>
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=secondOpinion.getKvartal()%></h3>
		        			<p><%=secondOpinion.getComment()%></p>
		        		</div>
	        		</div>
	        		<div class="col-md-4 col-sm-6">
	        			<div class="service-wrapper">
		        			<h3><%=thirdOpinion.getKvartal()%></h3>
		        			<p><%=thirdOpinion.getComment()%></p>
		        		</div>
	        		</div>
	        	</div>
	        </div>
	    </div>

<% } %>
	
<script defer="defer">
	$(document).ready(function() 
    { 
        $("#insured_list")
		.tablesorter({widthFixed: true, widgets: ['zebra']})
		.tablesorterPager({container: $("#pager")}); 
    } 
	); 
</script>
</body>

<jsp:include page="footer.jsp" />


</html>