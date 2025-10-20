<cfcomponent>

	    <cffunction name="BETWEEN" returntype="boolean">
        <cfargument name="grosspay1" type="numeric" required="yes">
        <cfargument name="value1" type="numeric" required="yes">
        <cfargument name="value2" type="numeric" required="yes">
        <cfif grosspay1 lte value2 and grosspay1 gte value1>
        <cfset total = true>
        <cfelse>
        <cfset total = false>
		</cfif>
		<cfreturn total>
        </cffunction>
        
	<cffunction name="updateBonus" access="public" returntype="any">
    	<cfargument name="db" required="yes">
		<cfargument name="empno" required="no">
        <cfargument name="db1" required="no">
        
        
        
        
       	<cfquery name="select_bonus" datasource="#db#">
       	SELECT * FROM pmast AS P LEFT JOIN bonus AS b ON p.empno = b.empno WHERE p.empno = "#empno#"
        </cfquery>
        <cfset basicpay = select_bonus.basicpay >
        <cfset epftbl = select_bonus.epftbl>
        <cfquery name="get_epf_fml" datasource="#db#">
       	 SELECT entryno FROM rngtable WHERE EPFPAYF <= "#val(basicpay)#" AND EPFPAYT >= "#val(basicpay)#"
        </cfquery>
        <cfset epf_entryno = get_epf_fml.entryno>
        <cfquery name="get_epf" datasource="#db#">
        SELECT * FROM rngtable WHERE entryno = "#epf_entryno#"
        </cfquery>
        
		<cfquery name="get_epf1" datasource="#db#">
        SELECT * FROM rngtable WHERE entryno="1"
        </cfquery>
		
		<cfquery name="get_emp_wages" datasource="#db#">
		SELECT EPF_PAY FROM pay_ytd WHERE empno="#empno#"
		</cfquery>
		
		<cfset total_ordinary = get_epf1.cpf_ceili * 12 >
		
		<cfset Estimated_AW_ceiling = val(get_epf1.tcpf_ceili)- val(total_ordinary) >
		
		
		<cfset PAYIN = #val(basicpay)#>
		
        <cfif PAYIN gt #Estimated_AW_ceiling#>
        	<cfset PAYIN = #Estimated_AW_ceiling#>
		</cfif>
		
		
        <cfset epf_yee = #get_epf['epfyee#epftbl#'][1]# >
        <cfset epf_yer = #get_epf['epfyer#epftbl#'][1]# >
        <cfset EPFW=#val(evaluate(#epf_yee#))#>
        <cfset result=#Replace(epf_yer,"ROUND","NumberFormat")#>
        <cfset EPFY=#val(evaluate(#result#))#>
        <cfset grosspay = #basicpay#>
        <cfset EPFPAY = EPFW + EPFY>
        <cfset NETPAY = #val(grosspay)# - #val(EPFW)#>	
        
<cfabort>
    	
		<cfquery name="update_bonus" datasource="#db#">
        UPDATE bonus SET EPFWW = "#numberformat(EPFW,'.__')#" , EPFCC = "#numberformat(EPFY,'.__')#", GROSSPAY = "#numberformat(grosspay,'.__')#", EPF_PAY = "#numberformat(EPFPAY,'.__')#", NETPAY = "#numberformat(NETPAY,'.__')#" WHERE empno = "#empno#"
        </cfquery>
        
		<cfquery name="update_pay_tm" datasource="#db#">
		UPDATE pay_tm SET epf_pay_b = "#numberformat(NETPAY,'.__')#", B_EPFWW = "#numberformat(val(EPFW),'.__')#", B_EPFCC = "#numberformat(val(EPFY),'.__')#" WHERE empno = "#empno#"
		</cfquery>
		
		
		<cfset myResult = "success">
		<cfreturn myResult>
	</cffunction>
</cfcomponent>