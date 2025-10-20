<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>User Define Rate Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="uDRate_qry" datasource="#dts#">
SELECT aw_cou,udrat_desp FROM awtable
</cfquery>

<body>
	<div class="mainTitle">User Define Rate Table</div>
	<div class="tabber">
	<form ame="eForm" action="/housekeeping/maintenance/userDefineRateTableMain_process.cfm" method="post">	
	<table border="0" class="form">
		<tr>
			<th width="80px">No</th>
			<th width="100px">Description</th>
		</tr>
		<cfoutput query="uDRate_qry">
		<tr>
			<th>#uDRate_qry.aw_cou#<input type="hidden" name="aw_cou" value="#uDRate_qry.currentrow#"></th>
			<td><input type="text" name="udrat_desp__r#uDRate_qry.aw_cou#" value="#uDRate_qry.udrat_desp#" maxlength="15"></td>
		</tr>
		</cfoutput>
	</table>
	<br />
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	</center>
	</div>
	
</body>
</html>