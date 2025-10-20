<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Month End Update Table</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	
</head>

<body>

<form name="eform" action="monthEndUpdateTableMain_process.cfm" method="post">
<cfquery name="meu_qry" datasource="#dts#">
SELECT meud_brate,meud_hol,meud_rdph,meud_leave,meud_loan,meud_mbr,MEUD_BRATEFLEX FROM awtable WHERE aw_cou='1'
</cfquery>

<div class="mainTitle">Month End Update Table</div><br/>
<cfoutput query="meu_qry">
<table class="insert" border="0">
	<tr>	
		<td><input type="checkbox" name="check1" value="Y" #IIF(meu_qry.meud_brate eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Basic Rate From Master</td>
	</tr>
    <tr>	
		<td><input type="checkbox" name="check7" value="Y" #IIF(meu_qry.MEUD_BRATEFLEX eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Basic Rate From Master Based on Employee No of Payment</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="check2" value="Y" #IIF(meu_qry.meud_hol eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Holidays</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="check3" value="Y" #IIF(meu_qry.meud_rdph eq "N",DE(""),DE("checked"))# /></td>
		<td>Update RD/PH Work Into Payroll</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="check4" value="Y" #IIF(meu_qry.meud_leave eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Leaves Into Payroll</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="check5" value="Y" #IIF(meu_qry.meud_loan eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Loan Deduction Into Payroll</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="check6" value="Y" #IIF(meu_qry.meud_mbr eq "N",DE(""),DE("checked"))# /></td>
		<td>Update Basic Rate From Mid Month Increment To Master</td>
	</tr>
</table>
</cfoutput>
<br/>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/body/bodymenu.cfm?id=218'">
	</center>
</form>

</body>
</html>