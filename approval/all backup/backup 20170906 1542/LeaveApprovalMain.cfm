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
<cfset dts2 = replace(dts,'_p','_i')>
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
	
		document.getElementById('id'+leavearray[i]).checked = checkid;
	}
	}
}
</script>
<script language="javascript">
function confirmDecline(type,id) {
	var answer = confirm("Confirm Decline?")
	if (answer){
		ColdFusion.Window.show('waitpage');
		var textbox_id = "management_"+id;
		var remark_text = document.getElementById(textbox_id).value;		
		
		window.location = "LeaveApprovalMain.cfm?type="+type+ "&id="+id+"&remarks="+remark_text;
	}
	else{
		
	}
}
function confirmDelete(type,id) {
	
		var answer = confirm("Confirm Delete?")
		if (answer){
			ColdFusion.Window.show('waitpage');
			window.location = "LeaveApprovalMain.cfm?type="+type+"&id="+id;
			}
		else{
			
			}
		}
		

function confirmApprove(type,id) {
	var answer = confirm("Confirm Approve?")
	if (answer){
		ColdFusion.Window.show('waitpage');
		var textbox_id = "management_"+id;
		var remark_text = document.getElementById(textbox_id).value;
		window.location = "LeaveApprovalMain.cfm?type="+type+"&id="+id+"&remarks="+remark_text;
	}
	else{
		
	}
}

function confirmApprove2(type,id) {
    window.location = "LeaveApproval2.cfm?id="+id;
}

function confirmApprove3(type,id) {
    window.location = "LeaveApproval3.cfm?id="+id;
	
}

function comfirmUpdate(id){

	document.getElementById('leave_id').value = id;
	ColdFusion.Window.show('update_leave')
}

function insufficientBalance() {
    alert("Insufficient leave balance!");
}

</script>
</head> 

<body>

<cfif isdefined("url.type") and isdefined("url.id")>
<cfquery name="getplacementno" datasource="#dts2#">
SELECT placementno,status FROM leavelist WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
</cfquery>

<cfif getplacementno.status eq "IN PROGRESS">
<cfquery name="gethrmgr" datasource="#dts2#">
SELECT hrmgr FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#">
</cfquery>

