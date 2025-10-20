<cfcomponent>
	<cffunction name="costbaseproj" access="public" returntype="any">
            <cfargument name="db" type="any" required="yes">
            <cfargument name="empno" type="any" required="yes">
            <cfargument name="project" type="any" required="yes">
             <cfquery name="sum_proj_qry" datasource="#db#">
                SELECT sum(TOT_DW) as sum_dw from proj_pay WHERE empno="#empno#"
             </cfquery>
             <cfquery name="proj_qry" datasource="#db#">
                SELECT TOT_DW from proj_pay WHERE empno="#empno#" and project="#project#"
             </cfquery>
            <cfquery name="pay_qry" datasource="#db#">
                select netpay from paytran where empno = "#empno#"
            </cfquery>
            <cfif val(sum_proj_qry.sum_dw) eq "0">
            	<cfset sum_dw = 1>
            <cfelse>
            	<cfset sum_dw = sum_proj_qry.sum_dw>
			</cfif>
            <cfset proj_pay = val(pay_qry.netpay) / val(sum_dw) * val(proj_qry.TOT_DW)>
		 	<cfquery name="update_proj_pay" datasource="#db#">
            	update proj_pay set total_pay = #proj_pay#
                WHERE empno="#empno#"and project="#project#"
            </cfquery>
		<cfreturn proj_pay>
	</cffunction>
</cfcomponent>