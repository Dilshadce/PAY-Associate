<cfcomponent output="false">
	<cffunction name="calsocso" access="public" returntype="any">
		<cfargument name="empno" required="yes">
		<cfargument name="db" required="yes">
		<cfargument name="payrate" required="yes">
		
		<cfset socso_array = ArrayNew(1)>
		<cfquery name="emp_qry" datasource="#db#">
			SELECT socsono,socsotbl FROM pmast where empno="#empno#"
		</cfquery>
		
		
		<cfif emp_qry.socsono neq "" and emp_qry.socsotbl neq "">
			<cfset socsoyer_tbl = "socyer"&#emp_qry.socsotbl#>
			<cfset socsoyee_tbl = "socyee"&#emp_qry.socsotbl#>
			
			<cfquery name="socso_tbl_qry" datasource="#db#">
				SELECT #socsoyer_tbl#,#socsoyee_tbl# FROM rngtable 
				where socpayf <= #val(payrate)# and socpayt >=  #val(payrate)#
			</cfquery>
			
			 <cfset socso_yee = #socso_tbl_qry['#socsoyee_tbl#'][1]#>
		     <cfset socso_yer = #socso_tbl_qry['#socsoyer_tbl#'][1]#>
			
		<cfelse>
			 <cfset socso_yee = "0">
		     <cfset socso_yer = "0">
		</cfif>
		
		<cfset socso_array[1] = socso_yee >
		<cfset socso_array[2] = socso_yer>
		
	<cfreturn socso_array>
	</cffunction>
</cfcomponent>