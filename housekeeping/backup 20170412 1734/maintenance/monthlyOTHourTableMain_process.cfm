<cfoutput>

<cfloop from="1" to="6" index="i">
	
<cfquery name="mOTHUpdate_qry" datasource="#dts#">
UPDATE ottable 
SET 
	XHRPYEAR01 = <cfqueryparam value="#evaluate('form.XHRPYEAR01__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR02 = <cfqueryparam value="#evaluate('form.XHRPYEAR02__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR03 = <cfqueryparam value="#evaluate('form.XHRPYEAR03__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR04 = <cfqueryparam value="#evaluate('form.XHRPYEAR04__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR05 = <cfqueryparam value="#evaluate('form.XHRPYEAR05__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR06 = <cfqueryparam value="#evaluate('form.XHRPYEAR06__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR07 = <cfqueryparam value="#evaluate('form.XHRPYEAR07__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR08 = <cfqueryparam value="#evaluate('form.XHRPYEAR08__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR09 = <cfqueryparam value="#evaluate('form.XHRPYEAR09__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR10 = <cfqueryparam value="#evaluate('form.XHRPYEAR10__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR11 = <cfqueryparam value="#evaluate('form.XHRPYEAR11__r#i#')#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR12 = <cfqueryparam value="#evaluate('form.XHRPYEAR12__r#i#')#" cfsqltype="CF_SQL_varchar">
WHERE OT_COU = '#i#'
</cfquery>

</cfloop>

<cflocation url ="/housekeeping/maintenance/monthlyOTHourTableMain.cfm">
</cfoutput>
