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
<%@ page import="java.util.Date" %>

<%@ page import="com.kvartali.Kvartal" %>
<%@ page import="com.kvartali.Opinion" %>
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
    <title>Кварталите на София</title>
	<link rel="stylesheet" href="./css/style.css" type="text/css" />
	<script type="text/javascript" src="./js/jquery-1.3.1.min.js"></script>
	<script type="text/javascript" src="./js/jquery.tablesorter.js"></script>
	<script type="text/javascript" src="./js/jquery.tablesorter.pager.js"></script>
</head>
<body>

<!-- <img src="images/sofia.jpg" class="sofia" style="width:304px;height:228px;"/>
 -->
	Разберете какво мислят хората за вашия квартал. Kvartali.info предлага статистики и мнения за кварталите на София. <br>  <br>
	По население Люлин е сравним с Бургас, Младост с Русе, Красно Село с Добрич, а Подуене със Сливен 
	и това налага нуждата от сравнение на кварталите и добавяне на мнения за тях. 
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

//parsing kvartalite
Kvartal tmp;
int countKvartali = 0;

for (int i =0; i<kvartali_names.size(); i++ ){
	if (syncCache.contains(kvartali_names.get(i))){
		countKvartali++;// Read from cache.
	}
}

syncCache.delete("Хаджи Димитър");

//initial initialization from database because sometimes data is lost.
if (countKvartali < 50) {

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
			opinions.add( new Opinion(kvartali_names.get(i),tmp.opinions.get(k), new Date()) );
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
<br><br>

Моля, напишете мнение за квартала, който оценихте:
<br>

<textarea rows="4" cols="50" name="opinion" form="usrform">
</textarea>
<br /><br />
<input type="submit" class="selected_btn" value="Добави"/>

</form>


<br> Въведени мнения от потребителите: 
<% 

for(int i = 0; i < opinions.size(); i++){ 
%>
<div class="comment" style="display: block;">
				<div class="avatar">					
				</div>
				
				<div class="name"><%="Квартал: " + opinions.get(i).getKvartal() %></div>
				<p><%="Мнение: "+ opinions.get(i).getComment() %> </p>
			</div>
	<%} %>
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