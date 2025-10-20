<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function validatepass()
{
var npass = document.getElementById("npass").value;
var npassagain = document.getElementById("npassagain").value;

if(npass != npassagain)
{
alert("The both new password is not matches, please retype");
return false;
}
else
{
return true;
}
}

function requireval()
{

var opassw = document.getElementById("opass").value;
var npassw = document.getElementById("npass").value;
var npassa = document.getElementById("npassagain").value;

if (npassw == "" || npassa == "")
{
//alert("New Password Is Required");
document.getElementById("changepass").style.visibility = "hidden";
}

else if (opassw == "")
{
//alert("Old Password Is Required");
document.getElementById("changepass").style.visibility = "hidden";
}

else
{
document.getElementById("changepass").style.visibility = "visible";
}

}
</script>				
<title>CREATE USER</title>
</head>
<body>
<cfoutput>

<div class="mainTitle" style="text-transform:uppercase">CREATE USER
  <br />
  <br />
</div>
<font color="red">
	<cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<form action="/housekeeping/createuserprocess.cfm?id=#url.id#" method="post" onsubmit="javascript:validatepass();">
  <table>
<tr>
<td width="150px">User Name</td>
<td width="300px"><input name="username" id="username" type="text" /></td>
</tr>
<tr>
<td width="150px">Enter Password</td>
<td width="300px"><input name="npass" id="npass" type="password" /></td>
</tr>
<tr>
<td width="150px">Enter Password Again</td>
<td width="300px"><input name="npassagain" id="npassagain" type="password" /></td>
</tr>
<tr>
<td width="150px">Email</td>
<td width="300px"><input name="email" id="email" type="text" /></td>
</tr>
 <tr><td>Choose UserGroup</td>
	 <td><select name="userGrpID">
				<cfif HUserGrpID eq "super">
					<cfoutput>
						<option value="super">SUPER</option>
					</cfoutput>
				</cfif>
				<cfquery name="userpin_qry" datasource="#url.id#">
					SELECT * from userpin
				</cfquery>
				<cfloop query="userpin_qry">
					<option value="#userpin_qry.usergroup#" >#userpin_qry.usergroup#</option>
			 	</cfloop>
			  	</select>
			  </td>
</tr>
<tr><td>Company Id:</td><td>#url.id#</td></tr>
<tr>
        <td>Receive Email</td>
        <td>
        <input type="checkbox" name="getmail" id="getmail" value="Y" checked>
        </td>
        </tr>
</table>
<br />
<br />
&nbsp;&nbsp;&nbsp;<input type="submit" name="changepass" id="changepass" value="ok" size="6"> 
</form>
</cfoutput>
</body>
</html>