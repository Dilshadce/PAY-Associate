<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Personal Particular</title>
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
<cfquery name="gs_qry2" datasource="payroll_main">
	SELECT eportapp FROM gsetup2 WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<cfset diff = 0>

<cfif gs_qry2.eportapp eq "Y">
<cfif emp_data.changes eq "Y" and (emp_data.add1 neq emp_data1.add1 or emp_data.add2 neq emp_data1.add2 
	or emp_data.phone neq emp_data1.phone or emp_data.edu neq emp_data1.edu)>
	<cfset diff = 1>
</cfif>
</cfif>

<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>Personal Particular</h3>
        <form action="/eleave/personal/personalDetailsProcess.cfm" method="post">
        <table class="form" border="0" width="70%">
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
        <td><cfif diff eq 1>Details Pending Admin Approval To Update</cfif></td>
        </tr>
        <tr>
        <th>Address</th>
        <td>:</td>
        <td><input type="text" value="#emp_data.add1#"  id="add1" name="add1" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif> /></td>
		<td><input type="text" value="#emp_data1.add1#"  id="eadd1" name="eadd1" size="50" <cfif diff neq 1>hidden </cfif> readonly="readonly" /></td>
        </td>
        </tr>
        <tr>
        <td></td>
        <td></td>
        <td><input type="text" value="#emp_data.add2#"  id="add2" name="add2" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
        <td><input type="text" value="#emp_data1.add2#"  id="eadd2" name="eadd2" size="50" <cfif diff neq 1>hidden </cfif> readonly="readonly"  /></td>
        </td>
        </tr>
        <tr>
          <th>Phone No.</th>
          <td>:</td>
          <td><input type="text" value="#emp_data.phone#" id="phone" name="phone" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
    	  <td><input type="text" value="#emp_data1.phone#" id="ephone" name="ephone" size="50" <cfif diff neq 1>hidden </cfif> readonly="readonly" /></td>
          </td>
        </tr>
        <tr>
          <th>Education</th>
          <td>:</td>
          <td><input type="text" value="#emp_data.edu#" name="edu" size="50" <cfif checkeditadd.editadd eq "Y"> readonly="readonly" </cfif>/></td>
	      <td><input type="text" value="#emp_data1.edu#" name="eedu" size="50" <cfif diff neq 1>hidden </cfif> readonly="readonly"  /></td>
          </td>
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
