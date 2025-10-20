<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Add Race</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>
<body>

<div class="mainTitle">Add Race</div>
<cfinclude template="raceTableHeader.cfm">
	
<form name="rForm" action="/housekeeping/maintenance/raceTableForm_process.cfm?type=add" method="post">
	<table width="100%" class="insert" border="0">
		<tr>
			<td>Race: <input type="text" name="racecode" size="2" maxlength="1"></td>
		</tr>
		<tr>
			<td>Description: <input type="text" name="racedesp" size="40" maxlength="15"></td>
		</tr>
	</table>
	<br/>
	<div align="center"><input type="submit" name="add" value="Add Race"></div>
</form>	
</body>
</html>