<cfsetting showdebugoutput="true">

<cfset dsname = "#dts#">
<cfset dts = "#Replace(dts, '_p', '_i')#">
<cfset advanceleavecount = 0>
    
<cfquery name="getleavetype" datasource="#dts#">
    SELECT costcode FROM iccostcode
</cfquery>

<cfquery name="getleave" datasource="#dts#">
    SELECT a.id, a.leavetype, a.startdate, a.enddate, a.days, a.placementno,
    b.empname, b.startdate AS "begindate", b.completedate, b.albfdays, b.aldays
    <cfloop query="getleavetype">
        , b.#getleavetype.costcode#entitle , b.#getleavetype.costcode#totaldays, b.#getleavetype.costcode#earndays, b.#getleavetype.costcode#earntype
    </cfloop>
    FROM leavelist a
    LEFT JOIN placement b ON a.placementno = b.placementno
    WHERE a.id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#form.leave#">)
    ORDER BY b.empname, a.placementno ASC, a.startdate ASC
</cfquery>

<cfif "#getleave.recordcount#" NEQ 0 >
    <cfoutput>
        <p>Enter remarks for all leaves: <input type="text" id="mainRemarks" value="" onkeyup="$('.inputText').val(this.value);"></p>
        <table class="table table-hover table-striped table-responsive">
            <thead >
                <th>Placement<br>No</th>
                <th>Name</th>
                <th>Leave<br>Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Days</th>
                <th>Leave Type<br>Details</th>
                <th>Remarks (Manager)</th>
            </thead>
            <cfloop query="getleave">
                <cfset applicationType = "Earned Leave">
                <cfif #Evaluate('getleave.#getleave.leavetype#earndays')# EQ 'Y'>
                    <cfset contractdays = #DateDiff('d', "#DateFormat(getleave.begindate, 'yyyy-mm-dd')#", "#DateFormat(getleave.completedate, 'yyyy-mm-dd')#")# + 1>
                    <cfset leavedays = #Val(Evaluate('getleave.#getleave.leavetype#totaldays'))#>
                    <cfset currentdays = #DateDiff('d', "#DateFormat(getleave.begindate, 'yyyy-mm-dd')#", "#DateFormat(now(), 'yyyy-mm-dd')#")# + 1>
                        
                    <cfquery name="gettaken" datasource="#dts#">
                        SELECT SUM(days) AS taken FROM leavelist
                        WHERE leavetype = "#getleave.leavetype#"
                        AND placementno = "#getleave.placementno#"
                        AND status IN ("APPROVED", "IN PROGRESS")
                        AND startdate <= "#DateFormat(getleave.startdate, 'yyyy-mm-dd')#"
                    </cfquery>
                    
                    <cfif #Evaluate('getleave.#getleave.leavetype#earntype')# EQ "Up">
                        <cfset totalearned = ROUND(leavedays/contractdays*currentdays*2)/2>
                    <cfelse>
                        <cfset totalearned = INT(leavedays/contractdays*currentdays*2)/2>
                    </cfif>
                        
                    <cfif "#totalearned#" LT "#gettaken.taken#">
                        <cfset applicationType = "Advance Leave">
                        <cfset advanceleavecount += 1>
                    <cfelse>
                        <cfset applicationType = "Earned Leave">
                    </cfif>    
                </cfif>
                    
                <cfif "#applicationType#" EQ "Advance Leave">
                    <tr class="danger">
                <cfelse>
                    <tr>
                </cfif>
                    <td>#getleave.placementno#</td>
                    <td>#getleave.empname#</td>
                    <td>#getleave.leavetype#</td>
                    <td>#DateFormat(getleave.startdate, 'yyyy-mm-dd')#</td>
                    <td>#DateFormat(getleave.enddate, 'yyyy-mm-dd')#</td>
                    <td>#getleave.days#</td>
                    <td>#applicationType#</td>
                    <td><input type="text" class="inputText" id="mgmtremarks-#getleave.id#"></td>
                </tr>
            </cfloop>
        </table>
            
        <cfif #advanceleavecount# NEQ 0 >
            <script>
                advanceleavealert();
            </script>    
        </cfif>
    </cfoutput>
</cfif>