<html>
<head>
	<title>EA Listing</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>

<div class="mainTitle">EA Report</div>
<div class="tabber">
<form name="gForm" id="gForm" action="EAListing_rep.cfm" method="post" target="_blank">
<cfquery name="getname" datasource="#dsname#">
SELECT * FROM emp_users a LEFT JOIN pmast b on a.empno = b.empno WHERE username = '#HUserID#'
</cfquery>
<br>
<cfoutput>
<table class="form">
<tr>
    <th width="100px">Employee No</th>
    <td><input type="text" id="empno" name="empno" value="#getname.empno#" size="50"></td>
</tr>
<tr>
    <th>Name</th>
    <td><input type="text" id="name" name="name" value="#getname.name#" size="50"></td>
</tr>
  
</table>
</cfoutput>

<br />
	<input type="submit" name="submit" value="Print">
</form>
</div>

</body>
</html>

