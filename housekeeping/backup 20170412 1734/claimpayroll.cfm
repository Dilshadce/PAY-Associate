<cfoutput>
<cfset mon = new_month>
<cfset yrs = new_year>
<cfset date= createdate(yrs,mon,1)>
<cfset nodays = daysinmonth(date)>
<cfset dateto = createdate(yrs,mon,nodays)>

<cfquery name="getdatabase" datasource="#dts#">	
    SELECT SUM(claimamount) AS total_claim,allowance,empno 
    FROM claimlist WHERE status = "Updated To Payroll" AND payrollmonth >= '#dateformat(date,"yyyy-mm-dd")#' 
    AND payrollmonth <= '#dateformat(dateto,"yyyy-mm-dd")#' GROUP BY allowance,empno ORDER BY empno
</cfquery>	
	<cfloop query="getdatabase">
    <cfquery name="posupdate" datasource="#dts#">
         UPDATE paytran SET 	
         AW#100+getdatabase.allowance# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.total_claim#">		
         WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdatabase.empno#">
    </cfquery>
    </cfloop> 
</cfoutput>