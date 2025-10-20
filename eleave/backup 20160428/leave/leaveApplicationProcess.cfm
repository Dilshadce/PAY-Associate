<cfoutput>
<cfset dts = replace(dsname,'_p','_i')>
<!---<cfquery name="checkcontrol" datasource="#dsname#">
    SELECT minstaff FROM dept as d LEFT JOIN pmast as p ON d.deptcode = p.deptcode LEFT JOIN emp_users ep on p.empno = ep.empno
    WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>--->

<cfset createdBY = form.createdBY >
<cfset empno = form.empno>
<cfset name = form.name>
<cfset leaveType = form.leaveType>
<cfset datefrom = form.dateFrom>
<cfset dateto = form.dateTo>
<cfset leave_option = form.leave_option>
<cfset email = form.email>
<cfset applicant_remarks = form.applicant_remarks>
<cfset mstaff = "N">
<cfset leavelist = "">
<!---<cfif checkcontrol.minstaff neq "">
    <cfquery name="emponleave" datasource="#dsname#">
        SELECT * FROM (
        SELECT lve_date,lve_date_to,lve_day FROM pleave as l 
        LEFT JOIN pmast as p ON l.empno = p.empno
        LEFT JOIN emp_users e on p.empno = e.empno
        WHERE p.deptcode = (SELECT deptcode FROM pmast WHERE empno='#empno#')
        UNION ALL
        SELECT datestart, dateend, days FROM leave_apl as l 
        LEFT JOIN pmast as p ON l.empno = p.empno
        LEFT JOIN emp_users ep on p.empno = ep.empno
        WHERE status NOT IN ("approved","declined")
        AND p.deptcode = (SELECT deptcode FROM pmast WHERE empno='#empno#')
        ) AS a ORDER BY lve_date 
    </cfquery>
    <cfif emponleave.recordcount neq 0>
        <cfloop query="emponleave">
            <cfloop from="#emponleave.lve_date#" to="#emponleave.lve_date_to#" index="i">
                <cfset leavelist = listappend(leavelist,dateformat(i,'yyyy-mm-dd'))>
            </cfloop>
        </cfloop>
    </cfif>
<!---    #leavelist#<br />
len:#listlen(leavelist)#<br />
count:#ListValueCount(leavelist,'2016-01-28')#--->

    <cfinvoke component="cfc.dateformat" method="DbDateFormat3" inputDate="#form.dateFrom#" returnvariable="cfc_fdate" />
    <cfinvoke component="cfc.dateformat" method="DbDateFormat3" inputDate="#form.dateTo#" returnvariable="cfc_tdate" />
    
    <cfloop from="0"  to="#datediff('d',cfc_fdate,cfc_tdate)#" index="i" > 
        <cfset currentdate = dateformat(dateadd('d',i,cfc_fdate),'yyyy-mm-dd')>
        <cfif ListValueCount(leavelist,currentdate) gte checkcontrol.minstaff>
            <script type="text/javascript">
                alert('Please Choose Another Date.\nStaffs On Leave Has More Than #checkcontrol.minstaff# Person.');
                history.go(-1);
                <cfset mstaff = "Y">
            </script>
            <cfbreak>
        </cfif>
    <!---    #currentdate#<br>--->
    </cfloop>
</cfif>--->

<cfif mstaff eq "N">
    <cfif form.timeTo neq "">
        <cfset form.timeto = replace(form.timeto,'.',':','all')>
        <cfset timeTo =  #TimeFormat(form.timeTo, "HH:mm")# >
    <cfelse>
        <cfset timeTo = '00:00' >
    </cfif>

    <cfif form.timeFr neq "">
    <cfset form.timeFr = replace(form.timeFr,'.',':','all')>
        <cfset timeFr = #TimeFormat(form.timeFr, "HH:mm")# >
    <cfelse>
        <cfset timeFr = '00:00' >
    </cfif>

    <cfset hours = TimeFormat(DateAdd('n', DateDiff('n', timeFr, timeTo) ,'00:00'), 'HH:mm')>
    <cfif isdefined('form.halfday') eq false>
        <cfif hours eq "00:00">
            <cfif isdefined('form.days') eq false>
            <h3>Time Format is Wrong. The format should be HH:MM.<br />Click <u><a style="cursor:pointer" onclick="history.go(-1);">here</a></u> to go back.
            </h3>
            <cfabort>
            </cfif>
            <cfset days = #val(form.days)#>
        <cfelseif hours LTE "2:00">
            <cfset days = 0.25>
        <cfelseif hours LTE "4:00">
            <cfset days = 0.5>
        <cfelseif hours LTE "6:00">
            <cfset days = 0.75>
        <cfelseif hours LTE "8:00">
            <cfset days = 1>
        </cfif>
    </cfif>

