<cfoutput>

<cfloop from="1" to="17" index="i">
<cfquery name="update_mdedtab" datasource="payroll">
UPDATE mdedtab SET
	   mded_desp = <cfqueryparam value="#evaluate('form.mded_desp__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   mded_link = <cfqueryparam value="#evaluate('form.mded_link__r#i#')#" cfsqltype="CF_SQL_varchar">
	   WHERE mded_cou = '#i#'
</cfquery>
</cfloop>

<cflocation url= "moreDeductionTableMain.cfm">

</cfoutput>

