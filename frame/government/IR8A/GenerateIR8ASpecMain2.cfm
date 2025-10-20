<html>
<head>
	<title>Generate IR8A Spec</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	<script>
		function findselected(){
		var selectedval = document.getElementById('generate').value;
		if (selectedval == "ir8a"){
		document.gForm.action = "GenerateIR8A_rep.cfm";
		}
		else{
			document.gForm.action = "GenerateIR8A_rep2.cfm";
		}
	}</script>
	<!--- <script>
		function findselected(){ 
		var generate = document.getElementById('generate'); 
		var toa = document.getElementById('toa'); 
		var tob = document.getElementById('tob'); 
		(generate.value == "ir8a" || generate.value == "all")? toa.disabled=false : toa.disabled=true ;
		(generate.value == "ir8s" || generate.value == "all")? tob.disabled=false : tob.disabled=true
		} 
	</script>  --->
	
</head>

<cfquery name="emp_qry" datasource="#dts#">
SELECT empno FROM pmast 
</cfquery>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type IN ('TAX')
</cfquery>

<body>

<div class="mainTitle">Generate IR8A Spec</div>

<form name="gForm" action="" method="post" target="_blank">
<div class="tabber">
<table class="form">
	<tr>
		<th>Generate</th>
		<td><select name="generate" id="generate"> 
				<option value=""></option> 
				<option value="ir8a" id="">IR8A</option> 
				<option value="ir8s">IR8S</option> 
				<option value="all">ALL</option> 
			</select> 
</td>
	</tr>
	<tr>
		<th>Employee No. From</th>
		<td><select name="empnoFrom">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno#</option>
			</cfoutput>
		</select></td>
	</tr>
	<tr>
		<th>Employee No. To</th>
		<td><select name="empnoTo">
			<option value="">zzzzzz</option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#" >#emp_qry.empno#</option>
			</cfoutput>
		</select> </td>
	</tr>
	<tr>
		<th>TAX Category</th>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<th>Batch Date</th>
		<td><input type="text" name="bdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(bdate);"></td>
	</tr>
	<tr>
		<th>Report Date</th>
		<td><input type="text" name="rdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(rdate);"></td>
	</tr>
	<tr>
		<th>To File (IR8A)</th>
		<td><input type="text" size="40" id="toa" name="toa" value="IR8A.TXT" disabled> </td>
	</tr>
	<tr>	
		<th>To File (IR8S)</th>
		<td>
			<input type="text" size="40" id="tob" name="tob" value="IR8S.TXT" disabled>
		</td>
	</tr>
</table>

<br />
<center>
	<input type="submit" name="save" value="OK" onClick="javascript: findselected();">
	<input type="button" name="exit" value="Exit" onclick="window.location='/government/IR8A/IR8AList.cfm'">
</center>
</div>
</form>
</body>

</html>