<cfoutput><cfinclude template="header.cfm">
<style type="text/css">
table.myTable {  border:1px solid black;border-collapse:collapse; }
table.myTable td, table.myTable th { border:1px solid black;padding = 3; }
</style>
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
  <script language="javascript" type="text/javascript" src="/javascripts/CalendarControlnew.js"></script>

<script type="text/javascript">
function markcurrentall(current,dateid,taskid,totalrow)
{
	for(var i = 1;i<=parseFloat(totalrow);i++)
	{
		document.getElementById('task'+i+taskid+':'+dateid).checked = current.checked;
	}
}
</script>

<cfquery name="general_qry" datasource="payroll_main">
SELECT mmonth,myear
FROM gsetup
where comp_id = '#HcomID#'
</cfquery>

<cfset date = createdate('#general_qry.myear#','#general_qry.mmonth#','1')>
<cfset lastdaysdate = createdate('#general_qry.myear#','#general_qry.mmonth#','#daysinmonth(date)#')>

<cfif isdefined('form.submit2')>
<cfset agentFrom = form.agentF>
<cfset agentTo = form.agentT>
<cfset dateF=form.dateF>
<cfset dateT=form.dateT>
<cfelseif isdefined('form.submit')>
<cfset agentFrom = form.agentF2>
<cfset agentTo = form.agentT2>
<cfset dateF=form.dateF2>
<cfset dateT=form.dateT2>
<cfelse>
<cfset agentFrom = ''>
<cfset agentTo = ''>
<cfset dateF=dateformat(date,'yyyy-mm-dd')>
<cfset dateT=dateformat(date,'yyyy-mm-dd')>
</cfif>

<cfquery name="getAgent" datasource="#dts#">
SELECT empno as agent,name FROM pmast
WHERE paystatus = "A"
<cfif agentFrom neq '' AND agentTo neq ''>
and empno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#agentFrom#"> AND <cfqueryparam cfsqltype="cf_sql_varchar" value="#AgentTo#">

</cfif>ORDER by empno
</cfquery>

<cfquery name="getAgentSelect" datasource="#dts#">
SELECT empno,name FROM pmast WHERE paystatus = "A" ORDER BY empno
</cfquery>



<cfif isdefined('form.submit')>
<cfloop list="#form.agent#" index="a" delimiters=",">
<cfloop from="#form.dateF2#" to="#form.dateT2#" index="c">
<cfquery name="check" datasource="#dts#">
SELECT * FROM DutyCalendar WHERE agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a#">
AND date = <cfqueryparam cfsqltype="cf_sql_date" value="#c#">
</cfquery>
<cfif check.recordcount eq 0>
<cfquery name="insert" datasource="#dts#">
INSERT INTO DutyCalendar
(agent,type,created_on,created_by,date)
VAlues
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#a#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['task#a##c#']#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getAuthuser()#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(c,'yyyy-mm-dd')#">
)
</cfquery>
<cfelse>
<cfquery name="update" datasource="#dts#">
UPDATE DutyCalendar SET
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['task#a##c#']#">
WHERE 
id = '#check.id#'
</cfquery>
</cfif>
</cfloop>
</cfloop>
<script type="text/javascript">
alert('Success');
<!--- window.location.href='assignDuty.cfm?date=#form.date#'; --->
</script>
</cfif>


<cfif isdefined('url.date')>
<cfset date = url.date>
</cfif>

<h4><u>Assignation Duty Roster Of The Month #dateformat(date,'mmmm')# Year #dateformat(date,'yyyy')#</u></h4>

<form name="assign2" id="assign2" method="post" action="">
<table>
<tr>
<th>Date From</th>
<td><input type="text" name="dateF" id="dateF" value="#dateformat(dateF,'yyyy-mm-dd')#">
&nbsp;
<img src="/images/cal.gif" size="30"
 border=0 onClick="showCalendarControl(document.getElementById('dateF'));">

</td>
<th>Date To</th>
<td><input type="text" name="dateT" id="dateT" value="#dateformat(dateT,'yyyy-mm-dd')#">
&nbsp;
<img src="/images/cal.gif" size="30"
 border=0 onClick="showCalendarControl(document.getElementById('dateT'));">

</td>
</tr>


