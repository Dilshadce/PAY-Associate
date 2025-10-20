<cfset alertlist = "">
<cfset uuid= createuuid()>
<cfset uuid = replace(uuid,'-','','all')>
<cfset filenewdir = "C:\Inetpub\wwwroot\payroll\download\#dts#\">
<cfif DirectoryExists(filenewdir) eq false>
<cfdirectory action = "create" directory = "#filenewdir#" >
</cfif>
<cffunction name="SPACE" returntype="string">
	        <cfargument name="value1" type="numeric" required="yes">
			<cfset reval="">
	         	<cfloop from="1" to="#value1#" index="i">
					<cfset reval = reval&" ">
				</cfloop>
			<cfreturn reval>
</cffunction>
<cftry>
<cfquery name="getComp_qry" datasource="#dts_main#">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset year_sys = getComp_qry.myear>

<cfquery name="getList_qry" datasource="#dts#">
	SELECT * FROM(SELECT * FROM pmast p where year(dresign) >= #year_sys# or dresign is null or dresign ="0000-00-00") as pm 
	left join itaxea as pt on pt.empno = pm.empno
	WHERE 0=0
    AND pm.confid >= #hpin#
	  <cfif form.empnoFrom neq ""> AND pm.empno >= '#form.empnoFrom#' </cfif>
	  <cfif form.empnoTo neq ""> AND pm.empno <= '#form.empnoTo#' </cfif>
	  <cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
	  and itaxcat <> "X"
      <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0 or (coalesce(ea_aw_t,0)+coalesce(ea_aw_e,0)+coalesce(ea_aw_o,0))<> 0  or coalesce(FLOOR(EA_COMM),0)+coalesce(FLOOR(EAFIG02),0)+coalesce(FLOOR(EA_AW_T),0)+coalesce(FLOOR(EA_AW_E),0)
	+coalesce(FLOOR(EA_AW_O),0)+coalesce(FLOOR(ecfig05),0)+coalesce(FLOOR(EAFIG05),0)+coalesce(FLOOR(EAFIG06),0)+
	coalesce(FLOOR(EA_EPFCEXT),0)+coalesce(FLOOR(EAFIG08),0)+coalesce(FLOOR(EAFIG09),0) <> 0 )</cfif>
	  order by pm.empno
</cfquery>
	
<cfset total_record_count = -1 >
		<cfset source ="#getComp_qry.source#" >
		<cfif source eq "Mindef">	
			<cfset source =  "1">
		<cfelseif source eq "Government">
			<cfset source =  "4">
		<cfelseif source eq "Statutory">
			<cfset source =  "5">
		<cfelseif source eq "Private">
			<cfset source =  "6">
		<cfelseif source eq "Others">
			<cfset source =  "9">
		</cfif>
	
		<cfif getComp_qry.myear neq "">
			<cfset basic_year="#getComp_qry.myear#">
		</cfif>
	
		<cfset orgIDtype="#getComp_qry.Organization_ID_Type#">
		<cfif orgIDtype eq  "UEN">
			<cfset orgIDtype = "7">
		<cfelseif orgIDtype eq  "UEN2">
			<cfset orgIDtype = "8">
		<cfelseif orgIDtype eq  "ASGD">
			<cfset orgIDtype = "A">
		<cfelseif orgIDtype eq  "ITR">
			<cfset orgIDtype = "I">
		<cfelseif orgIDtype eq  "GSTN">
			<cfset orgIDtype = "G">
		<cfelseif orgIDtype eq  "UENO">
			<cfset orgIDtype = "U">
		</cfif>
	
	
		<cfif getComp_qry.UEN neq "">
			<cfset uentry = replace(getComp_qry.UEN, "-","","all")>
			<cfset uen = uentry>
			<cfloop condition="len(uen) lt 12">
				<cfset uen = uen&" " >
			</cfloop>
            <cfif len(uen) gt 12>
            <cfset alertlist=alertlist&"UEN number is more than 12 characters<br />">
			</cfif>
        <cfelse>
        	<cfoutput>
            <h2>COMPANY's UEN is EMPTY<br />
Please kindly fill in COMPANY UEN at HouseKeeping > Parameter Setup to Proceed</h2>
            </cfoutput>
            <cfabort>
		</cfif>
	
		<cfif getComp_qry.authorised_name neq "">
			<cfset authorised_name = "#getComp_qry.authorised_name#">
			<cfloop condition="len(authorised_name) lt 30">
				<cfset authorised_name = authorised_name&" " >
			</cfloop>
            
            <cfif len(authorised_name) gt 30>
            <cfset alertlist=alertlist&"Authorised Name is more than 30 characters<br />">
			</cfif>
           
        <cfelse>
        <cfoutput>
            <h2>Name of authorised person is EMPTY<br />
