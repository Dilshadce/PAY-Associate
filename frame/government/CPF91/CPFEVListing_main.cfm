<html>
<head>
	<title>CPF Excess/Voluntary Listing</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type in ('CPF')
</cfquery>

<body>
<div class="mainTitle">CPF91 CPF Excess/Voluntary Listing</div>
<form name="gForm" action="CPFEVListing_rep.cfm" method="post" target="_blank">
<table class="form">
	<tr>
		<th>Report Format</th>
		<td>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">PDF<br/>
		<td>
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