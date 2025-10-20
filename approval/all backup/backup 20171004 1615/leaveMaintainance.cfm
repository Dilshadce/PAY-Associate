<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<script src="/javascripts/tabber.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<title>Leave Approval</title>
<link rel="shortcut icon" href="/PMS.ico" /> 
<script type="text/javascript">
function checkallfield()
{
	var leaveall = document.getElementById('leave_list').value;
	var leavearray = leaveall.split(",");
	var checkid = false;
	if(document.getElementById('checkall').checked == true)
	{
	checkid = true;
	}
	else
	{
	checkid = false;
	}
	
	if(leavearray.length != 0)
	{
	for(var i = 0;i<leavearray.length;i++)
	{
	
		document.getElementById('leaveid'+leavearray[i]).checked = checkid;
	}
	}
}
</script>
<script language="javascript">
function confirmDecline(type,leaveid) {
	var answer = confirm("Confirm Decline?")
	if (answer){
		ColdFusion.Window.show('waitpage');
		var textbox_id = "management_"+leaveid;
		var remark_text = document.getElementById(textbox_id).value;		
		
		window.location = "/payments/leavemaintainance.cfm?type="+type+ "&leaveid="+leaveid+"&remarks="+remark_text;
	}
	else{
		
	}
}
function confirmDelete(type,leaveid) {
	
		var answer = confirm("Confirm Delete?")
		if (answer){
			ColdFusion.Window.show('waitpage');
			window.location = "/payments/leavemaintainance.cfm?type="+type+"&leaveid="+leaveid;
			}
		else{
			
			}
		}
		

function confirmApprove(type,leaveid) {
	var answer = confirm("Confirm Approve?")
	if (answer){
		ColdFusion.Window.show('waitpage');
		var textbox_id = "management_"+leaveid;
		var remark_text = document.getElementById(textbox_id).value;
		window.location = "/payments/leavemaintainance.cfm?type="+type+"&leaveid="+leaveid+"&remarks="+remark_text;
	}
	else{
		
	}
}

function comfirmUpdate(leaveid){

	document.getElementById('leave_id').value = leaveid;
	ColdFusion.Window.show('update_leave')
}
</script>
</head> 

<body>
<cfquery name="default_mail_qry" datasource="payroll_main">
	select notif_email,default_email,emailserver,emailaccount,emailpassword,emailport,ELEAVEEMAIL,ELEAVEAPEMAIL,myear,emailsecure from gsetup where comp_id = "#HcomID#"
</cfquery>

<cfquery name="gs_qry2" datasource="payroll_main">
    SELECT cancelleave FROM gsetup2 WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="sum_LVE_DAY" datasource="#dts#">
				SELECT sum(coalesce(LVE_DAY,0)) as sum_taken,lve_type,empno
				from pleave WHERE year(lve_date) = "#default_mail_qry.myear#"
                GROUP BY empno,lve_type
</cfquery>

<cfquery name="getnameall" datasource="#dts#">
SELECT empno,name,alall,aladj,albf,mcall,ccall FROM pmast
</cfquery>

<!---enhanced for separate emails structure [2016-01-07, by Max Tan]--->
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
	
