<cfoutput>
<cfset dts = replace(dsname,'_p','_i') >
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfif val(company_details.mmonth) eq "13">
<cfset company_details.mmonth = 12 >
</cfif>

<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>

<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#" 
</cfquery>

<cfquery name="getplacementlist" datasource="#dts#">
SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
</cfquery>

<cfquery name="leavelist" datasource="#dts#">
Select * from iccostcode  WHERE costcode not in ('AL','CC1','HPL','MC','NPL')  order by costcode
</cfquery>

<cfif getplacementlist.recordcount eq 0>
<h3>No Active Placement Found</h3>
<cfabort>
</cfif>
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
      <cfif val(getplacementlist.medicalclaimedamt) neq 0 or val(getplacementlist.dentalclaimedamt) neq 0>
      <th align="left">Exception Claim (RM)</th>
      </cfif>
      <th align="left">Taken (RM)</th>
      <th align="left">Balance (RM)</th> 
      <td></td>
      </tr>
      
      <cfquery name="getlist" datasource="#dts#">
       SELECT * FROM claimlist 
       WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
       AND status = "Updated To Payroll"
       ORDER BY submit_date desc
      </cfquery>
      
      <cfloop list="Medical,Dental" index="a">
      <cfif evaluate('getplacementlist.#a#payable') eq "Y" or numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__') neq 0 or numberformat(evaluate('getplacementlist.total#a#claimable'),'.__') neq 0>
      <tr>
      <td>#a#</td>
	  <td><cfif numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__') eq 0><cfelse>RM#numberformat(evaluate('getplacementlist.per#a#claimcap'),'.__')# Cap per Visit</cfif><br>
<cfif numberformat(evaluate('getplacementlist.total#a#claimable'),'.__') eq 0><cfelse>RM#numberformat(evaluate('getplacementlist.total#a#claimable'),'.__')# Cap per Contract</cfif></td>
<cfif val(getplacementlist.medicalclaimedamt) neq 0 or val(getplacementlist.dentalclaimedamt) neq 0>
      <td>#numberformat(evaluate('getplacementlist.#a#claimedamt'),',.__')#</td>
      </cfif>
      
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
       AND status = "Updated To Payroll"
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
   </cfoutput>
