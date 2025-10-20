<cfsetting showdebugoutput="true" requesttimeout="0">
<cfset dsname = "#dts#">
<cfset dts = "#Replace(dts, '_p', '_i')#">
<cfset alertlist = "">
<cfset dd = "">
    
<cfif ("#IsDefined('form.checkerlist')#" AND "#form.checkerlist#" NEQ "") AND ("#IsDefined('form.tsstatus')#" AND "#form.tsstatus#" NEQ "")>
    <cfif "#form.tsstatus#" EQ "Approve">
        <cfset timestatus = "APPROVED">
        <cfset cancelrequest = "N">
    <cfelseif "#form.tsstatus#" EQ "Cancel">
        <cfset timestatus = "CANCELLED">
        <cfset cancelrequest = "N">
    <cfelseif "#form.tsstatus#" EQ "RejectCancellation">
        <cfset timestatus = "APPROVED">
        <cfset cancelrequest = "N">
    <cfelse>
        <cfset timestatus = "REJECTED">
        <cfset cancelrequest = "N">
    </cfif>
    
    <cfloop list="#form.checkerlist#" delimiters="," index="a">
           
        <cfquery name="getleave" datasource="#dts#">
            SELECT a.leavetype, a.days, a.startampm, a.endampm, a.remarks, a.startdate, a.startampm, a.enddate, a.endampm, b.* FROM leavelist a
            LEFT JOIN placement b ON a.placementno = b.placementno            
            WHERE a.id = "#a#"
        </cfquery>
        
        <cfif "#form.tsstatus#" EQ "Approve">

            <cfset starthour = "#getleave.startampm#">
            <cfset endhour = "#getleave.endampm#">
            <cfset calculatedWorkhour = "0">
            <cfset ampm = "">
                
            <cfquery name="getusedleave" datasource="#dts#">
                SELECT SUM(days) AS 'taken', leavetype
                FROM leavelist
                WHERE status = "Approved" AND placementno = "#getleave.placementno#"
                AND leavetype = "#getleave.leavetype#"
                GROUP BY leavetype
            </cfquery>

            <cfif "#getleave.leavetype#" EQ "AL" OR "#getleave.leavetype#" EQ "EL">
                <cfif "#getleave.albfdays#" GT 0 AND "#getleave.albfable#" EQ "Y">
                    <cfset leavebalance = #Val(getleave.aldays)# + #Val(getleave.albfdays)# - #Val(getusedleave.taken)#>
                <cfelse>    
                    <cfset leavebalance = #Val(getleave.aldays)# - #Val(getusedleave.taken)#>
                </cfif>
            <cfelseif "#getleave.leavetype#" EQ "NPL">
                <cfset leavebalance = 999>
            <cfelse>
                <cfset leavebalance = #Val(Evaluate('getleave.#getleave.leavetype#totaldays'))# - #Val(getusedleave.taken)#>
            </cfif>

            <cfif "#Val(leavebalance)#" GTE 0>

                <cfif "#getleave.days#" EQ "0.50">
                    <cfif "#val(left(getleave.startampm, 2))#" LT 12>
                        <cfset starthour = '#numberformat(val(left(getleave.startampm, 2)), '__')+4#:#right(getleave.startampm, 2)#:00'>
                        <cfset endhour = '#numberformat(val(left(getleave.endampm, 2)), '__')+4#:#right(getleave.endampm, 2)#:00'>
                        <cfset ampm = 'AM'>
                    <cfelse>
                        <cfset starthour = '#numberformat(val(left(getleave.startampm, 2)), '__')-4#:#right(getleave.startampm, 2)#:00'>
                        <cfset endhour = '#numberformat(val(left(getleave.endampm, 2)), '__')-4#:#right(getleave.endampm, 2)#:00'>
                        <cfset ampm = 'PM'>
                    </cfif>
                <cfelse>
                    <cfset starthour = '#getleave.startampm#:00'>
                    <cfset endhour = '#getleave.endampm#:00'>
                    <cfset ampm = 'FULL DAY'>
                </cfif>
                
                <!---Added to set timesheet according to am pm working hour, if apply am workhour will be pm [20171004 1616, ALvin]--->
                <cfset starthour = left(#getleave.startampm#, 2)&':00'>
                <cfset endhour = left(#getleave.endampm#, 2)&':00'>
                <cfset startminute = '00:'&right(#getleave.startampm#, 2)>
                <cfset endminute = '00:'&right(#getleave.endampm#, 2)>
                <cfset calculatedWorkhour = #NumberFormat(Val(datediff('n', starthour, endhour))/60, '.__')#>
                <!---Added to set timesheet--->
                    
                <cfset updateLeave("#dts#", "#a#", "#husername#", "#timestatus#", "#form.mgmtremarks#", "#cancelrequest#")>
                <cfset updateTimesheet("#dsname#", "#getleave.leavetype#", "#starthour#", "#endhour#", "#ampm#", "#calculatedWorkhour#", "#getleave.remarks#", "#husername#", "#getleave.startdate#", "#getleave.enddate#", "#getleave.placementno#")>
                
                <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been #LCase(timestatus)#.', '|')#">
                    
            <cfelse>
                <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# (#getleave.placementno#) has insufficient leave balance.', '|')#">
            </cfif>
        <cfelse>
            <cfset updateLeave("#dts#", "#a#", "#husername#", "#timestatus#", "#form.mgmtremarks#", "#cancelrequest#")>
                
            <cfif "#form.tsstatus#" EQ "RejectCancellation">
                <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) cancellation on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been rejected.', '|')#">
            <cfelse>
                <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been #LCase(timestatus)#.', '|')#">
            </cfif>
        </cfif>
        
        <cfset emailNotification("#dts#", "#dsname#", "#a#", "#hcomid#")>
    </cfloop>
                
    <cfoutput>
        <script>
            alert("#Replace(alertlist, '|', '\n', 'ALL')#");
            window.open('/approval2/LeaveApprovalMain.cfm', '_self');
        </script>
    </cfoutput>       
    
<cfelse>
    
    <cfif "#url.statusUpdate#" EQ "Approve">
        <cfset timestatus = "APPROVED">
        <cfset cancelrequest = "N">
    <cfelseif "#url.statusUpdate#" EQ "Cancel">
        <cfset timestatus = "CANCELLED">
        <cfset cancelrequest = "N">
    <cfelseif "#url.statusUpdate#" EQ "RejectCancellation">
        <cfset timestatus = "APPROVED">
        <cfset cancelrequest = "N">
    <cfelse>
        <cfset timestatus = "REJECTED">
        <cfset cancelrequest = "N">
    </cfif>
        
    <cfquery name="getleave" datasource="#dts#">
        SELECT a.leavetype, a.days, a.startampm, a.endampm, a.remarks, a.startdate, a.startampm, a.enddate, a.endampm, b.* FROM leavelist a
        LEFT JOIN placement b ON a.placementno = b.placementno            
        WHERE a.id = "#url.updateDetails#"
    </cfquery>

    <cfif "#url.statusUpdate#" EQ "Approve">

        <cfset starthour = "#getleave.startampm#">
        <cfset endhour = "#getleave.endampm#">
        <cfset calculatedWorkhour = "0">
        <cfset ampm = "">

        <cfquery name="getusedleave" datasource="#dts#">
            SELECT SUM(days) AS 'taken', leavetype
            FROM leavelist
            WHERE status = "Approved" AND placementno = "#getleave.placementno#"
            AND leavetype = "#getleave.leavetype#"
            GROUP BY leavetype
        </cfquery>

        <cfif "#getleave.leavetype#" EQ "AL" OR "#getleave.leavetype#" EQ "EL">
            <cfif "#getleave.albfdays#" GT 0 AND "#getleave.albfable#" EQ "Y">
                <cfset leavebalance = #Val(getleave.aldays)# + #Val(getleave.albfdays)# - #Val(getusedleave.taken)#>
            <cfelse>    
                <cfset leavebalance = #Val(getleave.aldays)# - #Val(getusedleave.taken)#>
            </cfif>
        <cfelseif "#getleave.leavetype#" EQ "NPL">
            <cfset leavebalance = 999>
        <cfelse>
            <cfset leavebalance = #Val(Evaluate('getleave.#getleave.leavetype#days'))# - #Val(getusedleave.taken)#>
        </cfif>
            
        <cfif "#Val(leavebalance)#" GTE 0>
            <cfset updateLeave("#dts#", "#url.updateDetails#", "#husername#", "#timestatus#", "#url.mgmtremarks#", "#cancelrequest#")>

            <cfif "#getleave.days#" EQ "0.50">
                <cfif "#val(left(getleave.startampm, 2))#" LT 12>
                    <cfset starthour = '#numberformat(val(left(getleave.startampm, 2)), '__')+4#:#right(getleave.startampm, 2)#:00'>
                    <cfset endhour = '#numberformat(val(left(getleave.endampm, 2)), '__')+4#:#right(getleave.endampm, 2)#:00'>
                    <cfset ampm = 'AM'>
                <cfelse>
                    <cfset starthour = '#numberformat(val(left(getleave.startampm, 2)), '__')-4#:#right(getleave.startampm, 2)#:00'>
                    <cfset endhour = '#numberformat(val(left(getleave.endampm, 2)), '__')-4#:#right(getleave.endampm, 2)#:00'>
                    <cfset ampm = 'PM'>
                </cfif>
            <cfelse>
                <cfset starthour = '#getleave.startampm#:00'>
                <cfset endhour = '#getleave.endampm#:00'>
                <cfset ampm = 'FULL DAY'>
            </cfif>

            <!---Added to set timesheet according to am pm working hour, if apply am workhour will be pm [20171004 1616, ALvin]--->
            <cfset starthour = left(#getleave.startampm#, 2)&':00'>
            <cfset endhour = left(#getleave.endampm#, 2)&':00'>
            <cfset startminute = '00:'&right(#getleave.startampm#, 2)>
            <cfset endminute = '00:'&right(#getleave.endampm#, 2)>
            <cfset calculatedWorkhour = #NumberFormat(Val(datediff('n', starthour, endhour))/60, '.__')#>
            <!---Added to set timesheet--->

            <cfset updateTimesheet("#dsname#", "#getleave.leavetype#", "#starthour#", "#endhour#", "#ampm#", "#calculatedWorkhour#", "#getleave.remarks#", "#husername#", "#getleave.startdate#", "#getleave.enddate#", "#getleave.placementno#")>

            <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been #LCase(timestatus)#.', '|')#">
        <cfelse>
                <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# (#getleave.placementno#) has insufficient leave balance.', '|')#"> 
        </cfif>
    <cfelse>
        <cfset updateLeave("#dts#", "#url.updateDetails#", "#husername#", "#timestatus#", "#url.mgmtremarks#", "#cancelrequest#")>

        <cfif "#url.statusUpdate#" EQ "RejectCancellation">
            <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) cancellation on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been rejected.', '|')#">
        <cfelse>
            <cfset alertlist = "#ListAppend(alertlist, '#getleave.empname# leave(#getleave.leavetype#) on #DateFormat(getleave.startdate, 'yyyy-mm-dd')# to #DateFormat(getleave.enddate, 'yyyy-mm-dd')# has been #LCase(timestatus)#.', '|')#">
        </cfif>    
    </cfif>
    
    <cfset emailNotification("#dts#", "#dsname#", "#url.updateDetails#", "#hcomid#")>
    <cfoutput>
        <script>
            alert("#Replace(alertlist, '|', '\n', 'ALL')#");
            window.open('/approval2/LeaveApprovalMain.cfm', '_self');
        </script>
    </cfoutput>
</cfif>

<cffunction name="updateLeave">
	<cfargument name="dts" required="true">
	<cfargument name="leaveid" required="true">
	<cfargument name="husername" required="true">
	<cfargument name="leavestatus" required="true">
	<cfargument name="managerremarks" required="true">
	<cfargument name="cancelreq" required="true">
        
    <cfquery name="approve_leave" datasource="#dts#">
        UPDATE leavelist SET 
        STATUS = "#leavestatus#", updated_by = "#HUserName#", MGMTREMARKS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#managerremarks#">, 
        updated_on = now(), cancel_req = "#cancelreq#" 
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#leaveid#">
    </cfquery>
</cffunction>   
        
<cffunction name="updateTimesheet">
    <cfargument name="dsname" required="true">
	<cfargument name="leavetype" required="true">
	<cfargument name="starthour" required="true">
	<cfargument name="endhour" required="true">
	<cfargument name="ampm" required="true">
	<cfargument name="workedhour" required="true">
	<cfargument name="associateremarks" default="" required="true">
	<cfargument name="husername" required="true">
	<cfargument name="startdate" required="true">
	<cfargument name="enddate" required="true">
	<cfargument name="pno" required="true">
        
    <cfquery name="insertLeaveintoTimesheet" datasource="#dsname#">
        UPDATE timesheet
        SET stcol = '#leavetype#',
        starttime = "#starthour#",
        endtime = "#endhour#",
        ampm = "#ampm#",
        breaktime = '0',
        workhours = '#workedhour#',
        remarks = '#associateremarks#',
        updated_on = now(),
        updated_by = "#husername#",
        othour = '0.00',
        ot15hour = '0.00',
        ot2hour = '0.00',
        ot3hour = '0.00',
        otrd1hour = '0.00',
        otrd2hour = '0.00',
        otph1hour = '0.00',
        otph2hour = '0.00',
        ot1 = '0.00000',
        ot2 = '0.00000',
        ot3 = '0.00000',
        ot4 = '0.00000',
        ot5 = '0.00000',
        ot6 = '0.00000',
        ot7 = '0.00000',
        ot8 = '0.00000'
        WHERE pdate >= "#dateformat(startdate,'yyyy-mm-dd')#" AND pdate <= "#dateformat(enddate,'yyyy-mm-dd')#"
        AND placementno = '#pno#'
        AND (status = "" OR status = "Rejected" OR status = "Cancelled")
    </cfquery>
</cffunction>

<cffunction name="emailNotification">
	<cfargument name="dts" required="true">
	<cfargument name="dsname" required="true">
	<cfargument name="leaveid" required="true">
	<cfargument name="hcomid" required="true">

    <cfquery name="getemail2" datasource="#dts#">
        SELECT * FROM notisetting
    </cfquery>

    <cfset template = getemail2.template9>
    <cfset header = getemail2.header9>
    <cfset template2 = getemail2.template10>
    <cfset header2 = getemail2.header10>

    <cfquery name="getdata" datasource="#dts#">
        SELECT a.*, b.*, c.*, CASE WHEN c.workemail = "" THEN c.email ELSE c.workemail END as validemail 
        FROM leavelist a 
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#leaveid#">
    </cfquery>

    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;leavetype&amp;,&amp;startdate&amp;,&amp;enddate&amp;,&amp;days&amp;,&amp;startampm&amp;,&amp;endampm&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">

    <cfset templatelist2 = "&empno&, &name&, &leavetype&, &datestart&, &dateend&, &days&, &timefrom&, &timeto&, &remarks&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #ucase(HComID)#">

    <cfset count1 = 0>
    <cfloop list="#templatelist1#" index="i" delimiters=",">
        <cfset count1 += 1>
        <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
        <cfset template2 = replace(template2,i,listgetat(replacelist1,count1),'all')>
    </cfloop>

    <cfset count2 = 0>
    <cfloop list="#templatelist2#" index="i" delimiters=",">
        <cfset count2 += 1>
        <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
        <cfset header2 = replace(header2,i,listgetat(replacelist2,count2),'all')>
    </cfloop>

    <cfset htmlstarttag = "<html>">
    <cfset htmlendtag = "</html>">

    <cftry>
        <cfif #getemail2.setting9# eq 'Y'>
            <cfif isvalid("email",trim(getdata.hrmgremail))>
                <cfquery name="getcc" datasource="#dsname#">
                    SELECT * FROM email_to_cc
                    WHERE id_no = "#getdata.custno#"
                    OR id_no = "#getdata.empno#"
                    OR id_no = "#getdata.placementno#"
                    ORDER BY priority ASC
                </cfquery>
                <cfif "#getcc.recordcount#" NEQ 0>
                    <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.validemail)#" subject="#header#" type="html"
                        bcc="alvin.hen@manpower.com.my" cc="#getcc.cc_email#"> <!---,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my--->
                        #htmlstarttag#
                        #template#
                        #htmlendtag#
                    </cfmail>
                <cfelse>
                    <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.validemail)#" subject="#header#" type="html"
                        bcc="alvin.hen@manpower.com.my"> <!---,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my--->
                        #htmlstarttag#
                        #template#
                        #htmlendtag#
                    </cfmail>
                </cfif>
            </cfif>
        </cfif>
        <cfif #getemail2.setting10# eq 'Y'> 
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" 
                    subject="#header2#" type="html" bcc="alvin.hen@manpower.com.my"> <!---,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my--->
                #htmlstarttag#
                #template2#
                #htmlendtag#
            </cfmail> 
        </cfif>
    <cfcatch type="any"></cfcatch>
    </cftry>
    
</cffunction>