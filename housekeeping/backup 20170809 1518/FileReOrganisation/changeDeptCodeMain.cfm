<html>
<head>
	<title>Change Department</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(deptcode)
{
	document.getElementById("adeptcode").innerHTML = document.getElementById("deptcode_"+deptcode).value;
	document.getElementById("odeptcode").value = document.getElementById("deptcode_"+deptcode).value;/*To get the old deptcode for update purpose*/
}
function check1(){

	if(document.getElementById("odeptcode").value==""&&document.getElementById("ndeptcode").value=="")
	{
	alert("Please select a Department from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("odeptcode").value==""){
	alert("Please select an Department from the table above.");
	return false;
	}
	else if(document.getElementById("ndeptcode").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="dept_qry" datasource="#dts#">
SELECT deptcode, deptdesp
FROM dept
ORDER BY deptcode
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=deptcode" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Department</div>
<font color="red" size="2,5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<div style="width:450px;height:500px;overflow:auto;">
<table class="form">

<tr>
	<th width="120px">Department</th>
	<th width="300px">Description</th>
</tr>

<cfloop query="dept_qry">
<tr onClick="showFoot('#dept_qry.currentrow#');" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
	<td>#dept_qry.deptcode#</td>
	<td>#dept_qry.deptdesp#</td>
</tr>

	<input type="hidden" name="deptcode_#dept_qry.currentrow#" id="deptcode_#dept_qry.currentrow#" value="#dept_qry.deptcode#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Department</th>
	<td width="100px"><label id="adeptcode"></label>
	<input type="hidden" name="odeptcode" id="odeptcode" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="ndeptcode" value="" size="12"></td>
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