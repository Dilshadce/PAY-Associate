<cfoutput>
<cfquery name="meuUpdate_qry" datasource="#dts#">
UPDATE awtable 
SET meud_brate = <cfif isdefined("form.check1")>'Y'<cfelse>'N'</cfif>,
	meud_hol = <cfif isdefined("form.check2")>'Y'<cfelse>'N'</cfif>,
	meud_rdph = <cfif isdefined("form.check3")>'Y'<cfelse>'N'</cfif>,
	meud_leave = <cfif isdefined("form.check4")>'Y'<cfelse>'N'</cfif>,
	meud_loan = <cfif isdefined("form.check5")>'Y'<cfelse>'N'</cfif>,
	meud_mbr = <cfif isdefined("form.check6")>'Y'<cfelse>'N'</cfif>,
    MEUD_BRATEFLEX = <cfif isdefined("form.check7")>'Y'<cfelse>'N'</cfif>
WHERE aw_cou='1'
</cfquery>	

<cflocation url="/housekeeping/maintenance/monthEndUpdateTableMain.cfm">
</cfoutput>
