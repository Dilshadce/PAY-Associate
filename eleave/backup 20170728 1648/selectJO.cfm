		<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >

		<cfset dts = replace(dsname,'_p','_i')>
        <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
        </cfquery>
        
        <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
       
        
        <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
        </cfquery>
        
         <cfquery name="checkplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#") or (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" and year(startdate) = "#dateformat(currentdate,'yyyy')#")
        </cfquery>
        
        <cfoutput>
        <cfset timesheetexisted = 0>
        <cfset rowcount = 1>

        <h3><cfif url.type eq "incident">Incident Log <cfelseif url.type eq "claim">Claim <cfelseif url.type eq "Leave">Leave <cfelseif url.type eq "Leavestatus">Leave Status <cfelseif url.type eq "claimstatus">Claim Status </cfif>Placement List</h3>
        <table width="50%">
        <tr>
        <th width="5%">No.</th>
        <th width="15%">Placement No.</th>
        <th width="15%">Company</th>
        <th width="10%">Contract Start Date</th>
        <th width="10%">Contract End Date</th>
        <th width="5%"></th>
        </tr>
        <cfloop query="checkplacementlist">
        <tr>
        <td>#checkplacementlist.currentrow#</td>
        <td>#checkplacementlist.placementno#</td>
        <td>#checkplacementlist.custname#</td>
        <td>#dateformat(checkplacementlist.startdate,'dd/mm/yyyy')#</td>
        <td>#dateformat(checkplacementlist.completedate,'dd/mm/yyyy')#</td>
        <cfset path = ''>
        <cfif isdefined("url.type")>
            <cfif url.type eq "leave">
                <cfset path = "/eleave/leave/leaveapplication.cfm">
            <cfelseif url.type eq "leavestatus">
                <cfset path = "/eleave/beps/leavestatus.cfm">
            <cfelseif url.type eq "claim">
                <cfset path = "/eleave/claim/createlist.cfm?type=mcreate">
            <cfelseif url.type eq "claimstatus">
                <cfset path = "/eleave/beps/claimstatus.cfm">
            <cfelseif url.type eq "incident">
                <cfset path = "/eleave/incident/incidentmain.cfm">
            </cfif>
        </cfif>
        <td><form action="#path#" method="post"><input type="hidden" name="pno" id="pno" value="#checkplacementlist.placementno#">
        <input type="submit" name="sub_btn" value="Select"></form></td>
        </tr>
        </cfloop>
        </table>
        
        
		</cfoutput>