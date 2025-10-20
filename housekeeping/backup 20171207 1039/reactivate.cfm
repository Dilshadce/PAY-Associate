<html>
<head>
<title>Reactive User ID</title>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="reactivate" default="">

<body>
<h1 align="center">Reactivate User</h1>
<h2>Reactivate for User - <cfoutput>#userid#</cfoutput>

<form action="" method="post">
	<input type="submit" name="reactivate" value="Reactivate"></h2>
</form>

<cfif reactivate eq "Reactivate">
	<cfquery name="activate" datasource="payroll_main">
		update users set 
		lastlogin = '0000-00-00 00:00:00' 
		where userid='#userid#';
	</cfquery>
	
	<cfset status = "You have reactivate this user successfully.">
	<h2>You have reactivate this user successfully.</h2>
</cfif>

<p>To view all user, click <a href="vuser1.cfm?all=all">Here</a></p>
</body>
</html>