<cfsetting enablecfoutputonly="no">
<cfoutput><cfinclude template="header.cfm">
<style type="text/css">
table.myTable {  border:1px solid black;border-collapse:collapse; }
table.myTable td, table.myTable th { border:1px solid black;padding = 3; }
</style>


<cfif isdefined('form.submit')>
<cfset form.date  = createdate(form.year,form.month,1)>
<cfelse>
<cfset form.date  = now()>

</cfif>


<h4><u>Duty Roster Of The Month #dateformat(form.date,'mmmm')# Year #dateformat(form.date,'yyyy')#</u></h4>



<form name="date" id="date" action="#cgi.SCRIPT_NAME#" method="post">
<table>
<tr>
<th style="width:70px;">Year</th>
<td>

<select name="year" id="year" style="width:150px;">
<cfloop from="2000" to="2080" index="x">
<option value="#x#" <cfif x eq dateformat(form.date,'yyyy')>selected</cfif>> #x# </option>
</cfloop>
</select>
</td>
<th style="width:70px;">Month</th>
<td>

<select name="month" id="month" style="width:150px;">
<cfloop from="1" to="12" index="x">
<option value="#x#" <cfif x eq dateformat(form.date,'m')>selected</cfif>> #dateformat(createdate(2000,x,1),'mmm')# </option>
</cfloop>
</select>
</td>
<td><input type="submit" name="submit" id="submit" value="Go">
</td>
</tr>
</table>
<br>




<table class="myTable" width="100%">
<tr>

<th>Day</th>
<cfloop from="1" to="#DaysInMonth(form.date)#" index="a">
<th>#dateformat("#dateformat(form.date,'yyyy')#-#dateformat(form.date,'mm')#-#a#",'ddd')#</th>
</cfloop>
</tr>
<tr>

<th>Date</th>
<cfloop from="1" to="#DaysInMonth(form.date)#" index="a">
<th>#a#</th>
</cfloop>
</tr>
<cfquery name="getAgent" datasource="#dts#">
SELECT i.empno,i.name as agent,'' as desp,date,type,short FROM (SELECT name,empno FROM pmast WHERE paystatus = "A") AS i
LEFT JOIN 
(select type,short,date,agent from dutyCalendar AS m
LEFT JOIN
dutyTask AS t ON t.id = m.type)  
AS d ON  i.empno = d.agent
WHERE date_format(date,'%Y%m') = '#dateformat(form.date,'yyyymm')#'
GROUP BY i.empno
</cfquery>

<cfquery name="getAgent2" datasource="#dts#">
SELECT concat(name,':',date) as aa,'' as desp,date,task,type,short FROM (SELECT name,empno FROM pmast WHERE paystatus = "A") AS i
LEFT JOIN 
(select type,task,short,date,agent from dutyCalendar AS m
LEFT JOIN
dutyTask AS t ON t.id = m.type)  
AS d ON  i.empno = d.agent
WHERE date_format(date,'%Y%m') = '#dateformat(form.date,'yyyymm')#'

</cfquery>
<cfloop query="getAgent">
<tr>
<td>#getagent.agent#</td>
<cfloop from="1" to="#DaysInMonth(form.date)#" index="a">
<cfif a lt 10>
<cfset a= '0'&'#a#'>
</cfif>
<td>
<cfset list = listfind(valuelist(getagent2.aa),"#getagent.agent#:#dateformat(form.date,'yyyy')#-#dateformat(form.date,'mm')#-#a#")>
<cfif list neq 0>
<cfif listgetat(valuelist(getAgent2.date),list) eq "#dateformat(form.date,'yyyy')#-#dateformat(form.date,'mm')#-#a#">
#listgetat(valuelist(getAgent2.task),list)#
</cfif></cfif>
</td>
</cfloop>
</tr>
<!--- <tr>
<td>#getagent.agent#</td>
<cfloop from="1" to="#DaysInMonth(form.date)#" index="a">
<td></td>
</cfloop>
</tr> --->
</cfloop> 
</table>

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