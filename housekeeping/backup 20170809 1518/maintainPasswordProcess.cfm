<cfset opassw = hash(form.opass) >
<cfset npassw = hash(form.npass) >
	
<cftry>
	<cfquery name="validateUser" datasource="#dts_main#">
		SELECT * 
		FROM 
		<cfif #Session.usercty# contains "test">
			hmuserstest
		<cfelse>
			hmusers
		</cfif>
		WHERE 
		userid="#HUserID#"
		AND userPwd="#opassw#"
	</cfquery>
   
    <cfif validateUser.Recordcount eq 1>
    <cfquery name="update_pass" datasource="#dts_main#">
    UPDATE 
    <cfif #Session.usercty# contains "test">
		hmuserstest
	<cfelse>
		hmusers
	</cfif> 
    SET userPwd = "#npassw#" WHERE userid = "#HUserID#"
    </cfquery>
	<cfset status_msg="Success Update Password">
	
	<cfelse>
    <cfset status_msg = "Wrong Old Password Provided" >
	</cfif>

<cfcatch type="database">
<cfset status_msg="Fail To Update Password. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfoutput><form name="pc" action="/housekeeping/maintainPassword.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>