<!---    <cfquery name="select_emp_email" datasource="#DSNAME#">
    SELECT * FROM emp_users where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
    </cfquery>
    
    <cfquery name="getemaillist" datasource="payroll_main">
    select leaveapproval from gsetup where comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
    </cfquery>
    
    <cfif getemaillist.leaveapproval eq 'everyone'>
        <cfquery name="select_email" datasource="payroll_main">
        SELECT useremail,userCmpID FROM users WHERE userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> and userGrpId = "admin" and getmail = "Y"  and userEmail <> "" and userEmail is not null 
        </cfquery>
    <cfelse>
        <cfquery name="getdept" datasource="#dsname#">
        SELECT deptcode FROM pmast WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery>
        
        <cfquery name="getheaddept" datasource="#dsname#">
        SELECT headdept FROM dept WHERE deptcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdept.deptcode#">
        </cfquery>
        
        <cfquery name="select_email" datasource="#dsname#">
        SELECT useremail,userCmpID FROM payroll_main.users WHERE entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getheaddept.headdept#"> and userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> and userGrpId = "admin" and getmail = "Y"  and userEmail <> "" and userEmail is not null
        </cfquery>
    </cfif>--->

    <!---<cfquery name="default_mail_qry" datasource="payroll_main">
        select notif_email,default_email,emailserver,emailaccount,emailpassword,emailport,emailsecure from gsetup where comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
    </cfquery>	
    
    <cfif #default_mail_qry.notif_email# neq "" and #default_mail_qry.default_email# eq "Y">
        <cfset emailAddress = "#default_mail_qry.notif_email#">	
    <cfelse> 	
        <cfset emailAddress = "noreply@mynetiquette.com">	
    </cfif>	

    <cfif default_mail_qry.emailserver eq "">
        <cfset emailserver = "smtpcorp.com">
        <cfset emailaccount = "noreply@mynetiquette.com">
        <cfset emailpassword = "Netiquette168">
        <cfset emailport = "2525">
        <cfset emailssl = "no">
        <cfset emailtls = "no">
    <cfelse>
        <cfset emailserver = default_mail_qry.emailserver>
        <cfset emailaccount = default_mail_qry.emailaccount>
        <cfset emailpassword = default_mail_qry.emailpassword>
        <cfset emailport = default_mail_qry.emailport>
        <cfif default_mail_qry.emailsecure neq "">
            <cfif default_mail_qry.emailsecure eq "ssl">
                <cfset emailssl = "yes">
                <cfset emailtls = "no">
            <cfelseif default_mail_qry.emailsecure eq "tls">
                <cfset emailssl = "no">
                <cfset emailtls = "yes">
            </cfif>
        <cfelse>
            <cfset emailssl = "no">
            <cfset emailtls = "no">
        </cfif>
    </cfif>--->

   <!--- <cfif select_email.recordcount eq 0>
        <cfset toemaillist = "noreply@mynetiquette.com">
    <cfelse>
        <cfset toemaillist = ""> 
        <cfloop query="select_email">
            <cfset toemaillist = toEmailList&select_email.useremail&";">
        </cfloop>
    </cfif>

    <cfif getemaillist.leaveapproval eq 'everyone'>
        <cfquery name="select_email_cc" datasource="payroll_main">
        SELECT useremail FROM users WHERE userCmpID = "#HcomID#" and userGrpId <> "admin" and userGrpId <> "super" and getmail = "Y"  and userEmail <> "" and userEmail is not null
        </cfquery>
    <cfelse>
        <cfquery name="select_email_cc" datasource="payroll_main">
        SELECT useremail FROM users WHERE FALSE;
        </cfquery>
    </cfif>

    <cfif select_email_cc.recordcount eq 0>
        <cfset ccEmailList = "">
    <cfelse>
        <cfset ccEmailList = "">
        <cfloop query="select_email_cc">
            <cfset ccEmailList = #ccEmailList#&#select_email_cc.useremail#&";">
        </cfloop>
    </cfif>

    <cfquery name="getemailset" datasource="payroll_main">
    SELECT eleaveapp FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
    </cfquery>--->
    
    <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateFrom#" returnvariable="cfc_lfdate" />
    <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateTo#" returnvariable="cfc_ltdate" />

