<cfoutput>
<cfif isdefined('form.pno')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT empno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfif getempno.empno neq get_comp.empno>
<cfabort>
</cfif>
</cfif>
<cfset dts = replace(dsname,'_p','_i') >
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<cfquery name="getplacementlist" datasource="#dts#">
SELECT * FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfquery name="getclaimlist" datasource="#dts#">
  		  select * from icgroup ORDER BY wos_group
    </cfquery>
      <table width="700px">
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
      <td colspan="100%"></td>
      </tr>
      <tr>
      <th align="left">Reimbursement</th>
      <th align="left">Entitlement (RM)</th>
      <th align="left">Claimed (RM)</th>
      <th align="left">Balance (RM)</th> 
      <td></td>
      </tr>
      
      <cfquery name="getlist" datasource="#dts#">
       SELECT * FROM claimlist 
       WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
       AND status in ("Updated To Payroll","Approved") 
       ORDER BY submit_date desc
      </cfquery>
      
      <cfloop query="getclaimlist">
      <cfset a = getclaimlist.wos_group>
      <cfif evaluate('getplacementlist.#a#payable') eq "Y" or numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__') neq 0 or numberformat(evaluate('getplacementlist.total#a#claimable'),'.__') neq 0>
      <tr>
      <td>#a#</td>
	  <td><cfif numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__') eq 0><cfelse>RM#numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__')# Cap per Visit</cfif><br>
<cfif numberformat(evaluate('getplacementlist.total#a#claimable'),'.__') eq 0><cfelse>RM#numberformat(evaluate('getplacementlist.total#a#claimable'),'.__')# Cap per Contract</cfif></td>
      
       <cfset totalget = 0>
       <cfloop query="getlist">
            <cfif getlist.claimtype eq a>
                <cfset totalget += val(getlist.claimamount)>
            </cfif>
       </cfloop>
       <td>#numberformat(totalget,',.__')#</td>
       <td><cfif numberformat(evaluate('getplacementlist.total#a#claimable'),'.__') eq 0><cfelse><cfset balancenow=numberformat(evaluate('getplacementlist.total#a#claimable'),'.__')- numberformat(totalget,'.__')-numberformat(evaluate('getplacementlist.#a#claimedamt'),'.__')>#numberformat(balancenow,',.__')#</cfif></td>
       
      </tr>
      </cfif>
      </cfloop>
     
      <tr>
      <td colspan="100%"></td>
      </tr>
      <tr>
      <th align="left" colspan="5">Reimbursement Details</th>
      </tr>
      <tr>
      <th align="left">Reimbursement</th>
      <th align="left">Pay Period</th>
      <th align="left">Description</th>
      <th align="left">Receipt</th>
      <th align="left">Amount</th>
      </tr>
      
      <cfquery name="getdetail" datasource="#dts#">
       SELECT * FROM claimlist
       WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
       AND status in ("Updated To Payroll","Approved") 
       ORDER BY submit_date desc
      </cfquery>
      
      
      <cfloop query="getdetail">
      <tr>
      <td>#getdetail.claimtype#</td>
      <td>#dateformat(getdetail.submit_date,'MMM YYYY')#</td>
      <td>#getdetail.remarks#</td>
      <td><a href="/upload/#dsname#/#receipt#" target="_blank">#receipt#</a></td>
      <td>#numberformat(claimamount,'.__')#</td>
      </tr>
      </cfloop>

   </table>

<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<script src="/javascripts/tabber.js" type="text/javascript"></script>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >

<script type="text/javascript">
function confirmdelete(type,id) {
		var answer = confirm("Confirm Delete?")
		if (answer){
			window.location = "/employee/process.cfm?type="+type+"&id="+id;}
		else{
			
			}
		}
</script>


<html>
<body>
<h1>Claim Status</h1>
<div class="tabber">
		
     <!---   <div class="tabbertab">
		<h3>Pending Submission</h3>
        
        <cfquery name="getposlist" datasource="#dts#">
            SELECT * FROM claimlist a
            LEFT JOIN placement b on a.placementno = b.placementno
            LEFT JOIN #dsname#.pmast c on b.empno = c.empno
            WHERE a.placementno = '#getplacementlist.placementno#'
            AND status in( 'Pending Submission', 'open') order by submited_on desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Placement No.</th>
        <th width="8%"><center>Claim Date</th>
        <th width="7%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="10%"><center>Status</th>
        <!---<th width="10%"><center>Action</th>--->
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#getposlist.placementno#</td>
        <td align="center">#dateformat(getposlist.submited_on,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimtype#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
<!---        <td>
            <a onClick="confirmdelete('delete','#getposlist.id#')" style="cursor:pointer;">
            <img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>
        </td>--->
        <td algin="center">#getposlist.status#</td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updated_on,"dd/mm/yyyy") & timeformat(getposlist.updated_on," hh:mmtt")#</td>
	</tr>
