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

<cfquery name="getplacementno" datasource="#dts2#">
SELECT placementno,status FROM claimlist WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
</cfquery>

<cfif getplacementno.status eq "Submitted For Approval" or getplacementno.status eq "Submitted For Approval 2">
<cfquery name="gethrmgr" datasource="#dts2#">
SELECT hrmgr FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#">
</cfquery>

<cfif gethrmgr.hrmgr neq getHQstatus.entryid>
<cfabort>
</cfif>

	<cfif url.type eq "dec">

		<cfquery name="delete_qry2" datasource="#dts2#">
        UPDATE claimlist SET
        updated_on = now(), MGMTREMARKS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.remarks#">,
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Rejected">
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
		</cfquery>

	<cfelseif url.type eq "app">

        <cfquery name="approve_leave" datasource="#dts2#">
        UPDATE claimlist SET
        updated_on = now(), MGMTREMARKS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.remarks#">,
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
        </cfquery>

        <cfquery name="getemail" datasource="#dts2#">
        SELECT * FROM notisetting
        </cfquery>
        
        <cfset template = getemail.template16>
        <cfset header = getemail.header16>
        <cfset template2 = getemail.template17>
        <cfset header2 = getemail.header17>
        
         <cfquery name="getdata" datasource="#dts2#">
         SELECT * FROM claimlist a 
         LEFT JOIN placement b on a.placementno = b.placementno
         LEFT JOIN #dts#.pmast c on b.empno = c.empno 
         WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
         </cfquery>
        
        <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;claimtype&amp;,&amp;claimamount&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
        <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.claimamount#, #getdata.remarks#, #ucase(HComID)#, #getdata.mgmtremarks#, #getdata.status#">
    
        <cfset templatelist2 = "&empno&, &name&, &claimtype&, &remarks&, &HComID&">
        <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.remarks#, #ucase(HComID)#">
    
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
        
        <cfquery name="getempno" datasource="#dts2#">
        SELECT empno,claimtype FROM claimlist a LEFT JOIN placement b on a.placementno = b.placementno WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
        </cfquery>
        
        <cfif getempno.recordcount NEQ 0 and getdata.email neq "">
          <cfquery name="getemail" datasource="#dts#">
            SELECT username FROM emp_users WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
            </cfquery>
            
            <cftry>
            <!--- <cfmail from="donotreply@manpower.com.my" to="#trim(getemail.username)#" subject="#header#">
                #template#
            </cfmail> --->
            
        <cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
<!---         <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#">
            #template2#
        </cfmail> --->
        </cfif>
        <cfcatch type="any">
        </cfcatch>
        </cftry>
        </cfif>

	</cfif>
    </cfif>
</cfif>


<!---<cfif isdefined("form.sub_btn") and form.sub_btn eq "Save & Submit" >
<cfif isdefined('form.approvebox')>
<cfloop list="#form.approvebox#" index="a" >
<cfquery name="getdata" datasource="#dts2#" result="updatecount">
UPDATE claimlist SET
updated_on = now(),
status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#">
</cfquery>
</cfloop>
<!---    <cfif updatecount.recordcount gt 0 and company_details.claimreceived neq "turnoff"
		and (company_details.eclaimapp eq "deptadmin" or company_details.eclaimapp eq "admindept")>
		<cfinclude template="claimemail2ndlevel.cfm" />
    </cfif> --->
</cfif>
  
<cfif isdefined('form.rejectbox')>
<cfloop list="#form.rejectbox#" index="b" >
<cfquery name="getdata" datasource="#dts2#">
UPDATE claimlist SET
updated_on = now(),
status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Rejected">
WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#b#">
</cfquery>
</cfloop>
</cfif>

<cfif isdefined('form.looprem')>
<cfloop list="#form.looprem#" index="c" >
<cfquery name="updaterem" datasource="#dts2#">
    UPDATE claimlist SET
    mgmtremarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.mgmtremarks#c#')#">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#c#">
</cfquery>
</cfloop>
</cfif>

<cfquery name="getupdate" datasource="#dts2#">
	SELECT * FROM claimlist c 
    LEFT JOIN placement a on c.placementno = a.placementno 
    LEFT JOIN #dts#.pmast pm on a.empno = pm.empno
    WHERE status in ('Approved','Reject')
</cfquery>

<!---<cfif getupdate.recordcount gt 0 and company_details.claimreceived neq "turnoff">
	<cfinclude template="claimemail.cfm" />
</cfif>--->

<cfquery name="updatetopayroll" datasource="#dts2#">
     UPDATE claimlist SET
     status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Updated To Payroll">,
     updated_on = now()
     WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved"> 
<!---     AND claim_date <= '#form.paymonth#'--->
</cfquery>

<cfquery name="rejectdata" datasource="#dts2#">
    UPDATE claimlist SET
    updated_on = now(),
    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Rejected">
    WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Reject">
</cfquery>

<!---<!---<cfquery name="getdatabase" datasource="#dts2#">	
    select sum(claimamount) as total_claim,allowance,empno 
    from claimlist where status = "Updated To Payroll" and payrollmonth >= '#dateformat(date,"yyyy-mm-dd")#' and 
    payrollmonth <= '#dateformat(dateto,"yyyy-mm-dd")#' group by allowance,empno order by empno
</cfquery>--->--->	

<!---<cfloop query="getdatabase">
<cfquery name="posupdate" datasource="#dts#">
		 update paytran set 	
		 AW#100+getdatabase.allowance# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.total_claim#">		
		 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.empno#">
</cfquery>
</cfloop>	---> 	
<cfset inform = "Update Payroll Success">	
</cfif>--->
</cfoutput>

<cfoutput>
<script type="text/javascript">	
<!---alert ('#inform#');--->
window.location.href="claimapprovalmain.cfm";
</script>
</cfoutput>

