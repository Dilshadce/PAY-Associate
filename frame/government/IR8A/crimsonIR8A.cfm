<cffunction name="SPACE" returntype="string">
	        <cfargument name="value1" type="numeric" required="yes">
			<cfset reval="">
	         	<cfloop from="1" to="#value1#" index="i">
					<cfset reval = reval&" ">
				</cfloop>
			<cfreturn reval>
</cffunction>

<cfset uuid = replace(createuuid(),'-','','all')>
<cfset filename = "C:\Inetpub\wwwroot\payroll\download\cimsonlogin#uuid#.txt">
<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset mon = getComp_qry.mmonth>
<cfif #mon# eq 13>
<cfset mon = 12>
</cfif>	

<cfset yrs = getComp_qry.myear>
<cfset date1= createdate(yrs,mon,1)>
<cfset daysmonth = daysinmonth(date1) >
<cfset lastdays = createdate(yrs,mon,daysmonth)>
	
<cfquery name="getList_qry" datasource="#dts#">
SELECT * FROM pmast
WHERE 0=0
<cfif form.empnoFrom neq ""> AND empno >= '#form.empnoFrom#' </cfif>
<cfif form.empnoTo neq ""> AND empno <= '#form.empnoTo#' </cfif>
</cfquery>

<cfset header = "UNB"&SPACE(153)&"IR8A">
<cfset header = header&SPACE(255-len(header))>
<cffile action = "write"  file = "#filename#" output = "#header#" nameconflict="overwrite">

