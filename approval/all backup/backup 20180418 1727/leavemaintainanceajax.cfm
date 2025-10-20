<cfset datenow = #dateformat(now(), 'yyyymmdd')# >

<cfquery name="getnameall" datasource="#dts#">
SELECT empno,name,alall,aladj,albf,mcall,ccall FROM pmast
</cfquery>

<cfquery name="default_mail_qry" datasource="payroll_main">
	select notif_email,default_email,emailserver,emailaccount,emailpassword,emailport,ELEAVEEMAIL,ELEAVEAPEMAIL,myear,emailsecure from gsetup where comp_id = "#HcomID#"
</cfquery>

<cfquery name="sum_LVE_DAY" datasource="#dts#">
    SELECT sum(coalesce(LVE_DAY,0)) as sum_taken,lve_type,empno
    from pleave WHERE year(lve_date) = "#default_mail_qry.myear#"
    GROUP BY empno,lve_type
</cfquery>

<cfquery name="gs_qry" datasource="#dts#">
    SELECT * from dept 
</cfquery>

<cfquery name="getleaveset" datasource="#dts_main#">
    SELECT eleaveapp FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="gs_qry2" datasource="#dts_main#">
    SELECT cancelleave FROM gsetup2 WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getsuperid" datasource="#dts_main#">
    SELECT userGrpID FROM users WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>

<cfoutput>        
<cfif isdefined("url.type") and url.type eq "approve">
<h3>Waiting Approval Leave</h3>
        <form name="updateall" id="updateall" method="post" action="updateleave.cfm" onsubmit="return confirm('Are You Sure You Want to Approve All Selected Leave?');">
    <table border="0" width="100%">
        <tr><hr/></tr>
        <tr>
		<select name="dept1" id="dept1"
                onchange="ajaxFunction(document.getElementById('refresh1'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept1').value)+'&type=approve');">
        <option value="default">All Departments</option>
        <cfloop query="gs_qry">
                <option value="#gs_qry.deptcode#" #IIF(isdefined("url.dept") and url.dept eq gs_qry.deptcode,DE('selected'),DE(''))#>#gs_qry.deptdesp# Department</option>
		</cfloop>
        </select>
		</tr>
        <cfif gs_qry2.cancelleave eq "Y"><h5>* = Approved leave, pending for cancellation</h5></cfif>
		<tr><hr/></tr>
<cfif getleaveset.eleaveapp eq "adminonly" or getsuperid.userGrpID eq "super">
    <cfquery name="wait_leave" datasource="#dts#">
        SELECT L.* FROM LEAVE_APL L INNER JOIN PMAST P ON L.EMPNO = P.EMPNO
        WHERE (STATUS = "IN PROGRESS" or STATUS = "WAITING DEPT APPROVED")
        <cfif isdefined("url.dept") and url.dept neq "default">
        AND DEPTCODE = '#url.dept#'
        </cfif>
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
        SELECT empno FROM pmast WHERE deptcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdept.deptcode#"> order by empno
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

    <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall 
        WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
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
		
		<cfset x = val(select_name.alall) + val(select_name.aladj)  + val(select_name.albf)>
        
        <cfquery name="getleavetaken" dbtype="query">
        SELECT sum_taken FROM sum_LVE_DAY WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(select_name.empno)#"> AND UPPER(lve_type) = <cfqueryparam cfsqltype="cf_sql_varchar" value="AL">
        </cfquery>
        <cfset sum_taken_al = val(getleavetaken.sum_taken)>
        
		<cfset bal_AL = x - #val(sum_taken_al)# >
		<td>#bal_AL#</td>

        <cfquery name="getleavetaken" dbtype="query">
        SELECT sum_taken FROM sum_LVE_DAY WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(select_name.empno)#"> AND UPPER(lve_type) = <cfqueryparam cfsqltype="cf_sql_varchar" value="MC">
        </cfquery>
        <cfset sum_taken_mc = val(getleavetaken.sum_taken)>
        
		<cfset bal_MC = val(select_name.mcall) - #val(sum_taken_mc)# >
		<td>#bal_MC#</td>

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
        </cfloop>
        </table> 
        <input type="hidden" name="leave_list" id="leave_list" value="#leavelist#" /> 
        </form>   
        <form name="eform" id="eform">
			<input type="hidden" name="leave_id" id="leave_id" value="">	
		</form>   
    
