<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Leave Application Status</title>
<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<script src="/javascripts/tabber.js" type="text/javascript"></script>
</head>
<script language="javascript">
function confirmDelete(type,leaveid) {
	if(type == "del"){
        var answer = confirm("Confirm Delete?")
        if (answer){
            window.location = "/eleave/leave/leaveApplicationStatus.cfm?type="+type+ "&leaveid="+leaveid;
        }

    }else if(type =="cancel"){
        var answer = prompt("Confirm to Cancel? Please Enter Your Reason.")
        if (answer != null && answer != ''){
            window.location = "/eleave/leave/leaveApplicationStatus.cfm?type="+type+ "&leaveid="+leaveid+"&remark="+answer;
        }else if (answer == ''){
            alert("Reason is required");
        }
    }
}
</script>

<cfoutput>
<cfif isdefined("url.type") and isdefined("url.leaveid")>
	<cfif url.type eq "del" or (url.type eq "cancel" and isdefined("url.remark") and url.remark neq '')>
    
<!-- 	sent email to notified employer that employee is cancel his/her leave -->
		<cfquery name="leave_apl" datasource="#DSNAME#">
			SELECT name,a.empno,leave_Type,datestart,dateend,days,leave_option,timeFr,timeTo,applicant_remarks
			from leave_apl as a left join pmast as pm on pm.empno=a.empno where leaveID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leaveid#">
		</cfquery>
    
		<cfquery name="emp_data" datasource="#DSNAME#" >
			SELECT createdBY FROM emp_users WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
		</cfquery>
		<cfquery name="select_email_cc" datasource="payroll_main">
			SELECT useremail FROM users WHERE userName <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.createdBY#"> 
			and userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> and (userEmail <> "" or userEmail is not null)
            and getmail = "Y"
			and userGrpID = "admin"
		</cfquery>
		
		<cfset ccEmailList = "">
		<cfloop query="select_email_cc">
		<cfif find(select_email_cc.useremail,ccEmailList) eq 0 and isvalid("email",select_email_cc.useremail)>
			<cfset ccEmailList = #ccEmailList#&#select_email_cc.useremail#&";">
		</cfif>
		</cfloop>
		
		<cfquery name="select_email" datasource="payroll_main">
			SELECT userEmail,userCmpID FROM users WHERE userName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.createdBY#">  and getmail = "Y"
		</cfquery>
		
		<cfif select_email.userEmail eq "">
			<cfset toemail = "noreply@mynetiquette.com" >
		<cfelse>
			<cfset toemail = select_email.userEmail>
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
        
        <cfif url.type eq "del">
		<cfmail
			from="#emailAddress#"
			to="#toemail#"
		    cc="#ccEmailList#"
			subject="Leave Cancelation from #leave_apl.name# #leave_apl.empno#" type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">
		
			<p>Dear Sir,</p>
			
			<p>The employee with the details below has cancelled his leave application.</p>
			<table border="1">
			<tr>
			<td width="100px">Empno</td>
			<td width="5px">:</td>
			<td width="300px">#leave_apl.empno#</td>
			</tr>
			<tr>
			<td>Name</td>
			<td>:</td>
			<td>#leave_apl.name#</td>
			</tr>
			<tr>
			<td>Leave Type</td>
			<td>:</td>
			<td>#leave_apl.leave_Type#</td>
			</tr>
			<tr>
			<td>Date Start</td>
			<td>:</td>
			<td>#dateformat(leave_apl.dateStart,'dd-mm-yyyy')#</td>
			</tr>
			<tr>
			<td>Date End</td>
			<td>:</td>
			<td>#dateformat(leave_apl.dateEnd,'dd-mm-yyyy')#</td>
			</tr>
			<tr>
			<td>Days</td>
			<td>:</td>
			<td>#leave_apl.days#</td>
			</tr>
			<tr>
			<td>Leave Option</td>
			<td>:</td>
			<td>#leave_apl.leave_option#</td>
			</tr>
			
			<cfif leave_apl.timeTo neq "">
			<tr>
			<td>Time From </td>
			<td>:</td>
			<td>#timeformat(leave_apl.timeFr,'HH:MM tt')#</td>
			</tr>
			<tr>
			<td>Time To</td>
			<td>:</td>
			<td>#timeformat(leave_apl.timeTo,'HH:MM tt')#</td>
			</tr>
			</cfif>
			
			<tr>
			<td>Applicant Remarks</td>
			<td>:</td>
			<td>#leave_apl.applicant_remarks#</td>
			</tr>
			</table>
			
			From: Netiquette Payroll System<br />
			Company ID: #HcomID#
			</p>
			<p style="font-size:smaller">This email is auto generated by system. Please do not reply to this email.</p>
			</cfmail>
            
			<cfquery name="getatt" datasource="#DSNAME#">
				SELECT attachment FROM LEAVE_APL WHERE leaveid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leaveid#">
			</cfquery>
            			
			<cfquery name="delete_leave" datasource="#DSNAME#">
				DELETE FROM LEAVE_APL WHERE leaveid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leaveid#">
			</cfquery>
            
            <cftry>
                <cfset uploaddir = "/upload/#dsname#/leave/#getatt.attachment#">
                <cfset uploaddir = expandpath(uploaddir)>	
                <cffile action = "delete" file = "#uploaddir#">
            <cfcatch type="any">
            </cfcatch>
            </cftry>
            
        <cfelseif url.type eq "cancel">
		<cfmail
			from="#emailAddress#"
			to="#toemail#"
		    cc="#ccEmailList#"
			subject="Leave Cancelation from #leave_apl.name# #leave_apl.empno#" type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">
			<p>Dear Sir,</p>
			
			<p>The employee with the details below has requested to cancel approved leave.</p>
			<table border="1">
			<tr>
			<td width="100px">Empno</td>
			<td width="5px">:</td>
			<td width="300px">#leave_apl.empno#</td>
			</tr>
			<tr>
			<td>Name</td>
			<td>:</td>
			<td>#leave_apl.name#</td>
			</tr>
			<tr>
			<td>Leave Type</td>
			<td>:</td>
			<td>#leave_apl.leave_Type#</td>
			</tr>
			<tr>
			<td>Date Start</td>
			<td>:</td>
			<td>#dateformat(leave_apl.dateStart,'dd-mm-yyyy')#</td>
			</tr>
			<tr>
			<td>Date End</td>
			<td>:</td>
			<td>#dateformat(leave_apl.dateEnd,'dd-mm-yyyy')#</td>
			</tr>
			<tr>
			<td>Days</td>
			<td>:</td>
			<td>#leave_apl.days#</td>
			</tr>
			<tr>
			<td>Leave Option</td>
			<td>:</td>
			<td>#leave_apl.leave_option#</td>
			</tr>
			
			<cfif leave_apl.timeTo neq "">
			<tr>
			<td>Time From </td>
			<td>:</td>
			<td>#timeformat(leave_apl.timeFr,'HH:MM tt')#</td>

			</tr>
			<tr>
			<td>Time To</td>
			<td>:</td>
			<td>#timeformat(leave_apl.timeTo,'HH:MM tt')#</td>
			</tr>
			</cfif>
			
			<tr>
			<td>Applicant Remarks</td>
			<td>:</td>
			<td>* #url.remark#</td>
			</tr>
			</table>
			
			From: Netiquette Payroll System<br />
			Company ID: #HcomID#
			</p>
			<p style="font-size:smaller">This email is auto generated by system. Please do not reply to this email.</p>
			</cfmail>
            
            <cfquery name="gs_qry" datasource="payroll_main">
            SELECT eleaveapp from gsetup WHERE comp_id = '#HComID#'
            </cfquery>
            
			<cfquery name="uptleave" datasource="#DSNAME#">
                UPDATE leave_apl set status = 
                <cfif gs_qry.eleaveapp eq "adminonly" or gs_qry.eleaveapp eq "admindept">"IN PROGRESS"
                <cfelse>"WAITING DEPT APPROVED"</cfif>, 
                applicant_remarks = '* #url.remark#'
                WHERE leaveid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leaveid#">
			</cfquery>
        
        </cfif>
	</cfif>
