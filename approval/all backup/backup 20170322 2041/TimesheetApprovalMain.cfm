<html>
<head>	
<title>Timesheet Approval</title>
<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">	
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<cfset dts2 = replace(dts,'_p','_i')>
<script type="text/javascript">

/*==================================================
  Set the tabber options (must do this before including tabber.js)
  ==================================================*/
var tabberOptions = {

  'cookie':"tabber", /* Name to use for the cookie */

  'onLoad': function(argsObj)
  {
    var t = argsObj.tabber;
    var i;

    /* Optional: Add the id of the tabber to the cookie name to allow
       for multiple tabber interfaces on the site.  If you have
       multiple tabber interfaces (even on different pages) I suggest
       setting a unique id on each one, to avoid having the cookie set
       the wrong tab.
    */
    if (t.id) {
      t.cookie = t.id + t.cookie;
    }

    /* If a cookie was previously set, restore the active tab */
    i = parseInt(getCookie(t.cookie));
    if (isNaN(i)) { return; }
    t.tabShow(i);

  },

  'onClick':function(argsObj)
  {
    var c = argsObj.tabber.cookie;
    var i = argsObj.index;

    setCookie(c, i);
  }
};

/*==================================================
  Cookie functions
  ==================================================*/
function setCookie(name, value, expires, path, domain, secure) {
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}
function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

function confirmDecline(type,id,pno,first,last,row) {
	var answer = confirm("Confirm Decline?")
	if (answer){
		var textbox_id = "management_"+row;
		var remark_text = document.getElementById(textbox_id).value;		
		
		window.location = "TimesheetApprovalProcess.cfm?type="+type+ "&id="+id+"&remarks="+remark_text+"&pno="+pno+"&first="+first+"&last="+last;
	}
	else{
		
	}
}
<!---function confirmDelete(type,id,pno,first,last) {
	
		var answer = confirm("Confirm Delete?")
		if (answer){
			window.location = "TimesheetApprovalProcess.cfm?type="+type+"&id="+id+"&pno="+pno+"&first="+first+"&last="+last;
			}
		else{
			
			}
		}--->
		
<!---added first and last of date, [20170110, Alvin]--->
function confirmApprove(type,id,pno,first,last,row) {
	var answer = confirm("Confirm Approve?")
	if (answer){
		var textbox_id = "management_"+row;
		var remark_text = document.getElementById(textbox_id).value;
		window.location = "TimesheetApprovalProcess.cfm?type="+type+"&id="+id+"&remarks="+remark_text+"&pno="+pno+"&first="+first+"&last="+last;
	}
	else{
		
	}
}
<!---added--->

function confirmApprove2(type,id,pno) {
    window.location = "TimesheetApproval2.cfm?id="+id+"&placementno="+pno;
}

function confirmApprove3(type,id,pno) {
    window.location = "TimesheetApproval3.cfm?id="+id+"&placementno="+pno;
}


</script>	
<script src="/javascripts/tabber.js" type="text/javascript">
</script>
</head>
<body>
<cfoutput>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getsuperid" datasource="#dts_main#">
SELECT * FROM hmusers WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>

	<cfset mon = company_details.mmonth>
    <cfset yrs = company_details.myear>
    <cfset date= createdate(yrs,mon,1)>
    <cfset month1= dateformat(date,'mmmm')>
    <cfset year1= dateformat(date,'yyyy')>
    <cfset total1=0>
    <cfset total2=0>
    <cfset total3=0>
    
<h3>Timesheet Approval</h3>
<div class="tabber">
	<div class="tabbertab">
		<h3>Submitted For Approval</h3>
		
<!--- Submitted for approval --->
<cfform method="post" action="TimesheetApprovalProcess.cfm">	

<cfquery name="getposlist" datasource="#dts2#">
	SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
    WHERE b.status IN ('Submitted For Approval','Submitted For Approval 2') 
    and a.hrMgr = "#getHQstatus.entryid#"
    GROUP BY b.empno, a.placementno
    ORDER BY b.empno
</cfquery>

<table align="center" width="100%">
    <tr>
        <th width="2%"><center>No.</th>
        <th width="20%"><center>Employee</th>
        <th width="10%"><center>Placement No.</th>
        <th width="8%"><center>Submit Date</th>
        <th width="8%"><center>Month</th>
        <th width="8%"><center>Date Start</th>
        <th width="8%"><center>Date End</th>
        <th width="8%"><center>Timesheet</th>
        <th width="10%"><center>Status</th>
        <th width="10%">Mgmt Remarks</th>
        <th width="8%"><center>Action</th>
<!---        <th width="11%"><center>Submitted On</th>  --->
    </tr> 
<center>
    <input type="hidden" name="id" id="id" value="#getposlist.id#">
    <cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
    
