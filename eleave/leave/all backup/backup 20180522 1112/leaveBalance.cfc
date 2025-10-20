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
        SELECT sum(days) as days, leavetype
        FROM leavelist
        WHERE placementno = "#pno#"
        AND status IN ("Approved", "IN PROGRESS")
        AND leavetype IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#leavelist#">)
    </cfquery>
    
    <cfquery name="getLeaveEntitlement" datasource="#dts#">
    	SELECT *
        FROM placement
        WHERE placementno = "#pno#"
    </cfquery>
    
    <cfif (#getLeaveTaken.recordcount# eq 0) OR (#leave# eq 'NPL')> <!---if record not found 0 balance--->
       <!--- <cfif #leave# eq 'AL'>
    		<cfset leavebalance = val("#evaluate('getLeaveEntitlement.#leave#days')#") + val("#evaluate('getLeaveEntitlement.#leave#bfdays')#")>
		<cfelseif #leave# eq 'NPL'>
            <cfset leavebalance = 0>
        <cfelse>
            <cfset leavebalance = val("#evaluate('getLeaveEntitlement.#leave#days')#")>
        </cfif>--->
        <cfset leavetaken = 0>
    <cfelse>														<!---if record found, get value from leavelist as taken--->
    	<cfset leavetaken = #getLeaveTaken.days#>
    </cfif>
    
    <cfif #leave# eq 'AL' OR #leave# EQ 'EL'>
        <cfset leave = "AL">
    	<cfif #getLeaveEntitlement.albfable# eq 'Y'>
    		<cfset leavebalance = #val(evaluate('getLeaveEntitlement.#leave#days'))# + #val(evaluate('getLeaveEntitlement.#leave#bfdays'))# - #val(evaluate('leavetaken'))#>
    	<cfelse>
    		<cfset leavebalance = #val(evaluate('getLeaveEntitlement.#leave#days'))# - #val(evaluate('leavetaken'))#>
    	</cfif>
    <cfelseif #leave# eq 'NPL'>
        <cfset leavebalance = 0>
    <cfelse>
        <cfset leavebalance = #val(evaluate('getLeaveEntitlement.#leave#days'))# - #val(evaluate('#leavetaken#'))#>
    </cfif>
    
    <cfif #leavebalance# eq ''>										<!---if leavebalance from database is null, set to 0 balance--->
    	<cfset leavebalance = 0>
    </cfif>
    

    <cfset leave = structNew() />
    <cfset leave["balance"] = '#leavebalance#' >

	<cfreturn leave >
</cffunction>

