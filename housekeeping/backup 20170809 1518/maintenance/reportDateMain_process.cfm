<cfoutput>

<cfloop from="1" to="12" index="i">

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#evaluate('form.rpt_date_1__r#i#')#" returnvariable="cfc_date1" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#evaluate('form.rpt_date_2__r#i#')#" returnvariable="cfc_date2" />

<cfquery name="rdUpdate_qry" datasource="#dts#">
UPDATE awtable 
SET
	rpt_date_1 = <cfqueryparam value="#cfc_date1#" cfsqltype="cf_sql_date">,
	rpt_date_2 = <cfqueryparam value="#cfc_date2#" cfsqltype="cf_sql_date">,
	num_day_1 = <cfqueryparam value="#evaluate('form.num_day_1__r#i#')#" cfsqltype="cf_sql_smallint">
	WHERE aw_cou = '#i#'
	   
</cfquery>				
</cfloop>

<cflocation url="/housekeeping/maintenance/reportDateMain.cfm">
</cfoutput>



