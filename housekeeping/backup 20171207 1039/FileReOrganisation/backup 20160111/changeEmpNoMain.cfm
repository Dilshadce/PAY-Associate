<html>
<head>
	<title>Change Employee No.</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(empno)
{
	document.getElementById("aempno").innerHTML = document.getElementById("empno_"+empno).value;
	document.getElementById("oempno").value = document.getElementById("empno_"+empno).value;/*To get the old ID for update purpose*/
	
}

function check1(){

	if(document.getElementById("oempno").value==""&&document.getElementById("nempno").value=="")
	{
	alert("Please select an Employee from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("oempno").value==""){
	alert("Please select an Employee from the table above.");
	return false;
	}
	else if(document.getElementById("nempno").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="emp_qry" datasource="#dts#">
SELECT empno, name
FROM pmast
ORDER BY empno
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=empno" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Employee No.</div>
<font color="red" size="2,5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<div style="width:450px;height:400px;overflow:auto;">
<table class="form">
<tr>
	<th width="120px">Empno</th>
	<th width="300px">Name</th>
</tr>

<cfloop query="emp_qry">
<tr onClick="showFoot('#emp_qry.currentrow#');" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
	<td>#emp_qry.empno#</td>
	<td>#emp_qry.name#</td>
</tr>

	<input type="hidden" name="empno_#emp_qry.currentrow#" id="empno_#emp_qry.currentrow#" value="#emp_qry.empno#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Employee No.</th>
	<td width="100px"><label id="aempno" name="aempno"></label>
	<input type="hidden" name="oempno" id="oempno" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="nempno" value="" size="12"></td>
</tr>
<tr>
	<td colspan="4" align="right"><br />
		<input type="submit" name="submit" value="OK">
		<input type="button" name="exit" value="Exit" onClick="window.location='/body/bodymenu.cfm?id=52'">
	</td>
</tr>
<tr>
	<td colspan="4"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></td>
</tr>
</table>

</form>
</cfoutput>
</body>

</html>