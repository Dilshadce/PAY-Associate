<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Add Religion</title>
</head>

<body>
<cfoutput>
<div class="mainTitle">Add Religion</div>
<cfinclude template="religionTableHeader.cfm">

<form name="eForm" action="/housekeeping/maintenance/religionTableForm_process.cfm?type=add" method="post">
<table width="100%" class="insert" border="0">
	<tr>
		<td>Religion: <input type="text" name="relcode" size="2" maxlength="2"></td>
	</tr>
	<tr>
		<td>Description: <input type="text" name="reldesp" size="50" maxlength="15"></td>
	</tr>
</table>
<br/>
<div align="center"><input type="submit" name="add" value="Add Religion"></div>
</form>

</cfoutput>
</body>
</html>