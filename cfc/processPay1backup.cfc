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
    
    <cffunction name="updatePay" access="public" returntype="any">
    	<cfargument name="db" required="yes">
		<cfargument name="empno" required="no">
        <cfargument name="db1" required="no">
        <cfargument name="compid" required="no">
 		<cfargument name="compccode" required="yes">

        <cfquery name="select_data" datasource="#db#">
        SELECT * FROM paytra1
        WHERE empno = "#empno#"
        </cfquery>
        
        <cfquery name="select_empdata" datasource="#db#">
        SELECT * FROM pmast
        WHERE empno = "#empno#"
        </cfquery>
        <cfset salarypaytype =  select_empdata.payrtype >
        
        <!--- get monthg for oob calculation --->
        <cfquery name="get_now_month" datasource="#db1#">
        SELECT * FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>        
       	<cfset Date_OOB = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
       
		<cfset bRate=select_data.BRATE>
        <cfset wDay = select_data.WDAY>
        <cfset OOB = select_data.OOB>
        <cfif OOB gt 0>
        	<cfset days_OOB =DaysInMonth(Date_OOB) >
        	<cfset bRate = (bRate * (days_OOB - OOB)) / days_OOB >
        </cfif>
        <cfif wDay eq 0 Or Wday eq "">
	        <cfif salarypaytype neq "H">
	        	<cfset wDay = 13>
	        </cfif>
        </cfif>
        <cfset dW = select_data.DW>
        <cfset AL = select_data.AL>
        <cfset pH = select_data.PH>
        <cfset mC = select_data.MC>
        <cfset mT = select_data.MT>
        <cfset cC = select_data.CC>
        <cfset mR = select_data.MR>
        <cfset cL = select_data.CL>
        <cfset hL = select_data.HL>
        <cfset eX = select_data.EX>
        <cfset pT = select_data.PT>
        <cfset aD = select_data.AD>
        <cfset oPL = select_data.OPL>
        <cfset lS = select_data.LS>
        <cfset nPL = select_data.NPL>
        <cfset aB = select_data.AB>
        <cfset oNPL = select_data.ONPL>
