<cffunction name="truncate" returntype="string" >
	        <cfargument name="stringget" type="any" required="yes">
	        <cfargument name="stringlen" type="any" required="yes">
            <cfset newstring = stringget>
			<cfif len(trim(stringget)) gte val(stringlen)+1>
            <cfset newstring = left(trim(stringget),stringlen)&"...">
            </cfif>            
			<cfreturn newstring>
</cffunction>