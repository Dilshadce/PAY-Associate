<cfoutput> 

<!---cfset arraya = ListToArray(form.aw_cou)>
<cfset arrayb = ListToArray(form.aw_desp)--->

<cfloop from="1" to="8" index="i">
<cfquery name="update_pcbtable" datasource="#dts#">
UPDATE pcbtable SET 
	   pfrom = "#evaluate('form.pfrom#i#')#",
	   pto = "#evaluate('form.pto#i#')#",
	   mamount = "#evaluate('form.mamount#i#')#",
	   ramount = "#evaluate('form.ramount#i#')#",
	   category1 = "#evaluate('form.category1#i#')#",
	   category2 = "#evaluate('form.category2#i#')#",
	   category3 = "#evaluate('form.category3#i#')#"
	   WHERE entryno= '#i#'
	   
</cfquery>
</cfloop>

<script type="text/javascript">
	alert('Information updated!');
	window.location='LHDNTableMain.cfm'
</script>

</cfoutput>