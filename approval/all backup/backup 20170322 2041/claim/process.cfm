<cfset inform="">
<cfquery name="company_details" datasource="#dts_main#">
    SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset nodays = daysinmonth(date)>
<cfset dateto = createdate(yrs,mon,nodays)>
<cfset month1= dateformat(date,'mm')>
<cfset year1= dateformat(date,'yyyy')>

<cfoutput>
<cfif isdefined("form.sub_btn") and form.sub_btn eq "Save & Submit to Payroll On" >
<cfif isdefined('form.approvebox')>
<cfloop list="#form.approvebox#" index="a" >
<cfquery name="getdata" datasource="#dts#" result="updatecount">
UPDATE claimlist SET
updatedon = now(),
<cfif company_details.eclaimapp eq "adminonly" or company_details.eclaimapp eq "deptonly">
    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#">
<cfelseif company_details.eclaimapp eq "deptadmin">
    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#"> 
    AND status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval 2">
    <cfquery name="getdata2"     datasource="#dts#">
    	UPDATE claimlist SET updatedon = now(), 
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#"> 
        AND status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">
    </cfquery>
<cfelseif company_details.eclaimapp eq "admindept">
    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval 2">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#"> 
    AND status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">
    <cfquery name="getdata2" datasource="#dts#">
    	UPDATE claimlist SET updatedon = now(), 
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved">
        WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#"> 
        AND status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval 2">
    </cfquery>
</cfif>
</cfquery>
</cfloop>
    <cfif updatecount.recordcount gt 0 and company_details.claimreceived neq "turnoff"
		and (company_details.eclaimapp eq "deptadmin" or company_details.eclaimapp eq "admindept")>
		<cfinclude template="claimemail2ndlevel.cfm" />
    </cfif> 
</cfif>
  
<cfif isdefined('form.rejectbox')>
<cfloop list="#form.rejectbox#" index="b" >
<cfquery name="getdata" datasource="#dts#">
UPDATE claimlist SET
updatedon = now(),
status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Reject">
WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#b#">
</cfquery>
</cfloop>
</cfif>

<cfif isdefined('form.looprem')>
<cfloop list="#form.looprem#" index="c" >
<cfquery name="updaterem" datasource="#dts#">
    UPDATE claimlist SET
    mgmtremarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.mgmtremarks#c#')#">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#c#">
</cfquery>
</cfloop>
</cfif>

<cfquery name="getupdate" datasource="#dts#">
	SELECT c.*,pm.name,claimdes from claimlist c left join pmast pm on c.empno = pm.empno
    WHERE status in ('Approved','Reject')
</cfquery>

<cfif getupdate.recordcount gt 0 and company_details.claimreceived neq "turnoff">
	<cfinclude template="claimemail.cfm" />
</cfif>

<cfquery name="updatetopayroll" datasource="#dts#">
     update claimlist set
     status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Updated To Payroll">,
     payrollmonth = <cfqueryparam cfsqltype="cf_sql_date" value="#form.paymonth#">,
     updatedon = now()
     where status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Approved"> 
     and claim_date <= '#form.paymonth#'
</cfquery>

<cfquery name="rejectdata" datasource="#dts#">
    UPDATE claimlist SET
    updatedon = now(),
    status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Rejected">
    WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Reject">
</cfquery>

<cfquery name="getdatabase" datasource="#dts#">	
    select sum(claimamount) as total_claim,allowance,empno 
    from claimlist where status = "Updated To Payroll" and payrollmonth >= '#dateformat(date,"yyyy-mm-dd")#' and 
    payrollmonth <= '#dateformat(dateto,"yyyy-mm-dd")#' group by allowance,empno order by empno
</cfquery>	

<cfloop query="getdatabase">
<cfquery name="posupdate" datasource="#dts#">
		 update paytran set 	
		 AW#100+getdatabase.allowance# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.total_claim#">		
		 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.empno#">
</cfquery>
</cfloop>	 	
<cfset inform = "Update Payroll Success">	
</cfif>
</cfoutput>

<cfoutput>
<script type="text/javascript">	
alert ('#inform#');
window.location.href="claimlist.cfm";
</script>
</cfoutput>

