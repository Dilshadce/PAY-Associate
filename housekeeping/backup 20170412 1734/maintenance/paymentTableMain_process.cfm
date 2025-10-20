<cfoutput>
<cfloop from="1" to="6" index="i">
<cfquery name="update_awtable" datasource="#dts#">
		
UPDATE awtable SET 
	   abcddepf = <cfif isdefined("form.abcddepf__r#i#")>'Y'<cfelse>'N'</cfif>,
	   abcdrepf = <cfif isdefined("form.abcdrepf__r#i#")>'Y'<cfelse>'N'</cfif>,
	   abcdrot = <cfif isdefined("form.abcdrot__r#i#")>'Y'<cfelse>'N'</cfif>,
	   abcd_epf = <cfif isdefined("form.abcd_epf__r#i#")>'1'<cfelse>'0'</cfif>
	   WHERE aw_cou= '#i#'
</cfquery>
</cfloop>
<cflocation url= "/housekeeping/maintenance/paymentTableMain.cfm">

</cfoutput>
