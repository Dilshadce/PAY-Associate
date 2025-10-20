<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<title>First Time Login</title>
<script src="../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function validatepass()
{
var npass = document.getElementById("password").value;
var npassagain = document.getElementById("cpassword").value;
<!---var email = document.getElementById("email").value;--->
var username  = document.getElementById("username").value;

if(npass == "" || npassagain == "" || username == "" ) <!---|| email == "" )--->
{
alert("All field should be filled");
return false;
}


<!---var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
if (!filter.test(email)) {
alert('Please provide a valid email address');
return false;
}--->



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

  

</script>
</head>

<body>
	<div class="tabber">
		<div class="tabbertab">
        <h3>First Time Login</h3>
        PLease Fill In the details below to proceed to the account
        <cfform id="form1" name="form1" method="post" action="updateAccountProcess.cfm" onsubmit="return validatepass()">
        <cfoutput><input type="hidden" value="#form.userid#" name="userid" /></cfoutput>
        <table class="form" width="500px">
        <tr>
        <th width="124px">User Name</th>
        <td width="6px">:</td>
        <td><span id="sprytextfield1">
          <cfoutput>
          <input type="text" name="username" id="username" value="#HUserID#" readonly/>
          <span class="textfieldRequiredMsg">User Name is required.</span></span></td>
          </cfoutput>
        </tr>
        <tr>
        <th>Password</th>
        <td>:</td>
        <td><span id="sprytextfield2">
          <input type="password" name="password" id="password" required
          title="Password must contain (UpperCase, LowerCase, Number/SpecialChar and min 8 Chars)"
pattern="(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"  
onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');" />
          <span class="textfieldRequiredMsg">Password is required.</span></span></td>
        </tr>
        <tr>
        <th>Confirm Password:</th>
        <td>:</td>
        <td>
          <span id="sprytextfield3">
            <input type="password" name="cpassword" id="cpassword" required
            title="Password must contain (UpperCase, LowerCase, Number/SpecialChar and min 8 Chars)"
pattern="(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"  
onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');"  />
            <span class="textfieldRequiredMsg">Confirm Password is required.</span></span>        </td>
        </tr>
        <tr>
        <th hidden="true">Email Address:</th>
        <td hidden="true">:</td>
        <td><span id="sprytextfield4">
        <input type="text" name="email" id="email" hidden />
        <!---<span class="textfieldRequiredMsg">Email is required.</span><span class="textfieldInvalidFormatMsg">Invalid email format.</span></span>---></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><input type="submit" name="submit" value="Submit"/>
          <input type="reset" name="reset" value="Reset"/></td>
        </tr>
        </table>
        </cfform>
        </div>
   </div>
    <script type="text/javascript">
<!--
var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1");
var sprytextfield2 = new Spry.Widget.ValidationTextField("sprytextfield2");
var sprytextfield3 = new Spry.Widget.ValidationTextField("sprytextfield3");
var sprytextfield4 = new Spry.Widget.ValidationTextField("sprytextfield4", "email", {validateOn:["blur"]});
//-->
</script>
</body>
</html>
