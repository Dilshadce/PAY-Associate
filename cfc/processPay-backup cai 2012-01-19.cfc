	<cfcomponent>
    
    <cffunction name="roundno" returntype="numeric">
 <cfargument name="nocal" type="numeric" required="yes">
 <cfargument name="typeround" type="string" required="yes">
 <cfargument name="control" type="numeric" required="yes">
 
 <cfset lencontrol = len(control)>
 <cfif lencontrol eq "1">
 <cfset lencontrol = 100>
 <cfelseif lencontrol eq "2">
 <cfset lencontrol = 10>
 <cfelseif lencontrol eq "3">
 <cfset lencontrol = 1>
 </cfif>
 <cfset nocal = nocal * lencontrol>
 
 <cfif typeround eq "O">
 <cfset nocal = round(nocal)>
 </cfif>
 <cfif typeround eq "D">
 <cfset nocal = int(nocal+0.1)>
 </cfif>
 <cfif typeround eq "U">
 <cfif nocal gt int(nocal)>
 <cfset nocal = int(nocal)+1>
 <cfelse>
 <cfset nocal = int(nocal)>
 </cfif>
 </cfif>
 
 <cfif left(control,1) neq "1">
		<cfset roundto = left(control,1)>
        <cfset rightno = right(nocal,1)>
        <cfif rightno eq "0">
		<cfelseif rightno mod roundto eq 0>
        
		 <cfelse>
        <cfset rightno = 10 + rightno>
        <cfset totaladdon = rightno mod roundto>
        <cfset totaldeduct = roundto - totaladdon>        
         <cfif typeround eq "O">
			<cfif roundto/2 lte  totaladdon>
				<cfset nocal = nocal + totaldeduct>
            <cfelse>
            	<cfset nocal = nocal - totaladdon>
            </cfif>
		 </cfif>  
         
         <cfif typeround eq "D">			
            	<cfset nocal = nocal - totaladdon>
		 </cfif> 
         
         <cfif typeround eq "U">		
				<cfset nocal = nocal + totaldeduct>
		 </cfif>  
         
        </cfif>
	</cfif>
 
 <cfreturn nocal/lencontrol>
