<html>
<head>
	<title>Change Category</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function showFoot(category)
{
	document.getElementById("acat").innerHTML = document.getElementById("category_"+category).value;
	document.getElementById("ocategory").value = document.getElementById("category_"+category).value;/*To get the old category for update purpose*/
}
function check1(){

	if(document.getElementById("ocategory").value==""&&document.getElementById("ncategory").value=="")
	{
	alert("Please select a Category from the table above and type in 'Change To'.");
	return false;
	}
	else if(document.getElementById("ncategory").value==""){
	alert("Please type in 'Change To'.");
	return false;
	
	}else{
	return true;
	}
}
</script>

</head>

<body>

<cfquery name="cat_qry" datasource="#dts#">
SELECT category, desp
FROM category
ORDER BY category
</cfquery>

<cfoutput>
<form name="cForm" action="/housekeeping/fileReOrganisation/change_process.cfm?type=category" method="post" onSubmit="return check1()">
<div class="mainTitle">Change Category</div>
<div style="width:450px;height:500px;overflow:auto;">
<table class="form">
<tr>
	<td colspan="2"><font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font></td>
</tr>
<tr>
	<th width="120px">Category</th>
	<th width="300px">Description</th>
</tr>

<cfloop query="cat_qry">
<tr onClick="showFoot('#cat_qry.currentrow#');" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
	<td>#cat_qry.category#</td>
	<td>#cat_qry.desp#</td>
</tr>

	<input type="hidden" name="category_#cat_qry.currentrow#" id="category_#cat_qry.currentrow#" value="#cat_qry.category#">

</cfloop>

<!--- <cfloop from="1" to="100" index="i">
<tr><td>#i#</td></tr>
</cfloop> --->
</table>
</div>

<table class="form">
<tr><td colspan="4"><hr></td></tr>
<tr>
	<th width="100px">Category</th>
	<td width="100px"><label id="acat"></label>
	<input type="hidden" name="ocategory" id="ocategory" value=""/></td>
	<th width="100px">Change To</th>
	<td width="100px"><input type="text" name="ncategory" value="" size="12"></td>
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