<cfset header1 = "UNH"&SPACE(16)&"IREERN011">
<cfset header1 = header1&SPACE(255-len(header1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header1#">

<cfset header2 = "BGM"&SPACE(2)&"938">
<cfset header2 = header2&SPACE(255-len(header2))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header2#">

<cfset header31 = "RFF"&SPACE(2)&"AWJ0">
<cfset header31 = header31&SPACE(255-len(header31))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header31#">

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

<cfset header32 = "RFF"&SPACE(2)&"AWK"&source>
<cfset header32 = header32&SPACE(255-len(header32))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header32#">

<cfset header33 = "RFF"&SPACE(2)&"AWL08">
<cfset header33 = header33&SPACE(255-len(header33))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header33#">

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
<cfelseif orgIDtype eq  "CRN">
	<cfset orgIDtype = "C">
<cfelseif orgIDtype eq  "MCST">
	<cfset orgIDtype = "M">
</cfif>

<cfset header34 = "RFF"&SPACE(2)&"AWM"&orgIDtype>
<cfset header34 = header34&SPACE(255-len(header34))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header34#">

<cfif isdefined('form.amendment')>
<cfset recindi = "A">
<cfelse>
<cfset recindi = "O">
</cfif>

<cfset header35 = "RFF"&SPACE(2)&"AWZ"&recindi>
<cfset header35 = header35&SPACE(255-len(header35))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header35#">

<!----<cfset batchdate = createdate(right(form.bdate,4),mid(form.bdate,4,2),left(form.bdate,2))> ------>
<cfset batchdate = lastdays>

<cfset header41 = "DTM"&SPACE(2)&"441"&dateformat(batchdate,'YYYY')&SPACE(4)&"602">
<cfset header41 = header41&SPACE(255-len(header41))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header41#">

<cfset header42 = "DTM"&SPACE(2)&"416"&dateformat(batchdate,'YYYYMMDD')&"102">
<cfset header42 = header42&SPACE(255-len(header42))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header42#">



<cfset uentry = replace(getComp_qry.UEN, "-","","all")>
<cfset uen = uentry>
<cfloop condition="len(uen) lt 12">
<cfset uen = uen&" " >
</cfloop>



<cfset authorised_name = "#getComp_qry.authorised_name#">
<cfloop condition="len(authorised_name) lt 50">
<cfset authorised_name = authorised_name&" " >
</cfloop>



<cfset authorised_email = "#getComp_qry.authorised_email#">
<cfloop condition="len(authorised_email) lt 50">
<cfset authorised_email = authorised_email&" " >
</cfloop>


<cfif getComp_qry.pm_name neq "">
<cfset Des_of_au_person ="#getComp_qry.pm_name#">
<cfloop condition="len(Des_of_au_person) lt 30">
<cfset Des_of_au_person = Des_of_au_person&" " >
</cfloop>
<cfelse>
<cfset Des_of_au_person =space(30)>
</cfif>



<cfset name_emp = "#getComp_qry.comp_name#">
<cfloop condition="len(name_emp) lt 60">
<cfset name_emp = name_emp&" " >
</cfloop>


<cfif getComp_qry.comp_phone neq "">
<cfset comp_phone =replace(getComp_qry.comp_phone, "-","","all")>
<cfloop condition="len(comp_phone) lt 20">
<cfset comp_phone = comp_phone&" " >
</cfloop>
<cfelse>
<cfset comp_phone =space(20)>
</cfif>

<cfset Name_of_Division="#getComp_qry.Name_of_Division#">
<cfif #Name_of_Division# neq "">
<cfloop condition="len(Name_of_Division) lt 30">
<cfset Name_of_Division = Name_of_Division&" " >
</cfloop>
<cfelse>
<cfset Name_of_Division =space(30)>
</cfif>

<cfset header6 = "NAD"&SPACE(2)&"SE"&SPACE(1)&uen&space(251-len(uen))&name_emp&space(70-len(name_emp))&authorised_email&space(60-len(authorised_email))&Name_of_Division>
<cfset header6 = header6&SPACE(419-len(header6))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header6#">

<cfset header7 = "COM"&SPACE(2)&comp_phone>
<cfset header7 = header7&SPACE(255-len(header7))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#header7#">

<cfset year_sys = getComp_qry.myear>

<cfquery name="getList_qry" datasource="#dts#">
	SELECT * FROM(SELECT * FROM pmast p where year(dresign) = #year_sys# or dresign is null or dresign ="0000-00-00") as pm 
	left join itaxea as pt on pt.empno = pm.empno
	WHERE 0=0
    AND pm.confid >= #hpin#
	  <cfif form.empnoFrom neq ""> AND pm.empno >= '#form.empnoFrom#' </cfif>
	  <cfif form.empnoTo neq ""> AND pm.empno <= '#form.empnoTo#' </cfif>
	  <cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
	  and itaxcat <> "X"
      <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0)</cfif>
	  order by pm.empno
</cfquery>

<cfset record_count = 0>

<cfloop query= "getList_qry">
<cfset record_count = record_count + 1>

<cfset detail8 = "LIN"&SPACE(2)&getList_qry.currentrow>
<cfset detail8 = detail8&space(255-len(detail8))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail8#">

<cfset detail91 = "RFF"&SPACE(2)&"AWJ1">
<cfset detail91 = detail91&space(255-len(detail91))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail91#">

<cfset num_ID = "            ">
<cfset postcode1 = 0>
<cfset ID_TYPE = 0>
<!--- 3.check if type --->
<cfif getList_qry.national eq "SG" OR getList_qry.r_statu eq "PR">
	<cfset ID_TYPE= "1">
<cfelseif getList_qry.r_statu eq "EP" or getList_qry.r_statu eq "SP" or getList_qry.r_statu eq "WP" and #getList_qry.fin# neq "">
	<cfset ID_TYPE= "2" >
<cfelseif getList_qry.IMS neq "">
	<cfset ID_TYPE= "3" >
<cfelseif getList_qry.r_statu eq "WP">
	<cfset ID_TYPE="4">
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
		<cfif getList_qry.wpermit neq "">
			<cfset num_ID = "#getList_qry.wpermit#">
			<cfloop condition="len(num_ID) lt 12">
				<cfset num_ID = num_ID&" " >
			</cfloop>
		<cfelseif getList_qry.fin neq "">
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

 <cfset name1 = space(80)>
		 <cfif getList_qry.name neq "">
			<cfset name1="#getList_qry.name#">
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
			
		<cfif addtype eq "L">
			<cfif getList_qry.block neq "">
				<cfset block_num= getList_qry.block>
				<cfloop condition="len(block_num) lt 10">
					<cfset block_num = block_num&" " >
				</cfloop>
			</cfif>
			<cfif getList_qry.street neq "">
				<cfset street_name = getList_qry.street>
				<cfloop condition="len(street_name) lt 32">
						<cfset street_name = street_name&" " >
				</cfloop>
			</cfif>	
			<cfif getList_qry.level_no neq "">
				<cfset LevelNo = getList_qry.level_no>
				<cfloop condition="len(LevelNo) lt 3">
						<cfset LevelNo = LevelNo&" " >
				</cfloop>
			</cfif>
			<cfif getList_qry.unit neq "">
				<cfset UnitNo = getList_qry.unit>
				<cfloop condition="len(UnitNo) lt 5">
						<cfset UnitNo = UnitNo&" " >
				</cfloop>
			</cfif>
			
			<cfif getList_qry.postcode neq "" >
				<cfset postcode1 = getList_qry.postcode>
			</cfif>
			
		<cfelseif addtype eq "F">
			<cfset line1 = getList_qry.add_line1>
			<cfloop condition="len(line1) lt 30">
					<cfset line1 = line1&" " >
			</cfloop>
            <cfif len(line1) gt 30>
            <cfset line1 = left(line1,30)>
			</cfif>
		
			<cfset line2= getList_qry.add_line2>
			<cfloop condition="len(line2) lt 30">
					<cfset line2 = line2&" " >
			</cfloop>
            <cfif len(line2) gt 30>
            <cfset line2 = left(line2,30)>
			</cfif>
		
			<cfset line3="#getList_qry.add_line3#">
			<cfloop condition="len(line3) lt 30">
					<cfset line3 = line3&" " >
			</cfloop>
            <cfif len(line3) gt 30>
            <cfset line3 = left(line3,30)>
			</cfif>
			
			<cfset country_add_code = getList_qry.country_code_address>
			<cfif country_add_code eq "ID">
				<cfset country_code = "303">
				
			<cfelseif country_add_code eq "MY">
				<cfset country_code = "304">
				
			<cfelseif country_add_code eq "PN">
				<cfset country_code = "305">
				
			<cfelseif country_add_code eq "TH">
				<cfset country_code = "306">
				
			<cfelseif country_add_code eq "JP">
				<cfset country_code = "331">
				
			<cfelseif country_add_code eq "TW">
				<cfset country_code = "334">
				
			<cfelseif country_add_code eq "CN">
				<cfset country_code = "336">
				
			<cfelseif country_add_code eq "GB">
				<cfset country_code = "110">
				
			<cfelseif country_add_code eq "US">
				<cfset country_code = "503">
				
			<cfelseif country_add_code eq "AU">
				<cfset country_code = "701">
				
			<cfelseif country_add_code eq "NZ">
				<cfset country_code = "705">
				
			<cfelse>
				<cfset country_code = "999">
			</cfif>
			
		<cfelseif addtype eq "C">
			<cfset line1=getList_qry.add_line1>
			<cfloop condition="len(line1) lt 30">
					<cfset line1 = line1&" " >
			</cfloop>
            <cfif len(line1) gt 30>
            <cfset line1 = left(line1,30)>
			</cfif>
			
			<cfset line2=getList_qry.add_line2>
			<cfloop condition="len(line2) lt 30">
					<cfset line2 = line2&" " >
			</cfloop>
            <cfif len(line2) gt 30>
            <cfset line2 = left(line2,30)>
			</cfif>
			
			<cfset line3=getList_qry.add_line3>
			<cfloop condition="len(line3) lt 30">
					<cfset line3 = line3&" " >
			</cfloop>
            <cfif len(line3) gt 30>
            <cfset line3 = left(line3,30)>
			</cfif>
            
			<cfif getList_qry.postcode neq "" >
				<cfset postcode2 = getList_qry.postcode>
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
				
				<cfif nationality eq "SG">
					<cfset nationality = "301">
				<cfelseif nationality eq "ID">
					<cfset nationality = "303">
				<cfelseif nationality eq "MY">
					<cfset nationality = "304">
				<cfelseif nationality eq "PN">
					<cfset nationality = "305">
				<cfelseif nationality eq "TH">
					<cfset nationality = "306">
				<cfelseif nationality eq "JP">
					<cfset nationality = "331">
				<cfelseif nationality eq "TW">
					<cfset nationality = "334">
				<cfelseif nationality eq "CN">
					<cfset nationality = "336">
				<cfelseif nationality eq "GB">
					<cfset nationality = "110">
				<cfelseif nationality eq "US">
					<cfset nationality = "503">
				<cfelseif nationality eq "AU">
					<cfset nationality = "701">
				<cfelseif nationality eq "NZ">
					<cfset nationality = "705">
				<cfelse>
					<cfset nationality = "999">
				</cfif>
			</cfif>
			
			<cfset DOB = 0>
			<cfif getList_qry.dbirth neq "">
				<cfset DOB= #dateformat(getList_qry.dbirth,'YYYYMMDD')#>
			</cfif>
			
		<cfset S45 = "N">
		<cfif getList_qry.EX_37 eq "Y">
			<cfset S45 = "Y">
		</cfif>	
		
		<cfset inc_tax_bor = "N">
		<cfif getList_qry.EX_38 eq "F">
			<cfset inc_tax_bor = "F">
		<cfelseif getList_qry.EX_38 eq "P">
			<cfset inc_tax_bor = "P">
		<cfelseif getList_qry.EX_38 eq "H" >
			<cfset inc_tax_bor = "H">
		</cfif>	
		
		<cfset Gratuity = "N">
	<cfif recindi eq "A">
		<cfif int(val(getList_qry.amd_grat)) neq 0>
			<cfset Gratuity = "Y">
		</cfif>	
	<cfelse>	
		<cfif val(getList_qry.ecfig05) neq 0>
			<cfset Gratuity = "Y">
		</cfif>
	</cfif>	
		
		<cfset Com_ReT_Oth = "N">
		<cfif recindi eq "A">
			<cfif #getList_qry.amd_com_ret# neq 0 >
				<cfset Com_ReT_Oth = "Y">
			</cfif>	
		<cfelse>	
			<cfif #getList_qry.EX_56# neq 0 >
				<cfset Com_ReT_Oth = "Y">
			</cfif>
		</cfif>		
		
<!-------------------Detail 12 ---------------------------------->

	<cfif getComp_qry.myear neq "">
			<cfset basic_year="#getComp_qry.myear#">
		</cfif>
			

				<cfif getList_qry.dcomm eq "" or #dateformat(getList_qry.dcomm,'YYYY')# lt basic_year>
					<cfset from_date = getComp_qry.myear&"0101">
				<cfelse>
					<cfset from_date = #dateformat(getList_qry.dcomm,'YYYYMMDD')#>
				</cfif>
		
			<cfset to_date ="#getComp_qry.myear#"&"1231">
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

		<cfset sec47DateComm = "        ">
		<cfif getList_qry.dcomm neq "">
			<cfset sec47DateComm = #dateformat(getList_qry.dcomm,'YYYYMMDD')# >
		</cfif>

		<cfset date_rsgn2 = "        ">
		<cfif getList_qry.dresign neq "" >
			<cfset date_rsgn2 = to_date>
				<cfif #dateformat(getList_qry.dresign,'YYYYMMDD')# gte #to_date#>
					<cfset date_rsgn2 ="#dateformat(getList_qry.dresign,'YYYYMMDD')#">		
				</cfif>
		</cfif>
		
<!---------------------------End Detail12 ------------------------>
	
		<cfset Cess_Pro = "N">
		<cfset basicyear = "#getComp_qry.myear#">
		<cfif #val(sec47DateComm)# lte val(19690101) and #left(date_rsgn2,4)# eq #basicyear# >
			<cfset Cess_Pro = "Y">
		</cfif>
		
	<cfif recindi eq "A">
		<cfif #int(val(getList_qry.amd_exces_yer))# neq 0>
				<cfset formIRAS = "Y">
		<cfelse>	
				<cfset formIRAS = "N">
		</cfif>
	<cfelse>
		<cfif #getList_qry.EX_44# eq "" or #getList_qry.EX_44# eq "N">
				<cfset formIRAS = "N">
		<cfelse>	
				<cfset formIRAS = "Y">
		</cfif>
	</cfif>	
		
		<cfset gross_ind = " ">
	<cfif recindi eq "A">
		<cfif #int(val(getList_qry.amd_com))# neq 0 and getList_qry.PBAYARAN neq "" >
			<cfif #getList_qry.PBAYARAN# eq "M" >
				<cfset gross_ind = "M">
			<cfelseif #getList_qry.PBAYARAN# eq "O">
				<cfset gross_ind = "O">
			</cfif>	
		</cfif>	
	<cfelse>		
		<cfif val(getList_qry.EA_COMM) neq 0 and getList_qry.PBAYARAN neq "" >
			<cfif #getList_qry.PBAYARAN# eq "M" >
				<cfset gross_ind = "M">
			<cfelseif #getList_qry.PBAYARAN# eq "O">
				<cfset gross_ind = "O">
			</cfif>
		</cfif>
	</cfif>
		
		<cfset res_add_ind = "N">
		<cfif getList_qry.add_type eq  "L">
			<cfset res_add_ind = "L">
		<cfelseif getList_qry.add_type eq  "F">
			<cfset res_add_ind = "F">
		<cfelseif getList_qry.add_type eq  "C">
			<cfset res_add_ind = "C">
		</cfif>
		
		<cfset exempt = "N">
	<cfif recindi eq "A">
		<cfif #int(val(getList_qry.amd_exe_tax_remi))# neq 0>
			<cfif #getList_qry.EX_45# eq "1">	
				<cfset exempt = "1">
			<cfelseif #getList_qry.EX_45# eq "2">	
				<cfset exempt = "2">
			<cfelseif #getList_qry.EX_45# eq "3">	
				<cfset exempt = "3">
			<cfelse>	
				<cfset exempt = "4">
			</cfif>
		</cfif>		
	<cfelse>	
		<cfif val(getList_qry.EX_33) neq 0>
		<cfif #getList_qry.EX_45# eq "1">	
			<cfset exempt = "1">
		<cfelseif #getList_qry.EX_45# eq "2">	
			<cfset exempt = "2">
		<cfelseif #getList_qry.EX_45# eq "3">	
			<cfset exempt = "3">
		<cfelse>	
			<cfset exempt = "4">
		</cfif>
		</cfif>
	</cfif>
		
		<cfset approvalIRAS = " ">
		<cfset date_approval = "        ">
	<cfif recindi eq "A">
		<cfif #getList_qry.amd_com_ret# neq 0 >
			<cfset approvalIRAS = "Y">
				<cfif getList_qry.EX_42 neq ""> 
					<cfset date_approval = #dateformat(getList_qry.EX_42,'YYYYMMDD')#>
				</cfif>
		</cfif>
	<cfelse>		
		<cfif #getList_qry.EX_41# eq "Y">
			<cfset approvalIRAS = "Y">
			<cfset date_approval = #dateformat(getList_qry.EX_42,'YYYYMMDD')#>
		<cfelseif #getList_qry.EX_41# eq "N">
			<cfset approvalIRAS = " ">
			<cfset date_approval = "        ">
		</cfif>	
	</cfif>
		
		
<!----	<cfset emp_bank_cat= "#getList_qry.bankcat#">
		<cfquery name="select_bank_code" datasource="#dts#">
				SELECT aps_num FROM address WHERE org_type in ('BANK') and category="#getList_qry.bankcat#"
		</cfquery>
		<cfif select_bank_code.aps_num eq "5">
				<cfset name_of_bank= "1">
		<cfelseif select_bank_code.aps_num eq "23">
				<cfset name_of_bank= "2">
		<cfelseif select_bank_code.aps_num eq "16">
				<cfset name_of_bank= "3">
		<cfelse>
				<cfset name_of_bank= "4">
		</cfif> --------------------------------->
	<cfset name_of_bank= " ">	
		<cfif #getList_qry.bankcode# eq "7171">
			<cfset name_of_bank= "1">
		<cfelseif #getList_qry.bankcode# eq "7375">
			<cfset name_of_bank= "2">
		<cfelseif #getList_qry.bankcode# eq "7339">
			<cfset name_of_bank= "3">
		<cfelseif #getList_qry.bankcode# neq "" and #getList_qry.bankcode# neq "7171" and #getList_qry.bankcode# neq "7375" and #getList_qry.bankcode# neq "7339">
			<cfset name_of_bank= "4">
		</cfif>	
	
	<!-----------------Benefits-in-kind indicator--------------------->
	<cfif recindi eq "A">
	<cfset BIK = int(val(getList_qry.amd_ben_kind))>
	<cfelse>
	<cfset BIK = int(val(getList_qry.EAFIG09))>
	</cfif>
	
	<cfif BIK neq 0>
		<cfset BIK_ind = "Y">
	<cfelse>
		<cfset BIK_ind = "N">
	</cfif>
		
			

<cfset detail92 = "RFF"&SPACE(2)&"AWM"&ID_TYPE>
<cfset detail92 = detail92&space(255-len(detail92))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail92#">

<cfset detail93 = "RFF"&SPACE(2)&"AWO"&nationality>
<cfset detail93 = detail93&space(255-len(detail93))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail93#">

<cfset detail94 = "RFF"&SPACE(2)&"AWP"&UCASE(getList_qry.sex)>
<cfset detail94 = detail94&space(255-len(detail94))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail94#">

<cfset detail95 = "RFF"&SPACE(2)&"AWQ"&BIK_ind>
<cfset detail95 = detail95&space(255-len(detail95))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail95#">

<cfset detail96 = "RFF"&SPACE(2)&"AWR"&S45>
<cfset detail96 = detail96&space(255-len(detail96))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail96#">

<cfset detail97 = "RFF"&SPACE(2)&"AWS"&inc_tax_bor>
<cfset detail97 = detail97&space(255-len(detail97))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail97#">

<cfset detail98 = "RFF"&SPACE(2)&"AWT"&Gratuity>
<cfset detail98 = detail98&space(255-len(detail98))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail98#">

<cfset detail99 = "RFF"&SPACE(2)&"AWU"&Com_ReT_Oth>
<cfset detail99 = detail99&space(255-len(detail99))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail99#">

<cfset detail910 = "RFF"&SPACE(2)&"AWV"&Cess_Pro>
<cfset detail910 = detail910&space(255-len(detail910))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail910#">

<cfset detail911 = "RFF"&SPACE(2)&"AWW"&formIRAS>
<cfset detail911 = detail911&space(255-len(detail911))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail911#">

<cfset detail912 = "RFF"&SPACE(2)&"AWX"&gross_ind>
<cfset detail912 = detail912&space(255-len(detail912))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail912#">

<cfset detail913 = "RFF"&SPACE(2)&"AWB"&res_add_ind>
<cfset detail913 = detail913&space(255-len(detail913))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail913#">

<cfset detail914 = "RFF"&SPACE(2)&"AWC"&exempt>
<cfset detail914 = detail914&space(255-len(detail914))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail914#">

<cfset detail915 = "RFF"&SPACE(2)&"AWD"&approvalIRAS>
<cfset detail915 = detail915&space(255-len(detail915))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail915#">

<cfset detail916 = "RFF"&SPACE(2)&"AWE"&name_of_bank>
<cfset detail916 = detail916&space(255-len(detail916))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail916#">

<!--------------------------Detail 10 ----------------------------------->
<cfif #getList_qry.jtitle# neq "" and #ID_TYPE# neq "5" and #ID_TYPE# neq "6">
<cfset designation1= "#left(getList_qry.jtitle,30)#">
<cfset designation = designation1>
<cfloop condition="len(designation) lt 30">
	<cfset designation = designation&" " >
</cfloop>
<cfelseif #ID_TYPE# eq "5" or #ID_TYPE# eq "6">
<cfset designation = "DIRECTOR">
<cfloop condition="len(designation) lt 30">
	<cfset designation = designation&" " >
</cfloop>
<cfelse>
	<cfset designation= space(30)>
</cfif>	
	
<cfset postcode3 = "      ">
<cfif addtype eq "L">
<cfset postcode3 = postcode1>
<cfelseif addtype eq "C">
<cfset postcode3 = postcode2>
</cfif>

<cfset detail10 = "NAD"&SPACE(2)&"PE"&SPACE(1)&num_ID&space(41-len(num_ID))&designation&space(70-len(designation))&line1&space(35-len(line1))&line2&space(35-len(line2))&line3&space(35-len(line3))&name1&space(178-len(name1))&block_num&space(35-len(block_num))&street_name&space(70-len(street_name))&LevelNo&space(35-len(LevelNo))&UnitNo&space(44-len(UnitNo))&postcode3&country_code>
<cfset detail10 = detail10&space(595-len(detail10))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail10#">

<!--------------------------Detail 11------------------------------------>

<cfset other = 0>
<cfset totalamt = 0>

<cfif recindi eq "A">	
<cfset tbonus = int(val(getList_qry.amd_bonus))	>
<cfset other = 	int(val(getList_qry.amd_com)) + int(val(getList_qry.amd_pen)) + int(val(getList_qry.amd_tran_alw)) + int(val(getList_qry.amd_ent_alw))
				+ int(val(getList_qry.amd_oth_alw)) + int(val(getList_qry.amd_grat)) + int(val(getList_qry.amd_1993)) + int(val(getList_qry.amd_con_yer))
				+ int(val(getList_qry.amd_exces_yer)) + int(val(getList_qry.amd_gain_prof)) + int(val(getList_qry.amd_ben_kind))>
<cfset totalamt = int(val(getList_qry.amd_salary)) + int(val(tbonus)) + int(val(getList_qry.amd_dif)) + int(val(other)) >

<cfelse>
	
<cfset tbonus = int(VAL(getList_qry.EA_BONUS)) + int(VAL(getList_qry.bonusfrny))>
<cfset other = int(val(getList_qry.EA_COMM))+int(val(getList_qry.EAFIG02))+ int(val(getList_qry.EA_AW_T))
				+ int(val(getList_qry.EA_AW_E))+ int(val(getList_qry.EA_AW_O))+ int(val(getList_qry.ecfig05))+ int(val(getList_qry.EAFIG05))
				+ int(val(getList_qry.EAFIG06))+ int(val(getList_qry.EA_EPFCEXT))+ int(val(getList_qry.EAFIG08))+ int(val(getList_qry.EAFIG09))>
<cfset totalamt = int(VAL(getList_qry.EA_BASIC)) + int(val(tbonus))+ int(val(getList_qry.ea_dirf))+ int(val(other))>
</cfif>

<cfset a = totalamt>
<cfset b = round(a)>
			<cfif b-a lte 0>
				<cfset totalamt2 = round(a)>
			<cfelse>
				<cfset totalamt2 = round(a-1)>
			</cfif>
			
<cfif recindi eq "A">			
<cfloop condition="len(totalamt2) lt 10">
		<cfset totalamt2 = totalamt2&" " >
</cfloop>
<cfelse>
<cfloop condition="len(totalamt2) lt 9">
		<cfset totalamt2 = Rereplace("#totalamt2#","-","","All")&" " >
</cfloop>	
</cfif>				
			
<!-------------------------donation -------------------------->

<cfif recindi eq "A">
<cfset donation ="#ceiling(val(getList_qry.amd_donation))#">	
<cfloop condition="len(donation) lt 6">
		<cfset donation = donation&" " >
</cfloop>
<cfelse>
<cfset donation ="#ceiling(val(getList_qry.EA_DED))#">	
<cfloop condition="len(donation) lt 5">
		<cfset donation = Rereplace("#donation#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------------CPF------------------------------>
<cfif recindi eq "A">
<cfset CPF ="#ceiling(val(getList_qry.amd_yee_cont_cpf))#">		
<cfloop condition="len(CPF) lt 8">
		<cfset CPF = CPF&" " >
</cfloop>
<cfelse>
<cfset CPF ="#ceiling(val(getList_qry.EA_EPF))#">	
<cfloop condition="len(CPF) lt 7">
		<cfset CPF = Rereplace("#CPF#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------------Insurance------------------------>
<cfif recindi eq "A">
<cfset insurance = "#ceiling(val(getList_qry.amd_insur))#">	
<cfloop condition="len(insurance) lt 6">
		<cfset insurance = insurance&" " >
</cfloop>
<cfelse>
<cfset insurance = "#ceiling(val(getList_qry.ins_ded))#">	
<cfloop condition="len(insurance) lt 5">
		<cfset insurance = Rereplace("#insurance#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------------Salary----------------------------->
<cfif recindi eq "A">
<cfset salary = int(VAL(getList_qry.amd_salary))>	
<cfloop condition="len(salary) lt 10">
		<cfset salary = salary&" " >
</cfloop>
<cfelse>
<cfset salary = int(VAL(getList_qry.EA_BASIC))>	
<cfloop condition="len(salary) lt 9">
		<cfset salary = Rereplace("#salary#","-","","All")&" " >
</cfloop>
</cfif>	

<!------------------------------Bonus-------------------------------->
<cfif recindi eq "A">	
<cfset a= VAL(getList_qry.amd_bonus)>
<cfelse>	
<cfset a=VAL(getList_qry.EA_BONUS) + VAL(getList_qry.bonusfrny)>
</cfif>

<cfset b=round(a)>
		<cfif b-a lte 0>
			<cfset bonus2 = round(a)>
		<cfelse>
			<cfset bonus2 = round(a-1)>
		</cfif>
<cfif recindi eq "A">		
<cfloop condition="len(bonus2) lt 10">
		<cfset bonus2 = bonus2&" " >
</cfloop>
<cfelse>
<cfloop condition="len(bonus2) lt 9">
		<cfset bonus2 = Rereplace("#bonus2#","-","","All")&" " >
</cfloop>
</cfif>	

<!-------------------------Director's Fee------------------------>
<cfif recindi eq "A">
<cfset a= val(getList_qry.amd_dif)>
<cfelse>
<cfset a= val(getList_qry.ea_dirf)>
</cfif>

<cfset b=round(a)>
		<cfif b-a lte 0>
			<cfset dirfee = round(a)>
		<cfelse>
			<cfset dirfee = round(a-1)>
		</cfif>
<cfif recindi eq "A">		
<cfloop condition="len(dirfee) lt 10">
		<cfset dirfee = dirfee&" " >
</cfloop>
<cfelse>
<cfloop condition="len(dirfee) lt 9">
		<cfset dirfee = Rereplace("#dirfee#","-","","All")&" " >
</cfloop>
</cfif>	

<!---------------------------Other--------------------------->
<cfif recindi eq "A">
<cfloop condition="len(other) lt 10">
		<cfset other = other&" " >
</cfloop>
<cfelse>
<cfloop condition="len(other) lt 9">
		<cfset other = Rereplace("#other#","-","","All")&" " >
</cfloop>
</cfif>

<!------------------------Gross Commission--------------------->
<cfif recindi eq "A">
<cfset gross_comm= int(val(getList_qry.amd_com))>
<cfset gross_comm = numberformat(gross_comm,'.__')>		
<cfloop condition="len(gross_comm) lt 13">
		<cfset gross_comm = gross_comm&" " >
</cfloop>
<cfelse>
<cfset gross_comm= int(val(getList_qry.EA_COMM))>
<cfset gross_comm = numberformat(gross_comm,'.__')>	
<cfloop condition="len(gross_comm) lt 12">
		<cfset gross_comm = Rereplace("#gross_comm#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------Pension------------------------------------>	
<cfif recindi eq "A">
<cfset pension= int(val(getList_qry.amd_pen))>	
<cfset pension = numberformat(pension,'.__')>		
<cfloop condition="len(pension) lt 13">
		<cfset pension = pension&" " >
</cfloop>
<cfelse>
<cfset pension= int(val(getList_qry.EAFIG02))>
<cfset pension = numberformat(pension,'.__')>	
<cfloop condition="len(pension) lt 12">
		<cfset pension = Rereplace("#pension#","-","","All")&" " >
</cfloop>	
</cfif>		

<!-----------------------Transport Allowance------------------------>
<cfif recindi eq "A">
<cfset tran= int(val(getList_qry.amd_tran_alw))>
<cfset tran = numberformat(tran,'.__')>	
<cfloop condition="len(tran) lt 13">
		<cfset tran = tran&" " >
</cfloop>
<cfelse>
<cfset tran= int(val(getList_qry.EA_AW_T))>
<cfset tran = numberformat(tran,'.__')>	
<cfloop condition="len(tran) lt 12">
		<cfset tran = Rereplace("#tran#","-","","All")&" " >
</cfloop>
</cfif>	

<!--------------------Entertaiment Allowance---------------------->
<cfif recindi eq "A">
<cfset Ent= int(val(getList_qry.amd_ent_alw))>
<cfset Ent = numberformat(Ent,'.__')>			
<cfloop condition="len(Ent) lt 13">
		<cfset Ent = Ent&" " >
</cfloop>
<cfelse>
<cfset Ent= int(val(getList_qry.EA_AW_E))>
<cfset Ent = numberformat(Ent,'.__')>	
<cfloop condition="len(Ent) lt 12">
		<cfset Ent = Rereplace("#Ent#","-","","All")&" " >
</cfloop>
</cfif>			

<!-------------------Other Allowance-------------------------------->
<cfif recindi eq "A">
<cfset sec37_other1= int(val(getList_qry.amd_oth_alw))>
<cfset sec37_other1 = numberformat(sec37_other1,'.__')>	
<cfloop condition="len(sec37_other1) lt 13">
		<cfset sec37_other1 = sec37_other1&" " >
</cfloop>
<cfelse>
<cfset sec37_other1= int(val(getList_qry.EA_AW_O))>
<cfset sec37_other1 = numberformat(sec37_other1,'.__')>	
<cfloop condition="len(sec37_other1) lt 12">
		<cfset sec37_other1 = Rereplace("#sec37_other1#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------Gratuity---------------------------------->
<cfif recindi eq "A">
<cfset gratuity1= int(val(getList_qry.amd_grat))>
<cfset gratuity1 = numberformat(gratuity1,'.__')>	
<cfloop condition="len(gratuity1) lt 13">
		<cfset gratuity1 = gratuity1&" " >
</cfloop>
<cfelse>
<cfset gratuity1= int(val(getList_qry.ecfig05))>
<cfset gratuity1 = numberformat(gratuity1,'.__')>	
<cfloop condition="len(gratuity1) lt 12">
		<cfset gratuity1 = Rereplace("#gratuity1#","-","","All")&" " >
</cfloop>
</cfif>	

<!---------------------1992--------------------------------->
<cfif recindi eq "A">
<cfset retirement_ben1= int(val(getList_qry.amd_1992))>
<cfset retirement_ben1 = numberformat(retirement_ben1,'.__')>	
<cfloop condition="len(retirement_ben1) lt 13">
		<cfset retirement_ben1 = retirement_ben1&" " >
</cfloop>
<cfelse>
<cfset retirement_ben1= int(val(getList_qry.EAFIG07))>
<cfset retirement_ben1 = numberformat(retirement_ben1,'.__')>	
<cfloop condition="len(retirement_ben1) lt 12">
		<cfset retirement_ben1 = Rereplace("#retirement_ben1#","-","","All")&" " >
</cfloop>
</cfif>	

<!----------------------1993-------------------------------->
<cfif recindi eq "A">
<cfset retire_ben_1993_1= int(val(getList_qry.amd_1993))>
<cfset retire_ben_1993_1 = numberformat(retire_ben_1993_1,'.__')>	
<cfloop condition="len(retire_ben_1993_1) lt 13">
		<cfset retire_ben_1993_1 = retire_ben_1993_1&" " >
</cfloop>
<cfelse>
<cfset retire_ben_1993_1= int(val(getList_qry.EAFIG05))>
<cfset retire_ben_1993_1 = numberformat(retire_ben_1993_1,'.__')>	
<cfloop condition="len(retire_ben_1993_1) lt 12">
		<cfset retire_ben_1993_1 = Rereplace("#retire_ben_1993_1#","-","","All")&" " >
</cfloop>
</cfif>	

<!-------------------Contribution MADE by employer to any pension---->
<cfif recindi eq "A">
<cfset sec41_con1= int(val(getList_qry.amd_con_yer))>
<cfset sec41_con1 = numberformat(sec41_con1,'.__')>	
<cfloop condition="len(sec41_con1) lt 13">
		<cfset sec41_con1 = sec41_con1&" " >
</cfloop>
<cfelse>
<cfset sec41_con1= int(val(getList_qry.EAFIG06))>
<cfset sec41_con1 = numberformat(sec41_con1,'.__')>	
<cfloop condition="len(sec41_con1) lt 12">
		<cfset sec41_con1 = Rereplace("#sec41_con1#","-","","All")&" " >
</cfloop>
</cfif>	

<!---------Excess/voluntary contribution to CPF by employer---------->
<cfif recindi eq "A">
<cfset sec42_execess1= int(val(getList_qry.amd_exces_yer))>
<cfset sec42_execess1 = numberformat(sec42_execess1,'.__')>	
<cfloop condition="len(sec42_execess1) lt 13">
		<cfset sec42_execess1 = sec42_execess1&" " >
</cfloop>
<cfelse>
<cfset sec42_execess1= int(val(getList_qry.EA_EPFCEXT))>
<cfset sec42_execess1 = numberformat(sec42_execess1,'.__')>	
<cfloop condition="len(sec42_execess1) lt 12">
		<cfset sec42_execess1 = Rereplace("#sec42_execess1#","-","","All")&" " >
</cfloop>
</cfif>	

<!--------------Gains and profits from ESOP/ESOW Plans------------>
<cfif recindi eq "A">
<cfset sec43_gains1= int(val(getList_qry.amd_gain_prof))>
<cfset sec43_gains1 = numberformat(sec43_gains1,'.__')>	
<cfloop condition="len(sec43_gains1) lt 13">
		<cfset sec43_gains1 = sec43_gains1&" " >
</cfloop>
<cfelse>
<cfset sec43_gains1= int(val(getList_qry.EAFIG08))>
<cfset sec43_gains1 = numberformat(sec43_gains1,'.__')>	
<cfloop condition="len(sec43_gains1) lt 12">
		<cfset sec43_gains1 = Rereplace("#sec43_gains1#","-","","All")&" " >
</cfloop>
</cfif>

<!-----------------Value of benefits-in-kind--------------------->
<cfif recindi eq "A">
<cfset sec44_value1= int(val(getList_qry.amd_ben_kind))>
<cfset sec44_value1 = numberformat(sec44_value1,'.__')>	
<cfloop condition="len(sec44_value1) lt 13">
		<cfset sec44_value1 = sec44_value1&" " >
</cfloop>
<cfelse>
<cfset sec44_value1= int(val(getList_qry.EAFIG09))>
<cfset sec44_value1 = numberformat(sec44_value1,'.__')>	
<cfloop condition="len(sec44_value1) lt 12">
		<cfset sec44_value1 = Rereplace("#sec44_value1#","-","","All")&" " >
</cfloop>	
</cfif>

<!------ Employee voluntary contribution to CPF obligatory by contract of employment (Overseas posting) ------------>
<cfset sec45_empyee= 0>
<cfif recindi eq "A">
<cfloop condition="len(sec45_empyee) lt 8">
		<cfset sec45_empyee = sec45_empyee&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sec45_empyee) lt 7">
		<cfset sec45_empyee = Rereplace("#sec45_empyee#","-","","All")&" " >
</cfloop>
</cfif>

<!----------------------Mosque Building Fund ------------------>
<cfif recindi eq "A">
<cfset MBF = "#ceiling(val(getList_qry.amd_mbf))#" >	
<cfloop condition="len(MBF) lt 6">
		<cfset MBF = MBF&" " >
</cfloop>
<cfelse>
<cfset MBF = "#ceiling(val(getList_qry.EAFIG15))#" >	
<cfloop condition="len(MBF) lt 5">
		<cfset MBF = Rereplace("#MBF#","-","","All")&" " >
</cfloop>
</cfif>

<!------------------Income exempt/subject to tax remission---->
<cfif recindi eq "A">
<cfset sec20_Exe_Income = int(val(getList_qry.amd_exe_tax_remi))>	
<cfloop condition="len(sec20_Exe_Income) lt 10">
		<cfset sec20_Exe_Income = sec20_Exe_Income&" " >
</cfloop>
<cfelse>	
<cfset sec20_Exe_Income = int(val(getList_qry.EX_33))>	
<cfloop condition="len(sec20_Exe_Income) lt 9">
		<cfset sec20_Exe_Income = Rereplace("#sec20_Exe_Income#","-","","All")&" " >
</cfloop>
</cfif>

<!------------------Income for which tax is borne by employer----->
<cfset sec21_amt_of_er = 0>
<cfif #getList_qry.EX_34# neq 0 and #getList_qry.EX_38# eq "P" or #getList_qry.amd_tax_yer# and #getList_qry.EX_38# eq "P">
	<cfif recindi eq "A">
		<cfset sec21_amt_of_er = int(val(getList_qry.amd_tax_yer))>
	<cfelse>
		<cfset sec21_amt_of_er = int(val(getList_qry.EX_34))>
	</cfif>	
</cfif>
<cfif recindi eq "A">
<cfloop condition="len(sec21_amt_of_er) lt 10">
		<cfset sec21_amt_of_er = sec21_amt_of_er&" " >
</cfloop>	
<cfelse>
<cfloop condition="len(sec21_amt_of_er) lt 9">
		<cfset sec21_amt_of_er = Rereplace("#sec21_amt_of_er#","-","","All")&" " >
</cfloop>
</cfif>

<!---------------Fixed amount of Income Tax borne by employee----->
<cfset sec22_fix_amt_ee = 0>
<cfif #getList_qry.EX_35# neq 0 and #getList_qry.EX_38# eq "H" or #getList_qry.amd_tax_yee# and #getList_qry.EX_38# eq "H">
	<cfif recindi eq "A">
		<cfset sec22_fix_amt_ee = int(val(getList_qry.amd_tax_yee))>
	<cfelse>
		<cfset sec22_fix_amt_ee = int(val(getList_qry.EX_35))>
	</cfif>		
</cfif>
<cfif recindi eq "A">
<cfloop condition="len(sec22_fix_amt_ee) lt 10">
		<cfset sec22_fix_amt_ee = sec22_fix_amt_ee&" " >
</cfloop>		
<cfelse>	
<cfloop condition="len(sec22_fix_amt_ee) lt 9">
		<cfset sec22_fix_amt_ee = Rereplace("#sec22_fix_amt_ee#","-","","All")&" " >
</cfloop>	
</cfif>

<!-------------Compensation/Retrenchment Benefits/Other----->
<cfif recindi eq "A">
<cfset sec38a_comp1= int(val(getList_qry.amd_com_ret)) >
<cfset sec38a_comp1 = numberformat(sec38a_comp1,'.__')>	
<cfloop condition="len(sec38a_comp1) lt 13">
		<cfset sec38a_comp1 = sec38a_comp1&" " >
</cfloop>
<cfelse>
<cfset sec38a_comp1= int(val(getList_qry.EX_56)) >
<cfset sec38a_comp1 = numberformat(sec38a_comp1,'.__')>	
<cfloop condition="len(sec38a_comp1) lt 12">
		<cfset sec38a_comp1 = Rereplace("#sec38a_comp1#","-","","All")&" " >
</cfloop>
</cfif>

<!-------------Gains & Profit from Share Option granted before 01/01/2003 S10(1)(g)----->
<cfset Gain_Share = 0>
<cfif #getList_qry.EX_32# neq 0 and #getList_qry.EX_32# neq "">
	<cfif recindi eq "A">
		<cfset Gain_Share = val(getList_qry.amd_gain_profit)>
	<cfelse>
		<cfset Gain_Share = val(getList_qry.EX_32)>
	</cfif>	
</cfif>	
<cfif recindi eq "A">
<cfloop condition="len(Gain_Share) lt 10">
		<cfset Gain_Share = Gain_Share&" " >
</cfloop>
<cfelse>
<cfloop condition="len(Gain_Share) lt 9">
		<cfset Gain_Share = Rereplace("#Gain_Share#","-","","All")&" " >
</cfloop>
</cfif>

<cfset detail111 = "MOA"&SPACE(2)&"128"&totalamt2>
<cfset detail111 = detail111&space(255-len(detail111))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail111#">

<cfset detail112 = "MOA"&SPACE(2)&"367"&donation>
<cfset detail112 = detail112&space(255-len(detail112))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail112#">

<cfset detail113 = "MOA"&SPACE(2)&"368"&CPF>
<cfset detail113 = detail113&space(255-len(detail113))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail113#">

<cfset detail114 = "MOA"&SPACE(2)&"67"&SPACE(1)&insurance>
<cfset detail114 = detail114&space(255-len(detail114))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail114#">

<cfset detail115 = "MOA"&SPACE(2)&"776"&salary>
<cfset detail115 = detail115&space(255-len(detail115))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail115#">

<cfset detail116 = "MOA"&SPACE(2)&"369"&bonus2>
<cfset detail116 = detail116&space(255-len(detail116))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail116#">

<cfset detail117 = "MOA"&SPACE(2)&"340"&dirfee>
<cfset detail117 = detail117&space(255-len(detail117))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail117#">

<cfset detail118 = "MOA"&SPACE(2)&"275"&other>
<cfset detail118 = detail118&space(255-len(detail118))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail118#">

<cfset detail119 = "MOA"&SPACE(2)&"265"&gross_comm>
<cfset detail119 = detail119&space(255-len(detail119))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail119#">

<cfset detail1110 = "MOA"&SPACE(2)&"341"&pension>
<cfset detail1110 = detail1110&space(255-len(detail1110))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1110#">

<cfset detail1111 = "MOA"&SPACE(2)&"342"&tran>
<cfset detail1111 = detail1111&space(255-len(detail1111))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1111#">

<cfset detail1112 = "MOA"&SPACE(2)&"343"&Ent>
<cfset detail1112 = detail1112&space(255-len(detail1112))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1112#">

<cfset detail1113 = "MOA"&SPACE(2)&"344"&sec37_other1>
<cfset detail1113 = detail1113&space(255-len(detail1113))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1113#">

<cfset detail1114 = "MOA"&SPACE(2)&"345"&gratuity1>
<cfset detail1114 = detail1114&space(255-len(detail1114))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1114#">

<cfset detail1115 = "MOA"&SPACE(2)&"346"&retirement_ben1>
<cfset detail1115 = detail1115&space(255-len(detail1115))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1115#">

<cfset detail1116 = "MOA"&SPACE(2)&"347"&retire_ben_1993_1>
<cfset detail1116 = detail1116&space(255-len(detail1116))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1116#">

<cfset detail1117 = "MOA"&SPACE(2)&"348"&sec41_con1>
<cfset detail1117 = detail1117&space(255-len(detail1117))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1117#">

<cfset detail1118 = "MOA"&SPACE(2)&"349"&sec42_execess1>
<cfset detail1118 = detail1118&space(255-len(detail1118))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1118#">

<cfset detail1119 = "MOA"&SPACE(2)&"350"&sec43_gains1>
<cfset detail1119 = detail1119&space(255-len(detail1119))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1119#">

<cfset detail1120 = "MOA"&SPACE(2)&"351"&sec44_value1>
<cfset detail1120 = detail1120&space(255-len(detail1120))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1120#">

<cfset detail1121 = "MOA"&SPACE(2)&"352"&sec45_empyee>
<cfset detail1121 = detail1121&space(255-len(detail1121))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1121#">

<cfset detail1122 = "MOA"&SPACE(2)&"366"&MBF>
<cfset detail1122 = detail1122&space(255-len(detail1122))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1122#">

<cfset detail1123 = "MOA"&SPACE(2)&"370"&sec20_Exe_Income>
<cfset detail1123 = detail1123&space(255-len(detail1123))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1123#">

<cfset detail1124 = "MOA"&SPACE(2)&"371"&sec21_amt_of_er>
<cfset detail1124 = detail1124&space(255-len(detail1124))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1124#">

<cfset detail1125 = "MOA"&SPACE(2)&"372"&sec22_fix_amt_ee>
<cfset detail1125 = detail1125&space(255-len(detail1125))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1125#">

<cfset detail1126 = "MOA"&SPACE(2)&"373"&sec38a_comp1>
<cfset detail1126 = detail1126&space(255-len(detail1126))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1126#">

<cfset detail1127 = "MOA"&SPACE(2)&"374"&Gain_Share>
<cfset detail1127 = detail1127&space(255-len(detail1127))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail1127#">

<!------------------------Deatail 12--------------------------------->
		
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
		
		<cfif getList_qry.EXTRADATE1 neq "">
			<cfset sec50_date_dirfee= "#dateformat(getList_qry.EXTRADATE1,'YYYYMMDD')#">
		<cfelse>
			<cfset sec50_date_dirfee = "        ">
		</cfif>
		
		<cfif getList_qry.BONUSDATE1 neq "">
			<cfset sec49_date_bonus="#dateformat(getList_qry.BONUSDATE1,'YYYYMMDD')#">
		<cfelse>
			<cfset sec49_date_bonus = "        ">
		</cfif>

<!----	<cfif date_rsgn2 neq "">
		<cfset date_of_payroll = date_rsgn2>
		<cfelse>
		<cfset date_of_payroll = #getComp_qry.myear#&"1212">
		</cfif>  -------->
		
<cfset date_of_payroll = #dateformat(lastdays,'YYYYMMDD')#>

<cfset detail12_1 = "DTM"&SPACE(2)&"329"&DOB&"102">
<cfset detail12_1 = detail12_1&space(255-len(detail12_1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_1#">	
	
<cfset detail12_2 = "DTM"&SPACE(2)&"155"&from_date&"102">
<cfset detail12_2 = detail12_2&space(255-len(detail12_2))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_2#">	

<cfset detail12_3 = "DTM"&SPACE(2)&"156"&to_date&"102">
<cfset detail12_3 = detail12_3&space(255-len(detail12_3))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_3#">	

<cfset detail12_4 = "DTM"&SPACE(2)&"157"&sec47DateComm&"102">
<cfset detail12_4 = detail12_4&space(255-len(detail12_4))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_4#">	

<cfset detail12_5 = "DTM"&SPACE(2)&"158"&date_rsgn2&"102">
<cfset detail12_5 = detail12_5&space(255-len(detail12_5))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_5#">	

<cfset detail12_6 = "DTM"&SPACE(2)&"159"&sec32aFromDate&"102">
<cfset detail12_6 = detail12_6&space(255-len(detail12_6))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_6#">	

<cfset detail12_7 = "DTM"&SPACE(2)&"160"&sec32bToDate&"102">
<cfset detail12_7 = detail12_7&space(255-len(detail12_7))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_7#">	

<cfset detail12_8 = "DTM"&SPACE(2)&"161"&sec49_date_bonus&"102">
<cfset detail12_8 = detail12_8&space(255-len(detail12_8))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_8#">	

<cfset detail12_9 = "DTM"&SPACE(2)&"162"&sec50_date_dirfee&"102">
<cfset detail12_9 = detail12_9&space(255-len(detail12_9))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_9#">	

<cfset detail12_10 = "DTM"&SPACE(2)&"163"&date_approval&"102">
<cfset detail12_10 = detail12_10&space(255-len(detail12_10))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_10#">	

<cfset detail12_11 = "DTM"&SPACE(2)&"164"&date_of_payroll&"102">
<cfset detail12_11 = detail12_11&space(255-len(detail12_11))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail12_11#">	

<!-----------------------------Detail 13 ---------------------------->

<cfset sec51_name_of_fund = "                                                            ">
<cfif val(retirement_ben1) neq 0 or val(retire_ben_1993_1) neq 0>
<cfif getList_qry.EATXT9 neq "">
				<cfset sec51_name_of_fund="#getList_qry.EATXT9#">
				<cfloop condition="len(sec51_name_of_fund) lt 60">
			<cfset sec51_name_of_fund = sec51_name_of_fund&" " >
			</cfloop>			
</cfif>
</cfif>	

<cfset sec52_name_desgn = "                                                            ">
<cfif val(CPF) neq 0>
<cfif #getList_qry.EX_70# neq "">
				<cfset sec52_name_desgn = "#getList_qry.EX_70#">
				<cfloop condition="len(sec52_name_desgn) lt 60">
					<cfset sec52_name_desgn = sec52_name_desgn&" " >
				</cfloop>	
</cfif>
</cfif>
	
		
<cfset detail13_1 = "FTX"&SPACE(2)&"AEV"&SPACE(26)&sec51_name_of_fund>
<cfset detail13_1 = detail13_1&space(255-len(detail13_1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail13_1#">

<cfset detail13_2 = "FTX"&SPACE(2)&"AEW"&SPACE(26)&sec52_name_desgn>
<cfset detail13_2 = detail13_2&space(255-len(detail13_2))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail13_2#">	

<cfif num_ID neq 0 and postcode3 neq 0 
					and ID_TYPE neq 0 and nationality neq "" 
					and name1 neq "" 
					and DOB neq 0
					and from_date neq 0 
					and to_date neq 0 
					and #getList_qry.jtitle# neq "">
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
                <td>Date Coommerce</td>
                <td>Date Resign</td>
				<td>Designation</td>
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
				<td>#getList_qry.jtitle#</td>
                </tr>
                </table>
                </cfoutput>
                <cfset datawrong = 1>
			</cfif>
			
			
	</cfloop>
	<cfif isdefined('datawrong')>
    <cfabort>
	</cfif>


<!----------------------------------Trailer 14----------------------------------->

#record_count#
<cfset detail14_1 = "RFF"&SPACE(2)&"AWJ"&"2"&SPACE(5)>
<cfset detail14_1 = detail14_1&space(255-len(detail14_1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail14_1#">

<cfset detail14_2 = "RFF"&SPACE(2)&"AWY"&record_count&SPACE(6-len(record_count))>
<cfset detail14_2 = detail14_2&space(255-len(detail14_2))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail14_2#">

<!--------------------------------Trailer 15------------------------------------->
<cfif recindi eq "A">
<cfquery name="sumAll" datasource="#dts#">
	SELECT sum(coalesce(FLOOR(amd_com),0))+sum(coalesce(FLOOR(amd_pen),0))+sum(coalesce(FLOOR(amd_tran_alw),0))+sum(coalesce(FLOOR(amd_ent_alw),0))
	+sum(coalesce(FLOOR(amd_oth_alw),0))+sum(coalesce(FLOOR(amd_grat),0))+sum(coalesce(FLOOR(amd_1993),0))+sum(coalesce(FLOOR(amd_con_yer),0))+
	sum(coalesce(FLOOR(amd_exces_yer),0))+sum(coalesce(FLOOR(amd_gain_prof),0))+sum(coalesce(FLOOR(amd_ben_kind),0))as sum_Other,
	sum(coalesce(FLOOR(amd_salary),0)) as sum_Salary, sum(coalesce(FLOOR(amd_dif),0))as sumDirFee,
	sum(coalesce(FLOOR(amd_bonus),0)) as sum_bonus, 
	sum(coalesce(ceiling(amd_donation),0)) as sumdonation,
	sum(coalesce(ceiling(amd_yee_cont_cpf),0)) as sumcpf, 
	sum(coalesce(ceiling(amd_mbf),0)) as sumMBF,
	sum(coalesce(ceiling(amd_exe_tax_remi),0)) as sum_exem_income,
	sum(coalesce(ceiling(amd_tax_yer),0)) as sum_Borne_emper,
	sum(coalesce(ceiling(amd_tax_yee),0)) as sum_Borne_empee,
	sum(coalesce(ceiling(amd_insur),0)) as sum_insurance
	FROM itaxea as i left join pmast as p on p.empno=i.empno
	WHERE 0=0 AND p.confid >= #hpin#
		  <cfif form.empnoFrom neq ""> AND i.empno >= '#form.empnoFrom#'</cfif>
		  <cfif form.empnoTo neq ""> AND i.empno <= '#form.empnoTo#'</cfif>
		  <cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
		  and itaxcat <> "X"
		  <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0)</cfif>
		  order by p.empno
	</cfquery>	
<cfelse>	
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
		  <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0)</cfif>
		  order by p.empno
	</cfquery>
</cfif>	
	
<cfset total_sum_amt= int(val(sumAll.sum_Other)) + int(val(sumAll.sumDirFee)) + int(val(sumAll.sum_Salary)) + int(val(sumAll.sum_bonus))>
<cfif recindi eq "A">
<cfloop condition="len(total_sum_amt) lt 13">
		<cfset total_sum_amt = total_sum_amt&" " >
</cfloop>
<cfelse>
<cfloop condition="len(total_sum_amt) lt 12">
		<cfset total_sum_amt = Rereplace("#total_sum_amt#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_salary= #int(val(sumAll.sum_Salary))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_salary) lt 13">
		<cfset sum_salary = sum_salary&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_salary) lt 12">
		<cfset sum_salary = Rereplace("#sum_salary#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_Bonus= #int(val(sumAll.sum_bonus))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_Bonus) lt 13">
		<cfset sum_Bonus = sum_Bonus&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_Bonus) lt 12">
		<cfset sum_Bonus = Rereplace("#sum_Bonus#","-","","All")&" " >
</cfloop>
</cfif>

<cfset sum_sumDirFee= #int(val(sumAll.sumDirFee))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_sumDirFee) lt 13">
		<cfset sum_sumDirFee = sum_sumDirFee&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_sumDirFee) lt 12">
		<cfset sum_sumDirFee = Rereplace("#sum_sumDirFee#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_Other= #int(val(sumAll.sum_Other))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_Other) lt 13">
		<cfset sum_Other = sum_Other&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_Other) lt 12">
		<cfset sum_Other = Rereplace("#sum_Other#","-","","All")&" " >
</cfloop>
</cfif>

<cfset sum_donation ="#ceiling(val(sumAll.sumdonation))#">
<cfif recindi eq "A">
<cfloop condition="len(sum_donation) lt 13">
		<cfset sum_donation = sum_donation&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_donation) lt 12">
		<cfset sum_donation = Rereplace("#sum_donation#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_CPF ="#ceiling(val(sumAll.sumcpf))#">
<cfif recindi eq "A">
<cfloop condition="len(sum_CPF) lt 13">
		<cfset sum_CPF = sum_CPF&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_CPF) lt 12">
		<cfset sum_CPF = Rereplace("#sum_CPF#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_insurance = "#ceiling(val(sumAll.sum_insurance))#">
<cfif recindi eq "A">
<cfloop condition="len(sum_insurance) lt 13">
		<cfset sum_insurance = sum_insurance&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_insurance) lt 12">
		<cfset sum_insurance = Rereplace("#sum_insurance#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_MBF = "#ceiling(val(sumAll.sumMBF))#" >
<cfif recindi eq "A">
<cfloop condition="len(sum_MBF) lt 13">
		<cfset sum_MBF = sum_MBF&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_MBF) lt 12">
		<cfset sum_MBF = Rereplace("#sum_MBF#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_sec20= #int(val(sumAll.sum_exem_income))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_sec20) lt 13">
		<cfset sum_sec20 = sum_sec20&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_sec20) lt 12">
		<cfset sum_sec20 = Rereplace("#sum_sec20#","-","","All")&" " >
</cfloop>
</cfif>

<cfset sum_sec21= #int(val(sumAll.sum_Borne_emper))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_sec21) lt 13">
		<cfset sum_sec21 = sum_sec21&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_sec21) lt 12">
		<cfset sum_sec21 = Rereplace("#sum_sec21#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset sum_sec22= #int(val(sumAll.sum_Borne_empee))#>
<cfif recindi eq "A">
<cfloop condition="len(sum_sec22) lt 13">
		<cfset sum_sec22 = sum_sec22&" " >
</cfloop>
<cfelse>
<cfloop condition="len(sum_sec22) lt 12">
		<cfset sum_sec22 = Rereplace("#sum_sec22#","-","","All")&" " >
</cfloop>
</cfif>	

<cfset detail15_1 = "MOA"&SPACE(2)&"353"&total_sum_amt>
<cfset detail15_1 = detail15_1&space(255-len(detail15_1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_1#">

<cfset detail15_2 = "MOA"&SPACE(2)&"354"&sum_salary>
<cfset detail15_2 = detail15_2&space(255-len(detail15_2))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_2#">

<cfset detail15_3 = "MOA"&SPACE(2)&"355"&sum_Bonus>
<cfset detail15_3 = detail15_3&space(255-len(detail15_3))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_3#">

<cfset detail15_4 = "MOA"&SPACE(2)&"356"&sum_sumDirFee>
<cfset detail15_4 = detail15_4&space(255-len(detail15_4))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_4#">

<cfset detail15_5 = "MOA"&SPACE(2)&"357"&sum_Other>
<cfset detail15_5 = detail15_5&space(255-len(detail15_5))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_5#">

<cfset detail15_6 = "MOA"&SPACE(2)&"358"&sum_donation>
<cfset detail15_6 = detail15_6&space(255-len(detail15_6))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_6#">

<cfset detail15_7 = "MOA"&SPACE(2)&"359"&sum_CPF>
<cfset detail15_7 = detail15_7&space(255-len(detail15_7))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_7#">

<cfset detail15_8 = "MOA"&SPACE(2)&"360"&sum_insurance>
<cfset detail15_8 = detail15_8&space(255-len(detail15_8))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_8#">

<cfset detail15_9 = "MOA"&SPACE(2)&"361"&sum_MBF>
<cfset detail15_9 = detail15_9&space(255-len(detail15_9))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_9#">

<cfset detail15_10 = "MOA"&SPACE(2)&"362"&sum_sec20>
<cfset detail15_10 = detail15_10&space(255-len(detail15_10))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_10#">

<cfset detail15_11 = "MOA"&SPACE(2)&"363"&sum_sec21>
<cfset detail15_11 = detail15_11&space(255-len(detail15_11))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_11#">

<cfset detail15_12 = "MOA"&SPACE(2)&"364"&sum_sec22>
<cfset detail15_12 = detail15_12&space(255-len(detail15_12))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail15_12#">


<!---------------------------Security Result ------------------------------>

<cfset detail16_1 = "RES"&SPACE(2)&"ZZ">
<cfset detail16_1 = detail16_1&space(255-len(detail16_1))>
<cffile action="append" addnewline="yes" file = "#filename#" output = "#detail16_1#">
	
<!---------------------------------End------------------------------------->		
			
<cfset yourFileName="C:\Inetpub\wwwroot\payroll\download\cimsonlogin#uuid#.txt">
		<cfset yourFileName2="crimsonIR8A.txt">
		 
		 <cfcontent type="application/x-unknown"> 
		
		 <cfset thisPath = ExpandPath("#yourFileName#")> 
		 <cfheader name="Content-Disposition" value="attachment; filename=#yourFileName2#">
		 <cfheader name="Content-Description" value="This is a tab-delimited file.">
		 <cfcontent type="Multipart/Report" file="#yourFileName#">
		 <cflocation url="#yourFileName#">