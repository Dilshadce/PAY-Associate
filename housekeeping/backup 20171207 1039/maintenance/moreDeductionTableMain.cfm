<!---cfscript>
	md_qry = event.getArg('moreDeductionData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>More Deduction Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
	<div class="mainTitle">More Deduction Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="md_qry" datasource="#dts#">
	SELECT * FROM mdedtab
	</cfquery>
	<form ame="eForm" action="moreDeductionTableMain_process.cfm" method="post">
	<table class="form" border="0">
	<tr>
		<th width="80px" align="center">No.</th>
		<th width="100px" align="center">Description</th>
		<th width="70px" align="center">Link To</th>
	</tr>
	<cfoutput>
	<cfloop query="md_qry">
	<tr>
		<th>#md_qry.currentrow#<input type="hidden" name="mded_cou" value="#md_qry.currentrow#"></th>
		<td><input type="text" name="mded_desp__r#md_qry.currentrow#" size="15" value="#md_qry.mded_desp#" maxlength="12" /></td>
		<td><input type="text" name="mded_link__r#md_qry.currentrow#" size="10" value="#md_qry.mded_link#" maxlength="2" /></td>
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
