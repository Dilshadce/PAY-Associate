<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Print Pay Slip</title>
    <script type="text/javascript">
	function printpdf()
	{
<!--- 	<cfif DSNAME eq "taftc_p">
<cfif dsname eq "uniq_p">
<cfelse> --->
	document.pForm.action = "customizePaySlip_cy.cfm";
<!--- 	</cfif>
	<cfelse>
	document.pForm.action = "printPaySlipPDF.cfm";
	</cfif> --->
	}
	
	function printpdf1()
	{
		<cfoutput>
		<cfif FileExists(ExpandPath("/bill/#hcomid#_p/customizepayslip.cfm")) AND company_details.eppscustom EQ "Y">
		document.pForm.action = "/bill/#hcomid#_p/customizepayslip.cfm?type=pay12m&eleave=y";
		<cfelse>
		document.pForm.action = "printPaySlipProcess.cfm";
		</cfif>
	 	</cfoutput>
	}
	</script>
</head>

<body>
<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>Print Pay Slip</h3>
        <form name="pForm" action="" method="post" target="_blank">
        <table class="form">
        <tr>
        <td>Month</td>
        <td>
        <cfset month_count = val(company_details.mmonth) - 1  >
        
        <select name="month1" >
        <cfloop from="1" to="#month_count#" index="i">
        <cfset month_value = createdate('2011',i,'1')>
        <option value="#i#">#dateformat(month_value,'mmmm')#</option>
        </cfloop>
        </select>
        </td>
        </tr>
        <tr>
        <td>Pay Type</td>
        <td><select name="paytype" id="paytype">
      <option value="pay2_12m_fig">2nd Half</option>
      <option value="pay1_12m_fig">1st Half</option>
      <option value="pay_12m">1st Half + 2nd Half</option>
    </select></td>
        </tr>
        <tr>
        <td></td>
        <td><input type="submit" name="submit" value="OK" onClick="javascript:printpdf1();">
        <cfif FileExists(ExpandPath("/bill/#hcomid#_p/customizepayslip.cfm")) AND company_details.eppscustom EQ "Y">
        <cfelse>
        <input type="submit" name="pdf" value="PDF" onClick="javascript:printpdf();">
        </cfif></td>
        </tr>
        </table>
        </form>
        </div>
</div>
</cfoutput>
</body>
</html>