<cfif isdefined("url.type") and isdefined("url.leaveid")>
	<cfif url.type eq "del">
        <cfquery name="checkcancellve" datasource="#dts#">
            SELECT leaveid FROM pleave WHERE leaveid = '#url.leaveid#'
        </cfquery>

        <cfquery name="decline_leave" datasource="#dts#">
        UPDATE LEAVE_APL SET STATUS = <cfif checkcancellve.recordcount eq 0>"DECLINED"<cfelse>"APPROVED"</cfif>, 
        final_process_by = "#HUserName#", management_remarks = "#url.remarks#",
        final_changesdate = now(), changesDate = now() WHERE leaveid = #url.leaveid#
        </cfquery>

        <cfquery name="select_details" datasource="#dts#">
        SELECT * FROM EMP_USERS as em LEFT JOIN LEAVE_APL as LA on em.empno = LA.empno WHERE LA.leaveid = #url.leaveid# 
        </cfquery> 
        
        <cfinclude template="informEmp.cfm">        
        
	<cfelseif url.type eq "can">
        <cfquery name="getleavedelete" datasource="#dts#">
        SELECT empno,leave_type,datestart FROM leave_apl WHERE leaveid = "#url.leaveid#"
        </cfquery>
    
        <cfquery name="leave_qry" datasource="#dts#">
		SELECT entryno FROM pleave WHERE empno='#getleavedelete.empno#' and LVE_TYPE = '#getleavedelete.Leave_type#' and 
        LVE_DATE = '#dateformat(getleavedelete.DateStart,'yyyy-mm-dd')#' ORDER BY lve_type 
		</cfquery>

		<cfquery name="delete_qry" datasource="#dts#">
		DELETE FROM pleave WHERE entryno = '#leave_qry.entryno#'
		</cfquery>
	
		<cfquery name="delete_qry2" datasource="#dts#">
		UPDATE LEAVE_APL SET STATUS = "DECLINED",final_process_by = "#HUserName#", <cfif isdefined('url.remarks')>
        management_remarks = "#url.remarks#",</cfif> final_changesdate = now(),changesDate = now() WHERE leaveid = #url.leaveid#
		</cfquery>
	
		<cfquery name="select_details" datasource="#dts#">
		SELECT * FROM EMP_USERS as em LEFT JOIN LEAVE_APL as LA on em.empno = LA.empno WHERE LA.leaveid = #url.leaveid#
		</cfquery>
	
        <cfinclude template="informCancel.cfm">
	
	<cfelseif url.type eq "app">
    
        <cfquery name="getdate" datasource="#dts_main#">
            SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
        </cfquery>
    
        <cfset finalapprove = 0>
        <cfset status = "">
        
        <cfquery name="checkcancellve" datasource="#dts#">
            SELECT leaveid FROM pleave WHERE leaveid = '#url.leaveid#'
        </cfquery>
    
        <cfif checkcancellve.recordcount eq 0>
            <cfif getdate.eleaveapp eq "deptonly" or getdate.eleaveapp eq "adminonly">
                <cfquery name="approve_leave" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#",
                final_changesDate = now() WHERE leaveid = #url.leaveid#
                </cfquery>
                <cfset finalapprove = 1>
                
            <cfelseif getdate.eleaveapp eq "deptadmin">
                <cfquery name="getcurrentstatus" datasource="#dts#">
                SELECT status FROM leave_apl WHERE leaveid = #url.leaveid#  order by datestart desc
                </cfquery>
                
                <cfif getcurrentstatus.status eq "In PROGRESS">
                    <cfquery name="approve_leave" datasource="#dts#">
                    UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#", 
                    final_changesDate = now() WHERE leaveid = #url.leaveid#
                    </cfquery>
                    <cfset finalapprove = 1>
                <cfelse>
                    <cfquery name="approve_leave" datasource="#dts#">
                    UPDATE LEAVE_APL SET STATUS = "IN PROGRESS",process_by = "#HUserName#", management_remarks = "#url.remarks#", 
                    changesDate = now() WHERE leaveid = #url.leaveid#	
                    </cfquery>
                    <cfinclude template="informadmin.cfm">
                </cfif>
                
            <cfelseif getdate.eleaveapp eq "admindept"> 
                <cfquery name="getcurrentstatus" datasource="#dts#">
                SELECT status FROM leave_apl WHERE leaveid = #url.leaveid#  order by datestart desc
                </cfquery>
                
                <cfif getcurrentstatus.status neq "In PROGRESS">
                    <cfquery name="approve_leave" datasource="#dts#">
                    UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#", 
                    final_changesDate = now() WHERE leaveid = #url.leaveid#
                    </cfquery>
                    <cfset finalapprove = 1>
                <cfelse>
                    <cfquery name="approve_leave" datasource="#dts#">
                    UPDATE LEAVE_APL SET STATUS = "WAITING DEPT APPROVED",process_by = "#HUserName#", management_remarks = "#url.remarks#", 
                    changesDate = now() WHERE leaveid = #url.leaveid#	
                    </cfquery>
                    <cfinclude template="informdept.cfm">
                </cfif>
            </cfif>
            
        <cfelse>
            <cfquery name="cancellve" datasource="#dts#">
                DELETE FROM pleave WHERE leaveid = '#url.leaveid#'
            </cfquery>    
            
            <cfquery name="cancellve" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "DECLINED", final_process_by = "#HUserName#", management_remarks = "#url.remarks#",
                final_changesDate = now() WHERE leaveid = #url.leaveid#
            </cfquery>   
            
            <cfquery name="select_details" datasource="#dts#">
        		SELECT * FROM EMP_USERS as em LEFT JOIN LEAVE_APL as LA on em.empno = LA.empno WHERE LA.leaveid = #url.leaveid# 
            </cfquery>
                  
            <cfinclude template="informCancel.cfm">
        </cfif>
    
        <cfif finalapprove eq 1>
       
            <cfset mon = #numberformat(getdate.mmonth,'00')# >
            <cfset yrs = getdate.myear>
            
            <cfquery name="getempno" datasource="#dts#">
            SELECT empno,leave_type FROM leave_apl WHERE leaveid = "#url.leaveid#"
            </cfquery>
            
            <cfif getempno.recordcount eq 0>
            <cfoutput>
            <script type="text/javascript">
            alert('Employee Record Not Found!');
            history.go(-1);
            </script>
            </cfoutput>
            <cfabort>
            </cfif>
        
            <cfquery name="select_emp" datasource="#dts#">
            SELECT * FROM (
            select sum(a.days) as days,a.leave_type,a.empno from (
                SELECT days,if(Leave_Type = 'NCL','AL',leave_type) as leave_type,empno FROM LEAVE_APL WHERE
                 empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> and substr(DateStart,1,4)='#yrs#' and 
                 substr(DateStart,6,2)='#mon#'  order by datestart desc) as a group by leave_type) as aa where 
                 aa.leave_type =     <cfif getempno.leave_type eq "NCL">
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="AL">
                                     <cfelse>
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.leave_type#">
                                     </cfif>
            </cfquery>
                
            <cfif select_emp.recordcount gt 0> 
                <cfquery name="check1sthalf" datasource="#dts#">
                SELECT #select_emp.Leave_Type# as leavec FROM paytra1 WHERE 
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> and payyes = "Y"
                </cfquery>
            
                <cfif check1sthalf.recordcount neq 0>
                    <cfif val(check1sthalf.leavec) neq 0>
                        <cfif val(select_emp.days) gt val(check1sthalf.leavec)>
                            <cfset select_emp.days = val(select_emp.days) - val(check1sthalf.leavec)>
                        </cfif>
                    </cfif>
                </cfif>

                <cfif select_emp.Leave_Type eq "TO">
                    <cfset select_emp.Leave_Type = "toff">
                </cfif>  
    
                <cfif select_emp.Leave_Type neq "NCL">
                    <cfquery name="approve_leave_paytran" datasource="#dts#">
                    UPDATE paytran SET #select_emp.Leave_Type# = "#select_emp.days#" WHERE empno = "#select_emp.empno#"
                    </cfquery>
                </cfif>
            </cfif>
	
            <cfquery name="select_details" datasource="#dts#">
            SELECT * FROM EMP_USERS as em 
            LEFT JOIN LEAVE_APL as LA 
            on (em.empno = LA.empno)
            LEFT JOIN pmast as PM 
             on (em.empno = PM.empno)
            WHERE LA.leaveid = #url.leaveid#
            </cfquery>
	
	    	<cfif #select_details.timeFr# neq "">
                <cfset timeFr = #timeformat(select_details.timeFr, "HH:mm")#>
            <cfelse>
                <cfset timeFr = '00:00'>
            </cfif>
            <cfif #select_details.timeTo# neq "">
                <cfset timeTo = #timeformat(select_details.timeTo, "HH:mm")#>
            <cfelse>
                <cfset timeTo = '00:00'>
            </cfif>
    
            <cfquery name="insert_leave_pleave" datasource="#dts#">
                Insert INTO pleave (empno,Lve_Type,lve_date,lve_date_to,lve_day,leave_option,timeFr,timeTo,leaveid) 
                values 
                ('#select_details.empno#','<cfif select_details.leave_Type eq "NCL">AL<cfelse>#select_details.leave_Type#</cfif>',
                "#dateformat(select_details.datestart,'YYYY-MM-DD')#","#dateformat(select_details.dateend,'YYYY-MM-DD')#",
                "#select_details.Days#",'#select_details.leave_option#','#timeFr#','#timeto#','#select_details.leaveid#')
            </cfquery>
            
            <cfinclude template="informEmpWithBal.cfm">

            <cfif #select_details.status# eq "APPROVED" >
            
                <cfset datenow = dateformat(now(),'yyyymmdd')>
                
                <cfquery name="getemaillist" datasource="payroll_main">
                select leavereceived from gsetup where comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
                </cfquery>
                
                <cfif getemaillist.leavereceived eq 'everyone'>
                    <cfquery name="select_email_cc" datasource="#dts#">
                    SELECT EM.EMAIL, PAYSTATUS,dresign FROM EMP_USERS AS EM 
                    LEFT JOIN PMAST AS PM ON PM.EMPNO = EM.EMPNO 
                    WHERE EM.Email <> "" and EM.Email is not null
                    AND PAYSTATUS="A" and (dresign = "0000-00-00")
                    union all
                    SELECT useremail,entryid,usercmpid FROM payroll_main.users where usercmpid="#HcomID#" and getmail ="Y";
                    </cfquery>
                <cfelse>
                    <cfquery name="getdept" datasource="#dts#">
                    SELECT deptcode FROM pmast WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_details.empno#">
                    </cfquery>
                    
                    <cfquery name="getheaddept" datasource="#dts#">
                    SELECT headdept FROM dept WHERE deptcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdept.deptcode#">
                    </cfquery>
                    
                    <cfquery name="select_email_cc" datasource="#dts#">
                    SELECT useremail as email,userCmpID,usercmpid FROM payroll_main.users 
                    WHERE entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getheaddept.headdept#"> 
                    and userCmpID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#"> 
                    and userGrpId = "ADMIN" and getmail = "Y"  and userEmail <> "" and userEmail is not null
                    </cfquery>
                </cfif>
                
                <cfset ccEmailList = "">
                <cfloop query="select_email_cc">
                <cfif find(select_email_cc.email,ccEmailList) eq 0 and isvalid("email",select_email_cc.email)>
                    <cfset ccEmailList = #ccEmailList#&#select_email_cc.email#&";">
                </cfif>
                </cfloop>
                
                <cfif timeFr neq "00:00">
                    <cfset timeFr =  #TimeFormat(timeFr, "hh:mm tt")# >
                </cfif>
                <cfif timeTo neq "00:00">
                    <cfset timeTo =  #TimeFormat(timeTo, "hh:mm tt")# >
                </cfif>	
                
                <cfif #select_details.leave_Type# eq "AL">
                   <cfset leave_desp = "( Annual Leave )">
                <cfelseif #select_details.leave_Type# eq "MC">
                   <cfset leave_desp = "( Medical Leave )">
                <cfelseif #select_details.leave_Type# eq "MT">
                   <cfset leave_desp = "( Maternity Leave )">	  
                <cfelseif #select_details.leave_Type# eq "CC">
                   <cfset leave_desp = "( ChildCare Leave )">	  
                <cfelseif #select_details.leave_Type# eq "MR">
                   <cfset leave_desp = "( Marriage Leave )">	  
                <cfelseif #select_details.leave_Type# eq "CL">
                   <cfset leave_desp = "( Compassionate Leave )">	  
                <cfelseif #select_details.leave_Type# eq "HL">
                   <cfset leave_desp = "( Hospital Leave )">	  
                <cfelseif #select_details.leave_Type# eq "EX">
                   <cfset leave_desp = "( Examination Leave )">	
                <cfelseif #select_details.leave_Type# eq "PT">
                   <cfset leave_desp = "( Paternity Leave )">	
                <cfelseif #select_details.leave_Type# eq "PH">
                   <cfset leave_desp = "( Public Holiday Leave )">	
                <cfelseif #select_details.leave_Type# eq "AD">
                   <cfset leave_desp = "( Advance Leave )">	 
                <cfelseif #select_details.leave_Type# eq "OPL">
                   <cfset leave_desp = "( Other Pay Leave )">	
                <cfelseif #select_details.leave_Type# eq "LS">
                   <cfset leave_desp = "( Line Shut Down )">	
                <cfelseif #select_details.leave_Type# eq "AB">
                   <cfset leave_desp = "( Absent )">	
                <cfelseif #select_details.leave_Type# eq "NPL">
                   <cfset leave_desp = "( No Pay Leave )">	
                <cfelseif #select_details.leave_Type# eq "RS">
                   <cfset leave_desp = "( Reservist )">	   
                <cfelseif #select_details.leave_Type# eq "ECL">
                   <cfset leave_desp = "( Extended Childcare Leave )">	 
                <cfelseif #select_details.leave_Type# eq "OIL">
                   <cfset leave_desp = "( Off In Lieu )">	    
                <cfelseif #select_details.leave_Type# eq "NCL" or #select_details.leave_Type# eq "TO" or #select_details.leave_Type# eq "TOff">
                   <cfset leave_desp = "( Time Off )">	
                <cfelse>	    
                   <cfset leave_desp = " ">	
                </cfif>  
               
               <cfif ccEmailList neq ''>
                   <cfif default_mail_qry.eleaveapemail eq 1>
                        <cfif default_mail_qry.eleaveemail neq 1 or (default_mail_qry.eleaveemail eq 1 and select_details.datestart gte now())>
                            <cfinclude template="informAll.cfm">
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
	    </cfif>
	</cfif>
    <cflocation url="/payments/leavemaintainance.cfm">    
