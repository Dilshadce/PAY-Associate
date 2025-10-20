<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Denomination Table</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		function disp_alert()
		{
			alert("Can not be 0!");
		}
	</script>
</head>

<body>

<form name="eform" action="denominationTableMain_process.cfm" method="post">
<cfquery name="denom_qry" datasource="#dts#">
SELECT * FROM denomtab
</cfquery>

<div class="mainTitle">Denomination Table</div><br/>
<table class="form" border="0">
	<cfoutput query="denom_qry">
	<tr>
		<th>Highest</th>
		<th>A</th>
		<td><input type="text" name="avalue" value="#denom_qry.denom_a#" maxlength="7"></td>
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>B</th>
		<td><input type="text" name="bvalue" value="#denom_qry.denom_b#" maxlength="7"></td>
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>C</th>
		<td><input type="text" name="cvalue" value="#denom_qry.denom_c#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>D</th>
		<td><input type="text" name="dvalue" value="#denom_qry.denom_d#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>E</th>
		<td><input type="text" name="evalue" value="#denom_qry.denom_e#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>F</th>
		<td><input type="text" name="fvalue" value="#denom_qry.denom_f#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>G</th>
		<td><input type="text" name="gvalue" value="#denom_qry.denom_g#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>H</th>
		<td><input type="text" name="hvalue" value="#denom_qry.denom_h#" maxlength="7"></td>	
	</tr>
	<tr>
		<td>&nbsp</td>
		<th>I</th>
		<td><input type="text" name="ivalue" value="#denom_qry.denom_i#" maxlength="7"></td>	
	</tr>
	<tr>
		<th>Lowest</th>
		<th>J</th>
		<td><input type="text" name="jvalue" value="#denom_qry.denom_j#" maxlength="7"></td>	
	</tr>
	<br/>
	<tr>
		<th>Factor</th>
		<td>&nbsp</td>
		<td><input type="text" name="factor" value="#denom_qry.denom_fac#" maxlength="7"></td>
	</tr>
	</cfoutput>
</table>
<br/>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	</center>
</form>

</body>
</html>