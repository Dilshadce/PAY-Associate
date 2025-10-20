<cfquery name="relEdit_qry" datasource="#dts#">
UPDATE religion
SET RELDESP='#form.RELDESP#'
WHERE RELCODE='#form.RELCODE#'
</cfquery>

<cflocation url="/housekeeping/maintenance/religionTableForm.cfm">
