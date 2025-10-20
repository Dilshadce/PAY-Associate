<cfset opassw = hash(form.opass) >
<cfset npassw = hash(form.npass) >
<cfset wrongpass = False >

<cftry>
	<cfquery name="validateUser" datasource="#DSNAME#">
		SELECT * 
		FROM EMP_USERS 
		WHERE 
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
		AND userPass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#opassw#">
	</cfquery>
        
    <cfquery name="validateHMUser" datasource="payroll_main">
		SELECT * 
		FROM 
		<cfif #Session.usercty# contains "test">
			hmuserstest
		<cfelse>
			hmusers
		</cfif>
		WHERE 
		userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
	</cfquery>
    
    <cfif validateUser.Recordcount eq 1>
        <cfquery name="update_pass" datasource="#DSNAME#">
            UPDATE EMP_Users SET userPass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#npassw#"> WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
        </cfquery>
        
        <cfquery name="insertPasswordHistory" datasource="payroll_main">
            INSERT INTO passwordHistory (userID,oldPassword,companyID,updatedOn,updatedBy)
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#opassw#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#dsname#">,
                     NOW(),
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
                )
        </cfquery>
                        
        <!---Added by Nieo 20190422 1123, to fix issues when users have both associate and hiring manager account--->
        <cfif validateHMUser.Recordcount eq 1>
            <cfquery name="update_pass" datasource="payroll_main">
            UPDATE 
            <cfif #Session.usercty# contains "test">
                hmuserstest
            <cfelse>
                hmusers
            </cfif> 
            SET userPwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#npassw#"> WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
            </cfquery>

            <cfquery name="insertPasswordHistory" datasource="payroll_main">
                INSERT INTO passwordHistory (userID,oldPassword,companyID,updatedOn,updatedBy)
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#opassw#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DSNAME#">,
                     NOW(),
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
                )
            </cfquery>
        </cfif>
        <!---Added by Nieo 20190422 1123, to fix issues when users have both associate and hiring manager account--->
        
        <!---<cfif IsDefined('url.fromMainPage')>--->
            <script>
				alert('Successfully update password! Please relogin');
				window.open('/logout.cfm','_self');
            </script>
            <cfabort>
        <!---</cfif>--->
        
        <cfset status_msg="Success Update Password">

	<cfelse>
        <cfif IsDefined('url.fromMainPage')>
            <cfset wrongpass = True>
        </cfif>
        
        <cfset status_msg = "Wrong Old Password Provided" >
	</cfif>
    

<cfcatch type="database">
<cfset status_msg="Fail To Update Password. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfif wrongpass EQ True>
    <cfoutput><form name="pc" action="/Eleave/personal/personalAccount.cfm?fromMainPage=1" method="post"></cfoutput>
<cfelse>
    <cfoutput><form name="pc" action="/Eleave/personal/personalAccount.cfm" method="post"></cfoutput>
</cfif>

<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>