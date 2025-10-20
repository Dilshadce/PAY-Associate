<cfset status = "">
<cfif isdefined("url.type") and url.type eq 'pph21'>
<cfloop from="1" to="6" index="i">
<cfquery name="update_JHTTable" datasource="#dts#">
UPDATE rngtable
SET bjabat = "#evaluate("numberformat(form.bjabat_#i#/100,'.____')")#",
	bjabatcap = "#evaluate("numberformat(form.bjabatcap_#i#,'.__')")#",
	ptkpcode = "#evaluate("form.ptkpcode_#i#")#",
	ptkprange = "#evaluate("numberformat(form.ptkprange_#i#,'.__')")#",
    lpkp = "#evaluate("numberformat(form.lpkp_#i#/100,'.__')")#",
    lpkprange = "#evaluate("numberformat(form.lpkprange_#i#,'.__')")#",
    npwp = "#evaluate("numberformat(form.npwp_#i#/100,'.____')")#"
WHERE entryno = #i#
</cfquery>
</cfloop>
<cfset status = "Information saved">


<cfelseif isdefined("url.type") and url.type eq 'bpjs'>
<cfloop from="1" to="30" index="i">
<cfquery name="update_JHTTable" datasource="#dts#">
UPDATE rngtable
SET kesehatan = "#evaluate("numberformat(form.kesehatan_#i#/100,'.____')")#",
    kesehatancap = "#evaluate("numberformat(form.kesehatancap_#i#,'.__')")#",
    jkk = "#evaluate("numberformat(form.jkk_#i#/100,'.____')")#",
    jkm = "#evaluate("numberformat(form.jkm_#i#/100,'.____')")#",
	epfpayf = "#numberformat(payFrom,'.__')#",
	epfpayt = "#numberformat(payTo,'.__')#"
    <cfif i eq 1>
    <cfloop from="1" to="30" index="j">
	,epfyee#j# = "#evaluate('form.epfyee#j#')#"
	,epfyer#j# = "#evaluate('form.epfyer#j#')#"
    </cfloop>
    ,cpf_ceili = "#form.cNormal#"
	,tcpf_ceili = "#form.cBonus#"
    </cfif>
WHERE entryno = #i#
</cfquery>

</cfloop>
	<cfset status = "Information saved">
</cfif>

<cfif status neq "">
<cfoutput>
<script type="text/javascript">
	alert('#status#');

<cfif isdefined("url.type") and url.type eq "pph21">
    window.location="pph21tablemain.cfm";
<cfelseif isdefined("url.type") and url.type eq "bpjs">
    window.location="bpjstablemain.cfm";
	
</cfif> 
</script>
</cfoutput>
</cfif>

