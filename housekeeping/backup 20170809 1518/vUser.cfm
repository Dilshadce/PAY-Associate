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
</html>