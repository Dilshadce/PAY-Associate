<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">				
<title>Reorganise Pay Data</title>
</head>
<cfoutput>
<div class="mainTitle" style="text-transform:uppercase">Reorganise Payroll Data</div>
<div class="tabber">
<font color="red" size="2.5">
<cfif isdefined("form.status")>
<cfoutput>#form.status#
</cfoutput>
</cfif>
</font>
<form action="process.cfm" method="post" onsubmit="return confirm('Are you sure want to reorganise?')">
<h1>Reorganise Payroll Data</h1>	
EMPNO : <input type="text" name="empno" id="empno" value="" /><br />
<br />

		&nbsp;&nbsp;&nbsp;<input type="submit" name="save" value="ok" >
</form>
</div>
</cfoutput>
</body>
</html>
