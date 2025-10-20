<html>
<head>
	<title>CPF CNR/FORM CAPR</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type in ('CPF')
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT * FROM pmast
</cfquery>


<div class="mainTitle">CPF91 CPF CNR/FORM CAPR</div>
<form name="" action="CPFCNR_rep.cfm" method="post" target="_blank">
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
			<option value="">zzzzzz</option>
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
</table>
<center><br />
	<input type="submit" name="submit" value="OK">
	<input type="button" name="exit" value="Exit" onClick="window.location='/government/CPF91/CPF91List.cfm'">
</center>
</form>

</body>
</html>