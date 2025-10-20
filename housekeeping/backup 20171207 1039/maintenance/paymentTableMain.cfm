<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Payment Table</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

</head>
<body>
	<form name="eForm" action="paymentTableMain_process.cfm" method="post">
	<div class="mainTitle">Payment Table</div>
	<div class="tabber">
	<cfif HuserCcode eq "MY">
		<cfset cpf_ccode = "EPF">
		<cfset sdl_code = "SOC">
	<cfelse>
		<cfset cpf_ccode = "CPF">
		<cfset sdl_code = "SDL">
	</cfif>
	<cfoutput>
	<table border="0" class="form">
		<tr>
			<th width="100px"  colspan="2">&nbsp</th>
			<th width="80px">Contribute to #cpf_ccode#</th>
			<th width="80px">Deduct #cpf_ccode# Directly In This Pay</th>
			<th width="120px" colspan="3">Calculate Using Basic Rate Instead Of Basic Pay</th>
		</tr>
		<tr>
			<th colspan="2">12 BCD Table</th>
			<th>&nbsp</th>
			<th>&nbsp</th>
			<th width="40px">#cpf_ccode#</th>
			<th width="40px">&nbsp</th>
			<th width="40px">OT</th>
		</tr>
		</cfoutput>
		<cfquery name="aw_qry" datasource="#dts#">
		SELECT aw_cou,abcd_desp,abcddepf FROM awtable where aw_cou='1'
		</cfquery>
		<cfoutput query="aw_qry">
		<tr>
			<td width="10px">#aw_qry.aw_cou#</td>
			<td width="90px"><input type="text" name="abcd_desp__r#aw_qry.aw_cou#" value="#aw_qry.abcd_desp#"  readonly="yes"></td>
			<td><input type="text" name="" value="-" size="15" readonly="yes"></td>
			<td align="right"><input type="checkbox" name="abcddepf__r#aw_qry.aw_cou#" value="" #IIF(aw_qry.abcddepf eq "N",DE(""),DE("checked"))# /></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
		</tr>
		</cfoutput>
		
		<cfquery name="aw2_qry" datasource="#dts#">
		SELECT aw_cou,abcd_desp,abcdrepf,abcdrot FROM awtable where aw_cou='2'
		</cfquery>	
		<cfoutput query="aw2_qry">
		<tr>
			<td width="10px">#aw2_qry.aw_cou#</td>
			<td width="90px"><input type="text" name="abcd_desp__r#aw2_qry.aw_cou#" value="#aw2_qry.abcd_desp#" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="15" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="15" readonly="yes"></td>
			<td align="right"><input type="checkbox" name="abcdrepf__r#aw2_qry.aw_cou#" value="Y" #IIF(aw2_qry.abcdrepf eq "N",DE(""),DE("checked"))# /></td>
			<td><input type="text" name="" value="" size="6" readonly="yes"></td>
			<td align="right"><input type="checkbox" name="abcdrot__r#aw2_qry.aw_cou#" value="Y" #IIF(aw2_qry.abcdrot eq "N",DE(""),DE("checked"))# /></td>
		</tr>
		</cfoutput>
		
		<cfquery name="aw34_qry" datasource="#dts#">
		SELECT aw_cou,abcd_desp,abcd_epf,abcddepf FROM awtable where (aw_cou='3' or aw_cou='4')
		</cfquery>
		<cfoutput query="aw34_qry">
		<tr>
			<td width="10px">#aw34_qry.aw_cou#</td>
			<td width="90px"><input type="text" name="abcd_desp__r#aw34_qry.aw_cou#" value="#aw34_qry.abcd_desp#" readonly="yes"></td>
			<td align="right"><input type="checkbox" name="abcd_epf__r#aw34_qry.aw_cou#" value="" value="1" #IIF(aw34_qry.abcd_epf eq 0,DE(""),DE("checked"))# /></td>
			<td align="right"><input type="checkbox" name="abcddepf__r#aw34_qry.aw_cou#" value="" value="Y" #IIF(aw34_qry.abcddepf eq "N",DE(""),DE("checked"))# /></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
		</tr>
		</cfoutput>
		
		<cfquery name="aw56_qry" datasource="#dts#">
		SELECT aw_cou,abcd_desp,abcd_epf FROM awtable where (aw_cou='5' or aw_cou='6')
		</cfquery>
		<cfoutput query="aw56_qry">
		<tr>
			<td width="10px">#aw56_qry.aw_cou#</td>
			<td width="90px"><input type="text" name="abcd_desp__r#aw56_qry.aw_cou#" value="#aw56_qry.abcd_desp#" readonly="yes"></td>
			<td align="right"><input type="checkbox" name="abcd_epf__r#aw56_qry.aw_cou#" value="1" #IIF(aw56_qry.abcd_epf eq 0,DE(""),DE("checked"))# /></td>
			<td><input type="text" name="" value="-" size="15" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="" size="6" readonly="yes"></td>
			<td><input type="text" name="" value="-" size="6" readonly="yes"></td>
		</tr>
		</cfoutput>
		
	</table>
	<br/>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	</center>
	</div>	
</body>
</html>