</cfif>
<!---end--->






<h3>Leave Maintenance</h3>
<cfoutput>
<cfset datenow = #dateformat(now(), 'yyyymmdd')# >

<div class="tabber">
	<div class="tabbertab" id="refresh1">	
       
	<h3>Waiting Approval Leave</h3>
    
    <form name="updateall" id="updateall" method="post" action="updateleave.cfm" onsubmit="return confirm('Are You Sure You Want to Approve All Selected Leave?');">
    <table border="0" width="100%">
        <tr><hr/></tr>
        <tr>
        <cfquery name="gs_qry" datasource="#dts#">
        	SELECT * from dept 
        </cfquery>
		<select name="dept1" id="dept1"
                onchange="ajaxFunction(document.getElementById('refresh1'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept1').value)+'&type=approve');">

        <option value="default" >All Departments</option> 
        <cfloop query="gs_qry">
					<option value="#gs_qry.deptcode#">#gs_qry.deptdesp# Department</option>
		</cfloop>
					</select> 
        </tr>
        <cfif gs_qry2.cancelleave eq "Y"><h5>* = Approved leave, pending for cancellation</h5></cfif>
        <tr><hr/></tr>

<cfquery name="getleaveset" datasource="#dts_main#">
SELECT eleaveapp FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getsuperid" datasource="#dts_main#">
SELECT userGrpID FROM users WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>
        
