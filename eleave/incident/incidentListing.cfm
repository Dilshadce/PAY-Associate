<cfoutput>
<cfset dts = replace(dsname,'_p','_i') >

<cfinvoke component="cfc.dateformat" method="DbDateFormat3" inputDate="#form.date#" returnvariable="cfc_date" />


<cfquery name="updateinc" datasource="#dts#">
INSERT into incident(placementno,empno,date,details,created_on)
values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#">,
<cfqueryparam cfsqltype="cf_sql_date" value="#cfc_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ePD#">,
now())
</cfquery>
</cfoutput>