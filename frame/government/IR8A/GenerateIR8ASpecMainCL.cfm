<html>
<head>
	<title>Generate IR8A Spec</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	
</head>

<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT empno,name FROM pmast where year(dresign) = "#getComp_qry.myear#" or dresign is null or dresign ="0000-00-00" order by empno 
</cfquery>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type IN ('TAX')
</cfquery>

<body>

<div class="mainTitle">Crimson Logic Report</div>

<cfform name="gForm" action="/government/IR8A/crimsonIR8A_html.cfm" method="post" target="_blank" >
<div class="tabber">
<table class="form">

	<tr>
		<th>Employee No. From</th>
		<td><select name="empnoFrom">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#" name="empnoFrom">#emp_qry.empno# - #emp_qry.name#</option>
			</cfoutput>
		</select></td>
	</tr>
	<tr>
		<th>Employee No. To</th>
		<td><select name="empnoTo">
			<option value="">zzzzzz</option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#" name="empnoTo">#emp_qry.empno# - #emp_qry.name#</option>
			</cfoutput>
		</select> </td>
	</tr>
	<tr>
		<th>TAX Category</th>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#" >#cpf_qry.category#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
  	<tr>
		  <th>Exclude 0 Figure</th>
		  <td><input type="checkbox" name="exclude0" id="exclude0" value="yes" checked /></td>
    </tr>

</table>

<br />
<center>
	<input type="submit" name="report" value="OK" >
</center>
</div>
</cfform>
</body>

</html>