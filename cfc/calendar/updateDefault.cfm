<cfquery name="get" datasource="#dts#">
UPDATE generalSetup SET
dutyDefault = '#url.id#'
</cfquery>