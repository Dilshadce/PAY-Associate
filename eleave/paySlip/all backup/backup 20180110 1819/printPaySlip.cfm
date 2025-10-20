<h2> We are currently doing maintenance on payslip.
<br> Maintenance will be done approximately 2018-01-10 6:00 PM.
<br> We are sorry for any inconvenience caused.</h2> <cfabort>

<cfquery name="getComp" datasource="payroll_main">
	SELECT mmonth from gsetup WHERE comp_id = "#HComID#";
</cfquery>

<!---<cfset finalmmonth = #getComp.mmonth#>		<!---this is to manipulate how many months back payslip is available--->
<cfif #getComp.mmonth# EQ '9'>
	<cfset finalmmonth -= 1>
<cfelse>
	<cfset finalmmonth -= 2>
</cfif>

<cfif #HcomID# EQ 'manpowertest'>
    <cfset finalmmonth = #getComp.mmonth# - 1>
</cfif>

<!---<cfif #HUserID# EQ "1izzad@my.ibm.com" OR #HUserID# EQ "1shawa@my.ibm.com" OR #HUserID# EQ "1celine@my.ibm.com">
    <cfset finalmmonth -= 1>
</cfif>--->

<cfif #HUserID# eq "furankurin@gmail.com">
	<cfset finalmmonth -= 1>
</cfif>--->
<cfset finalmmonth = "#getComp.mmonth#">

<html>
	<head>
	</head>
	
	<body>
		<label>Select Month</label>
        <form method="POST" action="PayslipFilter.cfm">
		<select name="month">
			<cfloop from="1" to="#finalmmonth#" index="i">
				<option value="<cfoutput>#i#</cfoutput>"><cfoutput>#MonthAsString(i)#</cfoutput></option>
			</cfloop>
		</select>
		<input type="submit" value="go" name="dumm">
		</form>
	</body>
</html>