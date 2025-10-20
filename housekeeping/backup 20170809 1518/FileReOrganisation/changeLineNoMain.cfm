<html>
<head>
	<title>Change Line No.</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(lineno)
{
	document.getElementById("alineno").innerHTML = document.getElementById("lineno_"+lineno).value;
	document.getElementById("olineno").value = document.getElementById("lineno_"+lineno).value;/*To get the old lineno for update purpose*/
}
function check1(){

	if(document.getElementById("olineno").value==""&&document.getElementById("nlineno").value=="")
	{
	alert("Please select a Line No from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("olineno").value==""){
	alert("Please select an Line No from the table above.");
	return false;
	}
	else if(document.getElementById("nlineno").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="line_qry" datasource="#dts#">
SELECT lineno, desp
FROM tlineno
ORDER BY lineno
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=lineno" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Line No.</div>
<font color="red" size="2,5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<div style="width:450px;height:500px;overflow:auto;">
<table class="form">
<tr>
	<th width="120px">Line No.</th>
	<th width="300px">Description</th>
</tr>

<cfloop query="line_qry">
<tr onClick="showFoot('#line_qry.currentrow#');" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
	<td>#line_qry.lineno#</td>
	<td>#line_qry.desp#</td>
</tr>

	<input type="hidden" name="lineno_#line_qry.currentrow#" id="lineno_#line_qry.currentrow#" value="#line_qry.lineno#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Line No.</th>
	<td width="100px"><label id="alineno"></label>
	<input type="hidden" name="olineno" id="olineno" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="nlineno" value="" size="12"></td>
</tr>
<tr>
	<td colspan="4" align="right"><br />
		<input type="submit" name="submit" value="OK">
		<input type="button" name="exit" value="Exit" onClick="window.location='/housekeeping/fileReOrganisation/fileReOrganisationList.cfm'">
	</td>
</tr>
</table>

</form>
</cfoutput>
</body>

</html>