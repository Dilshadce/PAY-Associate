<cfoutput> 

<cfloop from="1" to="15" index="i">
<cfquery name="update_dedtable" datasource="#dts#">
UPDATE dedtable SET 
	   ded_desp = "#evaluate('form.ded_desp__r#i#')#",
	   ded_mem = "#evaluate('form.ded_mem__r#i#')#",
	   ded_type = "#evaluate('form.ded_type__r#i#')#",
	   ded_for = "#evaluate('form.ded_for__r#i#')#",
	   ded_fig1 = "#evaluate('form.ded_fig1__r1')#",
	   ded_fig2 = "#evaluate('form.ded_fig2__r1')#",
	   ded_pay = <cfif isdefined("form.ded_pay__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   ded_ot = <cfif isdefined("form.ded_ot__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   ded_epf = <cfif isdefined("form.ded_epf__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   ded_tax = <cfif isdefined("form.ded_tax__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   ded_hrd = <cfif isdefined("form.ded_hrd__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   ded_npl = <cfif isdefined("form.ded_npl__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
	   DED_FOR_USE = <cfif isdefined("form.DED_FOR_USE__r#i#")>'1.00'<cfelse>'0.00'</cfif>,
       ded_rmk = <cfqueryparam value="#evaluate('form.rmk#i#')#" cfsqltype="CF_SQL_varchar"> 
	   WHERE ded_cou= '#i#'

</cfquery>
</cfloop>

<cflocation url= "/housekeeping/maintenance/deductionTableMain.cfm">

</cfoutput>


<!---UPDATE 	dedtable 
			SET
				DED_DESP = <cfqueryparam value="#arguments.DED_DESP#" cfsqltype="CF_SQL_varchar">,
				
				DED_OT = <cfqueryparam value="#arguments.DED_OT#" cfsqltype="CF_SQL_varchar">,
				DED_EPF = <cfqueryparam value="#arguments.DED_EPF#" cfsqltype="CF_SQL_varchar">,
				DED_TAX = <cfqueryparam value="#arguments.DED_TAX#" cfsqltype="CF_SQL_varchar">,
				DED_HRD = <cfqueryparam value="#arguments.DED_HRD#" cfsqltype="CF_SQL_varchar">,
				DED_NPL = <cfqueryparam value="#arguments.DED_NPL#" cfsqltype="CF_SQL_varchar">,
				
				DED_PAY = <cfqueryparam value="#arguments.DED_PAY#" cfsqltype="CF_SQL_varchar">,
				DED_MEM = <cfqueryparam value="#arguments.DED_MEM#" cfsqltype="CF_SQL_varchar">,
				DED_TYPE = <cfqueryparam value="#arguments.DED_TYPE#" cfsqltype="CF_SQL_varchar">,
				DED_FOR = <cfqueryparam value="#arguments.DED_FOR#" cfsqltype="CF_SQL_varchar">,
				DED_FIG1 = <cfqueryparam value="#arguments.DED_FIG1#" cfsqltype="CF_SQL_varchar">,
				DED_FIG2 = <cfqueryparam value="#arguments.DED_FIG2#" cfsqltype="CF_SQL_varchar">
			WHERE DED_COU = <cfqueryparam value="#arguments.DED_COU#" cfsqltype="cf_sql_varchar"--->