<cfoutput> 

<cfloop from="1" to="6" index="i">
<cfquery name="update_ottable" datasource="#dts#">
UPDATE ottable SET 
	   ot_desp = <cfqueryparam value="#evaluate('form.ot_desp__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_unit = <cfqueryparam value="#evaluate('form.ot_unit__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio = <cfqueryparam value="#evaluate('form.ot_ratio__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio2 = <cfqueryparam value="#evaluate('form.ot_ratio2__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio3 = <cfqueryparam value="#evaluate('form.ot_ratio3__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio4 = <cfqueryparam value="#evaluate('form.ot_ratio4__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio5 = <cfqueryparam value="#evaluate('form.ot_ratio5__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_ratio6 = <cfqueryparam value="#evaluate('form.ot_ratio6__r#i#')#" cfsqltype="CF_SQL_varchar">, 
	   ot_ratio7 = <cfqueryparam value="#evaluate('form.ot_ratio7__r#i#')#" cfsqltype="CF_SQL_varchar">, 
	   ot_ratio8 = <cfqueryparam value="#evaluate('form.ot_ratio8__r#i#')#" cfsqltype="CF_SQL_varchar">, 
	   ot_ratio9 = <cfqueryparam value="#evaluate('form.ot_ratio9__r#i#')#" cfsqltype="CF_SQL_varchar">, 
	   ot_const = <cfqueryparam value="#evaluate('form.ot_const__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const2 = <cfqueryparam value="#evaluate('form.ot_const2__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const3 = <cfqueryparam value="#evaluate('form.ot_const3__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const4 = <cfqueryparam value="#evaluate('form.ot_const4__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const5 = <cfqueryparam value="#evaluate('form.ot_const5__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const6 = <cfqueryparam value="#evaluate('form.ot_const6__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const7 = <cfqueryparam value="#evaluate('form.ot_const7__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const8 = <cfqueryparam value="#evaluate('form.ot_const8__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_const9 = <cfqueryparam value="#evaluate('form.ot_const9__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_mrate = <cfqueryparam value="#evaluate('form.ot_mrate__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_rtdec = <cfqueryparam value="#evaluate('form.ot_rtdec__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   ot_epf = <cfif isdefined("form.ot_epf__r#i#")>'1'<cfelse>'0'</cfif>,
	   ot_tax = <cfif isdefined("form.ot_tax__r#i#")>'1'<cfelse>'0'</cfif>,
	   ot_hrd = <cfif isdefined("form.ot_hrd__r#i#")>'1'<cfelse>'0'</cfif>
	   WHERE ot_cou= '#i#'
	   
</cfquery>
</cfloop>

<cflocation url= "/housekeeping/maintenance/overtimeTableMain.cfm">

</cfoutput>

<!---ot_rtdec = <cfqueryparam value="#evaluate('form.ot_rtdec__r#i#')#" cfsqltype="CF_SQL_varchar">,
<!--->UPDATE 	ottable 
			SET  
				OT_UNIT = <cfqueryparam value="#arguments.OT_UNIT#" cfsqltype="CF_SQL_varchar">,
				OT_DESP = <cfqueryparam value="#arguments.OT_DESP#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO = <cfqueryparam value="#arguments.OT_RATIO#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO2 = <cfqueryparam value="#arguments.OT_RATIO2#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO3 = <cfqueryparam value="#arguments.OT_RATIO3#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO4 = <cfqueryparam value="#arguments.OT_RATIO4#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO5 = <cfqueryparam value="#arguments.OT_RATIO5#" cfsqltype="CF_SQL_varchar">,
				OT_RATIO6 = <cfqueryparam value="#arguments.OT_RATIO6#" cfsqltype="CF_SQL_varchar">,
                ot_ratio7 = <cfqueryparam value="#arguments.OT_RATIO7#" cfsqltype="CF_SQL_varchar">, 
                ot_ratio8 = <cfqueryparam value="#arguments.OT_RATIO8#" cfsqltype="CF_SQL_varchar">, 
                ot_ratio9 = <cfqueryparam value="#arguments.OT_RATIO9#" cfsqltype="CF_SQL_varchar">, 
				OT_CONST = <cfqueryparam value="#arguments.OT_CONST#" cfsqltype="CF_SQL_varchar">,
				OT_CONST2 = <cfqueryparam value="#arguments.OT_CONST2#" cfsqltype="CF_SQL_varchar">,
				OT_CONST3 = <cfqueryparam value="#arguments.OT_CONST3#" cfsqltype="CF_SQL_varchar">,
				OT_CONST4 = <cfqueryparam value="#arguments.OT_CONST4#" cfsqltype="CF_SQL_varchar">,
				OT_CONST5 = <cfqueryparam value="#arguments.OT_CONST5#" cfsqltype="CF_SQL_varchar">,
				OT_CONST6 = <cfqueryparam value="#arguments.OT_CONST6#" cfsqltype="CF_SQL_varchar">,
                ot_const7 = <cfqueryparam value="#arguments.OT_RATIO7#" cfsqltype="CF_SQL_varchar">,
                ot_const8 = <cfqueryparam value="#arguments.OT_RATIO8#" cfsqltype="CF_SQL_varchar">,
                ot_const9 = <cfqueryparam value="#arguments.OT_RATIO9#" cfsqltype="CF_SQL_varchar">,
				
				OT_EPF = <cfqueryparam value="#arguments.OT_EPF#" cfsqltype="cf_sql_varchar">,
				
				OT_MRATE = <cfqueryparam value="#arguments.OT_MRATE#" cfsqltype="CF_SQL_varchar">,
				
				OT_TAX = <cfqueryparam value="#arguments.OT_TAX#" cfsqltype="CF_SQL_varchar">,
				OT_HRD = <cfqueryparam value="#arguments.OT_HRD#" cfsqltype="CF_SQL_varchar">
			WHERE OT_COU = <cfqueryparam value="#arguments.OT_COU#" cfsqltype="cf_sql_varchar"--->