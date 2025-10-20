<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Personal Particular</title>
<link rel="shortcut icon" href="/PMS.ico" />
<script src="../../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<link href="../../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
</head>

<body>
<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="emp_data1" datasource="#DSNAME#" >
SELECT * FROM emp_users WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="checkeditadd" datasource="payroll_main">
	SELECT editadd FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>Personal Particular</h3>
        <form action="/eleave/personal/personalDetailsProcess.cfm" method="post">
        <table class="form" border="1" width="500px">
        <tr>
        <th>Empno</th>
        <td>:</td>
        <td> #emp_data.empno#
          <input type="hidden" name="empno" value="#emp_data.empno#" /></td>
        </tr>
        <tr>
        <th>Name</th>
        <td>:</td>
        <td>#emp_data.name#</td>
        </tr>
        <tr>
        <th>IC Number</th>
        <td>:</td>
        <td>#emp_data.nricn#</td>
        </tr>
        <tr>
        <th>Address</th>
        <td>:</td>
        <td><input type="text" value="#emp_data.add1#" name="add1" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif> /></td>
        </tr>
        <tr>
        <td></td>
        <td></td>
        <td><input type="text" value="#emp_data.add2#" name="add2" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
        </tr>
        <tr>
          <th>Phone No.</th>
          <td>:</td>
          <td><input type="text" value="#emp_data.phone#" name="phone" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
        </tr>
        <tr>
          <th>Education</th>
          <td>:</td>
          <td><input type="text" value="#emp_data.edu#" name="edu" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
        </tr>
        <tr>
          <th>Email</th>
          <td>:</td>
          <td><span id="sprytextfield1">
          <input type="text" value="#emp_data1.email#" name="email" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/>
          <span class="textfieldRequiredMsg">Email is required.</span><span class="textfieldInvalidFormatMsg">Invalid format.</span></span></td>
        </tr>
        <tr>
        <td></td>
        <td></td>
        <td><cfif checkeditadd.editadd eq "Y"><cfelse><input type="submit" value="Submit" /></cfif></td>
        </tr>
        </table>
        </form>
        </div>
</div>
</cfoutput>
<script type="text/javascript">
<!--
var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1", "email", {validateOn:["blur"]});
//-->
</script>
</body>
</html>
