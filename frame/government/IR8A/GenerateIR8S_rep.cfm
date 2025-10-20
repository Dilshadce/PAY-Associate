<cftry>

<cfset uuid= createuuid()>
<cfset uuid = replace(uuid,'-','','all')>
<cfset filenewdir = "C:\Inetpub\wwwroot\payroll\download\#dts#\">
<cfif DirectoryExists(filenewdir) eq false>
<cfdirectory action = "create" directory = "#filenewdir#" >
</cfif>

	<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	
	<cfquery name="getList_qry" datasource="#dts#">
		SELECT * FROM pmast AS a LEFT JOIN itaxea2 AS b ON a.empno=b.empno 
		WHERE 0=0
			  <cfif form.empnoFrom neq ""> AND a.empno >= '#form.empnoFrom#' </cfif>
			  <cfif form.empnoTo neq ""> AND a.empno <= '#form.empnoTo#' </cfif>
	</cfquery>
	
	<cfquery name="getList_qry2" datasource="#dts#">
		SELECT * FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno 
		WHERE 0=0
			  <cfif form.empnoFrom neq ""> AND a.empno >= '#form.empnoFrom#' </cfif>
			  <cfif form.empnoTo neq ""> AND a.empno <= '#form.empnoTo#' </cfif>
	</cfquery>
	
	<cffunction name="drop_decimal" access="public" returntype="Any">
			<cfargument name="a" type="Numeric" required="yes">
				<cfset b=round(a)>
	        	<cfif b-a lte 0>
					<cfset totalamt2 = round(a)>
				<cfelse>
					<cfset totalamt2 = round(a-1)>
				</cfif>
			<cfreturn totalamt2>
	</cffunction>
	
	<cfif form.cat eq "1">	
		
		<!--- header --->
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
				<cfset uen = "#getComp_qry.UEN#">
				<cfloop condition="len(uen) lt 12">
					<cfset uen = uen&" " >
				</cfloop>
			</cfif>
		
			<cfif getComp_qry.pm_name neq "">
				<cfset authorised_name = "#getComp_qry.pm_name#">
			<cfloop condition="len(authorised_name) lt 30">
				<cfset authorised_name = authorised_name&" " >
			</cfloop>
			</cfif>
		
			<cfif getComp_qry.pm_position neq "">
			<cfset Des_of_au_person ="#getComp_qry.pm_position#">
			<cfloop condition="len(Des_of_au_person) lt 30">
			<cfset Des_of_au_person = Des_of_au_person&" " >
			</cfloop>
			<cfelse>
			<cfset Des_of_au_person ="                               " >
			</cfif>
		
		
			<cfif getComp_qry.comp_name neq "">
			<cfset name_emp = "#getComp_qry.comp_name#">
			<cfloop condition="len(name_emp) lt 60">
				<cfset name_emp = name_emp&" " >
			</cfloop>
			</cfif>
		
			<cfif getComp_qry.comp_phone neq "">
			<cfset comp_phone ="#getComp_qry.comp_phone#">
			<cfloop condition="len(comp_phone) lt 80">
				<cfset comp_phone = comp_phone&" " >
			</cfloop>
			<cfelse>
			<cfset comp_phone = " ">
			<cfloop condition="len(comp_phone) lt 80">
				<cfset comp_phone = comp_phone&" " >
			</cfloop>
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
				<cfset Name_of_Division ="                    " >
			</cfif>
		
			<cfset header = "0"&"#source#"&"#basic_year#"&"#orgIDtype#"&"#uen#"&"#authorised_name#"&"#Des_of_au_person#"&"#name_emp#"&"#comp_phone#"&"#Batch_Ind#"&"#Bdate##Name_of_Division#"&"IR8S">
			<cfloop condition="len(header) lt 1200">
			<cfset header = header&" " >
			</cfloop>
		
		<!--- <cfoutput>#header#</cfoutput>  --->
		<cffile action = "write" 
				file = "C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt" 
				output = "#header#">
		
		<!--- end header --->
		<!--- 	start content --->
