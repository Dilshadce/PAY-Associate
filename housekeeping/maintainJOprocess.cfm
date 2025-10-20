<cftry>
    <cfquery name="update_pass" datasource="#dts_main#">
    UPDATE hmUsers SET approvaltype = "#form.approvaltype#" WHERE userid = "#HUserID#"
    </cfquery>

<cfcatch type="database">
<cfset status_msg="Fail To Update Password. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfoutput><form name="pc" action="/housekeeping/maintainJO.cfm" method="post"></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>