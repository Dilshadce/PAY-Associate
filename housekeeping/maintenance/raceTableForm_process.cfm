<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update Race</title>
</head>

<body>
<cfoutput>
<cfif type eq "edit">
<cfquery name="raceEdit_qry" datasource="#dts#">
SELECT * FROM race WHERE RACECODE='#url.racecode#'
</cfquery>
<div class="mainTitle">Update Race</div>
<cfinclude template="raceTableHeader.cfm">
<form name="rForm" action="/housekeeping/maintenance/raceTableForm_update.cfm" method="post">

<table width="100%" border="0" class="insert">
	<tr>
		<td>Race: <input type="text" name="racecode" value="#raceEdit_qry.RACECODE#" readonly="yes"></td>
	</tr>
	<tr>
		<td>Description: <input type="text" name="racedesp" value="#raceEdit_qry.RACEDESP#"></td>
	</tr>
</table>
<br/>
<div align="center"><input type="submit" name="update" value="Update Race">

<cfelseif type eq "delete">
<cfquery name="raceDelete_qry" datasource="#dts#">
DELETE FROM race WHERE RACECODE='#url.racecode#'
</cfquery>

<cflocation url="raceTableForm.cfm">

<cfelse>
<cfquery name="raceAdd_qry" datasource="#dts#">
	INSERT INTO race (racecode,racedesp)
	VALUES ('#form.racecode#','#form.racedesp#')
</cfquery>

<cflocation url="/housekeeping/maintenance/raceTableForm.cfm">
</cfif>
</cfoutput>
</body>
</html>