<!---	<cfset nric = #getList_qry.nricn#>   ---->
<!---	<cfset nnric= replace(nric,"-","","all")>   ---->
		<cfloop query="getList_qry">
			<cfif getList_qry.national eq "SG" OR getList_qry.r_statu eq "PR">
				<cfset ID_TYPE= "1">
			<cfelseif getList_qry.fin neq "">
				<cfset ID_TYPE= "2" >
			<cfelseif getList_qry.IMS neq "">
				<cfset ID_TYPE= "3" >
			<cfelseif getList_qry.r_statu eq "WP">
				<cfset ID_TYPE="4">
			<cfelseif getList_qry.national eq "MY" AND getList_qry.r_statu neq "PR">
				<cfset ID_TYPE= "5">
			<cfelseif getList_qry.passport neq "" AND getList_qry.national neq "SG" >
				<cfset ID_TYPE= "6">
			</cfif>
			
					
		<cfif ID_TYPE eq "1" >
			<cfif getList_qry.national eq "SG">
				<cfset nric = ucase(getList_qry.nricn)>
			<cfelseif getList_qry.r_statu eq "PR">
				<cfset nric = ucase(getList_qry.pr_num)>
			</cfif>
			
			<cfset num_reg = REFind("^[S|T]", ucase(getList_qry.nricn))>
			<cfset nnric = replace(getList_qry.nricn, "-","","all")>
			<cfset new_reg_nric = REFind("[[:punct:]]", nnric)>
			
			<cfif nnric neq "" and new_reg_nric eq "0" and num_reg eq "1">
				<cfset num_ID = "#nnric#">
				<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
				</cfloop>
			</cfif>
				
			<cfelseif #ID_TYPE# eq "2">
				<cfif getList_qry.fin neq " ">
					<cfset num_ID = "#getList_qry.fin#">
					<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>	
				
			<cfelseif #ID_TYPE# eq "3">
				<cfif getList_qry.IMS neq " ">
					<cfset num_ID = "#getList_qry.IMS#">
					<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
				
			<cfelseif #ID_TYPE# eq "4">
				<cfif getList_qry.wpermit neq "">
					<cfset num_ID = "#getList_qry.wpermit#">
					<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
				
			<cfelseif #ID_TYPE# eq "5">
				<cfif getList_qry.nricn neq "">
					<cfset num_ID = #getList_qry.nricn#>
					<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
				
			<cfelseif #ID_TYPE# eq "6">
				<cfif getList_qry.passport neq "">
					<cfset num_ID = "#getList_qry.passport#">
					<cfloop condition="len(num_ID) lt 12">
					<cfset num_ID = num_ID&" " >
					</cfloop>
				</cfif>
			</cfif>
			
			<cfif getList_qry.name neq "">
				<cfset name1="#getList_qry.name#">
				<cfloop condition="len(name1) lt 80">
					<cfset name1 = name1&" " >
				</cfloop>
			</cfif>
			
			<!--- Details of month and contributions --->
			<cfset TOW = 0>
<!----		<cfset dataInMonth = ArrayNew(1)>
			<cfloop from="1" to="12" index="i">   
				<cfquery name="getList_qry2" datasource="#dts#">
					SELECT * FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno 
					WHERE a.empno="#getList_qry.empno#" AND TMONTH= #i#
				</cfquery>
				<cfquery name="get_bonus_qry" datasource="#dts#">
					SELECT * FROM pmast AS a LEFT JOIN bonu_12m AS b ON a.empno=b.empno 
					WHERE a.empno="#getList_qry.empno#" AND TMONTH= #i#
				</cfquery>
				<cfquery name="get_comm_qry" datasource="#dts#">
					SELECT * FROM pmast AS a LEFT JOIN comm_12m AS b ON a.empno=b.empno 
					WHERE a.empno="#getList_qry.empno#" AND TMONTH= #i#
				</cfquery>   ------>
				
				<!--- <cfquery name="get_ext_qry" datasource="#dts#">
					SELECT * FROM pmast AS a LEFT JOIN extr_12m AS b ON a.empno=b.empno 
					WHERE a.empno="#getList_qry.empno#" AND TMONTH= #i#
				</cfquery> --->
