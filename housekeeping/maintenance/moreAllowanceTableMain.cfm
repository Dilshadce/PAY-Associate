<!---cfscript>
	ma_qry = event.getArg('moreAllowanceData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Monthly OT Hours Table Main</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
	<div class="mainTitle">More Allowance Table</div><!---housekeeping/maintenance/test.cfm  --->
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="ma_qry" datasource="#dts#">
	SELECT * FROM mawtab
	</cfquery>
	<form name="eForm" action="moreAllowanceTable_process.cfm" method="post">
	<table class="form" border="0">
	<tr>
		<th width="80px" align="center">No.</th>
		<th width="100px" align="center">Description</th>
		<th width="70px" align="center">Link To</th>
	</tr>
	<cfoutput>
	<cfloop query="ma_qry">
	<tr>
		<th>#ma_qry.currentrow#<input type="hidden" name="maw_cou" value="#ma_qry.currentrow#"></th>
		<td><input type="text" name="maw_desp__r#ma_qry.currentrow#" size="15" value="#ma_qry.maw_desp#" maxlength="12" /></td>
		<td><input type="text" name="maw_link__r#ma_qry.currentrow#" size="10" value="#ma_qry.maw_link#" maxlength="2" /></td>
		<td></td>
	</tr>
	</cfloop>
	</table>
	<br />
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
		<!---input type="submit" name="save" value="#event.getArg('submitLabel')#"--->
	</center>
	</cfoutput>
	</form>
</body>
</html>
