<cfoutput><cfinclude template="header.cfm">
<style type="text/css">
table.myTable {  border:1px solid black;border-collapse:collapse; }
table.myTable td, table.myTable th { border:1px solid black;padding = 3; }
</style>



<cfset id=''>
<cfset type=''>
<cfset short='DW'>
<cfset daycount = '1'>
<cfif isdefined('url.id')>
<cfquery name="get" datasource="#dts#">
SELECT * FROM dutyTask WHERE id = '#url.id#'
</cfquery>
<cfset id=url.id>
<cfset type=get.task>
<cfset short=get.short>
<cfset daycount = get.daycount>
</cfif>


<cfif isdefined('form.submit')>
<cfif form.action eq 'create'>
<cfquery name="insert" datasource="#dts#">
INSERT INTO dutyTask
(task,short,created_on,created_by,daycount)
VALUES
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.short#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getAuthuser()#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daycount#">)
</cfquery>
<cfelseif form.action eq 'edit'>
<cfquery name="insert" datasource="#dts#">
UPDATE dutyTask SET 
task=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,short=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.short#">,created_on=now(),created_by=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getAuthuser()#">,daycount = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daycount#">
WHERE id = '#form.id#'
</cfquery>

<cfelse>
<cfquery name="insert" datasource="#dts#">
DELETE FROM dutyTask 
WHERE id = '#form.id#'
</cfquery>


</cfif>
<script type="text/javascript">
alert('Success');
window.location.href='tasklist.cfm';
</script>









<cfelse>
<h4><u>Assign Duty Type</u></h4>
<a href="Tasklist.cfm">Duty Type List</a>
<form name="type" id="type" action="#cgi.SCRIPT_NAME#" method="post">
<input type="hidden" name="action" id="action" value="#url.type#">
<input type="hidden" name="id" id="id" value="#id#">
<table class="data" width="50%">
 <tr>
 <th>Day Type</th>
 <td>
 <select name="type" id="type" onchange="document.getElementById('short').value=this.value">
 <cfloop list="DW,PH,AL,MC,MT,CC,MR,CL,HL,EX,PT,AD,LS,NPL,NS,AB,NWD" index="a">
 <option value="#a#" <cfif type eq "a">Selected</cfif>>#a#</option>
 </cfloop>
 </select>
 </td>
 </tr>
  <tr>
 <th>Short Form</th>
 <td><input type="text" name="short" value="#short#" id="short">
 </td>
 </tr>
  <tr>
 <th>Day Count</th>
 <td><input type="text" name="daycount" value="#daycount#" id="daycount">
 </td>
 </tr>
 <tr>
 <td colspan="2">
 <input type="submit" name="submit" id= "submit"
 value="#url.type#"></table>
</form>
</cfif>
</cfoutput>