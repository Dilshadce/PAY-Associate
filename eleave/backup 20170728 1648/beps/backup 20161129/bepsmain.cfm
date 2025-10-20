<cfset SetLocale("English (UK)")>

<html>
<head>
	<title>Payroll E-Leave System</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="/stylesheet/app.css"/>
</head>

<body>

<cfquery name="query_log" datasource="#DSNAME#">
SELECT * FROM EMP_USERS_LOG WHERE USER_ID = "#HUserID#" ORDER BY LOGDT DESC limit 0 , 20
</cfquery>

<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
</cfquery>

<cfoutput>

<h1>Dear #emp_data.name#,</h1>

<h5>Welcome onboard Business Edge online application. </h5>  

<h2>Your password is personal and confidential.  Please protect and do not share your password.</h2>
<h2>For security purpose, the ID will be de-activated if there are multiple unsuccessful logons.</h2>

<h2>If you have any queries with regards to the ID or function, please call 65-6745-4288 during office hours (9am to 6pm) for assistance.
</h2>
<br>

<h2>
Thank you.
</h2>
</cfoutput>
<br>
<h3>User's Log</h3>
User's log is a security feature to track user's login traffic and status.
<hr>
<table align="center" class="data">
<tr>
	<th width="132">User ID</th>
	<th width="177">Log In Time</th>
	<th width="196">IP Address</th>
</tr>

<cfoutput query="query_log">
<tr>
	<td>#query_log.User_ID#</td>
	<td>#query_log.LogDT#</td>
	<td>#query_log.Log_IP#</td>
</tr>
</cfoutput>
</table>
</body>
</html>