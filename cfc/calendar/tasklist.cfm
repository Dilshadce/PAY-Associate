<cfoutput><cfinclude template="header.cfm">
<style type="text/css">
table.myTable {  border:1px solid black;border-collapse:collapse; }
table.myTable td, table.myTable th { border:1px solid black;padding = 3; }
</style>

<script type="text/javascript" src="/scripts/ajax.js">

</script>

<cfquery name="get" datasource="#dts#">
SELECT * FROM dutyTask 
</cfquery>
<h4>Duty Type List</h4>
<a href="assignTask.cfm?type=create">Assign new Duty Type</a>

<table width="50%" class="data">
<tr>
<th>No.</th>
<th>Duty Type</th>
<th>Short Form</th>

<th>Action</th>
</tr>
<cfloop query="get">
<tr>
<td>#get.currentrow#</td>
<td>#get.task#</td>
<td>#get.short#</td>


<td>
<a target="_parent" href="assignTask.cfm?type=Edit&amp;id=#get.id#">
		             <img height="18px" width="18px" src="/images/Edit.png" alt="edit" border="0">Edit
		              </a>
                      
                     
                      &nbsp;
                      <a target="_parent" href="assignTask.cfm?type=Delete&amp;id=#get.id#">
		             <img height="18px" width="18px" src="/images/cancel.png" alt="delete" border="0">Delete
		              </a>
</td>
</tr>
</cfloop>
</table>

</cfoutput>
