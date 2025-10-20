
<cfquery name="user_detail" datasource="#dts_main#">
		SELECT * 
		FROM USERS 
		WHERE 
		userDsn="#url.companyid#"
</cfquery>


<cfset username = form.username >
<cfset password = hash(form.npass)>
<cfset group = form.userGrpID>
<cfset useremail = form.email>

<cfquery name="validate_user" datasource="#dts_main#">
SELECT * FROM USERS WHERE username = "#username#"
</cfquery>

<cfif validate_user.recordcount gt 0 >
 <cfset status_msg = "UserName Existed, Please Choose Another One" >
<cfelse>

<cfquery name="insert" datasource="#dts_main#">
INSERT INTO users (entryID, userID, userPWD, userGrpID, userName, userCmpID, userDsn, userCty, userEmail, userDirectory,getmail,pilotrep,mobileaccess)
VALUES ("#username#","#username#", "#password#", "#group#","#username#", "#user_detail.userCmpID#", "#user_detail.userDsn#", "#user_detail.userCty#","#userEmail#","default",
<cfif isdefined('form.getmail')>"Y"<cfelse>"N"</cfif>,
<cfif isdefined('form.pilotrep')>"Y"<cfelse>"N"</cfif>,
<cfif isdefined('form.mobileaccess')>"Y"<cfelse>"N"</cfif>) 
</cfquery>
 <cfset status_msg = "User Successfully Created" >
</cfif>

<!---<cfoutput><form name="pc" action="/housekeeping/createuser.cfm?companyid=#url.companyid#" method="post">
<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>--->

<cfoutput>
<form name="pc" action="/housekeeping/vUser1.cfm?companyid=#url.companyid#" method="post">
</form>
<script>
    alert('#status_msg#');
	pc.submit();
</script>
</cfoutput>