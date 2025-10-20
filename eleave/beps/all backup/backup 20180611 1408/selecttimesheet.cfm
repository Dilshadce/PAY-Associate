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
        <cfset startdate1 = createdate(year(startmonth),month(startmonth),val(startno))>
        <cfset enddate1 = createdate(year(currentdate),month(currentdate),val(endno))>
        
        <cfif checkplacementlist.startdate gt startdate1>
        
        <cfquery name="getanotherplacement" datasource="#dts#">
        SELECT startdate,timesheet,placementno,completedate FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(completedate) = "#dateformat(startdate1,'m')#" and year(completedate) = "#dateformat(startdate1,'yyyy')#" and startdate < "#dateformat(startdate1,'yyyy-mm-dd')#" and completedate >= "#dateformat(startdate1,'yyyy-mm-dd')#"
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
        
        <cfif getplacementlist.completedate lt enddate10>
        <cfset enddate10 = getplacementlist.completedate>
        </cfif>
        
        <cfif getplacementlist.startdate gt startdate10>
        <cfset startdate10 = getplacementlist.startdate>
		</cfif>
		
        </cfif>
		
        <cfoutput>
        <cfloop from="0" to="10" index="a">
        <cfif isdefined('startdate#a#')>
        #a# #evaluate('placementno#a#')# - #dateformat(evaluate('startdate#a#'),'dd/mm/yyyy')# - #dateformat(evaluate('enddate#a#'),'dd/mm/yyyy')#<br>
		</cfif>
        </cfloop>
        
		</cfoutput>