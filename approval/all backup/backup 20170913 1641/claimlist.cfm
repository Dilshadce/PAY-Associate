<html>
<head>	
<title>Claim</title>
<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">	
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
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
</script>	
<script src="/javascripts/tabber.js" type="text/javascript">
</script>
<script type="text/javascript">
function confirmdelete(type,claimid) {
		var answer = confirm("Confirm Delete?")
		if (answer){
			window.location = "/payments/claim/createclaim/process.cfm?type="+type+"&claimid="+claimid;}
		else{
			
			}
		}
</script>
</head>
<body>
<cfoutput>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getsuperid" datasource="#dts_main#">
SELECT userGrpID FROM users WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>

	<cfset mon = company_details.mmonth>
    <cfset yrs = company_details.myear>
    <cfset date= createdate(yrs,mon,1)>
    <cfset month1= dateformat(date,'mmmm')>
    <cfset year1= dateformat(date,'yyyy')>
    <cfset total1=0>
    <cfset total2=0>
    <cfset total3=0>
    
<h1>Approve Claim</h1>
<div class="tabber">
	<div class="tabbertab">
		<h3>Submitted For Approval</h3>

<!--- Submitted for approval --->
<cfform method="post" action="process.cfm">	

<cfquery name="getposlist" datasource="#dts#">
	SELECT * FROM claimlist 
    <cfif company_details.eclaimapp eq "adminonly" or getsuperid.userGrpID eq "super">
        c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
		WHERE status IN ('Submitted For Approval','Submitted For Approval 2', 'close','approve') 
	<cfelseif company_details.eclaimapp eq "deptonly">
		c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        INNER JOIN (SELECT deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
        INNER JOIN (SELECT entryid, usercmpid FROM payroll_main.users) AS u ON d.headdept = u.entryid
        WHERE entryid = '#HEntryID#' AND status IN ('Submitted For Approval 2', 'close','approve') 
    <cfelseif company_details.eclaimapp eq "deptadmin">
		c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        INNER JOIN (SELECT deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
        INNER JOIN (SELECT entryid, usercmpid FROM payroll_main.users) AS u ON d.headdept = u.entryid
        WHERE entryid = '#HEntryID#' AND status IN ('Submitted For Approval 2', 'close','approve') 
		UNION ALL SELECT * FROM claimlist 
        c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        INNER JOIN (SELECT deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
        INNER JOIN (SELECT entryid, usercmpid FROM payroll_main.users) AS u ON d.headdept = u.entryid
        WHERE entryid != '#HEntryID#' AND status IN ('Submitted For Approval', 'close','approve') 
    <cfelseif company_details.eclaimapp eq "admindept" >
		c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        INNER JOIN (SELECT deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
        INNER JOIN (SELECT entryid, usercmpid FROM payroll_main.users) AS u ON d.headdept = u.entryid
        WHERE entryid != '#HEntryID#' AND status IN ('Submitted For Approval', 'close','approve') 
		UNION ALL SELECT * FROM claimlist 
        c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        INNER JOIN (SELECT deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
        INNER JOIN (SELECT entryid, usercmpid FROM payroll_main.users) AS u ON d.headdept = u.entryid
        WHERE entryid = '#HEntryID#' AND status IN ('Submitted For Approval 2', 'close','approve') 
    </cfif> 
   ORDER BY empno
</cfquery>

<!---  <cfoutput>
<script type="text/javascript">
	alert("#hentryid#");
</script>
</cfoutput>
<cfabort>  --->
<table align="center" width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="11%">Employee</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="5%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
        <th width="10%"><center>Action / Mgmt Remarks</th>
        <th width="11%"><center>Updated On</th>  
    </tr> 
<center>
    <input type="hidden" name="id" id="id" value="#getposlist.id#">
    <cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <td>#getposlist.CurrentRow#</td>
        <td>#getposlist.empno# | #getposlist.name#</td>
        <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimname#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>
        <cfset total1 += getposlist.claimamount>
    <cfif #getposlist.receipt# neq "">
  		<td align="center">
		<a href="/upload/#dts#/#getposlist.receipt#" target="_blank">View</a></td>
    <cfelse>
   		<td></td>
    </cfif>

		<td align ="left">#remarks#	</td>
        <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
  		<td>
    <input type="checkbox" name="approvebox" id="approvebox#getposlist.id#" value="#getposlist.id#" onClick="if(this.checked == true){document.getElementById('rejectbox#getposlist.id#').checked = false;}" <cfif getposlist.status eq "Approve">Checked</cfif>>Approve
    <input type="checkbox" name="rejectbox" id="rejectbox#getposlist.id#"  value="#getposlist.id#" onClick="if(this.checked == true){document.getElementById('approvebox#getposlist.id#').checked = false;}" <cfif getposlist.status eq "Reject">Checked</cfif>>Reject
    <cfinput type="text" name="mgmtremarks#getposlist.id#" id="mgmtremarks#getposlist.id#" value="#getposlist.mgmtremarks#" size="30" maxlength="50">
    <input type="hidden" name="looprem" id="looprem" value="#getposlist.id#">
   
        <td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#</td>
    </tr>

</cfloop>
    <tr><td colspan=12><br></td></tr>
	<tr><td align="right" colspan="11">Total Submitted For Approval = #numberformat(total1,',.__')#</td></tr>

<table><tr><td align="center">
    <input type="submit" name="sub_btn" id="sub_but" value="Save & Submit to Payroll On">
    <select name="paymonth" id="paymonth">
        <cfloop from = "0" to = "11" index="m">
        <option value="#dateformat(dateadd("m",m,date),"mmm yyyy")#">#dateformat(dateadd("m",m,date),"mmm yyyy")#</option>
        </cfloop>
    </select>
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
    <cfquery name="getposlist" datasource="#dts#">
        SELECT * FROM claimlist 
        c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        WHERE status in ('Updated To Payroll','update to payroll') ORDER BY payrollmonth DESC, empno
    </cfquery>
	<tr>
        <th width="2%">No.</th>
        <th width="12%">Employee</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="5%"><center>Claim Amount</th>
        <th width="5%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
        <th width="10%"><center>Action / Mgmt Remarks</th>
        <th width="11%"><center>Updated On</th>
	</tr> 

	<center>
        <input type="hidden" name="id" id="id" value="#getposlist.id#">
	<cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
	    <cfloop query="getposlist">
	    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td>#getposlist.CurrentRow#</td>
            <td>#getposlist.empno# | #getposlist.name#</td>
            <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
            <td align="left">#getposlist.claimname#</td>
            <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
            <td align="left">#getposlist.receipt_no#</td>
        <cfset total2 += getposlist.claimamount>

        <cfif #getposlist.receipt# neq "">
            <td align="center">
			<a href="/upload/#dts#/#getposlist.receipt#" target="_blank">View</a></td>
        <cfelse>
      		<td></td>
        </cfif>
			<td align ="left">#remarks#
            </td>
            <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
            <td align="left">#getposlist.mgmtremarks#</td>
			<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#
            </td>
		</tr>
		</cfloop>
		<tr><td colspan=12><br></td></tr>
 		<tr><td align="right" colspan="11" >Total Updated To Payroll = #numberformat(total2,',.__')#</td></tr> 
	</center>
	</table> 
	</cfform>
    </div>

<!--- Rejected --->
<div class="tabbertab">
	<h3>Rejected</h3>
   	<cfform method="post" action="process.cfm">	
	<table align="center" width="100%">
    <cfquery name="getposlist" datasource="#dts#">
        SELECT * FROM claimlist 
        c INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
        WHERE status in ('Rejected', 'noapprove', 'reject') ORDER BY empno
    </cfquery>
	<tr>
        <th width="2%">No.</th>
        <th width="12%">Employee</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="5%"><center>Claim Amount</th>
        <th width="5%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
        <th width="10%"><center>Action / Mgmt Remarks</th>
        <th width="11%"><center>Updated On</th>
	</tr> 

	<center>
        <input type="hidden" name="id" id="id" value="#getposlist.id#">
	<cfinput type="hidden" name="rows" id="rows" value="#getposlist.CurrentRow#">
	    <cfloop query="getposlist">
	    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td>#getposlist.CurrentRow#</td>
            <td>#getposlist.empno# | #getposlist.name#</td>
            <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
            <td align="left">#getposlist.claimname#</td>
            <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
            <td align="left">#getposlist.receipt_no#</td>
        <cfset total3 += getposlist.claimamount>

        <cfif #getposlist.receipt# neq "">
            <td align="center">
      		<a href="/upload/#dts#/#getposlist.receipt#" target="_blank">View</a></td>
        <cfelse>
      		<td></td>
        </cfif>
			<td align ="left">#remarks#
            </td>
            <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
            <td align="left">#getposlist.mgmtremarks#</td>
			<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#
            </td>
		</tr>
		</cfloop>
		<tr><td colspan=12><br></td></tr>
 		<tr><td align="right" colspan="11" >Total Rejected = #numberformat(total3,',.__')#</td></tr> 
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