<cfif url.type eq "update">

<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT01#" returnvariable="cfc_EA2DAT01" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT02#" returnvariable="cfc_EA2DAT02" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT03#" returnvariable="cfc_EA2DAT03" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT04#" returnvariable="cfc_EA2DAT04" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT05#" returnvariable="cfc_EA2DAT05" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT06#" returnvariable="cfc_EA2DAT06" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT07#" returnvariable="cfc_EA2DAT07" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT08#" returnvariable="cfc_EA2DAT08" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT09#" returnvariable="cfc_EA2DAT09" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT10#" returnvariable="cfc_EA2DAT10" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT11#" returnvariable="cfc_EA2DAT11" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT12#" returnvariable="cfc_EA2DAT12" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT13#" returnvariable="cfc_EA2DAT13" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT14#" returnvariable="cfc_EA2DAT14" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT15#" returnvariable="cfc_EA2DAT15" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.EA2DAT16#" returnvariable="cfc_EA2DAT16" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.sec_83a#" returnvariable="cfc_sec_83a" />
<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.sec_83b#" returnvariable="cfc_sec_83b" />

<cfquery name="employeeUpdate" datasource="#dts#" >
UPDATE itaxea2

SET	EA2FIG01 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG01#" >,
	EA2FIG02 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG02#" >,
	EA2FIG03 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG03#" >,
	EA2FIG04 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG04#" >,
	EA2FIG05 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG05#" >,
	
	EA2FIG06 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG06#" >,
	EA2FIG07 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG07#" >,
	EA2FIG08 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG08#" >,
	EA2FIG09 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG09#" >,
	EA2FIG10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG10#" >,
	
	EA2FIG11 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG11#" >,			
	EA2FIG12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG12#" >,
	EA2FIG13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG13#" >,
	EA2FIG14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG14#" >,	
	EA2FIG15 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2FIG15#" >,

	EA2DAT01 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT01#" >,
	EA2DAT02 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT02#" >,
	EA2DAT03 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT03#" >,					
    EA2DAT04 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT04#" >,
	EA2DAT05 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT05#" >,
	EA2DAT06 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT06#" >,
	
	EA2DAT07 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT07#" >,
	EA2DAT08 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT08#" >,
	EA2DAT09 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT09#" >,
	EA2DAT10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT10#" >,
	EA2DAT11 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT11#" >,
	
	EA2DAT12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT12#" >,
	EA2DAT13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT13#" >,
	EA2DAT14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT14#" >,
	EA2DAT15 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT15#" >,
	EA2DAT16 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_EA2DAT16#" >,
	
	sec_5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_5)#" >,
	sec_6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_6)#" >,
	sec_7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_7)#" >,
	sec_8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_8)#" >,
	sec_9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_9)#" >,
	sec_10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_10)#" >,
	sec_11 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_11)#" >,
	sec_12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_12)#" >,
	sec_13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_13)#" >,
	sec_14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_14)#" >,
	sec_15 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_15)#" >,
	sec_16 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_16)#" >,
	sec_17 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_17)#" >,
	sec_18 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_18)#" >,
	sec_19 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_19)#" >,
	sec_20 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_20)#" >,
	sec_21 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_21)#" >,
	sec_22 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_22)#" >,
	sec_23 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_23)#" >,
	sec_24 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_24)#" >,
	sec_25 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_25)#" >,
	sec_26 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_26)#" >,
	sec_27 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_27)#" >,
	sec_28 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_28)#" >,
	sec_29 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_29)#" >,
	sec_30 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_30)#" >,
	sec_31 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_31)#" >,
	sec_32 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_32)#" >,
	sec_33 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_33)#" >,
	sec_34 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_34)#" >,
	sec_35 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_35)#" >,
	sec_36 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_36)#" >,
	sec_37 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_37)#" >,
	sec_38 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_38)#" >,
	sec_39 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_39)#" >,
	sec_40 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_40)#" >,
	sec_41 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_41)#" >,
	sec_42 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_42)#" >,
	sec_43 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_43)#" >,
	sec_44 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_44)#" >,
	sec_45 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_45)#" >,
	sec_46 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_46)#" >,
	sec_47 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_47)#" >,
	sec_48 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_48)#" >,
	sec_49 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_49)#" >,
	sec_50 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_50)#" >,
	sec_51 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_51)#" >,
	sec_52 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_52)#" >,
	sec_53 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_53)#" >,
	sec_54 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_54)#" >,
	sec_55 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_55)#" >,
	sec_56 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_56)#" >,
	sec_57 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_57)#" >,
	sec_58 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_58)#" >,
	sec_59 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_59)#" >,
	sec_60 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_60)#" >,
	sec_61 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_61)#" >,
	sec_62 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_62)#" >,
	sec_63 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_63)#" >,
	sec_64 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_64)#" >,
	sec_65 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_65)#" >,
	sec_66 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_66)#" >,
	sec_67 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_67)#" >,
	sec_68 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_68)#" >,
	sec_69 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_69)#" >,
	sec_70 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_70)#" >,
	sec_71 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_71)#" >,
	sec_72 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_72)#" >,
	sec_73 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_73)#" >,
	sec_74 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_74)#" >,
	sec_75 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_75)#" >,
	sec_76 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_76)#" >,
	sec_77 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_77)#" >,
	sec_78 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_78)#" >,
	sec_79 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_79)#" >,
	sec_80 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_80)#" >,
	sec_81 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_81)#" >,
	sec_82 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_82)#" >,

	sec_83a = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_sec_83a#" >,
	sec_83b = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfc_sec_83b#" >,
	
	<cfif isdefined('form.sec_84')>
	sec_84 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sec_84#" >,
	<cfelse>		
	sec_84 = <cfqueryparam cfsqltype="cf_sql_varchar" value="" >,
	</cfif>
	
	<cfif isdefined('form.sec_85')>	
	sec_85 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sec_85#" >,
	<cfelse>		
	sec_85 = <cfqueryparam cfsqltype="cf_sql_varchar" value="" >,
	</cfif>
	
	<cfif isdefined('form.sec_86')>	
	sec_86 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sec_86#" >,
	<cfelse>		
	sec_86 = <cfqueryparam cfsqltype="cf_sql_varchar" value="" >,
	</cfif>
	
	
	sec_88 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_88)#" >,
	sec_89 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.sec_89)#" >,
	
	
	
	EA2TXT01 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2TXT01#" >
		
	<cfif isdefined('form.EA2TXT02')>	
	,EA2TXT02 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EA2TXT02#" >
	<cfelse>
	,EA2TXT02 = <cfqueryparam cfsqltype="cf_sql_varchar" value="" >
	</cfif>	

WHERE  empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#" >
</cfquery>

<cfquery name="updateIR8S" datasource="#dts#">
	update itaxea set EX_44 = <cfqueryparam cfsqltype="cf_sql_varchar" value="Y" >,
	EA_EPFCEXT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sec_88#" >,
	EA_EPFWEXT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sec_89#" >
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
