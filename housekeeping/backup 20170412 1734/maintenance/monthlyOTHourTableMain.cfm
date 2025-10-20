<!---cfscript>
	mOTH_qry = event.getArg('monthlyOTHData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Monthly OT Hours Table Main</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

</head>

<body>
	<div class="mainTitle">Monthly OT Hours Table</div><!---housekeeping/maintenance/test.cfm  --->
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	
	<form name="eForm" action="monthlyOTHourTableMain_process.cfm" method="post">
	<table class="form" border="0">
	<tr>
		<th width="10%" align="center">Month</th>
		<th width="8%" align="center">Table 1</th>
		<th width="8%" align="center">Table 2</th>
		<th width="8%" align="center">Table 3</th>
		<th width="8%" align="center">Table 4</th>
		<th width="8%" align="center">Table 5</th>
		<th width="8%" align="center">Table 6</th>
		<td></td>
	</tr>
	<cfoutput>
	
	<cfquery name="mOTH_qry" datasource="#dts#">
	SELECT ot_cou,xhrpyear01,xhrpyear02,xhrpyear03,xhrpyear04,xhrpyear05,xhrpyear06,xhrpyear07,xhrpyear08,xhrpyear09,xhrpyear10,xhrpyear11,xhrpyear12 FROM ottable 
	</cfquery>
	
	<cfinvoke component="cfc/formating" method="row2column" qry="#mOTH_qry#" returnvariable="the_return_variable"/>
	<cfloop query="the_return_variable">
		
	<tr><input type="hidden" name="ot_cou" value="#the_return_variable.cHeader#">
		<th>#monthAsString(the_return_variable.currentrow)#</th>
		<td><input type="text" name="#the_return_variable.cHeader#__r1" size="10" value="#the_return_variable.c1#" /></td>
		<td><input type="text" name="#the_return_variable.cHeader#__r2" size="10" value="#the_return_variable.c2#" /></td>
		<td><input type="text" name="#the_return_variable.cHeader#__r3" size="10" value="#the_return_variable.c3#" /></td>
		<td><input type="text" name="#the_return_variable.cHeader#__r4" size="10" value="#the_return_variable.c4#" /></td>
		<td><input type="text" name="#the_return_variable.cHeader#__r5" size="10" value="#the_return_variable.c5#" /></td>
		<td><input type="text" name="#the_return_variable.cHeader#__r6" size="10" value="#the_return_variable.c6#" /></td>
		<td></td>
	</tr>
	<!---tr>
		<th>#MonthAsString(mOTH_qry.currentrow)#</th>
		<td><input type="text" name="#mOTH_qry.cHeader#__r1" size="10" value="#mOTH_qry.c1#" /></td>
		<td><input type="text" name="#mOTH_qry.cHeader#__r2" size="10" value="#mOTH_qry.c2#" /></td>
		<td><input type="text" name="#mOTH_qry.cHeader#__r3" size="10" value="#mOTH_qry.c3#" /></td>
		<td><input type="text" name="#mOTH_qry.cHeader#__r4" size="10" value="#mOTH_qry.c4#" /></td>
		<td><input type="text" name="#mOTH_qry.cHeader#__r5" size="10" value="#mOTH_qry.c5#" /></td>
		<td><input type="text" name="#mOTH_qry.cHeader#__r6" size="10" value="#mOTH_qry.c6#" /></td>
		<td></td>
	</tr--->
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