<!---modified start date and end date display in submitted for approval, [20170208, Alvin]--->
	<cfset submitRow = 1>
<cfloop query="getposlist">

				<!---<cfquery name="getflday" datasource="#dts2#">
				   SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
				    LEFT JOIN #dts#.pmast c on b.empno = c.empno
				    WHERE status IN ('Submitted For Approval','Submitted For Approval 2') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
				    AND tmonth = '#getposlist.tmonth#'
				</cfquery>--->

    <cfquery name="getListofSubmit" datasource="#dts#"> <!---this will return only the beginning of the timesheet with status submitted--->
        SELECT *
        FROM timesheet
        WHERE placementno = '#getposlist.placementno#'
        AND status = 'Submitted For Approval'
        AND tsrowcount = '0'
        ORDER by pdate
    </cfquery>
            
    <cfloop query="getListofSubmit">					<!---loop all the beginning of the timesheet--->
    	
        <cfquery name="getMonthlyTimesheet" datasource="#dts#">
        	SELECT *
            FROM timesheet
            WHERE placementno = '#getListofSubmit.placementno#' 
            AND status = 'Submitted for Approval'
            AND pdate >= '#dateformat(getListofSubmit.pdate,'yyyy-mm-dd')#'
            ORDER by pdate
        </cfquery>
        
        <cfset firstZero = TRUE>						<!---starting zero flag--->
        <cfset startingDate = #getListofSubmit.pdate#> <!---to get starting date of the month timesheet--->
        
        <cfloop query="getMonthlyTimesheet">
        	<cfif (firstZero eq FALSE) AND (#getMonthlyTimesheet.tsrowcount# eq '0')>	<!---this will skip first tsrowcount = 0 from being skipped--->
            	<cfbreak>															<!---stops when tsrowcount reach 0(another timesheet)--->
            <cfelse>
            	<cfset endingDate = #getMonthlyTimesheet.pdate#>	<!---set end date as current pdate, as it loops over all the pdate--->
                <cfset firstZero = FALSE>							<!---timesheet ran flag set to false to--->
            </cfif>
        </cfloop>
        
        <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
            <td valign="top">#submitRow#</td>
            <td valign="top">#getposlist.empname#</td>
            <td align="center" valign="top" >#getListofSubmit.placementno#</td>
            <td align="center" valign="top">#dateformat(getListofSubmit.created_on,'dd/mm/yyyy')#</td>
            <td align="center" valign="top"><cftry>#monthasstring(month(endingDate))#<cfcatch>#getListofSubmit.tmonth#</cfcatch></cftry></td>		<!---changed tmonth to end date month--->
            <td align="center" valign="top">#dateformat(startingDate,'dd/mm/yyyy')#</td>
            <td align="center" valign="top">#dateformat(endingDate,'dd/mm/yyyy')#</td>
            <td align="center" valign="top"><a href="TimesheetApprovalView.cfm?pno=#getListofSubmit.placementno#&datestart=#dateformat(startingDate,'yyyy-mm-dd')#&dateend=#dateformat(endingDate,'yyyy-mm-dd')#&tmonth=#getListofSubmit.tmonth#" target="_blank">View</a></td>
            <td align="center" valign="top">Pending</td>
            <td valign="top"><textarea name="management_#submitRow#" id="management_#submitRow#" cols="15" rows="3" required></textarea></td>
            <td align ="left" valign="top">
        <table>
            <tr>
				<cfset apptype = ''>
                <cfif getsuperid.approvaltype eq 2>        
                    <cfset apptype = 2>   
                <cfelseif getsuperid.approvaltype eq 3>
                    <cfset apptype = 3>
                </cfif>
                <td valign="top">
					<!---added some date parameter to be passed in url, [20170110, Alvin]--->
                    <a href="##" onclick="confirmApprove#apptype#('app','#getListofSubmit.tmonth#','#getListofSubmit.placementno#','#dateformat(startingDate, 'yyyy-mm-dd')#','#dateformat(endingDate, 'yyyy-mm-dd')#', '#submitRow#')"><img height="30px" width="30px" src="/images/1.png" alt="Approve" border="0"><br/>Approve</a>
                    <!---added--->
                </td>
                <td valign="top">
                    <a href="##" onclick="if(document.getElementById('management_#submitRow#').value == ''){alert('Please fill in the reason in Mgmt Remarks to cancel')}else{confirmDecline('dec','#getListofSubmit.tmonth#','#getListofSubmit.placementno#','#dateformat(startingDate, 'yyyy-mm-dd')#','#dateformat(endingDate, 'yyyy-mm-dd')#', '#submitRow#')}"><img height="30px" width="30px" src="/images/2.png" alt="Decline" border="0"><br />Decline</a>
                </td>
				<td></td>            
            </tr>
        </table>

        <input type="hidden" name="looprem" id="looprem" value="#getListofSubmit.tmonth#">
        <input type="hidden" name="placementno" id="placementno" value="#getListofSubmit.placementno#">
   
    	</tr>
		<cfset submitRow += 1>
        </cfloop>
    
</cfloop>

        <tr>
            <td colspan=12><br></td>
        </tr>
    
        <table>
            <tr>
                <td align="center"></td>
            </tr>
        </table>

</center>
</table> 
</cfform>
</div>  
<!---modified--->    
   
   <!--- Updated to Payroll --->     
<div class="tabbertab">
	<h3>Approved</h3>
	<cfform method="post" action="process.cfm">	
	<table align="center" width="100%">
    <cfquery name="getposlist" datasource="#dts2#">
        <!---SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        LEFT JOIN #dts#.pmast c on b.empno = c.empno
        WHERE status IN ('Approved','Validated') 
        and hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno, tmonth
        ORDER BY b.empno--->
        SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        WHERE b.status IN ('Approved') 
        and a.hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno
        ORDER BY b.empno       
    </cfquery>
    
	<tr>
        <th width="2%"><center>No.</th>
        <th width="20%"><center>Employee</th>
        <th width="10%"><center>Placement No.</th>
        <th width="8%"><center>Submit Date</th>
        <th width="8%"><center>Month</th>
        <th width="8%"><center>Date Start</th>
        <th width="8%"><center>Date End</th>
        <th width="8%"><center>Timesheet</th>
        <th width="8%"><center>Status</th>
<!---         <th width="6%"><center>Approval Doc</th> --->
        <th width="12%"><center>Mgmt Remarks</th>
	</tr> 

	<center>
        <input type="hidden" name="id" id="id" value="#getposlist.id#">
        <cfset submitRow = 1>
	<cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
	    <cfloop query="getposlist">
        
            <cfquery name="getListofSubmit" datasource="#dts#"> <!---this will return only the beginning of the timesheet with status submitted--->
                SELECT *
                FROM timesheet
                WHERE placementno = '#getposlist.placementno#'
                AND status IN ('Approved')
                AND tsrowcount = '0'
                ORDER by pdate
            </cfquery>
            
            <!---<cfquery name="getflday" datasource="#dts2#">
                SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
                LEFT JOIN #dts#.pmast c on b.empno = c.empno
                WHERE status IN ('Approved','Validated') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
                AND tmonth = '#getposlist.tmonth#'
            </cfquery>   --->
            <cfloop query="getListofSubmit">
            
            <cfquery name="getMonthlyTimesheet" datasource="#dts#">
                SELECT *
                FROM timesheet
                WHERE placementno = '#getListofSubmit.placementno#' 
                AND status IN ('Approved')
                AND pdate >= '#dateformat(getListofSubmit.pdate,'yyyy-mm-dd')#'
                ORDER by pdate
            </cfquery>
            
            <cfset firstZero = TRUE>						<!---starting zero flag--->
            <cfset startingDate = #getListofSubmit.pdate#> <!---to get starting date of the month timesheet--->
            
            <cfloop query="getMonthlyTimesheet">
                <cfif (firstZero eq FALSE) AND (#getMonthlyTimesheet.tsrowcount# eq '0')>	<!---this will skip first tsrowcount = 0 from being skipped--->
                    <cfbreak>															<!---stops when tsrowcount reach 0(another timesheet)--->
                <cfelse>
                    <cfset endingDate = #getMonthlyTimesheet.pdate#>	<!---set end date as current pdate, as it loops over all the pdate--->
                    <cfset firstZero = FALSE>							<!---timesheet ran flag set to false to--->
                </cfif>
            </cfloop>
            
            <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
                <td>#submitRow#</td>
                <td>#getposlist.empname#</td>
                <td align="center">#getposlist.placementno#</td>
                <!---changed submitdate parameter from getting data (from created_on  to Updated_on), [20170208,Alvin]--->
                <td align="center">#dateformat(getListofSubmit.updated_on,'dd/mm/yyyy')#</td>     
                <!---changed--->      
                <td align="center"><cftry>#monthasstring(month(endingDate))#<cfcatch>#getListofSubmit.tmonth#</cfcatch></cftry></td>
                
                <td align="center">#dateformat(startingDate,'dd/mm/yyyy')#</td>
                <td align="center">#dateformat(endingDate,'dd/mm/yyyy')#</td>
                <td align="center"><a href="TimesheetApprovalView.cfm?pno=#getposlist.placementno#&datestart=#dateformat(startingDate,'yyyy-mm-dd')#&dateend=#dateformat(endingDate,'yyyy-mm-dd')#&tmonth=#getListofSubmit.tmonth#" target="_blank">View</a></td>
                <td align="center">Approved<!--- #getposlist.status# ---></td>
              <!---   <td align="center"> <cfif getposlist.signdoc neq ''><a href="#getposlist.signdoc#" target="_blank">View</a></cfif></td> --->
                <td align ="left">#getListofSubmit.mgmtremarks#
            </tr>
            <cfset submitRow += 1>
            </cfloop>
		</cfloop>
		<tr><td colspan=12><br></td></tr>
 		<!---<tr><td align="right" colspan="11" >Total Updated To Payroll = #numberformat(total2,',.__')#</td></tr> --->
	</center>
	</table> 
	</cfform>
    </div>

<!--- Rejected --->
<div class="tabbertab">
	<h3>Rejected</h3>
   	<cfform method="post" action="process.cfm">	
	<table align="center" width="100%">
    <cfquery name="getposlist" datasource="#dts2#">
        <!---SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        LEFT JOIN #dts#.pmast c on b.empno = c.empno
        WHERE status IN ('Rejected') 
        and hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno, tmonth
        ORDER BY b.empno  --->
        SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        WHERE b.status IN ('Rejected') 
        and a.hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno
        ORDER BY b.empno 
    </cfquery>
    
	<tr>
        <th width="2%"><center>No.</th>
        <th width="20%"><center>Employee</th>
        <th width="10%"><center>Placement No.</th>
        <th width="8%"><center>Submit Date</th>
        <th width="8%"><center>Month</th>
        <th width="8%"><center>Date Start</th>
        <th width="8%"><center>Date End</th>
        <th width="8%"><center>Status</th>
        <th width="12%"><center>Mgmt Remarks</th>
	</tr> 

	<center>
        <input type="hidden" name="id" id="id" value="#getposlist.id#">
	<cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
    <cfset submitRow = 1>
	    <cfloop query="getposlist">
        
        <cfquery name="getListofSubmit" datasource="#dts#"> <!---this will return only the beginning of the timesheet with status submitted--->
            SELECT *
            FROM timesheet
            WHERE placementno = '#getposlist.placementno#'
            AND status IN ('Rejected')
            AND tsrowcount = '0'
            ORDER by pdate
        </cfquery>
        
        <!---<cfquery name="getflday" datasource="#dts2#">
            SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
            LEFT JOIN #dts#.pmast c on b.empno = c.empno
            WHERE status IN ('Rejected') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
            AND tmonth = '#getposlist.tmonth#'
        </cfquery>--->
        
        <cfloop query="getListofSubmit">
        
         <cfquery name="getMonthlyTimesheet" datasource="#dts#">
            SELECT *
            FROM timesheet
            WHERE placementno = '#getListofSubmit.placementno#' 
            AND status IN ('Rejected')
            AND pdate >= '#dateformat(getListofSubmit.pdate,'yyyy-mm-dd')#'
            ORDER by pdate
        </cfquery>
        
        <cfset firstZero = TRUE>						<!---starting zero flag--->
        <cfset startingDate = #getListofSubmit.pdate#> <!---to get starting date of the month timesheet--->
        
        <cfloop query="getMonthlyTimesheet">
            <cfif (firstZero eq FALSE) AND (#getMonthlyTimesheet.tsrowcount# eq '0')>	<!---this will skip first tsrowcount = 0 from being skipped--->
                <cfbreak>															<!---stops when tsrowcount reach 0(another timesheet)--->
            <cfelse>
                <cfset endingDate = #getMonthlyTimesheet.pdate#>	<!---set end date as current pdate, as it loops over all the pdate--->
                <cfset firstZero = FALSE>							<!---timesheet ran flag set to false to--->
            </cfif>
        </cfloop>
        
        <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
            <td>#submitRow#</td>
            <td>#getposlist.empname#</td>
            <td align="center">#getposlist.placementno#</td>
            <td align="center">#dateformat(getListofSubmit.created_on,'dd/mm/yyyy')#</td>
            <td align="center"><cftry>#monthasstring(month(endingDate))#<cfcatch>#getListofSubmit.tmonth#</cfcatch></cftry></td>
            <td align="center">#dateformat(startingDate,'dd/mm/yyyy')#</td>
            <td align="center">#dateformat(endingDate,'dd/mm/yyyy')#</td>
            <td align="center">Rejected</td>
            <td align ="left">#getListofSubmit.mgmtremarks#
		</tr>
        <cfset submitRow += 1>
        </cfloop>
		</cfloop>
		<tr><td colspan=12><br></td></tr>
 		<!---<tr><td align="right" colspan="11" >Total Rejected = #numberformat(total3,',.__')#</td></tr> --->
	</center>
	</table> 
	</cfform>
    </div>
    
</div>

<!--- <cfwindow center="true" width="800" height="400" name="viewreceipt" title="Receipt" refreshOnShow="true"
            source="process.cfm?type=viewreceipt&id={id}" />  --->
</cfoutput>
</body>
</html>