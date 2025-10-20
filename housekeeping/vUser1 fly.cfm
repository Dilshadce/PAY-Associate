<cfif husergrpid NEQ 'super'>
	<cfif IsDefined('url.comid') AND IsDefined('url.hcomid')>
		<cfif UCASE(trim(url.comid)) NEQ UCASE(trim(hcomid))>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfif IsDefined('url.companyID')>
	<cfset companyID = trim(urldecode(url.companyID))>
</cfif>

<cfif IsDefined('url.comid')>
	<cfset companyID = trim(urldecode(url.comid))>
</cfif>

<cfif IsDefined('url.userID')>
	<cfset huserid = trim(urldecode(url.userID))>
</cfif>

 <cfquery name="getMasterUser" datasource="net_c">
    SELECT * FROM ultrauser
</cfquery>

<cfquery name="getMultiCompanyUser" datasource="#dts_main#">
	SELECT userID
    FROM multicomusers
    WHERE FIND_IN_SET('#dts#',comlist);
</cfquery>

<cfset masterUserList = getmasteruser.username>
<cfset multiCompanyUser = ValueList(getMultiCompanyUser.userID,",")>

<cfquery name="getTotalUserCount" datasource="#dts_main#">
	SELECT COUNT(userid) AS totalUserCount 
    FROM users 
    WHERE (	userDsn = '#trim(dts)#' OR 
    		userID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#multiCompanyUser#">)
          )
    AND userID NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#masterUserList#">)
    AND userid not like "ultra%"; 
</cfquery>

<cfquery name="getUserLimit" datasource="#dts_main#">
	SELECT usercount AS userLimit
    FROM useraccountlimit 
    WHERE companyid = "#dts#";
</cfquery>

<cfset pageTitle="User Administration - #UCASE(replace(companyID,'_i',''))#">
<cfset targetTitle="User">
<cfset targetTable="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/css/profile/profile.css" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/js/respond/respond.min.js"></script>
    <![endif]-->
 
    <script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/dataTables_bootstrap.js"></script>

    <cfoutput>
    <script type="text/javascript">
        var dts='#companyID#';
        var targetTitle='#targetTitle#';
		var targetTable='#companyID#';
		var userGroup='#husergrpid#';
		var userID='#huserid#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/js/housekeeping/vUser1.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>
			#pageTitle#
			<span class="glyphicon glyphicon-question-sign btn-link"></span>
			<span class="glyphicon glyphicon-facetime-video btn-link"></span>
            
            <div class="pull-right">
            	<cfset condition1 = val(getTotalUserCount.totalUserCount) LT val(getUserLimit.userLimit)>
                <cfset condition2 = HusergrpID EQ "admin">
                <cfset condition3 = ListFind(masterUserList,HuserID,",")>
                
				<cfif (condition1 AND condition2) OR (condition3 NEQ 0)>
                    <button type="button" class="btn btn-default" onclick="window.open('/housekeeping/createuser.cfm?action=create&companyID=#companyID#','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add #targetTitle# 
                    </button>
                </cfif>
			</div>
		</h2>
	</div>
	<div class="container">
		<table class="table table-bordered table-hover" id="resultTable" style="table-layout:fixed">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
</cfoutput>
</body>
</html>