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
        
        
        
     <!---     <cfquery name="checkplacementlist" datasource="#dts#">
        SELECT startdate,timesheet,completedate,placementno FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" and year(startdate) = "#dateformat(currentdate,'yyyy')#"
        </cfquery>
        
        <cfif checkplacementlist.recordcount neq 0>
        <cfset currentdate = checkplacementlist.startdate>
		</cfif> --->
        
        
         <cfquery name="checkplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#") or (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" and year(startdate) = "#dateformat(currentdate,'yyyy')#")
        </cfquery>
        
        <cfif checkplacementlist.recordcount neq 0>
    
        
        <cfif checkplacementlist.timesheet neq "">
        
		<cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
        </cfquery>
        
        <cfset startno  = left(trim(checkplacementlist.timesheet),2)>
		<cfset endno = mid(trim(checkplacementlist.timesheet),4,2)>

        <cfif startno gt endno>
        <cfset startmonth = dateadd('m',-1,currentdate)>
        <cfelse>
        <cfset startmonth = currentdate>
		</cfif>
        
        <cfif endno eq "31">
        <cfset endno = daysinmonth(currentdate)>
		</cfif>
        
        
        <cfset placementno1 = checkplacementlist.placementno > 
        <cfset custname1 = checkplacementlist.custname>
        <cfset startdate1 = createdate(year(startmonth),month(startmonth),val(startno))>
        <cfset enddate1 = createdate(year(currentdate),month(currentdate),val(endno))>
        
        <cfif checkplacementlist.startdate gt startdate1>
        
        <cfquery name="getanotherplacement" datasource="#dts#">
        SELECT startdate,timesheet,placementno,completedate,custname FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(completedate) = "#dateformat(startdate1,'m')#" and year(completedate) = "#dateformat(startdate1,'yyyy')#" and startdate < "#dateformat(startdate1,'yyyy-mm-dd')#" and completedate >= "#dateformat(startdate1,'yyyy-mm-dd')#"
        </cfquery>
        
        
        <cfif getanotherplacement.recordcount  neq 0>
        	
            <cfif getanotherplacement.timesheet neq "">
            
        		<cfquery name="gettimesheetdetail" datasource="#dts#">
                SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getanotherplacement.timesheet#">
                </cfquery>
                
                <cfset startno  = left(trim(getanotherplacement.timesheet),2)>
                <cfset endno = mid(trim(getanotherplacement.timesheet),4,2)>
        

                
                <cfif endno eq "31">
                <cfset endno = daysinmonth(currentdate)>
                </cfif>
                <cfset placementno0 = getanotherplacement.placementno>
                <cfset custname0 = getanotherplacement.custname>
                <cfset enddate0= createdate(year(currentdate),month(currentdate),val(endno))>
                
                <cfset startdate0  = startdate1>
                
                <cfif getanotherplacement.completedate lt enddate0>
				<cfset enddate0= getanotherplacement.completedate>
                </cfif>
                
                
               </cfif>
                
        
		</cfif>

		</cfif>
        
        <cfif checkplacementlist.completedate lt enddate1>
        <cfset enddate1 = checkplacementlist.completedate>
        </cfif>
        
        <cfif checkplacementlist.startdate gt startdate1>
        <cfset startdate1 = checkplacementlist.startdate>
		</cfif>
        
         <cfif checkplacementlist.recordcount neq 1>
         
         <cfloop query="checkplacementlist" startrow="2" endrow="#checkplacementlist.recordcount#">
         
         <cfset currentdate = checkplacementlist.startdate>
        
        <cfif checkplacementlist.timesheet neq "">
        
		<cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
        </cfquery>
        
        <cfset startno  = left(trim(checkplacementlist.timesheet),2)>
		<cfset endno = mid(trim(checkplacementlist.timesheet),4,2)>

        <cfif startno gt endno>
        <cfset startmonth = dateadd('m',-1,currentdate)>
        <cfelse>
        <cfset startmonth = currentdate>
		</cfif>
        
        <cfif endno eq "31">
        <cfset endno = daysinmonth(currentdate)>
		</cfif>
        
        
        
        <cfset "startdate#checkplacementlist.currentrow#" = createdate(year(startmonth),month(startmonth),val(startno))>
        <cfset "enddate#checkplacementlist.currentrow#" = createdate(year(currentdate),month(currentdate),val(endno))>
        <cfset "placementno#checkplacementlist.currentrow#" = checkplacementlist.placementno>
        <cfset "custname#checkplacementlist.currentrow#" = checkplacementlist.custname>
        
        <cfif checkplacementlist.completedate lt evaluate("enddate#checkplacementlist.currentrow#")>
        <cfset "enddate#checkplacementlist.currentrow#" = checkplacementlist.completedate>
        </cfif>
        
        <cfif checkplacementlist.startdate gt evaluate("startdate#checkplacementlist.currentrow#")>
        <cfset "startdate#checkplacementlist.currentrow#" = checkplacementlist.startdate>
		</cfif>
		</cfif>
        
         </cfloop>
         
		 </cfif>
       
        
        
		</cfif>
        
		</cfif>
        
        <cfset currentdate = dateadd('m',1,createdate(val(company_details.myear),val(company_details.mmonth),1))>
        
        
        
        
         <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
        </cfquery>
        
        <cfif getplacementlist.recordcount eq 0>
        
        <cfset currentdatenew = createdate(val(company_details.myear),val(company_details.mmonth),1)>
        <cfquery name="checktimesheet" datasource="#dts#">
        SELECT timesheet FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdatenew,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdatenew,'yyyy-mm-dd')#"
        </cfquery>
        
        <cfif checktimesheet.recordcount neq 0>
        	<cfif checktimesheet.timesheet neq "">
            
            <cfset startno  = left(trim(checktimesheet.timesheet),2)>
            <cfset endno = mid(trim(checktimesheet.timesheet),4,2)>
    
            <cfif startno gt endno>
            <cfset startmonth = dateadd('m',-1,currentdate)>
            <cfelse>
            <cfset startmonth = currentdate>
            </cfif>
            
            <cfset currentdate = createdate(year(startmonth),month(startmonth),val(startno))>
            
            
            <cfquery name="getplacementlist" datasource="#dts#">
            SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
            </cfquery>
            
            <cfset currentdate = dateadd('m',1,currentdate)>
            
			</cfif>
		</cfif>
        
        
        
        
		
		</cfif>
        
        
        <cfif getplacementlist.timesheet neq "">

		
        
        <cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
        </cfquery>
        
         <cfset startno  = left(trim(getplacementlist.timesheet),2)>