<cfif getleaveset.eleaveapp eq "adminonly" or getsuperid.userGrpID eq "super">
    <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM LEAVE_APL WHERE 
        STATUS = "IN PROGRESS" 
        or STATUS = "WAITING DEPT APPROVED" 
        order by datestart desc
    </cfquery>
        
<cfelseif  getleaveset.eleaveapp eq "deptonly">
        
    <cfquery name="getdept" datasource="#dts#">
	select deptcode from dept where headdept = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HEntryID#">
	</cfquery>
        
       
   <cfquery name="getempindept" datasource="#dts#">
    SELECT empno FROM pmast WHERE 
    <cfif getdept.recordcount neq 0>
    deptcode in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#VALUELIST(getdept.deptcode)#" separator="," list="yes">)
    <cfelse>
    deptcode =  ""
    </cfif>
    </cfquery>
            
	<cfif getempindept.recordcount neq 0>
    
    <cfquery name="wait_leave" datasource="#dts#">
    SELECT * FROM LEAVE_APL WHERE 
    STATUS = "WAITING DEPT APPROVED" 
    and empno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getempindept.empno)#" list="yes" separator=",">) order by datestart  desc
    </cfquery>
    
    <cfelse>
    
    <cfquery name="wait_leave" datasource="#dts#">
    SELECT * FROM LEAVE_APL WHERE 
    STATUS = "NO" 
    order by datestart  desc
    </cfquery>      
             
    </cfif>

