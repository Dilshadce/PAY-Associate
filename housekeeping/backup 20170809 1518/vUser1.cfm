<cfif husergrpid neq "super">
<cfif hcomid neq replace(url.comid,'_p','')>
<cfabort>
</cfif>
</cfif>
<html>
<head>
<title>View All Payroll Users</title></title>
<link rel="shortcut icon" href="/PMS.ico" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>User Maintenance</h1>
<hr>

<cfparam name="start" default="1">

<cfif isdefined("url.all")>
	<cfquery name="getUsers" datasource="payroll_main">
		select * 
		from users 
		order by userDsn,usergrpid,userid;
	</cfquery>
<cfelse>
	<cfif husergrpid eq "super">
		<cfquery datasource='payroll_main' name="getUsers">
			select * 
			from users 
			where userDsn='#comid#' 
			order by usergrpid,userid;
		</cfquery>
	<cfelseif husergrpid eq "admin">
		<cfquery datasource='payroll_main' name="getUsers">
			select * 
			from users 
			where userDsn='#comid#' 
            and usergrpid <> 'super' 
            and userid not like 'ultra%'
			order by usergrpid,userid;
		</cfquery>
	<cfelse>
		<cfquery datasource='payroll_main' name="getUsers">
			select * 
			from users 
			where userid='#huserid#' and userDsn='#comid#';
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("url.start")>
	<cfset start = url.start>
</cfif>
			
<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1></cfoutput><hr>
</cfif>

<table align="center" class="data" width="100%">
	<tr>
		<cfif husergrpid eq "admin" or husergrpid eq "super">
			<th>Delete</th>
		</cfif>
		<th>Edit</th>
		<th>Name</th>
		<th>ID</th>
		<th>Company</th>
		<th>Group</th>
		<th>Email</th>
        <th>Receive Email</th>
        <th>Pilot Summary</th>
        <th>Mobile Access</th>
		<cfif husergrpid eq "super">
			<th>Lastlogin</th>
			<th>Reactivate</th>
		</cfif>
	</tr>
	<cfset countuser = 0>
	<cfloop query="getUsers">
		<cfoutput>
		<tr>
			<cfif husergrpid eq "admin" or husergrpid eq "super">
				<td><a href="user.cfm?type=Delete&userId=#getUsers.userId#">Go</a></td>
			</cfif>
			<td><a href="user.cfm?type=Edit&userId=#getUsers.userId#">Go</a></td>
			<td>#getUsers.userName#</td>
			<td>#getUsers.userId#</td>
			<td>#getUsers.userDsn#</td>
			<td>
				<cfif getUsers.usergrpid eq "admin">
					Administrator
				</cfif>
				<cfif getUsers.usergrpid eq "suser">
					Standard
				</cfif>
				<cfif getUsers.usergrpid eq "guser">
					General User
				</cfif>
				<cfif getUsers.usergrpid eq "muser">
					Mobile User
				</cfif>
				<cfif getUsers.usergrpid eq "luser">
					Limited User
				</cfif>
				<cfif getUsers.usergrpid eq "super">
					Super User
                <cfelse>
                	#getUsers.usergrpid#
				</cfif>
			</td>
			<td>#getUsers.userEmail#</td>
            <td>#getUsers.getmail#</td>
            <td>#getUsers.pilotrep#</td>
            <td>#getUsers.mobileaccess#</td>            
			<cfif husergrpid eq "super">
				<td nowrap>#getUsers.lastlogin#</td>
				<td><a href="reactivate.cfm?userid=#userid#">Go</a></td>
			</cfif>
		</tr>
		</cfoutput>
        <cfset countuser = countuser + 1>
	</cfloop>
</table>
<cfquery name="useracclimit" datasource="payroll_main">
select * from useraccountlimit
where companyid = '#comid#';
</cfquery>
<cfoutput>
<cfset balance = #val(useracclimit.usercount)# - #val(countuser)#>
<table>
<tr>
	<td>Total Users :</td>
    <td>#useracclimit.usercount#</td>
    <td>Current Users :</td>
    <td>#countuser#</td>
    <td>Balance :</td>
    <td>#balance#</td>
</tr>
</table>
</cfoutput>
<cfif husergrpid eq "super" or #balance# gt 0>
To create user, click <cfoutput><a href="createuser.cfm?id=#getUsers.userDsn#">Here</a> </cfoutput>
</cfif>
</body>
</html>