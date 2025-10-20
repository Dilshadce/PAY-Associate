
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
        <cfargument name="tablename" required="no">
 
        <cfquery name="select_data" datasource="#db#">
        SELECT * FROM #tablename#
        WHERE empno = "#empno#"
        </cfquery>
        
        <cfquery name="select_empdata" datasource="#db#">
        SELECT * FROM pmast
        WHERE empno = "#empno#"
        </cfquery>
        
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
        <cfset wDay = 13>
        </cfif>
        <cfset dW = select_data.DW>
        <cfset pH = select_data.PH>
        <cfset mC = select_data.MC>
        <cfset mT = select_data.MT>
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
         
          <!--- for cpf table automation choose --->
        <cfset national = select_empdata.national>
        <cfset r_status = select_empdata.r_statu>
        <cfset thisDate = Createdate(year(now()),month(now()),day(now()))>
        <cfif select_empdata.dbirth neq "">
		<cfset birthdate = Createdate(year(select_empdata.dbirth), month(select_empdata.dbirth), day(select_empdata.dbirth))>
		<cfset age = datediff("yyyy",birthdate,thisDate)>
		<cfelse>
			<cfset age=0>
		</cfif>
        
        <cfif select_empdata.pr_from neq "">
		<cfset pr_year = Createdate(year(select_empdata.pr_from), month(select_empdata.pr_from), day(select_empdata.pr_from))>
			<cfset pryear = datediff("yyyy",pr_year,thisDate)>
		<cfelse>
			<cfset pryear=0>
		</cfif>
        <cfset epf_table_array = ArrayNew(2)>
        <cfset epf_table_array[1][1] = "1">
        <cfset epf_table_array[1][2] = "2">
        <cfset epf_table_array[1][3] = "3">
        <cfset epf_table_array[1][4] = "4">
        <cfset epf_table_array[1][5] = "5">
        <cfset epf_table_array[1][6] = "6">
        <cfset epf_table_array[2][1] = "7">
        <cfset epf_table_array[2][2] = "8">
        <cfset epf_table_array[2][3] = "9">
        <cfset epf_table_array[2][4] = "10">
        <cfset epf_table_array[2][5] = "11">
        <cfset epf_table_array[2][6] = "12">
        <cfset epf_table_array[3][1] = "13">
        <cfset epf_table_array[3][2] = "14">
        <cfset epf_table_array[3][3] = "15">
        <cfset epf_table_array[3][4] = "16">
        <cfset epf_table_array[3][5] = "17">
        <cfset epf_table_array[3][6] = "18">
        
        <cfif pryear lt 2 and r_status eq "PR">
        <cfset x = 3>
        <cfelseif pryear lt 3 and r_status eq "PR">
        <cfset x = 2>
        <cfelseif national eq "SG" or pryear gte 3>
        <cfset x = 1>
        </cfif>
  			
  		<cfif age lte 35>
        <cfset y = 1>
        <cfelseif age lte 50>
		<cfset y = 2>
        <cfelseif age lte 55>
		<cfset y = 3>
        <cfelseif age lte 60>
		<cfset y = 4>
        <cfelseif age lte 65>
		<cfset y = 5>
        <cfelse>
		<cfset y = 6>
		</cfif>
        
        <cfset epf_selected = #evaluate(epf_table_array[#x#][#y#])#>
  
        
        <!--- check pay one or twice --->
        <cfquery name="check_pay" datasource="#db1#">
        SELECT bp_payment FROM gsetup WHERE comp_id = "#compid#"
        </cfquery>
        <cfset bRate = #val(brate)# / #val(check_pay.bp_payment)#>
        
        
        <!--- Work hours process --->
        <cfquery name="get_wh_qry" datasource="#db#">
        SELECT xhrpday_m FROM ottable where OT_COU = #whtbl#
        </cfquery>
        <cfset work_h = get_wh_qry.xhrpday_m>
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
     	<cfset dplustemp = #val(pH)# + #val(mC)# + #val(mT)# + #val(mR)# + #val(cL)# + #val(hL)# + #val(eX)# + #val(pT)# + #val(aD)# + #val(oPL)#>
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
        
        
        <!--- ALlowance Process --->
        <cfquery name="aw_qry" datasource="#db#">
			SELECT aw_cou,aw_desp,aw_epf FROM awtable
			where aw_cou < 18
		</cfquery>
        <cfset taw = 0>
        <cfloop query="aw_qry">
        	<cfset taw=#taw#+#val(select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1])#>
             <cfset aw_var = #val(select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1])#>
			<cfif aw_qry.aw_epf gt 0>
            <cfset additional_CPF = additional_CPF + aw_var >
            </cfif>
        </cfloop>
        
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
        <cfset ot_unit1[#i#] = otUnit>

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
        <cfset workingd = #evaluate('ot_table.xdaypmtha[#whtbl#]')# >
        
        <cfif #get_now_month.od_inclad# neq 0>
        <cfset BASICAW = val(bRate) + val(taw) >
        <cfelse>
        <cfset BASICAW = val(bRate) >
        </cfif>
      
        
        <cfset OT_VALUE = val(bRate) + val(taw) >
        <cfset OT_RATE_LIST = ArrayNew(1) >
        
        
        <cfif #BASICAW# gt #OTMAXPAY#>
        <cfset OT_VALUE = #OTMAXPAY#>
        
        <cfloop from="1" to="6" index="i">
        
		<cfif ot_unit1[i] eq "DAYS">
        <cfset workingh = 1 >
        </cfif>
        
        <cfif OTRATETYPE eq "C" and constant_list[i] gt 0>
        
        <cfset ArrayAppend(OT_RATE_LIST, "#constant_list[i]#")>
        
        <cfelseif OTRATETYPE eq "C" and constant_list[i] lte 0 >
		
    	<cfset OT_RATE_CALCULATE = ((OT_VALUE / workingd) / workingh ) * ratio_list[i] >
        
        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
        <cfset value111 = OT_VALUE / workingd >
        
        <cfelseif OTRATETYPE eq "R" and rate_list[i] gt 0 >
        <cfset ArrayAppend(OT_RATE_LIST, "#rate_list[i]#")>
        
        <cfelseif OTRATETYPE eq "R" and rate_list[i] lte 0 >
    	<cfset OT_RATE_CALCULATE = ((OT_VALUE / workingd) / workingh ) * ratio_list[i] >
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
    	<cfset OT_RATE_CALCULATE = ((OT_VALUE / workingd) / workingh ) * ratio_list[i] >
        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
        
        <cfelseif OTRATETYPE eq "R">
    	<cfset OT_RATE_CALCULATE = ((OT_VALUE / workingd) / workingh ) * ratio_list[i] >
        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
       
        </cfif>
        
        </cfloop>
        
		</cfif>
       
        
        <cfquery name="update_rate" datasource="#db#">
        UPDATE #tablename# SET 
        RATE1 = #numberformat(OT_RATE_LIST[1],'.__')#,
        RATE2 = #numberformat(OT_RATE_LIST[2],'.__')#,
        RATE3 = #numberformat(OT_RATE_LIST[3],'.__')#,
        RATE4 = #numberformat(OT_RATE_LIST[4],'.__')#,
        RATE5 = #numberformat(OT_RATE_LIST[5],'.__')#,
        RATE6 = #numberformat(OT_RATE_LIST[6],'.__')#
        WHERE empno = "#empno#"
        </cfquery>
        
        
        <cfquery name="select_new_rate" datasource="#db#">
        SELECT RATE1, RATE2, RATE3, RATE4, RATE5, RATE6 from #tablename# where empno = "#empno#"
        </cfquery>
		
        
        
  		<cfset OT1 = #val(select_new_rate.rate1)# * #val(hr1)#>
  		<cfset OT2 = #val(select_new_rate.rate2)# * #val(hr2)#>
        <cfset OT3 = #val(select_new_rate.rate3)# * #val(hr3)#>
        <cfset OT4 = #val(select_new_rate.rate4)# * #val(hr4)#>
        <cfset OT5 = #val(select_new_rate.rate5)# * #val(hr5)#>
        <cfset OT6 = #val(select_new_rate.rate6)# * #val(hr6)#>
        
        <cfloop from="1" to="6" index="ii">
        <cfquery name="check_cpf_addtional" datasource="#db#">
        SELECT * FROM ottable where ot_cou = #ii#
        </cfquery>
        <cfset ot_var = #evaluate("OT"&#ii#)# >
        <cfif ot_var gt 0 and #check_cpf_addtional.OT_EPF# gt 0>
        <cfset additional_CPF =  additional_CPF + ot_var>
        </cfif>
        </cfloop>
        <cfset OTtotal = OT1 + OT2 + OT3 + OT4 + OT5 +OT6>

        
        <!--- Calculate Gross Pay --->
        <cfset grosspay = #val(basicpay)# + #val(Ottotal)# + #val(taw)# + #val(dirfee)#>
        
        
        <!--- EPF Process --->
        <cfif epfno neq "" and epfcat neq "X">
        
        <cfset pay_to = select_empdata.epfbrinsbp>
        <cfif pay_to eq "Y">
        <cfset PAYIN = #val(bRate)#>
        <cfelse>
        <cfset PAYIN = #val(basicpay)# + #val(dirfee)# + #additional_CPF#>
		</cfif>
        <cfquery name="get_epf_fml" datasource="#db#">
        SELECT entryno FROM rngtable WHERE EPFPAYF <= #basicpay# AND EPFPAYT >= #basicpay#
        </cfquery>
        <cfset epf_entryno = get_epf_fml.entryno>
        <cfquery name="get_epf" datasource="#db#">
        SELECT * FROM rngtable WHERE entryno = #epf_entryno#
        </cfquery>
        
          <cfquery name="get_epf1" datasource="#db#">
        SELECT * FROM rngtable
        </cfquery>
        <cfif PAYIN gt #get_epf1.cpf_ceili#>
        <cfset PAYIN = #get_epf1.cpf_ceili#>
		</cfif>
        
        <cfset epf_yee = #get_epf['epfyee#epf_selected#'][1]#>
        <cfset epf_yer = #get_epf['epfyer#epf_selected#'][1]#>
        <cfset EPFW=#val(evaluate(#epf_yee#))#>
        <cfset result=#Replace(epf_yer,"ROUND","NumberFormat")#>
        <cfset EPFY=#val(evaluate(#result#))#>  
        
		<!--- check epf pay all by employer --->
        
		<cfset pay_by = select_empdata.epfbyer>
        <cfif pay_by eq "Y">
        <cfset EPFY=#val(EPFY)# + #val(EPFW)#>
         <cfset EPFW = 0>
		</cfif>
        <cfelse>
        <cfset EPFY = 0>
        <cfset EPFW = 0>
        </cfif>
              
        <!--- calculate MBMF --->
  		<cfloop from="1" to="15" index="i">
        <cfquery name="select_ded_formula" datasource="#db#">
        SELECT * FROM dedtable WHERE DED_COU = #i# 
        </cfquery>
        <cfset dedvar = 100 + #i# >
        <cfset dedvar1 = "DBDED"&#dedvar# >
        <cfset dedvar_update = "DED"&#dedvar# >
         <cfset deddata = #evaluate("select_empdata.#dedvar1#")#>
		<cfif deddata gt 0>
        <cfset new_ded_formula = select_ded_formula.DED_FOR>
        <cfset result=#Replace(new_ded_formula,"<"," lt ")#>
        <cfset new_value = #evaluate(result)#>
        <cfset new_value = #numberformat(new_value,'.__')# >
        
        
        <cfquery name="update_ded_to_paytran" datasource="#db#">
        UPDATE #tablename# SET #dedvar_update# = #new_value# WHERE empno = "#empno#"
        </cfquery>
		</cfif>
        
        </cfloop>
        
        
        <!--- Deduction Process --->
        <cfquery name="new_select_data" datasource="#db#">
        SELECT * FROM #tablename#
        WHERE empno = "#empno#"
        </cfquery>
        
        <cfset advance_value=#val(new_select_data.advance)#>
        <cfquery name="ded_qry" datasource="#db#">
		SELECT ded_cou,ded_desp FROM dedtable
		</cfquery>
		<cfset tded=0>
        <cfloop query="ded_qry">
        
        <cfset tded = #tded# + #val(new_select_data['ded1#numberformat(ded_qry.currentrow,"00")#'][1])#> 
        </cfloop>
        <cfset tded = #tded# + #advance_value#>
        
    
        
   
        <!--- Calculate Net Pay --->
        <cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)#>
        
       
        
        <!--- Process All Query --->
        <cfquery name="updatedw" datasource="#db#">
        UPDATE #tablename# SET DW = #dW# , BASICPAY = #basicpay#, NPLPAY = #totalNPL#, OT1 = #OT1#, OT2 = #OT2# , OT3 = #OT3# , OT4 = #OT4# , OT5 = #OT5# , OT6 = #OT6# , OTPay = #OTtotal# , TAW = #taw# , grosspay=#grosspay#, EPFWW=#EPFW#, EPFCC=#EPFY#, TDED=#tded# , TDEDU = #tded#, NETPAY = #netpay# WHERE empno = "#empno#"
        </cfquery>
        <cfset myResult = "success">
		<cfreturn myResult>
	</cffunction>
</cfcomponent>