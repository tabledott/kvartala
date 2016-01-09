
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page pageEncoding="UTF-8" %>

<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.LinkedList" %>


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

Оценка на кварталите и селата покрай София от 2 до 6, където 2 е най-лоша възможна оценка, а 6 най-добра. <br>  <br> 
	Моля добавяйте повече РЕАЛНИ данни, за да получим реална статистика. <br> <br> 
	Ще се радвам на коментари какви критерии да се слагат, на предложения и забележки на ttsonkov [AT] gmail.com
	
	
<table id="insured_list" class="tablesorter"> 
<thead> 
<tr> 
       <th>Квартал</th>
	  <th>Местоположение</th>      
	  <th>Паркове, зеленина</th>
	  <th>Престъпност</th>
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
<tr> 
    <td>Младост</td> 
    <td>3</td>
	<td>3</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>	
	<td>5.4</td>		
	<td>10</td>	
</tr> 
<tr> 
    <td>Младост2</td> 
    <td>3</td>
	<td>3</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>			
	<td>4.4</td>
	<td>10</td>	
</tr> 
<tr> 
    <td>Младост3</td> 
    <td>3</td>
	<td>3</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>
	<td>3.4</td>	
	<td>10</td>	
</tr> 
<tr> 
    <td>Младост4</td> 
    <td>3</td>
	<td>2</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>	
	<td>4.2</td>	
	<td>11</td>	
</tr> 
<tr> 
    <td>Кръстова вада</td> 
    <td>1</td>
	<td>2</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>	
	<td>4.3</td>	
	<td>10</td>	
</tr> 
<tr> 
    <td>Люлин</td> 
    <td>5</td>
	<td>3</td>	
	<td>3</td>
	<td>4</td>	
	<td>3</td>
	<td>6</td>
	<td>4</td>
	<td>6</td>	
	<td>5.5</td>	
	<td>10</td>	
</tr> 
</tbody> 
</table> 
<div id="pager" class="pager">
	<form>
		<img src="images/first.png" class="first"/>
		<img src="images/prev.png" class="prev"/>
		<input type="text" class="pagedisplay"/>
		<img src="images/next.png" class="next"/>
		<img src="images/last.png" class="last"/>
		<select class="pagesize">
			<option value="5">5 per page</option>
			<option value="10">10 per page</option>
			<option value="20">20 per page</option>
			
		</select>
	</form>
</div>


<br> 
Добави оценка за кварталите:
<br><br>
<select class="kvartal">
<option value="">Квартал</option>
			<%
			LinkedList<String> kvartali = new LinkedList<String>();
			
			BufferedReader br = null;
			try {

				String sCurrentLine;

				br = new BufferedReader(new FileReader("kvartali.txt"));
				int counter = 0;
				while ((sCurrentLine = br.readLine()) != null) {
					//<option value="5">Младост</option>
					%> 
					<option value="<%=counter %>"> <%=sCurrentLine%> </option> 
					<%
					counter++;
					//kvartali.add(sCurrentLine);
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
			
		%>		
</select>

<select class="location">
			<option value="">Местоположение</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="nature">
			<option value="">Паркове и зеленина</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="infrastructure">
			<option value="">Инфраструктура</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="transportation">
			<option value="">Транспорт</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="shops">
			<option value="">Публични сгради</option>
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>

<select class="buildings">
			<option value="">Сграден фонд</option>
	
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>
<select class="shops">
			<option value="">Магазини</option>
	
			<option value="2">2</option>
			<option value="3">3</option>		
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>	
</select>

<button type="button" onclick="location = 'insert.jsp'" >Добави квартала</button>


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