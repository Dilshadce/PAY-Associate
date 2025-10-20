<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Left Menu</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/left.css" rel="stylesheet" type="text/css">
    

<script type="text/javascript">
if (document.getElementById){ 
	document.write('<style type="text/css">\n')
	document.write('.submenu{display: none;}\n')
	document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
		var el = document.getElementById(obj);
		var ar = document.getElementById("masterdiv").getElementsByTagName("span"); 
		if(el.style.display != "block"){ 
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") 
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}
</script>
</head>

<body>
<cfquery name="gsetup" datasource="#dts_main#">
	SELECT * FROM gsetup WHERE  comp_id = "#HcomID#"
</cfquery>
<cfset user_pin = "PIN"&val(Hpin) >
<cfquery name="pin_qry" datasource="#dts#">
	SELECT code, #user_pin# as pin from userdefine 
</cfquery>
<cfquery name="getsuper" datasource="#dts_main#">
	select usergrpid from users where entryID="#HEntryID#" and usercmpID="#HcomID#"
</cfquery>


<cfset title_define = StructNew()>

<cfif #getsuper.usergrpid# eq "super">
	<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, "true")>
	</cfloop>
<cfelse>	
	<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, pin_qry.pin)>
	</cfloop>
</cfif>

<cfset country_code = "#gsetup.ccode#" > 

