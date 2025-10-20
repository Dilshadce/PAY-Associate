<cfoutput>
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EATXT5#" returnvariable="cfc_EATXT5" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EATXT6#" returnvariable="cfc_EATXT6" />	
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EX_42#" returnvariable="cfc_EX_42" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EXTRADATE1#" returnvariable="cfc_EXTRADATE1" />
<cfquery name="updateitaxea" datasource="#dts#">
	update itaxea set 
	amd_salary = "#val(form.amd_salary)#",
	amd_bonus = "#val(form.amd_bonus)#",
	amd_dif = "#val(form.amd_dif)#",
	amd_com = "#val(form.amd_com)#",
	amd_pen = "#val(form.amd_pen)#",
	amd_tran_alw = "#val(form.amd_tran_alw)#",
	amd_ent_alw = "#val(form.amd_ent_alw)#",
	amd_oth_alw = "#val(form.amd_oth_alw)#",
	amd_com_ret = "#val(form.amd_com_ret)#",
	amd_grat = "#val(form.amd_grat)#",
	amd_1993 = "#val(form.amd_1993)#",
	amd_1992 = "#val(form.amd_1992)#",
	amd_con_yer = "#val(form.amd_con_yer)#",
	amd_exces_yer = "#val(form.amd_exces_yer)#",
	amd_gain_prof = "#val(form.amd_gain_prof)#",
	amd_ben_kind = "#val(form.amd_ben_kind)#",
	amd_yee_cont_cpf = "#val(form.amd_yee_cont_cpf)#",
	amd_donation = "#val(form.amd_donation)#",
	amd_mbf = "#val(form.amd_mbf)#",
	amd_insur = "#val(form.amd_insur)#",
	amd_gain_profit = "#val(form.amd_gain_profit)#",
	
	<cfif #form.EX_38# eq "P">
		amd_tax_yer = "#val(form.amd_tax_yer)#",
	<cfelse>
		amd_tax_yer = 0,
	</cfif>	
	<cfif #form.EX_38# eq "H">
		amd_tax_yee = "#val(form.amd_tax_yee)#",
	<cfelse>
		amd_tax_yee = 0,	
	</cfif>
	
	amd_exe_tax_remi = "#val(form.amd_exe_tax_remi)#",
	EX_42 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EX_42#" >,
	EATXT5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EATXT5#" >,
	EATXT6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EATXT6#" >,
	EXTRADATE1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EXTRADATE1#" >,
	PBAYARAN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PBAYARAN#" >,
	EATXT9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EATXT9#" >,
	EX_38 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_38#" >
	where empno = "#form.empno#"
</cfquery>

<script language="javascript"> 
window.close()
</script>
</cfoutput>