<cfelseif getleaveset.eleaveapp eq "deptadmin" or  getleaveset.eleaveapp eq "admindept">

<cfquery name="getdept" datasource="#dts#">
select deptcode from dept where headdept = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HEntryID#">
</cfquery>

<cfif getdept.recordcount eq 0>
        
    <cfquery name="wait_leave" datasource="#dts#">
    SELECT * FROM LEAVE_APL WHERE STATUS = "IN PROGRESS" or STATUS = "WAITING DEPT APPROVED" order by datestart desc
    </cfquery>
		
<cfelse>

    <cfquery name="getempindept" datasource="#dts#">
    SELECT empno FROM pmast WHERE
    deptcode in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#VALUELIST(getdept.deptcode)#" separator="," list="yes">)
    order by empno
    </cfquery>
    
    <cfif getempindept.recordcount neq 0>
    
    <cfquery name="wait_leave" datasource="#dts#">
    SELECT * FROM LEAVE_APL WHERE STATUS = "WAITING DEPT APPROVED" and empno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getempindept.empno)#" list="yes" separator=",">) order by datestart desc
    </cfquery>
    
    <cfelse>
    
    <cfquery name="wait_leave" datasource="#dts#">
    SELECT * FROM LEAVE_APL WHERE STATUS = "WAITING DEPT APPROVED" and empno = "" 
    order by datestart desc
    </cfquery>
    
    </cfif>

