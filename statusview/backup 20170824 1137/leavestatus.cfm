<cfoutput>
<cfset dsname = dts>
<cfset form.pno = url.pno>
<cfif isdefined('form.pno')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT empno,hrmgr FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfif getempno.hrmgr neq getHQstatus.entryid>
<cfabort>
</cfif>
</cfif>
<cfset dts = replace(dsname,'_p','_i') >
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<cfquery name="gethuserid" datasource="#dsname#">
	SELECT username FROM emp_users WHERE empno = "#getempno.empno#"
</cfquery>

<cfif #gethuserid.recordcount# neq 0>
	<cfset HUserID = "#gethuserid.username#">
</cfif>

<cfif val(company_details.mmonth) eq "13">
    <cfset company_details.mmonth = 12 >
</cfif>

<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>

<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
</cfquery>

<cfquery name="getplacementlist" datasource="#dts#">
SELECT * FROM placement WHERE placementno = '#form.pno#' and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
</cfquery>

<cfquery name="leavelist" datasource="#dts#">
Select * from iccostcode  WHERE costcode not in ('AL','CC1','HPL','MC','NPL')  order by costcode
</cfquery>

<cfif getplacementlist.recordcount eq 0>
<h3>No Active Placement Found</h3>
<cfabort>
</cfif>


       <cfquery name="getleavedetail" datasource="#dts#">
      SELECT sum(days) as days,leavetype FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> 
      AND contractenddate <= "#dateformat(getplacementlist.completedate,'YYYY-MM-DD')#"
      AND status in ('Submitted For Approval','approved','Submitted For Approval 2')
      GROUP BY leavetype
      </cfquery>
      <cfloop query="getleavedetail">
      <cfset "#getleavedetail.leavetype##getplacementlist.placementno#day" = getleavedetail.days>
      </cfloop>
      <h2>Leave Status</h2>
      <table>
      <tr>
      <td colspan="100%">
      <table width="100%">
      <tr>
      <th align="left">Name</th>
      <td>#getplacementlist.empname#</td>
      <th align="left">Customer</th>
      <td>#getplacementlist.custname#</td>
      </tr>
      <tr>
      <th align="left">IC Number</th>
      <td>#getplacementlist.nric#</td>
      <th align="left">Placement No</th>
      <td>#getplacementlist.placementno#</td>
      </tr>
      <tr>
      <th align="left">Contract Start Date</th>
      <td>#dateformat(getplacementlist.startdate,'dd/mm/yyyy')#</td>
      <th align="left">Contract End Date</th>
      <td>#dateformat(getplacementlist.completedate,'dd/mm/yyyy')#</td>
      </tr>
      </table>
      </td>
      </tr>
       <tr>
      <td colspan="100%" style="font-size:14px"><br />
Leave entitlement shown is for full contract period.  Please note that leave is earned on a pro-rate basis. <br />Leave application may be made only for leave earned.<br /><br />