<!------		<cfset a = val(getList_qry2.grosspay)>
				<cfset OW1 = a * 100>
				<cfset OW="#numberformat(OW1,'000000000')#">
				
				
				<cfset a = val(getList_qry2.EPFCC)>
				<cfset cpfcc_data1 = a * 100>
				<cfset cpfcc_data = "#numberformat(cpfcc_data1,'000000000')#">
				
				<cfset a = val(getList_qry2.EPFWW)>
				<cfset cpfww_data1 = a * 100>
				<cfset cpfww_data ="#numberformat(cpfww_data1,'000000000')#">
				
				<cfset a = val(get_bonus_qry.grosspay)+val(get_comm_qry.BASICPAY)>
				<cfset AddW1 = a * 100>			
				<cfset AddW = "#numberformat(AddW1,'000000000')#">
				
				<cfset a = val(get_bonus_qry.EPFcc)+val(get_comm_qry.EPFcc)>
				<cfset DW_cpfcc1 = a * 100>
				<cfset ADW_cpfcc = "#numberformat(DW_cpfcc1,'000000000')#">
				
				<cfset a = val(get_bonus_qry.EPFww)+val(get_comm_qry.EPFww)>
				<cfset ADW_cpfww1 = a * 100>
				<cfset ADW_cpfww = "#numberformat(ADW_cpfww1,'000000000')#">
				
				<cfset ArrayAppend(dataInMonth, "#OW##cpfcc_data##cpfww_data##AddW##ADW_cpfcc##ADW_cpfww#")>
				
				<cfloop list=#dataInMonth[i]# index="j">
		  			<cfset count[i]= j >
		  		</cfloop>
			</cfloop>  ----------->
				
			<cfset sec_5_to_76 = ArrayNew(1)>
			
			<cfloop from="5" to="76" index="ss">
			
			<cfset a = "getList_qry.sec_"&ss>
			<cfset a = evaluate(a)>
			<cfset a2 = a * 100>
			<cfset a2="#numberformat(a2,'000000000')#">
					
			<cfset ArrayAppend(sec_5_to_76, "#a2#")>	
			</cfloop>
			
			
			<!--- 	Grand Total --->
			
			<cfset sec_77_tol = int(getList_qry.sec_77)>
			<cfif sec_77_tol neq 0 and sec_77_tol neq "">
					<cfloop condition="len(sec_77_tol) lt 7">
						<cfset sec_77_tol = sec_77_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_77_tol = "       " >
			</cfif>			
		
			<cfset sec_78_tol = int(getList_qry.sec_78)>
			<cfif sec_78_tol neq 0 and sec_78_tol neq "">
			<cfloop condition="len(sec_78_tol) lt 7">
						<cfset sec_78_tol = sec_78_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_78_tol = "       " >
			</cfif>	
			
			<cfset sec_79_tol = int(getList_qry.sec_79)>
			<cfif sec_79_tol neq 0 and sec_79_tol neq "">
			<cfloop condition="len(sec_79_tol) lt 7">
						<cfset sec_79_tol = sec_79_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_79_tol = "       " >
			</cfif>	
			
			<cfset sec_80_tol = int(getList_qry.sec_80)>
			<cfif sec_80_tol neq 0 and sec_80_tol neq "">
			<cfloop condition="len(sec_80_tol) lt 7">
						<cfset sec_80_tol = sec_80_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_80_tol = "       " >
			</cfif>	
			
			<cfset sec_81_tol = int(getList_qry.sec_81)>
			<cfif sec_81_tol neq 0 and sec_81_tol neq "">
			<cfloop condition="len(sec_81_tol) lt 7">
						<cfset sec_81_tol = sec_81_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_81_tol = "       " >
			</cfif>	
			
			<cfset sec_82_tol = int(getList_qry.sec_82)>
			<cfif sec_82_tol neq 0 and sec_82_tol neq "">
			<cfloop condition="len(sec_82_tol) lt 7">
						<cfset sec_82_tol = sec_82_tol&" " >
					</cfloop>
			<cfelse>
				<cfset sec_82_tol = "       " >
			</cfif>	
			
			
			
<!-------	<cfquery name="sum_OW_qry" datasource="#dts#">
				SELECT sum(coalesce(grosspay,0)) as Tgrosspay,sum(coalesce(epfww,0)) as Tepfww, sum(coalesce(epfcc,0)) as Tepfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#getList_qry.empno#"
			</cfquery>
			<cfquery name="sum_bonu_qry" datasource="#dts#">
				SELECT sum(coalesce(grosspay,0)) as bonu_gross, sum(coalesce(epfww,0)) as bonu_epfww, sum(coalesce(epfcc,0)) as bonu_epfcc FROM pmast AS a LEFT JOIN bonu_12m AS b ON a.empno=b.empno 
				WHERE a.empno="#getList_qry.empno#"
			</cfquery>
			<cfquery name="sum_comm_qry" datasource="#dts#">
				SELECT sum(coalesce(grosspay,0)) as comm_gross, sum(coalesce(epfww,0)) as comm_epfww, sum(coalesce(epfcc,0)) as comm_epfcc FROM pmast AS a LEFT JOIN comm_12m AS b ON a.empno=b.empno 
				WHERE a.empno="#getList_qry.empno#"
			</cfquery>  ---------->
			<cfquery name="get_empl_list" datasource="#dts#">
				SELECT * FROM pmast AS a LEFT JOIN itaxea2 AS b ON a.empno=b.empno
				WHERE a.empno="#getList_qry.empno#"	
			</cfquery>
			<cfquery name="itaxea" datasource="#dts#">
				SELECT * FROM itaxea WHERE empno="#getList_qry.empno#"
			</cfquery>
	
