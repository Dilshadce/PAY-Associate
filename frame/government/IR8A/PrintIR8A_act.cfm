<cfif url.type eq "update">

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.BONUSDATE1#" returnvariable="cfc_BONUSDATE1" />

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EXTRADATE1#" returnvariable="cfc_EXTRADATE1" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EATXT5#" returnvariable="cfc_EATXT5" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EATXT6#" returnvariable="cfc_EATXT6" />

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.appr_date#" returnvariable="cfc_appr_date" />

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EX_42#" returnvariable="cfc_EX_42" />

<cfquery name="employeeUpdate" datasource="#dts#" >
UPDATE itaxea

SET	BONUSDATE1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_BONUSDATE1#" >,
	EXTRADATE1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EXTRADATE1#" >,
	EATXT5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EATXT5#" >,
	EATXT6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EATXT6#" >,
	
	EA_AW_T = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_AW_T)#" >,
	EA_AW_E = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_AW_E)#" >,
	EA_AW_O = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_AW_O)#" >,
	EA_AW = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_AW)#" >,
	EA_EPFCEXT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_EPFCEXT)#" >,
	EA_DED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EA_DED)#" >,
	
	COM_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COM_ADD#" >,			
	EATXT8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EATXT8#" >,
	EATXT9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EATXT9#" >,
	PBAYARAN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PBAYARAN#" >,
	
	ecfig05 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ecfig05,'.__')#" >,
	ecfig06 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ecfig06,'.__')#" >,
	ecfig07 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ecfig07,'.__')#" >,
	ecfig08 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ecfig08,'.__')#" >,
	ecfig09 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ecfig09,'.__')#" >,
	ECFIG10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ECFIG10,'.__')#" >,
	
	EAFIG02 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.EAFIG02,'.__')#" >,
	EAFIG05 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.EAFIG05,'.__')#" >,
	EAFIG06= <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.EAFIG06,'.__')#" >,
	EAFIG07 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.EAFIG07,'.__')#" >,
	
	<cfif isdefined('form.yesno')>appr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.yesno#" >,
	<cfelse> appr = <cfqueryparam cfsqltype="cf_sql_varchar" value="No" >,	</cfif>
	
	<cfif isdefined('form.yesno')>
	appr_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_appr_date#" >,
	</cfif>
	
	ins_ded = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.ins_ded,'.__')#" >,
	EX_33 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EX_33)#" >,
	EX_34 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EX_34)#" >,
	EX_35 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EX_35)#" >,
	
	<cfif isdefined('form.EX_37')>EX_37 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_37#" >,
	<cfelse>EX_37 = <cfqueryparam cfsqltype="cf_sql_varchar" value="N" >,	</cfif>
			
	EX_38 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_38#" >,
	
	<cfif isdefined('form.EX_41')>EX_41 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_41#" >,
	<cfelse>EX_41 = <cfqueryparam cfsqltype="cf_sql_varchar" value="N" >,	</cfif>	
		
	EX_42 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EX_42#" >,
	
	<cfif isdefined('form.EX_44')>EX_44 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_44#" >,
	<cfelse>EX_44 = <cfqueryparam cfsqltype="cf_sql_varchar" value="N" >,	</cfif>	

	EX_45 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_45#" >,
	EX_56 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.EX_56)#" >,
	EX_70 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EX_70#" >
	
	
	
	
	
	
	
WHERE  empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#" >
</cfquery>




<cfwindow name="error" title="Employee profiles" modal="true" closable="true" width="250" height="160" center="true" initShow="true" >
	<p>Employee's Profile was successfully updated.</p>
	<p>
	<cfform><input type="button" onClick="ColdFusion.Window.hide('error')" value="Ok"></cfform>
	
	</p>
	</cfwindow>



<cfelseif url.type eq "create">
</cfif>

<script language="javascript"> 
window.close()
</script>