</td>
      </tr>
      <tr>
      <td colspan="100%"></td>
      </tr>
      <tr>
      <th align="left">Leave Type</th>
      <th align="left">Entitlement</th>
      <cfif #getplacementlist.ALbfable# eq 'Y'>
      <th align="left">Carry Forward</th>
      <cfelse>
      <th></th>
      </cfif>
      <th align="left">Taken</th>
      <th align="left">Balance</th>
      <td></td>
      </tr>

       <cfif isdefined("AL#getplacementlist.placementno#day")>
	  <cfset altaken = val(evaluate("AL#getplacementlist.placementno#day"))>
      <cfelse>
      <cfset altaken = 0>
	  </cfif>
      <cfif altaken neq 0 or val(getplacementlist.ALdays) + val(getplacementlist.ALbfdays) neq 0>
      <tr>
      <td>Annual Leave</td>
      <td>#val(getplacementlist.ALdays)#</td>
      <cfif #getplacementlist.Albfable# eq 'Y'>
      <td>#val(getplacementlist.ALbfdays)#</td>
      <cfelse>
      <td></td>
      </cfif>
      <td>#altaken#</td>
      <td>
	  <cfif #getplacementlist.albfable# eq 'Y'>
      	#val(getplacementlist.ALdays) + val(getplacementlist.ALbfdays)  - val(altaken)#
      <cfelse>
      	#val(getplacementlist.ALdays) - val(altaken)#
      </cfif>
	  </td>
 
      </tr>
       </cfif>
      <cfif isdefined("MC#getplacementlist.placementno#day")>
	  <cfset mctaken = val(evaluate("MC#getplacementlist.placementno#day"))>
      <cfelse>
      <cfset mctaken = 0>
	  </cfif>
      <cfif mctaken neq 0 or val(getplacementlist.MCdays) neq 0>
      <tr>
      <td>Medical Leave</td>
       <td>#val(getplacementlist.MCdays)#</td>
      
      <td></td>
      <td>#mctaken#</td>
      <td>#val(getplacementlist.MCdays) - val(mctaken)#</td>
     
      </tr> 
      </cfif>
	  <cfif isdefined("hpl#getplacementlist.placementno#day")>
	  <cfset hpltaken = val(evaluate("hpl#getplacementlist.placementno#day"))>
      <cfelse>
      <cfset hpltaken = 0>
	  </cfif>
      <cfif hpltaken neq 0 or val(getplacementlist.hpldays)> 
      <tr>
      <td>Hospitalisation</td>
      <td></td>
      
      <td></td>
      <td>#hpltaken#</td>
      <td></td>
  
      </tr>
      </cfif>
	  <cfif isdefined("cc1#getplacementlist.placementno#day")>
	  <cfset cc1taken = val(evaluate("cc1#getplacementlist.placementno#day"))>
      <cfelse>
      <cfset cc1taken = 0>
	  </cfif>
      <cfif cc1taken neq 0 or val(getplacementlist.cc1days) neq 0>
      <tr>
      <td>Childcare</td>
       <td></td>
      
      <td></td>
      <td>#cc1taken#</td>
      <td></td>
     
      </tr>
      </cfif>
	  <cfif isdefined("npl#getplacementlist.placementno#day")>
	  <cfset npltaken = val(evaluate("npl#getplacementlist.placementno#day"))>
      <cfelse>
      <cfset npltaken = 0>
	  </cfif>
      <cfif npltaken neq 0>
      <tr>
      <td>NPL</td>
      <td></td>
      <td></td>

      
      <td>#npltaken#</td>
          <td></td>
      </tr>
      </cfif>
      <cfloop query="leavelist">
      <cfif evaluate('getplacementlist.#leavelist.costcode#entitle') eq 'Y'>
      <tr>
      <td>#leavelist.Desp#</td>
      <td>#val(evaluate('getplacementlist.#leavelist.costcode#days'))#</td>
      <td></td>
      <cfif isdefined("#leavelist.costcode##getplacementlist.placementno#day")>
	  <cfset leavetaken = val(evaluate("#leavelist.costcode##getplacementlist.placementno#day"))>
      <cfelse>
      <cfset leavetaken = 0>
	  </cfif>
      <td>#leavetaken#</td>
      <td>#val(evaluate('getplacementlist.#leavelist.costcode#days'))-val(leavetaken)#</td>
    
      </tr>
	  </cfif>
      </cfloop>
      <tr>
      <td colspan="100%"></td>
      </tr>
      <tr>
      <th align="left">Leave Details</th>
      </tr>
      <tr>
      <th align="left">Leave</th>
      <th align="left">Start Date</th>
      <th align="left">End Date</th>
      <th align="left">Leave Taken</th>
      </tr>
      <cfquery name="getleavedetail" datasource="#dts#">
      SELECT * FROM (
      SELECT leavetype,days,startdate,enddate,status FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">) as a
      LEFT JOIN
      (SELECT desp,costcode from iccostcode) as b
      on a.leavetype = b.costcode
      WHERE status in ('Submitted For Approval','approved','Submitted For Approval 2')
      ORDER BY a.leavetype,a.startdate desc
      </cfquery>
      <cfloop query="getleavedetail">
      <tr>
      <td>#getleavedetail.desp#</td>
      <td>#dateformat(getleavedetail.startdate,'dd/mm/yyyy')#</td>
      <td>#dateformat(getleavedetail.enddate,'dd/mm/yyyy')#</td>
      <td>#val(getleavedetail.days)#</td>
      </tr>
      </cfloop>
   </table>



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


<cfif isdefined("url.type") and isdefined("url.leaveid")>
	<cfif url.type eq "del" or (url.type eq "cancel" and isdefined("url.remark") and url.remark neq '')>
    
    <cfelseif url.type eq "cancel">

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

<cfquery name="leave_data2" datasource="#dts#">
SELECT * FROM leavelist a
LEFT JOIN placement b on a.placementno = b.placementno
LEFT JOIN #dsname#.emp_users c on b.empno = c.empno 
WHERE c.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>

<cfset today="#dateformat(now(),'MM')#">
<!---<cfset leave_date="#dateformat(leave_data2.LVE_DATE,'MM')#">
---><cfset tLVE_DAY_a = 0>
<cfset tLVE_DAY_b = 0>
<cfset tLVE_DAY_MC_a = 0>
<cfset tLVE_DAY_MC_b = 0>
<cfset tLVE_DAY_CC_a = 0>
<cfset tLVE_DAY_CC_b = 0>

<cfset datenow = #dateformat(now(), 'yyyymmdd')# >

<h3>Leave Application Status</h3>
<div class="tabber">
		<div class="tabbertab">
		<h3>Waiting Approval Leave</h3>
        <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM leavelist a
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE (STATUS = "IN PROGRESS" or STATUS = "WAITING DEPT APPROVED") 
		and b.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
<!---        <th width="20%">Employee</th>--->
        <th width="10%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
		<th width="7%">Status</th>
        <th width="5%">Apply Date</th>
<!---        <th width="3%">Attachment</th>        --->
        <th width="8%">Remarks</th>
        <th width="8%">Management Remarks</th>
<!---        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;</th>--->
        <th width="8%">Last Update</th>
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
<!---        <td>#wait_leave.empno# | #select_name.name#</td>--->
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <td>#wait_leave.updated_on#</td>
        </tr>
        </cfloop>
        </table>     
        </div>
        
        <div class="tabbertab">
		<h3>Approved Leave</h3>
        <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM leavelist a
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE STATUS = "APPROVED" and enddate >= #datenow# and b.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
        </cfquery>

        <table class="form" border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
<!---        <th width="20%">Employee</th>--->
        <th width="10%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
		<th width="7%">Status</th>
        <th width="5%">Apply Date</th>
<!---        <th width="3%">Attachment</th>        --->
        <th width="8%">Remarks</th>
        <th width="8%">Management Remarks</th>
        <th width="8%">Last Update</th>
<!---        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;</th>--->
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
         <td>#wait_leave.currentrow#</td>
<!---        <td>#wait_leave.empno# | #select_name.name#</td>--->
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <td>#wait_leave.updated_on#</td>
        </tr>
        </cfloop>
        </table>      
        </div>
        
        <div class="tabbertab">
		<h3>Declined Leave</h3>
        <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM leavelist a
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE STATUS = "DECLINED" and enddate >= #datenow# and b.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
<!---        <th width="20%">Employee</th>--->
        <th width="10%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
		<th width="7%">Status</th>
        <th width="5%">Apply Date</th>
<!---        <th width="3%">Attachment</th>        --->
        <th width="8%">Remarks</th>
        <th width="8%">Management Remarks</th>
        <th width="8%">Last Update</th>
<!---        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;</th>--->
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
         <td>#wait_leave.currentrow#</td>
<!---        <td>#wait_leave.empno# | #select_name.name#</td>--->
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <td>#wait_leave.updated_on#</td>
        </tr>
        </cfloop>
        </table>      
        </div>       
        
        
        <div class="tabbertab">
		<h3>Expired Leave</h3>
        <cfquery name="wait_leave" datasource="#dts#">
        SELECT * FROM leavelist a
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE a.startdate<=  #datenow# and b.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        </cfquery>
        
        <table class="form" border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
<!---        <th width="20%">Employee</th>--->
        <th width="10%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
		<th width="7%">Status</th>
        <th width="5%">Apply Date</th>
<!---        <th width="3%">Attachment</th>        --->
        <th width="8%">Remarks</th>
        <th width="8%">Management Remarks</th>
        <th width="8%">Last Update</th>
<!---        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;</th>--->
        </tr>
        
        <cfloop query="wait_leave">
        <cfif #wait_leave.status# eq "APPROVED" or #wait_leave.status# eq " DECLINED">
        <cfif #wait_leave.enddate# lte #datenow#>
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
         <td>#wait_leave.currentrow#</td>
<!---        <td>#wait_leave.empno# | #select_name.name#</td>--->
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <td>#wait_leave.updated_on#</td>
        </tr>
        </cfif>
        
        <cfelse>
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
         <td>#wait_leave.currentrow#</td>
<!---        <td>#wait_leave.empno# | #select_name.name#</td>--->
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <td>#wait_leave.updated_on#</td>
        </tr>
		</cfif>
       
        </cfloop>
        </table> 
        </div>
</div>
</body>

</html>





   
</cfoutput>
