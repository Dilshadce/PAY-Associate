<!---<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1858, 11, 1859, 1497, 1631, 703, 536, 10">
<cfinclude template="/words.cfm">
--->
<cfset pageTitle="User Administration">
<cfset targetTitle="User Administration">
<cfset targetTable="User Administration">

<cfquery name="getMultiCompany" datasource='#dts_main#'>
		SELECT * 
        FROM multicomusers 
        WHERE userid='#huserid#'; 
</cfquery>
<cfset gotocolumn = "0">
<cfif getMultiCompany.recordcount neq 0>
	<cfset gotocolumn = "1">    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>  
    <link rel="shortcut icon" href="/PMS.ico" />
    <link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/css/profile/profile.css" />
 
    <script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/dataTables_bootstrap.js"></script>
    <cfoutput>
    <script type="text/javascript">
        var dts='#dts#';
        var dts_main='#dts_main#';
        var targetTitle='#targetTitle#';
		var targetTable='#targetTable#';
		var userGroup='#husergrpid#';
		var userID='#huserid#';
		var SEARCH = 'Search';
		var companyid = 'Company ID';
		var comp_name = 'Company Name';
		var mmonth = 'Current Month';
		var myear = 'Current Year';
		var action = 'Action';
		var gotocolumn="0"
    </script>
    </cfoutput>
    <script type="text/javascript" src="/js/housekeeping/vUser.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>
            #targetTable#
			<span class="glyphicon glyphicon-question-sign btn-link"></span>
			<span class="glyphicon glyphicon-facetime-video btn-link"></span>
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




<!---
















<html>
<head>
<title>View Payroll Database</title></title>
<link rel="shortcut icon" href="/PMS.ico" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>User Maintenance</h1>

<hr>
	<cfparam name="start" default="1">
	<cfparam name="no" default="1">
	
	<cfif husergrpid eq "super">
	
		<cfquery datasource='payroll_main' name="getUsers">
			select * from gsetup
			group by comp_id order by comp_id;
		</cfquery>
	<cfelseif husergrpid eq "admin">
		<cfquery datasource='payroll_main' name="getUsers">
			select * from gsetup
			where comp_id='#hcomid#'
			group by comp_id order by comp_id;
		</cfquery>
	<cfelse>
		<cfquery datasource='payroll_main' name="getUsers">
			select * from gsetup 
			where comp_id='#hcomid#'
		</cfquery>
	</cfif>
	
	<cfif isdefined("url.start")>
		<cfset start = url.start>
	</cfif>
	
	<table align="center" class="data" width="80%">
		<tr>
			<th width="10%">No.</th>				
    		<th width="20%">Company ID</th>
			<th width="40%">Company Name</th>
			<!--- <th width="10%">Last Payroll Year Closing Date</th> --->
			<th width="20%">Current Year</th>
			<th width="10%">Current Period</th>					
		</tr>
		<cfoutput query="getUsers" startrow="#start#">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="center">#no#.</div></td>																
				<td>
					<a href="vuser1.cfm?comid=#getUsers.comp_id#_p">#ucase(getUsers.comp_id)#</a>
				</td>
				<td>#getUsers.comp_name#</td>
				<td align="center">#getUsers.myear#</td>
				<!--- <td align="center">
					<cfif getcominfo.LastAccYear neq "">
						<cfset futuredate = dateAdd("m",val(getcominfo.Period),getcominfo.LastAccYear)>
						#dateformat(futuredate,"dd-mm-yyyy")#
					</cfif>
				</td> --->
				<td align="center">
				<!--- 	<cfset lastaccyear = lsdateformat(getcominfo.LastAccYear, 'mm/dd/yyyy')>
					<cfset period = getcominfo.period>
					<cfset currentdate = lsdateformat(now(),'mm/dd/yyyy')>
		
					<cfset tmpYear = year(currentdate)>
					<cfset clsyear = year(lastaccyear)>

					<cfset tmpmonth = month(currentdate)>
					<cfset clsmonth = month(lastaccyear)>

					<cfset intperiod = (tmpyear-clsyear)*12+tmpmonth-clsmonth>

					<cfif intperiod gt 18 or intperiod lte 0>
						<cfset readperiod=99>
					<cfelse>
						<cfset readperiod = numberformat(intperiod,"00")>
					</cfif>
					#readperiod# --->
					#getUsers.mmonth#
				</td>											
			</tr>
			<cfset no = no + 1>
		</cfoutput>
	</table>
<br>

</body>
</html>--->