<cfelseif isdefined("url.type") and url.type eq "approved">
    <h3>APPROVED LEAVE</h3>
    
        <cfquery name="wait_leave" datasource="#dts#">
            SELECT L.* FROM LEAVE_APL L INNER JOIN PMAST P ON L.EMPNO = P.EMPNO
            WHERE STATUS = "APPROVED"  
			<cfif isdefined("url.dept") and url.dept neq "default">
                AND DEPTCODE = '#url.dept#'
            </cfif>
            order by datestart desc
        </cfquery>

    <table border="0" width="100%">
        <tr><hr/></tr>
        <tr>
		<select name="dept2" id="dept2"
                onchange="ajaxFunction(document.getElementById('refresh2'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept2').value)+'&type=approved');">
        <option value="default">All Departments</option>
        <cfloop query="gs_qry">
        <option value="#gs_qry.deptcode#" #IIF(isdefined("url.dept") and url.dept eq gs_qry.deptcode,DE('selected'),DE(''))#>#gs_qry.deptdesp# Department</option>
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
        
<cfelseif isdefined("url.type") and url.type eq "reject">
	<h3>DECLINED LEAVE</h3>
    <cfquery name="wait_leave" datasource="#dts#">
        SELECT L.* FROM LEAVE_APL L INNER JOIN PMAST P ON L.EMPNO = P.EMPNO
        WHERE STATUS = "DECLINED"            
        <cfif isdefined("url.dept") and url.dept neq "default">
            AND DEPTCODE = '#url.dept#'
        </cfif>
        order by datestart desc
    </cfquery>

    <table border="0" width="100%">
        <tr><hr/></tr>
        <tr>
    	<select name="dept3" id="dept3"
                onchange="ajaxFunction(document.getElementById('refresh3'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept3').value)+'&type=reject');">
        <option value="default">All Departments</option>
        <cfloop query="gs_qry">
            <option value="#gs_qry.deptcode#" #IIF(isdefined("url.dept") and url.dept eq gs_qry.deptcode,DE('selected'),DE(''))#>#gs_qry.deptdesp# Department</option>
		</cfloop>
        </select>
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

<cfelseif isdefined("url.type") and url.type eq "expired">  
    <h3>EXPIRED LEAVE</h3>

    <cfquery name="wait_leave" datasource="#dts#">
        SELECT l.* FROM LEAVE_APL L INNER JOIN PMAST P ON L.EMPNO = P.EMPNO
        WHERE DateEnd <= "#datenow#" 
        AND status != 'WAITING DEPT APPROVED' 
        AND status != 'IN PROGRESS'
        <cfif isdefined("url.dept") and url.dept neq "default">
            AND DEPTCODE = '#url.dept#'
        </cfif> 
        order by datestart desc
    </cfquery>

    <table border="0" width="100%">
        <tr><hr/></tr>   
        <tr>     
		<select name="dept4" id="dept4"
                onchange="ajaxFunction(document.getElementById('refresh4'),
        		'leavemaintainanceajax.cfm?dept='+escape(document.getElementById('dept4').value)+'&type=expired');">
        <option value="default">All Departments</option>
        <cfloop query="gs_qry">
            <option value="#gs_qry.deptcode#" #IIF(isdefined("url.dept") and url.dept eq gs_qry.deptcode,DE('selected'),DE(''))#>#gs_qry.deptdesp# Department</option>
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
</cfif>
</cfoutput>