<!-----		<cfset Tgrosspay = drop_decimal(sum_OW_qry.Tgrosspay)>
			<cfset Tepfcc = drop_decimal(sum_OW_qry.Tepfcc)>
			<cfset Tepfww = round(sum_OW_qry.Tepfww)>
			
			<cfset sum_adw1 = val(sum_bonu_qry.bonu_gross) + val(sum_comm_qry.comm_gross)>
			<cfset sum_adw = drop_decimal(sum_adw1)>
			
			<cfset sum_adw_epfcc1 = val(sum_bonu_qry.bonu_epfcc) + val(sum_comm_qry.comm_epfcc)>
			<cfset sum_adw_epfcc = drop_decimal(sum_adw_epfcc1)>
			
			<cfset sum_adw_epfww1 = val(sum_bonu_qry.bonu_epfww) + val(sum_comm_qry.comm_epfww)>
			<cfset sum_adw_epfww = round(sum_adw_epfww1)>    ------->
		
			<cfif getList_qry.sec_83a neq 0 and getList_qry.sec_83a neq "">
			<cfset sec83_postoversea_from = #dateformat(getList_qry.sec_83a,'YYYYMMDD')#>
			<cfelse>
			<cfset 	sec83_postoversea_from = "        ">
			</cfif>
			
			<cfif getList_qry.sec_83b neq 0 and getList_qry.sec_83b neq "">
			<cfset sec83_postoversea_to = #dateformat(getList_qry.sec_83b,'YYYYMMDD')#>
			<cfelse>
			<cfset sec83_postoversea_to = "        " >
			</cfif>
			
			<cfif #getList_qry.sec_84# eq "Y">
				<cfset sec84_ind_cpf_oversea = "Y">
			<cfelseif #getList_qry.sec_84# eq "N">
				<cfset sec84_ind_cpf_oversea = "N">
			<cfelse>		
				<cfset sec84_ind_cpf_oversea = " ">
			</cfif>
			
			<cfif #getList_qry.sec_85# eq "Y">
				<cfset sec85_cpf_capping = "Y">
			<cfelseif #getList_qry.sec_85# eq "N">
				<cfset sec85_cpf_capping = "N">
			<cfelse>	
				<cfset sec85_cpf_capping = " ">
			</cfif>
			
			<cfif #getList_qry.sec_86# eq "Y">
				<cfset sec86_PR = "Y">
			<cfelseif #getList_qry.sec_86# eq "N">
				<cfset sec86_PR = "N">
			<cfelse>	
				<cfset sec86_PR = " ">
			</cfif>
			
			<cfif #getList_qry.EA2TXT02# eq "Y">
				<cfset sec_87_app = "Y">
			<cfelseif #getList_qry.EA2TXT02# eq "N">
				<cfset sec_87_app = "N">
			<cfelse>	
				<cfset sec_87_app = " ">
			</cfif>
			
<!------	<cfset PR_since = dateformat(get_empl_list.EA2DAT01,'yyyymmdd')>
			<cfset comp_basic_year = basic_year -2>
			<cfset comp_basic_date = createdate(comp_basic_year,01,01)>
			<cfset comp_basic_date2 = #dateformat(comp_basic_date,'yyyymmdd')#>
			<cfif PR_since gte comp_basic_date2 >
				<cfset sec86_PR = "Y">
			<cfelse>
				<cfset sec86_PR = "N">
			</cfif>                    
			
			<cfif sec86_PR eq "Y" >
				<cfif get_empl_list.EA2TXT02 neq "">
					<cfset sec_87 = get_empl_list.EA2TXT02>
				</cfif>
			<cfelse>
				<cfset sec_87 = get_empl_list.EA2TXT02>
			</cfif>	                             -------------->
			
