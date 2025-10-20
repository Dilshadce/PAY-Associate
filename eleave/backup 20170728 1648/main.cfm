
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Overview</title>
<link rel="stylesheet" href="/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/css/dataTables/dataTables_fullPagination.css" />
<link rel="stylesheet" href="/css/body/overview.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/js/body/overview.js"></script>
</head>
<body>

<cfquery name="query_log" datasource="#DSNAME#">
SELECT * FROM EMP_USERS_LOG WHERE USER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> ORDER BY LOGDT DESC limit 0 , 20
</cfquery>

<cfoutput>
	<h1>Welcome <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserName#"></h1>
</cfoutput>
<hr>
<h3>Important Information Board</h3>
<center>
	<cfquery datasource="payroll_main" name="getinfo">
							select * from info where info_system ='ELeave' order by info_date desc limit 5
						</cfquery>
                    	<table border="0" width="800">
							<cfloop query="getinfo">
								<tr><td align="left"><b><font style="font-style: italic" ><cfoutput><cfqueryparam cfsqltype="cf_sql_varchar" value="#getinfo.info_remark#"></cfoutput></font></b></td></tr>
								<tr><td align="left"><cfoutput>#dateformat(getinfo.info_date,"dd/mm/yyyy")#</cfoutput>: <cfoutput><cfqueryparam cfsqltype="cf_sql_varchar" value="#getinfo.info_desp#"></cfoutput></td></tr>
								<tr><td align="left"><ht/></td></tr>
							</cfloop>
						</table>
</center>
<br>
<h3>User's Log</h3>
user's log is a security festure to track user's login traffic and status.
<hr>
<table align="center" class="data">
<tr>
	<th width="132">User ID</th>
	<th width="177">Log In Time</th>
	<th width="196">IP Address</th>
</tr>

<cfoutput query="query_log">
<tr>
	<td><cfqueryparam cfsqltype="cf_sql_varchar" value="#query_log.User_ID#"></td>
	<td><cfqueryparam cfsqltype="cf_sql_varchar" value="#query_log.LogDT#"></td>
	<td><cfqueryparam cfsqltype="cf_sql_varchar" value="#query_log.Log_IP#"></td>
</tr>
</cfoutput>
</table>
</body>
</html>