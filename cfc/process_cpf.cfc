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
				<cfset con = Replace(con,"!="," neq ","all") >
		        <cfset con = Replace(con,"="," eq ","all") >
                
				
				<cfset R_STATU = select_empdata.r_statu>
				<cfset national = select_empdata.national>
				<cfset PR_RATE = select_empdata.pr_rate>
				
				<cfif select_empdata.dbirth neq "">
					<cfset birthdate = Createdate(year(select_empdata.dbirth), month(select_empdata.dbirth),'1')>
					
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
        <cfargument name="addwages" required="no">
        <cfargument name="ccode" required="no">
		
		<cfset cpf_array = ArrayNew(1)>
		
		
		<cfquery name="get_epf_fml" datasource="#db#">
        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #val(rng_amt)# AND EPFPAYT >= #val(rng_amt)#
        </cfquery>
		
		<cfset epf_entryno = get_epf_fml.entryno>    
        <cfquery name="get_epf" datasource="#db#">
        	SELECT * FROM rngtable WHERE entryno = "#epf_entryno#"
        </cfquery>
	        
        <cfquery name="get_epf1" datasource="#db#">
        	SELECT cpf_ceili,tcpf_ceili FROM rngtable where entryno="1"
        </cfquery>
        
        <cfset oldpayin = PAYIN>
    <!---     <cfif PAYIN lte #get_epf1.cpf_ceili#>
        <cfelse> --->
			<cfif isdefined('addwages')>
            <cfif payin neq val(addwages)>
            <cfset newpayin = payin - val(addwages)>
            
                <cfif newpayin lte #get_epf1.cpf_ceili#>
                <cfset PAYIN = newpayin>
                <cfelse>
                <cfset PAYIN = #get_epf1.cpf_ceili#>
                </cfif>
            </cfif>
            <cfelse>
            <cfset PAYIN = #get_epf1.cpf_ceili#>
            </cfif>
			<cfset paypayin = PAYIN>
	<!--- 	</cfif> --->
			
        
		   <!--- <cfset EPFWORI = EPFW>
           <cfset EPFYORI = EPFY> --->
           
           <cfif isdefined('addwages') <!--- and oldpayin gt #get_epf1.cpf_ceili# ---> >
           <cfset ADDPAYIN = val(addwages)>
           <cfif val(addwages) gt 0 and val(addwages) neq val(oldpayin) >
           <cfquery name="getaddceiling" datasource="#db#">
           SELECT tcpf_ceili FROM rngtable where entryno="1"
           </cfquery>
           
           <cfif val(addwages) gt val(getaddceiling.tcpf_ceili) - (val(PAYIN) * 12)>
           <cfset addwages = val(getaddceiling.tcpf_ceili) - (val(PAYIN) * 12)>
           </cfif>
           
           <cfquery name="getaddallow" datasource="#db#">
            SELECT aw_cou FROM awtable WHERE aw_addw <> 0
            </cfquery>
            
            <cfquery name="gettotalepf" datasource="#db#">
            SELECT coalesce(epf_pay_b,0)+coalesce(epf_pay_c,0) as totalepf 
            <cfif getaddallow.recordcount neq 0>
            ,<cfloop query="getaddallow">coalesce(AW#val(getaddallow.aw_cou)+100#,0)<cfif getaddallow.currentrow neq getaddallow.recordcount>+</cfif></cfloop>
            <cfelse>
            ,"0"
            </cfif>
            as totaladdaw
            from pay_ytd WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
            </cfquery>
            
            <cfquery name="getyearbrate" datasource="#db#">
            SELECT brate FROM pmast WHERE empno =<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
            </cfquery>
            
            <cfset yearlypay = val(getyearbrate.brate) * 12>
            <cfif val(yearlypay) gt (val(get_epf1.cpf_ceili)*12)>
            <cfset yearlypay = (val(get_epf1.cpf_ceili)*12)>
            </cfif> 
            <cfset addallow = val(get_epf1.tcpf_ceili) - val(yearlypay)>
            
            <cfif val(addallow) - (val(gettotalepf.totalepf) + val(gettotalepf.totaladdaw)) lte 0>
				<cfset addwages = 0>
            <cfelse>
                <cfset leftover = val(addallow) - (val(gettotalepf.totalepf) + val(gettotalepf.totaladdaw))>
                <cfif val(addwages) gt val(leftover)>
                <cfset addwages = val(leftover)>
                </cfif> 
            </cfif>
       
       
       
       <cfset ADDPAYIN = val(addwages)>
       
       <!--- <cfset EPFW =#val(evaluate(#result1#))#>
       <cfset EPFY=#val(evaluate(#epf_yer_result#))#>
       <cfset EPFW = EPFW + EPFWORI>
       <cfset EPFY = EPFY + EPFYORI> --->
       <cfelse>
       <cfset ADDPAYIN = 0>
	   </cfif>
	   </cfif>
       
       
       <cfif isdefined('ADDPAYIN')>
       <cfset PAYIN = PAYPAYIN + ADDPAYIN>
       <cfelse>
       <cfset PAYIN = PAYPAYIN>
	   </cfif>
       <cfset PAYIN = numberformat(PAYIN,'.__')>
       

       <cfset epf_yee = #get_epf['epfyee#epf_selected#'][1]#>
       <cfset epf_yer = #get_epf['epfyer#epf_selected#'][1]#>

       <cfif ccode eq "MY" and rng_amt lte 5000>
           <cfset eyee = replace(listlast(#get_epf['epfyee#epf_selected#'][1]#,'*'),')','','all')>
           <cfset eyer = replace(listlast(#get_epf['epfyer#epf_selected#'][1]#,'*'),')','','all')>
           <cfset epf_yee = ceiling(payin*eyee)>
           <cfset epf_yer = ceiling(payin*eyer)>
       </cfif>
       
<!---         <cfquery name="getbasicpayvalid" datasource="#db#">
        SELECT basicpay FROM pay_tm WHERE empno =<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery> --->
        
        
        
        <!--- <cfif val(getbasicpayvalid.basicpay) eq 0> --->
        <cfset result1=epf_yee>
        <!--- <cfelse>
		<cfset result1= #REReplace(epf_yee,"INT"," ", "all")#>
        </cfif> --->
		<cfset EPFW = #val(evaluate(#result1#))#>
		
       <!---  <cfif val(getbasicpayvalid.basicpay) eq 0> --->
        <cfset result=epf_yer>
		<!--- <cfelse>
        <cfset result=#Replace(epf_yer,"ROUND"," ","all")#>
        </cfif> --->
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
				<cfquery name="select_empdata" datasource="#db#">
			SELECT epfbyer, epfbyee FROM pmast where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
		</cfquery>	
		<cfset cpf_array[1]= EPFW >
		<cfset cpf_array[2]= EPFY >
		<cfreturn cpf_array>
	</cffunction>
</cfcomponent>