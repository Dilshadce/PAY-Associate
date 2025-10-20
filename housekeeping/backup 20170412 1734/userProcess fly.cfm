<cfif IsDefined('url.userID')>
	<cfset URLuserID = trim(urldecode(url.userID))>
</cfif>

<cfif IsDefined('url.companyID')>
	<cfset URLuserCompanyID = LCASE(trim(urldecode(url.companyID)))>
</cfif>

<cfoutput>
<cfset status = ''>

<cfif isdefined("url.action")>
	<cfif url.action eq "Delete">
		<cfquery datasource='payroll_main' name="deleteUser">
			delete from users 
			where userId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLuserID#">;
		</cfquery>
		
		<cfset status = "The User #URLuserID# Has Been Deleted. ">
		
		<form name="done" action="/housekeeping/vUser1.cfm?process=done&companyid=#URLuserCompanyID#" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			alert("User <cfoutput>#URLuserID#</cfoutput> Has Been Deleted !");
			done.submit();
		</script>
        </cfif>
<cfelseif form.mode eq "Edit">

		<cfset username = form.username >
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
		<cfset status="The User #form.userName# Has Been Updated. ">
		
		<form name="done" action="/housekeeping/vUser1.cfm?process=done&companyid=#form.userDsn#" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			alert("#status#");
			done.submit();
		</script>

	
</cfif>

</cfoutput>
</body>
</html>