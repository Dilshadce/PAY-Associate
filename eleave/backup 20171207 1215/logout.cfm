
<cfoutput> 

  <cfif isdefined('SESSION.id')>
  		<cfset dummy = structdelete(application.sessionTracker, "#session.company_name#(#session.id#)")>
		<cfset SESSION.isLogIn="No">
  </cfif>
  
<cflogout>
<script>
	window.open('/login/login.cfm?logout=yes', "_top");
</script> 
</cfoutput>
<cfabort>