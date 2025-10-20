<cfif isdefined ("url.type")>
<cfquery name="del_txtTable" datasource="#dts#">
DELETE FROM imptable
WHERE entryno = "#url.entryno#"
</cfquery>

<cfelse>
<cfif form.count gt "0">
<cfloop from="1" to="#form.count#" index="i">
<cfquery name="add_txtImpTable" datasource="#dts#">
INSERT INTO imptable (dfield, iformula)
VALUES ('#evaluate('ndfield__r#i#')#', '#evaluate('niformula__r#i#')#')
</cfquery>
</cfloop>

<cfelse>
<cfloop list="#form.entryno#" index="i">
<cfquery name="update_txtImpTable" datasource="#dts#">
UPDATE imptable
SET dfield = "#evaluate('dfield__r#i#')#",
	iformula = "#evaluate('iformula__r#i#')#"
WHERE entryno = #i#
</cfquery>
</cfloop>

</cfif>

</cfif>

<cflocation url="/housekeeping/maintenance/txtImportTableMain.cfm">