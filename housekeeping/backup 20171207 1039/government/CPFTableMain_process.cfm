<cfloop from="1" to="30" index="i">
<cfquery name="update_CPFTable" datasource="#dts#">
UPDATE rngtable
SET epfpayf = "#numberformat(payFrom,'.__')#",
	epfpayt = "#numberformat(payTo,'.__')#",
	epfyee#i# = "#evaluate('form.epfyee#i#')#",
	epfyer#i# = "#evaluate('form.epfyer#i#')#"
WHERE entryno = #url.e#
</cfquery>
</cfloop>

<cfquery name="update_pay" datasource="#dts#">
UPDATE rngtable
SET	cpf_ceili = "#form.cNormal#",
	tcpf_ceili = "#form.cBonus#"
WHERE entryno = "1"
</cfquery>
<cflocation url="/housekeeping/government/CPFTableMain.cfm">