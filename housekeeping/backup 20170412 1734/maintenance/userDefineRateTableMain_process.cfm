<cfoutput>

<cfloop from="1" to="17" index="i">
<cfquery name="update_mawtab" datasource="#dts#">
	UPDATE awtable SET 
		   udrat_desp = <cfqueryparam value="#evaluate('form.udrat_desp__r#i#')#" cfsqltype="CF_SQL_varchar">
		   WHERE aw_cou = '#i#'
</cfquery>
</cfloop>
<cflocation url="/housekeeping/maintenance/userDefineRateTableMain.cfm">

</cfoutput>