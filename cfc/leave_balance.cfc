<cfcomponent>
	<cffunction name="leave_taken" access="public">
		<cfargument name="db" required="yes">
		<cfargument name="empno" required="no">
        <cfargument name="type" required="no">
			<cftry>
            <cfquery name="getmain" datasource="payroll_main">
SELECT myear FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(db,'_p','')#">
</cfquery>

			<cfquery name="sum_LVE_DAY" datasource="#db#">
				SELECT sum(coalesce(LVE_DAY,0)) as sum_taken
				from pleave
				where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				AND LVE_TYPE = "#type#" 
                and year(lve_date) = "#getmain.myear#"
			</cfquery>
			<cfset sum_taken = sum_LVE_DAY.sum_taken>
				<cfcatch type="any">
					<cfset sum_taken = "0.00">
				</cfcatch>
			</cftry>
		<cfreturn sum_taken>	
	</cffunction>
	
</cfcomponent>
