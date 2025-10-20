<html>
<head>
	<title>Clear All File</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfoutput>
<form name="iForm" action="/housekeeping/fileReOrganisation/clearTransactionMasterProcess.cfm" method="post" onSubmit="return confirm('Are you sure? Once Clear, all data will be gone forever')">
<div class="mainTitle">Clear All File</div>
<font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<table class="form">
<tr>
	<td><strong>Note :</strong></td>
</tr>
<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; In network enviroment,
		<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; please make sure you are the only user to access this option.
	</td>
</tr>
<tr>
	<td><hr></td>
</tr>
<tr>
	<td><input type="radio" name="clear" value="clear1" checked>Clear Transactions</td>
</tr>
<tr>
	<td><input type="radio" name="clear" value="clear2">Clear Master Files</td>
</tr>
<tr><td><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /></td></tr>
<tr>
	<td align="right">
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onClick="window.location='/body/bodymenu.cfm?id=52'">
	</td>
</tr>
</table>
</form>
</cfoutput>
</body>

</html>