Please kindly fill in Name of authorised person at HouseKeeping > Parameter Setup to Proceed</h2>
            </cfoutput>
            <cfabort>
        
		</cfif>
	
		<cfif getComp_qry.pm_name neq "">
		<cfset Des_of_au_person ="#getComp_qry.pm_name#">
			<cfloop condition="len(Des_of_au_person) lt 30">
				<cfset Des_of_au_person = Des_of_au_person&" " >
			</cfloop>
            <cfif len(Des_of_au_person) gt 30>
            <cfset alertlist=alertlist&"Designation of Authorised Person is more than 30 characters<br />">
			</cfif>
		<cfelse>
			<cfset Des_of_au_person ="                              ">
		</cfif>
	
	
		<cfif getComp_qry.comp_name neq "">
			<cfset name_emp = "#getComp_qry.comp_name#">
			<cfloop condition="len(name_emp) lt 60">
				<cfset name_emp = name_emp&" " >
			</cfloop>
		</cfif>
	
		<cfif getComp_qry.comp_phone neq "">
			<cfset comp_phone ="#getComp_qry.comp_phone#">
			<cfloop condition="len(comp_phone) lt 20">
				<cfset comp_phone = comp_phone&" " >
			</cfloop>
		<cfelse>
			<cfset comp_phone =space(20)>
		</cfif>
        
        <cfif getComp_qry.authorised_email neq "">
			<cfset authorised_email ="#getComp_qry.authorised_email#">
			<cfloop condition="len(authorised_email) lt 60">
				<cfset authorised_email = authorised_email&" " >
			</cfloop>
		<cfelse>
			<cfset authorised_email =space(60)>
		</cfif>
		
			<cfset Batch_Ind = "O">
	
		<cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.bdate#" returnvariable="cfc_bdate" />
	
		<cfif BDate neq "">
			<cfset BDate = "#cfc_bdate#">
			<cfset now ="#dateformat(now(),'YYYYMMDD')#">
			<cfif #BDate# lt #now# >
				<cfset Bdate = #BDate# >
			</cfif>
		</cfif>
	
		<cfset Name_of_Division="#getComp_qry.Name_of_Division#">
		<cfif #Name_of_Division# neq "">
			<cfloop condition="len(Name_of_Division) lt 30">
				<cfset Name_of_Division = Name_of_Division&" " >
			</cfloop>
		<cfelse>
			<cfset Name_of_Division ="                              ">
		</cfif>
		
		<cfset header = "0"&"#source#"&"#basic_year#"&"08"&"#orgIDtype#"&"#uen#"&"#authorised_name#"&"#Des_of_au_person#"&"#name_emp#"&"#comp_phone#"&authorised_email&"#Batch_Ind#"&"#Bdate##Name_of_Division#"&"IR8A">
		<cfloop condition="len(header) lt 1200">
		<cfset header = header&" " >
		</cfloop>
	
	<!--- <cfoutput>#header#</cfoutput> --->
	<cffile action = "write" 
			file = "C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt" 
			output = "#header#">
	
	<!--- end header --->
	<!--- start Detail--->
	 <cfloop query= "getList_qry">
		<cfset num_ID = 0>
		<cfset postcode1 = 0>
		<cfset ID_TYPE = 0>
		<!--- 3.check if type --->
		<cfif getList_qry.national eq "SG" OR getList_qry.r_statu eq "PR">
			<cfset ID_TYPE= "1">
		<cfelseif getList_qry.r_statu eq "EP" or getList_qry.r_statu eq "SP" or getList_qry.r_statu eq "WP" or getList_qry.r_statu eq "LC" and #getList_qry.fin# neq "">
			<cfset ID_TYPE= "2" >
		<cfelseif getList_qry.IMS neq "">
			<cfset ID_TYPE= "3" >
		<cfelseif getList_qry.r_statu eq "WP">
			<cfset ID_TYPE= "4">
		<cfelseif getList_qry.national eq "MY" AND getList_qry.passport eq "">
			<cfset ID_TYPE= "5">
		<cfelseif getList_qry.passport neq "" AND getList_qry.national neq "SG" >
			<cfset ID_TYPE= "6">
		</cfif>
		<!--- 4.check number id --->
		<cfif ID_TYPE eq "1" >
			<cfif getList_qry.national eq "SG">
				<cfset nric = ucase(getList_qry.nricn)>
			<cfelseif getList_qry.r_statu eq "PR">
				<cfset nric = ucase(getList_qry.pr_num)>
			</cfif>
			
			<cfset num_reg = REFind("^[S|T|F|G]", ucase(getList_qry.nricn))>
			<cfset nnric = replace(getList_qry.nricn, "-","","all")>
			<cfset new_reg_nric = REFind("[[:punct:]]", nnric)>
			
			<cfif nnric neq "" and new_reg_nric eq "0" and num_reg eq "1">
				<cfset num_ID = "#nnric#">
				<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
				</cfloop>
			</cfif>
		
		<cfelseif ID_TYPE eq "2">
			<cfset num_reg = REFind("^[F|G]", ucase(getList_qry.fin))>
			<cfif getList_qry.fin neq "" and num_reg eq 1>
				<cfset num_ID = "#getList_qry.fin#">
				<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
				</cfloop>	
			</cfif>
		<cfelseif ID_TYPE eq "3">
			<cfset num_reg = REFind("^\d{8}$" , ucase(getList_qry.IMS))>
			<cfif getList_qry.IMS neq "" and num_reg eq 1>
				<cfset num_ID = "#getList_qry.IMS#">
				<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
				</cfloop>
			</cfif>
		<cfelseif ID_TYPE eq "4">
				<cfif  getList_qry.wpermit neq "">
					<cfset num_ID = "#getList_qry.wpermit#">
					<cfloop condition="len(num_ID) lt 12">
						<cfset num_ID = num_ID&" " >
					</cfloop>
				<cfelseif  getList_qry.fin neq "">
					<cfset num_ID = "#getList_qry.fin#">
					<cfloop condition="len(num_ID) lt 12">
						<cfset num_ID = num_ID&" " >
					</cfloop>	
				</cfif>
		
		<cfelseif ID_TYPE eq "5">
				
				<cfset nric = getList_qry.nricn>
				<!--- <cfset num_reg = getList_qry.nricn> --->
				
				<cfset nnric = replace(getList_qry.nricn, "-","","all")>
				<cfset new_reg_nric = REFind("[[:punct:]]", nnric)>
				
				<cfif nnric neq "" and new_reg_nric eq "0" >
					<cfset num_ID = "#nnric#">
					<cfloop condition="len(num_ID) lt 12">
						<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
			<!--- <cfoutput>#nnric# #new_reg_nric# #num_reg#</cfoutput> --->
		<cfelseif ID_TYPE eq "6">
				<cfif getList_qry.passport neq  "">
					<cfset num_ID = getList_qry.passport>
					<cfloop condition="len(num_ID) lt 12">
						<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
		</cfif>
		<!---  No.5 check name --->
		 <cfset name1 = "">
		 <cfif getList_qry.name neq "">
			<cfset name1="#trim(getList_qry.name)#">
			<cfloop condition="len(name1) lt 80">
				<cfset name1 = name1&" " >
			</cfloop>
		</cfif>
		<!--- 6.check addtype --->
		<cfif getList_qry.add_type eq "">
			<cfset addtype =  "N">
		<cfelse>
			<cfset addtype = "#getList_qry.add_type#" >
		</cfif>
		<cfset block_num="          ">
		<cfset street_name = "                                ">
		<cfset LevelNo = "   ">
		<cfset UnitNo = "     ">
		<cfset country_code = "   ">
		<cfset postcode1 = "      ">
		<cfset postcode2 = "      ">
		<cfset line1="                              ">
		<cfset line2="                              ">
		<cfset line3="                              ">
		<cfset postcode2 = "      ">
			
		<cfif addtype eq "L">
			<cfif trim(getList_qry.block) neq "">
				<cfset block_num= trim(getList_qry.block)>
				<cfloop condition="len(block_num) lt 10">
					<cfset block_num = block_num&" " >
				</cfloop>
                 <cfif len(block_num) gt 10>
            <cfset alertlist=alertlist&"Block Number for Employee #num_ID#  #name1# is more than 10 characters<br />">
			</cfif>
			</cfif>
			<cfif trim(getList_qry.street) neq "">
				<cfset street_name = trim(getList_qry.street)>
				<cfloop condition="len(street_name) lt 32">
						<cfset street_name = street_name&" " >
				</cfloop>
                <cfif len(street_name) gt 32>
            <cfset alertlist=alertlist&"Street Name for Employee #num_ID#  #name1# is more than 32 characters<br />">
			</cfif>
			</cfif>	
			<cfif trim(getList_qry.level_no) neq "">
				<cfset LevelNo = trim(getList_qry.level_no)>
				<cfloop condition="len(LevelNo) lt 3">
						<cfset LevelNo = LevelNo&" " >
				</cfloop>
                <cfif len(LevelNo) gt 3>
            <cfset alertlist=alertlist&"Level no for Employee #num_ID#  #name1# is more than 3 characters<br />">
			</cfif>
			</cfif>
			<cfif trim(getList_qry.unit) neq "">
				<cfset UnitNo = trim(getList_qry.unit)>
				<cfloop condition="len(UnitNo) lt 5">
						<cfset UnitNo = UnitNo&" " >
				</cfloop>
                <cfif len(UnitNo) gt 5>
            <cfset alertlist=alertlist&"Unit no for Employee #num_ID#  #name1# is more than 5 characters<br />">
			</cfif>
			</cfif>
			
			<cfif trim(getList_qry.postcode) neq "" AND len(trim(getList_qry.postcode)) eq 6>
				<cfset postcode1 = trim(getList_qry.postcode)>
            <cfelseif trim(getList_qry.postcode) eq "">
            	<cfset alertlist=alertlist&"Postal code for Employee #num_ID#  #name1# is Empty<br />">
                <cfelseif len(trim(getList_qry.postcode)) neq 6>
            	<cfset alertlist=alertlist&"Postal code for Employee #num_ID#  #name1# is not 6 characters<br />">
			</cfif>
			
		<cfelseif addtype eq "F">
			<cfset line1 = trim(getList_qry.add_line1)>
			<cfloop condition="len(line1) lt 30">
					<cfset line1 = line1&" " >
			</cfloop>
            <cfif len(line1) gt 30>
            <cfset line1 = left(line1,30)>
			</cfif>
		
			<cfset line2= trim(getList_qry.add_line2)>
			<cfloop condition="len(line2) lt 30">
					<cfset line2 = line2&" " >
			</cfloop>
            
            <cfif len(line2) gt 30>
            <cfset line2 = left(line2,30)>
			</cfif>
		
			<cfset line3="#trim(getList_qry.add_line3)#">
			<cfloop condition="len(line3) lt 30">
					<cfset line3 = line3&" " >
			</cfloop>
            
            <cfif len(line3) gt 30>
            <cfset line3 = left(line3,30)>
			</cfif>
			
			<cfset country_add_code = trim(getList_qry.country_code_address)>
            
            <cfquery name="getcountrycode" datasource="payroll_main">
            SELECT ir8acode FROM councode WHERE ccode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#country_add_code#">
            </cfquery>
			<cfif getcountrycode.ir8acode neq "">
				<cfset country_code = getcountrycode.ir8acode>
			<cfelse>
				<cfset country_code = "   ">
			</cfif>
			
		<cfelseif addtype eq "C">
			<cfset line1=trim(getList_qry.add_line1)>
			<cfloop condition="len(line1) lt 30">
					<cfset line1 = line1&" " >
			</cfloop>
            
            <cfif len(line1) gt 30>
            <cfset line1 = left(line1,30)>
			</cfif>
			
			<cfset line2=trim(getList_qry.add_line2)>
			<cfloop condition="len(line2) lt 30">
					<cfset line2 = line2&" " >
			</cfloop>
            
            <cfif len(line2) gt 30>
            <cfset line2 = left(line2,30)>
			</cfif>
			
			<cfset line3=trim(getList_qry.add_line3)>
			<cfloop condition="len(line3) lt 30">
					<cfset line3 = line3&" " >
			</cfloop>
            
            <cfif len(line3) gt 30>
            <cfset line3 = left(line3,30)>
			</cfif>
			<cfif trim(getList_qry.postcode) neq "" AND len(trim(getList_qry.postcode)) eq 6>
				<cfset postcode2 = trim(getList_qry.postcode)>
			</cfif>
		
		<cfelseif addtype eq "N">
			<cfset block_num="          ">
			<cfset street_name = "                                ">
			<cfset LevelNo = "   ">
			<cfset UnitNo = "     ">
			<cfset line1="                              ">
			<cfset line2="                              ">
			<cfset line3="                              ">
			<cfset country_code = "   ">
			<cfset postcode1 = "      ">
			<cfset postcode2 = "      ">	
		</cfif>
		
		<cfset nationality = "">
		<cfif getList_qry.r_statu eq "PR" >
			<cfset nationality = "300">
		<cfelse>
				<cfset nationality = "#getList_qry.national#" >
                
                 <cfquery name="getcountrycode" datasource="payroll_main">
            SELECT ir8acode FROM councode WHERE ccode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nationality#">
            </cfquery>
            
				
				<cfif getcountrycode.ir8acode neq "">
					<cfset nationality = getcountrycode.ir8acode>
				<cfelse>
					<cfset nationality = "999">
				</cfif>
			</cfif>
			
			<cfset DOB = 0>
			<cfif getList_qry.dbirth neq "">
				<cfset DOB= #dateformat(getList_qry.dbirth,'YYYYMMDD')#>
			</cfif>
			
			<!---start count total amount --->
			<cfset other = 0>
			<cfset totalamt = 0>
			<cfset tbonus = int(VAL(getList_qry.EA_BONUS)) + int(VAL(getList_qry.bonusfrny))>
			<cfset other = int(val(getList_qry.EA_COMM))+int(val(getList_qry.EAFIG02))+ int(val(getList_qry.EA_AW_T))
							+ int(val(getList_qry.EA_AW_E))+
							int(val(getList_qry.EA_AW_O))+ int(val(getList_qry.ecfig05))+ int(val(getList_qry.EAFIG05))
							+ int(val(getList_qry.EAFIG06))+ int(val(getList_qry.EA_EPFCEXT))+ int(val(getList_qry.EAFIG08))+ int(val(getList_qry.EAFIG09))>
			<cfset totalamt = int(VAL(getList_qry.EA_BASIC)) + int(val(tbonus))+ int(val(getList_qry.ea_dirf))+ int(val(other))>
			<!--- start drop decimals place --->
			
			<cfset a = totalamt>
			<cfset b = round(a)>
			<cfif b-a lte 0>
				<cfset totalamt2 = round(a)>
			<cfelse>
				<cfset totalamt2 = round(a-1)>
			</cfif>
			
			<!--- end drop decimals place --->
			<cfset totalamt2 = "#numberformat(totalamt2,'000000000')#">
			<!--- end count total amount --->
			
			
			<cfset from_date = 0>
			<cfif getList_qry.dcomm neq "">
				<cfset year_dcomm = datepart("yyyy",getList_qry.dcomm)>
				<cfset year_comp = basic_year>
				<cfif year_dcomm eq year_comp>
					<cfset from_date = dateformat(getList_qry.dcomm,"yyyymmdd")>
				<cfelse>
					<cfset from_date = getComp_qry.myear&"0101">
				</cfif>
			</cfif>
		
			<cfset to_date = 0>
			<cfif getList_qry.dresign eq "">
				<cfset to_date ="#getComp_qry.myear#"&"1231">
			<cfelse>
				<cfset to_year = "#dateformat(getList_qry.dresign,'YYYY')#">
				<cfset basicyear = "#getComp_qry.myear#">
				<cfif to_year eq basicyear >
					<cfset to_date ="#dateformat(getList_qry.dresign,'YYYYMMDD')#">
				<cfelse>
				<cfset to_date ="#getComp_qry.myear#"&"1231">
				</cfif>
			</cfif>
			
			<cfset MBF_re = "#ceiling(val(getList_qry.EAFIG15))#" >
			<cfset MBF = "#numberformat(MBF_re,'00000')#">
			<cfset donation ="#ceiling(val(getList_qry.EA_DED))#">
			<cfset donation = "#numberformat(donation,'00000')#">
			<cfset CPF ="#ceiling(val(getList_qry.EA_EPF))#">
			<cfset CPF = "#numberformat(CPF,'0000000')#">
			<cfset insurance = "#ceiling(val(getList_qry.ins_ded))#">
			<cfset insurance = "#numberformat(insurance,'00000')#">
			
			<cfset salary_2 = int(VAL(getList_qry.EA_BASIC))>
			
			<cfset salary = int(salary_2)>
		
			<cfset salary = "#numberformat(salary,'000000000')#">
			
			<cfset a=VAL(getList_qry.EA_BONUS) + VAL(getList_qry.bonusfrny)>
			<cfset b=round(a)>
			<cfif b-a lte 0>
				<cfset bonus2 = round(a)>
			<cfelse>
				<cfset bonus2 = round(a-1)>
			</cfif>
			<cfset bonus2 = "#numberformat(bonus2,'000000000')#">
			
			<cfset a= val(getList_qry.ea_dirf)>
			<cfset b=round(a)>
			<cfif b-a lte 0>
				<cfset dirfee = round(a)>
			<cfelse>
				<cfset dirfee = round(a-1)>
			</cfif>
			<cfset dirfee = "#numberformat(dirfee,'000000000')#">
			
			
			<cfset a= #val(other)#>
			<cfset b=round(a)>
			<cfif b-a lte 0>
				<cfset other = round(a)>
			<cfelse>
				<cfset other = round(a-1)>
			</cfif>
			<cfset other = "#numberformat(other,'000000000')#">
			
			<cfif #getList_qry.EX_32# neq 0 and #getList_qry.EX_32# neq "">
				<cfset Gain_Share = "val(getList_qry.EX_32)">
				<cfset Gain_Share = "#numberformat(Gain_Share,'000000000')#">
			<cfelse>	
			<cfset Gain_Share = "000000000">
			</cfif>
			
			<cfif #getList_qry.EX_33# neq 0 and #getList_qry.EX_33# neq "">
				<cfset sec20 = val(getList_qry.EX_33)>
				<cfset sec20 = "#numberformat(sec20,'000000000')#">
			<cfelse>	
			<cfset sec20="000000000">
			</cfif>
			
			<cfif #getList_qry.EX_34# neq 0 and #getList_qry.EX_38# eq "P">
				<cfset sec21 = val(getList_qry.EX_34)>
				<cfset sec21 = "#numberformat(sec21,'000000000')#">
			<cfelse>	
				<cfset sec21="000000000">
			</cfif>
			
			<cfif #getList_qry.EX_35# neq 0 and #getList_qry.EX_38# eq "H">
				<cfset sec22 = val(getList_qry.EX_35)>
				<cfset sec22 = "#numberformat(sec22,'000000000')#">
			<cfelse>
			<cfset sec22="000000000">
			</cfif>
			
			<cfif val(getList_qry.EAFIG09) neq 0>
			<cfset benefits_in_kind = "Y">
			<cfelse>
			<cfset benefits_in_kind = "N">
			</cfif>
			
			<cfif #getList_qry.EX_37# eq "Y">
			<cfset appsec45 = "Y">
			<cfelse>
			<cfset appsec45 = "N">
			</cfif>	
			
			<cfif #getList_qry.EX_38# eq "N" or #getList_qry.EX_38# eq "">
			<cfset sec25 = "N">
			<cfelseif #getList_qry.EX_38# eq "F">
			<cfset sec25 = "F">
			<cfelseif #getList_qry.EX_38# eq "P">
			<cfset sec25 = "P">
			<cfelseif #getList_qry.EX_38# eq "H">
			<cfset sec25 = "H">
			</cfif>
			
			<cfif val(getList_qry.ecfig05) neq 0>
				<cfset sec26_gratuity = "Y">
			<cfelse>
				<cfset sec26_gratuity = "N">
			</cfif>
			
		<!----------- 27-Compensation/Retrenchment benefits, 27a-Approval obtained from IRAS, 27b-Date of approval------------->	
			<cfif #getList_qry.EX_56# neq 0 >
			<cfset sec27_comp = "Y">
			<cfelse>		
			<cfset sec27_comp = "N">
			</cfif>
			
			<cfif #getList_qry.EX_41# eq "Y">
			<cfset approvalIRAS = "Y">
			<cfset date_approval = #dateformat(getList_qry.EX_42,'YYYYMMDD')#>
		<cfelse>	
			<cfset approvalIRAS = " ">
			<cfset date_approval = "        ">
		</cfif>	
		<!-------------------------------------------------------------------------------------->
		<!------------------------section 28 Cessation Provisions(if date commencement<19690101 and date dresign(YYYY) eq basicyear(YYYY))------------------------------------------>	
		<cfset basicyear = "#getComp_qry.myear#">
		<cfif #dateformat(getList_qry.dcomm,'YYYYMMDD')# lte "19690101" and #dateformat(getList_qry.dresign,'YYYY')# eq #basicyear# >
			<cfset sec28_cess_Pro = "Y">
		<cfelse>
			<cfset sec28_cess_Pro = "N">
		</cfif>
		<!------------------------------------------------------------------------------------------------------->		
			
			<cfif #getList_qry.EX_44# eq "" or #getList_qry.EX_44# eq "N">
				<cfset sec29_formIRAS = "N">
			<cfelse>	
				<cfset sec29_formIRAS = "Y">
			</cfif>
			
			<cfif #getList_qry.EX_45# eq "N" or #getList_qry.EX_45# eq "">
				<cfset sec30_exempt = "N">
			<cfelseif #getList_qry.EX_45# eq "1">	
			<cfset sec30_exempt = "1">
			<cfelseif #getList_qry.EX_45# eq "2">	
			<cfset sec30_exempt = "2">
			<cfelseif #getList_qry.EX_45# eq "3">	
			<cfset sec30_exempt = "3">
			<cfelse>	
			<cfset sec30_exempt = "4">
			</cfif>
			
			
			<cfset sec30a_comp_Gra = " ">
			
			<cfset a= int(val(getList_qry.EA_COMM))>
			<cfset gross_comm = a * 100 >
			<cfset gross_comm = "#numberformat(gross_comm,'00000000000')#">
			
			<cfif getList_qry.EATXT5 neq "">
				
				<cfset sec32a_from_Date = DateFormat(getList_qry.EATXT5,'yyyymmdd')>
				<cfset sec32b_to_Date = DateFormat(getList_qry.EATXT6,'yyyymmdd')>
					<cfif sec32a_from_Date lte sec32b_to_Date >
						<cfset sec32aFromDate = sec32a_from_Date >
					</cfif>
			<cfelse>
					<cfset sec32aFromDate = "        " >
			</cfif>
			
			<cfif getList_qry.EATXT6 neq "">
				<cfset sec32bToDate = "#DateFormat(getList_qry.EATXT6,'yyyymmdd')#">
			<cfelse>
				<cfset sec32bToDate = "        ">
			</cfif>	
			
			<cfif getList_qry.EA_COMM neq "0.00" and getList_qry.PBAYARAN neq "" >
				<cfset sec33_gross_ind = "#getList_qry.PBAYARAN#">
			<cfelse>
				<cfset sec33_gross_ind = " ">
			</cfif>
			
			<cfset a= int(val(getList_qry.EAFIG02))>
			<cfset sec34_pension1 = a * 100>
			<cfset sec34_pension = "#numberformat(sec34_pension1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EA_AW_T))>
			<cfset sec35_tran1 = a * 100>
			<cfset sec35_tran="#numberformat(sec35_tran1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EA_AW_E))>
			<cfset sec36_Ent1 = a * 100>
			<cfset sec36_Ent="#numberformat(sec36_Ent1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EA_AW_O))>
			<cfset sec37_other1 = a * 100>
			<cfset sec37_other="#numberformat(sec37_other1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.ecfig05))>
			<cfset sec38_gratuity1 = a * 100>
			<cfset sec38_gratuity="#numberformat(sec38_gratuity1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EX_56)) >
			<cfset sec38a_comp1 = a* 100>
			<cfset sec38a_comp = "#numberformat(sec38a_comp1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EAFIG07))>
			<cfset sec39_retirement_ben1 = a * 100>
			<cfset sec39_retirement_ben="#numberformat(sec39_retirement_ben1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EAFIG05))>
			<cfset sec40_retire_ben_1993_1 = a * 100>
			<cfset sec40_retire_ben_1993="#numberformat(sec40_retire_ben_1993_1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EAFIG06))>
			<cfset sec41_con1 = a * 100>
			<cfset sec41_con="#numberformat(sec41_con1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EA_EPFCEXT))>
			<cfset sec42_execess1 = a * 100>
			<cfset sec42_execess="#numberformat(sec42_execess1,'00000000000')#">
			
			<cfset a= int(val(getList_qry.EAFIG08))>
			<cfset sec43_gains1 = a * 100>
			<cfset sec43_gains="#numberformat(sec43_gains1,'00000000000')#">
			
			
			<cfset a= int(val(getList_qry.EAFIG09))>
			<cfset sec44_value1 = a * 100>
			<cfset sec44_value="#numberformat(sec44_value1,'00000000000')#">
			
			<cfset sec45_empyee="0000000">
			
			<cfif #getList_qry.jtitle# neq "">
				<cfset sec46_designation= "#left(getList_qry.jtitle,30)#">
					<cfloop condition="len(sec46_designation) lt 30">
						<cfset sec46_designation = sec46_designation&" " >
					</cfloop>
			<cfelse>
				<cfset sec46_designation="                              ">
			</cfif>

			<cfif #getList_qry.jtitle# neq "">
				<cfset sec52_name_desgn = "#getList_qry.jtitle#">
					<cfloop condition="len(sec52_name_desgn) lt 60">
						<cfset sec52_name_desgn = sec52_name_desgn&" " >
					</cfloop>
			<cfelse>
				<cfset sec52_name_desgn = "                                                            ">
			</cfif>
			
			<!--- <cfset from_year = "#dateformat(getList_qry.dcomm,'YYYY')#">
			<cfset basicyear = "#getComp_qry.myear#">
			<cfif #from_year# gte #basicyear# AND getList_qry.dcomm lte getList_qry.dresign >
			<cfif sec28_cess_Pro eq "Y" >
			<cfif getList_qry.dcomm neq "" AND #dateformat(getList_qry.dcomm,'YYYYMMDD')# gte "19690101">
			<cfset sec47_date_comm="#dateformat(getList_qry.dcomm,'YYYYMMDD')#">
			</cfif>
			<cfelse>
			<cfset sec47_date_comm="#dateformat(getList_qry.dcomm,'YYYYMMDD')#">
			</cfif>
			</cfif>
			<cfif getList_qry.dresign eq "">
			<cfset sec48_date_resgn="        ">
			</cfif>
			
			<cfif #sec28_cess_Pro# eq "Y" >
			<cfif getList_qry.dresign neq "" AND #to_year# eq #basicyear# AND getList_qry.dcomm lte getList_qry.dresign>
			<cfset sec48_date_resgn="#dateformat(getList_qry.dcomm,'YYYYMMDD')#">
			</cfif>
			<cfelse>
			<cfif getList_qry.dresign neq "" AND #to_year# eq #basicyear# AND getList_qry.dcomm lte getList_qry.dresign>
			<cfset sec48_date_resgn="#dateformat(getList_qry.dcomm,'YYYYMMDD')#">
			</cfif>
			</cfif>
			<cfif getList_qry.dresign eq "">
			<cfset sec48_date_resgn="        ">
			</cfif> --->
			
			<cfif getList_qry.dcomm neq "">
			<cfset sec47DateComm = #dateformat(getList_qry.dcomm,'YYYYMMDD')# >
			<cfelse>
			<cfset sec47DateComm ="        ">
			</cfif>
			
			<cfif getList_qry.dresign neq "">
				<cfset date_rsgn2 ="#dateformat(getList_qry.dresign,'YYYYMMDD')#">
			<cfelse>
				<cfset date_rsgn2 = "        ">
			</cfif>
			
			<cfif getList_qry.BONUSDATE1 neq "">
			<cfset sec49_date_bonus="#dateformat(getList_qry.BONUSDATE1,'YYYYMMDD')#">
			<cfelse>
			<cfset sec49_date_bonus = "        ">
			</cfif>
			
			<cfif getList_qry.EXTRADATE1 neq "">
			<cfset sec50_date_dirfee="#dateformat(getList_qry.EXTRADATE1,'YYYYMMDD')#">
			<cfelse>
			<cfset sec50_date_dirfee = "        ">
			</cfif>
			
			<cfif getList_qry.EATXT9 neq "">
				<cfset sec51_name_of_fund="#getList_qry.EATXT9#">
				<cfloop condition="len(sec51_name_of_fund) lt 60">
			<cfset sec51_name_of_fund = sec51_name_of_fund&" " >
			</cfloop>
			<cfelse>
			<cfset sec51_name_of_fund = "                                                            ">
			</cfif>
			
			<cfif #getList_qry.EX_70# neq "">
				<cfset sec52_name_desgn = "#getList_qry.EX_70#">
				<cfloop condition="len(sec52_name_desgn) lt 60">
					<cfset sec52_name_desgn = sec52_name_desgn&" " >
				</cfloop>
			<cfelse>
			<cfset sec52_name_desgn = "                                                            ">
			</cfif>
			
			<cfset emp_bank_cat= "#getList_qry.bankcat#">
            
			<cfquery name="select_bank_code" datasource="payroll_main">
				SELECT ir8acode FROM bankcode WHERE bankcode ="#getList_qry.bankcode#"
			</cfquery>
			<cfif select_bank_code.recordcount neq "0">
				<cfset sec53_name_of_bank= select_bank_code.ir8acode>
			<cfelse>
				<cfset sec53_name_of_bank= "4">
			</cfif> 
			<!--- <cfoutput>
			#num_ID#
			#postcode1#<br/>
			#ID_TYPE#<br/>
			#nationality#<br/>
			#name1#<br/>
			#DOB#<br/>
			#from_date#<br/>
			#to_date#<br/><cfabort>
			</cfoutput> --->
			<cfif num_ID neq 0 and postcode1 neq 0 
					and ID_TYPE neq 0 and nationality neq "" 
					and name1 neq "" 
					and DOB neq 0
					and from_date neq 0 
					and to_date neq 0>
						<cfset content ="1#ID_TYPE#"&ucase("#num_ID#")&"#REReplace("#name1#","'|,|/|>|:|;|{|}|]|~|!|@|%|&|-|_|=|`"," ","ALL")#"&"#addtype#"&"#block_num#"
						&"#street_name##LevelNo##UnitNo##postcode1##line1##line2##line3##postcode2##country_code##nationality##getList_qry.sex##DOB#"
						&"#totalamt2##from_date##to_date##MBF##donation##CPF##insurance##salary##bonus2##dirfee##other#"
						&"#Gain_Share##sec20##sec21##sec22##benefits_in_kind##appsec45##sec25##sec26_gratuity##sec27_comp##approvalIRAS#"
						&"#date_approval##sec28_cess_Pro##sec29_formIRAS##sec30_exempt##sec30a_comp_Gra##gross_comm#"
						&"#sec32aFromDate##sec32bToDate##sec33_gross_ind##sec34_pension##sec35_tran##sec36_Ent##sec37_other##sec38_gratuity#"
						&"#sec38a_comp##sec39_retirement_ben##sec40_retire_ben_1993##sec41_con##sec42_execess##sec43_gains##sec44_value#"
						&"#sec45_empyee##sec46_designation##sec47DateComm##date_rsgn2##sec49_date_bonus##sec50_date_dirfee##sec51_name_of_fund#"
						&"#sec52_name_desgn##sec53_name_of_bank##dateformat(now(),'YYYYMMDD')#">
					
					<cfloop condition="len(content) lt 1200">
						<cfset content = content&" " >
					</cfloop>
					
					<cffile action="append" addnewline="yes" file = "C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt" output = "#content#">
					
					<cfset total_record_count = total_record_count + 1>
			
			<cfelse>
				<font color="red"><th>got some problem,kindly check.<th></font>
                <cfoutput>
                <h1>Employee that have problem</h1>
                <table width="100%">
                <tr>
                <th>Empno</th>
                <th>Identification No</th>
                <td>Postcode</td>
                <td>ID TYPE</td>
                <td>Nationality</td>
                <td>Name</td>
                <td>DOB</td>
                <td>Date Commence</td>
                <td>To Date</td>
                </tr>       
                <tr>
                <td>#getList_qry.empno#</td>
                <td>#num_id#</td>
                <td>#postcode1#</td>
                <td>#ID_TYPE#</td>
                <td>#nationality#</td>
                <td>#name1#</td>
                <td>#DOB#</td>
                <td>#from_date#</td>
                <td>#to_date#</td>
                </tr>
                </table>
                </cfoutput>
                <cfset datawrong = 1>
			</cfif>
			
			
	</cfloop>
	<cfif isdefined('datawrong')>
    <cfabort>
	</cfif>
	<!--- end Detail--->
	
	<!--- start trailer --->
	<cfset total_record_count =  #numberformat(total_record_count+1, '000000')#>
	
	<cfquery name="sumAll" datasource="#dts#">
	SELECT sum(coalesce(FLOOR(EA_COMM),0))+sum(coalesce(FLOOR(EAFIG02),0))+sum(coalesce(FLOOR(EA_AW_T),0))+sum(coalesce(FLOOR(EA_AW_E),0))
	+sum(coalesce(FLOOR(EA_AW_O),0))+sum(coalesce(FLOOR(ecfig05),0))+sum(coalesce(FLOOR(EAFIG05),0))+sum(coalesce(FLOOR(EAFIG06),0))+
	sum(coalesce(FLOOR(EA_EPFCEXT),0))+sum(coalesce(FLOOR(EAFIG08),0))+sum(coalesce(FLOOR(EAFIG09),0))as sum_Other,
	sum(coalesce(FLOOR(EA_BASIC),0)) as sum_Salary, sum(coalesce(FLOOR(ea_dirf),0))as sumDirFee,
	sum(coalesce(FLOOR(EA_BONUS),0))+sum(coalesce(FLOOR(bonusfrny),0)) as sum_bonus, 
	sum(coalesce(ceiling(EA_DED),0)) as sumdonation,
	sum(coalesce(ceiling(EA_EPF),0)) as sumcpf, 
	sum(coalesce(ceiling(EAFIG15),0)) as sumMBF,
	sum(coalesce(ceiling(EX_33),0)) as sum_exem_income,
	sum(coalesce(ceiling(EX_34),0)) as sum_Borne_emper,
	sum(coalesce(ceiling(EX_35),0)) as sum_Borne_empee,
	sum(coalesce(ceiling(ins_ded),0)) as sum_insurance
	FROM itaxea as i left join pmast as p on p.empno=i.empno
	WHERE 0=0 AND p.confid >= #hpin#
		  <cfif form.empnoFrom neq ""> AND i.empno >= '#form.empnoFrom#'</cfif>
		  <cfif form.empnoTo neq ""> AND i.empno <= '#form.empnoTo#'</cfif>
		  <cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
		  and itaxcat <> "X"
          and (year(dresign) >= #year_sys# or dresign is null or dresign ="0000-00-00")
		  <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0 or (coalesce(ea_aw_t,0)+coalesce(ea_aw_e,0)+coalesce(ea_aw_o,0))<> 0 or coalesce(FLOOR(EA_COMM),0)+coalesce(FLOOR(EAFIG02),0)+coalesce(FLOOR(EA_AW_T),0)+coalesce(FLOOR(EA_AW_E),0)
	+coalesce(FLOOR(EA_AW_O),0)+coalesce(FLOOR(ecfig05),0)+coalesce(FLOOR(EAFIG05),0)+coalesce(FLOOR(EAFIG06),0)+
	coalesce(FLOOR(EA_EPFCEXT),0)+coalesce(FLOOR(EAFIG08),0)+coalesce(FLOOR(EAFIG09),0) <> 0 )</cfif>
		  order by p.empno
	</cfquery>		
	
	<cfset total_sum_amt= int(val(sumAll.sum_Other)) + int(val(sumAll.sumDirFee)) + int(val(sumAll.sum_Salary)) + int(val(sumAll.sum_bonus))>
	<cfset total_sum_amt2 = "#numberformat(total_sum_amt,'000000000000')#">
	
	
	<cfset sum_salary= #int(val(sumAll.sum_Salary))#>
	<cfset sum_salary = #numberformat(sum_salary, '000000000000')#>
	
	
	<cfset sum_Bonus= #int(val(sumAll.sum_bonus))#>
	<cfset sum_Bonus = #numberformat(sum_Bonus, '000000000000')#>
	
	 
	<cfset sum_sumDirFee= #int(val(sumAll.sumDirFee))#>
	<cfset sum_sumDirFee = #numberformat(sum_sumDirFee, '000000000000')#>
	
	
	<cfset sum_Other= #int(val(sumAll.sum_Other))#>
	<cfset sum_Other = #numberformat(sum_Other, '000000000000')#>
	
	<cfset sum_sec20= #int(val(sumAll.sum_exem_income))#>
	<cfset sum_sec20="#numberformat(sum_sec20,'000000000000')#">
	
	<cfset sum_sec21= #int(val(sumAll.sum_Borne_emper))#>
	<cfset sum_sec21="#numberformat(sum_sec21,'000000000000')#">
	
	<cfset sum_sec22= #int(val(sumAll.sum_Borne_empee))#>
	<cfset sum_sec22="#numberformat(sum_sec22,'000000000000')#">
	
	<cfset sum_donation ="#ceiling(val(sumAll.sumdonation))#">
	<cfset sum_donation = "#numberformat(sum_donation,'000000000000')#">
	
	<cfset sum_CPF ="#ceiling(val(sumAll.sumcpf))#">
	<cfset sum_CPF = "#numberformat(sum_CPF,'000000000000')#">
	
	<cfset sum_insurance = "#ceiling(val(sumAll.sum_insurance))#">
	<cfset sum_insurance = "#numberformat(sum_insurance,'000000000000')#">
	
	<cfset sum_MBF = "#ceiling(val(sumAll.sumMBF))#" >
	<cfset sum_MBF = "#numberformat(sum_MBF,'000000000000')#">
	
	<cfset trailer = "2"&"#total_record_count##total_sum_amt2##sum_salary##sum_Bonus##sum_sumDirFee##sum_Other##sum_sec20#"
			&"#sum_sec21##sum_sec22##sum_donation##sum_CPF##sum_insurance##sum_MBF#">
	<cfloop condition="len(trailer) lt 1200">
	<cfset trailer = trailer&" " >
	</cfloop>
	<cffile action="append" addnewline="yes" 
	   file = "C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt"
	   output = "#trailer#">

	<!--- end trailer --->
	
	
