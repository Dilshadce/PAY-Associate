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
            <cftry>
                <cfset symbol = "-">
                <cfset test = ListGetAt(tm, 2, "-")>
                <cfcatch type="any">
                    <cfset symbol = "_">
                </cfcatch>
            </cftry>
            <tr>
                <td>#ListGetAt(tm, 1, "#symbol#")#</td>
                <cfquery name="getname" datasource="#dts#">
                    SELECT empname FROM placement WHERE placementno = "#ListGetAt(tm, 1, "#symbol#")#"
                </cfquery>
                <td>#getname.empname#</td>
                <td>#ListGetAt(tm, 2, "#symbol#")#</td>
                <td>#ListGetAt(tm, 3, "#symbol#")#</td>
                <td><input type="text" class="inputText" id="mgmtremarks_#tm#" style="width: 100%"></td>
            </tr>
            <cfset rowcount += 1>
        </cfloop>
            
    </table>
</cfoutput>
