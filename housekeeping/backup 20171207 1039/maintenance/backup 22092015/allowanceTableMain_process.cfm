<cfoutput> 

<!---cfset arraya = ListToArray(form.aw_cou)>
<cfset arrayb = ListToArray(form.aw_desp)--->

<cfloop from="1" to="17" index="i">
<cfquery name="update_awtable" datasource="#dts#">
UPDATE awtable SET 
	   aw_desp = <cfqueryparam value="#evaluate('form.aw_desp__r#i#')#" cfsqltype="CF_SQL_varchar">,  
	   aw_note = <cfqueryparam value="#evaluate('form.aw_note__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_dbase = <cfqueryparam value="#evaluate('form.aw_dbase__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_type = <cfqueryparam value="#evaluate('form.aw_type__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_for = <cfqueryparam value="#evaluate('form.aw_for__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_rattn = <cfqueryparam value="#evaluate('form.aw_rattn__r1')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot1 = <cfif isdefined("form.aw_ot1__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_ot2 = <cfif isdefined("form.aw_ot2__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_ot3 = <cfif isdefined("form.aw_ot3__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_ot4 = <cfif isdefined("form.aw_ot4__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_ot5 = <cfif isdefined("form.aw_ot5__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_ot6 = <cfif isdefined("form.aw_ot6__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_epf = <cfif isdefined("form.aw_epf__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_tax = <cfif isdefined("form.aw_tax__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_pay = <cfif isdefined("form.aw_pay__r#i#")>'1'<cfelse>'0'</cfif>,
       aw_addw = <cfif isdefined("form.aw_addw__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_hrd = <cfif isdefined("form.aw_hrd__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_npl = <cfif isdefined("form.aw_npl__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_late = <cfif isdefined("form.aw_late__r#i#")>'1'<cfelse>'0'</cfif>,
	   aw_bonus = <cfif isdefined("form.aw_bonus__r#i#")>'1'<cfelse>'0'</cfif>
	   WHERE aw_cou= '#i#'
	   
</cfquery>
</cfloop>

<cflocation url= "/housekeeping/maintenance/allowanceTableMain.cfm">

</cfoutput>

<!---   aw_ot1 = <cfqueryparam value="#evaluate('form.aw_ot1__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot2 = <cfqueryparam value="#evaluate('form.aw_ot2__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot3 = <cfqueryparam value="#evaluate('form.aw_ot3__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot4 = <cfqueryparam value="#evaluate('form.aw_ot4__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot5 = <cfqueryparam value="#evaluate('form.aw_ot5__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_ot6 = <cfqueryparam value="#evaluate('form.aw_ot6__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_epf = <cfqueryparam value="#evaluate('form.aw_epf__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_tax = <cfqueryparam value="#evaluate('form.aw_tax__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_hrd = <cfqueryparam value="#evaluate('form.aw_hrd__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_npl = <cfqueryparam value="#evaluate('form.aw_npl__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_late = <cfqueryparam value="#evaluate('form.aw_late__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_bonus = <cfqueryparam value="#evaluate('form.aw_bonus__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   
	   aw_pay = <cfqueryparam value="#arguments.aw_pay#" cfsqltype="CF_SQL_varchar">,
	   aw_pay = <cfqueryparam value="#evaluate('form.aw_pay__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_note = <cfqueryparam value="#evaluate('form.aw_note__r#i#')#" cfsqltype="CF_SQL_varchar">, 
	   aw_dbase = <cfqueryparam value="#evaluate('form.aw_dbase__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_type = <cfqueryparam value="#evaluate('form.aw_type__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_for = <cfqueryparam value="#evaluate('form.aw_for__r#i#')#" cfsqltype="CF_SQL_varchar">,
	   aw_rattn = <cfqueryparam value="#evaluate('form.aw_rattn__r1#i#')#" cfsqltype="CF_SQL_varchar">--->