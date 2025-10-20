<cfcomponent output="false">
	<cffunction name="select_cpf_tbl" access="public" returntype="any">
	<cfargument name="empno" required="yes">
	<cfargument name="db" required="yes">
	<cfargument name="comp_Auto_cpf" required="yes">
	<cfargument name="sys_date" required="yes">
		
		<cfquery name="select_empdata" datasource="#db#">
		SELECT R_STATU,national,pr_rate,dbirth,pr_from,epftbl from pmast where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
		
		</cfquery>
		
		<cfif comp_Auto_cpf eq "Y">
			
			<cfquery name="con_qry" datasource="#db#">
				SELECT 	entryno, epfcon1, epfcon2, epfcon3, epfcon4, epfcon5, epfcon6, epfcon7, epfcon8, epfcon9, epfcon10,
						epfcon11, epfcon12, epfcon13, epfcon14, epfcon15, epfcon16, epfcon17, epfcon18, epfcon19, epfcon20,
						epfcon21, epfcon22, epfcon23, epfcon24, epfcon25, epfcon26, epfcon27, epfcon28, epfcon29, epfcon30
				FROM rngtable where entryno = "1"
			</cfquery>
			<cfset epf_selected = 0>
			
			<cfloop from="1" to="30" index="i">
				<cfset con = "epfcon"&i>
				<cfset con = con_qry[#con#]>
				<cfset con = replace(con,"YY_PR()","pryear" ,"all")>
				<cfset con = replace(con,"NO_AGE()","age" ,"all")>
				<cfset con = replace(con,"NATIONAL","national" ,"all")>
				<cfset con = replace(con,"R_STATU","R_STATU" ,"all")>
				<cfset con = Replace(con,"<="," lte ","all") >
		        <cfset con = Replace(con,">="," gte ","all") >
		        <cfset con = Replace(con,">"," gt ","all") >
		        <cfset con = Replace(con,"<"," lt ","all") >
		        <cfset con = Replace(con,"="," eq ","all") >
				
				<cfset R_STATU = select_empdata.r_statu>
				<cfset national = select_empdata.national>
				<cfset PR_RATE = select_empdata.pr_rate>
				
				<cfif select_empdata.dbirth neq "">
					<cfset birthdate = Createdate(year(select_empdata.dbirth), month(select_empdata.dbirth), day(select_empdata.dbirth))>
					
					<cfset age_m = datediff("m",birthdate,sys_date)>
					<cfset age = age_m/12>
				<cfelse>
					<cfset age = 0>
				</cfif>
		       
		        <cfif select_empdata.pr_from neq "">
					<cfset pr_year = Createdate(year(select_empdata.pr_from), month(select_empdata.pr_from), day(select_empdata.pr_from))>
					<cfset pryear = datediff('yyyy',pr_year,sys_date)+1>
				<cfelse>
					<cfset pryear = 0>
				</cfif>
				
				<cfset condition = evaluate("#con#")>
				<cfif condition eq "YES" >
						
					<cfset epf_selected = i>
					
				</cfif>
				
			</cfloop>
			
		<cfelse>
			<cfset epf_selected = select_empdata.epftbl >
		</cfif>
	
	<cfreturn epf_selected>
	</cffunction>
	
	
	<cffunction name="Cal_cpf" access="public" returntype="any">
		<cfargument name="db" required="yes">
		<cfargument name="payin" required="yes">
		<cfargument name="epf_selected" required="yes">
		<cfargument name="empno" required="yes">
		<cfargument name="rng_amt" required="yes">
		
		<cfset cpf_array = ArrayNew(1)>
		
		
		<cfquery name="get_epf_fml" datasource="#db#">
        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #val(rng_amt)# AND EPFPAYT >= #val(rng_amt)#
        </cfquery>
		
		<cfset epf_entryno = get_epf_fml.entryno>    
        <cfquery name="get_epf" datasource="#db#">
        	SELECT * FROM rngtable WHERE entryno = "#epf_entryno#"
        </cfquery>
	        
        <cfquery name="get_epf1" datasource="#db#">
        	SELECT cpf_ceili FROM rngtable where entryno="1"
        </cfquery>
	        
        <cfif PAYIN gt #get_epf1.cpf_ceili#>
        	<cfset PAYIN = #get_epf1.cpf_ceili#>
		</cfif>
			
        <cfset epf_yee = #get_epf['epfyee#epf_selected#'][1]#>
        <cfset epf_yer = #get_epf['epfyer#epf_selected#'][1]#>
	    
		<cfset result1= #REReplace(epf_yee,"INT"," ", "all")#>
		<cfset EPFW = #val(evaluate(#result1#))#>
		
        <cfset result=#Replace(epf_yer,"ROUND"," ","all")#>
        <cfset epf_yer_result=#Replace(result,",0"," ","all")#>
       
    	<cfset EPFY=#val(evaluate(#epf_yer_result#))#>
	   
	    
        <!--- check epf pay all by employer --->
    	<cfquery name="select_empdata" datasource="#db#">
			SELECT epfbyer, epfbyee FROM pmast where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
		</cfquery>	
	
		<cfset pay_by = select_empdata.epfbyer>
        <cfif pay_by eq "Y">
        	 <cfset EPFY=#val(EPFY)# + #val(EPFW)#>
        	 <cfset EPFW = 0>
		</cfif>
		
		<cfset pay_by_yee = select_empdata.epfbyee>
		<cfif pay_by_yee eq "Y">
        	<cfset EPFW = #val(EPFY)# + #val(EPFW)#>
        	<cfset EPFY = 0 >
        </cfif>
			
		<cfset cpf_array[1]= EPFW >
		<cfset cpf_array[2]= EPFY >
		
		<cfreturn cpf_array>
	</cffunction>
</cfcomponent>