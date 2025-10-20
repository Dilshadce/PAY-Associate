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

<!--- Check wp validity --->
<cfquery name="checkwp" datasource="payroll_main">
	SELECT wpexpdays,wpemail FROM gsetup where comp_id = "#HComID#"
</cfquery>

<cfif checkwp.wpemail eq "Y">

<cfset dateget = dateadd('d',checkwp.wpexpdays,now())>

<cfquery name="getwp" datasource="#dts#">
    SELECT wp_to,empno,name FROM pmast WHERE wp_to <> "" and wp_to <> "0000-00-00" 
    and wp_to <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(dateget,'yyyy-mm-dd')#"> and paystatus = "A"		 	order by wp_to
</cfquery>
<cfset wplist = "">

<cfif getwp.recordcount gt 0>
<cfloop query="getwp">
		<cfif wplist eq "">
			<cfset wplist = wplist & getwp.empno &" (" & dateformat(getwp.wp_to,"dd/mm/yyyy") & ")">
        <cfelse>
			<cfset wplist = wplist & ", "& getwp.empno &" (" & dateformat(getwp.wp_to,"dd/mm/yyyy") & ")">
        </cfif>
</cfloop>
		<cfoutput>
        <script type="text/javascript">
			alert("Work permit(s) expiring in #checkwp.wpexpdays# days for employee no:\n\n#wplist#");
        </script>
        </cfoutput>
</cfif>
</cfif>
<!--- end of Check wp validity --->

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
</cfoutput>

<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;" >
<cfoutput query="query_log">
<tr>
	<td width="19%" align="center">#query_log.userlogid#</td>
	<td width="33%" align="center">#query_log.userlogtime#</td>
	<td width="27%" align="center">#query_log.uipaddress#</td>
	<td width="21%" align="center">#query_log.status#</td>
</tr>
</cfoutput>
		</table>
        </div>

</div>
</body>
</html>