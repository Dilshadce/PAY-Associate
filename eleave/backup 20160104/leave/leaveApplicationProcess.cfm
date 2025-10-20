<cfset createdBY = form.createdBY >
<cfset empno = form.empno>
<cfset name = form.name>
<cfset leaveType = form.leaveType>
<cfset datefrom = form.dateFrom>
<cfset dateto = form.dateTo>
<cfset leave_option = form.leave_option>
<cfset email = form.email>
<cfset applicant_remarks = form.applicant_remarks>
<!--- <cfif right(form.days,2) eq ".5">
<cfif form.halfday eq "AM">
<cfset form.timeTo = "11:59">
<cfset form.timeFr = "08:00">
<cfelse>
<cfset form.timeTo = "17:00">
<cfset form.timeFr = "12:00">
</cfif>
</cfif> --->
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
    <cfoutput>
    <h3>Time Format is Wrong. The format should be HH:MM.<br />Click <u><a style="cursor:pointer" onclick="history.go(-1);">here</a></u> to go back.
</h3>
    </cfoutput>
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

<cfquery name="select_emp_email" datasource="#DSNAME#">
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
SELECT useremail,userCmpID FROM payroll_main.users WHERE entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getheaddept.headdept#"> and userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> and getmail = "Y"  and userEmail <> "" and userEmail is not null
</cfquery>
</cfif>

<cfquery name="default_mail_qry" datasource="payroll_main">
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
</cfif>

<cfif select_email.recordcount eq 0>
<cfset toemaillist = "noreply@mynetiquette.com">
<cfelse>
<cfset toemaillist = "">
<cfloop query="select_email">
<cfset toemaillist = toEmailList&select_email.useremail&";">
</cfloop>
</cfif>

<cfif getemaillist.leaveapproval eq 'everyone'>
<cfquery name="select_email_cc" datasource="payroll_main">
SELECT useremail FROM users WHERE userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> and userGrpId <> "admin" and userGrpId <> "super" and getmail = "Y"  and userEmail <> "" and userEmail is not null
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
</cfquery>


<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateFrom#" returnvariable="cfc_lfdate" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateTo#" returnvariable="cfc_ltdate" />

