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
    <cfset loopDate = #dateformat(dateadd('m',-2, currentdate), 'yyyy-mm-dd')#>
    <cfset nextMonth = 0>
    <cfset tyear = 0>
    <cfset controlDate = 0>

    <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
    </cfquery>

    <cfquery name="checkplacementlist" datasource="#dts#">
        SELECT * FROM 
        placement 
        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
        AND completedate >= '#loopDate#'
        AND jobstatus = '2' 
        ORDER BY startdate   
    </cfquery>

    <cfset itemcounter = 0>							
    <cfset timesheetChanged = FALSE>				
    <cfset placementfirstloop = TRUE>				                <!---flag to indicate first time running for placement--->
    <cfset previousTimesheet = "#checkplacementlist.timesheet#">	<!---flag to keep track of timesheet cycle in case placement renewal got 2 different cycle--->

    <!---does not cater more than 1 concurrent placement--->

    <cfloop query="checkplacementlist">

        <cfquery name="gettimesheetdetail" datasource="#dts#">
            SELECT * FROM iccolorid  
            WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#checkplacementlist.timesheet#">
        </cfquery>

        <cfset startno  = left(trim(checkplacementlist.timesheet),2)>           <!---to get timesheet cycle start day and end day--->
        <cfset endno = mid(trim(checkplacementlist.timesheet),4,2)>

        <cfif timesheetChanged eq FALSE>										<!---this only need to be initialise one time--->
            <cfif startno gt endno>				<!---set the loopdate and control date - loopdate will be past month and control date will be future 1 month--->
                <cfset controlDate = #dateadd('m', 1, currentdate)#>			<!---if cycle not 01-31 it loopdate wil be 2 month past from current--->	
                <cfset nextMonth = dateadd('m', 1, loopDate)>
            <cfelse>
                <cfset loopDate = dateadd('m', 1, loopDate)>				    <!---if it is 01-31 then loop date set to previous month--->
                <cfset nextMonth = #loopDate#>
                <cfset controlDate = #dateadd('m', 1, currentdate)#>
            </cfif>
        </cfif>

        <cfif #previousTimesheet# neq  #checkplacementlist.timesheet#>		    <!---if previous placement timesheet cycle different than current--->
            <cfif #left(checkplacementlist.timesheet, 2)# lt #right(checkplacementlist.timesheet, 2)#>	
                                                                                <!---if it is 01-31, add 1 month to loopdate to make it same as nextmonth--->
                <cfset loopDate = #dateformat(dateadd('m', 1, loopDate), 'yyyy-mm-dd')#>
            </cfif>
        </cfif>

        <cfif loopDate gt #checkplacementlist.completedate#>					<!---if loop date > completedate timesheet expired--->
            <cfset timesheetChanged = TRUE>
            <cfcontinue>
        </cfif>

        <cfif createdate(year(loopDate),month(loopDate),val(startno)) gt #checkplacementlist.completedate#>                             
                                                                <!---if loop date(exact date for timesheet not 01-31 greater than completedate, timesheet expired--->
            <cfset timesheetChanged = TRUE>
            <cfcontinue>
        </cfif>

        <cfset previousTimesheet = "#checkplacementlist.timesheet#">
        <cfset placementfirstloop = TRUE>					  <!---first time placement running reset to true--->

        <cfloop condition="#loopDate# lte #controlDate#">

            <cfset startno  = left(trim(checkplacementlist.timesheet),2)> 		<!---to get timesheet cycle starting--->
            <cfset endno = mid(trim(checkplacementlist.timesheet),4,2)>

            <cfif startno gt endno>								<!---if timesheet cycle is not 1-31, nextmonth should be ahead of loopdate instead of same month--->
                <cfif #nextMonth# gt #controlDate#>								<!---if nextmonth gt than controldate stop looping timesheet--->
                    <cfbreak>
                <cfelse>
                    <cfset nextMonth = #dateformat(dateadd('m', 1, loopDate), 'yyyy-mm-dd')#>
                </cfif>
            </cfif>

            <cfif #month(loopdate)# LT #month(checkplacementlist.startdate)# AND #year(loopdate)# EQ #year(checkplacementlist.startdate)#>
                <cfset loopDate = #dateformat(dateadd('m', 1, loopDate), 'yyyy-mm-dd')#>											
                                                            <!---Check if startdate havent commence from loopdate then go to the next month , [20170727, Alvin]--->
                <cfset nextMonth = #dateformat(dateadd('m', 1, nextMonth), 'yyyy-mm-dd')#>
            </cfif>

            <cfif endno eq "31"> 											    <!---if timesheet cycle is 01-31, get last day of the month--->
                <cfset endno = daysinmonth(nextMonth)>
            </cfif>

            <cfset 'placementno#itemcounter#' = checkplacementlist.placementno> 						<!---fill in placementno--->
            <cfset 'custname#itemcounter#' = checkplacementlist.custname>								<!---fill in custname--->
            <cfset 'startdate#itemcounter#' = createdate(year(loopDate),month(loopDate),val(startno))>	
                                                                            <!---create start date based on the cycle and mmonth, myear, startno(timesheet cycle)--->
            <cfset 'enddate#itemcounter#' = createdate(year(nextMonth),month(nextMonth),val(endno))>	
                                                                            <!---create end date based on the cycle and mmonth, myear, endno(timesheet cycle)--->
            <cfset 'nextmonth#itemcounter#' = "#dateformat(nextMonth,'m')#">                            <!---tmonth value holder--->
            <cfset 'tyear#itemcounter#' = "#dateformat(nextMonth,'yyyy')#">                            <!---tmonth value holder--->

            <cfif checkplacementlist.completedate lte evaluate("enddate#itemcounter#")>
                <cfset 'enddate#itemcounter#' = dateformat(checkplacementlist.completedate, 'yyyy-mm-dd')>			
                                                                            <!---if cycle exceed complete date, stops at complete date--->
                <cfif evaluate('day(enddate#itemcounter#)') eq endno>		<!---if dateend stops at end of timesheet cycle, add 1 month loopdate,nextmonth--->
                    <cfset loopDate = #dateformat(dateadd('m', 1, loopDate), 'yyyy-mm-dd')#>    <!---increment counter if enddate eq timesheet endno--->
                    <cfset nextMonth = #dateformat(dateadd('m', 1, nextMonth), 'yyyy-mm-dd')#>
                </cfif>
                <cfset timesheetChanged = TRUE>
                <cfset itemcounter += 1>
                <cfset endFirstPlacement = TRUE>
                <cfbreak>
            </cfif>

            <cfif checkplacementlist.startdate gt evaluate('startdate#itemcounter#')>
                                                                    <!---if startdate has not begin from the defaulted startdate, set to placement startdate--->
                <cfset 'startdate#itemcounter#' = checkplacementlist.startdate>		<!---startdate havent commence from defaulted startdate--->
            <cfelseif (month(#checkplacementlist.startdate#) eq evaluate('month(startdate#itemcounter#)') 								
                                                                    <!---to check month is equal for loopdate and startdate month--->
                        AND year(#checkplacementlist.startdate#) eq evaluate('year(startdate#itemcounter#)')) 
                                                                <!---to check year is equal for loopdate and startdate year--->
                        AND	#checkplacementlist.startdate# lt evaluate('startdate#itemcounter#')	<!---if startdate is smaller than loopdate--->
                        AND #placementfirstloop# eq TRUE>		<!---if placement is executed for the first time--->

                <cfset 'startdate#itemcounter#' = checkplacementlist.startdate>	<!---set the earlier startdate to be the startdate for current row--->
                <cfset 'enddate#itemcounter#' = createdate(year(loopDate),month(loopDate),val(endno))>	
                                                                                <!---enddate set to earlier startdate month,year and timesheet endno--->
                <cfset 'nextmonth#itemcounter#' = "#dateformat(nextMonth,'m')#"><!---tmonth value holder--->
                <cfset 'tyear#itemcounter#' = "#dateformat(nextMonth,'yyyy')#">    <!---tyear value holder--->
                <cfset itemcounter += 1>
                <cfset timesheetChanged = TRUE>
                <cfset placementfirstloop = FALSE>						        <!---change placement executed first time--->
                <cfcontinue>

            </cfif>

            <cfset loopDate = #dateformat(dateadd('m', 1, loopDate), 'yyyy-mm-dd')#> <!---increment counter--->
            <cfset nextMonth = #dateformat(dateadd('m', 1, nextMonth), 'yyyy-mm-dd')#>
            <cfset itemcounter += 1>
            <cfset timesheetChanged = TRUE>
            <cfset placementfirstloop = FALSE>

        </cfloop>

    </cfloop>

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
                        <!---modified query and changed status retrieval method, [20170125, Alvin]--->
                        <cfquery name="gettimesheetstatus" datasource="#dsname#">
                            SELECT status,MGMTREMARKS,mpremarks 
                            FROM timesheet 
                            WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('placementno#a#')#">
                            AND pdate BETWEEN "#dateformat(evaluate('startdate#a#'),'YYYY-MM-DD')#"
                            AND "#dateformat(evaluate('enddate#a#'),'YYYY-MM-DD')#"
                        </cfquery>

                        <cfset daysCount = abs(datediff('d', evaluate('startdate#a#'), evaluate('enddate#a#')))>
                        <cfset approvedCount = 0>
                        <cfset submittedCount = 0>
                        <cfset rejectedCount = 0>
                        <cfset validatedCount = 0>

                        <cfloop query="gettimesheetstatus">
                            <cfif #gettimesheetstatus.status# eq 'Approved'>
                                <cfset approvedCount += 1>
                            <cfelseif #gettimesheetstatus.status# eq 'Submitted For Approval'>
                                <cfset submittedCount += 1>
                            <cfelseif #gettimesheetstatus.status# eq 'Validated'>
                                <cfset validatedCount += 1>
                            <cfelseif #gettimesheetstatus.status# eq 'Rejected'>
                                <cfset rejectedCount += 1>
                            </cfif>
                        </cfloop>

                        <cfif gettimesheetstatus.recordcount eq 0>
                            NEW
                        <cfelseif #approvedCount# eq (val(daysCount) + 1)>	<!---approved status eq to total days specified in timesheet means all timesheet approved--->

                            #gettimesheetstatus.status#																									
                            <cfif gettimesheetstatus.MGMTREMARKS neq ""> - #gettimesheetstatus.MGMTREMARKS#</cfif>
                            <cfif gettimesheetstatus.MPREMARKS neq ""> - #gettimesheetstatus.MPREMARKS#</cfif>

                        <cfelseif #submittedCount# eq (val(daysCount) + 1)>	<!---submitted status eq to total days specified in timesheet means all timesheet submitted--->

                            #gettimesheetstatus.status#
                            <cfif gettimesheetstatus.MGMTREMARKS neq ""> - #gettimesheetstatus.MGMTREMARKS#</cfif>
                            <cfif gettimesheetstatus.MPREMARKS neq ""> - #gettimesheetstatus.MPREMARKS#</cfif>

                        <cfelseif #validatedCount# eq (val(daysCount) + 1)>	<!---validated status eq total days specified in timesheet means all timesheet validated--->

                            #gettimesheetstatus.status#
                            <cfif gettimesheetstatus.MGMTREMARKS neq ""> - #gettimesheetstatus.MGMTREMARKS#</cfif>
                            <cfif gettimesheetstatus.MPREMARKS neq ""> - #gettimesheetstatus.MPREMARKS#</cfif>

                        <cfelseif #rejectedCount# eq (val(daysCount) + 1)>	<!---rejected status eq total days specified in timesheet means all timesheet rejected--->

                            #gettimesheetstatus.status#
                            <cfif gettimesheetstatus.MGMTREMARKS neq ""> - #gettimesheetstatus.MGMTREMARKS#</cfif>
                            <cfif gettimesheetstatus.MPREMARKS neq ""> - #gettimesheetstatus.MPREMARKS#</cfif>

                        <cfelse>			                             <!---else status does not match total days specified in timesheet mark as saved--->
                            SAVED
                        </cfif>
                        <!---modified--->
                    </td>
                    <td>
                        <form action="timesheet.cfm" method="post">
                            <input type="hidden" name="pno" id="pno" value="#evaluate('placementno#a#')#">
                            <input type="hidden" name="tsdates" id="tsdates" value="#dateformat(evaluate('startdate#a#'),'yyyy-mm-dd')#">
                            <input type="hidden" name="tsdatee" id="tsdatee" value="#dateformat(evaluate('enddate#a#'),'yyyy-mm-dd')#">
                            <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
                            <cfif a eq 10>
                               <cfset currentdate = dateadd('m',1,currentdate)>
                            </cfif>
                            <!---<input type="hidden" name="nexmonth" id="nexmonth" value="#dateformat(evaluate('enddate#a#'),'m')#">--->
                            <input type="hidden" name="nexmonth" id="nexmonth" value="#evaluate('nextmonth#a#')#">
                            <input type="hidden" name="tyear" id="tyear" value="#evaluate('tyear#a#')#">
                            <input type="submit" name="sub_btn" value="Select">
                        </form>
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