</cfif>
<body>

<cfquery name="emp_data" datasource="#DSNAME#">
SELECT * FROM Emp_users where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<!---  calculate balance leave   --->     
<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="leave_data" datasource="#DSNAME#">
SELECT * FROM emp_users as pm LEFT JOIN pay_ytd as p ON pm.empno = p.empno WHERE pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>
<cfquery name="leave_data2" datasource="#DSNAME#">
SELECT * FROM pleave as p left join emp_users as pm on p.empno= pm.empno where pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>

<cfset today="#dateformat(now(),'MM')#">
<cfset leave_date="#dateformat(leave_data2.LVE_DATE,'MM')#">
<cfset tLVE_DAY_a = 0>
<cfset tLVE_DAY_b = 0>
<cfset tLVE_DAY_MC_a = 0>
<cfset tLVE_DAY_MC_b = 0>
<cfset tLVE_DAY_CC_a = 0>
<cfset tLVE_DAY_CC_b = 0>


<!--- start AL --->
<cfloop query="leave_data2">
	<cfif #leave_date# lte #today# AND leave_data2.LVE_TYPE eq "AL">  
	<cfset tLVE_DAY_a= tLVE_DAY_a + val(leave_data2.LVE_DAY)>
</cfif>

<cfif #leave_date# gt #today# AND leave_data2.LVE_TYPE eq "AL">  
<cfset tLVE_DAY_b= tLVE_DAY_b + val(leave_data2.LVE_DAY)>
</cfif>
</cfloop>
		<cfquery name="gsetup_qry" datasource="payroll_main">
			SELECT COMP_NAME,c_ale FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
		</cfquery>
		 