<cfquery name="insert_application" datasource="#DSNAME#">
	INSERT INTO leave_apl (empno,DateStart,DateEnd,days,leave_type,leave_option,status,applydate,timeFr,timeTo,applicant_remarks) VALUES ("#empno#", #cfc_lfdate#,#cfc_ltdate#, "#val(days)#", "#leaveType#", "#leave_option#",<cfif getemailset.eleaveapp eq "adminonly" or getemailset.eleaveapp eq "admindept">"IN PROGRESS"<cfelse>"WAITING DEPT APPROVED"</cfif>, now(),"#timeFr#","#timeTo#", <cfqueryparam cfsqltype="cf_sql_varchar" value="#applicant_remarks#">)
</cfquery>

<cfif select_email.userEmail eq "">
	<cfset toemail = "noreply@mynetiquette.com" >
<cfelse>
	<cfset toemail = select_email.userEmail>
</cfif>

<cfif timeFr neq "00:00">
	<cfset timeFr =  #TimeFormat(form.timeFr, "hh:mm tt")# >
</cfif>
<cfif timeTo neq "00:00">
	<cfset timeTo =  #TimeFormat(form.timeTo, "hh:mm tt")# >
</cfif>

<cfquery name="getemailset" datasource="payroll_main">
SELECT eleaveapp FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<cfif getemailset.eleaveapp eq "adminonly" or getemailset.eleaveapp eq "admindept">

<cfelse>
    <cfquery name="getdept" datasource="#DSNAME#">
    select b.headdept as headdept from pmast as a left join dept as b on a.deptcode = b.deptcode
    where a.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
    </cfquery>

	<cfif getdept.headdept neq "">
    <cfquery name="getemaildept" datasource="payroll_main">
    SELECT useremail FROM users WHERE entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdept.headdept#"> and userdsn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DSNAME#"> and 
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


</cfif>

<cfmail
	from="#emailAddress#"
	to="#toemaillist#"
    cc="#ccEmailList#"
	subject="Leave Application from #name# #empno#" type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">

<p>Dear Sir,</p>

<p>The employee with the details below would like to apply leave. The leave application details as below:</p>
<table border="1">
<tr>
<td width="100px">Empno</td>
<td width="5px">:</td>
<td width="350px">#empno#</td>
</tr>
<tr>
<td>Name</td>
<td>:</td>
<td>#name#</td>
</tr>
<tr>
<td>Leave Type</td>
<td>:</td>
<td><cfif leavetype eq "NCL">Time Off<cfelse>#leaveType#</cfif></td>
</tr>
<tr>
<td>Date Start</td>
<td>:</td>
<td>#datefrom#</td>
</tr>
<tr>
<td>Date End</td>
<td>:</td>
<td>#dateto#</td>
</tr>
<tr>
<td>Days</td>
<td>:</td>
<td>#days#</td>
</tr>
<tr>
<td>Leave Option</td>
<td>:</td>
<td>#leave_option#</td>
</tr>

<cfif timeTo neq "">
<tr>
<td>Time From </td>
<td>:</td>
<td>#timeFr#</td>
</tr>
<tr>
<td>Time To</td>
<td>:</td>
<td>#timeTo#</td>
</tr>
</cfif>

<tr>
<td>Applicant Remarks</td>
<td>:</td>
<td>#applicant_remarks#</td>
</tr>
</table>
<cfset currentURL = CGI.SERVER_NAME >
<cfif right(currentURL,4) neq "asia">
<cfset link = "http://payroll.netiquette.com.sg" >
<cfelse>
<cfset link = "http://payroll.netiquette.asia" >
</cfif>
<p>For Approval or Decline, Please Click <a href="#link#" >HERE</a> or the copy and paste the link below into your browser</p>
#link#
<p>
From: Netiquette Payroll System<br />
Company ID: #select_email.userCmpID#
</p>
<p style="font-size:smaller">This email is auto generated by system. Please do not reply to this email.</p>
</cfmail>





<cfif select_emp_email.email eq "" or select_emp_email.email eq "0">
<cfset toemail = "noreply@mynetiquette.com" >
<cfelse>
<cfset toemail = select_emp_email.email>
</cfif>
<cfmail
	from="#emailAddress#"
	to="#toemail#"
	subject="Leave Application For #name# #empno#" type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">

<p>Dear #name# ,</p>

<p>Your leave application has been sent to management level. The leave that you applied for is as detail below: </p>
<table border="1">
<tr>
<td width="100px">Empno</td>
<td width="5px">:</td>
<td width="350px">#empno#</td>
</tr>
<tr>
<td>Name</td>
<td>:</td>
<td>#name#</td>
</tr>
<tr>
<td>Leave Type</td>
<td>:</td>
<td><cfif leavetype eq "NCL">Time Off<cfelse>#leaveType#</cfif></td>
</tr>
<tr>
<td>Date Start</td>
<td>:</td>
<td>#datefrom#</td>
</tr>
<tr>
<td>Date End</td>
<td>:</td>
<td>#dateto#</td>
</tr>
<tr>
<td>Days</td>
<td>:</td>
<td>#days#</td>
</tr>
<td>Leave Option</td>
<td>:</td>
<td>#leave_option#</td>
</tr>

<cfif timeTo neq "">
<tr>
<td>Time From </td>
<td>:</td>
<td>#timeFr#</td>
</tr>
<tr>
<td>Time To</td>
<td>:</td>
<td>#timeTo#</td>
</tr>
</cfif>
<tr>
<td>Applicant Remarks</td>
<td>:</td>
<td>#applicant_remarks#</td>
</tr>
</table>
<p> If you found that the leave details are mistaken, please delete the leave applied for in the " Leave Application Status " page and notify the managerial person who is incharge for the leave.
<p>
From: Netiquette Payroll System<br />
Company ID: #select_email.userCmpID#
</p>
<p style="font-size:smaller">This email is auto generated by system. Please do not reply to this email.</p>
</cfmail>


<cflocation url="/Eleave/leave/leaveApplicationStatus.cfm">