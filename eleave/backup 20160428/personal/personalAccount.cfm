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
<title>Maintain Password</title>
</head>
<body>
<cfoutput>

<div class="mainTitle" style="text-transform:uppercase">Maintain Password</div>
<font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<cfform action="/ELeave/personal/personalAccountProcess.cfm" method="post" onsubmit="javascript: return validatepass();">
<table class="form">
<tr>
<td>User Name:</td>
<td>#HUserName#</td>
</tr>
</table>
<br />
<br />
Please enter old password and also enter the new password twice
<table>
<tr>
<td width="150px">Enter Old Password</td>
<td width="300px"><input name="opass" id="opass" type="password" /></td>
</tr>
<tr>
<td width="150px">Enter New Password</td>
<td width="300px"><cfinput name="npass" id="npass" type="password" validate="regex" pattern="^(?=.*[a-zA-Z])(?=.*[0-9])" message="Must be alphanumeric!" /></td>
</tr>
<tr>
<td width="150px">Enter New Password Again</td>
<td width="300px"><cfinput name="npassagain" id="npassagain" type="password" validate="regex" pattern="^(?=.*[a-zA-Z])(?=.*[0-9])" message="Must be alphanumeric!" /></td>
</tr>
</table>
<br />
<br />
&nbsp;&nbsp;&nbsp;<input type="submit" name="changepass" id="changepass" value="ok" size="6"> 
</cfform>
</cfoutput>
</body>
</html>