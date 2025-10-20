<cffunction name="dateformatnew" returntype="date" >
	        <cfargument name="dateget" type="any" required="yes">
	        <cfargument name="format" type="any" required="yes">
            <cfset datenew = createdate(listlast(dateget,'/'),listgetat(dateget,'2','/'),listfirst(dateget,'/'))>
            <cfset datenew = dateformat(datenew,format)>
			<cfreturn datenew>
</cffunction>