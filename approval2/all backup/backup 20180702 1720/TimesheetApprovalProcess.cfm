<cfsetting showdebugoutput="true" requesttimeout="0">
<cfif ("#IsDefined('form.checkerlist')#" AND "#form.checkerlist#" NEQ "") AND ("#IsDefined('form.tsstatus')#" AND "#form.tsstatus#" NEQ "")>
    <cfif "#form.tsstatus#" EQ "Approve">
        <cfset tseditable = "N">
        <cfset timestatus = "Approved">
        <cfset cancelrequest = "N">
    <cfelseif "#form.tsstatus#" EQ "Cancel">
        <cfset tseditable = "Y">
        <cfset timestatus = "Cancelled">
        <cfset cancelrequest = "N">
    <cfelseif "#form.tsstatus#" EQ "RejectCancellation">
        <cfset tseditable = "N">
        <cfset timestatus = "Approved">
        <cfset cancelrequest = "N">
    <cfelse>
        <cfset tseditable = "Y">
        <cfset timestatus = "Rejected">
        <cfset cancelrequest = "N">
    </cfif>
    
    <cfloop list="#form.checkerlist#" delimiters="," index="a">
        <cfset pno = "#ListGetAt(a, 1, '-')#">
        <cfset tsmonth = "#ListGetAt(a, 2, '-')#">
        <cfset tsyear = "#ListGetAt(a, 3, '-')#">
        
        <!---Update timesheet day by day--->
        <cfquery name="getts" datasource="#dts#">
            SELECT placementno, pdate, cancel_req FROM timesheet WHERE placementno = "#pno#" and tmonth = "#tsmonth#" and tyear = "#tsyear#" ORDER by pdate
        </cfquery>
            
        <cfloop query="getts">                    
            <cfquery name="updateTS" datasource="#dts#">
                UPDATE timesheet SET
                updated_on = now(),
                updated_by = "#HUserID#",
                MGMTREMARKS = "#form.mgmtremarks#",
                status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#timestatus#">,
                editable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tseditable#">,
                cancel_req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cancelrequest#">
                WHERE placementno = "#getts.placementno#"
                AND pdate = "#DateFormat(getts.pdate, 'yyyy-mm-dd')#"
            </cfquery>
        </cfloop>
                
        <!---Update range in one go--->
        <!---<cfquery name="updateTS" datasource="#dts#">
            UPDATE timesheet SET
            updated_on = now(),
            updated_by = "#HUserID#",
            MGMTREMARKS = "#form.mgmtremarks#",
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#timestatus#">,
            editable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tseditable#">
            WHERE placementno = "#pno#"
            AND tmonth = "#tsmonth#"
            AND tyear = "#tsyear#"
        </cfquery>--->
            
        <cfset emailNotification("#dts#", "#pno#", "#tsmonth#", "#tsyear#")>
    </cfloop>
                
    <cfoutput>
        <script>
            alert("#Listlen(form.checkerlist, ',')# Timesheet #timestatus#!");
            window.open('/approval2/TimesheetApprovalMain.cfm', '_self');
        </script>
    </cfoutput>                
<cfelse>
    <cfif "#url.statusUpdate#" EQ "Approve">
        <cfset tseditable = "N">
        <cfset timestatus = "Approved">
        <cfset cancelrequest = "N">
    <cfelseif "#url.statusUpdate#" EQ "Cancel">
        <cfset tseditable = "Y">
        <cfset timestatus = "Cancelled">
        <cfset cancelrequest = "N">
    <cfelseif "#url.statusUpdate#" EQ "RejectCancellation">
        <cfset tseditable = "N">
        <cfset timestatus = "Approved">
        <cfset cancelrequest = "N">
    <cfelse>
        <cfset tseditable = "Y">
        <cfset timestatus = "Rejected">
        <cfset cancelrequest = "N">
    </cfif>
            
    <cfset pno = "#ListGetAt(url.updateDetails, 1, '-')#">
    <cfset tsmonth = "#ListGetAt(url.updateDetails, 2, '-')#">
    <cfset tsyear = "#ListGetAt(url.updateDetails, 3, '-')#">
        
    <!---Update timesheet day by day--->
    <cfquery name="getts" datasource="#dts#">
        SELECT placementno, pdate FROM timesheet where placementno = "#pno#" and tmonth = "#tsmonth#" and tyear = "#tsyear#"
    </cfquery>

    <cfloop query="getts">
        <cfquery name="updateTS" datasource="#dts#">
            UPDATE timesheet SET
            updated_on = now(),
            updated_by = "#HUserID#",
            MGMTREMARKS = "#url.mgmtremarks#",
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#timestatus#">,
            editable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tseditable#">,
            cancel_req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cancelrequest#">
            WHERE placementno = "#getts.placementno#"
            AND pdate = "#DateFormat(getts.pdate, 'yyyy-mm-dd')#"
        </cfquery>
    </cfloop>

    <!---Update range in one go--->
    <!---<cfquery name="updateTS" datasource="#dts#">
        UPDATE timesheet SET
        updated_on = now(),
        updated_by = "#HUserID#",
        MGMTREMARKS = "#url.mgmtremarks#",
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#timestatus#">,
        editable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tseditable#">
        WHERE placementno = "#pno#"
        AND tmonth = "#tsmonth#"
        AND tyear = "#tsyear#"
    </cfquery>--->

    <cfset emailNotification("#dts#", "#pno#", "#tsmonth#", "#tsyear#")>
        
    <cfoutput>
        <script>
            alert("Timesheet #timestatus#!");
            window.open('/approval2/TimesheetApprovalMain.cfm', '_self');
        </script>
    </cfoutput>
</cfif>

<cffunction name="emailNotification">
	<cfargument name="dts" required="true">
	<cfargument name="pno" required="true">
	<cfargument name="tsmonth" required="true">
	<cfargument name="tsyear" required="true">
    
    <cfset dts_i = "#Replace(dts, '_p', '_i')#">
	
    <cfquery name="getemail" datasource="#dts_i#">
        SELECT * FROM notisetting
    </cfquery>

    <cfset template = getemail.template2>
    <cfset header = getemail.header2>
    <cfset template2 = getemail.template3>
    <cfset header2 = getemail.header3>

    <cfquery name="getdata" datasource="#dts#">
        SELECT a.status, a.mgmtremarks, a.status, a.empno, b.name, CASE WHEN b.workemail = "" THEN b.email ELSE b.workemail END AS validemail,
        c.mppicemail, c.mppicemail2, c.mppicspemail
        FROM timesheet a 
        LEFT JOIN pmast b ON a.empno = b.empno 
        LEFT JOIN #dts_i#.placement c ON a.placementno = c.placementno
        WHERE tmonth = '#tsmonth#' AND a.placementno = '#pno#'
    </cfquery>

    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">

    <cfset templatelist2 = "&empno&, &name&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #ucase(HComID)#">

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

    <cfif #getemail.setting2# eq 'Y'>
        <cfif getdata.validemail neq "">
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.validemail)#" subject="#header#" type="html"
                    bcc="alvin.hen@manpower.com.my"><!---,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my --->
                <html>#template#</html>
            </cfmail>
        </cfif>
    </cfif>

    <cfif #getemail.setting3# eq 'Y'>
        <cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" type="html" bcc="alvin.hen@manpower.com.my"> <!---,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my --->
                <html>#template2#</html>
            </cfmail> 
        </cfif>
    </cfif>    
    
</cffunction>

