<cfset opassw = hash(form.opass) >
<cfset npassw = hash(form.npass) >
<cftry>
	<cfquery name="validateUser" datasource="#DSNAME#">
		SELECT * 
		FROM EMP_USERS 
		WHERE 
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
		AND userPass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#opassw#">
	</cfquery>
    
    <cfif validateUser.Recordcount eq 1>
    <cfquery name="update_pass" datasource="#DSNAME#">
    UPDATE EMP_Users SET userPass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#npassw#"> WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
    </cfquery>
	<cfset status_msg="Success Update Password">
	
	<cfelse>
    <cfset status_msg = "Wrong Old Password Provided" >
	</cfif>
    

<cfcatch type="database">
<cfset status_msg="Fail To Update Password. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfoutput><form name="pc" action="/Eleave/personal/personalAccount.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>