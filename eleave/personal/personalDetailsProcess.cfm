
<cftry>
<cfquery name="checkedit" datasource="payroll_main">
SELECT eportapp FROM gsetup2 WHERE comp_id ='#HComID#'
</cfquery>

<cfquery name="update_pmast" datasource="#DSNAME#">
UPDATE pmast 
SET 
<cfif checkedit.eportapp eq "N">
add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">, 
add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">, 
phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">, 
edu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.edu#">,
</cfif>
email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">
WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#">
</cfquery>

<cfquery name="update_email" datasource="#DSNAME#">
UPDATE EMP_USERS 
SET 
add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">, 
add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">, 
phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">, 
edu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.edu#">,
<cfif checkedit.eportapp eq "Y">
changes = "Y",
</cfif> 
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
