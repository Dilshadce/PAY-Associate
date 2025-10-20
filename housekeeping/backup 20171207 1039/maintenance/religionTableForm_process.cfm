<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Religion</title>
</head>

<body>
<cfoutput>
<cfif type eq "edit">
<cfquery name="relEdit_qry" datasource="#dts#">
SELECT * FROM religion WHERE RELCODE='#url.relcode#'
</cfquery>

<div class="mainTitle">Update Religion</div>
<cfinclude template="religionTableHeader.cfm">
<form name="eForm" action="/housekeeping/maintenance/religionTableForm_update.cfm" method="post">
<table width="100%" border="0" class="insert">
	<tr>
		<td>Religion: <input type="text" name="relcode" value="#relEdit_qry.RELCODE#" readonly="yes"></td>
	</tr>
	<tr>
		<td>Description: <input type="text" name="reldesp" value="#relEdit_qry.RELDESP#"></td>
	</tr>
</table>
<br/>
<div align="center"><input type="submit" name="button" value="Update Religion"></div>

<cfelseif type eq "delete">
<cfquery name="relDelete_qry" datasource="#dts#">
DELETE FROM religion WHERE RELCODE='#url.relcode#'
</cfquery>

<cflocation url="/housekeeping/maintenance/religionTableForm.cfm">

<cfelse>
<cfquery name="relDelete_qry" datasource="#dts#">
INSERT INTO religion (relcode,reldesp)
VALUES ('#form.relcode#','#form.reldesp#')
</cfquery>

<cflocation url="/housekeeping/maintenance/religionTableForm.cfm">

</cfif>
</cfoutput>
</body>
</html>