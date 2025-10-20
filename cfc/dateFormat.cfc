<cfcomponent>
	<cffunction name="DbDateFormat3" returntype="string">
		
		<cfargument name="inputDate" required="yes">	
		<cfset dd = dateformat(inputDate, 'DD')>
		
		<cfif dd greater than '0'>
		
		<cfif dd greater than '12'>
			<cfset date = dateformat(inputDate,"YYYY-MM-DD")>
		<cfelse>
			<cfset date = dateformat(inputDate,"YYYY-DD-MM")>
		
		</cfif>	
		<cfreturn date>
		<cfelse>
		<cfset date = "0000-00-00">
		<cfreturn date>
		</cfif>

		
 		
	</cffunction>
	<cffunction name="DbDateFormat2" returntype="string">
		
		<cfargument name="inputDate" required="yes">	
		<cfset dd = dateformat(inputDate, 'DD')>
		
		<cfif dd greater than '0'>
		
		<cfif dd greater than '12'>
			<cfset date = dateformat(inputDate,"YYYYMMDD")>
		<cfelse>
			<cfset date = dateformat(inputDate,"YYYYDDMM")>
		
		</cfif>	
		<cfreturn date>
		<cfelse>
		<cfset date = "0000-00-00">
		<cfreturn date>
		</cfif>

		
 		
	</cffunction>
	
	<cffunction name="DbDateFormat" returntype="string">
		<cfargument name="inputDate" required="yes">
		<cfset dd = dateformat(inputDate, 'DD')>
		<cfif dd greater than '0'>
		<cfif dd greater than '12'>
			<cfset date = dateformat(inputDate,"YYYYMMDD")>
		<cfelse>
			<cfset date = dateformat(inputDate,"YYYYDDMM")>
		
		</cfif>	
		<cfreturn date>
		<cfelse>
		<cfset date = "0000-00-00">
		<cfreturn date>
		</cfif>
	</cffunction>
	
	<cffunction name="AppDateFormat" returntype="string">
		<cfargument name="inputDate" required="yes">
		
 		<cfreturn dateformat(inputDate,"dd/mm/yyyy")>
	</cffunction>
	
	<cffunction name="getAppDateDay" output="true" returntype="string" hint="inputDate type is DD/MM/YYYY">
		<cfargument name="inputDate" required="yes">
		
		<cfreturn mid(inputDate,1,2)>
	</cffunction>
	
	<cffunction name="getAppDateMonth" output="true" returntype="string" hint="inputDate type is DD/MM/YYYY">
		<cfargument name="inputDate" required="yes">
		
		<cfreturn mid(inputDate,4,2)>
	</cffunction>
	
	<cffunction name="getAppDateYear" output="true" returntype="string" hint="inputDate type is DD/MM/YYYY">
		<cfargument name="inputDate" required="yes">
		
		<cfreturn mid(inputDate,7,4)>
	</cffunction>
</cfcomponent>	