<!------	<cfset sec_88 = drop_decimal(val(itaxea.EA_EPFCEXT))>
			<cfset sec_89 ="0000000">    --------->
			
			<cfset sec_88_con = int(getList_qry.sec_88)>
			<cfif sec_88_con neq 0 and sec_88_con neq "">
			<cfloop condition="len(sec_88_con) lt 7">
						<cfset sec_88_con = sec_88_con&" " >
					</cfloop>
			<cfelse>
				<cfset sec_88_con = "       " >
			</cfif>
			
			<cfset sec_89_con = int(getList_qry.sec_89)>
			<cfif sec_89_con neq 0 and sec_89_con neq "">
			<cfloop condition="len(sec_89_con) lt 7">
						<cfset sec_89_con = sec_89_con&" " >
					</cfloop>
			<cfelse>
				<cfset sec_89_con = "       " >
			</cfif>		
			
			<!--- Details of refund claimed/to be claimed --->
				<!--- occurence1 --->
					
			<cfset sec_90_adw = drop_decimal(val(get_empl_list.EA2FIG01))>
			<cfif sec_90_adw neq 0 and sec_90_adw neq "">
			<cfloop condition="len(sec_90_adw) lt 7">
						<cfset sec_90_adw = sec_90_adw&" " >
					</cfloop>
			<cfelse>
				<cfset sec_90_adw = "       " >
			</cfif>	
					<cfset sec_91_to = "        ">
					<cfset sec_91_frm = "        ">
					
					<cfset var_sec_91_frm = #dateformat(get_empl_list.EA2DAT02,'YYYY')#>
					<cfset var_sec_91_to2 = #dateformat(get_empl_list.EA2DAT03,'YYYYMMDD')#>
					<cfset var_sec_91_frm2 = #dateformat(get_empl_list.EA2DAT02,'YYYYMMDD')#>
					
					<cfif var_sec_91_to2 neq "" and var_sec_91_frm2 neq "">
						<cfif var_sec_91_frm eq basic_year>
							<cfif var_sec_91_frm2 lte var_sec_91_to2>
								<cfset sec_91_to = #dateformat(get_empl_list.EA2DAT03,'YYYYMMDD')#>
								<cfset sec_91_frm = #dateformat(get_empl_list.EA2DAT02,'YYYYMMDD')#>
							</cfif>
						</cfif>
					<cfelse>
								<cfset sec_91_to = "        ">
								<cfset sec_91_frm = "        ">
					</cfif>
					
					<cfif get_empl_list.EA2DAT04 neq 0 and get_empl_list.EA2DAT04 neq "">	
						<cfset sec92_date_of_payment = #dateformat(get_empl_list.EA2DAT04,'YYYYMMDD')#>
					<cfelse>
						<cfset sec92_date_of_payment = "        ">
					</cfif>	
					
					<cfset sec93_amt_refund_yer_con = drop_decimal(val(get_empl_list.EA2FIG02))>
					<cfif sec93_amt_refund_yer_con neq 0 and sec93_amt_refund_yer_con neq "">
						<cfloop condition="len(sec93_amt_refund_yer_con) lt 7">
							<cfset sec93_amt_refund_yer_con = sec93_amt_refund_yer_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec93_amt_refund_yer_con = "       " >
					</cfif>	
					
					<cfset sec94_amt_refund_yer_int = drop_decimal(val(get_empl_list.EA2FIG03))>
					<cfif sec94_amt_refund_yer_int neq 0 and sec94_amt_refund_yer_int neq "">
						<cfloop condition="len(sec94_amt_refund_yer_int) lt 7">
							<cfset sec94_amt_refund_yer_int = sec94_amt_refund_yer_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec94_amt_refund_yer_int = "       " >
					</cfif>
					
					<cfif get_empl_list.EA2DAT05 neq 0 and get_empl_list.EA2DAT05 neq "">
						<cfset sec95_date_refund = #dateformat(get_empl_list.EA2DAT05,'YYYYMMDD')#>
					<cfelse>
						<cfset sec95_date_refund = "        ">
					</cfif>	
						
					<cfset sec96_amt_refund_yee_con = drop_decimal(val(get_empl_list.EA2FIG04))>
					<cfif sec96_amt_refund_yee_con neq 0 and sec96_amt_refund_yee_con neq "">
						<cfloop condition="len(sec96_amt_refund_yee_con) lt 7">
							<cfset sec96_amt_refund_yee_con = sec96_amt_refund_yee_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec96_amt_refund_yee_con = "       " >
					</cfif>
					
					<cfset sec97_amt_refund_yee_int = drop_decimal(val(get_empl_list.EA2FIG05))>
					<cfif sec97_amt_refund_yee_int neq 0 and sec97_amt_refund_yee_int neq "">
						<cfloop condition="len(sec97_amt_refund_yee_int) lt 7">
							<cfset sec97_amt_refund_yee_int = sec97_amt_refund_yee_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec97_amt_refund_yee_int = "       " >
					</cfif>
					
					<cfif get_empl_list.EA2DAT06 neq 0 and get_empl_list.EA2DAT06 neq "">
					<cfset sec98_date_refund_yee = #dateformat(get_empl_list.EA2DAT06,'yyyymmdd')#>
					<cfelse>
					<cfset sec98_date_refund_yee = "        ">	
					</cfif>
					
				<!--- occurence2 --->
					<cfset sec_99_adw = drop_decimal(val(get_empl_list.EA2FIG06))>
					<cfif sec_99_adw neq 0 and sec_99_adw neq "">
						<cfloop condition="len(sec_99_adw) lt 7">
							<cfset sec_99_adw = sec_99_adw&" " >
						</cfloop>
					<cfelse>
						<cfset sec_99_adw = "       " >
					</cfif>
					
					<cfset sec_100_to = "        ">
					<cfset sec_100_frm = "        ">
					
					<cfset var_sec_100_frm = #dateformat(get_empl_list.EA2DAT07,'YYYY')#>
					<cfset var_sec_100_to2 = #dateformat(get_empl_list.EA2DAT08,'YYYYMMDD')#>
					<cfset var_sec_100_frm2 = #dateformat(get_empl_list.EA2DAT07,'YYYYMMDD')#>
					
					<cfif var_sec_100_frm2 neq "" and var_sec_100_to2 neq "">
						<cfif var_sec_100_frm eq basic_year>
							<cfif var_sec_100_frm2 lte var_sec_91_to2>
								<cfset sec_100_to = #dateformat(get_empl_list.EA2DAT08,'YYYYMMDD')#>
								<cfset sec_100_frm = #dateformat(get_empl_list.EA2DAT07,'YYYYMMDD')#>
							</cfif>
						</cfif>
					<cfelse>
							<cfset sec_100_to = "        ">
							<cfset sec_100_frm = "        ">
					</cfif>
					
					<cfif get_empl_list.EA2DAT09 neq 0 and get_empl_list.EA2DAT09 neq "">
					<cfset sec101_date_of_payment = #dateformat(get_empl_list.EA2DAT09,'YYYYMMDD')#>
					<cfelse>
					<cfset sec101_date_of_payment = "        ">
					</cfif>
					
					<cfset sec102_amt_refund_yer_con = drop_decimal(val(get_empl_list.EA2FIG07))>
						<cfif sec102_amt_refund_yer_con neq 0 and sec102_amt_refund_yer_con neq "">
						<cfloop condition="len(sec102_amt_refund_yer_con) lt 7">
							<cfset sec102_amt_refund_yer_con = sec102_amt_refund_yer_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec102_amt_refund_yer_con = "       " >
					</cfif>
					
					<cfset sec103_amt_refund_yer_int = drop_decimal(val(get_empl_list.EA2FIG08))>
						<cfif sec103_amt_refund_yer_int neq 0 and sec103_amt_refund_yer_int neq "">
						<cfloop condition="len(sec103_amt_refund_yer_int) lt 7">
							<cfset sec103_amt_refund_yer_int = sec103_amt_refund_yer_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec103_amt_refund_yer_int = "       " >
					</cfif>
					
					<cfif get_empl_list.EA2DAT10 neq 0 and get_empl_list.EA2DAT10 neq "">
					<cfset sec104_date_refund = #dateformat(get_empl_list.EA2DAT10,'YYYYMMDD')#>
					<cfelse>
					<cfset sec104_date_refund = "        ">
					</cfif>
					
					
					<cfset sec105_amt_refund_yee_con = drop_decimal(val(get_empl_list.EA2FIG09))>
						<cfif sec105_amt_refund_yee_con neq 0 and sec105_amt_refund_yee_con neq "">
						<cfloop condition="len(sec105_amt_refund_yee_con) lt 7">
							<cfset sec105_amt_refund_yee_con = sec105_amt_refund_yee_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec105_amt_refund_yee_con = "       " >
					</cfif>
					
					<cfset sec106_amt_refund_yee_int = drop_decimal(val(get_empl_list.EA2FIG10))>
						<cfif sec106_amt_refund_yee_int neq 0 and sec106_amt_refund_yee_int neq "">
						<cfloop condition="len(sec106_amt_refund_yee_int) lt 7">
							<cfset sec106_amt_refund_yee_int = sec106_amt_refund_yee_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec106_amt_refund_yee_int = "       " >
					</cfif>
					
					
					<cfif get_empl_list.EA2DAT11 neq 0 and get_empl_list.EA2DAT11 neq "">
					<cfset sec107_date_refund_yee = #dateformat(get_empl_list.EA2DAT11,'yyyymmdd')#>
					<cfelse>
					<cfset sec107_date_refund_yee = "        ">
					</cfif>
				
				<!--- occurence3 --->
					<cfset sec_108_adw = drop_decimal(val(get_empl_list.EA2FIG11))>
					<cfif sec_108_adw neq 0 and sec_108_adw neq "">
						<cfloop condition="len(sec_108_adw) lt 7">
							<cfset sec_108_adw = sec_108_adw&" " >
						</cfloop>
					<cfelse>
						<cfset sec_108_adw = "       " >
					</cfif>
					
					<cfset var_sec_109_frm = #dateformat(get_empl_list.EA2DAT12,'YYYY')#>
					<cfset var_sec_109_to2 = #dateformat(get_empl_list.EA2DAT13,'YYYYMMDD')#>
					<cfset var_sec_109_frm2 = #dateformat(get_empl_list.EA2DAT12,'YYYYMMDD')#>
					
					<cfset sec_109_to = "        ">
					<cfset sec_109_frm = "        ">
					
					<cfif var_sec_109_to2 neq "" and var_sec_109_frm2 neq "">
						<cfif var_sec_109_frm eq basic_year>
							<cfif var_sec_109_frm2 lte var_sec_91_to2>
								<cfset sec_109_to = #dateformat(get_empl_list.EA2DAT13,'YYYYMMDD')#>
								<cfset sec_109_frm = #dateformat(get_empl_list.EA2DAT12,'YYYYMMDD')#>
							</cfif>
						</cfif>
					<cfelse>
						<cfset sec_109_to = "        ">
						<cfset sec_109_frm = "        ">
					</cfif>
					
					<cfif get_empl_list.EA2DAT14 neq 0 and get_empl_list.EA2DAT14 neq "">	
					<cfset sec110_date_of_payment = #dateformat(get_empl_list.EA2DAT14,'YYYYMMDD')#>
					<cfelse>
					<cfset sec110_date_of_payment = "        ">	
					</cfif>
					
					
					<cfset sec111_amt_refund_yer_con = drop_decimal(val(get_empl_list.EA2FIG12))>
					<cfif sec111_amt_refund_yer_con neq 0 and sec111_amt_refund_yer_con neq "">
						<cfloop condition="len(sec111_amt_refund_yer_con) lt 7">
							<cfset sec111_amt_refund_yer_con = sec111_amt_refund_yer_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec111_amt_refund_yer_con = "       " >
					</cfif>
					
					<cfset sec112_amt_refund_yer_int = drop_decimal(val(get_empl_list.EA2FIG13))>
					<cfif sec112_amt_refund_yer_int neq 0 and sec112_amt_refund_yer_int neq "">
						<cfloop condition="len(sec112_amt_refund_yer_int) lt 7">
							<cfset sec112_amt_refund_yer_int = sec112_amt_refund_yer_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec112_amt_refund_yer_int = "       " >
					</cfif>
					
					<cfif get_empl_list.EA2DAT15 neq 0 and get_empl_list.EA2DAT15 neq "">
					<cfset sec113_date_refund = #dateformat(get_empl_list.EA2DAT15,'YYYYMMDD')#>
					<cfelse>
					<cfset sec113_date_refund = "        ">
					</cfif>	
					
					
					<cfset sec114_amt_refund_yee_con = drop_decimal(val(get_empl_list.EA2FIG14))>
					<cfif sec114_amt_refund_yee_con neq 0 and sec114_amt_refund_yee_con neq "">
						<cfloop condition="len(sec114_amt_refund_yee_con) lt 7">
							<cfset sec114_amt_refund_yee_con = sec114_amt_refund_yee_con&" " >
						</cfloop>
					<cfelse>
						<cfset sec114_amt_refund_yee_con = "       " >
					</cfif>
					
					<cfset sec115_amt_refund_yee_int = drop_decimal(val(get_empl_list.EA2FIG15))>
					<cfif sec115_amt_refund_yee_int neq 0 and sec115_amt_refund_yee_int neq "">
						<cfloop condition="len(sec115_amt_refund_yee_int) lt 7">
							<cfset sec115_amt_refund_yee_int = sec115_amt_refund_yee_int&" " >
						</cfloop>
					<cfelse>
						<cfset sec115_amt_refund_yee_int = "       " >
					</cfif>
					
					
					<cfif get_empl_list.EA2DAT16 neq 0 and get_empl_list.EA2DAT16 neq "">
					<cfset sec116_date_refund_yee = #dateformat(get_empl_list.EA2DAT16,'yyyymmdd')#>
					<cfelse>
					<cfset sec116_date_refund_yee = "        ">
					</cfif>
					
					
			
					
				
			<cfset content ="1#ID_TYPE##num_ID##name1#"
			<!----	&"#count[1]##count[2]##count[3]##count[4]##count[5]##count[6]##count[7]##count[8]##count[9]##count[10]##count[11]##count[12]#"--->
					&"#sec_5_to_76[1]##sec_5_to_76[2]##sec_5_to_76[3]##sec_5_to_76[4]##sec_5_to_76[5]##sec_5_to_76[6]##sec_5_to_76[7]##sec_5_to_76[8]#"
					&"#sec_5_to_76[9]##sec_5_to_76[10]##sec_5_to_76[11]##sec_5_to_76[12]##sec_5_to_76[13]##sec_5_to_76[14]##sec_5_to_76[15]##sec_5_to_76[16]#"
					&"#sec_5_to_76[17]##sec_5_to_76[18]##sec_5_to_76[19]##sec_5_to_76[20]##sec_5_to_76[21]##sec_5_to_76[22]##sec_5_to_76[23]##sec_5_to_76[24]#"
					&"#sec_5_to_76[25]##sec_5_to_76[26]##sec_5_to_76[27]##sec_5_to_76[28]##sec_5_to_76[29]##sec_5_to_76[30]##sec_5_to_76[31]##sec_5_to_76[32]#"
					&"#sec_5_to_76[33]##sec_5_to_76[34]##sec_5_to_76[35]##sec_5_to_76[36]##sec_5_to_76[37]##sec_5_to_76[38]##sec_5_to_76[39]##sec_5_to_76[40]#"
					&"#sec_5_to_76[41]##sec_5_to_76[42]##sec_5_to_76[43]##sec_5_to_76[44]##sec_5_to_76[45]##sec_5_to_76[46]##sec_5_to_76[47]##sec_5_to_76[48]#"
					&"#sec_5_to_76[49]##sec_5_to_76[50]##sec_5_to_76[51]##sec_5_to_76[52]##sec_5_to_76[53]##sec_5_to_76[54]##sec_5_to_76[55]##sec_5_to_76[56]#"
					&"#sec_5_to_76[57]##sec_5_to_76[58]##sec_5_to_76[59]##sec_5_to_76[60]##sec_5_to_76[61]##sec_5_to_76[62]##sec_5_to_76[63]##sec_5_to_76[64]#"
					&"#sec_5_to_76[65]##sec_5_to_76[66]##sec_5_to_76[67]##sec_5_to_76[68]##sec_5_to_76[69]##sec_5_to_76[70]##sec_5_to_76[71]##sec_5_to_76[72]#"
					&"#sec_77_tol##sec_78_tol##sec_79_tol##sec_80_tol##sec_81_tol##sec_82_tol#"
			<!----- &"#numberformat(Tgrosspay,'0000000')##numberformat(Tepfcc,'0000000')##numberformat(Tepfww,'0000000')#"
					&"#numberformat(sum_adw,'0000000')##numberformat(sum_adw_epfcc,'0000000')##numberformat(sum_adw_epfww,'0000000')#" ------->
					&"#sec83_postoversea_from##sec83_postoversea_to##sec84_ind_cpf_oversea##sec85_cpf_capping##sec86_PR#"
					&"#sec_87_app##sec_88_con##sec_89_con##sec_90_adw#"
					&"#sec_91_frm##sec_91_to##sec92_date_of_payment#"
					&"#sec93_amt_refund_yer_con##sec94_amt_refund_yer_int##sec95_date_refund#"
					&"#sec96_amt_refund_yee_con##sec97_amt_refund_yee_int#"
					&"#sec98_date_refund_yee##sec_99_adw##sec_100_frm##sec_100_to##sec101_date_of_payment#"
					&"#sec102_amt_refund_yer_con##sec103_amt_refund_yer_int#"
					&"#sec104_date_refund##sec105_amt_refund_yee_con##sec106_amt_refund_yee_int#"
					&"#sec107_date_refund_yee##sec_108_adw##sec_109_frm##sec_109_to##sec110_date_of_payment#"
					&"#sec111_amt_refund_yer_con##sec112_amt_refund_yer_int##sec113_date_refund#"
					&"#sec114_amt_refund_yee_con##sec115_amt_refund_yee_int#"
					&"#sec116_date_refund_yee#">
							
					<cfloop condition="len(content) lt 1200">
						<cfset content = content&" " >
					</cfloop>
					<!---  <cfoutput>#content#</cfoutput>  --->
				<cffile action="append" addnewline="yes" 
					   file = "C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt"
					   output = "#content#">
					
		
		</cfloop>
		
		
		
		
		<!--- 	end content --->	
	</cfif>
		
		<cfset filename = form.tob>
		

		
		<cfset yourFileName="C:\Inetpub\wwwroot\payroll\download\#dts#\file#uuid#.txt">
		<cfset yourFileName2="#filename#.txt">
		 
		 <cfcontent type="application/x-unknown"> 
		
		 <cfset thisPath = ExpandPath("#yourFileName#")> 
		 <cfheader name="Content-Disposition" value="attachment; filename=#yourFileName2#">
		 <cfheader name="Content-Description" value="This is a tab-delimited file.">
		 <cfcontent type="Multipart/Report" file="#yourFileName#">
		 <cflocation url="#yourFileName#">
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
<!--- <cflocation url="/government/IR8A/GenerateIR8ASpecMain.cfm" > --->	         
	