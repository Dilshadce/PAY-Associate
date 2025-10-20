<cfquery name="getComp" datasource="payroll_main">
	SELECT (mmonth-1) as mmonth from gsetup WHERE comp_id = "manpower";
</cfquery>

<html>
	<head>
	</head>

	<body>
		<label>Select Month</label>
		<form method="POST" action="printPaySlipProcess.cfm">
		<select name="month">
			<cfloop from="1" to="#getComp.mmonth#" index="i">
				<option value="<cfoutput>#i#</cfoutput>"><cfoutput>#MonthAsString(i)#</cfoutput></option>
			</cfloop>
		</select>
		<input type="submit" value="go" name="dumm">
		</form>
	</body>
</html>