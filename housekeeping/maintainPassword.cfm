<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type="text/javascript" src="/scripts/prototypenew.js" ></script>   

<cfquery name="getPasswordControls" datasource="payroll_main">
	SELECT *
    FROM passwordControls;
</cfquery>
<cfset passwordRepeatHistory = val(getPasswordControls.repeatPassword)>

<cfquery name="getLastChange" datasource="payroll_main">
	SELECT *
    FROM passwordHistory
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY updatedOn DESC
    LIMIT 1;
</cfquery>

<cfquery name="getPasswordList" datasource="payroll_main">
	SELECT *
    FROM passwordHistory
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY updatedOn DESC
    LIMIT #passwordRepeatHistory#;
</cfquery>

<cfset passwordList = valuelist(getPasswordList.oldpassword)>

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
<cfoutput>
function validatePasswordHistory(){
			
    var urlissbatch = 'gethashajax.cfm?password='+escape(encodeURI(document.getElementById("npass").value));

    new Ajax.Request(urlissbatch,{
        method:'get',
        onSuccess: function(getdetailback){
        document.getElementById('passwordAjaxfield').innerHTML = getdetailback.responseText;
        },
        onFailure: function(){ 
        alert('error'); },		
        onComplete: function(transport){
            
            var oldList = "#passwordList#"			
            var userInput = document.getElementById("hashedpassword").value;

            if (oldList.indexOf(userInput)!= -1){
                alert("Please do not use any of the previous 5 passwords!");
                document.getElementById('npass').value = "";
                document.getElementById('npass').focus();
            }
        }
    })
}
</cfoutput>
</script>				
<title>Change Password</title>
</head>
<body>
<cfoutput>

    <div class="mainTitle" style="text-transform:uppercase">Change Password</div>
    <font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
    
    <cfif IsDefined('url.fromMainPage')>
        <form action="/housekeeping/maintainPasswordProcess.cfm?fromMainPage=1" method="post" onsubmit="javascript:return validatepass();">
    <cfelse>
        <form action="/housekeeping/maintainPasswordProcess.cfm" method="post" onsubmit="javascript:return validatepass();">
    </cfif>
    
    <table class="form">
        <tr>
            <td width="100px">User ID:</td>
            <td>#HUserID#</td>
        </tr>
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
            <td width="300px"><input name="opass" id="opass" type="password"/></td>
        </tr>
        <tr>
            <div id="passwordAjaxfield"></div>
            <td width="150px">Enter New Password</td>
            <td width="300px">
                <input name="npass" id="npass" type="password" required
                title="Password must contain (UpperCase, LowerCase, Number/SpecialChar and min 8 Chars)"
                pattern="(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"  
                onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');"
                onBlur="validatePasswordHistory();"  />
            </td>
        </tr>
        <tr>
            <td width="150px">Enter New Password Again</td>
            <td width="300px">
                <input name="npassagain" id="npassagain" type="password" required title="Password must contain (UpperCase, LowerCase, Number/SpecialChar and min 8 Chars)"  
                pattern="(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"  
                onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');" />
            </td>
        </tr>
    </table>
    <br />
    <br />
    &nbsp;&nbsp;&nbsp;<input type="submit" name="changepass" id="changepass" value="Save" size="6" > <!---style="visibility:hidden"---> 
    </form>
</cfoutput>
</body>
</html>