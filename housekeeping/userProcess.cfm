<cfif left(trim(form.userId),5) eq "ultra" and husergrpid neq "super">
<cfabort>
</cfif>
<html>
<head>
<title>User Process</title>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfparam name="status" default="">

	<cfif  form.mode eq "Delete">
		<cfquery datasource='payroll_main' name="deleteUser">
			delete from users 
			where userId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.userId#">;
		</cfquery>
		
		<cfset status = "The user, #form.userName# had been successfully deleted. ">
		
		<form name="done" action="/housekeeping/vUser.cfm?process=done" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			alert("User <cfoutput>#form.userid#</cfoutput> Has Been Deleted !");
			done.submit();
		</script>
	<cfelseif form.mode eq "Edit">
		<cfset username = form.username >
        
        <cfif REFind("[^[:alpha:]_\.]", form.userpwd, 1) GT 0>
            <cfoutput>
            #REFind("[^[:alpha:]_\.]", form.userpwd, 1)#
            </cfoutput>
            <cfabort>
        </cfif>
        
        <cfif form.userpwd neq "">
		<cfset userpwd = hash(form.userpwd)>
        </cfif>
	
		
		<cfquery datasource='payroll_main' name="editUser">
			update users set 
            <cfif form.userpwd neq "">
			userPwd='#userpwd#',
            </cfif>
			userGrpID='#form.userGrpID#',
			userName='#username#',
			userDsn='#form.userDsn#',
			userCmpID='#form.userCmpID#',
			userCty='#form.usercty#',
			userEmail='#form.userEmail#',
            getmail = <cfif isdefined('form.getmail')>"Y"<cfelse>"N"</cfif>,
            pilotrep = <cfif isdefined('form.pilotrep')>"Y"<cfelse>"N"</cfif>,
            mobileaccess = <cfif isdefined('form.mobileaccess')>"Y"<cfelse>"N"</cfif>
			where userId='#form.userId#';
		</cfquery>
		<cfset status="The user, #form.userName# had been successfully edited. ">
		
		<form name="done" action="/housekeeping/vUser.cfm?process=done" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			alert("User <cfoutput>#form.userid#</cfoutput> Has Been Edited !");
			done.submit();
		</script>
	</cfif>
	


</body>
</html>