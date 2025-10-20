<cfcomponent>
<cffunction name="sum_fwl" access="public" returntype="Any">	
	<cfargument name="empno" required="yes">
	<cfargument name="db" required="yes">
	<cfargument name="compid" required="yes">
	<cfargument name="db_main" required="yes">
	
	<cfquery name="gsetup_qry" datasource="#db_main#">
		Select c_acfwl from gsetup where comp_id="#compid#"
	</cfquery>
	
	<cfquery name="emp_qry" datasource="#db#">
		SELECT fwlevytbl,fwlevymtd,fwlevyadj FROM pmast where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	</cfquery>
	
	<cfif emp_qry.fwlevytbl neq "" and gsetup_qry.c_acfwl eq "1">
		<cfif emp_qry.fwlevymtd eq "M">
			<cfquery name="fwl_qry" datasource="#db#">
				SELECT monthly as levy_m FROM fwltable where id = "#emp_qry.fwlevytbl#"
			</cfquery>
			
			<cfset FWL = round(val(fwl_qry.levy_m))>
			
			<cfquery name='update_fwlevy' datasource="#db#">
				update comm set levy_fw_w = #FWL# where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
		<cfelse>
			<cfquery name="fwl_qry" datasource="#db#">
				SELECT DAILY as levy_d FROM fwltable where id = "#emp_qry.fwlevytbl#"
			</cfquery>
			<cfquery name="pay_tm_qry" datasource="#db#">
				SELECT dw FROM pay_tm where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
			<cfset day_fwl = val(pay_tm_qry.dw) + val(emp_qry.fwlevyadj)>
			
			<cfset FWL = numberformat(val(fwl_qry.levy_d)* val(day_fwl),'.__')>
<!---			<cfif db eq "imiqgroup_p" and empno eq '1408'>
            <cfoutput>
            #fwl#<br>
			#day_fwl#<br>
#emp_qry.fwlevyadj#<br>
			#fwl_qry.levy_d#            
            </cfoutput>
            <cfabort>
            </cfif>--->
			<cfquery name='update_fwlevy' datasource="#db#">
				update comm set levy_fw_w = #FWL# where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
		</cfif>
     <cfelse>
     <cfquery name='update_fwlevy' datasource="#db#">
				update comm set levy_fw_w = 0 where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
	</cfif>
	<cfreturn "fwl">
	</cffunction>
</cfcomponent>