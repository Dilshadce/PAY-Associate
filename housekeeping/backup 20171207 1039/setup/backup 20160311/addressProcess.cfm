<cfif IsDefined('url.org_type')>
	<cfset URLaddress = trim(urldecode(url.org_type))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<!--- <cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT empno 
            FROM pmast
			WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.employee)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.employee)# already exist!');
				window.open('/housekeeping/employee.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createEmployee" datasource="#dts#">
					INSERT INTO pmast (empno,name)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.employee)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.employee)#!\nError Message: #cfcatch.message#');
						window.open('/housekeeping/employee.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.employee)# has been created successfully!');
				window.open('/housekeeping/employeeProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateEmployee" datasource="#dts#">
				UPDATE pmast
				SET
					empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.employee#">,
					name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.employee)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.employee)#!\nError Message: #cfcatch.message#');
				window.open('/housekeeping/employee.cfm?action=update&empno=#form.employee#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.employee)# successfully!');
			window.open('/housekeeping/employeeProfile.cfm','_self');
		</script> --->	
        
        
        <!---  <cfelseif url.action EQ "reset">
   		
		<cftry>
        	<cfquery name="select_emp_data" datasource="#dts#">
				SELECT * from pmast where empno = "#URLempno#"
			</cfquery>
			<cfset newicnumber = hash(select_emp_data.nricn) >
			<cfquery name="reset_emp_account" datasource="#dts#">
				UPDATE emp_users SET UserName = "#URLempno#" , UserPass = "#newicnumber#", FIRSTTIME = "Y" WHERE empno = "#URLempno#"
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to reset #URLempno#!\nError Message: #cfcatch.message#');
				window.open('/housekeeping/employeeProfile.cfm','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #URLempno# successfully!');
			window.open('/housekeeping/employeeProfile.cfm','_self');
		</script>   
        
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteEmployee" datasource="#dts#">
				DELETE FROM pmast
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLempno#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLempno#!\nError Message: #cfcatch.message#');
					window.open('/housekeeping/employeeProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLempno# successfully!');
			window.open('/housekeeping/employeeProfile.cfm','_self');
		</script> --->
        

	 <cfif url.action EQ "print">
    
		<!--- <cfquery name="getGsetup" datasource="#dts#">
			SELECT comp_name 
            FROM gsetup;
		</cfquery> --->
        
		<cfquery name="printemployee" datasource="#dts#">
			SELECT org_type,category,com_fileno,com_accno
			FROM address
			ORDER BY org_type;
		</cfquery>


		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>12 Months Figures Update</title>
        <link rel="shortcut icon" href="/PMS.ico" />
		<link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
		<!--[if lt IE 9]>
			<script type="text/javascript" src="/js/html5shiv/html5shiv.js"></script>
			<script type="text/javascript" src="/js/respond/respond.min.js"></script>
		<![endif]-->
		<script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>
		
		<div class="container">
		<div class="page-header">
			<h1 class="text">Addresses & Account No. Listing</h1>
			<p class="lead">Company: #HcomCode#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>TYPE</th>
					<th>CATEGORY</th>
                    <th>FILE NO</th>
                    <th>ACCOUNT NO</th>


				</tr>
			</thead>
			<tbody>
				<cfloop query="printemployee">
				<tr>
					<td>#org_type#</td>
					<td>#category#</td>
                    <td>#com_fileno#</td>
                    <td>#com_accno#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>Printed at #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/housekeeping/setup/AddressMain.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/housekeeping/setup/AddressMain.cfm','_self');
	</script>
</cfif>
</cfoutput>