<cfcomponent>
	<cffunction name="calwday" access="public" returntype="any" >
		<cfargument name="wday" required="yes">
		<cfargument name="salarypaytype" required="yes">
		<cfargument name="Date_sys" required="yes">
		<cfargument name="empno" required="yes">
		<cfargument name="emp_pay_time" required="yes">
		<cfargument name="comp_pay_time" required="yes">
		<cfargument name="emp_grp" required="no">
		<cfargument name="db" required="yes">
		
		<cfif wday eq "" OR wday eq 0 AND salarypaytype eq "M">
			<cfset MMONTH= dateformat(Date_sys,"mm")>
			<cfif MMONTH eq "01">
				<cfset comp_month = "JAN" >
			<cfelseif MMONTH eq "02">
				<cfset comp_month = "FEB">
			<cfelseif MMONTH eq "03">
				<cfset comp_month = "MAR">	
			<cfelseif MMONTH eq "04">
				<cfset comp_month = "APRIL">
			<cfelseif MMONTH eq "05">
				<cfset comp_month = "MAY">
			<cfelseif MMONTH eq "06">
				<cfset comp_month = "JUN">
			<cfelseif MMONTH eq "07">
				<cfset comp_month = "JULY">
			<cfelseif MMONTH eq "08">
				<cfset comp_month = "AUG">
			<cfelseif MMONTH eq "09">
				<cfset comp_month = "SEPT">
			<cfelseif MMONTH eq "10">
				<cfset comp_month = "OCT">	
			<cfelseif MMONTH eq "11">
				<cfset comp_month = "NOV">
			<cfelseif MMONTH eq "12">
				<cfset comp_month = "DECB">
			</cfif>
			
			<cfoutput>
			
				
			<cfquery name="wdtable_qry" datasource="#db#">
				SELECT #comp_month# from wdgroup 
				where groupwp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_grp#">
			</cfquery>
			</cfoutput>
			<cfset wday = #val(wdtable_qry["#comp_month#"][1])# >
			
			<cfif emp_pay_time eq "0">
				<cfset pay_times = comp_pay_time>
			<cfelseif emp_pay_time eq "1">
				<cfset pay_times = 1>
			<cfelseif emp_pay_time eq "2">
				<cfset pay_times = 2>
			</cfif>
			
			<cfset myResult = wday/pay_times>
			
		<cfelse>	
			<cfset myResult = wday>
		</cfif>	
		
		<cfreturn myResult>
	</cffunction>
</cfcomponent>