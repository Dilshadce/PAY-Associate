<cfcomponent>
	<cffunction name="paytype" access="public" returntype="string">
		<cfargument name="pay" type="string" required="yes">
        <cfset pay_type="MONTHLY">
        <cfif pay eq "M">
		<cfset pay_type="MONTHLY">
        <cfelseif pay eq "D">
        <cfset pay_type="DAILY">
        <cfelseif pay eq "H">
        <cfset pay_type="HOURLY">
        </cfif>
		<cfreturn pay_type>
	</cffunction>
    
    <cffunction name="paymeth" access="public" returntype="string">
    
		<cfargument name="pay_method" type="string" required="yes">
        <cfset pay_meth="BANK">
		<cfif pay_method eq "B">
		<cfset pay_meth="BANK">
        <cfelseif pay_method eq "C">
        <cfset pay_meth="CASH">
        <cfelseif pay_method eq "Q">
        <cfset pay_meth="CHEQUE">
        </cfif>
		<cfreturn pay_meth>
	</cffunction>
    
</cfcomponent>