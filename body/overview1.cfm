<cfsetting showdebugoutput="no">
<cfquery name="getInfo" datasource="payroll_main">
	SELECT info_remark,info_date,info_desp
	FROM info
	ORDER BY info_date desc
	LIMIT 5;
</cfquery>

<cfquery name="query_log" datasource="payroll_main">
SELECT * FROM USERLOG ul, USERS u
WHERE ul.userLogID = u.userID
AND u.entryID = "#HEntryID#" ORDER BY ul.userlogtime DESC limit 0 , 20
</cfquery>


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
<cfoutput>
<script type="text/javascript">
	var dts='#dts#';
</script>
</cfoutput>
<script type="text/javascript" src="/js/body/overview.js"></script>
</head>
<body>
<cfoutput>
<div class="containerDiv">
	<div class="titleDiv">Overview</div>
	
	<div class="infoBoardDiv">
		<div class="infoBoardTitleDiv">Information Board</div>
		<div class="infoBoardContentDiv">
			<cfloop query="getInfo">
			<div class="infoDiv">
				<div class="infoTitleDiv">#info_remark#
					<div class="infoDateDiv">#DateFormat(info_date,"dd/mm/yyyy")#</div>
				</div>
				<div class="infoContentDiv">#info_desp#</div>	
			</div>
			</cfloop>	
		</div>
	</div>
    
	<!--- <div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>  --->
    
</div>
</cfoutput>


<table align="center" class="data">
<h3>User's Log</h3>
user's log is a security festure to track user's login traffic and status. 
<tr>
	<th width="132">User ID</th>
	<th width="177">Log In Time</th>
	<th width="196">IP Address</th>
	<th width="129">Status</th>
</tr>

<cfoutput query="query_log">
<tr>
	<td>#query_log.userlogid#</td>
	<td>#query_log.userlogtime#</td>
	<td>#query_log.uipaddress#</td>
	<td>#query_log.status#</td>
</tr>
</cfoutput>
</table>	
</body>
</html>