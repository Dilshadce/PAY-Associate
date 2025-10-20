<html>
<head>
	<title>Change Project</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(project)
{
	document.getElementById("aproject").innerHTML = document.getElementById("project_"+project).value;
	document.getElementById("oproject").value = document.getElementById("project_"+project).value;/*To get the old ID for update purpose*/
}
function check1(){

	if(document.getElementById("oproject").value==""&&document.getElementById("nproject").value=="")
	{
	alert("Please select a Project from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("oproject").value==""){
	alert("Please select a Project from the table above.");
	return false;
	}
	else if(document.getElementById("nproject").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="pro_qry" datasource="#dts#">
SELECT project, desp
FROM project
ORDER BY project
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=project" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Project</div>
<font color="red" size="2,5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<div style="width:450px;height:500px;overflow:auto;">
<table class="form">
<tr>
	<th width="120px">Project</th>
	<th width="300px">Description</th>
</tr>

<cfloop query="pro_qry">
<tr onClick="showFoot('#pro_qry.currentrow#');">
	<td>#pro_qry.project#</td>
	<td>#pro_qry.desp#</td>
</tr>

	<input type="hidden" name="project_#pro_qry.currentrow#"  id="project_#pro_qry.currentrow#" value="#pro_qry.project#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Project</th>
	<td width="100px"><label id="aproject"></label>
	<input type="hidden" name="oproject" id="oproject" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="nproject" value="" size="40"></td>
</tr>
<tr>
	<td colspan="4" align="right"><br />
		<input type="submit" name="submit" value="OK">
		<input type="button" name="exit" value="Exit" onClick="window.location='/body/bodymenu.cfm?id=52'">
	</td>
</tr>
</table>

</form>
</cfoutput>
</body>

</html>