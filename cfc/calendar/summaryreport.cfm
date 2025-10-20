<cfoutput>
<cfinclude template="header.cfm">
<cfquery name="general_qry" datasource="payroll_main">
SELECT mmonth,myear
FROM gsetup
where comp_id = '#HcomID#'
</cfquery>

<cfset date = createdate('#general_qry.myear#','#general_qry.mmonth#','1')>
<cfset lastdaysdate = createdate('#general_qry.myear#','#general_qry.mmonth#','#daysinmonth(date)#')>

<cfset dateF = dateformat(date,'YYYY-MM-DD')>
<cfset dateT = dateformat(lastdaysdate,'YYYY-MM-DD')>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
  <script language="javascript" type="text/javascript" src="/javascripts/CalendarControlnew.js"></script>
<cfif isdefined('form.submit2')>
<cfset dateF=form.dateF>
<cfset dateT=form.dateT>
</cfif>
<form name="assign2" id="assign2" method="post" action="">
<table>
<tr>
<th>Date From</th>
<td><input type="text" name="dateF" id="dateF" value="#dateformat(dateF,'yyyy-mm-dd')#">&nbsp;<img src="/images/cal.gif" size="30"
 border=0 onClick="showCalendarControl(document.getElementById('dateF'));">

</td>
<th>Date To</th>
<td><input type="text" name="dateT" id="dateT" value="#dateformat(dateT,'yyyy-mm-dd')#">&nbsp;<img src="/images/cal.gif" size="30"
 border=0 onClick="showCalendarControl(document.getElementById('dateT'));">

</td>
</tr>
<tr>
<td colspan="4">
<input type="submit" name="submit2" value="Ok" />
</td>
</tr></table>
</form>
<table>
<tr>
<th>No</th>
<th>Empno</th>
<th>Name</th>
<cfquery name="getnwd" datasource="#dts#">
SELECT id FROM dutytask WHERE task = "NWD"
</cfquery>
<cfquery name="getlist" datasource="#dts#">
SELECT * FROM dutytask WHERE task <> "NWD" GROUP BY TASK
</cfquery>
<cfloop query="getlist">
<th>#getlist.short#</th>
</cfloop>
</tr>

<cfquery name="GETDATA" datasource="#dts#">
SELECT agent,task,sum(coalesce(totaldays,0)*coalesce(daycount,0)) as totaldays FROM (
SELECT agent,type,count(type) as totaldays,date FROM dutycalendar WHERE id <> "#getnwd.id#" and date between <cfqueryparam cfsqltype="cf_sql_date" value="#dateF#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateT#"> GROUP BY agent,type ) as a
LEFT JOIN
(SELECT task,id,daycount FROM dutytask ) as b
on a.type = b.id
GROUP BY a.agent, b.task

</cfquery>
<cfquery name="allempno" datasource="#dts#">
SELECT empno, name FROM pmast WHERE paystatus = "A" order by empno
</cfquery>
<cfloop query="allempno">
<tr>
<td>#allempno.currentrow#</td>
<td>#allempno.empno#</td>
<td>#allempno.name#</td>
<cfloop query="getlist">
    <cfquery name="getdays" dbtype="query">
    	SELECT TOTALDAYS FROM GETDATA WHERE AGENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#allempno.empno#"> AND TASK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getlist.task#">
    </cfquery>
<cfif getdays.recordcount neq 0>
<cfif isdefined('form.paytbl')>
<cfquery name="updatepay" datasource="#dts#">
UPDATE #form.paytbl# SET #getlist.task# = "#val(getdays.totaldays)*val(getlist.daycount)#" WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#allempno.empno#">
</cfquery>
</cfif>
<td>#val(getdays.totaldays)*val(getlist.daycount)#</td>
<cfelse>
<cfif isdefined('form.paytbl')>
<cfquery name="updatepay" datasource="#dts#">
UPDATE #form.paytbl# SET #getlist.task# = "0" WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#allempno.empno#">
</cfquery>
</cfif>
<td>0</td>
</cfif>
</cfloop>
</tr>
</cfloop>
<tr>
</table>
<form name="post" id="post" action="" method="post" onSubmit="return confirm('Are You Sure You Want to Post?')">
<table>
<tr>
<th>Post into</th>
<td>
<select name="paytbl" id="paytbl">
<option value="paytra1">1st Half</option>
<option value="paytran">2nd Half</option>
</select>
</td>
<td>
<input type="submit" name="submit_btn" id="submit_btn" value="POST">
</td>
</tr>
</table>
</form>

</cfoutput>