<cfset x =  val(emp_data.alall) + val(emp_data.albf)+ val(emp_data.aladj)>
		
<cfif leave_data.AL gte #tLVE_DAY_a# >
	<cfset bal_AL = x-(val(leave_data.AL)+val(tLVE_DAY_b)) >
<cfelse>
	<cfset bal_AL = x-(val(tLVE_DAY_a)+val(tLVE_DAY_b))>
</cfif>

<!--- start MC --->

<cfloop query="leave_data2">
<cfif #leave_date# lte #today# AND leave_data2.LVE_TYPE eq "MC">  
<cfset tLVE_DAY_MC_a= tLVE_DAY_MC_a + val(leave_data2.LVE_DAY)>
</cfif>

<cfif #leave_date# gt #today# AND leave_data2.LVE_TYPE eq "MC">  
<cfset tLVE_DAY_MC_b= tLVE_DAY_MC_b + val(leave_data2.LVE_DAY)>
</cfif>
</cfloop>

<cfif leave_data.MC gte #tLVE_DAY_MC_a# >
<cfset bal_MC = val(emp_data.mcall)-(val(leave_data.MC)+val(tLVE_DAY_MC_b)) >
<cfelse>
<cfset bal_MC = val(emp_data.mcall)-(val(tLVE_DAY_MC_a)+val(tLVE_DAY_MC_b))>
</cfif>

<!--- start childcare --->

<cfloop query="leave_data2">
<cfif #leave_date# lte #today# AND leave_data2.LVE_TYPE eq "CC">  
<cfset tLVE_DAY_CC_a= tLVE_DAY_CC_a + val(leave_data2.LVE_DAY)>
</cfif>

<cfif #leave_date# gt #today# AND leave_data2.LVE_TYPE eq "CC">  
<cfset tLVE_DAY_CC_b= tLVE_DAY_CC_b + val(leave_data2.LVE_DAY)>
</cfif>
</cfloop>

