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
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Netiquette Payroll Management System</title>
<link rel="shortcut icon" href="/PMS.ico" />

</head>
<!---
<frameset cols="218px,*" border="0">
	<frame frameborder="no" name="leftFrame" noresize="noresize" scrolling="no" src="/latest/side/sidemenu.cfm" />
	<frameset rows="68px,*" border="0">
		<frame frameborder="no" name="topFrame" noresize="noresize" scrolling="no" src="/latest/header/header.cfm" />
		<frame frameborder="no" name="mainFrame" id="mainFrame" noresize="noresize" scrolling="yes" src="/latest/body/overview.cfm" />
	</frameset>
</frameset> --->

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
