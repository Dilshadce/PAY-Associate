<cfset dts = replace(dsname,'_p','_i')>

<cfset uploaddir = "/upload/#dsname#/">
<cfset uploaddir = expandpath("#uploaddir#")> 
<cfif directoryexists(uploaddir) eq false>
    <cfdirectory action="create" directory="#uploaddir#" >
</cfif>
<cfif isdefined('form.uploadfilefield')>
	<cfif form.uploadfilefield neq "">
    <cffile action="upload" destination="#uploaddir#" nameconflict="makeunique" filefield="uploadfilefield" >
    </cfif>
</cfif>

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>


<cfif isdefined("form.sub_but") and form.sub_but eq "create">	

<cfquery name="getcontract" datasource="#dts#">
SELECT contract_end_d FROM placement WHERE placementno = '#form.claimpriid#'
</cfquery>

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#getcontract.contract_end_d#" returnvariable="cfc_condate" />

<cfquery name="getdatabase" datasource="#dts#">
        INSERT INTO claimlist (placementno,claimtype,placementclaimid,claimamount,submitted,remarks,submited_on,submit_date,contractenddate,status,receipt_no
		<cfif isdefined('file.serverfile')>,receipt</cfif>)
        VALUES
        (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.claimpriid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.claimname#">,
        '',
		<cfqueryparam cfsqltype="cf_sql_double" value="#form.claimamounttxt#">,
        'N',
   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remarksinput#">,        
        now(), now(), '#cfc_condate#',"Submitted For Approval",
   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.receipt_no#">       
    	<cfif isdefined('file.serverfile')>
		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#file.serverfile#">
		</cfif>
<!---		<cfqueryparam cfsqltype="cf_sql_double" value="#form.allowance#">,--->

<!---		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.receipt_no#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="">
--->	
		<!---,<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(createdate(right(form.dateFrom,4),mid(form.dateFrom,4,2),left(form.dateFrom,2)),'YYYY-MM-DD')#">
		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_comp.empno#">--->
        )
</cfquery>

<cfquery name="getid" datasource="#dsname#">
	select max(id) as id from claimlist 
</cfquery>
	<cfset doc = 10000+ #val(getid.id)#>

<cfquery name="updatedoc" datasource="#dsname#">
    update claimlist set doc_no = "#doc#" where id = "#getid.id#"
</cfquery>	

	<cfset inform="Create success">

<cfelseif isdefined("form.sub_but") and form.sub_but eq "Submit For Approval">
    <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT pm.empno as empno,pm.name as name FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno 
        WHERE ep.username = "#HUserID#"  
    </cfquery>
    <cfquery name="checkflow" datasource="payroll_main">
    	SELECT eclaimapp from gsetup where comp_id='#HcomID#'
    </cfquery>        
	<cfquery name="getupdate" datasource="#dsname#">
		SELECT ca.claimdes, c.claimamount,remarks,updatedon FROM claimlist c left join claim ca on c.claimid =
        ca.claimid WHERE status in ('Pending Submission','open') AND empno = '#emp_data.empno#'
	</cfquery>
    
    <cfquery name="update" datasource="#dsname#" result="result">
        UPDATE claimlist SET
        <cfif checkflow.eclaimapp eq "adminonly" or checkflow.eclaimapp eq "admindept">
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">,
        <cfelseif checkflow.eclaimapp eq "deptonly" or checkflow.eclaimapp eq "deptadmin">
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval 2">,
        </cfif>
        updatedon = now()
        WHERE 
        status in (<cfqueryparam cfsqltype="cf_sql_varchar" value="Pending Submission">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="open">)
        and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
    </cfquery>
    
   
	<cfset inform="Submit success">

<cfelseif isdefined("form.sub_but") and form.sub_but eq "edit">
	<cfquery name="delfile" datasource="#dsname#">
         select receipt from claimlist where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
	</cfquery>
	<cfif isdefined('form.uploadfilefield')>
		<cfif form.uploadfilefield eq "">
            <cftry>
				<cfset uploaddir = "/upload/#dsname#/#delfile.receipt#/">
                <cfset uploaddir = expandpath(uploaddir)>	
                <cffile action = "delete" file = "#uploaddir#">
            <cfcatch type="any">
            </cfcatch>
            </cftry>
        </cfif>
	</cfif>
	<cfquery name="getedit" datasource="#dsname#">
        update claimlist set
        empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_comp.empno#">,
        claimamount = <cfqueryparam cfsqltype="cf_sql_double" value="#form.claimamounttxt#">,
        remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remarksinput#">,   
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Pending Submission">,
        claim_date = <cfqueryparam cfsqltype="cf_sql_varchar" value=
        "#dateformat(createdate(right(form.dateFrom,4),mid(form.dateFrom,4,2),left(form.dateFrom,2)),'YYYY-MM-DD')#">,
        updatedon = now() 
		<cfif isdefined('file.serverfile')>,receipt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file.serverfile#">		<cfelseif isdefined('form.uploadfilefield')>
		<cfif form.uploadfilefield eq "">,receipt = ""</cfif>
        </cfif>
        ,receipt_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#receipt_no#">
        where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
	</cfquery>
    
	<cfset inform="Edit success">

<cfelseif isdefined("url.type") and url.type eq "delete">
	<cfquery name="getfile" datasource="#dsname#">
		select receipt from claimlist where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
	</cfquery>
	<cfquery name="getdelete" datasource="#dsname#">
        delete from claimlist 
        where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
	</cfquery>
	<cftry>
	<cfset uploaddir = "/upload/#dsname#/#getfile.receipt#/">
	<cfset uploaddir = expandpath(uploaddir)>	
	<cffile 
    action = "delete"
    file = "#uploaddir#">
	<cfcatch type="any">
	</cfcatch>
	</cftry>
    
	<cfset inform="Delete success">
</cfif>
<cfoutput>

<script type="text/javascript">	
	alert('#inform#');
	window.location.href="/eleave/selectjo.cfm?type=claim";
</script>
</cfoutput>