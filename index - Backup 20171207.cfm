
<cfif isuserinrole("employee")>
<cflocation url="/logout.cfm" addtoken="no">
<cfabort>
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

<cfquery name="checklog" datasource="payroll_main">
	SELECT userlogid FROM userlog WHERE udatabase='#hcomid#'
</cfquery>


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