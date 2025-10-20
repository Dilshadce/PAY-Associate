<cfoutput>

<cfloop from="1" to="17" index="i">
<cfquery name="update_mawtab" datasource="#dts#">
	UPDATE mawtab SET 
		   maw_desp = <cfqueryparam value="#evaluate('form.maw_desp__r#i#')#" cfsqltype="CF_SQL_varchar">,
		   maw_link = <cfqueryparam value="#evaluate('form.maw_link__r#i#')#" cfsqltype="CF_SQL_varchar">
		   WHERE maw_cou = '#i#'
</cfquery>
</cfloop>

<cflocation url="/housekeeping/maintenance/moreAllowanceTableMain.cfm">

</cfoutput>




<!--->ot_unit = <cfqueryparam value="#evaluate('form.ot_unit__r#i#')#" cfsqltype="CF_SQL_varchar">,
national = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.national#" --->