<!---    <cfset uploaddir = "/upload/#dsname#/leave">
    <cfset uploaddir = expandpath("#uploaddir#")> 
    <cfif directoryexists(uploaddir) eq false>
        <cfdirectory action="create" directory="#uploaddir#" >
    </cfif>--->
    <!---<cfset attachment = "">
    <cfif isdefined('form.attachfield') and form.attachfield neq "">
        <cffile action="upload" destination="#uploaddir#" nameconflict="makeunique" filefield="attachfield" >
        <cfset attachment = file.ServerFile>
    </cfif>--->

<!---    <cfquery name="insert_application" datasource="#DSNAME#">
        INSERT INTO leave_apl (empno,DateStart,DateEnd,days,leave_type,leave_option,status,applydate,timeFr,timeTo,applicant_remarks,attachment) 
        VALUES (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_lfdate#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_ltdate#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(days)#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#leaveType#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#leave_option#">,
        <cfif getemailset.eleaveapp eq "adminonly" or getemailset.eleaveapp eq "admindept">
        "IN PROGRESS"
        <cfelse>
        "WAITING DEPT APPROVED"
        </cfif>, 
        now(),
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#timeFr#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#timeTo#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#applicant_remarks#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attachment#">)
    </cfquery>--->

    <cfquery name="getcontract" datasource="#dts#">
    SELECT contract_end_d FROM placement WHERE placementno = '#form.pno#'
    </cfquery>
    
    <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#getcontract.contract_end_d#" returnvariable="cfc_condate" />

    <cfquery name="insert_application" datasource="#dts#">
    INSERT into leavelist (placementno,leavetype,days,submitted,remarks,submited_on,submit_date,startdate,enddate,
                            contractenddate,startampm,endampm,status) <!---leavebalance,timefr,timeto--->
    values
    ('#form.pno#','#leaveType#','#val(days)#','Y','#applicant_remarks#',now(),now(),'#cfc_lfdate#','#cfc_ltdate#','#cfc_condate#'
    ,'#timefr#','#timeto#','IN PROGRESS')
    </cfquery>
    
<!---    <cfif select_email.userEmail eq "">
        <cfset toemail = "noreply@mynetiquette.com" >
    <cfelse>
        <cfset toemail = select_email.userEmail>
    </cfif>--->
    
<!---    <cfif timeFr neq "00:00">
        <cfset timeFr =  #TimeFormat(form.timeFr, "hh:mm tt")# >
    </cfif>
    <cfif timeTo neq "00:00">
        <cfset timeTo =  #TimeFormat(form.timeTo, "hh:mm tt")# >
    </cfif>--->
    
<!---    <cfquery name="getemailset" datasource="payroll_main">
    SELECT eleaveapp FROM gsetup WHERE comp_id = "#HcomID#"
    </cfquery>--->

   <!--- <cfif getemailset.eleaveapp eq "adminonly" or getemailset.eleaveapp eq "admindept">
    
    <cfelse>
        <cfquery name="getdept" datasource="#DSNAME#">
        select b.headdept as headdept from pmast as a left join dept as b on a.deptcode = b.deptcode
        where a.empno = "#empno#"
        </cfquery>
    
        <cfif getdept.headdept neq "">
        <cfquery name="getemaildept" datasource="payroll_main">
        SELECT useremail FROM users WHERE entryid = "#getdept.headdept#" and userdsn = "#DSNAME#" and 
        useremail <> "" and useremail is not null
        </cfquery>
        
            <cfif getemaildept.recordcount eq 0>
            <cfelse>
                <cfif right(toemaillist,1) eq ";">
                <cfset ccemaillist = toemaillist&ccemaillist>
                <cfelse>
                <cfset ccemaillist = toemaillist&";"&ccemaillist>
                </cfif>
                <cfset toemaillist = getemaildept.useremail>
            </cfif>
        </cfif>
    </cfif>--->

   <!--- <cfinclude template="informApprover.cfm">
    
    <cfif select_emp_email.email eq "" or select_emp_email.email eq "0">
        <cfset toemail = "noreply@mynetiquette.com" >
    <cfelse>
        <cfset toemail = select_emp_email.email>
    </cfif>
    
    <cfinclude template="informEmp.cfm">--->

    <!---<cflocation url="/Eleave/leave/leaveApplicationStatus.cfm">--->
    <script type="text/javascript">
        location.href="/Eleave/beps/leavestatus.cfm";
    </script>
</cfif>
</cfoutput>