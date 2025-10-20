<html>
<head>	
<title>Claim</title>
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



</head>
<script type="text/javascript">
function confirmdelete(type,id) {
		var answer = confirm("Confirm Delete?")
		if (answer){
			window.location = "/employee/process.cfm?type="+type+"&id="+id;}
		else{
			
			}
		}
		
		
</script>

<cfquery name="emp_data" datasource="#DSNAME#" >
	SELECT pm.empno as empno FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#"  
</cfquery>


<cfquery name="getposdetail" datasource="#dsname#">
select * from claim 
</cfquery>

<body>
<cfoutput>
<h1>Claim Status</h1>

<div class="tabber">
		
        <div class="tabbertab">
		<h3>Pending Submission</h3>
        
        <cfquery name="getposlist" datasource="#dsname#">
            SELECT * FROM claimlist WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            AND status in( 'Pending Submission', 'open') order by claim_date desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table align="left" width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
<!---         <th width="15%"><center>Status</th> --->
        <th width="10%"><center>Action</th>
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimname#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
<!---         <a onClick="document.getElementById('hiddenid').value='#getposlist.id#';ColdFusion.Window.show('viewreceipt');" style="cursor:pointer">View</a> --->
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
<!---         <td align="center">#getposlist.status#</td> --->
        <td>
            <a href="createlist.cfm?id=#getposlist.id#&type=edit&claimid=#getposlist.claimid#">
            <img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;&nbsp;
            <a onClick="confirmdelete('delete','#getposlist.id#')" style="cursor:pointer;">
            <img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>
        </td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#</td>
	</tr>
</cfloop>
	<tr>	
		<td align="center" colspan="12"><input type="submit" name="sub_but" id="sub_but" value="Submit For Approval"></td>
	</tr>
</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
        
        
        <div class="tabbertab">
		<h3>Submitted For Approval</h3>
        
        <cfquery name="getposlist" datasource="#dsname#">
            SELECT * FROM claimlist WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            AND status in( 'Submitted For Approval', 'Submitted For Approval 2', 'close','approve') order by claim_date desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table align="left" width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
<!---         <th width="15%"><center>Status</th> --->
        <th width="10%"><center>Action</th>
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimname#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
<!---         <a onClick="document.getElementById('hiddenid').value='#getposlist.id#';ColdFusion.Window.show('viewreceipt');" style="cursor:pointer">View</a> --->
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
<!---         <td align="center">#getposlist.status#</td> --->
        <td>
        </td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#</td>
	</tr>
</cfloop>

</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
        <div class="tabbertab">
		<h3>Approved</h3>
        
        <cfquery name="getposlist" datasource="#dsname#">
            SELECT * FROM claimlist WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            AND status in( 'Updated To Payroll','update to payroll') order by payrollmonth desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table align="left" width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
<!---         <th width="15%"><center>Status</th> --->
        <th width="10%"><center>Action</th>
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimname#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
       <!---  <a onClick="document.getElementById('hiddenid').value='#getposlist.id#';ColdFusion.Window.show('viewreceipt');" style="cursor:pointer">View</a> --->
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
<!---         <td align="center">#getposlist.status#</td> --->
        <td>
        </td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#</td>
	</tr>
</cfloop>

</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
        <div class="tabbertab">
		<h3>Rejected</h3>
        
        <cfquery name="getposlist" datasource="#dsname#">
            SELECT * FROM claimlist WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
            AND status in('Rejected','reject','noaaprove') order by claim_date desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table align="left" width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Claim Date</th>
        <th width="8%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="6%"><center>Payroll Date</th>
<!---         <th width="15%"><center>Status</th> --->
        <th width="10%"><center>Action</th>
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#dateformat(getposlist.claim_date,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimname#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
<!---         <a onClick="document.getElementById('hiddenid').value='#getposlist.id#';ColdFusion.Window.show('viewreceipt');" style="cursor:pointer">View</a> --->
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td align="center">#dateformat(getposlist.payrollmonth,'mmm yyyy')#</td>
<!---         <td align="center">#getposlist.status#</td> --->
        <td>
		
            <a href="createlist.cfm?id=#getposlist.id#&type=edit&claimid=#getposlist.claimid#">
            <img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;&nbsp;
            <!--- <a onClick="confirmdelete('delete','#getposlist.id#')" style="cursor:pointer;">
            <img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a> --->
		

        </td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updatedon,"dd/mm/yyyy") & timeformat(getposlist.updatedon," hh:mmtt")#</td>
	</tr>
</cfloop>
	
</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>


</cfoutput>

<!--- <cfajaximport tags="cfwindow,cfform,cfdiv"> --->
<!---<cfwindow center="true" width="800" height="400" name="viewreceipt" title="Receipt" refreshOnShow="true"
   		 source="process.cfm?type=viewreceipt&id={hiddenid}" />--->
   
</body>	
</html>