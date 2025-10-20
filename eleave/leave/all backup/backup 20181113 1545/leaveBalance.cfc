<cffunction name="getBalance" access="remote" returnFormat="json">
    <cfargument name="pno" type="string" required="yes" />
    <cfargument name="dts" type="string" required="yes" />
    <cfargument name="leave" type="string" required="yes" />
    <cfset leavebalance = 0>
	<cfset leavetaken = 0>
    
    <cfif #leave# EQ "EL">
        <cfset leavelist = "AL,EL">
    <cfelse>
        <cfset leavelist = "#leave#">        
    </cfif>
    
    <cfquery name="getLeaveTaken" datasource="#dts#">
        SELECT pm.placementno, pm.startdate, pm.completedate, ll.leavetype, COALESCE(taken, 0) AS taken 
        <cfloop list="#leavelist#" index="typeleave">
            ,pm.#typeleave#totaldays, pm.#typeleave#earndays, pm.#typeleave#earntype
        </cfloop>
        FROM placement pm
        LEFT JOIN
        (
            SELECT placementno, leavetype, COALESCE(SUM(days), 0) AS taken 
            FROM leavelist
            WHERE status IN ("APPROVED", "IN PROGRESS")
            AND leavetype IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#leavelist#">)
            AND placementno = "#pno#"
        ) ll ON pm.placementno = ll.placementno
        WHERE pm.placementno = "#pno#"
        <!---SELECT sum(days) as days, leavetype
        FROM leavelist
        WHERE placementno = "#pno#"
        AND status IN ("Approved", "IN PROGRESS")
        AND leavetype IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#leavelist#">)--->
    </cfquery>
    
    <cfif #leave# eq 'AL' OR #leave# EQ 'EL'>
        <cfset leave = "AL">
    </cfif>
        
    <cfset leavedays = #Val(Evaluate('getLeaveTaken.#leave#totaldays'))#>
        
    <cfif #leave# eq 'NPL'>
        <cfset leavebalance = 0>
    <cfelse>
        <cfset leavebalance = #Val(leavedays)# - #Val(Evaluate('getLeaveTaken.taken'))#>
    </cfif>
        
    <cfset earnleave = "#Evaluate('getLeaveTaken.#leave#earndays')#">    
        
    <cfif "#earnleave#" EQ "Y">
        <cfset contractdays = #DateDiff('d', "#DateFormat(getLeaveTaken.startdate, 'yyyy-mm-dd')#", "#DateFormat(getLeaveTaken.completedate, 'yyyy-mm-dd')#")# + 1>
        <cfset currentdays = #DateDiff('d', "#DateFormat(getLeaveTaken.startdate, 'yyyy-mm-dd')#", "#DateFormat(now(), 'yyyy-mm-dd')#")# + 1>
        
        <cfif #Evaluate('getLeaveTaken.#leave#earntype')# EQ "Up">
            <cfset totalearned = ROUND(leavedays/contractdays*currentdays*2)/2>
        <cfelse>
            <cfset totalearned = INT(leavedays/contractdays*currentdays*2)/2>
        </cfif>
    <cfelse>
        <cfset totalearned = "#leavedays#">
    </cfif>
        
    <cfset leave = structNew() />
    <cfset leave["balance"] = '#leavebalance#' >
    <cfset leave["earnedleaves"] = "#totalearned#">
    <cfset leave["totaltaken"] = #Val(Evaluate('getLeaveTaken.taken'))#>    
    <cfset leave["earningleave"] = "#earnleave#">    
    <cfset leave["leaveentitlement"] = "#leavedays#">    

	<cfreturn leave >
</cffunction>