<cfif alertlist neq "">
<cfoutput>
#alertlist#
</cfoutput>
<cfabort>
</cfif>
	
	<cfset filename= #form.toa#>
	
	
	
	
	<cfset yourFileName="C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt">
	<cfset yourFileName2="#filename#.txt">
	 
	 <cfcontent type="application/x-unknown"> 
	
	 <cfset thisPath = ExpandPath("#yourFileName#")> 
	 <cfheader name="Content-Disposition" value="attachment; filename=#yourFileName2#">
	 <cfheader name="Content-Description" value="This is a tab-delimited file.">
	 <cfcontent type="Multipart/Report" file="#yourFileName#">
	 <cflocation url="#yourFileName#">
	         
	 <cfoutput>#yourFileName#,#yourFileName2#,#thisPath#</cfoutput>
	 
	
	<!--- file = "C:\Inetpub\wwwroot\payroll\download\file.txt" --->
	<!--- \JRun4\servers\cfusion\cfusion-ear\cfusion-war\payroll\download\file.txt --->
 <cfcatch type="any">
		 	<cfset status_msg="Fail To generate disk. Error Message : #cfcatch.Detail#">
			 <cfoutput>
				 <script type="text/javascript">
				 alert("#status_msg#");
				 window.location = "/government/IR8A/GenerateIR8ASpecMain.cfm"
				</script>
			 </cfoutput>
		</cfcatch>

</cftry>

<!--- <cflocation url="/government/IR8A/GenerateIR8ASpecMain.cfm" >
 --->
<!--- <cfreport template="GenerateIR8A.cfr" format="PDF" query="getList_qry" >
		
<cfreportparam name="compName" value="#getComp_qry.comp_name#">
<cfreportparam name="compCode" value="#getComp_qry.comp_roc#">
<cfreportparam name="add1" value="#getComp_qry.comp_add1#">
<cfreportparam name="add2" value="#getComp_qry.comp_add2#">
<cfreportparam name="add3" value="#getComp_qry.comp_add3#">
<cfreportparam name="tel" value="#getComp_qry.comp_phone#">


<cfreportparam name="pmName" value="#getComp_qry.pm_name#">
<cfreportparam name="pmPost" value="#getComp_qry.pm_position#">
<cfreportparam name="pmTel" value="#getComp_qry.pm_tel#">

</cfreport> --->