<cfif country_code eq 'MY'>
	<div id="masterdiv">
		<cfif title_define[100000] eq "TRUE"><div class="menutitle" onClick="SwitchMenu('sub1')">Payments</div></cfif>
		<span class="submenu" id="sub1">
	  		<cfif title_define[110000] eq "TRUE">
		  		<li><a class="sub" href="/payments/1stHalf/1stHalfList.cfm" target="mainFrame">1st Half Payroll</a></li>
                <cfif left(dts,4) eq "beps">
                <li><a class="sub" href="/payments/1stHalf/CashBankOthers/netPayCBOChequeMain.cfm" target="mainFrame">1st Half Cheque Link</a></li>
				</cfif>
			</cfif>
			<cfif title_define[120000] eq "TRUE">
				<li><a class="sub" href="/payments/2ndHalf/2ndHalfList.cfm" target="mainFrame">2nd Half Payroll</a></li>
                <cfif left(dts,4) eq "beps">
                <li><a class="sub" href="/payments/2ndHalf/CashBankOthers/netPayCBOChequeMain.cfm" target="mainFrame">2nd Half Cheque Link</a></li>
				</cfif>
			</cfif>
			<cfif title_define[130000] eq "TRUE">
				<li><a class="sub" href="/payments/bonus/bonusList.cfm" target="mainFrame">Bonus</a></li>
			</cfif>
			<cfif title_define[140000] eq "TRUE">
				<li><a class="sub" href="/payments/commission/commissionList.cfm" target="mainFrame">Commission</a></li>
			</CFIF>
			<cfif title_define[150000] eq "TRUE">
			<li><a class="sub" href="/payments/extra/extraList.cfm" target="mainFrame">Extra</a></li>
			</cfif>
			<cfif title_define[160000] eq "TRUE">
			<li><a class="sub" href="/payments/2HBCE/2HBCEList.cfm" target="mainFrame">2nd Half + Bonus + Commission + Extra</a></li>
			</cfif>
		<cfif title_define[170000] eq "TRUE">
			<li><a class="sub" href="/payments/weeklyPayroll/weeklyPayrollList.cfm" target="mainFrame">Weekly Payroll</a></li>
	        </cfif>
			<cfif title_define[180000] eq "TRUE">
	        <li><a class="sub" href="/payments/leavemaintainance.cfm" target="mainFrame">Leave Approval</a></li>
	        </cfif>
	        <cfif title_define[190000] eq "TRUE">
        	<li><a class="sub" href="/payments/Claim/Claimlist.cfm" target="mainFrame">Claim</a></li>
			</cfif>
            <cfif title_define[190000] eq "TRUE" and dts eq "ksp_p">
        	<li><a class="sub" href="/projectcalendar/" target="mainFrame">Project Calendar</a></li>
			</cfif>
		</span>
	
		<cfif title_define[200000] eq "TRUE">
			<div class="menutitle" onClick="SwitchMenu('sub2')">Personnel</div>
		</cfif>
		<span class="submenu" id="sub2">
			
			<cfif title_define[210000] eq "TRUE">
	  		<li><a class="sub" href="/personnel/employee/employeeMain.cfm" target="mainFrame">Add/Update Employees</a></li>
	  		</cfif>
			<cfif title_define[220000] eq "TRUE">
			<li><a class="sub" href="/personnel/workingdaygroup_main.cfm" target="mainFrame">Update Working Days</a></li>
			</cfif>
			<cfif title_define[230000] eq "TRUE">
	        <li><a class="sub" href="/personnel/updateLeaveFundEntitledMain.cfm" target="mainFrame">Update Leave / Fund Entitled</a></li>
			</cfif>
			<cfif title_define[240000] eq "TRUE">
			<li><a class="sub" href="/personnel/updateAWnDEDMain.cfm" target="mainFrame">Update Allowance And Deduction</a></li>
			</cfif>
			<cfif title_define[250000] eq "TRUE">
			<li><a class="sub" href="/personnel/checkListEmployeeMain.cfm" target="mainFrame">Check / List Employees</a></li>
			</cfif>
			<cfif title_define[260000] eq "TRUE">
			<li><a class="sub" href="/personnel/reports/pReportMain.cfm" target="mainFrame">Personnel Report</a></li>
			</cfif>
			<cfif title_define[270000] eq "TRUE">
			<li><a class="sub" href="/personnel/maintenance/categoryList.cfm" target="mainFrame">Category Maintenance</a></li>
			</cfif>
			<cfif title_define[280000] eq "TRUE">
			<li><a class="sub" href="/personnel/updateHistoricalRecordsMain.cfm" target="mainFrame">Update History Records</a></li>
			</cfif>
			<cfif title_define[290000] eq "TRUE">
			<li><a class="sub" href="/personnel/historicalListing/historicalListingList.cfm" target="mainFrame">History Listing</a></li>
			</cfif>
			<li><a class="sub" href="/personnel/generateBasicRateIncrement/list.cfm" target="mainFrame">Generate Basic Rate Increment</a></li>
            <li><a class="sub" href="/personnel/employeeCPF/list.cfm" target="mainFrame">Employee EPF Table Maintenance</a></li>
			<!--- <li><a class="sub" href="underconstruction.cfm" target="mainFrame">Generate Employee SOCSO Table</a></li>
			<li><a class="sub" href="/personnel/employeeSocso/gsocsotable.cfm" target="mainFrame">Generate Employee SOCSO Table</a></li> --->
		</span>
		
		<cfif title_define[300000] eq "TRUE">
			<div class="menutitle" onClick="SwitchMenu('sub3')">Government</div>
		</cfif>
		<span class="submenu" id="sub3">
			<!--- <li><a class="sub" href="/government/EPF/epfReport.cfm" target="mainFrame">EPF Reports</a></li>
			<li><a class="sub" href="/government/SOCSO/socsoReport.cfm" target="mainFrame">SOCSO Reports</a></li>
			<li><a class="sub" href="/government/ITAXREPORT/itaxReport.cfm" target="mainFrame">Income Tax Reports</a></li>
			<li><a class="sub" href="/government/OTHERS/ASN.cfm" target="mainFrame">A.S.N</a></li>
			<li><a class="sub" href="/government/OTHERS/thaji.cfm" target="mainFrame">T.Haji</a></li>
			<li><a class="sub" href="/government/OTHERS/hrdfund.cfm" target="mainFrame">Human Resource  Development Fund</a></li>
			<li><a class="sub" href="/government/OTHERS/foreignworker.cfm" target="mainFrame">Foreign Worker Levy</a></li>
			<li><a class="sub" href="/government/OTHERS/zakatListing.cfm" target="mainFrame">Zakat Listing</a></li>
			<li><a class="sub" href="/government/OTHERS/others.cfm" target="mainFrame">Other Reports</a></li> --->
	  		
	  		<li><a class="sub" href="underconstruction.cfm" target="mainFrame">EPF Reports</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">SOCSO Reports</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">Income Tax Reports</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">A.S.N</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">T.Haji</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">Human Resource  Development Fund</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">Foreign Worker Levy</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">Zakat Listing</a></li>
			<li><a class="sub" href="underconstruction.cfm" target="mainFrame">Other Reports</a></li>
		</span>
		
		<cfif title_define[400000] eq "TRUE">
			<div class="menutitle" onClick="SwitchMenu('sub4')">Miscellaneous</div>
		</cfif>
		<span class="submenu" id="sub4">
			<cfif title_define[410000] eq "TRUE">
			<li><a class="sub" href="/miscellaneous/printOtherReports/printOtherReportsList.cfm" target="mainFrame">Print Other Reports</a></li>
			</cfif>
			<cfif title_define[420000] eq "TRUE">
			<li><a class="sub" href="/miscellaneous/checkFile/checkfile.cfm" target="mainFrame">Check File</a></li>
			</cfif>
			
			<!--- <li><a class="sub" href="/miscellaneous/PostToDaccount.cfm" target="mainFrame">Post To Daccount</a></li> --->
	  	</span>
		
		<cfif title_define[500000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub5')">Monthly & Yearly</div>
		</cfif>
		<span class="submenu" id="sub5">
			<cfif title_define[510000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/monthToDatePayReport/monthToDatePayReports.cfm" target="mainFrame">Month To Date Pay Listing</a></li>
			</cfif>
			<cfif title_define[520000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/figUpdate.cfm" target="mainFrame">12 Months Figures Update</a></li>
			</cfif>
			<cfif title_define[570000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/cal12MonthFiguresMain.cfm" target="mainFrame">Calculate 12 Months Figures</a></li>
			</cfif>
			<cfif title_define[530000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/12monthYearlyReport/12monthYearlyReport.cfm" target="mainFrame">12 Months Yearly Reports</a></li>
			</cfif>
			<cfif title_define[540000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/recalculateALL.cfm" target="mainFrame">Recalculate MTD, YID & Taxable AW, OT, DED</a></li>
			</cfif>
			<cfif title_define[550000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/yearToDatePayReport/yearToDatePayReports.cfm" target="mainFrame">Year To Date Pay Reports</a></li>
			</cfif>
			<cfif title_define[560000] eq "TRUE">
			<li><a class="sub" href="/monthlyAndyearly/pastMonthPay.cfm" target="mainFrame">Past Months Pay Transaction</a></li>
			</cfif>
		</span>
		
		<cfif title_define[600000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub6')">Housekeeping</div>
		</cfif>
		<span class="submenu" id="sub6">
			<cfif title_define[610000] eq "TRUE">
				<li><a class="sub" href="/housekeeping/setupList.cfm" target="mainFrame">Setup</a></li>
			</cfif>
			<cfif title_define[620000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/maintainPassword.cfm" target="mainFrame">Maintain Password</a></li>
			</cfif>
			<cfif title_define[630000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/FileReOrganisation/fileReOrganisationList.cfm" target="mainFrame">File Re-Organisation</a></li>
			</cfif>
			<cfif title_define[640000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/monthEndMain.cfm" target="mainFrame">Month End</a></li>
			</cfif>
			<cfif title_define[650000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/yearEndMain.cfm" target="mainFrame">Year End</a></li>
			</cfif>
			<!--- <li><a class="sub" href="/housekeeping/createuser.cfm" target="mainFrame">Create User</a></li> --->
			<cfif title_define[660000] eq "TRUE">
	        	<li><a class="sub" href="/housekeeping/Vuser.cfm" target="mainFrame">User Administration</a></li>
			</cfif>
			<cfif title_define[670000] eq "TRUE">
				<li><a class="sub" href="/housekeeping/checkAudit.cfm" target="mainFrame">Check Audit</a></li>
			</cfif>
		</span>
		
		<cfif title_define[700000] eq "TRUE">
			<div class="menutitle" onClick="SwitchMenu('sub7')">Wizard</div>
		</cfif>
		<span class="submenu" id="sub7">
			<cfif title_define[710000] eq "TRUE">
				<li><a class="sub" href="/wizard/wizard.cfm" target="mainFrame">Add Employee Wizard</a></li>
			</cfif>
		</span>
		
		<cfif husergrpid eq "super">
					<div class="menutitle" onClick="SwitchMenu('sub8')">Super Menu</div>
		<span class="submenu" id="sub8">
			<li><a class="sub" href="/supermenu/info.cfm" target="mainFrame">Information Update</a></li>
			<li><a class="sub" href="/housekeeping/info/info.cfm" target="mainFrame">Add Info</a></li>
            <li><a class="sub" href="/supermenu/backupdata/index.cfm" target="mainFrame">Back Up Data</a></li>
            <li><a class="sub" href="/supermenu/backupdata/restore.cfm" target="mainFrame">Restore Data</a></li>
			<li><a class="sub" href="/supermenu/yearendprocess_main.cfm" target="mainFrame">Year End Process</a></li>
            <li><a class="sub" href="/importemployee/uploadfile.cfm" target="mainFrame">Import Employee From Excel</a></li>
		</span>
		</cfif>
	  	</span>
	</div>
	
	<!--- 	<div class="menutitle" onClick="SwitchMenu('sub8')">Testing</div>
		<span class="submenu" id="sub8">
			<li><a class="sub" href="/testing/index.cfm" target="mainFrame">Upload excel file</a></li>
		</span>
		
	  	</span>
	</div> --->
	</div>
<cfelse>

<cfoutput>
<div id="masterdiv">
	<cfif title_define[100000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub1')">Payments</div>
	</cfif>
	<span class="submenu" id="sub1">
		<cfif title_define[110000] eq "TRUE">
  		<li><a class="sub" href="/payments/1stHalf/1stHalfList.cfm" target="mainFrame">1st Half Payroll</a></li>
         <cfif left(dts,4) eq "beps">
                <li><a class="sub" href="/payments/1stHalf/CashBankOthers/netPayCBOChequeMain.cfm" target="mainFrame">1st Half Cheque Link</a></li>
				</cfif>
		</cfif>
		<cfif title_define[120000] eq "TRUE">
		<li><a class="sub" href="/payments/2ndHalf/2ndHalfList.cfm" target="mainFrame">2nd Half Payroll</a></li>
        <cfif left(dts,4) eq "beps">
                <li><a class="sub" href="/payments/2ndHalf/CashBankOthers/netPayCBOChequeMain.cfm" target="mainFrame">2nd Half Cheque Link</a></li>
				</cfif>
		</cfif>
		<cfif title_define[130000] eq "TRUE">
		<li><a class="sub" href="/payments/bonus/bonusList.cfm" target="mainFrame">Bonus</a></li>
		</cfif>
		<cfif title_define[140000] eq "TRUE">
		<li><a class="sub" href="/payments/commission/commissionList.cfm" target="mainFrame">Commission</a></li>
		</cfif>
		<cfif title_define[150000] eq "TRUE">
		<li><a class="sub" href="/payments/extra/extraList.cfm" target="mainFrame">Extra</a></li>
		</cfif>
		<cfif title_define[160000] eq "TRUE">
		<li><a class="sub" href="/payments/2HBCE/2HBCEList.cfm" target="mainFrame">2nd Half + Bonus + Commission + Extra</a></li>
		</cfif>
<cfif title_define[170000] eq "TRUE">
		<li><a class="sub" href="/payments/weeklyPayroll/weeklyPayrollList.cfm" target="mainFrame">Weekly Payroll</a></li>
		</cfif>
		<cfif title_define[180000] eq "TRUE">
        <li><a class="sub" href="/payments/leavemaintainance.cfm" target="mainFrame">Leave Approval</a></li>
		</cfif>
		<cfif title_define[190000] eq "TRUE">
        <li><a class="sub" href="/payments/Claim/Claimlist.cfm" target="mainFrame">Claim</a></li>
		</cfif>
         <cfif title_define[190000] eq "TRUE">
        	<li><a class="sub" href="/projectcalendar/" target="mainFrame">Project Calendar</a></li>
            <li><a class="sub" href="/calendar/assignduty.cfm" target="mainFrame">Pay Calendar</a></li>
			</cfif>
	</span>

	<cfif title_define[200000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub2')">Personnel</div>
	</cfif>
	<span class="submenu" id="sub2">
		<cfif title_define[210000] eq "TRUE">
  		<li><a class="sub" href="/personnel/employee/employeeMain.cfm" target="mainFrame">Add/Update Employees</a></li>
		</cfif>
		<cfif title_define[220000] eq "TRUE">
		<li><a class="sub" href="/personnel/workingdaygroup_main.cfm" target="mainFrame">Update Working Days</a></li>
		</cfif>
		<cfif title_define[230000] eq "TRUE">
		<!--- <li><a class="sub" href="/personnel/updateWorkingDays.cfm" target="mainFrame">Update Working Days</a></li> --->
        <li><a class="sub" href="/personnel/updateLeaveFundEntitledMain.cfm" target="mainFrame">Update Leave / Fund Entitled</a></li>
		</cfif>
		<cfif title_define[240000] eq "TRUE">
		<li><a class="sub" href="/personnel/updateAWnDEDMain.cfm" target="mainFrame">Update Allowance And Deduction</a></li>
		</cfif>
		<cfif title_define[250000] eq "TRUE">
		<li><a class="sub" href="/personnel/checkListEmployeeMain.cfm" target="mainFrame">Check / List Employees</a></li>
		</cfif>
		<cfif title_define[260000] eq "TRUE">
		<li><a class="sub" href="/personnel/reports/pReportMain.cfm" target="mainFrame">Personnel Report</a></li>
		</cfif>
		<cfif title_define[270000] eq "TRUE">
		<li><a class="sub" href="/personnel/maintenance/categoryList.cfm" target="mainFrame">Category Maintenance</a></li>
		</cfif>
		<cfif title_define[280000] eq "TRUE">
		<li><a class="sub" href="/personnel/updateHistoricalRecordsMain.cfm" target="mainFrame">Update History Records</a></li>
		</cfif>
		<cfif title_define[290000] eq "TRUE">
		<li><a class="sub" href="/personnel/historicalListing/historicalListingList.cfm" target="mainFrame">History Listing</a></li>
		
		<li><a class="sub" href="/personnel/generateBasicRateIncrement/list.cfm" target="mainFrame">Generate Basic Rate Increment</a></li>
		<li><a class="sub" href="/personnel/employeeCPF/list.cfm" target="mainFrame">Employee CPF Table Maintenance</a></li></cfif>
	</span>

	<cfif title_define[300000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub3')">Government</div>
	</cfif>
	<span class="submenu" id="sub3">
		<cfif title_define[310000] eq "TRUE">
		<li><a class="sub" href="/government/CPF91/CPF91List.cfm" target="mainFrame">CPF 91</a></li>
		</cfif>
		<cfif title_define[320000] eq "TRUE">
		<li><a class="sub" href="/government/IR8A/IR8AList.cfm" target="mainFrame">IR8A</a></li>
		</cfif>
	</span>
	
	<cfif title_define[400000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub4')">Miscellaneous</div>
	</cfif>
	<span class="submenu" id="sub4">
		<cfif title_define[410000] eq "TRUE">
		<li><a class="sub" href="/miscellaneous/printOtherReports/printOtherReportsList.cfm" target="mainFrame">Print Other Reports</a></li>
<!--- 		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Export/ Import Payroll Records</a></li>
		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Export Payroll Records To Excel</a></li>
		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Export CSV/ TXT File</a></li> --->
		</cfif>
		<cfif title_define[420000] eq "TRUE">
		<li><a class="sub" href="/miscellaneous/checkFile/checkfile.cfm" target="mainFrame">Check File</a></li>
		</cfif>
		<cfif title_define[430000] eq "TRUE">
		<li><a class="sub" href="/miscellaneous/PostToDaccount/PostToDaccountList.cfm" target="mainFrame">Post To Daccount</a></li>
<!--- 		<li><a class="sub" href="/miscellaneous/ubsHRMSOption/ubsHRMSOptionList.cfm" target="mainFrame">UBS HRMS Option</a></li>
		<li><a class="sub" href="/miscellaneous/accuredAccountMaintenanceMain.cfm" target="mainFrame">Accrued Account Maintenance</a></li>
		<li><a class="sub" href="/miscellaneous/postToDaccount/postToDaccountList.cfm" target="mainFrame">Post To Daccount</a></li>
		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Note On Importing</a></li>
		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">External Application</a></li> --->
  		</cfif>
	</span>
	<cfif title_define[500000] eq "TRUE">
	<div class="menutitle" onClick="SwitchMenu('sub5')">Monthly & Yearly</div>
	</cfif>
	<span class="submenu" id="sub5">
		<cfif title_define[510000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/monthToDatePayReport/monthToDatePayReports.cfm" target="mainFrame">Month To Date Pay Listing</a></li>
		</cfif>
		<cfif title_define[520000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/figUpdate.cfm" target="mainFrame">12 Months Figures Update</a></li>
		</cfif>
		<cfif title_define[570000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/cal12MonthFiguresMain.cfm" target="mainFrame">Calculate 12 Months Figures</a></li>
		</cfif>
		<cfif title_define[530000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/12monthYearlyReport/12monthYearlyReport.cfm" target="mainFrame">12 Months Yearly Reports</a></li>
		</cfif>
		<cfif title_define[540000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/recalculateALL.cfm" target="mainFrame">Recalculate MTD, YID & Taxable AW, OT, DED</a></li>
		</cfif>
		<cfif title_define[550000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/yearToDatePayReport/yearToDatePayReports.cfm" target="mainFrame">Year To Date Pay Reports</a></li>
		</cfif>
		<cfif title_define[560000] eq "TRUE">
		<li><a class="sub" href="/monthlyAndyearly/pastMonthPay.cfm" target="mainFrame">Past Months Pay Transaction</a></li>
  		</cfif>
	</span>
	
	<cfif title_define[600000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub6')">Housekeeping</div>
	</cfif>
	<span class="submenu" id="sub6">
		<cfif title_define[610000] eq "TRUE">
		<li><a class="sub" href="/housekeeping/setupList.cfm" target="mainFrame">Setup</a></li>
		</cfif>
		<cfif title_define[620000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/maintainPassword.cfm" target="mainFrame">Maintain Password</a></li>
		</cfif>
		<cfif title_define[630000] eq "TRUE">
		<li><a class="sub" href="/housekeeping/FileReOrganisation/fileReOrganisationList.cfm" target="mainFrame">File Re-Organisation</a></li>
		</cfif>
		<cfif title_define[640000] eq "TRUE">
		<li><a class="sub" href="/housekeeping/monthEndMain.cfm" target="mainFrame">Month End</a></li>
        <li><a class="sub" href="/supermenu/backupdata/index.cfm" target="mainFrame">Back Up Data</a></li>
		</cfif>
		<cfif title_define[650000] eq "TRUE">
		<li><a class="sub" href="/housekeeping/yearEndMain.cfm" target="mainFrame">Year End</a></li>
		</cfif>
        <cfif title_define[650000] eq "TRUE">
		<li><a class="sub" href="/housekeeping/reorganise/" target="mainFrame">Pay Data Reorganise</a></li>
		</cfif>
<!--- 		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Enquiries</a></li>
		<li><a class="sub" href="/housekeeping/backupRestoreList.cfm" target="mainFrame">Backup And Restore</a></li>
		<li><a class="sub" href="/underconstruction.cfm" target="mainFrame">Menu Control Manager</a></li> --->
<!---         <li><a class="sub" href="/housekeeping/createuser.cfm" target="mainFrame">Create User</a></li> --->
		
		<cfif husergrpid eq "super" or title_define[660000] eq "TRUE">
			<li><a class="sub" href="/housekeeping/Vuser.cfm" target="mainFrame">User Administration</a></li>
		</cfif>
		<cfif husergrpid eq "super" or title_define[670000] eq "TRUE">	
			<li><a class="sub" href="/housekeeping/checkAudit.cfm" target="mainFrame">Check Audit</a></li>
		</cfif>
		<cfif HcomID eq "demo">
		<cfif title_define[650000] eq "TRUE">
			<li><a class="sub" href="/login/loginsample.cfm" target="mainFrame">Login</a></li>
		</cfif>
		</cfif>
	</span>
	
	<cfif title_define[700000] eq "TRUE">
		<div class="menutitle" onClick="SwitchMenu('sub7')">Wizard</div>
	</cfif>
	<span class="submenu" id="sub7">
		<cfif title_define[710000] eq "TRUE">
		<li><a class="sub" href="/wizard/wizard.cfm" target="mainFrame">Add Employee Wizard</a></li>
		</cfif>
	</span>
	
	<cfif husergrpid eq "super">
		<div class="menutitle" onClick="SwitchMenu('sub8')">Super Menu</div>
		<span class="submenu" id="sub8">
			<li><a class="sub" href="/supermenu/info.cfm" target="mainFrame">Information Update</a></li>
			<li><a class="sub" href="/housekeeping/info/info.cfm" target="mainFrame">Add Info</a></li>
            <li><a class="sub" href="/supermenu/backupdata/index.cfm" target="mainFrame">Back Up Data</a></li>
            <li><a class="sub" href="/supermenu/backupdata/restore.cfm" target="mainFrame">Restore Data</a></li>
			<li><a class="sub" href="/supermenu/yearendprocess_main.cfm" target="mainFrame">Year End Process</a></li>
            <li><a class="sub" href="/importemployee/uploadfile.cfm" target="mainFrame">Import Employee From Excel</a></li>
            <li><a class="sub" href="/supermenu/UpdatePaySlipTemplate.cfm" target="mainFrame">Update Pay Slip Template</a></li>	
            	<li><a class="sub" href="/supermenu/copycompanyprofile.cfm" target="mainFrame">Copy Company Profile</a></li>
                <li><a class="sub" href="/supermenu/comparemonthleave.cfm" target="mainFrame">Compare Leave</a></li>		
		</span>
	</cfif>
<!--- </div>

	<div class="menutitle" onClick="SwitchMenu('sub8')">Testing</div>
	<span class="submenu" id="sub8">
		<li><a class="sub" href="/testing/index.cfm" target="mainFrame">Upload excel file</a></li>
	</span>
	
  	</span>
</div> --->
</div>
</cfoutput>
</cfif>


</body>
</html>
