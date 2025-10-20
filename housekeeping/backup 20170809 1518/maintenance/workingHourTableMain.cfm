<!---cfscript>
	wo_qry = event.getArg('workingHourData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Working Hour Table Main</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
	<div class="mainTitle">Working Hour Table</div><!---housekeeping/maintenance/test.cfm  --->
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="wo_qry" datasource="#dts#">
	SELECT * FROM ottable
	</cfquery>
	<form name="eForm" action="workingHourTableMain_process.cfm" method="post"><cfloop query="wo_qry">
	<input type="hidden" name="ot_cou" value="<cfoutput>#wo_qry.ot_cou#</cfoutput>"></cfloop><cfoutput>
	<table class="form" border="0">
		
	<tr>
		<th align="center">Working Hours</th>
		<th align="center">1</th>
		<th align="center">2</th>
		<th align="center">3</th>
		<th align="center">4</th>
		<th align="center">5</th>
		<th align="center">6</th>
		<td></td>
	</tr>
	
	<tr>
		<th>Monthly Rated</th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<th>Monthly Per Year</th>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[1]#" /></td>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[2]#" /></td>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[3]#" /></td>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[4]#" /></td>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[5]#" /></td>
		<td><input type="text" name="xpaymthpy" size="10" value="#wo_qry.xpaymthpy[6]#" /></td>
		<td>OT = Basic Rate *?/Hrs per yr</td>
	</tr>
	<tr>
		<th>Days Per Month</th>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[1]#" /></td>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[2]#" /></td>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[3]#" /></td>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[4]#" /></td>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[5]#" /></td>
		<td><input type="text" name="xdaypmth" size="10" value="#wo_qry.xdaypmth[6]#" /></td>
		<td>NPL, Advance, ORP</td>
	</tr>
	<tr>
		<th>Days Per Month</th>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[1]#" /></td>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[2]#" /></td>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[3]#" /></td>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[4]#" /></td>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[5]#" /></td>
		<td><input type="text" name="xdaypmthab" size="10" value="#wo_qry.xdaypmthab[6]#" /></td>
		<td>Absent</td>
	</tr>
    <tr>
		<th>Days Per Week</th>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[1]#" /></td>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[2]#" /></td>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[3]#" /></td>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[4]#" /></td>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[5]#" /></td>
		<td><input type="text" name="daysperweek" size="10" value="#wo_qry.daysperweek[6]#" /></td>
		<td>NPL</td>
	</tr>
	<tr>
		<th>Hours Per Day</th>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[1]#" /></td>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[2]#" /></td>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[3]#" /></td>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[4]#" /></td>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[5]#" /></td>
		<td><input type="text" name="xhrpday_m" size="10" value="#wo_qry.xhrpday_m[6]#" /></td>
		<td>Lateness, Normal hr. worked pay</td>
	</tr>
	<tr>
		<th>Hours Per Year</th>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[1]#" /></td>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[2]#" /></td>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[3]#" /></td>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[4]#" /></td>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[5]#" /></td>
		<td><input type="text" name="xhrpyear" size="10" value="#wo_qry.xhrpyear[6]#" /></td>
		<td>OT (Basic rate, Ded., Aw.)</td>
	</tr>
	<tr>
		<th>Daily Rated</th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<th>Hours Per Day</th>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[1]#" /></td>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[2]#" /></td>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[3]#" /></td>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[4]#" /></td>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[5]#" /></td>
		<td><input type="text" name="xhrpday_d" size="10" value="#wo_qry.xhrpday_d[6]#" /></td>
		<td>OT (Basic rate, Ded., Aw.) Also to get Month_Rate</td>
	</tr>
	<tr>
		<th>Days Per Month (A)</th>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[1]#" onkeyup="document.eForm.tempHA1.value=this.value" /></td>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[2]#" onkeyup="document.eForm.tempHA2.value=this.value" /></td>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[3]#" onkeyup="document.eForm.tempHA3.value=this.value" /></td>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[4]#" onkeyup="document.eForm.tempHA4.value=this.value" /></td>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[5]#" onkeyup="document.eForm.tempHA5.value=this.value" /></td>
		<td><input type="text" name="xdaypmtha" size="10" value="#wo_qry.xdaypmtha[6]#" onkeyup="document.eForm.tempHA6.value=this.value" /></td>
		<td>Bonus, Bonus PCB, Comm. PCB Also to get Month_Rate</td>
	</tr>
	<tr>
		<th>Days Per Month (B)</th>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[1]#" onkeyup="document.eForm.tempHB1.value=this.value" /></td>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[2]#" onkeyup="document.eForm.tempHB2.value=this.value" /></td>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[3]#" onkeyup="document.eForm.tempHB3.value=this.value" /></td>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[4]#" onkeyup="document.eForm.tempHB4.value=this.value" /></td>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[5]#" onkeyup="document.eForm.tempHB5.value=this.value" /></td>
		<td><input type="text" name="xdaypmthb" size="10" value="#wo_qry.xdaypmthb[6]#" onkeyup="document.eForm.tempHB6.value=this.value" /></td>
		<td>Hrp = + Aw / ? / Hr. per day Set to 0 if day_worked is Used</td>
	</tr>
	<tr>
		<th>Hourly Rated</th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<th>Hours Per Day</th>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[1]#" /></td>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[2]#" /></td>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[3]#" /></td>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[4]#" /></td>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[5]#" /></td>
		<td><input type="text" name="xhrpday_h" size="10" value="#wo_qry.xhrpday_h[6]#" /></td>
		<td>Basic Pay, OT (Ded., Aw.)</td>
	</tr>
	<tr>
		<th>Days Per Month (A)</th>
		<td><input type="text" size="10" name="tempHA1" value="#wo_qry.xdaypmtha[1]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHA2" value="#wo_qry.xdaypmtha[2]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHA3" value="#wo_qry.xdaypmtha[3]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHA4" value="#wo_qry.xdaypmtha[4]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHA5" value="#wo_qry.xdaypmtha[5]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHA6" value="#wo_qry.xdaypmtha[6]#" readonly="yes" /></td>
		<td>Equal Daily Rated Figures</td>
	</tr>
	<tr>
		<th>Days Per Month (B)</th>
		<td><input type="text" size="10" name="tempHB1" value="#wo_qry.xdaypmthb[1]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHB2" value="#wo_qry.xdaypmthb[2]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHB3" value="#wo_qry.xdaypmthb[3]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHB4" value="#wo_qry.xdaypmthb[4]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHB5" value="#wo_qry.xdaypmthb[5]#" readonly="yes" /></td>
		<td><input type="text" size="10" name="tempHB6" value="#wo_qry.xdaypmthb[6]#" readonly="yes" /></td>
		<td>Equal Daily Rated Figures</td>
	</tr>
	</table>
	<br />
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	</center>
	</cfoutput>
	</form>
</body>
</html>