<cfset endno = mid(trim(getplacementlist.timesheet),4,2)>
        <cfif startno gt endno>
        <cfset startmonth = dateadd('m',-1,currentdate)>
        <cfelse>
        <cfset startmonth = currentdate>
		</cfif>
        
        <cfif endno eq "31">
        <cfset endno = daysinmonth(currentdate)>
		</cfif>
        
        <cfset startdate10 = createdate(year(startmonth),month(startmonth),val(startno))>
        <cfset enddate10 = createdate(year(currentdate),month(currentdate),val(endno))>
        <cfset placementno10 = getplacementlist.placementno>
        <cfset custname10 = getplacementlist.custname>
        <cfif getplacementlist.completedate lt enddate10>
        <cfset enddate10 = getplacementlist.completedate>
        </cfif>
        
        <cfif getplacementlist.startdate gt startdate10>
        <cfset startdate10 = getplacementlist.startdate>
		</cfif>
		
        </cfif>
		
        <cfoutput>
        <cfset timesheetexisted = 0>
        <cfset rowcount = 1>
        <h3>Pick a Time Sheet</h3>
        <table width="70%">
        <tr>
        <th width="1%">No.</th>
        <th width="10%">Placement No.</th>
        <th width="15%">Company</th>
        <th width="10%">Date Start</th>
        <th width="10%">Date End</th>
        <th width="15%">Status</th>
        <th width="5%"></th>
        </tr>
        <cfloop from="0" to="10" index="a">
        <cfif isdefined('startdate#a#')>
        <cfset timesheetexisted= 1>
        <tr>
        <td>#rowcount#<cfset rowcount = rowcount + 1></td>
        <td>#evaluate('placementno#a#')#</td>
        <td>#evaluate('custname#a#')#</td>
        <td>#dateformat(evaluate('startdate#a#'),'dd/mm/yyyy')#</td>
        <td>#dateformat(evaluate('enddate#a#'),'dd/mm/yyyy')#</td>
        <td>
        <cfquery name="gettimesheetstatus" datasource="#dsname#">
        SELECT status,MGMTREMARKS,mpremarks FROM timesheet WHERE 
        placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('placementno#a#')#">
        and pdate = "#dateformat(evaluate('startdate#a#'),'YYYY-MM-DD')#"
        </cfquery>
        <cfif gettimesheetstatus.recordcount eq 0>
        NEW
		<cfelseif gettimesheetstatus.recordcount neq 0 and gettimesheetstatus.status eq "">
        SAVED
        <cfelse>
        #gettimesheetstatus.status#<cfif gettimesheetstatus.MGMTREMARKS neq ""> - #gettimesheetstatus.MGMTREMARKS#</cfif><cfif gettimesheetstatus.MPREMARKS neq ""> - #gettimesheetstatus.MPREMARKS#</cfif>
		</cfif>
        
        </td>
        <td><form action="timesheet.cfm" method="post"><input type="hidden" name="pno" id="pno" value="#evaluate('placementno#a#')#"><input type="hidden" name="tsdates" id="tsdates" value="#dateformat(evaluate('startdate#a#'),'yyyy-mm-dd')#"><input type="hidden" name="tsdatee" id="tsdatee" value="#dateformat(evaluate('enddate#a#'),'yyyy-mm-dd')#">
         <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
         <cfif a eq 10>
		 <cfset currentdate = dateadd('m',1,currentdate)>
		 </cfif>
         <input type="hidden" name="nexmonth" id="nexmonth" value="#dateformat(currentdate,'m')#">
        <input type="submit" name="sub_btn" value="Select"></form></td>
        </tr>
		</cfif>
        
        </cfloop>
		<cfif timesheetexisted eq 0>
        <tr>
        <td colspan="6"><h1>Online timesheet is not applicable at this moment.  Please contact ManPower if you have further queries.</h1></td>
        </tr>
		</cfif>
        </table>
        
        
		</cfoutput>