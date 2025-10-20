<html>
<head>
	<title>CPF Refund</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
</head>

<body>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type in ('CPF')
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT * FROM pmast where confid >= #hpin#
</cfquery>

<div class="mainTitle">CPF91 CPF Refund</div>
<div class="tabber">
<form name="gForm" action="CPFRefund_rep.cfm" method="post" target="_blank">
<table class="form">
	<tr>
		<th>Report Format</th>
		<td>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">PDF<br/>
		<td>
	</tr>	
	<tr>
		<td>Employee No. From</td>
		<td>
		<select name="empno_frm">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<td>Employee No. To</td>
		<td>
		<select name="empno_to">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<td>CPF Category</td>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category# - #cpf_qry.com_fileno#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="right"><br />
			<input type="button" name="generate" value="Generate" onClick="">
			<input type="button" name="update" value="Update" onClick="window.location.href='CPFRefund_upd.cfm';">
			<input type="submit" name="submit" value="OK">
			<input type="button" name="cancel" value="Cancel" onClick="window.location='/government/CPF91/CPF91List.cfm'">
		</td>
	</tr>
</table>
<!--- <center>
	<input type="submit" name="submit" value="Submit">
	<input type="button" name="cancel" value="Cancel" onclick="window.location='/government/CPF91/CPF91List.cfm'">
</center> --->
</form>

</body>

</html>