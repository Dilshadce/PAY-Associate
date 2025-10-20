<cfcomponent extends="mxAjax">
	<cffunction name="checkCBookingExist" returntype="struct">
		<cfargument name="refno" type="string">
		<cfargument name="cc" type="string">
		
		<cfset var qryData="">
		<cfset var retData = StructNew()>
		<cfset retData.exist=false>
		
		<cfif arguments.refno neq "">
			<cfquery datasource="ss" name="qryData">
				SELECT JOB_REF
				FROM JOB 
				WHERE JOB_REF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
			</cfquery>
			
			<cfif qryData.recordcount>
				<cfset retData.exist=true>
				<cfset retData.message="Your Booking No. #UCase(arguments.refno)# already EXISTS!">
			</cfif>
		</cfif>
		
		<cfreturn retData>
	</cffunction>
</cfcomponent>