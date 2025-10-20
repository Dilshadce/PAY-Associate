<!---cfimport prefix="ctag" taglib="/extensions/customtags/">
<cfset ses = event.getArg("sessionUser")>

<cfsavecontent variable="actionLink">
	<a href="../index.cfm?event=housekeeping.maintenance.raceEdit&id=#racecode#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/edit.ICO" alt="Edit" border="0">Edit</a> || 
	<a href="../index.cfm?event=housekeeping.maintenance.raceRemove&id=#racecode#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/delete.ICO" alt="Delete" border="0">Delete</a>
</cfsavecontent--->

<html>
<head>
	<title>Add/Edit Race</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>
<body>

	<div class="mainTitle">Add / Edit Race</div>
	<cfinclude template="raceTableHeader.cfm">
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif--->

	<!---ctag:table
		useComponent="extensions.model.race.raceService"
		useMethod="getRaceInGroup"
        TableFieldList="racecode!!Race Code!!10%||racedesp!!Race Description!!60%||"
		orderBy="racedesp"
		Path="../index.cfm?event=housekeeping.setup.showRaceTableMain"
		ActionButton="#actionLink#"
		SearchType="racecode!!ID||racedesp!!Race Description"
		Dsn="#ses.userDsn#"--->
</body>
</html>