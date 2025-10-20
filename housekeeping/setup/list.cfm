<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<title>APS BANK LIST</title>
</head>
<body>

<cfquery name="bank_data_qry" datasource="#dts#">
SELECT *  FROM aps_set a ;
</cfquery>
<cfoutput>
<table>
<tr><td>APS BANK</td></tr>
<tr>
	<table>
	<tr><th>Number</th>
		<th>Bank Name</th>
		<th>APS Note</th>
		<th></th>
	</tr>
<cfloop query="bank_data_qry">	
	<tr><td>#bank_data_qry.entryno#</td>
		<td>#bank_data_qry.APSbank#</td>
		<td>#bank_data_qry.APSNote#</td>
		<td>#bank_data_qry.APSFile#</td>
	</tr>
	</cfloop>
	</table>
</tr>
</table>
</cfoutput>
</body>
</html>