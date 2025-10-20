<!---cfimport prefix="ctag" taglib="/extensions/customtags/">
<cfset ses = event.getArg("sessionUser")>

<cfsavecontent variable="actionLink">
	<a href="../index.cfm?event=housekeeping.maintenance.religionEdit&id=#relcode#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/edit.ICO" alt="Edit" border="0">Edit</a> || 
	<a href="../index.cfm?event=housekeeping.maintenance.religionRemove&id=#relcode#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/delete.ICO" alt="Delete" border="0">Delete</a>
</cfsavecontent--->

<html>
<head>
	<title>Add / Edit Religion</title>
	<link href="../shared/css/app.css" rel="stylesheet" type="text/css">
</head>
<body>

	<div class="mainTitle">Add / Edit Religion</div>
	<cfinclude template="religionTableHeader.cfm">
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif--->

	<!---ctag:table
		useComponent="extensions.model.religion.religionService"
		useMethod="getReligionInGroup"
        TableFieldList="relcode!!Religion Code!!10%||reldesp!!Religion Description!!60%||"
		orderBy="reldesp"
		Path="../index.cfm?event=housekeeping.setup.showReligionTableMain"
		ActionButton="#actionLink#"
		SearchType="relcode!!ID||reldesp!!Religion Description"
		Dsn="#ses.userDsn#"--->
</body>
</html>