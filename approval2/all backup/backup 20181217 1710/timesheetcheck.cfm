<cfsetting showdebugoutput="true">

<cfset dsname = "#dts#">
<cfset dts = "#Replace(dts, '_p', '_i')#">
<cfset rowcount = 1>
    
<cfoutput>
    <p>Enter remarks for all timesheet: <input type="text" id="mainRemarks" value="" onkeyup="$('.inputText').val(this.value);"></p>
    <table class="table table-hover table-striped table-responsive">
        <thead >
            <th>Placement<br>No</th>
            <th>Name</th>
            <th>Month</th>
            <th>Year</th>
            <th>Remarks (Manager)</th>
        </thead>
        
        <cfloop list="#form.timesheet#" index="tm" delimiters=",">  
            <tr>
                <td>#ListGetAt(tm, 1, "_")#</td>
                <cfquery name="getname" datasource="#dts#">
                    SELECT empname FROM placement WHERE placementno = "#ListGetAt(tm, 1, "_")#"
                </cfquery>
                <td>#getname.empname#</td>
                <td>#ListGetAt(tm, 2, "_")#</td>
                <td>#ListGetAt(tm, 3, "_")#</td>
                <td><input type="text" class="inputText" id="mgmtremarks_#tm#" style="width: 100%"></td>
            </tr>
            <cfset rowcount += 1>
        </cfloop>
            
    </table>
</cfoutput>
