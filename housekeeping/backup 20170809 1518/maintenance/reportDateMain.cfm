<!---cfscript>
	rd_qry = event.getArg('reportDateData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Report Dates & 1st Half Days Main</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
</head>

<body style="width:840px">
	<div class="mainTitle">Report Dates & 1st Half Days</div><!---housekeeping/maintenance/test.cfm  --->
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<form name="eForm" action="reportDateMain_process.cfm" method="post">
	<cfquery name="rd_qry" datasource="#dts#"> 
	SELECT * FROM awtable WHERE aw_cou between 1 and 12
	</cfquery>
	<table class="form" border="0">
	<tr>
		<th width="80px" align="center">Month</th>
		<th width="100px" align="center">1st Half</th>
		<th width="100px" align="center">2nd Half</th>
		<th width="100px" align="center">No. of day in 1st Half</th>
	</tr>
	<cfoutput>
	<cfloop query="rd_qry">
	<tr>
		<th>#MonthAsString(rd_qry.currentrow)#</th>
		<td><input type="text" name="rpt_date_1__r#rd_qry.currentrow#" size="12" value="#lsdateformat(rd_qry.rpt_date_1,"dd/mm/yyyy")#" maxlength="10" />
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(rpt_date_1__r#rd_qry.currentrow#);">
			</td>
		<td><input type="text" name="rpt_date_2__r#rd_qry.currentrow#" size="12" value="#lsdateformat(rd_qry.rpt_date_2,"dd/mm/yyyy")#" maxlength="10" />
			<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(rpt_date_2__r#rd_qry.currentrow#);">
			</td>
		<td><input type="text" name="num_day_1__r#rd_qry.currentrow#" size="15" value="#rd_qry.num_day_1#" maxlength="2" /></td>
		<td></td>
	</tr>
	</cfloop>
	</table>
	<br />
	<div style="text-align:center; width:420px">
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="save" value="Save">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
		<!---input type="submit" name="save" value="#event.getArg('submitLabel')#"--->
	</div>
	</cfoutput>
	</form>
</body>
</html>
