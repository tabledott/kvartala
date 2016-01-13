<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@page pageEncoding="UTF-8" %>

<%@page import="java.util.HashMap"%>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.List" %>

<%@ page import="com.kvartali.Kvartal" %>
<%@ page import="com.kvartali.SampleResults" %>
<%@ page import="com.kvartali.OfyHelper" %>

<%@ page import="java.util.logging.Level" %>

<%@ page import="com.google.appengine.api.memcache.ErrorHandlers" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheService" %>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory" %>

<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.google.appengine.api.log.*" %>

<jsp:directive.page contentType="text/html;charset=UTF-8"
  language="java" isELIgnored="false" />
  
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us">
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Квартали на София</title>
	<link rel="stylesheet" href="./css/style.css" type="text/css" />
	<script type="text/javascript" src="./js/jquery-1.3.1.min.js"></script>
	<script type="text/javascript" src="./js/jquery.tablesorter.js"></script>
	<script type="text/javascript" src="./js/jquery.tablesorter.pager.js"></script>
</head>
<body>

<!-- <img src="images/sofia.jpg" class="sofia" style="width:304px;height:228px;"/>
-->

Идеята на приложението е да се даде оценка на кварталите на София от 2 до 6 и 
да се определи кой е най-предпочитания квартал за живеене <br>  <br> 
	Моля добавяйте повече РЕАЛНИ данни, за да получим реална статистика. Може да сортирате по брой мнения или средна оценка.
	Средната оценка е сумата на всички критерии, разделено на броя им.<br> <br> 
	Ще се радвам на коментари какви критерии да се слагат, на предложения и забележки на ttsonkov [AT] gmail.com <br>
	Под публични сгради се разбират училища, детски градини, болници и и т.н.
	
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
	  <th>Публични сгради</th>
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
BufferedReader br = null;
LinkedList<String> kvartali_names = new LinkedList<String>();
try {

	String sCurrentLine;
	
	br = new BufferedReader(
			   new InputStreamReader(
	                      new FileInputStream("kvartali.txt"), "UTF-8"));

//	br = new BufferedReader(new FileReader("kvartali.txt"));
	int counter = 0;
	while ((sCurrentLine = br.readLine()) != null) {
		kvartali_names.add(sCurrentLine);
	}

}
catch (IOException e) {
	e.printStackTrace();
} finally {
	try {
		if (br != null)br.close();
	} catch (IOException ex) {
		ex.printStackTrace();
	}
}

MemcacheService syncCache = MemcacheServiceFactory.getMemcacheService();
syncCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.SEVERE));

//initial initialization because sometimes data is lost.
/*
SampleResults sample = new SampleResults();
Kvartal[] samples = sample.generateData();
for(int i = 0; i <samples.length; i++){
	syncCache.put(samples[i].getName(), samples[i]);
}
*/

//parsing kvartalite
Kvartal tmp;

	//visualize the data for each Kvartal
	for (int i =0; i<kvartali_names.size(); i++ ){
		
		if (syncCache.contains(kvartali_names.get(i))){
			tmp = (Kvartal) syncCache.get(kvartali_names.get(i)); // Read from cache.
		}
		else{
			tmp = new Kvartal(); //empty kvartal
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


<br> 
Добави оценка за кварталите:
<br><br>

<form accept-charset="UTF-8" action="/addkvartal" method="post">
<select class="kvartal" name="kvartal">
<option value="">Квартал</option>
			<%
			request.setCharacterEncoding( "UTF-8" );			
			response.setCharacterEncoding( "UTF-8" );
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
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="parks" name="parks">
			<option value="">Паркове и зеленина</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="infrastructure" name="infrastructure"">
			<option value="">Инфраструктура</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>

<select class="crime" name="crime"">
			<option value="">Сигурност</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="transport" name="transport"">
			<option value="">Транспорт</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="facilities" name="facilities">
			<option value="">Публични сгради</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>

<select class="buildings" name="buildings">
			<option value="">Сграден фонд</option>
	
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="shops" name ="shops">
			<option value="">Магазини</option>
	
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<br><br>Въведете мнение за квартала, който оценихте:
<br>
<textarea rows="4" cols="50" name="opinion" form="usrform">
</textarea>
<br><br>
<input type="submit" value="Добави"/>

</form>

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
</html>