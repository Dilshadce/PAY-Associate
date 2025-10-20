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
	   category3 = "#evaluate('form.category3#i#')#",
       
       <cfif i eq 1>
	   disab = "#form.disab#",
	   sdisab = "#form.sdisab#",
	   child18 = "#form.child18#",
	   childstdy = "#form.childstdy#",
	   childhedu = "#form.childhedu#",
	   cdisab = "#form.cdisab#",
	   cdisabstdy = "#form.cdisabstdy#",
	   cate1 = "#form.cate1#",
	   cate2 = "#form.cate2#",
	   cate3 = "#form.cate3#",
       epfcap = "#form.epfcap#",
       </cfif>
       
       updated_on = now(),
       updated_by = "#GetAuthUser()#"
	   WHERE entryno= '#i#'
</cfquery>
</cfloop>

<script type="text/javascript">
alert('Information Saved!');
history.go(-1);
</script>

</cfoutput>