<html>
<head>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM rngtable
WHERE entryno = '#url.c#'
</cfquery>

<cfquery name="ceili_qry" datasource="#dts#">
SELECT * FROM rngtable
WHERE entryno = 1
</cfquery>

<cfoutput>
<form name="eForm" action="/housekeeping/government/CPFTableMain_process.cfm?e=#cpf_qry.entryno#" method="post">
<table class="form" border="0">
	<tr>
	<td colspan="2">Pay From
	<input type="text" name="payFrom" value="#cpf_qry.epfpayf#" size="8">
	To
	<input type="text" name="payTo" value="#cpf_qry.epfpayt#" size="8"></td>
</tr>
	<tr >
		<th width="10">Table</th>
		<th width="450">Employee</th>
		<th width="450">Employer</th>
	</tr>
	<cfset i=1>
	<cfloop from="1" to="30" index="i">
	<tr>
		<td>#i#</td>
		<td><input type="text" name="epfyee#i#" value="#evaluate('cpf_qry.epfyee#i#')#" size="72"></td>
		<td><input type="text" name="epfyer#i#" value="#evaluate('cpf_qry.epfyer#i#')#" size="72"></td>
	</tr>
	<cfset i= i +1>
	</cfloop>
</table>

<table>
<tr>
	<td>Ceiling for normal pay CPF calculated</td>
	<td><input type="text" name="cNormal" value="#ceili_qry.cpf_ceili#" size="10"></td>
</tr>
<tr>
	<td>Ceiling for Bonus CPF calculated</td>
	<td><input type="text" name="cBonus" value="#ceili_qry.tcpf_ceili#" size="10"></td>
</tr>
</table>
</br>
<center>
	<!--- <input type="reset" name="reset" value="Reset"> --->
	<input type="submit" name="save" value="Save">
	<input type="button" name="cancel" value="Cancel" onClick="window.location='/housekeeping/setupList.cfm'">
    <input type="button" name="update" value="UPDATE NEW CPF RATE" onClick="updateconfirm()" />
</center>
</form>

</cfoutput>
</body>

</html>