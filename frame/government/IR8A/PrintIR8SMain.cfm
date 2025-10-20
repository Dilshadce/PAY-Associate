<html>
<head>
	<title>Print IR8S</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
</head>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type IN ('TAX')
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT *
FROM pmast where confid >= #hpin#
order by empno
</cfquery>

<body>

<div class="mainTitle">IR8A Print IR8S</div>
<form name="iForm" action="PrintIR8S_rep.cfm" method="post" target="_blank">
<table class="form">
	<tr>
		<th>Employee No. From</th>
		<td>
		<select name="empno_frm" id="empno_frm" onChange="document.getElementById('empno_to').selectedIndex=this.selectedIndex;">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<th>Employee No. To</th>
		<td>
		<select name="empno_to" id="empno_to">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<th>TAX Category</th>
		<td>
		<select name="epfcat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category# - #cpf_qry.com_fileno#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<th>Report Format</th>
		<td>
		<select name="">
			<option value=""></option>
		</select>
		</td>
	</tr>
	<tr>
		<th>Credit Date</th>
		<td><input type="text" name="cdate" id="cdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(cdate);"></td>
	</tr>
	<tr>
		<th>Report Date</th>
		<td><input type="text" name="rdate" id="rdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(rdate);"></td>
</table>
<br/>

	<center>
		<input type="button" name="update" value="Update" onClick="window.location.href='PrintIR8SUpdateMain.cfm';">
		<input type="submit" name="ok" value="OK">
		<input type="button" name="exit" value="Exit" onClick="window.location='/government/IR8A/IR8AList.cfm'">
	</center>
</form>

</body>

</html>