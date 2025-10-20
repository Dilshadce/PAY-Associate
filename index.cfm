<cfif isuserinrole("employee")>
<cflocation url="/logout.cfm" addtoken="no">
<cfabort>
</cfif>
<cfif NOT #IsDefined('dts')#>
    <cfset dts = "#dsname#">
</cfif>
<cfset checkcomid = replacenocase(dts,'_p','')>
<cfquery name="getstart" datasource="payroll_main">
	SELECT * FROM startupwarning
	WHERE (comid='#checkcomid#' or comid='all')
	limit 1
</cfquery>
<cfif getstart.recordcount neq 0 and (getstart.message neq "" or getstart.details neq "") and not isdefined("url.check")>
 	<cfinclude template="/startupwarning/startupwarning.cfm">
<cfelse>

<!---<cfquery name="checklog" datasource="payroll_main">
	SELECT userlogid FROM userlog WHERE udatabase='#hcomid#'
</cfquery>--->

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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
<link rel="shortcut icon" href="/images/mp.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>MP4U</title>
</head>
<!---
<frameset cols="218px,*" border="0">
	<frame frameborder="no" name="leftFrame" noresize="noresize" scrolling="no" src="/side/sidemenu.cfm" />
	<frameset rows="68px,*" border="0">
		<frame frameborder="no" name="topFrame" noresize="noresize" scrolling="no" src="/header/header.cfm" />
		<frame frameborder="no" name="mainFrame" id="mainFrame" noresize="noresize" scrolling="yes" src="/body/overview.cfm" />
	</frameset>
</frameset> --->

    <cfoutput>
        <cfif dts EQ 'manpower_p'>
            <cfif IsDate(lastChangedDate)>
                <cfif DateDiff("d",lastChangedDate,currentTime) GTE #passwordExpiryDays#> 
                    <script type="text/javascript">
                        alert('Your password has expired and must be changed! You will be redirected to change password page....');
                        window.open('../housekeeping/maintainPassword.cfm?fromMainPage=1','_self');
                    </script>
                    <cfabort>
                </cfif> 

                <cfif DateDiff("d",lastChangedDate,currentTime) EQ #reminderExpiry#> 
                    <script type="text/javascript">
                        alert('Your password will expire in #reminderExpiryDays# days! Please change it as soon as possible.');
                    </script>
                </cfif>       
            </cfif>

            <cfif getPasswordHistory.recordcount EQ 0> 
                <script type="text/javascript">
                    alert('Welcome On Board MP4U! You are required to change your password....');
                    window.open('../housekeeping/maintainPassword.cfm?fromMainPage=1','_self');
                </script>
                <cfabort>
            </cfif> 
    </cfif>
    </cfoutput>    

<frameset cols="218px,*" border="0">
    <frame frameborder="no" name="leftFrame" noresize="noresize" scrolling="no" src="side/sidemenu.cfm" />
    <frameset rows="68px,*" border="0">
        <frame frameborder="no" name="topFrame" noresize="noresize" scrolling="no" src="/header/header.cfm" />
        <frame frameborder="no" name="mainFrame" id="mainFrame" noresize="noresize" scrolling="yes" src="/body/overview.cfm" />
    </frameset>
</frameset>

<noframes>Sorry, please use browser with support frameset while using this systen.</noframes>
</html>

</cfif>