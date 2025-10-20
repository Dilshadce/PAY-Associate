<cfif isdefined('url.uuid')>
<cfset dts = dsname>
<cfquery name="getempno" datasource="#dts#">
SELECT empno FROM emp_users WHERE 
username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<cfquery name="validateuuid" datasource="#dts#">
SELECT id FROM pdpauuid WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
AND given_to = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
AND given_ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
AND used_on = "0000-00-00 00:00:00"
</cfquery>

<cfif validateuuid.recordcount neq 1>
<cflocation url="/pdpa.cfm" addtoken="no">
<cfabort>
</cfif>

<cfquery name="updateused_on" datasource="#dts#">
UPDATE pdpauuid
SET used_on = now()
WHERE id = "#validateuuid.id#"
</cfquery>

<cfquery name="updatepdpa" datasource="#dts#">
INSERT INTO pdpaupdatelog
(
userid,
empno,
pdpa_agreed_on,
pdpa_agreed_ipaddress,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
)
</cfquery>

<cflocation url="/eform" addtoken="no">
</cfif>