<cfif leave_data.CC gte #tLVE_DAY_CC_a# >
<cfset bal_CC = val(emp_data.ccall)-(val(leave_data.CC)+val(tLVE_DAY_CC_b)) >
<cfelse>
<cfset bal_CC = val(emp_data.ccall)-(val(tLVE_DAY_CC_a)+val(tLVE_DAY_CC_b))>
</cfif>
<cfset datenow = #dateformat(now(), 'yyyymmdd')# >
<h3>Leave Application Status</h3>
<div class="tabber">
		<div class="tabbertab">
		<h3>Waiting Approval Leave</h3>
        <cfquery name="wait_leave" datasource="#DSNAME#">
        SELECT * FROM LEAVE_APL WHERE (STATUS = "IN PROGRESS" or STATUS = "WAITING DEPT APPROVED") and DateStart >= #datenow# 
		and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="3%">No.</th>
        <th width="3%">Leave ID</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="3%">Days</th>
        <th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="3%">AL Balance</th>
        <th width="3%">MC Balance</th>
        <th width="3%">CC Balance</th>
        <th width="5%">Time From</th>
        <th width="5%">Time To</th>
        <th width="8%">Status</th>
        <th width="7%">Apply Date</th>
        <th width="5%">Attachment</th>
        <th width="10%">Remarks</th>
        <th width="8%">Action</th>
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
         <td>#wait_leave.Leave_type#</td>
        <td>#wait_leave.leave_option#</td>
		<td>#bal_AL#</td>
		<td>#bal_MC#</td>
		<td>#bal_CC#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
		<td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
                <td align="center"><a href="/upload/#dsname#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
                <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td><a href="##" onclick="confirmDelete('del','#wait_leave.LeaveID#')">
			<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>
		</td>
        </tr>
        </cfloop>
        </table>     
        </div>
        
        <div class="tabbertab">
		<h3>Approved Leave</h3>
        <cfquery name="wait_leave" datasource="#DSNAME#">
        SELECT * FROM LEAVE_APL WHERE STATUS = "APPROVED" and DateEnd >= #datenow# and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
        </cfquery>
        
        <cfquery name="gs_qry2" datasource="payroll_main">
        SELECT cancelleave from gsetup2 WHERE comp_id = '#HComID#'
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="3%">No.</th>
        <th width="3%">Leave ID</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="3%">Days</th>
        <th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="5%">Time From</th>
        <th width="5%">Time To</th>
        <th width="8%">Status</th>
        <th width="7%">Apply Date</th>
        <th width="5%">Attachment</th>
        <th width="8%">Remarks</th>
        <th width="7%">Last Updated</th>
        <th width="7%">Management Remarks</th>
        <th width="5%">Action</th>
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td>#wait_leave.Leave_type#</td>
        <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
                <td align="center"><a href="/upload/#dsname#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
                <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td>#wait_leave.ChangesDate#</td>
        <td>#wait_leave.Management_remarks#</td>
        <td><cfif gs_qry2.cancelleave eq "Y"><a href="##" onclick="confirmDelete('cancel','#wait_leave.LeaveID#')">
			<img height="18px" width="18px" src="/images/delete.ICO" alt="Cancel" border="0">Cancel</a></cfif>
		</td>
        </tr>
        </cfloop>
        </table>      
        </div>
        
        <div class="tabbertab">
		<h3>Declined Leave</h3>
        <cfquery name="wait_leave" datasource="#DSNAME#">
        SELECT * FROM LEAVE_APL WHERE STATUS = "DECLINED" and DateEnd >= #datenow# and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="3%">No.</th>
        <th width="3%">Leave ID</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="3%">Days</th>
        <th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="5%">Time From</th>
        <th width="5%">Time To</th>
        <th width="8%">Status</th>
        <th width="7%">Apply Date</th>
        <th width="5%">Attachment</th>
        <th width="10%">Remarks</th>
        <th width="7%">Last Updated</th>
        <th width="8%">Management Remarks</th>
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
         <td>#wait_leave.Leave_type#</td>
         <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
                <td align="center"><a href="/upload/#dsname#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
                <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td>#wait_leave.ChangesDate#</td>
        <td>#wait_leave.Management_remarks#</td>
        </tr>
        </cfloop>
        </table>      
        </div>       
        
        
        <div class="tabbertab">
		<h3>Expired Leave</h3>
        <cfquery name="wait_leave" datasource="#DSNAME#">
        SELECT * FROM LEAVE_APL WHERE DateStart<=  #datenow# and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="3%">No.</th>
        <th width="3%">Leave ID</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="3%">Days</th>
        <th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="5%">Time From</th>
        <th width="5%">Time To</th>
        <th width="6%">Status</th>
        <th width="7%">Apply Date</th>
        <th width="5%">Attachment</th>
        <th width="8%">Remarks</th>
        <th width="7%">Last Updated</th>
        <th width="7%">Management Remarks</th>
        <th width="5%">Action</th>
        </tr>
        
        <cfloop query="wait_leave">
        <cfif #wait_leave.status# eq "APPROVED" or #wait_leave.status# eq " DECLINED">
        <cfif #wait_leave.DateEnd# lte #datenow#>
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td>#wait_leave.Leave_type#</td>
        <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
            <td align="center"><a href="/upload/#dsname#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
            <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td>#wait_leave.ChangesDate#</td>
        <td>#wait_leave.Management_remarks#</td>
        
        <td><cfif #wait_leave.status# neq "APPROVED" ><a href="##" onclick="confirmDelete('del','#wait_leave.LeaveID#')"><img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a></cfif></td>
        </tr>
        </cfif>
        
        <cfelse>
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td>#wait_leave.Leave_type#</td>
        <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
            <td align="center"><a href="/upload/#dsname#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
            <td/>
        </cfif>
        <td>#wait_leave.ChangesDate#</td>
        <td>#wait_leave.Management_remarks#</td>
        <td><a href="##" onclick="confirmDelete('del','#wait_leave.LeaveID#')"><img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a></td>
        </tr>
		</cfif>
       
        </cfloop>
        </table> 
        </div>
</div>
</body>
</cfoutput>
</html>
