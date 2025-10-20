<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">				
<title>Month End</title>
<link rel="shortcut icon" href="/PMS.ico" />
<script type="text/javascript">
function wd_validation()
{
var trans = document.getElementById("uwd").checked;
if(trans == false)
{
document.getElementById("uwdtable").style.visibility = "hidden";
}
else
{
document.getElementById("uwdtable").style.visibility = "visible";
}
 
}
</script>
</head>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfquery name="checkstatus" datasource="#dts_main#">
SELECT mestatus, emailpayslip FROM gsetup2 WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfif mon neq 13>
<cfset date= createdate(yrs,mon,1)>
<cfelse>
<script type="text/javascript">
parent.topFrame.location.reload();
</script>

</cfif>
<body>
<cfoutput>
<div class="mainTitle" style="text-transform:uppercase"><cfif mon neq 13>MONTH END PROCESSING FOR #dateformat(date,'MMMM')#<cfelse>Please proceed to do year end at HouseKeeping > Year End</cfif></div>
<div class="tabber">
<font color="red" size="2.5">
<cfif isdefined("form.status") and mon neq 13>
<script type="text/javascript">
window.parent.frames("topFrame").location.reload();
</script>
<cfoutput>#form.status#
<br />Current Month: #dateformat(date,'MMMM')#
<br />Current Year : #dateformat(date,'YYYY')#
</cfoutput>
</cfif>
</font>

	<cfif datediff('h',company_details.monthend,now())lt 24>
		<cfset msg = "You have done month end earlier at #company_details.monthend# \nAre you sure want to do month end again?">
    <cfelse>
    	<cfset msg = "Are you sure want to do month end?">
	</cfif>
    
<form action="/housekeeping/monthEndProcess.cfm" method="post" onsubmit="if(confirm('#msg#')){ColdFusion.Window.show('processing'); return true;}else{return false;}">
<table class="form">
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td width="50px"><input type="radio" name="transaction" value="MFT" id="transaction_0" checked="checked" /></td>
<td width="200px">1. Move Forward Transaction</td>
<td width="80px"></td>
</tr>
<tr>
<td><input type="radio" name="transaction" value="RT" id="transaction_1" /></td>
<td>2. Remove Transaction</td>
<td></td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td></td>
</tr>
<cfif left(dts,4) neq "beps">
<tr>
  <td><input type="checkbox" name="remainweekpay" id="remainweekpay" value="1"/></td>
  <td>Remain Weekly Pay</td>
  <td></td>
</tr>
</cfif>
<tr>
  <td><input type="checkbox" name="uwd" id="uwd" checked="checked" value="1" onclick="javascript:wd_validation();"/></td>
  <td>Update Working Days As Below </td>
  <td></td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td></td>
</tr>
<tr>
  <td><input type="checkbox" name="emailpayslip" id="emailpayslip" <cfif checkstatus.emailpayslip eq "Y"> checked="checked"</cfif> hidden="true" /></td>
  <td><!---Email pay slip to all employees---></td>
  <td></td>
</tr>
<tr>
<td colspan="3">
<table id="uwdtable">
<tr><th colspan="2">For employee pay twice a month</th></tr>
<tr>
  <td width="250px">1st half working day for coming month</td>
  <td align="right" width="80px"><input type="text" name="fwd" size="6" value="#numberformat('13.00','.__')#"/></td>
</tr>
<tr>
  <td width="250px">2nd half working day for coming month</td>
  <td align="right" width="80px"><input type="text" name="swd" size="6" value="#numberformat('13.00','.__')#"/></td>
</tr>
<tr><th colspan="2">For employee pay once a month</th></tr>
<tr>
  <td width="250px">2nd half working day for coming month</td>
  <td align="right" width="80px"><input type="text" name="new2wd" size="6" value="#numberformat('26.00','.__')#"/></td>
</tr>
</table>
</td>
</tr>
<tr>
  <td colspan="2">&nbsp;</td>
  <td align="right">&nbsp;</td>
</tr>
</table>
		<br />	
		&nbsp;&nbsp;&nbsp;<input type="submit" name="save" value="ok" <cfif mon eq 13 or checkstatus.mestatus eq 'Y'> style="display:none" disabled="disabled"  </cfif>>
</form>

</div>
</cfoutput>
<cfwindow name="processing" width="300" height="300" initshow="false" center="true" closable="false" draggable="false" title="Processing....Please Wait" modal="true" resizable="false" >
<h1>Processing....Please Wait</h1>
<img src="/images/loading.gif" align="middle" />
</cfwindow>
</body>
</html>
