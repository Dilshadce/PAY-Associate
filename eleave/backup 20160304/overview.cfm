<cfsetting showdebugoutput="no">
<cfquery name="getInfo" datasource="payroll_main">
	SELECT info_remark,info_date,info_desp
	FROM info
    where info_system ='ELeave'
	ORDER BY info_date desc
	LIMIT 5;
</cfquery>

<cfquery name="query_log" datasource="#DSNAME#">
SELECT * FROM EMP_USERS_LOG WHERE USER_ID = "#HUserID#" ORDER BY LOGDT DESC limit 0 , 20
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Overview</title>
<link rel="shortcut icon" href="/PMS.ico" />
<link rel="stylesheet" href="/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/css/dataTables/dataTables_fullPagination.css" />
<link rel="stylesheet" href="/css/body/overview.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
<cfoutput>
<script type="text/javascript">
	var DSNAME='#DSNAME#';
 </script> 
</cfoutput>
<script type="text/javascript" src="/eleave/js/overview.js"></script>
</head>
<body>
<cfoutput>
<div class="containerDiv">
	<div class="titleDiv">Welcome #HUserName#</div>
	
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
<!--- 	<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div> --->
    
</cfoutput>
<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;" >
<cfoutput query="query_log">
<tr>
	<td width="19%" align="center">#query_log.User_ID#</td>
	<td width="33%" align="center">#query_log.LogDT#</td>
	<td width="27%" align="center">#query_log.Log_IP#</td>
</tr>
</cfoutput>
		</table>
        </div>

</body>
</html>