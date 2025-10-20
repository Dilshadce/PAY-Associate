<cfcomponent>
<cfsetting showdebugoutput="no">
<cffunction name="updateDesp" access="remote" returntype="any">
	<cfset menu_id=form.id>
	<cfset desp=form.desp>
	<cfset desp = REReplace(desp, "\r\n|\n\r|\n|\r", "<br />", "all")>
	<cftry>
	<cfquery name="getGsetup" datasource="#dts#">
		SELECT dflanguage FROM gsetup
	</cfquery>
	<cfif getGsetup.dflanguage NEQ "english">
		<cfset titledesp="titledesp_"&getGsetup.dflanguage>	
	<cfelse>
		<cfset titledesp="titledesp">
	</cfif>
	<cfquery name="updateDesp" datasource="mainams">
		UPDATE menunew2
		SET
			#titledesp#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#desp#">,
			updated_by=<cfqueryparam cfsqltype="cf_sql_varchar" value="#authUser#">,
			updated_on=NOW()
		WHERE menu_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#menu_id#">
	</cfquery>
		<cfcatch type="any">
			<cfreturn "<b style='color:red;'>Error occurred during update menu description. Please try again.</b>">
		</cfcatch>
	</cftry>	
	<cfreturn desp>
</cffunction>
</cfcomponent>