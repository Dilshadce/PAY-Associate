<cfset inform="">
<cfquery name="company_details" datasource="#dts_main#">
    SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset dts2 = replace(dts,'_p','_i')>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset nodays = daysinmonth(date)>
<cfset dateto = createdate(yrs,mon,nodays)>
<cfset month1= dateformat(date,'mm')>
<cfset year1= dateformat(date,'yyyy')>

<cfoutput>

<cfif isdefined("url.type") and isdefined("url.id")>

	<!---Modified query to get the approval range(pdate), [20170110, Alvin]--->
    <cfquery name="getplacementno" datasource="#dts#">
        SELECT placementno,status FROM timesheet WHERE 
        tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#"> 
        AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.pno#">
        AND pdate 
        BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#url.first#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#url.last#">
    </cfquery>
    <!---modified--->
    
	<cfif getplacementno.status eq "Submitted For Approval" or getplacementno.status eq "Submitted For Approval 2">
        <cfquery name="gethrmgr" datasource="#dts2#">
        	SELECT hrmgr FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#">
        </cfquery>
    
        <cfif gethrmgr.hrmgr neq getHQstatus.entryid>
            <cfabort>
        </cfif>
    
    	<!---added range for approval and decline, [20170208, Alvin]--->
        <cfif url.type eq "dec">
            <cfquery name="delete_qry2" datasource="#dts#">
                UPDATE timesheet SET
                updated_on = now(), MGMTREMARKS = "#url.remarks#",
                status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Rejected">,
                editable = ''
                WHERE tmonth  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#"> 
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.pno#">
                AND pdate
                BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#url.first#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#url.last#">
            </cfquery>
		<cfelseif url.type eq "app">
            <cfquery name="approve_leave" datasource="#dts#">
                UPDATE timesheet SET
                updated_on = now(), MGMTREMARKS = "#url.remarks#",
                status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
                WHERE tmonth  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#"> 
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.pno#">
                AND pdate
                BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#url.first#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#url.last#">
            </cfquery>
		<!---added range--->
            <cfquery name="getemail" datasource="#dts2#">
            	SELECT * FROM notisetting
            </cfquery>
        
			<cfset template = getemail.template2>
            <cfset header = getemail.header2>
            <cfset template2 = getemail.template3>
            <cfset header2 = getemail.header3>
    
            <cfquery name="getdata" datasource="#dts2#">
                SELECT * FROM #dts#.timesheet a 
                LEFT JOIN placement b on a.placementno = b.placementno
                LEFT JOIN #dts#.pmast c on b.empno = c.empno 
                WHERE tmonth = '#url.id#' AND a.placementno = '#url.pno#'
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
				<cfif getdata.email neq "">
					<cfmail from="donotreply@manpower.com.my" to="#trim(getdata.email)#" subject="#header#" type="html">
						<html>#template#</html>
					</cfmail>
				</cfif>
			</cfif>
           
           	<cfif #getemail.setting3# eq 'Y'>
				<cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
					<cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" type="html">
						<html>#template2#</html>
					</cfmail> 
				</cfif>
			</cfif>

		</cfif>
    </cfif>
</cfif>

</cfoutput>

<cfoutput>
<script type="text/javascript">	
window.location.href="/approval/timesheetapprovalmain.cfm";
</script>
</cfoutput>

