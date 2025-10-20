<cfif isdefined ("url.type")>
<cfquery name="del_prTable" datasource="#dts#">
DELETE FROM pctab2
WHERE entryno = "#url.entryno#"
</cfquery>

<cfelse>
<cfif form.count gt "0">
<cfloop from="1" to="#form.count#" index="i">
<cfquery name="add_prTable" datasource="#dts#">
INSERT INTO pctab2 (pc_code, pc_desp, pc_xrate, pc_yrate)
VALUES ('#evaluate('nprcode__r#i#')#', '#evaluate('nprdesp__r#i#')#', '#evaluate('nxrate__r#i#')#', '#evaluate('nyrate__r#i#')#')
</cfquery>
</cfloop>

<cfelse>
<cfloop list="#form.entryno#" index="i">
<cfquery name="update_prTable" datasource="#dts#">
UPDATE pctab2
SET pc_code = "#evaluate('pccode__r#i#')#",
	pc_desp = "#evaluate('pcdesp__r#i#')#",
	pc_xrate = "#evaluate('xrate__r#i#')#",
	pc_yrate = "#evaluate('yrate__r#i#')#" 
WHERE entryno = #i#
</cfquery>
</cfloop>
</cfif>
</cfif>
<cflocation url="/housekeeping/maintenance/pieceRateTableMain.cfm">