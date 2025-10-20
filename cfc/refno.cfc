<cfcomponent>
	<cffunction name="processNum" access="public" returntype="string">
		<cfargument name="oldNum" type="string" required="yes">
			<cfset var on2="">
			<cfset var onLen=len(arguments.oldNum)>
			<cfset var nf="">
			
			<cfloop from="1" to="#onLen#" index="i">
				<cfif Not isValid("regex", right(arguments.oldNum,i), "^{0,1}[0-9]+[\d]*")>
					<cfset on2=i-1>
					<cfbreak>
				<cfelse>
					<cfset nf=nf&"0">
				</cfif>
			</cfloop>
			
			<cfif on2 neq 0 and on2 neq "">
				<cfset on2=left(arguments.oldNum,(onLen-on2))&NumberFormat(right(arguments.oldNum,on2)+1,nf)>
			<cfelse>
				<cfset on2=NumberFormat(val(arguments.oldNum)+1,nf)>
			</cfif>
		<cfreturn on2>
	</cffunction>
	
	<cffunction name="resetRefno" access="public" returntype="string">
		<cfargument name="oldNum" type="string" required="yes">
			<cfset var on2="">
			<cfset var onLen=len(arguments.oldNum)>
			<cfset var nf="">
			
			<cfloop from="1" to="#onLen#" index="i">
				<cfif Not isValid("regex", right(arguments.oldNum,i), "^{0,1}[0-9]+[\d]*")>
					<cfset on2=i-1>
					<cfbreak>
				<cfelse>
					<cfset nf=nf&"0">
				</cfif>
			</cfloop>
			
			<cfif on2 neq 0 and on2 neq "">
				<cfset on2=left(arguments.oldNum,(onLen-on2))&NumberFormat("0",nf)>
			<cfelse>
				<cfset on2=NumberFormat("0",nf)>
			</cfif>
		<cfreturn on2>
	</cffunction>
</cfcomponent>