</cfloop>
	<tr>	
	</tr>
</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>--->
        
        
        <div class="tabbertab">
		<h3>Submitted For Approval</h3>
        
        <cfquery name="getposlist" datasource="#dts#">
            SELECT * FROM claimlist a
            LEFT JOIN placement b on a.placementno = b.placementno
            LEFT JOIN #dsname#.pmast c on b.empno = c.empno
            WHERE a.placementno = '#getplacementlist.placementno#' 
            AND status in( 'Submitted For Approval', 'Submitted For Approval 2', 'close','approve') order by submited_on desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Placement No.</th>
        <th width="8%"><center>Claim Date</th>
        <th width="7%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="10%"><center>Status</th>
        <!---<th width="10%"><center>Action</th>--->
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#getposlist.placementno#</td>
        <td align="center">#dateformat(getposlist.submited_on,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimtype#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td algin="center">#getposlist.status#</td>
        <td align="left">#getposlist.mgmtremarks#</td>

		<td align="center">#dateformat(getposlist.updated_on,"dd/mm/yyyy") & timeformat(getposlist.updated_on," hh:mmtt")#</td>
	</tr>
</cfloop>

</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
        <div class="tabbertab">
		<h3>Approved</h3>
        
        <cfquery name="getposlist" datasource="#dts#">
            SELECT * FROM claimlist a
            LEFT JOIN placement b on a.placementno = b.placementno
            LEFT JOIN #dsname#.pmast c on b.empno = c.empno
            WHERE a.placementno = '#getplacementlist.placementno#'
            AND status in( 'Updated To Payroll','update to payroll') order by submited_on desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Placement No.</th>
        <th width="8%"><center>Claim Date</th>
        <th width="7%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="10%"><center>Status</th>
        <!---<th width="10%"><center>Action</th>--->
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#getposlist.placementno#</td>
        <td align="center">#dateformat(getposlist.submited_on,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimtype#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td algin="center">#getposlist.status#</td>
        <td align="left">#getposlist.mgmtremarks#</td>
		<td align="center">#dateformat(getposlist.updated_on,"dd/mm/yyyy") & timeformat(getposlist.updated_on," hh:mmtt")#</td>
	</tr>
</cfloop>

</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
        <div class="tabbertab">
		<h3>Rejected</h3>
        
        <cfquery name="getposlist" datasource="#dts#">
            SELECT * FROM claimlist a
            LEFT JOIN placement b on a.placementno = b.placementno
            LEFT JOIN #dsname#.pmast c on b.empno = c.empno
	    WHERE a.placementno = '#getplacementlist.placementno#'
	    AND status in('Rejected','reject','noaaprove') order by submited_on desc
        </cfquery>
        
        <cfform name="form2" id="form2" method="post" action="process.cfm">	
<table width="100%">
    <tr>
        <th width="2%">No.</th>
        <th width="6%"><center>Placement No.</th>
        <th width="8%"><center>Claim Date</th>
        <th width="7%"><center>Claim Type</th>
        <th width="7%"><center>Claim Amount</th>
        <th width="6%"><center>Receipt No.</th>
        <th width="5%"><center>Claim File</th>
        <th width="10%"><center>Remarks</th>
        <th width="10%"><center>Status</th>
        <!---<th width="10%"><center>Action</th>--->
        <th width="14%"><center>Mgmt. Remarks</th>
        <th width="11%"><center>Updated On</th>
    </tr>

<cfloop query="getposlist">
    <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';">
        <input type="hidden" name="id" id="id" value="getposlist.id">
        <td>#getposlist.CurrentRow#</td>
        <td align="center">#getposlist.placementno#</td>
        <td align="center">#dateformat(getposlist.submited_on,'dd/mm/yyyy')#</td>
        <td align="left">#getposlist.claimtype#</td>
        <td align="right">#numberformat(getposlist.claimamount,',.__')#</td>
        <td align="left">#getposlist.receipt_no#</td>

<cfif #getposlist.receipt# neq "">
        <td align="center">
        <a href="/upload/#dsname#/#getposlist.receipt#" target="_blank">View </a>
        </td>
<cfelse>
		<td></td>
</cfif>

        <td align="left">#getposlist.remarks#</td>
        <td algin="center">#getposlist.status#</td>
        <td align="left">#getposlist.mgmtremarks#</td>
		<td align="center">#dateformat(getposlist.updated_on,"dd/mm/yyyy") & timeformat(getposlist.updated_on," hh:mmtt")#</td>
	</tr>
</cfloop>
	
</table>
	<input type="hidden" name="hiddenid" id="hiddenid" value="">
</cfform>
        </div>
</div>
</body>	
</html>
   
   
   
   
   


</cfoutput>
