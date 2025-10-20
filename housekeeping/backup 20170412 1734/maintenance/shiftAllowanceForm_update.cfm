<cfoutput>
<cfquery name="shftableUpdate" datasource="#dts#" >
UPDATE shftable
SET	  	SHF_DESP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHF_DESP#" >,
		SHIFT1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT1#" >,
		SHIFT2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT2#" >,
		SHIFT3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT3#" >,
		SHIFT4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT4#" >,
		SHIFT5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT5#" >,
		SHIFT6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT6#" >,
		SHIFT7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT7#" >,
		SHIFT8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT8#" >,
		SHIFT9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT9#" >,
		SHIFT10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT10#" >,
		SHIFT11 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT11#" >,
		SHIFT12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT12#" >,
		SHIFT13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT13#" >,
		SHIFT14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT14#" >,
		SHIFT15 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT15#" >,
		SHIFT16 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT16#" >,
		SHIFT17 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT17#" >,
		SHIFT18 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT18#" >,
		SHIFT19 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT19#" >,
		SHIFT20 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT20#" >,
		SHIFT_D1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D1#" >,
		SHIFT_D2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D2#" >,
		SHIFT_D3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D3#" >,
		SHIFT_D4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D4#" >,
		SHIFT_D5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D5#" >,
		SHIFT_D6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D6#" >,
		SHIFT_D7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D7#" >,
		SHIFT_D8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D8#" >,
		SHIFT_D9 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D9#" >,
		SHIFT_D10 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D10#" >,
		SHIFT_D11 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D11#" >,
		SHIFT_D12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D12#" >,
		SHIFT_D13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D13#" >,
		SHIFT_D14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D14#" >,
		SHIFT_D15 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D15#" >,
		SHIFT_D16 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D16#" >,
		SHIFT_D17 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D17#" >,
		SHIFT_D18 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D18#" >,
		SHIFT_D19 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D19#" >,
		SHIFT_D20 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHIFT_D20#" >
WHERE  	SHF_COU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SHF_COU#" >
</cfquery> 		

<cflocation url ="/housekeeping/maintenance/shiftAllowanceForm.cfm">
</cfoutput>

	 