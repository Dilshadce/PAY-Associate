<cfquery name="raceEdit_qry" datasource="#dts#">
UPDATE race
SET RACEDESP='#form.RACEDESP#'
WHERE RACECODE='#form.RACECODE#'
</cfquery>

<cflocation url="/housekeeping/maintenance/raceTableForm.cfm">