<cfif isdefined('form.claimpriid')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT empno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.claimpriid#">
</cfquery>
<cfif getempno.empno neq get_comp.empno>
<cfabort>
</cfif>
</cfif>
<cfset dts = replace(dsname,'_p','_i')>

<cfset uploaddir = "/upload/#dsname#/">
<cfset uploaddir = expandpath("#uploaddir#")> 
<cfif directoryexists(uploaddir) eq false>
    <cfdirectory action="create" directory="#uploaddir#" >
</cfif>
<cfif isdefined('form.uploadfilefield')>
<cfset sizeLimit = 10240000 />
<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(form.uploadfilefield)) >
<cfif fileInfo.size Gt sizeLimit>
<script type="text/javascript">
alert('Receipt File Size Over 10 MB');
history.go(-1);
</script>
<cfabort>
</cfif>
	<cfif form.uploadfilefield neq "">
    <cftry>
    <cffile action="upload" destination="#uploaddir#" nameconflict="makeunique" filefield="uploadfilefield" accept="image/*,application/pdf,application/msword,application/excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" >
    <cfcatch type="any">
<script type="text/javascript">
alert('Receipt file type is INVALID! Only allow PICTURE, PDF, WORD & EXCEL documents.');
history.go(-1);
</script>
<cfabort>
</cfcatch>
</cftry>
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

<cfquery name="getdatabase" datasource="#dts#" result="result">
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
        now(), "#dateformat(form.datefrom, 'yyyy-mm-dd')#", '#cfc_condate#',"Submitted For Approval",
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

<!---<cfquery name="getid" datasource="#dsname#">
	select max(id) as id from claimlist 
</cfquery>--->
	<cfset doc = 10000+ #val(result.generatedkey)#>

<cfquery name="updatedoc" datasource="#dsname#">
    update claimlist set doc_no = "#doc#" where id = '#result.generatedkey#'
</cfquery>	

    <cfquery name="getemail" datasource="#dts#">
    SELECT * FROM notisetting
    </cfquery>

    <cfset template = getemail.template15>
    <cfset header = getemail.header15>
    
     <cfquery name="getdata" datasource="#dts#">
     SELECT * FROM claimlist a 
     LEFT JOIN placement b on a.placementno = b.placementno
     LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
     WHERE id = '#result.generatedkey#'
     </cfquery>
    
    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;claimtype&amp;,&amp;claimamount&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.claimamount#, #getdata.remarks#, #ucase(HComID)#, #getdata.mgmtremarks#, #getdata.status#">

    <cfset templatelist2 = "&empno&, &name&, &claimtype&, &remarks&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.remarks#, #ucase(HComID)#">
        
    <cfset count1 = 0>
    <cfloop list="#templatelist1#" index="i" delimiters=",">
        <cfset count1 += 1>
        <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
    </cfloop>

    <cfset count2 = 0>
    <cfloop list="#templatelist2#" index="i" delimiters=",">
        <cfset count2 += 1>
        <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
    </cfloop>
    
    <cfif getcontract.recordcount NEQ 0>
<!---    <cfmail from="#emailaccount#" to="#trim(getdata.hrmgremail)#" subject="#header#" 
    type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
    <cfif isvalid("email",trim(getdata.hrmgremail))>
      <!---   <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.hrmgremail)#" subject="#header#">
            #template#
        </cfmail> --->
    </cfif>
    </cfif>


	<cfset inform="Claim submitted successfully!">

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
    
   
	<cfset inform="Claim updated successfully!">

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
    
	<cfset inform="Claim edited successfully!">

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
    
	<cfset inform="Claim deleted successfully!">
</cfif>
<cfoutput>

<script type="text/javascript">	
	alert('#inform#');
	window.location.href="/eleave/selectjo.cfm?type=claimstatus";
</script>
</cfoutput>