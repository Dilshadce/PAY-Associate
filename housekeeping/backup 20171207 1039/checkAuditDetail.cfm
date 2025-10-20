<cfif isdefined("url.entryno") and url.entryno neq "">
	<cfquery name="getData" datasource="#dts#">
		SELECT REPLACE(old_value,"||","#chr(10)#") as old_value, REPLACE(new_value,"||","#chr(10)#") as new_value 
		FROM audit_trail where entryno='#url.entryno#'
	</cfquery>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Audit Trail Detail</title>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
<center>
<cfif isdefined("url.entryno") and url.entryno neq ""><cfif getData.recordcount eq 0><font color="#FF0000">No Record Found.</font></cfif></cfif>
<table>
	<tr>
		<th>Old Value</th>
		<th>New Value</th>
	</tr>
	<cfoutput>
	<tr>
		<td><textarea cols="35" rows="25" readonly="readonly">#getData.old_value#</textarea></td>
		<td><textarea cols="35" rows="25" readonly="readonly">#getData.new_value#</textarea></td>
	</tr>
	</cfoutput>
</table>
</center>
</body>
</html>
