
<cftry>
<cfquery name="update_pmast" datasource="#DSNAME#">
UPDATE pmast 
SET 
add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">, 
add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">, 
phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">, 
edu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.edu#">,
email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#">
</cfquery>
<cfquery name="update_email" datasource="#DSNAME#">
UPDATE EMP_USERS 
set 
email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#"> 
WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#">
</cfquery>

<cfset status_msg="Success Update Personal Details.">
<cfcatch type="database">
<cfset status_msg="Fail To Update Personal Details. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>
<cfoutput>
<script type="text/javascript">
alert("#status_msg#");
</script>
<form name="pc"  action="/eleave/personal/personalDetails.cfm" method="post">
</cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>
