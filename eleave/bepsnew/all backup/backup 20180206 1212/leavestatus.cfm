<cfoutput>
<cfset dsname = replace(dsname,'_p','_i') >
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<cfif val(company_details.mmonth) eq "13">
<cfset company_details.mmonth = 12 >
</cfif>

<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>

<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
</cfquery>

<cfquery name="getplacementlist" datasource="#dsname#">
SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
</cfquery>

<cfquery name="leavelist" datasource="#dsname#">
Select * from iccostcode  WHERE costcode not in ('AL','CC1','HPL','MC','NPL')  order by costcode
</cfquery>

<cfif getplacementlist.recordcount eq 0>
<h1>No Active Placement Found</h1>
<cfabort>
</cfif>


       <cfquery name="getleavedetail" datasource="#dsname#">
      SELECT sum(days) as days,leavetype FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> and contractenddate = "#dateformat(getplacementlist.completedate,'YYYY-MM-DD')#" GROUP BY leavetype
      </cfquery>
      <cfloop query="getleavedetail">
      <cfset "#getleavedetail.leavetype##getplacementlist.placementno#day" = getleavedetail.days>
      </cfloop>
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
Leave entitlement shown is for full contract period.  Please note that leave is earned on a pro-rata basis. <br />Leave application may be made only for leave earned.<br /><br />

</td>
      </tr>
      <tr>
      <td colspan="100%"></td>
      </tr>
      <tr>
      <th align="left">Leave Type</th>
      <th align="left">Entitlement</th>
      <cfif val(getplacementlist.ALbfdays) neq 0>
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
      <cfif val(getplacementlist.ALbfdays) neq 0>
      <td>#val(getplacementlist.ALbfdays)#</td>
      <cfelse>
      <td></td>
      </cfif>
      <td>#altaken#</td>
      <td>#val(getplacementlist.ALdays)+val(getplacementlist.ALbfdays) - val(altaken)#</td>
 
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
       <td></td>
      
      <td></td>
      <td>#mctaken#</td>
      <td></td>
     
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
      <td></td>
      <td></td>
      <cfif isdefined("#leavelist.costcode##getplacementlist.placementno#day")>
	  <cfset leavetaken = val(evaluate("#leavelist.costcode##getplacementlist.placementno#day"))>
      <cfelse>
      <cfset leavetaken = 0>
	  </cfif>
      <td>#leavetaken#</td>
      <td></td>
    
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
      <cfquery name="getleavedetail" datasource="#dsname#">
      SELECT * FROM (
      SELECT leavetype,days,startdate,enddate FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> and contractenddate = "#dateformat(getplacementlist.completedate,'YYYY-MM-DD')#") as a
      LEFT JOIN
      (SELECT desp,costcode from iccostcode) as b
      on a.leavetype = b.costcode
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
   </cfoutput>
