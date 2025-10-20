<!---<h2> We are currently doing maintenance on payslip.
<br> Maintenance will be done approximately 2018-01-10 6:00 PM.
<br> We are sorry for any inconvenience caused.</h2> <cfabort>--->

<cfquery name="getComp" datasource="payroll_main">
	SELECT mmonth, myear from gsetup WHERE comp_id = "#HComID#";
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
	<cfoutput>
	<body>
		<label>Select Month and Year</label>
        <form method="POST" action="PayslipFilter.cfm">
        <select name="yearchose">
            <cfloop from="2017" to="#getComp.myear#" index="a">
                <option value="#a#" <cfif "#a#" EQ "#getComp.myear#">SELECTED</cfif>>#a#</option>
            </cfloop>
        </select>
		<select name="month">
			<cfloop from="1" to="12" index="i">
				<option value="#i#">#MonthAsString(i)#</option>
			</cfloop>
		</select>
		<input type="submit" value="Go" name="dumm">
		</form>
	</body>
    </cfoutput>
</html>