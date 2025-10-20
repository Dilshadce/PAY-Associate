<cfoutput>
<cfif isdefined('form.insert')>
<cfquery name="insertrow" datasource="#dts#">
INSERT INTO FWLTABLE (SECTOR,DC,WORKERCAT,MONTHLY,DAILY,TYPE)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fwl_sector#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fwl_DC#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fwl_workercat#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.fwl_monthly)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.fwl_daily)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fwl_type#">
)
</cfquery>
<cfelseif isdefined('url.action')>
<cfif url.action eq "delete">
<cfquery name="deletecom" datasource="#dts#">
DELETE FROM fwltable WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

</cfif>

<cfelse>

<cfquery name="getfwl" datasource="#dts#">
SELECT * FROM fwltable
</cfquery>

<cfloop query="getfwl">
<cfquery name="update_fwltable" datasource="#dts#">
	UPDATE FWLTABLE SET 
<cfif getfwl.id gt 22 or dts eq "empty_p">
       SECTOR=<cfqueryparam value="#evaluate('form.fwl_sector_#getfwl.id#')#" cfsqltype="CF_SQL_varchar">,
       DC=<cfqueryparam value="#evaluate('form.fwl_DC_#getfwl.id#')#" cfsqltype="CF_SQL_varchar">,
       WORKERCAT=<cfqueryparam value="#evaluate('form.fwl_WORKERCAT_#getfwl.id#')#" cfsqltype="CF_SQL_varchar">,
       TYPE = <cfqueryparam value="#evaluate('form.fwl_TYPE_#getfwl.id#')#" cfsqltype="CF_SQL_varchar">,
  </cfif>
       MONTHLY=<cfqueryparam value="#val(evaluate('form.fwl_MONTHLY_#getfwl.id#'))#" cfsqltype="cf_sql_integer">,
       DAILY=<cfqueryparam value="#val(evaluate('form.fwl_DAILY_#getfwl.id#'))#" cfsqltype="cf_sql_double">  
	WHERE id=<cfqueryparam value="#getfwl.id#" cfsqltype="cf_sql_integer">
</cfquery>
</cfloop>
</cfif>
<cflocation url="fwlTableMain.cfm">

</cfoutput>

