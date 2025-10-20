<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<title>Setup List</title>
</head>

<body>
<cfset user_pin = "PIN"&Hpin >
<cfquery name="pin_qry" datasource="#dts#">
	SELECT code, #user_pin# as pin from userdefine 
</cfquery>


<cfset title_define = StructNew()>
<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, pin_qry.pin)>
</cfloop>
<div class="mainTitle">Setup List</div>
<div class="subTitle"></div>
<table class="list">
<tr>
	<td colspan="3" height="20"></td>
</tr>
<tr>
	<cfif title_define[611000] eq "TRUE">
	<td colspan="3" nowrap><a href="/housekeeping/setup/parameterSetupMain.cfm" target="mainFrame">
	<img name="Cash Sales" src="../images/reportlogo.gif">Parameter Setup</a></td>
	</cfif>
</tr>
<!---tr>
	<td colspan="3" nowrap><a href="../index.cfm?event=housekeeping.setup.showParameterSetupMain" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Parameter Setup</a></td>
</tr--->
<tr>
	<td colspan="3"><hr /></td>
</tr>
<tr>
	<td align="center" colspan="3" nowrap>Tables Maintenance</td>
</tr>
<tr>
	<cfif title_define[612000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/paymentTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Payment Table</a></td>
	</cfif>
	<cfif title_define[613000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/allowanceTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif" >Allowance Table*</a></td>
	</cfif>
	<cfif title_define[614000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/MoreAllowanceTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">More Allowance Table*</a></td>
	</cfif>	
</tr>
<tr>
	<cfif title_define[615000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/DeductionTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Deduction Table*</a></td>
	</cfif>
	<cfif title_define[616000] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/MoreDeductionTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">More Deduction Table*</a></td>
	</cfif>
	<cfif title_define[617000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/OvertimeTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Overtime Table*</a></td>
	</cfif>	
</tr>
<tr>
	<cfif title_define[618000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/WorkingHourTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Working Hours Table*</a></td>
	</cfif>
	<cfif title_define[619000] eq "TRUE">
	<td><a href="/housekeeping/maintenance/MonthlyOTHourTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Monthly OT Hours Table*</a></td>
	</cfif>
	<cfif title_define["619000-1"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/ShiftAllowanceForm.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Shift Allowance Table*</a></td>
	</cfif>	
</tr>
<tr>
	<cfif title_define["619000-2"] eq "TRUE">
	<td><a href="/housekeeping/maintenance/pieceRateTableMain.cfm" target="mainFrame"> 
		<img name="Cash Sales" src="../images/reportlogo.gif">Piece Rates Table</td>
	</cfif>
	<cfif title_define["619000-3"] eq "TRUE">		
	<td><a href="/housekeeping/maintenance/ReportDateMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">1st & 2nd Half Dates*</a></td>
	</cfif>
	<cfif title_define["619000-4"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/TxtImportTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">TXT Import Table*</a></td>
	</cfif>	
</tr>
<tr>
	<cfif title_define["619000-5"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/RaceTableForm.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Race Table*</a></td>
	</cfif>
	<cfif title_define["619000-6"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/ReligionTableForm.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Religion Table*</a></td>
	</cfif>
	<cfif title_define["619000-7"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/denominationTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Denomination Table</a></td>
	</cfif>	
</tr>
<tr>
	<cfif title_define["619000-8"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/userDefineRateTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">User Define Rate Table</td>
	</cfif>
	<cfif title_define["619000-9"] eq "TRUE">	
	<td><a href="/housekeeping/maintenance/monthEndUpdateTableMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Month End Update Table</a></td>
	</cfif>
	<td></td>
</tr>
<tr>
	<td colspan="3"><hr /></td>
</tr>
<tr>
	<td align="center" colspan="3" nowrap>Government Tables</td>
</tr>
<cfquery name="gsetup" datasource="#dts_main#">
	SELECT ccode FROM gsetup WHERE  comp_id = "#HcomID#"
</cfquery>

<cfset country_code = "#gsetup.ccode#" > 

<cfif country_code eq 'MY'>
	<tr>
		<td><a href="/housekeeping/government/CPFTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">EPF Table</a></td>
		<td><a href="/housekeeping/government/socsotablemain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">SOCSO Table</a></td>
		<td><a href="/housekeeping/government/LHDNTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">PCB Table</a></td>
	</tr>
	<tr>
		<td><a href="/housekeeping/government/TaxReliefTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">Tax Relief Table</a></td>
	
	</tr>
	<!--- <tr>
		<td><a href="/housekeeping/government/" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">FW Levy (FWL) Table</a></td>
		<td><a href="/housekeeping/government/" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">Tax Relief Table</a></td>
		<td><a href="/housekeeping/government/" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">BIK Table</a></td>
	</tr> --->
<cfelse>
	<tr>
		<cfif title_define["619000-10"] eq "TRUE">	
		<td><a href="/housekeeping/government/CPFTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">CPF Table</a></td>
		</cfif>
		<cfif title_define["619000-11"] eq "TRUE">	
		<td><a href="/housekeeping/government/FWLTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">FWL Table*</a></td>
		</cfif>
		<cfif title_define["619000-12"] eq "TRUE">	
		<td><a href="/housekeeping/government/SDLTableMain.cfm" target="mainFrame">
			<img name="Cash Sales" src="../images/reportlogo.gif">SDL Table*</a></td>
		</cfif>	
	</tr>
</cfif>
<tr>
	<td colspan="3"><hr /></td>
</tr>
<tr>
	<cfif title_define["619000-13"] eq "TRUE">	
	<td colspan="3" nowrap><a href="/housekeeping/setup/AddressMain.cfm" target="mainFrame">
		<img name="Cash Sales" src="../images/reportlogo.gif">Addresses & Account No.*</a></td>
	</cfif>
</tr>
<tr>
	<cfif title_define["619000-14"] eq "TRUE">	
	<td colspan="3" nowrap><a href="/housekeeping/setup/APS_Format_Setup.cfm">
		<img name="Cash Sales" src="../images/reportlogo.gif">APS Format Setup</a></td>
	</cfif>	
</tr>
<tr>
	<td colspan="3"><hr /></td>
</tr>
<tr>
	<!---<cfquery name="user_qry" datasource="#dts_main#">
	SELECT userGrpID FROM users where userid="#HUserName#" AND userCmpID="#HcomID#";
	</cfquery> 
	<cfquery name="userpin_qry" datasource="#dts#">
		SELECT pin from userpin where usergroup = "#user_qry.userGrpID#"
	</cfquery>--->
	<cfif husergrpid eq "super" or title_define["619000-15"] eq "TRUE">	
	<td  nowrap><a href="/housekeeping/setup/user_admin_ID.cfm">
	<img name="Cash Sales" src="../images/reportlogo.gif">USER ID MAINTAINANCE</a></td>
	</cfif>
	<cfif husergrpid eq "super" or title_define["619000-16"] eq "TRUE">		
	<td  nowrap><a href="/housekeeping/setup/user_define_menu.cfm">
	<img name="Cash Sales" src="../images/reportlogo.gif">USER DEFINE MENU</a></td>
	</cfif>
	
	</tr>

</table>
</body>
</html>
