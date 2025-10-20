<cfif isdefined('form.leaveid') eq false>
    <script type="text/javascript">
    alert('Please Kindly Select At Least One Leave');
    </script>
    <cfabort>
</cfif>

<cfoutput>
<cfquery name="default_mail_qry" datasource="payroll_main">
	select notif_email,default_email,emailserver,emailaccount,emailpassword,emailport,ELEAVEEMAIL,ELEAVEAPEMAIL,myear from gsetup where comp_id = "#HcomID#"
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
    <cfset emailssl = "no">
    <cfset emailtls = "no">
</cfif>


<cfquery name="getdate" datasource="#dts_main#">
    SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
    
    
<cfloop list="#form.leaveid#" index="a">
    
    <cfquery name="sum_LVE_DAY" datasource="#dts#">
        SELECT sum(coalesce(LVE_DAY,0)) as sum_taken,lve_type,empno
        from pleave WHERE year(lve_date) = "#default_mail_qry.myear#"
        GROUP BY empno,lve_type
    </cfquery>

    <cfset url.remarks = "">
    <cfset url.leaveid = a>
    
    <cfset finalapprove = 0>
    <cfset status = "">
    
    <cfquery name="checkcancellve" datasource="#dts#">
        SELECT leaveid FROM pleave WHERE leaveid = '#url.leaveid#'
    </cfquery>
    
    <cfif checkcancellve.recordcount eq 0>
        <cfif getdate.eleaveapp eq "deptonly" or getdate.eleaveapp eq "adminonly">
            <cfquery name="approve_leave" datasource="#dts#">
            UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#", final_changesDate = now() WHERE leaveid = #url.leaveid#
            </cfquery>
            <cfset finalapprove = 1>
            
        <cfelseif getdate.eleaveapp eq "deptadmin">
            <cfquery name="getcurrentstatus" datasource="#dts#">
            SELECT status FROM leave_apl WHERE leaveid = #url.leaveid#  order by datestart desc
            </cfquery>
            
            <cfif getcurrentstatus.status eq "In PROGRESS">
                <cfquery name="approve_leave" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#", final_changesDate = now() WHERE leaveid = #url.leaveid#
                </cfquery>
                <cfset finalapprove = 1>
            <cfelse>
                <cfquery name="approve_leave" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "IN PROGRESS",process_by = "#HUserName#", management_remarks = "#url.remarks#", changesDate = now() WHERE leaveid = #url.leaveid#	
                </cfquery>
                <cfinclude template="informadmin.cfm">
            </cfif>
            
        <cfelseif getdate.eleaveapp eq "admindept"> 
            <cfquery name="getcurrentstatus" datasource="#dts#">
            SELECT status FROM leave_apl WHERE leaveid = #url.leaveid#  order by datestart desc
            </cfquery>
            
            <cfif getcurrentstatus.status neq "In PROGRESS">
                <cfquery name="approve_leave" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "APPROVED",final_process_by = "#HUserName#", management_remarks = "#url.remarks#", final_changesDate = now() WHERE leaveid = #url.leaveid#
                </cfquery>
                <cfset finalapprove = 1>
            <cfelse>
                <cfquery name="approve_leave" datasource="#dts#">
                UPDATE LEAVE_APL SET STATUS = "WAITING DEPT APPROVED",process_by = "#HUserName#", management_remarks = "#url.remarks#", changesDate = now() WHERE leaveid = #url.leaveid#	
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

	
</cfloop>
    
    <script type="text/javascript">
	alert('Approve Success!');
	window.location.href = 'leaveMaintainance.cfm';
    </script>
 
	</cfoutput>