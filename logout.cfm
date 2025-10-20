
<cftry>
<cfquery datasource="payroll_main">
			insert into userlog 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status
                
			) 
			values 
			(
				'#huserid#',
				now(),
				'#hcomid#',
				'#cgi.remote_Addr#',
				'Logout'
			)
</cfquery>
<cfcatch></cfcatch>
</cftry>
<cfset SessionInvalidate()>
<cflogout>
<cfoutput> 
<cfif isdefined('url.goerp')>
<cflocation url="http://payroll.netiquette.asia/login/login.cfm?logout=yes" addtoken="no">
</cfif>
<!--- <cfif lcase(HcomID) eq "simplysiti_i">
<script>
	window.open('http://simplysiti.fiatech.com.my/login/login.cfm?logout=yes', "_top");
</script>
<cfelse> --->
<script>
	window.open('/login/login.cfm?logout=yes', "_top");
</script>
<!--- </cfif>  --->
</cfoutput>
<cfabort>