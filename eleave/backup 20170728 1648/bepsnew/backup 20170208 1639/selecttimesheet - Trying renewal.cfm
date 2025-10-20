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
        <cfset tempcurrentdate = #dateformat(dateadd('m',-2, currentdate), 'yyyy-mm-dd')#>
        
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
            SELECT * FROM placement WHERE (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            								<!---AND startdate >= '#tempcurrentdate#' AND completedate >= '#tempcurrentdate#'--->)
                                <!---(startdate <= '#dateformat(currentdate,'yyyy-mm-dd')#' AND completedate >='#dateformat(currentdate,'yyyy-mm-dd')#' 
                                	AND empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">)
                                OR (startdate <= '#dateformat(dateadd('m', -1, currentdate),'yyyy-mm-dd')#' AND completedate >='#dateformat(dateadd('m', -1, currentdate),'yyyy-mm-dd')#' 
                                	AND empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">)
                                OR (startdate <= '#dateformat(dateadd('m', -2, currentdate),'yyyy-mm-dd')#' AND completedate >='#dateformat(dateadd('m', -2, currentdate),'yyyy-mm-dd')#' 
                                	AND empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">)
                                order by startdate--->
            								<!---and ((month(startdate) >= #dateformat(tempcurrentdate, 'm')#) AND (year(startdate) >= #dateformat(tempcurrentdate, 'yyyy')#))--->
                                            <!---and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"--->
                                            <!---<cfif #dateformat(currentdate,'m')# eq '12'> <!---if month is december, need to go to JAN next year--->
                                                or (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(dateadd('m', 1, currentdate),'m')#" 
                                                and year(startdate) = "#dateformat(dateadd('yyyy', 1, currentdate),'yyyy')#")
                                            <cfelse>
                                            	or (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" 
                                                and year(startdate) = "#dateformat(currentdate,'yyyy')#")<!---alvin2--->
                                            </cfif>      --->                                     
        </cfquery>

        <cfset itemcounter = 0>
        <cfset lastcompletedate = 0>
        <cfset renewalflag = 0>
        <cfset enddateflag = false> 																										<!---reset flag--->
        
<!---new select timesheet logic (handle multiple placement), [20170111, Alvin]--->
<!---<cfif #checkplacementlist.recordcount# gt 1>--->
	
	<cfloop query="checkplacementlist">
        
    	<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)> 											<!---reset currentdate--->
		
        <cfset displaycounter = 0> 																											<!---reset display counter--->
        
        <cfif #checkplacementlist.timesheet# EQ '01-31'>
        	<cfset currentdate = dateadd('m',-2, currentdate)>																				<!--- to roll back to 2 months back--->
        <cfelse>
        	<cfset currentdate = dateadd('m',-1, currentdate)>																				<!--- to roll back to 1 months back--->
        </cfif>
        
        <cfif <!---((month(renewalflag) eq month(currentdate)) AND (year(renewalflag) eq year(currentdate))) OR---> #enddateflag# EQ FALSE>
        	<cfset loopcount = 3>
        <cfelse>
        	<cfset loopcount = 1>
            <cfset enddateflag = FALSE>
        </cfif>
      
    	<cfloop condition="displaycounter NOT EQUAL #loopcount#"> 																					<!---act like while loop, stop once 3 month displayed--->
        	
        	<cfif checkplacementlist.startdate lte now()> 																					<!---if startdate is past today create timesheet else dont--->
            	
                <cfquery name="gettimesheetdetail" datasource="#dts#">
                    SELECT * FROM iccolorid  
                    WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
                </cfquery>
                        
            	<cfset startno  = left(trim(checkplacementlist.timesheet),2)> 																<!---to get timesheet cycle starting--->
                <cfset endno = mid(trim(checkplacementlist.timesheet),4,2)>																	<!---to get timesheet cycle ending--->

                <cfif startno gt endno>																										<!---if timesheet cycle is like 16-15 where the date of starting is > ending--->
                    <cfset startmonth = dateadd('m',-1,currentdate)> 																		<!---start from previous month--->
                <cfelse>
                    <cfset startmonth = currentdate>				 																		<!---else start from current month--->
                </cfif>
            
                <cfif endno eq "31"> 																										<!---if timesheet cycle is 01-31, get last day of the month--->
                    <cfset endno = daysinmonth(currentdate)>
                </cfif>   

                <!---                              placement startdate and completedate validation                           ---> 
					<!---<cfif #createdate(year(currentdate),month(currentdate),val(endno))# eq #renewalflag#> 									<!---to display record which have renewal--->
                    		
                    	<cfset displaycounter += 2>
                        <cfset currentdate = dateadd('m',1, currentdate)>
                        <cfcontinue>
                    </cfif>--->
                
					<cfif #currentdate# lt #checkplacementlist.startdate#>																	<!--- placement havent commence from current date--->
                        <cfset currentdate = dateadd('m',1, currentdate)>
                        <cfcontinue>
                    </cfif>
                    
                    <cfif #enddateflag# EQ TRUE>																							<!---if current date exceed placement completedate, break--->
                       <!--- <cfbreak>--->
                    </cfif>

                <cfif #currentdate# gt #checkplacementlist.completedate#>																	<!---if reached end of the timesheet, break--->
                		<cfbreak>				
                </cfif>
				<!---                                               end of validation                                        --->
                
                        

                <cfset 'placementno#itemcounter#' = checkplacementlist.placementno> 														<!---fill in placementno--->
                <cfset 'custname#itemcounter#' = checkplacementlist.custname>																<!---fill in custname--->
                <cfset 'startdate#itemcounter#' = createdate(year(startmonth),month(startmonth),val(startno))>								<!---create start date based on the cycle and mmonth, myear, startno(timesheet cycle)--->
                <cfset 'enddate#itemcounter#' = createdate(year(currentdate),month(currentdate),val(endno))>								<!---create end date based on the cycle and mmonth, myear, endno(timesheet cycle)--->
  
                <cfif checkplacementlist.completedate lt evaluate("enddate#itemcounter#")>
                    <cfset 'enddate#itemcounter#' = checkplacementlist.completedate>														<!---if cycle exceed complete date, stops at complete date--->
                    <cfset enddateflag = TRUE>																								<!---reached end of cycle, set end flag to true--->
                    <cfset renewalflag = evaluate('enddate#itemcounter#')>
                </cfif>
    
                <cfif (evaluate('month(startdate#itemcounter#)') eq month(#checkplacementlist.startdate#)) 
						AND (evaluate('year(startdate#itemcounter#)') eq year(#checkplacementlist.startdate#))>
                    <cfif checkplacementlist.startdate lt evaluate('startdate#itemcounter#')>												<!---if cycle begin exceed start date, begin at start date--->
                        <cfset 'startdate#itemcounter#' = checkplacementlist.startdate>
                    </cfif>
                </cfif>
                
                <cfset lastcompletedate = #evaluate('enddate#itemcounter#')#>
                <cfset currentdate = dateadd('m',1, currentdate)> 																			<!---add 1 month to move to next month--->
                <cfset itemcounter += 1>
                <cfset displaycounter += 1> 																								<!---counter for display, if display created counter++--->
                <!---
                <!---for placement renewal purpose--->
                <cfquery name="getnewplacement" datasource="#dts#">
                    	SELECT startdate, completedate, placementno, custname FROM placement
                        WHERE startdate = '#dateformat(dateadd('d', 1, lastcompletedate),'yyyy-mm-dd')#'
                        AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
                    </cfquery>
                    
                <cfif day(lastcompletedate) NEQ endno AND #getnewplacement.recordcount# EQ 1>												<!---if last day is not tally with timesheet cycle end date and more than 1 record--->
                
                <cfset lastcompletedate = #dateformat(dateadd('d', 1, lastcompletedate),'yyyy-mm-dd')#>
                <!---<cfif checkplacementlist.timesheet eq '01-31'>																				<!---if cycle is not 01-31 add 1 month--->
                	<cfset lastcompletedate = #dateformat(dateadd('m', 1, lastcompletedate),'yyyy-mm-dd')#>
                </cfif>--->
                	<cfset 'placementno#itemcounter#' = getnewplacement.placementno> 														<!---fill in placementno--->
					<cfset 'custname#itemcounter#' = '#getnewplacement.custname#haha'>																<!---fill in custname--->
                    <cfset 'startdate#itemcounter#' = createdate(year(lastcompletedate),month(lastcompletedate),day(lastcompletedate))>		<!---create start date based on the cycle and mmonth, myear, startno(timesheet cycle)--->
                    <cfset 'enddate#itemcounter#' = createdate(year(lastcompletedate),month(lastcompletedate),val(endno))>
                    <cfset renewalflag = evaluate('enddate#itemcounter#')>
                    <cfset enddateflag = TRUE>
                    <cfset itemcounter += 1>
                    
                </cfif>
               <!---end of placement renewal--->
			   --->
               
            </cfif>
        </cfloop>
    </cfloop>
<!---<cfelse>--->        
<!---end of new select timesheet method--->       



<!---
        <cfif checkplacementlist.recordcount neq 0>
		<h3> record count neq 0 </h3>
				<cfif checkplacementlist.timesheet neq "">
            
                <cfquery name="gettimesheetdetail" datasource="#dts#">
                    SELECT * FROM iccolorid  
                    WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
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
                
                
                <!---check startdate > startdate1--->
                <cfif checkplacementlist.startdate gt startdate1>
                
                <h3> startdate: <cfoutput>#checkplacementlist.startdate# is gt startdate1: #startdate1#</cfoutput> </h3>
                
                    <cfquery name="getanotherplacement" datasource="#dts#">
                        SELECT startdate,timesheet,placementno,completedate,custname 
                        FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
                        AND month(completedate) = "#dateformat(startdate1,'m')#" 
                        AND year(completedate) = "#dateformat(startdate1,'yyyy')#" 
                        AND startdate < "#dateformat(startdate1,'yyyy-mm-dd')#" 
                        AND completedate >= "#dateformat(startdate1,'yyyy-mm-dd')#"
                    </cfquery>

                        <cfif getanotherplacement.recordcount  neq 0>
                
                            <cfif getanotherplacement.timesheet neq "">
                            
                                <cfquery name="gettimesheetdetail" datasource="#dts#">
                                    SELECT * 
                                    FROM iccolorid  
                                    WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getanotherplacement.timesheet#">
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
            <!---end of check startdate > startdate1--->
    
            <cfif checkplacementlist.completedate lt enddate1>
                <cfset enddate1 = checkplacementlist.completedate>
            </cfif>
            
            <cfif checkplacementlist.startdate gt startdate1>
                <cfset startdate1 = checkplacementlist.startdate>
            </cfif>
            
            <!---if record count != 1--->       
            <cfif checkplacementlist.recordcount neq 1>
            	<h3> Record count neq 1</h3>
                <cfloop query="checkplacementlist" startrow="2" endrow="#checkplacementlist.recordcount#">
                 
                    <cfset currentdate = checkplacementlist.startdate>
                    
                    <cfif checkplacementlist.timesheet neq "">
                    
                        <cfquery name="gettimesheetdetail" datasource="#dts#">
                            SELECT * 
                            FROM iccolorid  
                            WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
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
            <!---end of recordcount !=1--->
          </cfif>
        
		</cfif>
        
        <cfset currentdate = dateadd('m',1,createdate(val(company_details.myear),val(company_details.mmonth),1))>

        <cfquery name="getplacementlist" datasource="#dts#">
        	SELECT * 
            FROM placement 
            WHERE (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            AND startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" 
            AND completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#")
			or (empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" 
                                                and year(startdate) = "#dateformat( currentdate,'yyyy')#")<!---alvin3--->
        </cfquery>
        
        <!---if no record--->
        <cfif getplacementlist.recordcount eq 0>
        
			<cfset currentdatenew = createdate(val(company_details.myear),val(company_details.mmonth),1)>
            <cfquery name="checktimesheet" datasource="#dts#">
            	SELECT timesheet 
                FROM placement 
                WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
                AND startdate <= "#dateformat(currentdatenew,'yyyy-mm-dd')#" 
                AND completedate >= "#dateformat(currentdatenew,'yyyy-mm-dd')#"
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
                    	SELECT * 
                        FROM placement 
                        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
                        AND startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" 
                        AND completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"<!---alvin--->
                    </cfquery>
            
            		<cfset currentdate = dateadd('m',1,currentdate)>
            
				</cfif>
			</cfif>
		</cfif>
        <!---END OF no record--->
		<cfif getplacementlist.timesheet neq "">
            <cfquery name="gettimesheetdetail" datasource="#dts#">
            	SELECT * 
                FROM iccolorid  
                WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
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
</cfif>
---> 


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
        				<cfloop from="0" to="#itemcounter#" index="a">
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
                                <td><form action="timesheet.cfm" method="post"><input type="hidden" name="pno" id="pno" value="#evaluate('placementno#a#')#">
                                <input type="hidden" name="tsdates" id="tsdates" value="#dateformat(evaluate('startdate#a#'),'yyyy-mm-dd')#">
                                <input type="hidden" name="tsdatee" id="tsdatee" value="#dateformat(evaluate('enddate#a#'),'yyyy-mm-dd')#">
                                     <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
                                     <cfif a eq 10>
                                     	<cfset currentdate = dateadd('m',1,currentdate)>
                                     </cfif>
                                     <input type="hidden" name="nexmonth" id="nexmonth" value="#dateformat(currentdate,'m')#">
                                    <input type="submit" name="sub_btn" value="Select"></form>
                                </td>
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