</cffunction>
	
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
	        SELECT * FROM paytran
	        WHERE empno = "#empno#"
	        </cfquery>
	        
	        <cfquery name="select_empdata" datasource="#db#">
	        SELECT * FROM pmast
	        WHERE empno = "#empno#"
	        </cfquery>
	        
            <cfquery name="bonus_qry" datasource="#db#">
                    SELECT basicpay,netpay,empno,fixoesp FROM bonus 
                    where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                </cfquery>
                <cfquery name="comm_qry" datasource="#db#">
                    SELECT basicpay,epfww,epfcc FROM comm
                    where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                </cfquery>
			<!--- <cfquery name="prj_rcd_qry" datasource ="#db#">
			SELECT sum(coalesce(dw_p,0)) as DW_P, sum(coalesce(MC_P,0)) as mc_p, sum(coalesce(npl_p,0)) as npl_p,
					sum(coalesce(ot1_p,0)) as ot_1, sum(coalesce(ot2_P)) as ot_2,
					sum(coalesce(ot3_p,0)) as ot_3, sum(coalesce(ot4_P)) as ot_4,
					sum(coalesce(ot5_p,0)) as ot_5, sum(coalesce(ot6_P)) as ot_6
	 		FROM proj_rcd WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery> --->
			
	        <cfset salarypaytype =  select_empdata.payrtype >
	        
	        <!--- get monthg for oob calculation --->
	        <cfquery name="get_now_month" datasource="#db1#">
	        	SELECT * FROM gsetup WHERE comp_id = "#compid#"
	        </cfquery>
	                
	       	<cfset Date_OOB = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
	       	<cfset bRate=select_data.BRATE>
	        <cfset OOB = select_data.OOB>
	        <cfif OOB gt 0>
		        <cfset days_OOB =DaysInMonth(Date_OOB) >
		        <cfset bRate = (bRate * (days_OOB - OOB)) / days_OOB >
	        </cfif>
	        <cfset wDay = select_data.WDAY>
	        <cfif wDay eq 0 Or Wday eq "">
		        <cfif salarypaytype neq "H">
		        <cfset wDay = 26>
		        </cfif>
	        </cfif>
			<cfset paytype = 2 >
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
            <cfset NS = select_data.NS>
	        <cfset oNPL = select_data.ONPL>
	<!---   <cfset rate1= select_data.RATE1>
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
	        <cfset whtbl = select_empdata.whtbl>
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
            <cfset bonus = val(bonus_qry.basicpay)>
            <cfset comm = val(comm_qry.basicpay)>
            <cfset total_late_h = 0>
            <cfset total_earlyD_h = 0>
            <cfset total_noP_h = 0>
            <cfset total_work_h = 0>
            <cfset hourrate = 0>
	        <!--- for cpf table automation choose --->
	       <!---  <cfset national = select_empdata.national>
	        <cfset r_status = select_empdata.r_statu>
			
	        <cfset thisDate = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
	       <!---  <cfset num_day = DaysInMonth(thisDate)>
			<cfset thisDate = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,num_day)> --->
			<cfif select_empdata.dbirth neq "">
				<cfset birthdate = Createdate(year(select_empdata.dbirth), month(select_empdata.dbirth), day(select_empdata.dbirth))>
				<cfif thisDate gte birthdate>
					<cfset age = datediff("yyyy",birthdate,thisDate)>	
				<cfelse>
					<cfset age = datediff("yyyy",birthdate,thisDate)-1>
				</cfif>
					
			<cfelse>
				<cfset age=0>
			</cfif>
	        
	        <cfif select_empdata.pr_from neq "">
				<cfset pr_year = Createdate(year(select_empdata.pr_from), month(select_empdata.pr_from), day(select_empdata.pr_from))>
				<cfset pryear = datediff('yyyy',pr_year,thisDate)+1>
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
	        
			<cfset x =1 >
			
	        <cfif pryear lt 2 and r_status eq "PR">
	        <cfset x = 2>
	        <cfelseif pryear lt 3 and r_status eq "PR">
	        <cfset x = 3>
	        <cfelseif national eq "SG" or pryear gte 3>
	        <cfset x = 1>
	        </cfif>
	        
	  		<cfset y = 1>
	  		<cfif age lt 35>
	        <cfset y = 1>
	        <cfelseif age lt 50>
			<cfset y = 2>
	        <cfelseif age lt 55>
			<cfset y = 3>
	        <cfelseif age lt 60>
			<cfset y = 4>
	        <cfelseif age lt 65>
			<cfset y = 5>
	        <cfelse>
			<cfset y = 6>
			</cfif>
	        
	        <cfset epf_selected = #evaluate(epf_table_array[#x#][#y#])#> --->
		     <cfif compccode eq "SG">  
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
							<cfset birthdate = Createdate(year(select_empdata.dbirth), month(select_empdata.dbirth), '1')>
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
							
				<!--- <cfoutput>#empno# #epf_selected#<br></cfoutput> --->
		        <cfquery name="update_epf_table" datasource="#db#">
		        	UPDATE pmast SET epftbl = #epf_selected# WHERE empno = "#empno#"
		        </cfquery>
		  	<cfelse>
		  		<cfset epf_selected = select_empdata.epftbl >
	        </cfif>
	        
	        <!--- check pay one or twice --->
	        <cfquery name="check_pay" datasource="#db1#">
	        	SELECT bp_payment FROM gsetup WHERE comp_id = "#compid#"
	        </cfquery>
	     <!---    <cfset bRate = #val(brate)# / #val(check_pay.bp_payment)#> --->
	        
	        <!--- working hour data --->
	        <cfquery name="get_wh_qry" datasource="#db#">
	        	SELECT xhrpday_m FROM ottable where OT_COU = #val(whtbl)#
	        </cfquery>
	        <cfset work_h = get_wh_qry.xhrpday_m>
			
			<!--- check daily or hourly pay --->
	        <cfset salarypaytype =  select_empdata.payrtype >
	        <cfif salarypaytype eq "D">
	    
	        	<cfset brate = #val(brate)# * #val(wDay)# >
	        
	        <cfelseif salarypaytype eq "H">    
				<cfset total_work_amt = #val(brate)# * (#val(workHR)# - #val(lateHR)# - #val(earlyHR)# - #val(noPayHR)#) >
		        <cfset brate = #val(brate)# * #val(wDay)# * #val(work_h)#+ #val(total_work_amt)#>
			</cfif>
			
	        
	        
	        <!--- Work hours process --->
	       
	        <cfif salarypaytype neq "H" >
            <cfif get_now_month.hpy eq "Y">
            <cfquery name="getottablenew" datasource="#db#">
            SELECT xpaymthpy,xhrpyear FROM ottable
            </cfquery>
            
            <cfif val(evaluate('getottablenew.xhrpyear[#whtbl#]')) neq 0>
            <cfset hour_r = (val(brate) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]'))> 
            <cfelse>
            <cfset hour_r = 1 / (#val(wDay)# * #val(work_h)#) * #val(brate)#> 
			</cfif>
     
            <cfelse>
	        <cfset hour_r = 1 / (#val(wDay)# * #val(work_h)#) * #val(brate)#> 
            </cfif>
            <cfif get_now_month.payhourrate eq "Y">
            <cfset hour_r = numberformat(hour_r,'.__')>
			</cfif>
			<cfset hourrate = hour_r>
            
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
	        <cfset dminustemp =  #val(lS)# +  #val(nPL)# +  #val(aB)# +  #val(oNPL)# +  #val(NS)#>
	        <cfset totalspecialday = dplustemp + dminustemp>
	        <cfset outstandingday = #val(wDay)# - #val(dW)# - totalspecialday>
	        <cfif outstandingday neq 0>
				<cfif get_now_month.pay_to_nopay neq "">
				<cfset dW=#val(dW)#>	
				<cfelse>	
	        	<cfset dW=#val(dW)#+outstandingday>
				</cfif>
	        </cfif>
	        <cfset payday = #val(WDay)# - dminustemp>
	        
	        <cfset totalNPL = dminustemp / #val(wDay)# * #val(bRate)#> 
	        <!--- Basic Pay Process --->
	      	<cfset basicpay = (#val(payday)# / #val(wDay)# * #val(bRate)#) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
	        
			
			<cfelse>
				<cfset totalNPL = 0.00 >
		        <cfset basicpay = #val(brate)#  + #val(piecepay)# + #val(backpay)# >
		        
			</cfif>
	        
	 
	 		<cfquery name="aw_qry" datasource="#db#">
				SELECT aw_cou,aw_desp,aw_epf,aw_dbase,aw_type,aw_for,aw_rattn,aw_npl,aw_hrd,aw_addw,aw_npl FROM awtable
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
            <cfset additionalwages = 0>
            <cfset awnplamount = 0>
			
			    	<!------------------Shift Process -------->
		<cfquery name="getshiftbl" datasource="#db#">
			SELECT * FROM shftable where shf_cou ="#select_empdata.shifttbl#"
		</cfquery> 
		
		<cfset sumshift = 0>
			
		<cfloop from="1" to="20" index="i">
					<cfset rateno = chr(96+i)>
					<cfset shiftday = evaluate('select_data.shift#rateno#')>
					<cfset shiftrate = evaluate('getshiftbl.shift#i#')>
					<cfset totalshift = val(shiftday) * val(shiftrate)>
					<cfset sumshift = sumshift + val(totalshift)>
			</cfloop>	
			
			
	        <cfloop query="aw_qry">
				
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
				
				<cfelseif #sumshift# gt 0 and aw_qry.aw_type eq "S" >
					<cfset AW = #sumshift#>
		            <cfset aw_data = #sumshift# >
					
				<cfelse>
		            	<cfset aw_data = 0 >
				</cfif>
				
	            <cfset aw_variable = 'aw1'&#numberformat(aw_qry.currentrow,"00")# >
	            <cfquery name="updata_aw_back" datasource="#db#">
	            	UPDATE paytran SET #aw_variable# = #aw_data# WHERE empno = "#empno#"
	            </cfquery>
	            
				<cfset taw= taw + aw_data>
	            <cfset aw_var = #aw_data#>
				<cfif aw_qry.aw_epf gt 0>
	            	<cfset additional_CPF = additional_CPF + aw_var >
                <cfif aw_qry.aw_addw gt 0>
                <cfset additionalwages = additionalwages + aw_var >
				</cfif>
	            </cfif>
                <cfif aw_qry.aw_npl gt 0>
                <cfset awnplamount =awnplamount + aw_var >
	            </cfif>
	            <cfif aw_qry.aw_hrd gt 0>
		            <cfset add_hrd = add_hrd + aw_var>
	            </cfif>
                
                
	        </cfloop>
            
			<cfif salarypaytype neq "H" >
            <cfif get_now_month.allowancenpl eq "Y">
            <cfset totalNPL = (dminustemp / #val(wDay)#) * (val(bRate)+val(awnplamount))>
	        </cfif>
			<!--- Basic Pay Process --->
            <cfif get_now_month.allowancenpl eq "Y">
	      	<cfset basicpay = (#val(payday)# / #val(wDay)# * (val(bRate)+val(awnplamount)))-val(awnplamount) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
            </cfif>
            </cfif>
            
            <cfif salarypaytype neq "H" and get_now_month.NPLHPY eq "Y" >
                
                <cfquery name="getottablenew" datasource="#db#">
                SELECT xpaymthpy,xhrpyear,XHRPDAY_M FROM ottable
                 </cfquery>
                 
                 <cfquery name="getallownpl" datasource="#db#">
                 select aw_cou from awtable where aw_npl > 0 and aw_cou < 18
                 </cfquery>
                 <cfset allowancerate = 0>
                 
				 <cfif getallownpl.recordcount neq 0>
					 <cfset allowancevar= "">
                         <cfloop query="getallownpl">
                         <cfset allowancevar = allowancevar&"coalesce(dbaw"&100+val(getallownpl.aw_cou)&",0)">
                             <cfif getallownpl.recordcount neq getallownpl.currentrow>
                             <cfset allowancevar = allowancevar&" + ">
                             </cfif>
                         </cfloop>
                     <cfif allowancevar neq "">
                     <cfquery name="getallowancesum" datasource="#db#">
                     SELECT sum(#allowancevar#) as sumnplaw FROM pmast where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                     </cfquery>
                     <cfset allowancerate = val(getallowancesum.sumnplaw)>
				 	</cfif>
                  </cfif>
                 
                 <cfset npldayrate = (((val(select_empdata.brate)+val(allowancerate)) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]')))*val(evaluate('getottablenew.XHRPDAY_M[#whtbl#]'))>
                 
            <cfset totalNPL = val(dminustemp) * numberformat(val(npldayrate),'.__')>
            <cfset totalNPL = numberformat(val(totalNPL),'.__')>
	      	<cfset basicpay = val(brate)-val(totalNPL) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
            </cfif>
            
            <cfif salarypaytype neq "H" and get_now_month.NPLDED eq "Y" >
            <cfquery name="getottablenew" datasource="#db#">
                SELECT xpaymthpy,xhrpyear,XHRPDAY_M,xdaypmth FROM ottable
                 </cfquery>
                 <cfset allowancerate = 0>
                 <cfif get_now_month.allowancenpl eq "Y">
                 <cfquery name="getallownpl" datasource="#db#">
                 select aw_cou from awtable where aw_npl > 0 and aw_cou < 18
                 </cfquery>
                 
                 
				 <cfif getallownpl.recordcount neq 0>
					 <cfset allowancevar= "">
                         <cfloop query="getallownpl">
                         <cfset allowancevar = allowancevar&"coalesce(dbaw"&100+val(getallownpl.aw_cou)&",0)">
                             <cfif getallownpl.recordcount neq getallownpl.currentrow>
                             <cfset allowancevar = allowancevar&" + ">
                             </cfif>
                         </cfloop>
                     <cfif allowancevar neq "">
                     <cfquery name="getallowancesum" datasource="#db#">
                     SELECT sum(#allowancevar#) as sumnplaw FROM pmast where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                     </cfquery>
                     <cfset allowancerate = val(getallowancesum.sumnplaw)>
				 	</cfif>
                  </cfif>
                 </cfif>
                 
                 <cfif get_now_month.bp_dedmnpl eq "" or get_now_month.bp_dedmnpl eq "WD">
                 <cfset npldayrate = (val(brate)+val(allowancerate)) /val(wDay)>
				 <cfelseif get_now_month.bp_dedmnpl eq "FD">
                 <cfset npldayrate = (val(select_empdata.brate)+val(allowancerate)) /val(evaluate('getottablenew.xdaypmth[#whtbl#]'))>
				 <cfelseif get_now_month.bp_dedmnpl eq "DW">
                 <cfset npldayrate = (val(select_empdata.brate)+val(allowancerate)) /daysinmonth(createdate(get_now_month.myear,get_now_month.mmonth,'1')) >                 
                 <cfelse>
                 <cfset npldayrate = (((val(select_empdata.brate)+val(allowancerate)) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]')))*val(evaluate('getottablenew.XHRPDAY_M[#whtbl#]'))>
                 </cfif>
                 
                 
                 
            <cfset totalNPL = val(dminustemp) * numberformat(val(npldayrate),'.__')>
			<cfif salarypaytype eq "D">
            <cfset totalNPL = val(dminustemp) * numberformat(val(select_data.BRATE),'.__')>
            </cfif>
            <cfset totalNPL = numberformat(val(totalNPL),'.__')>
	      	<cfset basicpay = val(brate)-val(totalNPL) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
            </cfif>
            
	        
	        <!--- Deduction Process --->
	        <!--- <cfquery name="new_select_data" datasource="#db#">
		        SELECT * FROM paytran
		        WHERE empno = "#empno#"
	        </cfquery>
	        
	        <cfset advance_value=#val(new_select_data.advance)#>
	        <cfquery name="ded_qry" datasource="#db#">
				SELECT * FROM dedtable
			</cfquery>
			<cfset tded=0>
			<cfset ded_CPF = 0 >
	        <cfloop query="ded_qry">
			 	<cfset ggross_ded_for= #find("GROSSPAY",ded_qry.ded_for)#>
				<cfif ggross_ded_for eq 0>
					<cfset ded_var = val(new_select_data['ded1#numberformat(ded_qry.currentrow,"00")#'][1])>
					
					<cfset tded = #tded# + ded_var> 
					
					<cfif ded_qry.ded_epf gt 0>
			            <cfset ded_CPF = ded_CPF + ded_var >
			        </cfif>
				</cfif>
			</cfloop>
			 --->
			 <cfquery name="ded_qry" datasource="#db#">
				SELECT ded_for,ded_type,ded_hrd,ded_epf,ded_hrd FROM dedtable d where ded_cou < 16
			</cfquery>
		
			<cfquery name="pay_ded" datasource="#db#">
	        	SELECT * FROM paytran
	        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	        </cfquery>
			
			<cfquery name="emp_ded" datasource="#db#">
	        	SELECT * FROM pmast
	        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	        </cfquery>
			
			<cfset advance_value = val(pay_ded.advance)>
			
			<cfset ded_array = ArrayNew(1)>
	      	<cfset ded_CPF = 0>
			
			<cfset tded=0>
			<cfloop query="ded_qry">
				<cfset ded_data = 0>	
				<cfif ded_qry.ded_type eq "F">
					<cfif ded_qry.ded_for eq "" >
						<cfset ded_data =  val(emp_ded['dbded1#numberformat(ded_qry.currentrow,"00")#'][1])>
						<cfset tded = tded + ded_data>
						
					<cfelse>
						<cfset DED = val(emp_ded['dbded1#numberformat(ded_qry.currentrow,"00")#'][1])>
						<cfset ggross_ded_for= #find("GROSSPAY",ded_qry.ded_for)#>
                        <cfset ggross_ded_for2= #find("GROSS1PAY",ded_qry.ded_for)#>
						<cfif ggross_ded_for eq 0 and ggross_ded_for2 eq 0>
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
	            	UPDATE paytran SET #ded_variable# = #ded_data# WHERE empno = "#empno#"
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
							SELECT AW#tempawvar# as AW from paytran where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
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
						SELECT ded#tempdedvar# as DED from paytran where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
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
				SELECT basicpay, bRate FROM paytran WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">;
			</cfquery>
			<cfquery name="aw2_qry" datasource="#db#">
				SELECT aw_cou,abcd_desp,abcdrepf,abcdrot FROM awtable where aw_cou='2'
			</cfquery>	
			
			<cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
			<cfset getBasic.brate = select_empdata.brate>
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
			
			<cfquery name="testqry" datasource="#db#">
            SELECT empno FROM pmast where "#basicpay#" = "#basicpay#"
            </cfquery>		
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
			       	<cfif salarypaytype eq "H">
			        	<cfset workingd = 1 >
			        	<cfset workingh = 1 >
			        </cfif>
			        <cfif OTRATETYPE eq "C" and constant_list[i] gt 0>
			        
			        	<cfset ArrayAppend(OT_RATE_LIST, "#constant_list[i]#")>
			        
			        <cfelseif OTRATETYPE eq "C" and constant_list[i] lte 0 >
                    
                    <cfif get_now_month.hpy eq "Y" and salarypaytype neq "H" and salarypaytype neq "D">
					<cfset hourspy = #evaluate('ot_table.xhrpyear[#whtbl#]')# >
                    <cfset monthspy = #evaluate('ot_table.xpaymthpy[#whtbl#]')# >
                    <cfif ot_unit1[i] eq "DAYS">
                    <cfset hourspd = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
                    <cfelse>
                    <cfset hourspd = 1 >
                    </cfif>
                    <cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) ) * ratio_list[i] >
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >                    </cfif>
                    
				        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
				        <cfset value111 = OT_VALUE / workingd >
			        
			        <cfelseif OTRATETYPE eq "R" and rate_list[i] gt 0 >
			        	<cfset ArrayAppend(OT_RATE_LIST, "#rate_list[i]#")>
			        
			        <cfelseif OTRATETYPE eq "R" and rate_list[i] lte 0 >
				    
					<cfif get_now_month.hpy eq "Y" and salarypaytype neq "H" and salarypaytype neq "D">
					<cfset hourspy = #evaluate('ot_table.xhrpyear[#whtbl#]')# >
                    <cfset monthspy = #evaluate('ot_table.xpaymthpy[#whtbl#]')# >
                    <cfif ot_unit1[i] eq "DAYS">
                    <cfset hourspd = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
                    <cfelse>
                    <cfset hourspd = 1 >
                    </cfif>
                    <cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) ) * ratio_list[i] >
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >                    </cfif>
                    
				    <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			       
			        </cfif>
		        
		        </cfloop>     
		         
	        <cfelse>
	        
		        <cfloop from="1" to="6" index="i">
					
				
					<cfif ot_unit1[i] eq "DAYS">
			        	<cfset workingh = 1 >
			        </cfif>
			      
			        <cfif salarypaytype eq "H">
			        	<cfset workingd = 1 >
			        	<cfset workingh = 1 >
			        </cfif>
			       
			        <cfif OTRATETYPE eq "C" and constant_list[i] gt 0>
			        	<cfset ArrayAppend(OT_RATE_LIST, "#constant_list[i]#")>
			        
			        <cfelseif OTRATETYPE eq "C" and constant_list[i] lte 0 >
				    
					<cfif get_now_month.hpy eq "Y" and salarypaytype neq "H" and salarypaytype neq "D">
					<cfset hourspy = #evaluate('ot_table.xhrpyear[#whtbl#]')# >
                    <cfset monthspy = #evaluate('ot_table.xpaymthpy[#whtbl#]')# >
                    <cfif ot_unit1[i] eq "DAYS">
                    <cfset hourspd = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
                    <cfelse>
                    <cfset hourspd = 1 >
                    </cfif>
                    <cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) ) * ratio_list[i] >
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >                    </cfif>
                    
				        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			        
			        <cfelseif OTRATETYPE eq "R">
				    
					<cfif get_now_month.hpy eq "Y" and salarypaytype neq "H" and salarypaytype neq "D">
					<cfset hourspy = #evaluate('ot_table.xhrpyear[#whtbl#]')# >
                    <cfset monthspy = #evaluate('ot_table.xpaymthpy[#whtbl#]')# >
                    <cfif ot_unit1[i] eq "DAYS">
                    <cfset hourspd = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
                    <cfelse>
                    <cfset hourspd = 1 >
                    </cfif>
                    <cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) ) * ratio_list[i] >
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >                    </cfif>
                    
				        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			        </cfif>
			             
		        </cfloop>
	        
			</cfif>
	    
	        <cfquery name="update_rate" datasource="#db#">
	        UPDATE paytran SET 
	        RATE1 = #numberformat(OT_RATE_LIST[1],'.__')#,
	        RATE2 = #numberformat(OT_RATE_LIST[2],'.__')#,
	        RATE3 = #numberformat(OT_RATE_LIST[3],'.__')#,
	        RATE4 = #numberformat(OT_RATE_LIST[4],'.__')#,
	        RATE5 = #numberformat(OT_RATE_LIST[5],'.__')#,
	        RATE6 = #numberformat(OT_RATE_LIST[6],'.__')#
	        WHERE empno = "#empno#"
	        </cfquery>
	        
	        
	        <cfquery name="select_new_rate" datasource="#db#">
	        SELECT RATE1, RATE2, RATE3, RATE4, RATE5, RATE6 from paytran where empno = "#empno#"
	        </cfquery>
			
	  		<cfset OT1 = #val(select_new_rate.rate1)# * #val(hr1)#>
	  		<cfset OT2 = #val(select_new_rate.rate2)# * #val(hr2)#>
	        <cfset OT3 = #val(select_new_rate.rate3)# * #val(hr3)#>
	        <cfset OT4 = #val(select_new_rate.rate4)# * #val(hr4)#>
	        <cfset OT5 = #val(select_new_rate.rate5)# * #val(hr5)#>
	        <cfset OT6 = #val(select_new_rate.rate6)# * #val(hr6)#>
	        <cfset add_hrd_ot = 0>
	        <cfset OT1 = roundno(OT1,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
	       <cfset OT2 = roundno(OT2,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
           <cfset OT3 = roundno(OT3,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
           <cfset OT4 = roundno(OT4,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
           <cfset OT5 = roundno(OT5,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
           <cfset OT6 = roundno(OT6,'#get_now_month.sud_otrnd#','#get_now_month.sud_otpsu#')>
	        <cfloop from="1" to="6" index="ii">
		        <cfquery name="check_cpf_addtional" datasource="#db#">
		        	SELECT * FROM ottable where ot_cou = #ii#
		        </cfquery>
		        <cfset ot_var = #evaluate("OT"&#ii#)# >
	        	
	        	<cfif ot_var gt 0 and check_cpf_addtional.OT_EPF gt 0>
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
	        	SELECT * FROM paytran
	        	where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	        </cfquery>
			<cfquery name="pay_gs_1" datasource="#db#">
	        	SELECT grosspay FROM paytra1
	        	where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	        </cfquery>
			<cfset grosspay1 = val(pay_gs_1.grosspay)>
	  		<cfset gross1pay = val(pay_gs_1.grosspay)>
	  		
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
		        <cfset ggrosspay = #find("GROSSPAY",select_ded_formula.ded_for)#>
				<cfset PAY_TIMES = 2>
				
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
		           				
			    	<cfquery name="update_ded_to_paytran" datasource="#db#">
		        		UPDATE paytran SET #dedvar_update# = #new_value# WHERE empno = "#empno#"
		     		</cfquery>
		     		<cfset tot_new_value = tot_new_value + new_value>
						
					<cfif select_ded_formula.ded_epf gt 0>
			            <cfset ded_CPF = ded_CPF + new_value >
			        </cfif>
				</cfif>
				
				<cfif DED eq 0 AND ggrosspay gt 0>
			    	<cfset new_value = 0>
				    <cfquery name="update_ded_to_paytran" datasource="#db#">
			        	UPDATE paytran SET #dedvar_update# = #new_value# WHERE empno = "#empno#"
			     	</cfquery>
			     	<cfif select_ded_formula.ded_epf gt 0>
			            <cfset ded_CPF = ded_CPF + new_value >
			        </cfif>
			     	<cfset tot_new_value = tot_new_value + new_value>
				</cfif>	
				
				<cfset ded_var = #evaluate("pay_ded.#dedvar_update#")#>
				
				<cfif select_ded_formula.ded_epf gt 0>
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
			
			<cfset fix_cpf = find("E", ucase(select_data.FIXOESP))>
			
	        <cfif epfno neq "" and epfcat neq "X" and fix_cpf eq 0 and epf_selected neq 0>
	        
	   			<!---Cal.CPF Using Basic Rate Instead Of Basic Pay--->
		        <cfset pay_to = select_empdata.epfbrinsbp>
		        
                <cfset nspay = 0>
				<cfif val(ns) neq 0>
                <cfif val(wDay) neq 0>
                <cfset nspay = val(ns)/ val(wDay) * brate >
                </cfif>
                </cfif>
                
		        <cfif aw2_qry.abcdrepf eq "Y">
					<cfset PAYIN = #brate# + #val(dirfee)# + #additional_CPF# - #ded_cpf# >
		        <cfelseif pay_to eq "Y">
		        	<cfset PAYIN = #brate# + #val(dirfee)# + #additional_CPF# - #ded_cpf#>
		        <cfelse>
		        	<cfset PAYIN = #val(basicpay)# + #val(dirfee)# + #additional_CPF# - #ded_cpf# + val(nspay) >
				</cfif> 
				
				<cfset payin_2nd = val(PAYIN)>
				<cfquery name="paytra1_qry" datasource="#db#">
					SELECT cpf_amt,EPFWW, EPFCC from paytra1 
					where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
                
				
				<cfset PAYIN = val(PAYIN) + val(paytra1_qry.cpf_amt)>
                <cfset choosepayin = val(PAYIN) + val(bonus_qry.basicpay) + val(comm_qry.basicpay)>
				
		        <cfquery name="get_epf_fml" datasource="#db#">
		        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #choosepayin# AND EPFPAYT >= #choosepayin# 
		        </cfquery>
		        
		        <cfset epf_entryno = get_epf_fml.entryno>    
		        <cfquery name="get_epf" datasource="#db#">
		        	SELECT * FROM rngtable WHERE entryno = "#epf_entryno#"
		        </cfquery>
		        
		        <cfquery name="get_epf1" datasource="#db#">
		        	SELECT cpf_ceili FROM rngtable where entryno="1"
		        </cfquery>
		       
                <cfset oldpayin = PAYIN>
                <cfif PAYIN lte #get_epf1.cpf_ceili#>
				<cfelse>
                    <cfif val(additionalwages) neq 0>
                    <cfset newpayin = payin - val(additionalwages)>
                    
                        <cfif newpayin lte #get_epf1.cpf_ceili#>
                        <cfset PAYIN = newpayin>
                        <cfelse>
                        <cfset PAYIN = #get_epf1.cpf_ceili#>
                        </cfif>
                    
                    <cfelse>
                    <cfset PAYIN = #get_epf1.cpf_ceili#>
                    </cfif>
                
                </cfif>
				<cfset oldpayin1 = PAYIN>
                <cfset PAYIN = PAYIN + val(bonus_qry.basicpay) + val(comm_qry.basicpay)>
                <cfif oldpayin gt #get_epf1.cpf_ceili# and val(additionalwages) neq 0>
                <cfset PAYIN = PAYIN + val(additionalwages)>
				</cfif>
                
		        <cfset epf_yee = #get_epf['epfyee#epf_selected#'][1]#>
		        <cfset epf_yer = #get_epf['epfyer#epf_selected#'][1]#>
		        
		        <cfset EPFW = #val(evaluate(#epf_yee#))#>

		        <cfset result= #Replace(epf_yer,"ROUND","NumberFormat")#>
		        <cfset EPFY = #val(evaluate(#result#))#>
		        
		      <!---   cpf amount not round --->
		        
		        <cfset result1= #REReplace(epf_yee,"INT"," ", "all")#>
				<cfset EPFW_nt_round = #val(evaluate(#result1#))#>
				
		        <cfset result=#Replace(epf_yer,"ROUND"," ","all")#>
		        <cfset epf_yer_result=#Replace(result,",0"," ","all")#>
		        <cfif val(payin) eq 0>
                <cfset payin = 1>
				</cfif>
		        <cfset epf_yer_nt_round=#val(evaluate(#epf_yer_result#))#>
                <cfset EPFWORI = EPFW>
			     <cfset EPFYORI = EPFY>
                 <cfset EPFW_nt_roundORI = EPFW_nt_round>
                 <cfset epf_yer_nt_roundORI =epf_yer_nt_round>
                <cfset EPFW = EPFW * val(oldpayin1) / val(PAYIN)>
                <cfset EPFY = EPFY * val(oldpayin1) / val(PAYIN)>
                <cfset EPFW_nt_round = EPFW_nt_round * val(oldpayin1) / val(PAYIN)>
                <cfset epf_yer_nt_round = epf_yer_nt_round * val(oldpayin1) / val(PAYIN)>
                
		         
				 <cfif val(additionalwages) neq 0 and oldpayin gt #get_epf1.cpf_ceili#>
                    <cfset EPFW1 = EPFWORI * val(additionalwages) / val(PAYIN)>
					<cfset EPFY1 = EPFYORI * val(additionalwages) / val(PAYIN)>
                    <cfset EPFW_nt_round1 = EPFW_nt_roundORI * val(additionalwages) / val(PAYIN)>
                    <cfset epf_yer_nt_round1 = epf_yer_nt_roundORI * val(additionalwages) / val(PAYIN)>
                    <cfset EPFW = EPFW + EPFW1>
       			    <cfset EPFY = EPFY + EPFY1>
                    <cfset EPFW_nt_round = EPFW_nt_round + EPFW_nt_round1>
                    <cfset epf_yer_nt_round= epf_yer_nt_round + epf_yer_nt_round1>
                 <!--- <cfelse>
                 <cfset additionalwages = 0> --->
				  </cfif>
                <cfset EPFW = round(EPFW)>
                <cfset EPFY = round(EPFY)>
		        
		       
		        <cfquery name="update_round_cpf_pay_tm" datasource="#db#">
					UPDATE pay_tm 
					SET p_epfww = #val(EPFW_nt_round)#,
						p_epfcc = #val(epf_yer_nt_round)#
      
					WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
		        
		      <!---  select cpf 1st half  as full month pay  --->
		        <cfif epf1hd eq "Y">
			        <cfset EPFW = numberformat(val(EPFW),'.__') - numberformat(val(paytra1_qry.EPFWW),'.__') > 
			       	<cfset EPFY = numberformat(val(EPFY),'.__') - numberformat(val(paytra1_qry.EPFCC),'.__') > 
		        </cfif>
				
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
		        	<cfquery name="update_round_cpf_pay_tm" datasource="#db#">
					UPDATE pay_tm 
					SET p_epfww = #val(EPFW)#,
						p_epfcc = #val(EPFY)#
					WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
		    		<cfset payin_2nd = 0>
                    <cfset additionalwages= 0>
		    <cfelse>
			        <cfset EPFY = 0>
			        <cfset EPFW = 0>
			        <cfset payin_2nd = 0>
                    <cfset additionalwages= 0>
                    <cfquery name="update_round_cpf_pay_tm" datasource="#db#">
					UPDATE pay_tm 
					SET p_epfww = 0,
						p_epfcc = 0
					WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
	        </cfif>
	        
	        
	        <cfif compccode eq "MY">
		       	<cfset socso_rate = val(basicpay) + val(add_hrd_ot) + val(add_hrd)- val(dedt_hrd)>	       
		       <cfinvoke component="cfc.socsoprocess" method="calsocso" empno="#empno#" db="#db#" 
				 	returnvariable="socso_array" payrate="#socso_rate#"/>
	        	<cfset socso_yee = socso_array[1]>
	        	<cfset socso_yer = socso_array[2]>
	       		
	       		<cfquery name="update_socso_qry" datasource="#db#">
					UPDATE paytran 
					set socsoww = #val(socso_yee)# ,
						socsocc = #val(socso_yer)# 
					where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
	       			       		
	       		<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)# - #val(socso_yee)#>
	       	<cfelse>
	       		<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)#>
			</cfif>
            <cfif db eq "mcjim_p">
            	<cfset netpay =roundno(netpay,'#get_now_month.sud_rnd#','#get_now_month.sud_psu#')>
			</cfif>
	       	<!--- calculate epf a --->
	        <cfset epf_a = val(payin_2nd)>
	        <cfset epf_pay = #val(epfw)# + #val(epfy)# >
	  
	       
	        <!--- Process All Query --->
	        <cfquery name="updatedw" datasource="#db#">
		        UPDATE paytran SET DW = #val(dW)# , 
				BASICPAY = #basicpay#, 
				NPLPAY = #totalNPL#, 
				OT1 = #OT1#, 
				OT2 = #OT2# , OT3 = #OT3# , OT4 = #OT4# , OT5 = #OT5# , OT6 = #OT6# , 
				OTPay = #OTtotal# , TAW = #taw# , grosspay=#grosspay#, EPFWW=#EPFW#, 
				EPFCC=#EPFY#, 
				epf_pay = #epf_pay#, TDED=#tded# , 
				TDEDU = #tded#, NETPAY = #netpay#, 
				epf_pay_a = #epf_a# , cpf_amt="#payin_2nd#"
                <cfif isdefined('additionalwages')>
                ,additionalwages="#val(additionalwages)#"
				</cfif>
                <cfif isdefined('hourrate')>
                ,total_late_h="#val(total_late_h)#"
                ,total_earlyD_h="#val(total_earlyD_h)#"
                ,total_noP_h="#val(total_noP_h)#"
                ,total_work_h="#val(total_work_h)#"
                ,hourrate="#val(hourrate)#"
				</cfif>
				WHERE empno = "#empno#"
	        </cfquery>
	        <!--- 
			<cfquery name="update_tm_hrd" datasource="#db#">
				update pay_tm set HRD_PAY = #val(HRD_PAY)# 
			</cfquery> --->
			
			
	        <!--- Select All From Paytra1 --->
	      <!---   <cfquery name="ps1" datasource="#db#">
	        SELECT * FROM paytra1 WHERE empno = "#empno#" and payyes="Y"
	        </cfquery>
			
			<!--- Select All From Paytran --->
	        <cfquery name="ps" datasource="#db#">
	        SELECT * FROM paytran WHERE empno = "#empno#"
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

	      
			
			<!--- calculate netpay project --->
			
			<cfquery name="paytran_qry" datasource="#db#">
				SELECT netpay,EPFCC, EPFWW,grosspay,tded FROM paytran WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
			
			<cfquery name="prj_rcd_qry" datasource="#db#">
				SELECT project_code,dw_p, entryno FROM proj_rcd 
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfquery name="cal_dw" datasource="#db#">
				SELECT SUM(coalesce(dw_p,0)) as dw_sum FROM proj_rcd 
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfloop query="prj_rcd_qry">
				<cfset project_saly_pay = val(paytran_qry.netpay) * val(prj_rcd_qry.dw_p)/val(cal_dw.dw_sum)>
				<cfset project_saly_pay = numberformat(project_saly_pay,'.__')>
				 
				<cfset PRJ_NET = val(paytran_qry.grosspay) - paytran_qry.tded>
				<cfif get_now_month.CPFWW_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - val(paytran_qry.epfww)>
				</cfif>
				
				
				
				
				<cfif get_now_month.CPFCC_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - val(paytran_qry.epfcc)>
				</cfif>
				 
				<cfset project_cost_pay = val(PRJ_NET)* val(prj_rcd_qry.dw_p)/val(cal_dw.dw_sum)>
				<cfset project_cost_pay = numberformat(project_cost_pay,'.__')>
				
				<!---  <cfset project_saly_pay = val(paytran_qry.netpay) * val(prj_rcd_qry.dw_p)/val(cal_dw.dw_sum)>
				 <cfset project_cost_pay = (val(paytran_qry.netpay) + val(paytran_qry.EPFCC)-val(paytran_qry.EPFWW))* val(prj_rcd_qry.dw_p)/val(cal_dw.dw_sum)> --->
				
				 <cfquery name="update_prj_rcd" datasource="#db#">
					UPDATE proj_rcd 
					SET netpay = #val(project_saly_pay)#,
						jobcosting = #val(project_cost_pay)#
					WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
					and entryno = #prj_rcd_qry.entryno#
				 </cfquery> 
			</cfloop>
			 --->
		
			<cfinvoke component="cfc.project_job_costing" method="cal_project" empno="#empno#" db="#db#" 
				CPFCC_ADD_PRJ ="#get_now_month.CPFCC_ADD_PRJ#" CPFWW_ADD_PRJ ="#get_now_month.CPFWW_ADD_PRJ#"
					qry_tbl_pay="paytran" proj_pay_qry="proj_rcd" compid="#compid#" db_main="#db1#"
						returnvariable="update_proj" />
			
			
	        <cfset myResult = "success">
			<cfreturn myResult>
		</cffunction>
	</cfcomponent>