<tr>
<th>Employee From</th>
<td><select name="agentF" id="agentF">
<option value="">Choose an Employee</option>
<cfloop query="getAgentSelect">
<option value="#getAgentSelect.empno#">#getAgentSelect.empno# - #getAgentSelect.name#</option>
</cfloop>
</select>
</td>
<th>Employee To</th>
<td>
<select name="agentT" id="agentT">
<option value="">Choose an Employee</option>
<cfloop query="getAgentSelect">
<option value="#getAgentSelect.empno#">#getAgentSelect.empno# - #getAgentSelect.name#</option>
</cfloop>
</select>
</td>
</tr>
<tr>
<td colspan="4">
<input type="submit" name="submit2" value="Ok" />
</td>
</tr>

<!--- <cfif checkAgent.recordcount gt 0>
<h5>Assigned</h5>
</cfif> --->

</table>
<form name="assign" id="assign" method="post" action="">
<input type="hidden" name="dateF2" id="dateF2" value="#fix(dateF)#" />
<input type="hidden" name="dateT2" id="dateT2" value="#fix(dateT)#" />
<input type="hidden" name="agentF2" id="agentF2" value="#agentFrom#" />
<input type="hidden" name="agentT2" id="agentT2" value="#agentTo#" />
<table width="80%" class="data">
<tr>
<td colspan="100%">
<h4>Date :#dateF# - #dateT#</h4>
</td>
</tr>
<tr>




<td></td><cfquery name="taskType" datasource="#dts#">
SELECT * FROM dutyTask 
</cfquery>
<cfloop from="#fix(dateF)#" to="#fix(dateT)#" index="a">
<th  <cfif dateformat(a,'ddd') eq "sun" or dateformat(a,'ddd') eq "sat">style="background-color:##F00"</cfif> colspan="#taskType.recordcount#">#dateformat(a,'dd/mmm/yy')#<br />
#dateformat(a,'ddd')#</th>
</cfloop>
<tr>


<th>Type</th>


<cfloop from="#fix(dateF)#" to="#fix(dateT)#" index="a">
<cfloop query="taskType">
<th>#tasktype.short#<br />
<input type="radio" name="markall#a#" id="markall#a#" onchange="markcurrentall(this,'#a#','#taskType.id#','#getagent.recordcount#')" />
</th>

</cfloop>
</cfloop>
</tr>


<cfloop query="getAgent">
<tr  onMouseOver="javascript:this.style.backgroundColor='99FF00';" onMouseOut="javascript:this.style.backgroundColor='';">
<td>

<input type="hidden" value="#getagent.agent#" name="agent" id="agent">
#getagent.agent#</td>
<cfquery name="get" datasource="#dts#">
SELECT id FROM dutyTask WHERE task = "DW"
</cfquery>

<cfloop from="#fix(dateF)#" to="#fix(dateT)#" index="a">
<cfquery name="checkAgent" datasource="#dts#">
select * from dutyCalendar WHERE date = '#dateformat(a,'yyyy-mm-dd')#'
</cfquery>
<cfset list = listfind(ValueList(checkAgent.agent),'#getagent.agent#')>
<cfloop query="taskType">
<td><input type="radio" 
<cfif list neq 0>
<cfif listgetat(ValueList(checkAgent.type),list) eq taskType.id>checked</cfif><CFELSEIF get.id eq tasktype.id>checked</cfif>  name="task#getAgent.agent##a#" id="task#getAgent.currentrow##taskType.id#:#a#" value="#taskType.id#"></td>
</cfloop>
</cfloop>
</tr>
<tr>
<td></td>
<td colspan="#taskType.recordcount#"></td>
</tr>
</cfloop> 
<tr><td colspan="#taskType.recordcount+1#"><input type="submit" name="submit" id="submit" value="Submit">
</td>
</tr>
</table>
</form>
<cfquery name="task" datasource="#dts#">
SELECT * FROM dutyTask
</cfquery>
<cfloop from="1" to="#task.recordcount#" step="6" index="ee">
<cfloop startrow="#ee#" endrow="#ee+5#" query="task">
<b>#task.task#</b> = #task.short#&nbsp;&nbsp;&nbsp;
</cfloop>
<br />
</cfloop>
</cfoutput>