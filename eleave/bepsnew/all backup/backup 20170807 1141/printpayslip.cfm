<cfset dts = replace(dsname,'_p','_i') >
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Print Pay Slip</title>
<script type="text/javascript">
function printpdf1()
	{
		<cfoutput>
		var tabletype = "paytra1";
		if(document.getElementById('paytype').value == 'pay_12m')
		{
			tabletype = "pay12m";
		}
		else
		{
			tabletype = document.getElementById('paytype').value;
		}
		document.pForm.action = "/bill/beps_p/customizepayslip.cfm?type="+tabletype+"&eleave=y";
		
	 	</cfoutput>
	}
    </script>
</head>

<body>
<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>Print Pay Slip</h3>
        <form name="pForm" id="pForm" action="/bill/beps_p/customizepayslip.cfm?type=pay12m&eleave=y" method="post" target="_blank">
        
        <table class="form">
        <tr>
        <td>Month</td>
        <td>
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
        
        <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
        </cfquery>
        
        <cfif getplacementlist.recordcount neq 0>
        <cfset payday = getplacementlist.emp_pay_d>
        <cfif val(payday) eq 0>
        <cfset payday = daysinmonth(currentdate)>
		</cfif>
       
        <cfset getlastday = daysinmonth(createdate(val(company_details.myear),val(company_details.mmonth),1))>
        <cfif getlastday lt val(payday)>
        <cfset payday = getlastday>
		</cfif>
 
        <cfset payrolldate = createdate(val(company_details.myear),val(company_details.mmonth),val(payday))>
        <cfif (dateadd('m','1',dateadd('d',1,payrolldate)) lte now() and payday lte 15) or (payday gt 15 and dateadd('d',1,payrolldate) lte now())>
        
        <cfquery name="checkpay" datasource="#dsname#">
        SELECT payyes FROM paytra1 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and cheque_no is not null and cheque_no <> ""
        </cfquery>	
        
        <cfif checkpay.payyes neq "Y">
        <cfquery name="checkpay" datasource="#dsname#">
        SELECT payyes FROM paytran WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and cheque_no is not null and cheque_no <> ""
        </cfquery>	
        <cfif checkpay.payyes eq "Y">
        <cfset currentpaytran = 1>
		</cfif>
		</cfif>
        
        <cfif checkpay.payyes eq "Y">
        <cfset currentmonthpayyes = 0>
        </cfif>
        
        </cfif>
        
        </cfif>
        <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
        </cfquery>
		
        <cfif isdefined('currentmonthpayyes')>
        <cfset month_count = val(company_details.mmonth) >
		<cfelse>
        <cfset month_count = val(company_details.mmonth) - 1  >
        </cfif>
        <input type="hidden" value="<cfif month_count lt 1><cfif isdefined('currentpaytran')>paytran<cfelse>paytra1</cfif><cfelse>pay_12m</cfif>" name="paytype" id="paytype" />
        <select name="month1" id="month1" onchange="document.getElementById('paytype').value=this.options[this.selectedIndex].id" >
        <cfloop from="1" to="#month_count#" index="i">
        <cfset month_value = createdate('2011',i,'1')>
        <option value="#i#" id="<cfif i eq val(company_details.mmonth)><cfif isdefined('currentpaytran')>paytran<cfelse>paytra1</cfif><cfelse>pay_12m</cfif>">#dateformat(month_value,'mmmm')#</option>
        </cfloop>
        </select>
        </td>
        </tr>
       
        <tr>
        <td></td>
        <td>
        <input type="submit" name="pdf" value="PRINT" onclick="printpdf1();" >
 </td>
        </tr>
        </table>
        </form>
        </div>
</div>
</cfoutput>
</body>
</html>
