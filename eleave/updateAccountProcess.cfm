

<cfset username = form.username >
<cfquery name="validate_user" datasource="payroll_main">
SELECT * FROM USERS WHERE username = "#username#"
</cfquery>
<cfquery name="validate_user1" datasource="#DSNAME#">
SELECT * FROM emp_USERs WHERE (username = "#username#" and username != "#HUserID#")
</cfquery>

<cfif validate_user.recordcount eq 0 and validate_user1.recordcount eq 0>
<cftry>
<cfset userid = form.userid>
<cfquery name="update_emp_account" datasource="#DSNAME#">
UPDATE EMP_USERS SET username = "#form.username#" , userpass = "#hash(form.password)#" , email = "#form.email#", firsttime = "N" WHERE user_id = "#userid#"
</cfquery>
<cfquery name="getempno" datasource="#DSNAME#">
SELECT empno FROM emp_users WHERE user_id = "#userid#"
</cfquery>
<cfquery name="update_pmast_email" datasource="#DSNAME#">
UPDATE PMAST SET email = "#form.email#" WHERE empno = "#getempno.empno#"
</cfquery>
<cfset status_msg="Success Update Account Details. Please Relogin!">
<cfcatch type="database">
<cfset status_msg="Fail To Update Account Details. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>
<cfoutput>
<script type="text/javascript">
alert('#status_msg#');
</script>
<form name="pc"  action="/eleave/logout.cfm" method="post"></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>

<cfelse>

<cfoutput>
<script langauge="javascript">alert("The username is existed, please enter a new one");history.go(-1);</script>
</cfoutput>
</cfif>