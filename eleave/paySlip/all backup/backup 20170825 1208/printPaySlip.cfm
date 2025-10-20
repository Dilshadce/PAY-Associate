<cfquery name="getComp" datasource="payroll_main">
	SELECT mmonth from gsetup WHERE comp_id = "#HComID#";
</cfquery>

<cfset finalmmonth = #getComp.mmonth#>		<!---this is to manipulate how many months back payslip is available--->
<cfif #getComp.mmonth# EQ '8'>
	<cfset finalmmonth -= 1>
<cfelse>
	<cfset finalmmonth -= 2>
</cfif>

<!---<cfif #HUserID# EQ "1izzad@my.ibm.com" OR #HUserID# EQ "1shawa@my.ibm.com" OR #HUserID# EQ "1celine@my.ibm.com">
    <cfset finalmmonth -= 1>
</cfif>--->

<cfif #HUserID# eq "furankurin@gmail.com">
	<cfset finalmmonth -= 1>
</cfif>

<html>
	<head>
	</head>

	<body>
		<label>Select Month</label>
		<cfif #HComID# EQ 'manpowertest'>
		    <form method="POST" action="PayslipFilter.cfm">
		<cfelse>
		    <form method="POST" action="printPaySlipProcess.cfm">
		</cfif>
		<select name="month">
			<cfloop from="1" to="#finalmmonth#" index="i">
				<option value="<cfoutput>#i#</cfoutput>"><cfoutput>#MonthAsString(i)#</cfoutput></option>
			</cfloop>
		</select>
		<input type="submit" value="go" name="dumm">
		</form>
	</body>
</html>