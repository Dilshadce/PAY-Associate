<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Leave Balance</title>
<link rel="shortcut icon" href="/PMS.ico" />
</head>

<body>


<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>

<cfquery name="total_aL" datasource="#DSNAME#">
SELECT sum(LVE_DAY) as sumal FROM pleave
 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
and LVE_TYPE = 'AL';
</cfquery>

<cfquery name="total_MC" datasource="#DSNAME#">
SELECT sum(LVE_DAY) as summc FROM pleave
 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
and LVE_TYPE = 'MC';
</cfquery>

<!--- <cfquery name="total_CC" datasource="#DSNAME#">
SELECT sum(LVE_DAY) as sumcc FROM pleave
 WHERE empno = "#emp_data.empno#"
and LVE_TYPE = 'CC';
</cfquery> --->

<cfset sumal = #val(total_aL.sumal)#>
<cfset summc = #val(total_MC.summc)#>
<!--- <cfset sumcc = #val(total_CC.sumcc)#> --->

<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        
        <h3>Leave Balance</h3>
        <table class="form" border="1">
        <tr>
        <th>Annual Leave</tH>
        <th>Medical Leave</th>
       <!---  <th>Child Care Leave</th> --->
        </tr>
        <tr>
        <td>#numberformat(val(emp_data.ALBF) + val(emp_data.ALALL) + val(emp_data.ALADJ)-sumal,'.__')#</td>
        <td>#numberformat(val(emp_data.MCALL)-summc,'.__')#</td>
        <!--- <td>#numberformat(val(emp_data.CCALL)-sumcc,'.__')#</td> --->
        </tr>
        </table>
        </div>
</div>
</cfoutput>
</body>
</html>
