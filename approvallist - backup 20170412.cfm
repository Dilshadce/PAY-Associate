<cfoutput>
<cfset dts2 = replace(dts,'_p','_i')>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<cfquery name="getsuperid" datasource="#dts_main#">
SELECT * FROM hmusers WHERE userCmpID = "#HcomID#" and entryID = "#HEntryID#"
</cfquery>
<cfquery name="getplacement" datasource="#dts2#">
	SELECT * FROM placement WHERE
    hrMgr = "#getsuperid.entryid#"
    AND completedate >= now()
    ORDER BY empname
</cfquery>
<table align="center" width="700px">
<tr>
<th>No.</th>
<th>Placement No</th>
<th>Candidate ID</th>
<th>Name</th>
<th>Start Date</th>
<th>End Date</th>
<th>View</th>
</tr>
<cfloop query="getplacement">
<tr  onMouseOver="this.style.backgroundColor='f3bd90';" onMouseOut="this.style.backgroundColor='';">
<td>#getplacement.currentrow#</td>
<td>#getplacement.placementno#</td>
<td>#getplacement.empno#</td>
<td>#getplacement.empname#</td>
<td>#dateformat(getplacement.startdate,'dd/mm/yyyy')#</td>
<td>#dateformat(getplacement.completedate,'dd/mm/yyyy')#</td>
<td><a target="_blank" href="/statusview/claimstatus.cfm?pno=#getplacement.placementno#">Claim Status</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a target="_blank" href="/statusview/leavestatus.cfm?pno=#getplacement.placementno#">Leave Status</a></td>
</tr>
</cfloop>
</table>
</cfoutput>
