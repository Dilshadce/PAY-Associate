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

function confirmDecline(type,id,pno,first,last) {
	var answer = confirm("Confirm Decline?")
	if (answer){
		var textbox_id = "management_"+id+"_"+pno;
		var remark_text = document.getElementById(textbox_id).value;		
		
		window.location = "TimesheetApprovalProcess.cfm?type="+type+ "&id="+id+"&remarks="+remark_text+"&pno="+pno+"&first="+first+"&last="+last;
	}
	else{
		
	}
}
function confirmDelete(type,id,pno,first,last) {
	
		var answer = confirm("Confirm Delete?")
		if (answer){
			window.location = "TimesheetApprovalProcess.cfm?type="+type+"&id="+id+"&pno="+pno+"&first="+first+"&last="+last;
			}
		else{
			
			}
		}
		
<!---added first and last of date, [20170110, Alvin]--->
function confirmApprove(type,id,pno,first,last) {
	var answer = confirm("Confirm Approve?")
	if (answer){
		var textbox_id = "management_"+id+"_"+pno;
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
    LEFT JOIN #dts#.pmast c on a.empno = c.empno
    WHERE status IN ('Submitted For Approval','Submitted For Approval 2') 
    and hrMgr = "#getHQstatus.entryid#"
    GROUP BY b.empno, a.placementno, tmonth
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
<cfloop query="getposlist">
<cfquery name="getflday" datasource="#dts2#">
	SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
    LEFT JOIN #dts#.pmast c on b.empno = c.empno
    WHERE status IN ('Submitted For Approval','Submitted For Approval 2') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
    AND tmonth = '#getposlist.tmonth#'
</cfquery>
<!---    <input type="text" hidden id="pno" name="pno" value="#getposlist.placementno#">
    <input type="text" hidden id="datestart" name="datestart" value="#getflday.first#">
    <input type="text" hidden id="dateend" name="dateend" value="#getflday.last#">--->
        
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
        <td valign="top">#getposlist.CurrentRow#</td>
        <td valign="top">#getposlist.name#</td>
        <td align="center" valign="top" >#getposlist.placementno#</td>
        <td align="center" valign="top">#dateformat(getposlist.created_on,'dd/mm/yyyy')#</td>
        <td align="center" valign="top"><cftry>#monthasstring(getflday.tmonth)#<cfcatch>#getflday.tmonth#</cfcatch></cftry></td>
        <td align="center" valign="top">#dateformat(getflday.first,'dd/mm/yyyy')#</td>
        <td align="center" valign="top">#dateformat(getflday.last,'dd/mm/yyyy')#</td>
        <td align="center" valign="top"><a href="TimesheetApprovalView.cfm?pno=#getposlist.placementno#&datestart=#dateformat(getflday.first,'yyyy-mm-dd')#&dateend=#dateformat(getflday.last,'yyyy-mm-dd')#&tmonth=#getflday.tmonth#" target="_blank">View</a></td>
        <td align="center" valign="top">Pending</td>
        <td valign="top"><textarea name="management_#getposlist.tmonth#_#getposlist.placementno#" id="management_#getposlist.tmonth#_#getposlist.placementno#" cols="15" rows="3" required></textarea></td>
		<td align ="left" valign="top"><!---#getposlist.mgmtremarks#--->
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
            <td valign="top">
            <!---added some date parameter to be passed in url, [20170110, Alvin]--->
                <a href="##" onclick="confirmApprove#apptype#('app','#getposlist.tmonth#','#getposlist.placementno#','#dateformat(getflday.first, 'yyyy-mm-dd')#','#dateformat(getflday.first, 'yyyy-mm-dd')#')"><img height="30px" width="30px" src="/images/1.png" alt="Approve" border="0"><br/>Approve</a>
            <!---added--->
            </td>
            <td valign="top">
                <a href="##" onclick="if(document.getElementById('management_#getposlist.tmonth#_#getposlist.placementno#').value == ''){alert('Please fill in the reason in Mgmt Remarks to cancel')}else{confirmDecline('dec','#getposlist.tmonth#','#getposlist.placementno#','#dateformat(getflday.first, 'yyyy-mm-dd')#','#dateformat(getflday.first, 'yyyy-mm-dd')#')}"><img height="30px" width="30px" src="/images/2.png" alt="Decline" border="0"><br />Decline</a>
            </td>
            <td><!---<input type="checkbox" name="id" id="id#wait_leave.id#" value="#wait_leave.id#" />--->
            </td>            
            </tr>
        </table>

<!---    <input type="checkbox" name="approvebox" id="approvebox#getposlist.tmonth#" value="#getposlist.tmonth#" onClick="if(this.checked == true){document.getElementById('rejectbox#getposlist.tmonth#').checked = false;}" <cfif getposlist.status eq "Approve">Checked</cfif>>Approve
    <input type="checkbox" name="rejectbox" id="rejectbox#getposlist.tmonth#"  value="#getposlist.tmonth#" onClick="if(this.checked == true){document.getElementById('approvebox#getposlist.tmonth#').checked = false;}" <cfif getposlist.status eq "Reject">Checked</cfif>>Reject
    <cfinput type="text" name="mgmtremarks#getposlist.tmonth#" id="mgmtremarks#getposlist.tmonth#" value="#getposlist.mgmtremarks#" size="30" maxlength="50">
--->    <input type="hidden" name="looprem" id="looprem" value="#getposlist.tmonth#">
    <input type="hidden" name="placementno" id="placementno" value="#getposlist.placementno#">
   
<!---        <td align="center">#dateformat(getposlist.updated_on,"dd/mm/yyyy") & timeformat(getposlist.updated_on," hh:mmtt")#</td>--->
    </tr>

</cfloop>
    <tr><td colspan=12><br></td></tr>
<!---	<tr><td align="right" colspan="11">Total Submitted For Approval = #numberformat(total1,',.__')#</td></tr>--->

<table><tr><td align="center">
<!---    <input type="submit" name="sub_btn" id="sub_but" value="Save & Submit">
---><!---    <select name="paymonth" id="paymonth">
        <cfloop from = "0" to = "11" index="m">
        <option value="#dateformat(dateadd("m",m,date),"mmm yyyy")#">#dateformat(dateadd("m",m,date),"mmm yyyy")#</option>
        </cfloop>
    </select>--->
</td></tr></table>

</center>
</table> 
</cfform>
</div>      
   
   <!--- Updated to Payroll --->     
<div class="tabbertab">
	<h3>Approved</h3>
	<cfform method="post" action="process.cfm">	
	<table align="center" width="100%">
    <cfquery name="getposlist" datasource="#dts2#">
        SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        LEFT JOIN #dts#.pmast c on b.empno = c.empno
        WHERE status IN ('Approved','Validated') 
        and hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno, tmonth
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
	<cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
	    <cfloop query="getposlist">
        <cfquery name="getflday" datasource="#dts2#">
            SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
            LEFT JOIN #dts#.pmast c on b.empno = c.empno
            WHERE status IN ('Approved','Validated') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
            AND tmonth = '#getposlist.tmonth#'
        </cfquery>
        
	    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
            <td>#getposlist.CurrentRow#</td>
            <td>#getposlist.name#</td>
            <td align="center">#getposlist.placementno#</td>
            <td align="center">#dateformat(getposlist.created_on,'dd/mm/yyyy')#</td>           
            <td align="center"><cftry>#monthasstring(getflday.tmonth)#<cfcatch>#getflday.tmonth#</cfcatch></cftry></td>
            
            <td align="center">#dateformat(getflday.first,'dd/mm/yyyy')#</td>
            <td align="center">#dateformat(getflday.last,'dd/mm/yyyy')#</td>
            <td align="center"><a href="TimesheetApprovalView.cfm?pno=#getposlist.placementno#&datestart=#dateformat(getflday.first,'yyyy-mm-dd')#&dateend=#dateformat(getflday.last,'yyyy-mm-dd')#&tmonth=#getflday.tmonth#" target="_blank">View</a></td>
            <td align="center">Approved<!--- #getposlist.status# ---></td>
          <!---   <td align="center"> <cfif getposlist.signdoc neq ''><a href="#getposlist.signdoc#" target="_blank">View</a></cfif></td> --->
            <td align ="left">#getposlist.mgmtremarks#
		</tr>
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
        SELECT * FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
        LEFT JOIN #dts#.pmast c on b.empno = c.empno
        WHERE status IN ('Rejected') 
        and hrMgr = "#getHQstatus.entryid#"
        GROUP BY b.empno, a.placementno, tmonth
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
	    <cfloop query="getposlist">
        <cfquery name="getflday" datasource="#dts2#">
            SELECT min(pdate) as first,max(pdate) as last,tmonth FROM placement a INNER JOIN #dts#.timesheet b on a.placementno = b.placementno 
            LEFT JOIN #dts#.pmast c on b.empno = c.empno
            WHERE status IN ('Rejected') and a.empno = '#getposlist.empno#' and a.placementno = '#getposlist.placementno#'
            AND tmonth = '#getposlist.tmonth#'
        </cfquery>
        <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
            <td>#getposlist.CurrentRow#</td>
            <td>#getposlist.name#</td>
            <td align="center">#getposlist.placementno#</td>
            <td align="center">#dateformat(getposlist.created_on,'dd/mm/yyyy')#</td>
            <td align="center"><cftry>#monthasstring(getflday.tmonth)#<cfcatch>#getflday.tmonth#</cfcatch></cftry></td>
            <td align="center">#dateformat(getflday.first,'dd/mm/yyyy')#</td>
            <td align="center">#dateformat(getflday.last,'dd/mm/yyyy')#</td>
            <td align="center">Rejected</td>
            <td align ="left">#getposlist.mgmtremarks#
		</tr>
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