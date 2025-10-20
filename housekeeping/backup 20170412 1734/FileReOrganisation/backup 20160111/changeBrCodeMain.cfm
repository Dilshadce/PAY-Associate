<html>
<head>
	<title>Change Branch</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(brcode)
{
	document.getElementById("abrcode").innerHTML = document.getElementById("brcode_"+brcode).value;
	document.getElementById("obrcode").value = document.getElementById("brcode_"+brcode).value;/*To get the old brcode for update purpose*/
}
function check1(){

	if(document.getElementById("obrcode").value==""&&document.getElementById("nbrcode").value=="")
	{
	alert("Please select a Branch from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("obrcode").value==""){
	alert("Please select an Branch from the table above.");
	return false;
	}
	else if(document.getElementById("nbrcode").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="br_qry" datasource="#dts#">
SELECT brcode, brdesp
FROM branch
ORDER BY brcode
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=brcode" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Branch</div>
<font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<div style="width:450px;height:500px;overflow:auto;">
<table class="form">

<tr>
	<th width="120px">Branch</th>
	<th width="300px">Description</th>
</tr>

<cfloop query="br_qry">
<tr onClick="showFoot('#br_qry.currentrow#');" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
	<td>#br_qry.brcode#</td>
	<td>#br_qry.brdesp#</td>
</tr>

	<input type="hidden" name="brcode_#br_qry.currentrow#" id="brcode_#br_qry.currentrow#" value="#br_qry.brcode#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Branch</th>
	<td width="100px"><label id="abrcode"></label>
	<input type="hidden" name="obrcode" id="obrcode" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="nbrcode" value="" size="12"></td>
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