<!---         <cfset rate1= select_data.RATE1>
        <cfset rate2= select_data.RATE2>
        <cfset rate3= select_data.RATE3>
        <cfset rate4= select_data.RATE4>
        <cfset rate5= select_data.RATE5>
        <cfset rate6= select_data.RATE6> --->
        <cfset hR1= select_data.HR1>
        <cfset hR2= select_data.HR2>
        <cfset hR3= select_data.HR3>
        <cfset hR4= select_data.HR4>
        <cfset hR5= select_data.HR5>
        <cfset hR6= select_data.HR6>
        <cfset epftbl = select_empdata.epftbl>
        <cfset oTtbl = select_empdata.ottbl>
        <cfset epfcat = select_empdata.epfcat>
        <cfset epfno = select_empdata.epfno>
        <cfset dirFee = select_data.dirfee>
        <cfset workHR = select_data.WORKHR>
        <cfset lateHR = select_data.LATEHR>
        <cfset earlyHR = select_data.EARLYHR>
        <cfset noPayHR = select_data.NOPAYHR>
        <cfset whtbl = select_empdata.WHTBL>
        <cfset piecepay = select_data.piecepay>
        <cfset cltipoint = select_data.cltipoint>
        <cfset tiprate = select_data.tiprate>
         <cfset additional_CPF = 0>
         <cfset backpay = select_data.backpay>
         <cfset comp_Auto_cpf = get_now_month.Auto_cpf>
		<cfset sys_date = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
		<cfset epf1hd = select_empdata.epf1hd>
		
		
          <!--- for cpf table automation choose --->
       <cfif compccode eq "SG">   
			<cfif comp_Auto_cpf eq "Y">
			
				<cfquery name="con_qry" datasource="#db#">
					SELECT 	entryno, epfcon1, epfcon2, epfcon3, epfcon4, epfcon5, epfcon6, epfcon7, epfcon8, epfcon9, epfcon10,
							epfcon11, epfcon12, epfcon13, epfcon14, epfcon15, epfcon16, epfcon17, epfcon18, epfcon19, epfcon20,
							epfcon21, epfcon22, epfcon23, epfcon24, epfcon25, epfcon26, epfcon27, epfcon28, epfcon29, epfcon30
					FROM rngtable where entryno="1"
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
						<!--- <cfif sys_date gte birthdate>
							<cfset age = datediff("yyyy",birthdate,sys_date)>	
						<cfelse>
							<cfset age = datediff("yyyy",birthdate,sys_date)-1>
						</cfif> --->
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
  			

	        <cfquery name="update_epf_table" datasource="#db#">
	        	UPDATE pmast SET epftbl = #epf_selected# WHERE empno = "#empno#"
	        </cfquery>
		<cfelse>
			<cfset epf_selected = select_empdata.epftbl >
		</cfif>
		
        <!--- check pay one or twice --->
        <!---<cfquery name="check_pay" datasource="#db1#">
        	SELECT bp_payment FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>
		<cfif select_empdata.nppm eq "0" and salarypaytype eq "M">
			<cfset pay_times = check_pay.bp_payment>
		<cfelseif select_empdata.nppm eq "1" and salarypaytype eq "M">
			<cfset pay_times = 1>
		<cfelseif select_empdata.nppm eq "2" and salarypaytype eq "M">
			<cfset pay_times = 2>
		<cfelse>
			<cfset pay_times = 1>
		</cfif>
      	<cfset bRate = #val(brate)# / #val(pay_times)#>
        --->
        
        <!--- working hour data --->
         <cfquery name="get_wh_qry" datasource="#db#">
        	SELECT xhrpday_m FROM ottable where OT_COU = #whtbl#
        </cfquery>
        <cfset work_h = get_wh_qry.xhrpday_m>
        
		
		<!--- check daily or hourly pay --->
        <cfset salarypaytype =  select_empdata.payrtype >
        <cfif salarypaytype eq "D">
        
        	<cfset brate = #val(brate)# * #val(wDay)# >
        
        <cfelseif salarypaytype eq "H">
        
			<cfset total_work_amt = #val(brate)# * #val(workHR)# >
	        <cfset brate = #val(brate)# * #val(wDay)# * #val(work_h)#+ #val(total_work_amt)#>
        </cfif>

        
        <!--- Work hours process --->
       	<cfif salarypaytype neq "H">
        
        <cfset hour_r = 1 / (#val(wDay)# * #val(work_h)#) * #val(brate)#> 
        <cfset total_work_h = #val(workHR)# * hour_r>
       
        
        <!--- Lateness Hours Process --->
        <cfquery name="get_lateness_ratio" datasource="#db1#">
        SELECT bp_dedratio FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>
        <cfset total_late_h = #val(lateHR)# * hour_r * #val(get_lateness_ratio.bp_dedratio)# >
        
        <!--- Early Depart Hours--->
        <cfset total_earlyD_h = #val(earlyHR)# * hour_r>
        
        <!--- No Pay Hours --->
        <cfset total_noP_h = #val(noPayHR)# * hour_r>
        
        
        <!--- working day process --->
     	<cfset dplustemp = #val(pH)# + #val(AL)# + #val(mC)# + #val(mT)# + #val(cC)# + #val(mR)# + #val(cL)# + #val(hL)# + #val(eX)# + #val(pT)# + #val(aD)# + #val(oPL)#>
        <cfset dminustemp =  #val(lS)# +  #val(nPL)# +  #val(aB)# +  #val(oNPL)#>
        <cfset totalspecialday = dplustemp + dminustemp>
        <cfset outstandingday = #val(wDay)# - #val(dW)# - totalspecialday>
        <cfif outstandingday neq 0>
        <cfset dW=#val(dW)#+outstandingday>
        </cfif>
        <cfset payday = #val(WDay)# - dminustemp>
        <cfset totalNPL = dminustemp / #val(wDay)# * #val(bRate)#> 
        
        <!--- Basic Pay Process --->
        <cfset basicpay = (payday / #val(wDay)# * #val(bRate)#) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#> 
        
		
		<cfelse>
		<cfset totalNPL = 0.00 >
        <cfset basicpay = #val(brate)# + #val(piecepay)# + #val(backpay)# >
        
		</cfif>
        
        <!--- ALlowance Process --->
 		<cfquery name="aw_qry" datasource="#db#">
			SELECT aw_cou,aw_desp,aw_epf,aw_dbase,aw_type,aw_for,aw_rattn,aw_hrd FROM awtable
			where aw_cou < 18
		</cfquery>
        <cfquery name="get_now_month" datasource="#db1#">
        	SELECT * FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>        
       	<cfset Date_NDOM = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
	
		<cfset taw = 0>
        <cfset aw_count = 1>
        <cfset wdlist = "DW,PH,AL,MC,MT,CC,MR,CL,HL,OPL,DW2,EX,PT,AD" >
		
		<cfset wdArray = ArrayNew(1) >
        <cfloop list="#wdlist#" index="k">
        	<cfset ArrayAppend(wdArray, "#k#")> 
		</cfloop>
        
        
		
        <cfset nPL = #val(select_data.NPL)#>
        <cfset aB = #val(select_data.AB)#>
        <cfset ADJ = 1 >
        <!--- <cfset NDOM = 1> --->
        <cfset latehr = #val(select_data.latehr)#>
        <cfset tippoint = #val(select_data.tippoint)#>
        <cfset tiprate = #val(select_data.tippoint)#>
		<cfset Nmonth = #get_now_month.mmonth#>
		<cfset add_hrd = 0>
        
		
        <cfloop query="aw_qry">
			
			<!--- <cfif  #aw_qry.aw_npl# eq "1">
				<cfset NPL = select_data.NPL>
			<cfset AB = select_data.AB>
				<cfelse>
			<cfset NPL = 0>
			<cfset AB = 0>
			</cfif> --->
			<cfset nPL = #val(select_data.NPL)#>
            <cfset aB = #val(select_data.AB)#>
			<cfset RATTN = evaluate("#aw_qry.aw_rattn#")>
            
        	<cfset total_aw_days = 0>
			
        	<cfset AW =  #val(select_empdata['dbaw1#numberformat(aw_qry.currentrow,"00")#'][1])#>
        	<cfset AW2 =  #val(select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1])#>	
			
           	<cfif AW gt 0 and aw_qry.aw_type neq "V">
            
            <cfif aw_qry.aw_for neq "">
	            <cfset aw_formula = #aw_qry.aw_for# >
	            <cfset aw_formula = Replace(aw_formula,"<="," lte ") >
	            <cfset aw_formula = Replace(aw_formula,">="," gte ") >
	            <cfset aw_formula = Replace(aw_formula,">"," gt ") >
	            <cfset aw_formula = Replace(aw_formula,"<"," lt ") >
	            <cfset aw_formula = Replace(aw_formula,"="," eq ") >
				<cfset aw_formula = Replace(aw_formula,"NDOM","#DaysInMonth(Date_NDOM)#")>
	            <cfset aw_data = #evaluate('#aw_formula#')#>
            <cfelse>
            	<cfset aw_data = AW >
			</cfif>
            <cfif aw_qry.aw_type eq "D">
	            <cfloop from="1" to="13" index="i">            
					<cfset check_base = #findoneof("1",aw_qry.aw_dbase,i)#>
		            <cfset aw_data_var = wdArray[i]>
		           
					<cfif check_base eq #i#>
		            
		            <cfset total_aw_days = total_aw_days + #val(select_data['#aw_data_var#'][1])#>
		            
					</cfif>
				</cfloop>
            	<cfset aw_data = aw_data * total_aw_days>
			</cfif>
            
           <!---  <cfelseif aw_qry.aw_type neq "D">
            <cfset aw_data =  #val(select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1])#>
             --->
          
			<cfelseif AW2 gt 0 and aw_qry.aw_type eq "V">
			<cfif aw_qry.aw_for neq "">
				<cfset AW = val(AW2)>
	            <cfset aw_formula = #aw_qry.aw_for# >
	            <cfset aw_formula = Replace(aw_formula,"<="," lte ") >
	            <cfset aw_formula = Replace(aw_formula,">="," gte ") >
	            <cfset aw_formula = Replace(aw_formula,">"," gt ") >
	            <cfset aw_formula = Replace(aw_formula,"<"," lt ") >
	            <cfset aw_formula = Replace(aw_formula,"="," eq ") >
				<cfset aw_formula = Replace(aw_formula,"NDOM","#DaysInMonth(Date_NDOM)#")>
	            <cfset aw_data = #evaluate('#aw_formula#')#>
            <cfelse>
            	<cfset aw_data = val(AW2) >
			</cfif>
			
			<cfelseif AW2 gt 0 and aw_qry.aw_type eq "S" >
				<cfset AW = #AW2#>
	            <cfset aw_data = #AW2# >
				
			<cfelse>
            	<cfset aw_data = 0 >
			</cfif>
			
            <cfset aw_variable = 'aw1'&#numberformat(aw_qry.currentrow,"00")# >
            <cfquery name="updata_aw_back" datasource="#db#">
            	UPDATE paytra1 SET #aw_variable# = #aw_data# WHERE empno = "#empno#"
            </cfquery>
            
			<cfset taw=#taw#+#aw_data#>
            <cfset aw_var = #aw_data#>
			<cfif aw_qry.aw_epf gt 0>
            	<cfset additional_CPF = additional_CPF + aw_var >
            </cfif>
			
			<cfif aw_qry.aw_hrd gt 0>
		            <cfset add_hrd = add_hrd + aw_var>
	            </cfif>
        </cfloop>
        
        <!--- Deduction Process --->
        <cfquery name="ded_qry" datasource="#db#">
			SELECT ded_for,ded_type,ded_hrd,ded_epf,ded_hrd FROM dedtable d where ded_cou < 16
		</cfquery>
	
		<cfquery name="pay_ded" datasource="#db#">
        	SELECT * FROM paytra1
        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery>
		
		<cfquery name="emp_ded" datasource="#db#">
        	SELECT * FROM pmast
        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery>
		
		<cfset advance_value = val(pay_ded.advance)>
		<cfset ded_data = 0>
		<cfset ded_array = ArrayNew(1)>
      	<cfset ded_CPF = 0>
		<cfset ded_sdl = 0>
		<cfset tded=0>
		<cfloop query="ded_qry">
			
			<cfif ded_qry.ded_type eq "F">
				<cfif ded_qry.ded_for eq "" >
					<cfset ded_data =  val(emp_ded['dbded1#numberformat(ded_qry.currentrow,"00")#'][1])>
					<cfset tded = tded + ded_data>
				<cfelse>
					<cfset DED = val(emp_ded['dbded1#numberformat(ded_qry.currentrow,"00")#'][1])>
					<cfset ggross_ded_for= #find("GROSSPAY",ded_qry.ded_for)#>
					
					<cfif ggross_ded_for eq 0>
						<cfset ded_formula = ded_qry.ded_for >
		            	<cfset ded_formula = Replace(ded_formula,"<="," lte ") >
			            <cfset ded_formula = Replace(ded_formula,">="," gte ") >
			            <cfset ded_formula = Replace(ded_formula,">"," gt ") >
			            <cfset ded_formula = Replace(ded_formula,"<"," lt ") >
			            <cfset ded_formula = Replace(ded_formula,"="," eq ") >
						<cfset ded_data = #evaluate('#ded_formula#')#>
						<cfset tded = tded + ded_data>
					</cfif>
				</cfif>
			<cfelse>
				<cfset ded_data =  val(pay_ded['ded1#numberformat(ded_qry.currentrow,"00")#'][1])>
				<cfset tded = tded + ded_data>
			</cfif>
			
			
			
			<cfset ded_variable = 'ded1'&#numberformat(ded_qry.currentrow,"00")# >
            <cfquery name="updata_ded_back" datasource="#db#">
            	UPDATE paytra1 SET #ded_variable# = #ded_data# WHERE empno = "#empno#"
            </cfquery>
		</cfloop>
		 
        <cfset tded = tded + advance_value>
      	
 		<!--- Overtime ratio--->
        <cfset ratio_list = ArrayNew(1)>
        <cfset constant_list = ArrayNew(1)>
        <cfset rate_list = ArrayNew(1)>
        <cfset ot_unit1 = ArrayNew(1)>
        
		<cfloop from="1" to="6" index="i">
			<cfif oTtbl eq 1>
	        	<cfset ot_table = "">
	        <cfelse>
	        	<cfset ot_table = oTtbl>
	        </cfif>
	       
			<cfset OTtblname = "OT_RATIO"&#ot_table# >
	        <cfset OTconname = "OT_CONST"&#ot_table# >
	        <cfquery name="select_otRatio_qry" datasource="#db#">
				SELECT #OTtblname#, #OTconname#,ot_mrate,OT_UNIT FROM ottable WHERE ot_cou = #i#
			</cfquery>
	        <cfset otValue = select_otRatio_qry['#OTtblname#'][1] >
	        <cfset otConstant = select_otRatio_qry['#OTconname#'][1] >
	        <cfset otRate = select_otRatio_qry.ot_mrate >
	        <cfset otUnit = select_otRatio_qry.ot_unit >
	        
	        <cfset ArrayAppend(ratio_list, "#otValue#")>
	        <cfset ArrayAppend(constant_list, "#otConstant#")>
	        <cfset ArrayAppend(rate_list, "#otRate#") >
	        <cfset ArrayAppend(ot_unit1, "#otUnit#")>

        </cfloop>
        
        <!--- <cfif oTtbl eq 1>
        <cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio#")>
        </cfloop>
      
        
        <cfelseif oTtbl eq 2>
      	<cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO2 FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio2#")>
        </cfloop>
        
        <cfelseif oTtbl eq 3>
        <cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO3 FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio3#")>
        </cfloop>
        
        <cfelseif oTtbl eq 4>
     	<cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO4 FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio4#")>
        </cfloop>
        
        <cfelseif oTtbl eq 5>
        <cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO5 FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio5#")>
        </cfloop>
        
        <cfelseif oTtbl eq 6>
      	<cfset ratio_list = ArrayNew(1)>
        <cfloop from="1" to="6" index="i">
        <cfquery name="select_otRatio_qry" datasource="#db#">
		SELECT ot_RATIO6 FROM ottable WHERE ot_cou = #i#
		</cfquery>
        <cfset ArrayAppend(ratio_list, "#select_otRatio_qry.ot_Ratio6#")>
        </cfloop>
        
        </cfif> --->
        
		<cfquery name="ot_table" datasource="#db#">
        	SELECT * from ottable
        </cfquery>
        
        <cfset OTRATETYPE = #select_empdata.otraterc# >
        <cfset OT_maxpay =  #select_empdata.ot_maxpay# >
        
        <cfset ot_var = "OD_MAXPAY"&#OT_maxpay# >
        <cfquery name="ot_maxpay_rate" datasource="#db1#">
       		SELECT #ot_var# FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>
        <cfset OTMAXPAY = ot_maxpay_rate['#ot_var#'][1] >
       	<cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
		
		<cfif salarypaytype neq "D">
        	<cfset workingd = #evaluate('ot_table.xdaypmtha[#whtbl#]')# >
        <cfelse>
		 	<cfset workingd = wDay >
		</cfif>
		
		<!--- Start Calculate OT for Allowance --->
		<cfset awot = 0 >
		<cfset dedot = 0 >
		<cfset dedarray = 0>
	
		<cfif OTRATETYPE neq  "C">
			<cfset awarray = ArrayNew(1)>
			<cfloop from="1" to="6" index="i">
				<cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
				<cfif ot_unit1[i] eq "DAYS">
		        	<cfset workingh = 1 >
		        </cfif>
				<cfset OTAW = "AW_OT"&#i# >
			
				<cfquery name="select_aw_OT" datasource="#db#">
					SELECT #OTAW#,aw_cou FROM awtable where aw_cou <=17 and #OTAW# = 1
				</cfquery>
				
				<cfset awot = 0>
				<cfloop query="select_aw_OT">
					<cfset tempawvar = 100 + select_aw_OT.aw_cou >
					<cfquery name="getAwFromPaytran" datasource="#db#">
						SELECT AW#tempawvar# as AW from paytra1 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
					</cfquery>
					
					<cfif getAwFromPaytran.AW neq 0 >
					<cfset awot = awot + getAwFromPaytran.AW>
					
					</cfif>
				</cfloop>
				<cfset awarray[i] = awot>
				
			</cfloop>
	
		<!--- END Calculate OT for Allowance --->
		
		<!--- Start Calculate OT for Deduction --->
			<cfquery name="select_ded_OT" datasource="#db#">
			SELECT DED_OT,ded_cou,ded_for FROM dedtable where ded_cou <=17 and DED_OT = 1
			</cfquery>
			
			<cfloop query="select_ded_OT">
				<cfset tempdedvar = 100 + select_ded_OT.ded_cou >
				<cfquery name="getDedFromPaytran" datasource="#db#">
					SELECT ded#tempdedvar# as DED from paytra1 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
				<cfset ggrosspay = find("GROSSPAY",select_ded_OT.ded_for)>
				<cfif getDedFromPaytran.DED neq 0 and ggrosspay eq 0>
					<cfset dedot = dedot + getDedFromPaytran.DED>
					<cfset dedarray = dedot>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset awot = 0>
			<cfset awarray = ArrayNew(1)>
				<cfloop from="1" to="6" index="i">
					<cfset awarray[i] = 0>
				</cfloop>
		</cfif>
		
		<!--- END Calculate OT for Deduction --->
		
		<cfquery name="getPayBaseOption" datasource="#db1#">
			SELECT paybase FROM gsetup WHERE comp_id = "#compid#"
		</cfquery>
		<cfquery name="getBasic" datasource="#db#">
			SELECT basicpay, bRate FROM paytra1 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">;
		</cfquery>
		<cfquery name="aw2_qry" datasource="#db#">
			SELECT aw_cou,abcd_desp,abcdrepf,abcdrot FROM awtable where aw_cou='2'
		</cfquery>	
		
		<cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
		
		<cfif aw2_qry.abcdrot eq "Y">
			<cfset cal_aw_bRate = getBasic.brate>
			
			<cfif salarypaytype eq  "D">
				<cfset workingd = 1 >
			</cfif>
			<cfif salarypaytype eq "H">
	        	<cfset workingd = 1 >
	        	<cfset workingh = 1 >
		    </cfif>
		    
		<cfelseif getPayBaseOption.paybase eq "BR">
			<cfset cal_aw_bRate = getBasic.brate>
			
			<cfif salarypaytype eq "D">
				<cfset workingd = 1 >
			</cfif>
			<cfif salarypaytype eq "H">
	        	<cfset workingd = 1 >
	        	<cfset workingh = 1 >
		    </cfif>
		
		<cfelse>
			<cfset cal_aw_bRate = #basicpay#>
			<cfif salarypaytype eq "H">
	        	<cfset cal_aw_bRate = getBasic.brate>
	        	<cfset workingd = 1 >
	        	<cfset workingh = 1 >
	        </cfif>
		</cfif>
		
	
		<cfif get_now_month.od_inclad neq 0 >
			<cfset BASICAW = val(cal_aw_bRate) + val(taw)- val(tded) >
        <cfelse>
        	<cfset BASICAW = val(cal_aw_bRate) >
        </cfif>
		
		
		<cfset OT_VALUE = val(cal_aw_bRate) - val(dedot)  >
		
        <cfset OT_RATE_LIST = ArrayNew(1) >
		
	   	<cfset fix_ot = find("O", ucase(select_data.FIXOESP))>
	    <cfif fix_ot gt 0>
				<cfset OT_RATE_LIST[1] = select_data.RATE1>
				<cfset OT_RATE_LIST[2] = select_data.RATE2>
				<cfset OT_RATE_LIST[3] = select_data.RATE3>
				<cfset OT_RATE_LIST[4] = select_data.RATE4>
				<cfset OT_RATE_LIST[5] = select_data.RATE5>
				<cfset OT_RATE_LIST[6] = select_data.RATE6>
				
		<cfelseif #BASICAW# gt #OTMAXPAY#>
        	<cfset OT_VALUE = #OTMAXPAY#>      
	        <cfloop from="1" to="6" index="i">
		       
				<cfif ot_unit1[i] eq "DAYS">
		        	<cfset workingh = 1 >
		        </cfif>
		      
		        <cfif OTRATETYPE eq "C" and constant_list[i] gt 0>
		        
		        	<cfset ArrayAppend(OT_RATE_LIST, "#constant_list[i]#")>
		        
		        <cfelseif OTRATETYPE eq "C" and constant_list[i] lte 0 >
				
			    	<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >
			        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			        <cfset value111 = OT_VALUE / workingd >
		        
		        <cfelseif OTRATETYPE eq "R" and rate_list[i] gt 0 >
		        	<cfset ArrayAppend(OT_RATE_LIST, "#rate_list[i]#")>
		        
		        <cfelseif OTRATETYPE eq "R" and rate_list[i] lte 0 >
			    	<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i]  >
			        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
		       
		        </cfif>
	        
	        </cfloop>      
        <cfelse>
        
	        <cfloop from="1" to="6" index="i">
				
		      	<cfif ot_unit1[i] eq "DAYS">
		        	<cfset workingh = 1 >
		        </cfif>
		      
		        <cfif OTRATETYPE eq "C" and constant_list[i] gt 0>
		        	<cfset ArrayAppend(OT_RATE_LIST, "#constant_list[i]#")>
		        
		        <cfelseif OTRATETYPE eq "C" and constant_list[i] lte 0 >
			    	<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >
			        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
		        
		        <cfelseif OTRATETYPE eq "R">
			    	<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh )* ratio_list[i] >
			        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			    	
				</cfif>
		        
	        </cfloop>
        
		</cfif>
       
      
        
        <cfquery name="update_rate" datasource="#db#">
	        UPDATE paytra1 SET 
	        RATE1 = #numberformat(OT_RATE_LIST[1],'.__')#,
	        RATE2 = #numberformat(OT_RATE_LIST[2],'.__')#,
	        RATE3 = #numberformat(OT_RATE_LIST[3],'.__')#,
	        RATE4 = #numberformat(OT_RATE_LIST[4],'.__')#,
	        RATE5 = #numberformat(OT_RATE_LIST[5],'.__')#,
	        RATE6 = #numberformat(OT_RATE_LIST[6],'.__')#
	        WHERE empno = "#empno#"
        </cfquery>
        
        
        <cfquery name="select_new_rate" datasource="#db#">
        	SELECT RATE1, RATE2, RATE3, RATE4, RATE5, RATE6 from paytra1 where empno = "#empno#"
        </cfquery>
		
  		<cfset OT1 = #val(select_new_rate.rate1)# * #val(hr1)#>
  		<cfset OT2 = #val(select_new_rate.rate2)# * #val(hr2)#>
        <cfset OT3 = #val(select_new_rate.rate3)# * #val(hr3)#>
        <cfset OT4 = #val(select_new_rate.rate4)# * #val(hr4)#>
        <cfset OT5 = #val(select_new_rate.rate5)# * #val(hr5)#>
        <cfset OT6 = #val(select_new_rate.rate6)# * #val(hr6)#>
        <cfset add_hrd_ot = 0>
		
        <cfloop from="1" to="6" index="ii">
	        <cfquery name="check_cpf_addtional" datasource="#db#">
	        	SELECT * FROM ottable where ot_cou = #ii#
	        </cfquery>
	        <cfset ot_var = #evaluate("OT"&#ii#)# >
	        <cfif ot_var gt 0 and #check_cpf_addtional.OT_EPF# gt 0>
	        	<cfset additional_CPF =  additional_CPF + ot_var>
	        </cfif>
	        
	        <cfif ot_var gt 0 and check_cpf_addtional.OT_HRD gt 0>
	        	<cfset add_hrd_ot =  add_hrd_ot + ot_var>
	        </cfif>	
	        
        </cfloop>
		
        <cfset OTtotal = OT1 + OT2 + OT3 + OT4 + OT5 +OT6>
		 
		 <!--- calculate HRD  for SDL--->
 		<cfset hrd_pay =  #val(basicpay)# + #val(Ottotal)# + #val(taw)#>
        
        <!--- Calculate Gross Pay --->
        <cfset grosspay = #val(basicpay)# + #val(Ottotal)# + #val(taw)# + #val(dirfee)#>
        
		<!--- calculate MBMF --->
        <cfset tot_new_value= 0>
		<cfset dedt_hrd = 0>
		<cfquery name="pay_ded" datasource="#db#">
        	SELECT * FROM paytra1
        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery>
		<cfset PAY_TIMES = 1>
		<cfloop from="1" to="15" index="i">
	        <cfquery name="select_ded_formula" datasource="#db#">
	        	SELECT * FROM dedtable WHERE DED_COU = #i# 
	        </cfquery>
	        
	        <cfset dedvar = 100 + #i# >
	        <cfset dedvar1 = "DBDED"&#dedvar# >
	        <cfset dedvar_update = "DED"&#dedvar# >
	       <!---  <cfset deddata = #evaluate("select_empdata.#dedvar1#")#> --->
			<cfset DED = #evaluate("select_empdata.#dedvar1#")#>
			<cfset new_ded_formula = select_ded_formula.DED_FOR>
	        <cfset use_ded_formula = select_ded_formula.DED_FOR_USE>
			
	        <cfset ded_type = select_ded_formula.ded_type>
	        <cfquery name="pay_gs_1" datasource="#db#">
        	SELECT grosspay FROM paytra1
        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	        </cfquery>
			<cfset grosspay1 = val(pay_gs_1.grosspay)>
	        
        	<cfset ggrosspay = #find("GROSSPAY",select_ded_formula.ded_for)#>
		  	
			<cfif DED gt 0 and new_ded_formula neq "" and ggrosspay gt 0 and ded_type eq "F">
        		<cfif use_ded_formula neq 0 >
		            
		            <cfset result = Replace(new_ded_formula,"<="," lte ") >
		            <cfset result = Replace(result,">="," gte ") >
		            <cfset result = Replace(result,">"," gt ") >
		            <cfset result = Replace(result,"<"," lt ") >
		            <cfset result = Replace(result,"="," eq ") >
		          
			        <cfset new_value = #evaluate(result)#>
			        <cfset new_value = #numberformat(new_value,'.__')# >
			      	
	        	<cfelse>
	        		<cfset new_value = DED>
	        	</cfif>
	           
				<cfif i gte 11>
				<cfset new_value = 0>
				</cfif>
		    	<cfquery name="update_ded_to_paytra1" datasource="#db#">
	        		UPDATE paytra1 SET #dedvar_update# = #new_value# WHERE empno = "#empno#"
	     		</cfquery>
               
	     		<cfset tot_new_value = tot_new_value + new_value>
					
				<cfif select_ded_formula.ded_epf gt 0>
		            <cfset ded_CPF = ded_CPF + new_value >
		        </cfif>
			</cfif>
			 
			<cfif DED eq 0 AND ggrosspay gt 0>
		    	<cfset new_value = 0>
                <cfif i gte 11>
				<cfset new_value = 0>
				</cfif>
			    <cfquery name="update_ded_to_paytra1" datasource="#db#">
		        	UPDATE paytra1 SET #dedvar_update# = #new_value# WHERE empno = "#empno#"
		     	</cfquery>
               
		     	<cfif select_ded_formula.ded_epf gt 0>
		            <cfset ded_CPF = ded_CPF + new_value >
		        </cfif>
		     	<cfset tot_new_value = tot_new_value + new_value>
			</cfif>	
			
			<cfset ded_var = #evaluate("pay_ded.#dedvar_update#")#>
			
			<cfif ded_qry.ded_epf gt 0>
	            <cfset ded_CPF = ded_CPF + ded_var >
	        </cfif>
	     	<cfif ded_qry.ded_hrd gt 0>
	            <cfset dedt_hrd = dedt_hrd + ded_var>
            </cfif>
			
			
	    </cfloop>
	
  		<cfset tded = tded + tot_new_value>
        <!--- EPF Process --->
		
		<!---<cfif salarypaytype eq "M">
			<cfset selct_range_RATE = select_empdata.brate>
		<cfelse>
			<cfset selct_range_RATE = brate>
		</cfif>--->
		<!---1st Half CPF Directly--->
		
       	<cfset fix_cpf = find("E", ucase(select_data.FIXOESP))>
		
        <cfif epfno neq "" and epfcat neq "X" and fix_cpf eq 0 
			and epf_selected neq 0 and epf1hd eq "Y">
   		
	        <cfset pay_to = select_empdata.epfbrinsbp>
		    
	        <cfif aw2_qry.abcdrepf eq "Y">
				<cfset PAYIN = #brate# + #val(dirfee)# + #additional_CPF# - #ded_cpf#>
	        <cfelseif pay_to eq "Y">
	        	<cfset PAYIN = #brate# + #val(dirfee)# + #additional_CPF# - #ded_cpf#>
	        <cfelse>
	        	<cfset PAYIN = #val(basicpay)# + #val(dirfee)# + #additional_CPF# - #ded_cpf#>
			</cfif> 
	      	
	      <!--- <cfif get_now_month.cd_h1cpf eq "Y"> --->
	      <cfif get_now_month.cpf_selectrange eq "Y">
		      	<cfset amt_range = val(select_empdata.brate)>
		      	<cfif get_now_month.cpf_add_rg eq "1">
			     <cfset amt_range = val(select_empdata.brate) + #val(dirfee)# + #additional_CPF# - #ded_cpf#> 	
			    </cfif>
		      	<cfquery name="get_epf_fml" datasource="#db#">
		        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #amt_range# AND EPFPAYT >= #amt_range#
		        </cfquery>
		  <cfelse>
				<cfquery name="get_epf_fml" datasource="#db#">
		        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #PAYIN# AND EPFPAYT >= #PAYIN#
		        </cfquery>
		  </cfif>      
		       
		        
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
		
	    <cfelseif fix_cpf gte 1>
	    		<cfset EPFW = select_data.EPFWW >
	        	<cfset EPFY = select_data.EPFCC >
    	<cfelse>
		        <cfset EPFY = 0>
		        <cfset EPFW = 0>
		        <cfset payin= 0>
        </cfif>
      
   
        <cfset epf_pay = #val(epfw)# + #val(epfy)# >
		
		<cfset epf_a = #payin#>
  		
		<cfif compccode eq "MY">
		<cfset socso_rate = val(basicpay) + val(add_hrd_ot) + val(add_hrd)- val(dedt_hrd)>	
	       <cfinvoke component="cfc.socsoprocess" method="calsocso" empno="#empno#" db="#db#" 
			 	returnvariable="socso_array" payrate="#socso_rate#"/>
        	<cfset socso_yee = socso_array[1]>
        	<cfset socso_yer = socso_array[2]>
       		
       		<cfquery name="update_socso_qry" datasource="#db#">
				UPDATE paytra1 
				set socsoww = #val(socso_yee)# ,
					socsocc = #val(socso_yer)# 
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
       			       		
       		<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)# -#val(socso_yee)#>
       	<cfelse>
       		<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)#>
		</cfif>
 		
		<!--- Process All Query --->
        <cfquery name="updatedw" datasource="#db#">
	        UPDATE paytra1 SET DW = #val(dW)# , 
			BASICPAY = #basicpay#, NPLPAY = #totalNPL#, 
			OT1 = #OT1#, OT2 = #OT2# , OT3 = #OT3# , OT4 = #OT4# , 
			OT5 = #OT5# , OT6 = #OT6# , OTPay = #OTtotal# , 
			TAW = #taw# , grosspay=#grosspay#, EPFWW=#EPFW#, 
			EPFCC=#EPFY#, epf_pay = #epf_pay#, TDED=#tded# , 
			TDEDU = #tded#, NETPAY = #netpay#, 
			epf_pay_a = #epf_a#, cpf_amt="#PAYIN#"
			WHERE empno = "#empno#"
        </cfquery>
		
		<!---<cfoutput>#EPFY#</cfoutput>
		<cfabort>
		<!--- update to pay_tm --->
		<cfquery name="ps" datasource="#db#">
        SELECT * FROM paytra1 WHERE empno = "#empno#"
        </cfquery>
        
        <!--- Select All From Bonus --->
        <cfquery name="bonus_data" datasource="#db#">
        SELECT * FROM bonus WHERE empno = "#empno#"
        </cfquery>
        
        <!--- Select All From Extra --->
        <cfquery name="extra_data" datasource="#db#">
        SELECT * FROM extra WHERE empno = "#empno#" 
        </cfquery>
        
        <!--- Select All From Comm --->
        <cfquery name="comm_data" datasource="#db#">
        SELECT * FROM comm WHERE empno = "#empno#" 
        </cfquery>        
		
		
        <!--- Update Into Pay_tm --->
		<cfquery name="updateintopaytm" datasource="#db#">
        UPDATE pay_tm SET
        <!--- HRD_PAY = #val(hrd_pay)#, --->
		    BONUS = #val(bonus_data.basicpay)#,
	        EXTRA = #val(extra_data.basicpay)#,
	        COMM = #val(comm_data.basicpay)#,
	        BRATE = #val(ps.brate)#,
	        OOB = #val(ps.oob)#,
	        WDAY = #val(ps.Wday)#,
			DW = #val(ps.DW)# , 
			PH = #val(ps.PH)#,
			AL = #val(ps.AL)#,
			ALHR = #val(ps.ALHR)#,
			MC = #val(ps.MC)#,
			MT = #val(ps.MT)#,
	        CC = #val(ps.CC)#,
			PT = #val(ps.PT)#,
			MR = #val(ps.MR)#,
			CL = #val(ps.CL)#,
			HL = #val(ps.HL)#,
	        AD = #val(ps.AD)#,
			EX = #val(ps.Ex)#,
			LS = #val(ps.LS)#,
			OPL = #val(ps.OPL)#,
			NPL = #val(ps.NPL)#,
			AB = #val(ps.AB)#,
			ONPL = #val(ps.ONPL)#,
			WORKHR = #val(ps.WORKHR)#,
			LATEHR = #val(ps.LATEHR)#,
			EARLYHR = #val(ps.EARLYHR)#,
	        NOPAYHR = #val(ps.NOPAYHR)#,
	        HR1 = #val(ps.HR1)#,
	        HR2 = #val(ps.HR2)#,
	        HR3 = #val(ps.HR3)#,
	        HR4 = #val(ps.HR4)#,
	        HR5 = #val(ps.HR5)#,
	        HR6 = #val(ps.HR6)#,
	        BASICPAY = #val(ps.BASICPAY)#,
	        OTPAY = #val(ps.OTPAY)#,
	        DIRFEE = #val(ps.DIRFEE)#,
	        TAW = #val(ps.TAW)#,
	        GROSSPAY = #val(ps.GROSSPAY)#,
	        TDEDU = #val(ps.TDEDU)#,
	        TDED = #val(ps.TDED)#,
	        NETPAY = #val(ps.NETPAY)#,
	        NPLPAY = #val(ps.NPLPAY)#,
	        TXAW = #val(ps.TXAW)#,
	        TXDED = #val(ps.TXDED)#,
	        OT1 = #val(ps.OT1)#,
	        OT2 = #val(ps.OT2)#,
	        OT3 = #val(ps.OT3)#,
	        OT4 = #val(ps.OT4)#,
	        OT5 = #val(ps.OT5)#,
	        OT6 = #val(ps.OT6)#,
	        AW101 = #val(ps.AW101)#,
	        AW102 = #val(ps.AW102)#,
	        AW103 = #val(ps.AW103)#,
	        AW104 = #val(ps.AW104)#,
	        AW105 = #val(ps.AW105)#,
	        AW106 = #val(ps.AW106)#,
	        AW107 = #val(ps.AW107)#,
	        AW108 = #val(ps.AW108)#,
	        AW109 = #val(ps.AW109)#,
	        AW110 = #val(ps.AW110)#,
	        AW111 = #val(ps.AW111)#,
	        AW112 = #val(ps.AW112)#,
	        AW113 = #val(ps.AW113)#,
	        AW114 = #val(ps.AW114)#,
	        AW115 = #val(ps.AW115)#,
	        AW116 = #val(ps.AW116)#,
	        AW117 = #val(ps.AW117)#,
	        DED101 = #val(ps.DED101)#,
	        DED102 = #val(ps.DED102)#,
	        DED103 = #val(ps.DED103)#,
	        DED104 = #val(ps.DED104)#,
	        DED105 = #val(ps.DED105)#,
	        DED106 = #val(ps.DED106)#,
	        DED107 = #val(ps.DED107)#,
	        DED108 = #val(ps.DED108)#,
	        DED109 = #val(ps.DED109)#,
	        DED110 = #val(ps.DED110)#,
	        DED111 = #val(ps.DED111)#,
	        DED112 = #val(ps.DED112)#,
	        DED113 = #val(ps.DED113)#,
	        DED114 = #val(ps.DED114)#,
	        DED115 = #val(ps.DED115)#,
	        ADVANCE = #val(ps.ADVANCE)#,
	        ITAXPCB = #val(ps.ITAXPCB)#,
	        ITAXPCBADJ = #val(ps.ITAXPCBADJ)#,
	        EPFWW = #val(ps.EPFWW)#,
	        EPFCC = #val(ps.EPFCC)#,
	        EPFWWEXT = #val(ps.EPFWWEXT)#,
	        EPFCCEXT = #val(ps.EPFCCEXT)#,
	        EPGCC = #val(ps.EPGCC)#,
	        SOASOWW = #val(ps.SOASOWW)#,
	        SOASOCC = #val(ps.SOASOCC)#,
	        SOBSOWW = #val(ps.SOBSOWW)#,
	        SOBSOCC = #val(ps.SOBSOCC)#,
	        SOCSOWW = #val(ps.SOCSOWW)#,
	        SOCSOCC = #val(ps.SOCSOCC)#,
	        SODSOWW = #val(ps.SODSOWW)#,
	        SODSOCC = #val(ps.SODSOCC)#,
	        SOESOWW = #val(ps.SOESOWW)#,
	        SOESOCC = #val(ps.SOESOCC)#,
	        CCSTAT1 = #val(ps.CCSTAT1)#,
	        PENCEN = #val(ps.PENCEN)#,
	        MFUND = #val(ps.MFUND)#,
	        DFUND = #val(ps.DFUND)#,
	        EPF_PAY = #val(ps.EPF_PAY)#,
	        EPF_PAY_A = #val(ps.EPF_PAY_A)#,
	        PAYYES = "Y"
        WHERE empno = "#empno#"
        </cfquery>--->
		
		<!--- calculate netpay project --->
		
			<cfinvoke component="cfc.project_job_costing" method="cal_project" empno="#empno#" db="#db#" 
				CPFCC_ADD_PRJ ="#get_now_month.CPFCC_ADD_PRJ#" CPFWW_ADD_PRJ ="#get_now_month.CPFWW_ADD_PRJ#"
					qry_tbl_pay="paytra1" proj_pay_qry="proj_rcd_1" compid="#compid#" db_main="#db1#" returnvariable="update_proj" /> 
                  
        <cfset myResult = "success">
		<cfreturn myResult>
	</cffunction>
</cfcomponent>