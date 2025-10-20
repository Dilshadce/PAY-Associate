<cfquery name="change_account" datasource="#DSNAME#">
SELECT * FROM EMP_USERS WHERE UserNAME = "#HUserID#"
</cfquery>

<cfif change_account.firsttime eq "Y">
<cfoutput><form name="pc"  action="/eleave/updateAccount.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="userid" value="#change_account.user_ID#" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>

<cfelse>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="shortcut icon" href="/images/mp.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>MP4U</title>

<cfquery name="getPasswordControl" datasource="payroll_main">
	SELECT * 
    FROM passwordControls;
</cfquery>

<cfquery name="getPasswordHistory" datasource="payroll_main">
	SELECT * 
    FROM passwordHistory
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY updatedOn DESC
    LIMIT 1;
</cfquery>

<cfset lastChangedDate = DateFormat(getPasswordHistory.updatedOn,"YYYY/MM/DD")>
<cfset currentTime = DateFormat(NOW(),"YYYY/MM/DD")>
<cfset passwordExpiryDays = getPasswordControl.expiryDays>
<cfset reminderExpiryDays = getPasswordControl.reminderChangePasswordDays> 
<cfset reminderExpiry = val(passwordExpiryDays - getPasswordControl.reminderChangePasswordDays)>

</head>
<!---
<frameset cols="218px,*" border="0">
	<frame frameborder="no" name="leftFrame" noresize="noresize" scrolling="no" src="/latest/side/sidemenu.cfm" />
	<frameset rows="68px,*" border="0">
		<frame frameborder="no" name="topFrame" noresize="noresize" scrolling="no" src="/latest/header/header.cfm" />
		<frame frameborder="no" name="mainFrame" id="mainFrame" noresize="noresize" scrolling="yes" src="/latest/body/overview.cfm" />
	</frameset>
</frameset> --->
    <cfquery name="checkpdpa" datasource="#dsname#">
         SELECT * FROM pdpaupdatelog WHERE userid = "#GetAuthUser()#" and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_comp.empno#">
    </cfquery>
    <cfif checkpdpa.recordcount eq 0>
        <cflocation url="/pdpa.cfm" addtoken="no">
        <cfabort>
    <cfelse>
        <cfif checkpdpa.eform_updated eq "N">
            <cflocation url="/eform/" addtoken="no">
            <cfabort>
        </cfif>
    </cfif>
    
    <cfoutput>
        <cfif dsname EQ 'manpower_p'>
            <cfif IsDate(lastChangedDate)>
                <cfif DateDiff("d",lastChangedDate,currentTime) GTE #passwordExpiryDays#> 
                    <script type="text/javascript">
                        alert('Your password has expired and must be changed! You will be redirected to change password page....');
                        window.open('../eleave/personal/personalAccount.cfm?fromMainPage=1','_self');
                    </script>
                    <cfabort>
                </cfif> 

                <cfif DateDiff("d",lastChangedDate,currentTime) EQ #reminderExpiry#> 
                    <script type="text/javascript">
                        alert('Your password will expiry in #reminderExpiryDays# days! Please change it as soon as possible.');
                    </script>
                </cfif>       
            </cfif>

            <cfif getPasswordHistory.recordcount EQ 0> 
                <script type="text/javascript">
                    alert('Welcome On Board MP4U! You are required to change your password....');
                    window.open('../eleave/personal/personalAccount.cfm?fromMainPage=1','_self');
                </script>
                <cfabort>
            </cfif> 
    </cfif>
    </cfoutput>    
    
<frameset cols="218px,*" border="0">
    <frame frameborder="no" name="leftFrame" noresize="noresize" scrolling="no" src="/eleave/frame/<cfif left(DSNAME,4) eq "beps">leftbeps.cfm<cfelse>sidemenu.cfm</cfif>" />
    <frameset rows="68px,*" border="0">
        <frame frameborder="no" name="topFrame" noresize="noresize" scrolling="no" src="/eleave/frame/header.cfm" />
        <frame frameborder="no" name="mainFrame" id="mainFrame" noresize="noresize" scrolling="yes" src="/eleave/<cfif left(DSNAME,4) eq "beps">beps/bepsmenu.cfm<cfelse>overview.cfm</cfif>" />      
    </frameset>
</frameset>

<noframes>Sorry, please use browser with support frameset while using this system.</noframes>
</html>
</cfif>
