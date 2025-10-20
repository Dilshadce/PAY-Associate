<cfimport prefix="ctag" taglib="/extensions/customtags/">
<cfset ses = event.getArg("sessionUser")>

<cfsavecontent variable="actionLink">
	<a href="../index.cfm?event=housekeeping.maintenance.shiftAllowanceEdit&shf_cou=#shf_cou#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/edit.ICO" alt="Edit" border="0">Edit</a>
</cfsavecontent>

<html>
<head>
	<title>Shift Allowance Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>
<body>

	<div class="mainTitle">Shift Allowance Table</div>
	<cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>

	<ctag:table
		useComponent="extensions.model.shftable.shftableService"
		useMethod="getShftableInGroup"
        TableFieldList="shf_cou!!hidden||shf_desp!!Description!!80%"
		orderBy="shf_cou"
		Path="../index.cfm?event=housekeeping.setup.showShftableMain"
		ActionButton="#actionLink#"
		SearchType=""
		Dsn="#ses.userDsn#">
		
</body>
</html>