<cfif gethrmgr.hrmgr neq getHQstatus.entryid>
<cfabort>
</cfif>

        
	<cfif url.type eq "dec">

		<cfquery name="delete_qry2" datasource="#dts2#">
		UPDATE leavelist SET STATUS = "DECLINED",updated_by = "#HUserName#", <cfif isdefined('url.remarks')>
        mgmtremarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.remarks#">,</cfif> updated_on = now() WHERE id = #url.id#
		</cfquery>

	<cfelseif url.type eq "app">
    
        <cfquery name="getdate" datasource="#dts_main#">
            SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
        </cfquery>
    
        <cfset finalapprove = 0>
        <cfset status = "">
        
        <!---edited by alvin 20170101--->  

        <cfif val(getdate.mmonth) eq "13">
            <cfset getdate.mmonth = 12 >
        </cfif>
        
        <cfset currentdate = createdate(val(getdate.myear),val(getdate.mmonth),1)>
        
        <cfquery name="getlistplacement" datasource="#dts2#">
       		SELECT * 
            FROM placement 
            WHERE placementno = "#getplacementno.placementno#" 
            <!---and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" 
            and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"--->
        </cfquery>
        
        <cfquery name="getleavedetail" datasource="#dts2#">
              SELECT sum(days) as days,leavetype FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getlistplacement.placementno#"> 
              AND contractenddate <= "#dateformat(getlistplacement.completedate,'YYYY-MM-DD')#"
              AND status in ('Submitted For Approval','approved','Submitted For Approval 2')
              GROUP BY leavetype
      	</cfquery>
        
        <cfquery name="getleavetype" datasource="#dts2#">
        	SELECT *
            FROM leavelist as leavelists
            LEFT join placement as placements
       		ON leavelists.placementno = placements.placementno
            WHERE leavelists.id = #url.id#
        </cfquery>
        
      	<cfloop query="getleavedetail">
      		<cfset "#getleavedetail.leavetype##getlistplacement.placementno#day" = getleavedetail.days>
      	</cfloop>
        
        <cfif isdefined("#getleavetype.leavetype##getlistplacement.placementno#day")>
		  <cfset leavetaken = val(evaluate("#getleavetype.leavetype##getlistplacement.placementno#day"))>
        <cfelse>
              <cfset leavetaken = 0>
        </cfif>
        
        <cfif #getleavetype.leavetype# eq 'AL'>
        	<cfset balance = val(evaluate('getlistplacement.#getleavetype.leavetype#days')) + val(evaluate('getlistplacement.#getleavetype.leavetype#bfdays')) - val(leavetaken)>
        <cfelse>
        	<cfset balance = val(evaluate('getlistplacement.#getleavetype.leavetype#days')) - val(leavetaken)>
        </cfif>
        
 		<!---edited---> 
        
			<cfif (#balance# - val(getleavetype.days) lt 0 AND #getleavetype.leavetype# neq 'NPL') or (#balance# lt val(getleavetype.days) AND #getleavetype.leavetype# neq 'NPL')>
            	<script>
					insufficientBalance()
				</script>
            <cfelse>
                <cfquery name="approve_leave" datasource="#dts2#">
                UPDATE leavelist SET STATUS = "APPROVED",updated_by = "#HUserName#", MGMTREMARKS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.remarks#">,
                updated_on = now() WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
                </cfquery>
                
                <cfset starthour = left(#getleavetype.startampm#, 2)&':00'>
                <cfset endhour = left(#getleavetype.endampm#, 2)&':00'>
                <cfset startminute = '00:'&right(#getleavetype.startampm#, 2)>
                <cfset endminute = '00:'&right(#getleavetype.endampm#, 2)>
                <cfset calculatedWorkhour = #datediff('h', starthour, endhour)#&'.'&#numberformat(datediff('n', startminute, endminute),'_0')#>
                
                <!---added query to add approved leave into timesheet, [20170224, Alvin]--->
                <cfquery name="updateTimesheet" datasource="#dts#">
                    UPDATE timesheet
                    SET stcol = '#getleavetype.leavetype#',
                    starttime = '#getleavetype.startampm#:00',
                    endtime = '#getleavetype.endampm#:00',
                  	<cfif (#getleavetype.startampm# eq '00:00') AND (#getleavetype.endampm# eq '00:00')>
                        ampm = 'FULL DAY',
                    <cfelseif left(#getleavetype.endampm#, 2) gt 12>
                        ampm = 'PM',
                    <cfelseif left(#getleavetype.endampm#, 2) lt 12>
                        ampm = 'AM',
                    </cfif>
                    breaktime = '0',
                    workhours = '#calculatedWorkhour#',
                    remarks = '#getleavetype.remarks#',
                    updated_on = now(),
                    updated_by = "#HUserName#",
                    mgmtremarks = "#url.remarks#",
                    othour =' 0.00',
                    ot15hour = '0.00',
                    ot2hour = '0.00',
                    ot3hour = '0.00',
                    otrd1hour = '0.00',
                    otrd2hour = '0.00',
                    otph1hour = '0.00',
                    otph2hour = '0.00',
                    ot1 = '0.00000',
                    ot2 = '0.00000',
                    ot3 = '0.00000',
                    ot4 = '0.00000',
                    ot5 = '0.00000',
                    ot6 = '0.00000',
                    ot7 = '0.00000',
                    ot8 = '0.00000'
                    WHERE pdate >= "#dateformat(getleavetype.startdate,'yyyy-mm-dd')#" AND pdate <= "#dateformat(getleavetype.enddate,'yyyy-mm-dd')#"
                    AND placementno = '#getleavetype.placementno#'
                    AND STATUS = ""
                </cfquery>
            
            <!---added approved leave--->
                
                <cfset finalapprove = 1>
            </cfif>
            
        <cfif finalapprove eq 1>
       
            <cfset mon = #numberformat(getdate.mmonth,'00')# >
            <cfset yrs = getdate.myear>
            
            <cfquery name="getemail2" datasource="#dts2#">
            SELECT * FROM notisetting
            </cfquery>
            
            <cfset template = getemail2.template9>
            <cfset header = getemail2.header9>
            <cfset template2 = getemail2.template10>
            <cfset header2 = getemail2.header10>
           
             <cfquery name="getdata" datasource="#dts2#">
             SELECT * FROM leavelist a 
             LEFT JOIN placement b on a.placementno = b.placementno
             LEFT JOIN #dts#.pmast c on b.empno = c.empno 
             WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
             </cfquery>
            
            <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;leavetype&amp;,&amp;startdate&amp;,&amp;enddate&amp;,&amp;days&amp;,&amp;startampm&amp;,&amp;endampm&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
            <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">
        
            <cfset templatelist2 = "&empno&, &name&, &leavetype&, &datestart&, &dateend&, &days&, &timefrom&, &timeto&, &remarks&, &HComID&">
            <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #ucase(HComID)#">
        
            <cfset count1 = 0>
            <cfloop list="#templatelist1#" index="i" delimiters=",">
                <cfset count1 += 1>
                <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
                <cfset template2 = replace(template2,i,listgetat(replacelist1,count1),'all')>
            </cfloop>
        
            <cfset count2 = 0>
            <cfloop list="#templatelist2#" index="i" delimiters=",">
                <cfset count2 += 1>
                <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
                <cfset header2 = replace(header2,i,listgetat(replacelist2,count2),'all')>
            </cfloop>
            
            <cfset htmlstarttag = "<html>">
            <cfset htmlendtag = "</html>">
            
            <cfquery name="getempno" datasource="#dts2#">
            SELECT empno,leavetype FROM leavelist a LEFT JOIN placement b on a.placementno = b.placementno WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
            </cfquery>
            
            <cfif getempno.recordcount NEQ 0>
            <cfquery name="getemail" datasource="#dts#">
            SELECT username FROM emp_users WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
            </cfquery>
            <cftry>
            	<cfif #getemail2.setting9# eq 'Y'>
                 <cfmail from="donotreply@manpower.com.my" to="#trim(getemail.username)#" subject="#header#" type="html">
                    #htmlstarttag#
                    #template#
                    #htmlendtag#
                </cfmail>
                </cfif>
                <cfif #getemail2.setting10# eq 'Y'> 
                 <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" type="html">
                    #htmlstarttag#
                    #template2#
                    #htmlendtag#
                </cfmail> 
                </cfif>
                <cfcatch type="any">
                </cfcatch>
                </cftry>
            </cfif>

            <cfif getempno.recordcount eq 0>
            <cfoutput>
            <script type="text/javascript">
            alert('Employee Record Not Found!');
            </script>
            </cfoutput>
            <cfabort>
            </cfif>
        
	    </cfif>
	</cfif>
 </cfif>
</cfif>

<h3>Leave Approval</h3>
<cfoutput>
<cfset datenow = #dateformat(now(), 'yyyymmdd')# >

<div class="tabber">
	<div class="tabbertab" id="refresh1">	
       
	<h3>Waiting Approval Leave</h3>
    
    <form name="updateall" id="updateall" method="post" action="LeaveApprovalProcess.cfm" onsubmit="return confirm('Are You Sure You Want to Approve All Selected Leave?');">
    <table border="0" width="100%">

<cfquery name="getleaveset" datasource="#dts_main#">
SELECT eleaveapp FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getsuperid" datasource="#dts_main#">
SELECT * FROM 
<cfif #Session.usercty# contains "test">
	hmuserstest
<cfelse>
	hmusers
</cfif> 	
WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>
        
    <cfquery name="wait_leave" datasource="#dts2#">
        SELECT * FROM leavelist a
        LEFT JOIN placement b on a.placementno = b.placementno
        WHERE (STATUS = "IN PROGRESS" 
        or STATUS = "WAITING DEPT APPROVED")
        and hrMgr = "#getHQstatus.entryid#"
        order by a.startdate
    </cfquery>

        <tr>
        <th width="2%">No.</th>
        <th width="10%">Employee</th>
        <th width="10%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
		<th width="7%">Status</th>
        <th width="5%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="8%">Applicant Remarks</th>
        <th width="8%">Remarks</th>
        <th width="6%" nowrap="nowrap">Action&nbsp;&nbsp;</th>
        </tr>
<cfset leavelist = "">

<cfloop query="wait_leave">
    <input type="text" name="leaveid" id="leaveid#wait_leave.id#" value="#wait_leave.id#" hidden>
	<cfset leavelist = leavelist&wait_leave.id>
    <cfif wait_leave.recordcount neq wait_leave.currentrow>
		<cfset leavelist = leavelist&",">
    </cfif>

        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.empname#</td>
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
		<td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
		<td>#wait_leave.status#</td>
        <td>#dateformat(wait_leave.submit_date,'yyyy-mm-dd')#</td>
        <td>
            <a href="/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#" target="_blank">
            <cfif #wait_leave.signdoc# NEQ "" AND FileExists(ExpandPath('/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#')) >View</cfif>
            </a>
        </td>
        <td>#wait_leave.remarks#</td>
        <td><textarea name="management_#wait_leave.id#" id="management_#wait_leave.id#" cols="15" rows="3"></textarea></td>
        <td >
        <table>
            <tr>
    <!---		<td><a href="##" onclick="comfirmUpdate('#wait_leave.id#')"><img height="30px" width="30px" src="/images/edit.ico" alt="Approve" border="0"><br/>Edit</a></td>	
    --->
            <cfset apptype = ''>
            <cfif getsuperid.approvaltype eq 2>        
                <cfset apptype = 2>   
            <cfelseif getsuperid.approvaltype eq 3>
                <cfset apptype = 3>
            </cfif>
            <td>
                <a href="##" onclick="confirmApprove#apptype#('app','#wait_leave.id#')"><img height="30px" width="30px" src="/images/1.png" alt="Approve" border="0"><br/>Approve</a>
            </td>
            <td>
                <a href="##" onclick="confirmDecline('dec','#wait_leave.id#')"><img height="30px" width="30px" src="/images/2.png" alt="Decline" border="0"><br />Decline</a>
            </td>
            <td><!---<input type="checkbox" name="id" id="id#wait_leave.id#" value="#wait_leave.id#" />--->
            </td>            
            </tr>
        </table>
        </td>
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
       <!---  <form  name="#wait_leave.id#" id="#wait_leave.id#" action="/payments/updateLeave.cfm" method="post">
        ---> 
    <h3>APPROVED LEAVE</h3>
    <cfquery name="wait_leave" datasource="#dts2#">
        SELECT * FROM leavelist a 
        LEFT JOIN placement b 
        ON a.placementno = b.placementno        
        WHERE STATUS = "APPROVED"  
        and enddate >= "#datenow#" 
        and hrMgr = "#getHQstatus.entryid#"
        ORDER BY a.startdate desc
    </cfquery>


    <table border="0" width="100%">
     
        <tr>
        <th width="2%">No.</th>
        <th width="10%">Employee</th>
        <th width="5%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Type</th>
        <th width="4%">Time Fr</th>
        <th width="4%">Time To</th>
        <th width="5%">Apply Date</th>
        <th width="3%">Attachment</th>
        <th width="8%">Remarks</th>
        <th width="5%">Approved Date</th>
		<th width="5%">Approved By</th>
        <th width="8%">Management Remarks</th>
     <!---    <th width="6%"><center>Approval Doc</th>
        <th width="3%">Action</th> --->
        </tr>
        
        <cfloop query="wait_leave">

<!---         <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>--->
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.empname#</td>
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
         <td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
        <td>#dateformat(wait_leave.submit_date,'dd/mm/yyyy')#</td>
        <td>
            <a href="/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#" target="_blank">
            <cfif #wait_leave.signdoc# NEQ "" AND FileExists(ExpandPath('/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#')) >View</cfif>
            </a>
        </td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.updated_on#</td>
		<td>#wait_leave.updated_by#</td>
        <td>#wait_leave.mgmtremarks#</td>
       <!---  <td align="center"> <cfif wait_leave.signdoc neq ''><a href="#wait_leave.signdoc#" target="_blank">View</a></cfif></td> --->
       <!---  <td>
        <a href="##" onclick="confirmDelete('can','#wait_leave.id#')">
				<img height="30px" width="30px" src="/images/2.png"  alt="Delete" border="0"><br />Delete</a></td> --->
        </tr>
            </cfloop>
        </table>    
           <!---   </form> --->
    </div>
    
    <div class="tabbertab" id="refresh3">
    <h3>DECLINED LEAVE</h3>
        <cfquery name="wait_leave" datasource="#dts2#">
        SELECT * FROM leavelist a 
        LEFT JOIN placement b 
        ON a.placementno = b.placementno        
        WHERE STATUS = "DECLINED"  
        and enddate >= "#datenow#" 
        and hrMgr = "#getHQstatus.entryid#"
        ORDER BY a.startdate desc
        </cfquery>

        <table border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
        <th width="10%">Employee</th>
        <th width="5%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Leave Type</th>
        <th width="5%">Time From</th>
        <th width="5%">Time To</th>
        <th width="8%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="8%">Remarks</th>
        <th width="8%">Declined Date</th>
		<th width="5%">Declined By</th>
        <th width="8%">Management Remarks</th>
        </tr>
        
        
        <cfloop query="wait_leave">
<!---             <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>--->
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.empname#</td>
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
        <td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
        <td>#dateformat(wait_leave.submit_date,'dd/mm/yyyy')#</td>
        <td>
            <a href="/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#" target="_blank">
            <cfif #wait_leave.signdoc# NEQ "" AND FileExists(ExpandPath('/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#')) >View</cfif>
            </a>
        </td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.updated_on#</td>
		<td>#wait_leave.updated_by#</td>
        <td>#wait_leave.mgmtremarks#</td>
        </tr>
        </cfloop>
        </table>    
             
    </div>
    
    <div class="tabbertab" id="refresh4">
    <h3>EXPIRED LEAVE</h3>

    <cfquery name="wait_leave" datasource="#dts2#">
        SELECT * FROM leavelist a 
        LEFT JOIN placement b 
        ON a.placementno = b.placementno        
        WHERE enddate <= "#datenow#" 
<!---         AND status != 'WAITING DEPT APPROVED' 
        AND status != 'IN PROGRESS'   --->
        and hrMgr = "#getHQstatus.entryid#"
        ORDER BY a.startdate desc
    </cfquery>

    <table border="0" width="100%">
        <tr>
        <th width="2%">No.</th>
        <th width="10%">Employee</th>
        <th width="5%">Placement No.</th>
        <th width="5%">Date Start</th>
        <th width="5%">Date End</th>
        <th width="2%">Days</th>
		<th width="2%">Leave Type</th>
        <th width="4%">Time From</th>
        <th width="4%">Time To</th>
		<th width="5%">Status</th>
        <th width="7%">Apply Date</th>
        <th width="3%">Attachment</th>        
        <th width="8%">Remarks</th>
        <th width="8%">Last Updated</th>
        <th width="8%">Management Remarks</th>
 <!---        <th width="6%"><center>Approval Doc</th> --->
        </tr>
        
        <cfloop query="wait_leave">
        <tr onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">

        <!--- <cfquery name="select_name" dbtype="query">
        SELECT empno,name,alall,aladj,albf,mcall,ccall FROM getnameall WHERE UPPER(empno) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(wait_leave.empno)#">
        </cfquery>--->
        <td>#wait_leave.currentrow#</td>
        <td>#wait_leave.empname#</td>
        <td>#wait_leave.placementno#</td>
        <td>#dateformat(wait_leave.startdate,'yyyy-mm-dd')#</td>
        <td>#dateformat(wait_leave.enddate,'yyyy-mm-dd')#</td>
        <td>#wait_leave.Days#</td>
        <td><cfif wait_leave.leavetype eq "NCL">Time Off<cfelse>#wait_leave.leavetype#</cfif></td>
		<td>#timeformat(wait_leave.startampm)#</td>
        <td>#timeformat(wait_leave.endampm)#</td>
        <td>#wait_leave.status#</td>
		<td>#dateformat(wait_leave.submit_date,'dd/mm/yyyy')#</td>
        <td>
            <a href="/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#" target="_blank">
            <cfif #wait_leave.signdoc# NEQ "" AND FileExists(ExpandPath('/upload/#dts#/leave/#wait_leave.empno#/#wait_leave.placementno#/#wait_leave.signdoc#')) >View</cfif>
            </a>
        </td>
        <td>#wait_leave.remarks#</td>
        <td>#wait_leave.updated_on#</td>
        <td>#wait_leave.mgmtremarks#</td>
        <!--- <td align="center"> <cfif wait_leave.signdoc neq ''><a href="#wait_leave.signdoc#" target="_blank">View</a></cfif></td> --->
        </tr> 
        </cfloop>
        </table>     
        </div>
</div>

<cfwindow x="210" y="100" width="570" height="480" name="update_leave"
  		 minHeight="400" minWidth="400" 
   		 title="Update Leave" initshow="false" refreshOnShow="true"
   		 source="edit_leave_maintainace.cfm?id={eform:leave_id}" />
  <cfwindow name="waitpage" title="Under Progress!" modal="true" closable="false" width="350" height="260" center="true" initShow="false" >
<p align="center">Under Process, Please Wait!</p>
<p align="center"><img src="/images/loading.gif" name="Cash Sales" width="30" height="30"></p>
<br />
</cfwindow>        
         
</cfoutput>
</body>
</html> 