</cfif>
</cfif>
        <tr>
        <th width="2%">No.</th>
        <th width="2%">Leave ID</th>
        <th width="8%">Employee</th>
        <th width="4%">Date Start</th>
        <th width="4%">Date End</th>
        <th width="3%">Days</th>
		<th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
		<th width="2%">AL Bal.</th>
		<th width="2%">MC Bal.</th>
		<th width="2%">CC Bal.</th>
        <th width="4%">Time From</th>
        <th width="4%">Time To</th>
		<th width="9%">Status</th>
        <th width="8%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="6%">Applicant Remarks</th>
        <th width="5%">Remarks</th>
        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;<input type="checkbox" name="checkall" id="checkall" value="" onchange="checkallfield();" />&nbsp;<input type="submit" name="submit" value="Approve" /><!--- &nbsp;<input type="submit" name="submit" value="Reject" /> ---></th>
        </tr>
<cfset leavelist = "">
<cfloop query="wait_leave">
	<cfset leavelist = leavelist&wait_leave.leaveid>
    <cfif wait_leave.recordcount neq wait_leave.currentrow>
		<cfset leavelist = leavelist&",">
    </cfif>

        <!--- <cfquery name="select_name" datasource="#dts#">
        SELECT * FROM pmast 
        WHERE empno = "#wait_leave.empno#"
        </cfquery> --->
        <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>
        
	<!--- 	<cfquery name="gsetup_qry" datasource="#dts_main#">
			SELECT COMP_NAME,c_ale FROM gsetup WHERE comp_id = "#HcomID#"
		</cfquery> --->
	<!--- 	<form name="#wait_leave.LeaveID#" id="#wait_leave.LeaveID#" action="/payments/leavemaintainance.cfm" method="post"> --->
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#wait_leave.empno# | #select_name.name#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leave_type eq "NCL">Time Off<cfelse>#wait_leave.leave_Type#</cfif></td>
        <td>#wait_leave.leave_option#</td>
		
		<cfset x = val(select_name.alall) + val(select_name.aladj)  + val(select_name.albf)>
		
		<!--- <cfinvoke component="cfc.leave_balance" method="leave_taken" empno="#select_name.empno#" db="#dts#" type="AL" returnvariable="sum_taken_al" /> --->
        
        <cfquery name="getleavetaken" dbtype="query">
        SELECT sum_taken FROM sum_LVE_DAY WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(select_name.empno)#"> AND UPPER(lve_type) = <cfqueryparam cfsqltype="cf_sql_varchar" value="AL">
        </cfquery>
        <cfset sum_taken_al = val(getleavetaken.sum_taken)>
        
		<cfset bal_AL = x - #val(sum_taken_al)# >
		<td>#bal_AL#</td>
		<!--- <cfinvoke component="cfc.leave_balance" method="leave_taken" empno="#select_name.empno#" db="#dts#" type="MC" returnvariable="sum_taken_mc" /> --->
        
        <cfquery name="getleavetaken" dbtype="query">
        SELECT sum_taken FROM sum_LVE_DAY WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(select_name.empno)#"> AND UPPER(lve_type) = <cfqueryparam cfsqltype="cf_sql_varchar" value="MC">
        </cfquery>
        <cfset sum_taken_mc = val(getleavetaken.sum_taken)>
        
		<cfset bal_MC = val(select_name.mcall) - #val(sum_taken_mc)# >
		<td>#bal_MC#</td>
		<!--- <cfinvoke component="cfc.leave_balance" method="leave_taken" empno="#select_name.empno#" db="#dts#" type="CC" returnvariable="sum_taken_cc" /> --->
        <cfquery name="getleavetaken" dbtype="query">
        SELECT sum_taken FROM sum_LVE_DAY WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(select_name.empno)#"> AND UPPER(lve_type) = <cfqueryparam cfsqltype="cf_sql_varchar" value="CC">
        </cfquery>
        <cfset sum_taken_cc = val(getleavetaken.sum_taken)>
        
		<cfset bal_CC = val(select_name.ccall) - #val(sum_taken_cc)# >
		<td>#bal_CC#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
		<td>#wait_leave.status#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
                <td align="center"><a href="/upload/#dts#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
                <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td><textarea name="management_#wait_leave.LeaveID#" id="management_#wait_leave.LeaveID#" cols="10" rows="3"></textarea></td>
        <td ><table>
        <tr>
		<td><a href="##" onclick="comfirmUpdate('#wait_leave.LeaveID#')"><img height="30px" width="30px" src="/images/edit.ico" alt="Approve" border="0"><br/>Edit</a></td>	
        <td><a href="##" onclick="confirmApprove('app','#wait_leave.LeaveID#')"><img height="30px" width="30px" src="/images/1.jpg" alt="Approve" border="0"><br/>Approve</a></td>
        <td><a href="##" onclick="confirmDecline('del','#wait_leave.LeaveID#')"><img height="30px" width="30px" src="/images/2.jpg" alt="Decline" border="0"><br />Decline</a></td><td><input type="checkbox" name="leaveid" id="leaveid#wait_leave.LeaveID#" value="#wait_leave.LeaveID#" /></td>
        </tr>
        </table></td>
        </tr>
        <!--- </form> --->
        </cfloop>
        </table> 
        <input type="hidden" name="leave_list" id="leave_list" value="#leavelist#" /> 
        </form>   
        <form name="eform" id="eform">
			<input type="hidden" name="leave_id" id="leave_id" value="">	
		</form>   

    </div>

        
    <div class="tabbertab" id="refresh2">
       <!---  <form  name="#wait_leave.LeaveID#" id="#wait_leave.LeaveID#" action="/payments/updateLeave.cfm" method="post">
        ---> 
    <h3>APPROVED LEAVE</h3>
    <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM LEAVE_APL WHERE STATUS = "APPROVED"  order by datestart desc
    </cfquery>


    <table border="0" width="100%">
        <tr><hr/></tr>  
        <tr>      
		<select name="dept2" id="dept2"
                onchange="ajaxFunction(document.getElementById('refresh2'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept2').value)+'&type=approved');">
        <option value="default" >All Departments</option>
        <cfloop query="gs_qry">
            <option value="#gs_qry.deptcode#">#gs_qry.deptdesp# Department</option>
		</cfloop>
        </select>
        </tr>
        <tr><hr/></tr>        
        <tr>
        <th width="2%">No.</th>
        <th width="2%">Leave ID</th>
        <th width="11%">Employee</th>
        <th width="4%">Date Start</th>
        <th width="4%">Date End</th>
        <th width="3%">Days</th>
		<th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="4%">Time From</th>
        <th width="4%">Time To</th>
        <th width="7%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="7%">Remarks</th>
        <th width="7%">Approved Date</th>
		<th width="6%">Approved By</th>
        <th width="6%">Management Remarks</th>
        <th width="3%">Action</th>
        </tr>
        
        <cfloop query="wait_leave">
        <!--- <cfquery name="select_name" datasource="#dts#">
        SELECT * FROM pmast
        WHERE empno = "#wait_leave.empno#"
        </cfquery> --->
         <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#wait_leave.empno# | #select_name.name#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
         <td><cfif wait_leave.leave_type eq "NCL">Time Off<cfelse>#wait_leave.leave_Type#</cfif></td>
        <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
            <td align="center"><a href="/upload/#dts#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
            <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td>#wait_leave.final_ChangesDate#</td>
		<td>#wait_leave.final_process_by#</td>
        <td>#wait_leave.Management_remarks#</td>
        <td>
        <a href="##" onclick="confirmDelete('can','#wait_leave.LeaveID#')">
				<img height="30px" width="30px" src="/images/2.jpg"  alt="Delete" border="0"><br />Delete</a></td>
        </tr>
            </cfloop>
        </table>    
           <!---   </form> --->
    </div>
    
    <div class="tabbertab" id="refresh3">
    <h3>DECLINED LEAVE</h3>
        <cfquery name="wait_leave" datasource="#dts#">
        	SELECT * FROM LEAVE_APL WHERE STATUS = "DECLINED" order by datestart desc
        </cfquery>
        <cfquery name="gs_qry" datasource="#dts#">
            SELECT * from dept 
        </cfquery>

        <table border="0" width="100%">
        <tr><hr/></tr>   
        <tr>     
		<select name="dept3" id="dept3"
                onchange="ajaxFunction(document.getElementById('refresh3'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept3').value)+'&type=reject');">
        <option value="default" >All Departments</option>
        <cfloop query="gs_qry">
                <option value="#gs_qry.deptcode#">#gs_qry.deptdesp# Department</option>
		</cfloop>
        </select>
        </tr>
        <tr><hr/></tr>        
        <tr>
        <th width="2%">No.</th>
        <th width="2%">Leave ID</th>
        <th width="11%">Employee</th>
        <th width="4%">Date Start</th>
        <th width="4%">Date End</th>
        <th width="3%">Days</th>
		<th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="4%">Time From</th>
        <th width="4%">Time To</th>
        <th width="9%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="7%">Remarks</th>
        <th width="9%">Declined Date</th>
		<th width="6%">Declined By</th>
        <th width="6%">Management Remarks</th>
        </tr>
        
        
        <cfloop query="wait_leave">
	        <!--- <cfquery name="select_name" datasource="#dts#">
	        SELECT * FROM pmast
	        WHERE empno = "#wait_leave.empno#"
	        </cfquery> --->
             <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#wait_leave.empno# | #select_name.name#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td><cfif wait_leave.leave_type eq "NCL">Time Off<cfelse>#wait_leave.leave_Type#</cfif></td>
        <td>#wait_leave.leave_option#</td>
        <td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
            <td align="center"><a href="/upload/#dts#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
        <cfelse>
            <td/>
        </cfif>
        <td>#wait_leave.Applicant_remarks#</td>
        <td>#wait_leave.ChangesDate#</td>
		<td>#wait_leave.final_process_by#</td>
        <td>#wait_leave.Management_remarks#</td>
        </tr>
        </cfloop>
        </table>    
             
    </div>
    
    <div class="tabbertab" id="refresh4">
    <h3>EXPIRED LEAVE</h3>

    <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM LEAVE_APL 
        WHERE DateEnd <= "#datenow#" 
        AND status != 'WAITING DEPT APPROVED' 
        AND status != 'IN PROGRESS' 
        order by datestart desc
    </cfquery>

    <table border="0" width="100%">
        <tr><hr/></tr>  
        <tr>      
		<select name="dept4" id="dept4"
                onchange="ajaxFunction(document.getElementById('refresh4'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept4').value)+'&type=expired');">
        <option value="default" >All Departments</option>
        <cfloop query="gs_qry">
            <option value="#gs_qry.deptcode#">#gs_qry.deptdesp# department</option>
		</cfloop>
        </select>
        </tr>
        <tr><hr/></tr> 
        <tr>
        <th width="2%">No.</th>
        <th width="2%">Leave ID</th>
        <th width="11%">Employee</th>
        <th width="4%">Date Start</th>
        <th width="4%">Date End</th>
        <th width="3%">Days</th>
		<th width="3%">Leave Type</th>
        <th width="3%">Leave Option</th>
        <th width="4%">Time From</th>
        <th width="4%">Time To</th>
		<th width="9%">Status</th>
        <th width="9%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="7%">Remarks</th>
        <th width="9%">Last Updated</th>
        <th width="6%">Management Remarks</th>
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='99FF00';" onMouseOut="this.style.backgroundColor='';">
        <!--- <cfquery name="select_name" datasource="#dts#">
        SELECT * FROM pmast
        WHERE empno = "#wait_leave.empno#"
        </cfquery> --->
         <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.LeaveID#</td>
        <td>#wait_leave.empno# | #select_name.name#</td>
        <td>#dateformat(wait_leave.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.DateEnd,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td><cfif wait_leave.leave_type eq "NCL">Time Off<cfelse>#wait_leave.leave_Type#</cfif></td>
        <td>#wait_leave.leave_option#</td>
		<td>#timeformat(wait_leave.timeFr)#</td>
        <td>#timeformat(wait_leave.timeTo)#</td>
        <td>#wait_leave.status#</td>
		<td>#wait_leave.ApplyDate#</td>
        <cfif wait_leave.attachment neq "">
            <td align="center"><a href="/upload/#dts#/leave/#wait_leave.attachment#" target="_blank">View </a></td>
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
</div>

<cfwindow x="210" y="100" width="570" height="480" name="update_leave"
  		 minHeight="400" minWidth="400" 
   		 title="Update Leave" initshow="false" refreshOnShow="true"
   		 source="edit_leave_maintainace.cfm?leaveid={eform:leave_id}" />
  <cfwindow name="waitpage" title="Under Progress!" modal="true" closable="false" width="350" height="260" center="true" initShow="false" >
<p align="center">Under Process, Please Wait!</p>
<p align="center"><img src="/images/loading.gif" name="Cash Sales" width="30" height="30"></p>
<br />
</cfwindow>        
         
</cfoutput>
</body>
</html> 
