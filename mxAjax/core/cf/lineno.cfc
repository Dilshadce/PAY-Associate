<cfcomponent extends="mxAjax">
	<cffunction name="checkLineExist" returntype="struct">
		<cfargument name="code" type="string">
		<cfargument name="dts" type="string">
		
		<cfset var qryData="">
		<cfset var retData = StructNew()>
		<cfset retData.exist=false>
		
		<cfif arguments.code neq "">
			<cfquery datasource="#dts#" name="qryData">
				SELECT lineno
				FROM tlineno
				WHERE lineno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#">
			</cfquery>
			
			<cfif qryData.recordcount>
				<cfset retData.exist=true>
				<cfset retData.message="This Line No. #UCase(arguments.code)# already EXISTS!">
			</cfif>
		</cfif>
		
		<cfreturn retData>
	</cffunction>
</cfcomponent>