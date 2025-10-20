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
 <cfset nocal = round(nocal+0.0001)>
 </cfif>
 <cfif typeround eq "D">
 <cfset nocal = int(nocal+0.1)>
 </cfif>
 <cfif typeround eq "U">
 <cfif val(nocal) gt val(int(nocal))>
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
	 		
            <cfquery name="getmoretra" datasource="#db#">
                SELECT group_concat(maw_cou) as listmaw,maw_link FROM mawtab where maw_link > 0 GROUP BY maw_link
            </cfquery>
            <cfloop query="getmoretra">
                <cfquery name="gettotal" datasource="#db#">
                SELECT 0
                <cfloop list="#getmoretra.listmaw#" index="a">
                    + coalesce(MAW#100+a#,0)
                </cfloop>
                as totalaw
                FROM moretra 
                WHERE empno = "#empno#"
            </cfquery>
            
                <cfquery name="updateaw" datasource="#db#">
                UPDATE paytran SET aw#100+getmoretra.maw_link# = "#numberformat(gettotal.totalaw,'.__')#" WHERE empno = "#empno#"
                </cfquery>
            </cfloop>
            
	        <cfquery name="get_now_month" datasource="#db1#">
	        	SELECT * FROM gsetup WHERE comp_id = "#compid#"
	        </cfquery>
            
	        <cfquery name="get_now_month2" datasource="#db1#">
	        	SELECT * FROM gsetup2 WHERE comp_id = "#compid#"
	        </cfquery>
            
	        <cfquery name="select_empdata" datasource="#db#">
	        SELECT * FROM pmast
	        WHERE empno = "#empno#"
	        </cfquery>
            
            <!--- enhanced for manpower auto assign npl after resign [2016/03/28, by Max Tan]   --->
            <cfif get_now_month.autonpl eq "Y" and select_empdata.dcomm neq "">
                <cfset dcomm =  dateformat(createdate(year(select_empdata.dcomm),month(select_empdata.dcomm),day(select_empdata.dcomm)),'YYYY-MM-DD')>
                <cfif get_now_month.Mmonth eq dateformat(dcomm,"m")>        
                    <cfset firstday = createdate(get_now_month.Myear,get_now_month.Mmonth,1)> 
                    <cfset lastday = createdate(get_now_month.Myear,get_now_month.Mmonth,daysinmonth(dcomm))>
                    <cfset npldays = datediff('d',firstday,dcomm)>
                    <cfquery name="updatenpl" datasource="#db#">
                    UPDATE paytran SET 
                    npl = #npldays#
                    WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_empdata.empno#" >
                    </cfquery> 
                </cfif>            
            </cfif>
            <cfif get_now_month.autonpl eq "Y" and select_empdata.dresign neq "">
                <cfset dateresign = dateformat(createdate(year(select_empdata.dresign),month(select_empdata.dresign),day(select_empdata.dresign)),'YYYY-MM-DD')>
                <cfif get_now_month.Mmonth eq dateformat(dateresign,"m")>        
                    <cfset lastday = createdate(get_now_month.Myear,get_now_month.Mmonth,daysinmonth(dateresign))>
                    <cfset npldays = datediff('d',dateresign,lastday)>
                    <cfquery name="updatenpl" datasource="#db#">
                    UPDATE paytran SET 
                    npl = #npldays#
                    WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_empdata.empno#" >
                    </cfquery> 
                </cfif>      
            </cfif>
            <!---   end --->

	        <cfquery name="select_data" datasource="#db#">
	        SELECT * FROM paytran
	        WHERE empno = "#empno#"
	        </cfquery>
            
	        <cfquery name="select_data1" datasource="#db#">
	        SELECT dw,wday FROM paytra1
	        WHERE empno = "#empno#"
	        </cfquery>
	        
            <cfquery name="bonus_qry" datasource="#db#">
                    SELECT basicpay,netpay,empno,fixoesp,epfcc,epfww,ded115 FROM bonus 
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
	                
	       	<cfset Date_OOB = Createdate(get_now_month.MYEAR,get_now_month.MMONTH,1)>
            
           
            
            
	       	<cfset bRate=select_data.BRATE>
            <cfif getauthuser() eq "ultracai">
            <cfif val(select_empdata.inc_amt) neq 0 and select_empdata.inc_date neq "" and select_empdata.brate eq brate>
            <cfif month(select_empdata.inc_date) eq get_now_month.MMONTH and  year(select_empdata.inc_date) eq get_now_month.Myear>
            <cfset brate = brate + val(select_empdata.inc_amt)>
			</cfif>
			</cfif>
            <cfif val(select_empdata.m_inc_amt) neq 0 and select_empdata.m_inc_date neq "" and select_empdata.brate eq brate>
            <cfif month(select_empdata.m_inc_date) eq get_now_month.MMONTH and  year(select_empdata.m_inc_date) eq get_now_month.Myear>
            <cfset daysmonth = daysinmonth(createdate(get_now_month.Myear,get_now_month.MMONTH,1)) >
            <cfset brate = brate + numberformat((select_empdata.m_inc_amt*(daysmonth-dateformat(select_empdata.m_inc_date,'d')+1)/daysmonth), '.__')>
			</cfif>
			</cfif>
            </cfif>
	        <cfset OOB = select_data.OOB>
            
             <cfset fix_brate = find("P", ucase(select_data.FIXOESP))>
             <cfif fix_brate neq 0>
             <cfset select_empdata.brate = bRate>
			 </cfif>
            
	        <cfif OOB gt 0>
		        <cfset days_OOB =DaysInMonth(Date_OOB) >
		        <cfset bRate = (bRate * (days_OOB - OOB)) / days_OOB >
	        </cfif>
<!---             <cfquery name="caiquery" datasource="#db#">
            SELECT * FROM PMAST WHERE #brate# = #brate#
            </cfquery> --->
	        <cfset wDay = select_data.WDAY>
	        <cfif wDay eq 0 Or Wday eq "">
		        <cfif salarypaytype neq "H">
		        <cfset wDay = 26>
		        </cfif>
	        </cfif>
			<cfset paytype = 2 >
	        <cfset dW = select_data.DW>
            <cfset dW1 = select_data1.DW>
            <cfset wDay1 = select_data1.wDay>
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
            <cfset ecl = select_data.ecl>
            <cfset oil = select_data.oil>
            <cfset rs = select_data.rs>
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
            <cfset dcomm = select_empdata.dcomm>
            <cfset dresign = select_empdata.dresign>
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
            <cfset sys_lastday = createdate(get_now_month.Myear,get_now_month.Mmonth,daysinmonth(sys_date))>
	        <cfset epf1hd = select_empdata.epf1hd>
            <cfset bonus = val(bonus_qry.basicpay)>
            <cfset comm = val(comm_qry.basicpay)>
            <cfset total_late_h = 0>
            <cfset total_earlyD_h = 0>
            <cfset total_noP_h = 0>
            <cfset total_work_h = 0>
            <cfset hourrate = 0>
            
            <cfif val(get_now_month.saving) neq 0>
		<cfset savingbf = val(select_empdata.savingbf)>
        <cfquery name="getytdsaving" datasource="#db#">
        SELECT aw#val(get_now_month.saving)+100# as saving FROM pay_ytd
        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
        </cfquery>
        <cfif val(getytdsaving.saving) neq 0>
        <cfset savingbf = savingbf + val(getytdsaving.saving)>
		</cfif>
		</cfif>	
        
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
		     <cfif compccode eq "SG" or compccode eq 'MY' or compccode eq 'ID'>  
		        <cfif comp_Auto_cpf eq "Y">
					
					<cfquery name="con_qry" datasource="#db#">
						SELECT 	entryno, epfcon1, epfcon2, epfcon3, epfcon4, epfcon5, epfcon6, epfcon7, epfcon8, epfcon9, epfcon10,
								epfcon11, epfcon12, epfcon13, epfcon14, epfcon15, epfcon16, epfcon17, epfcon18, epfcon19, epfcon20,
								epfcon21, epfcon22, epfcon23, epfcon24, epfcon25, epfcon26, epfcon27, epfcon28, epfcon29, epfcon30
						FROM rngtable where entryno = "1"
					</cfquery>
					
					<cfset epf_selected = 0>
					<cfloop from="1" to="30" index="i">
<!---                        <!---enhanced for new optional EPF rate, 20160218 by Max Tan--->
                        <cfif compccode eq "MY" and i eq 11>
                            <cfbreak>
                        </cfif>
                        <!---end--->--->
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
                        
                        <cfset newrate = 0>
                        <cfif select_empdata.epftbl2 eq "Y">
                            <cfset newrate = 1>
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
<!---                    <cfif compccode eq 'MY'> <!---enhance for extra % epf submission--->
                    AND epftbl < 5
                    </cfif>--->
		        </cfquery>
                
                <cfif compccode eq 'MY'>
                    <cfquery name="getepftable" datasource="#db#">
                    SELECT epftbl from pmast WHERE empno = '#empno#'
                    </cfquery>
                    <cfset epf_selected = getepftable.epftbl >
                </cfif>
                
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
            SELECT xpaymthpy,xhrpyear,daysperweek FROM ottable
            </cfquery>
            
            <cfif val(evaluate('getottablenew.xhrpyear[#whtbl#]')) neq 0>
            <cfif salarypaytype neq "H" and salarypaytype neq "D">
            <cfset hour_r = (val(select_empdata.brate) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]'))> 
            <cfelse>
            <cfset hour_r = (val(brate) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]'))> 
            </cfif>
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
            <cfif get_now_month.payhourrate eq "Y">
            <cfset total_late_h = numberformat(val(total_late_h),'.__')>
			</cfif>
	        
	        <!--- Early Depart Hours--->
	        <cfset total_earlyD_h = #val(earlyHR)# * hour_r>
            <cfif get_now_month.payhourrate eq "Y">
            <cfset total_earlyD_h = numberformat(val(total_earlyD_h),'.__')>
			</cfif>
	        
	        <!--- No Pay Hours --->
	        <cfset total_noP_h = #val(noPayHR)# * hour_r>
            <cfif get_now_month.payhourrate eq "Y">
            <cfset total_noP_h = numberformat(val(total_noP_h),'.__')>
			</cfif>
	
	        <!--- working day process --->
	     	<cfset dplustemp = #val(pH)# + #val(AL)# + #val(mC)# + #val(mT)# + #val(cC)# + #val(mR)# + #val(cL)# + #val(hL)# + #val(eX)# + #val(pT)# + #val(aD)# + #val(oPL)#+val(ecl)+val(oil) + val(rs)>
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
            <cfset totalNPL = numberformat(totalNPL,'.__')>
	        <!--- Basic Pay Process --->
	      	<cfset basicpay = val(brate) - val(totalNPL)<!--- (#val(payday)# / #val(wDay)# * #val(bRate)#) ---> + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
	        
			
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
			
			<cfif isdate(select_empdata.dcomm)>
				<cfset wrkmonth = datediff('m',select_empdata.dcomm,Date_NDOM)>	
            <cfelse>
            	<cfset wrkmonth = 0>
			</cfif>
            
	        <cfset taw = 0>
	        <cfset aw_count = 1>
	        <cfset wdlist = "DW,PH,AL,MC,MT,CC,MR,CL,HL,OPL,DW2,EX,PT,AD,ECL,OIL" >
			
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
			
			<cfset PAY_TIMES = 2>
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
				            <cfset aw_formula = Replace(aw_formula,"<="," lte ","all") >
				            <cfset aw_formula = Replace(aw_formula,">="," gte ","all") >
				            <cfset aw_formula = Replace(aw_formula,">"," gt ","all") >
				            <cfset aw_formula = Replace(aw_formula,"<"," lt ","all") >
				            <cfset aw_formula = Replace(aw_formula,"="," eq ","all") >
							<cfset aw_formula = Replace(aw_formula,"NDOM","#DaysInMonth(Date_NDOM)#","all")>
<!---                            <cfif GetAuthUser() eq 'ultrauser7'>
                            <cfoutput>
                            #aw_formula#<br>
                            #AW#,#WRKMONTH#,#basicpay#
                            </cfoutput>
                            <cfabort>
                            </cfif> --->

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
			            <cfset aw_formula = Replace(aw_formula,"<="," lte ","all") >
			            <cfset aw_formula = Replace(aw_formula,">="," gte ","all") >
			            <cfset aw_formula = Replace(aw_formula,">"," gt ","all") >
			            <cfset aw_formula = Replace(aw_formula,"<"," lt ","all") >
			            <cfset aw_formula = Replace(aw_formula,"="," eq ","all") >
						<cfset aw_formula = Replace(aw_formula,"NDOM","#DaysInMonth(Date_NDOM)#","all")>
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
                <cfset "#aw_variable#" = #aw_data#>
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
                SELECT xpaymthpy,xhrpyear,XHRPDAY_M,daysperweek FROM ottable
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
              <cfif get_now_month.nplround eq "N">
              <cfset totalNPL = val(dminustemp) * val(npldayrate)>
              <cfelse>   
            <cfset totalNPL = val(dminustemp) * numberformat(val(npldayrate),'.__')>
            </cfif>
            <cfset totalNPL = numberformat(val(totalNPL),'.__')>
	      	<cfset basicpay = val(brate)-val(totalNPL) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
            <cfif basicpay lt 0>
            	<cfset basicpay = 0>
            </cfif>
            </cfif>
            
            <cfif salarypaytype neq "H" and get_now_month.NPLDED eq "Y" >
            <cfquery name="getottablenew" datasource="#db#">
                SELECT xpaymthpy,xhrpyear,XHRPDAY_M,xdaypmth,daysperweek FROM ottable
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
                  <cfelseif get_now_month.bp_dedmnpl eq "WW">
                 <cfset npldayrate = ((val(select_empdata.brate)+val(allowancerate)) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]'))) / (52 * val(evaluate('getottablenew.daysperweek[#whtbl#]'))) >               
                 <cfelseif  get_now_month.bp_dedmnpl eq "NW">
                 <cfquery name="get1paytra1" datasource="#db#">
                 SELECT wday,payyes FROM paytra1 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
                 </cfquery>
                 <cfset npldaycount = val(wDay)>
                 <cfif get1paytra1.payyes eq "Y">
                 <cfset npldaycount = val(npldaycount) + val(get1paytra1.wday)>
				 </cfif>
                 <cfif npldaycount eq 0>
                  <cfset npldayrate = 0 >
                 <cfelse>
                  <cfset npldayrate = (val(select_empdata.brate)+val(allowancerate))/val(npldaycount)  >  
                  </cfif>
                 <cfelse>
                 <cfset npldayrate = (((val(select_empdata.brate)+val(allowancerate)) *  val(evaluate('getottablenew.xpaymthpy[#whtbl#]')))/val(evaluate('getottablenew.xhrpyear[#whtbl#]')))*val(evaluate('getottablenew.XHRPDAY_M[#whtbl#]'))>
                 </cfif>
                 
                 
                  <cfif get_now_month.nplround eq "N">
                <cfset totalNPL = val(dminustemp) * val(npldayrate)>
                <cfelse> 
            <cfset totalNPL = val(dminustemp) * numberformat(val(npldayrate),'.__')>
            </cfif>
			<cfif salarypaytype eq "D">
            <cfset totalNPL = val(dminustemp) * numberformat(val(select_data.BRATE),'.__')>
            </cfif>
            <cfset totalNPL = numberformat(val(totalNPL),'.__')>

	      	<cfset basicpay = val(brate)-val(totalNPL) + #val(total_work_h)# - #val(total_late_h)# - #val(total_noP_h)# - #val(total_earlyD_h)# + #val(piecepay)# + #val(backpay)#>
            <cfif basicpay lt 0>
            	<cfset basicpay = 0>
            </cfif>
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
			            	<cfset ded_formula = Replace(ded_formula,"<="," lte ","all") >
				            <cfset ded_formula = Replace(ded_formula,">="," gte ","all") >
				            <cfset ded_formula = Replace(ded_formula,">"," gt ","all") >
				            <cfset ded_formula = Replace(ded_formula,"<"," lt ","all") >
				            <cfset ded_formula = Replace(ded_formula,"="," eq ","all") >
							<cfset ded_data = #val(evaluate('#ded_formula#'))#>
							<cfset tded = tded + ded_data>
						
						</cfif>
					</cfif>
				<cfelse>
					<cfset ded_data =  val(pay_ded['ded1#numberformat(ded_qry.currentrow,"00")#'][1])>
					<cfset tded = tded + ded_data>
					
				</cfif>
				
				<cfset ded_variable = 'ded1'&#numberformat(ded_qry.currentrow,"00")# >
                 	<cfif left(db,4) eq "beps" or left(db,9) eq "imiqgroup">		
                    <cfif numberformat(ded_qry.currentrow,"0") gte 9>
                    <cfquery name="getdedpaytra1" datasource="#db#">
                    SELECT #ded_variable# as paytra1dedamt FROM paytra1 WHERE empno = "#empno#" and payyes = "Y"
                    </cfquery>
                    <cfif val(getdedpaytra1.paytra1dedamt) neq 0 and val(ded_data) neq 0>
                    <cfset ded_data = ded_data - val(getdedpaytra1.paytra1dedamt)>
					</cfif>
                    </cfif>
                    <!--- <cfelseif db eq "beps_p" and val(npl) neq 0>	
                    <cfset ded_data = 0>	 --->
                    </cfif>
                    
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
			        <cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
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
                    <cfif get_now_month.otrbr eq "Y">
                    <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) )),'.__') * ratio_list[i] >
                    </cfif>
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >                    
					 <cfif get_now_month.otrbr eq "Y">
                     <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) / workingd) / workingh )),'.__') * ratio_list[i] > 
                     </cfif>
					</cfif>
                   
                    
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
                    <cfif get_now_month.otrbr eq "Y">
                    <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) )),'.__') * ratio_list[i] >
                    </cfif>
					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >   
                     <cfif get_now_month.otrbr eq "Y">
                     <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) / workingd) / workingh )),'.__') * ratio_list[i] > 
                     </cfif>
                    
                                     </cfif>
                    
				    <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			       
			        </cfif>
		        
		        </cfloop>     
		         
	        <cfelse>
	        
		        <cfloop from="1" to="6" index="i">
					
				<cfset workingh = #evaluate('ot_table.xhrpday_h[#whtbl#]')# >
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
                      <cfif get_now_month.otrbr eq "Y">
                    <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) )),'.__') * ratio_list[i] >
                    </cfif>

					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >
                    <cfif get_now_month.otrbr eq "Y">
                     <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) / workingd) / workingh )),'.__') * ratio_list[i] > 
                     </cfif>                    </cfif>
                    
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
                      <cfif get_now_month.otrbr eq "Y">
                    <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) * val(monthspy)) / val(hourspy) * val(hourspd) )),'.__') * ratio_list[i] >
                    </cfif>


					<cfelse>
					<cfset OT_RATE_CALCULATE = (((OT_VALUE+awarray[i]) / workingd) / workingh ) * ratio_list[i] >    
                    <!--- <cfquery name="testqry" datasource="#db#">
            SELECT empno FROM pmast where "#workingd#" = "#workingd#" and "#workingh#" = "#workingh#" limit 1
            </cfquery>	 --->
            
                    <cfif get_now_month.otrbr eq "Y">
                     <cfset OT_RATE_CALCULATE = numberformat(val((((OT_VALUE+awarray[i]) / workingd) / workingh )),'.__') * ratio_list[i] > 
                     </cfif>                </cfif>
                    
				        <cfset ArrayAppend(OT_RATE_LIST, "#OT_RATE_CALCULATE#")>
			        </cfif>
			             
		        </cfloop>
	        
			</cfif>
	    
	        <cfset rddec = ArrayNew(1) >
            
            <cfloop from="1" to="6" index="r">
				<cfif ot_table.ot_rtdec[r] eq 2>
                    <cfset rddec[r] = ".__">
                <cfelseif ot_table.ot_rtdec[r] eq 3>
                    <cfset rddec[r] = ".___">
                <cfelseif ot_table.ot_rtdec[r] eq 4>
                    <cfset rddec[r] = ".____">
                </cfif>
            </cfloop>

	        <cfquery name="update_rate" datasource="#db#">
	        UPDATE paytran SET 
			<cfif get_now_month.otrater eq "N">
                RATE1 = #val(OT_RATE_LIST[1])#,
                RATE2 = #val(OT_RATE_LIST[2])#,
                RATE3 = #val(OT_RATE_LIST[3])#,
                RATE4 = #val(OT_RATE_LIST[4])#,
                RATE5 = #val(OT_RATE_LIST[5])#,
                RATE6 = #val(OT_RATE_LIST[6])#
            <cfelse>
                RATE1 = #numberformat(OT_RATE_LIST[1],'#rddec[1]#')#,
                RATE2 = #numberformat(OT_RATE_LIST[2],'#rddec[2]#')#,
                RATE3 = #numberformat(OT_RATE_LIST[3],'#rddec[3]#')#,
                RATE4 = #numberformat(OT_RATE_LIST[4],'#rddec[4]#')#,
                RATE5 = #numberformat(OT_RATE_LIST[5],'#rddec[5]#')#,
                RATE6 = #numberformat(OT_RATE_LIST[6],'#rddec[6]#')#
            </cfif>
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

				
				<cfif DED gt 0 and new_ded_formula neq "" and ggrosspay gt 0 and ded_type eq "F">
	        		<cfif use_ded_formula neq 0 >
						
			            <cfset result = Replace(new_ded_formula,"<="," lte ","all") >
			            <cfset result = Replace(result,">="," gte ","all") >
			            <cfset result = Replace(result,">"," gt ","all") >
			            <cfset result = Replace(result,"<"," lt ","all") >
			            <cfset result = Replace(result,"="," eq ","all") >
			            
				        <cfset new_value = #evaluate(result)#>
				        <cfset new_value = #numberformat(new_value,'.__')# >
				        
		        	<cfelse>
		        		<cfset new_value = DED>
		        	</cfif>
		           	<cfif left(db,4) eq "beps"  or left(db,9) eq "imiqgroup" <!--- and val(npl) eq 0 --->>		
                    <cfif i gte 9>
                    <cfquery name="getdedpaytra1" datasource="#db#">
                    SELECT #dedvar_update# as paytra1dedamt FROM paytra1 WHERE empno = "#empno#" and payyes = "Y"
                    </cfquery>
                    <cfif val(getdedpaytra1.paytra1dedamt) neq 0 and val(new_value) neq 0>
                    <cfset new_value = new_value - val(getdedpaytra1.paytra1dedamt)>
					</cfif>
                    </cfif>
                    <!--- <cfelseif db eq "beps_p" and val(npl) neq 0>	
                    <cfset new_value = 0> --->
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
		     	
		     	<cfif select_ded_formula.ded_hrd gt 0>
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
                <cfset nspay = numberformat(nspay,'.__')>
                </cfif>
                </cfif>
                
		        <cfif aw2_qry.abcdrepf eq "Y">
					<cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# >
		        <cfelseif pay_to eq "Y">
		        	<cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf#>
		        <cfelse>
		        	<cfset PAYIN = #val(basicpay)# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# + val(nspay) >
				</cfif> 
		
				<cfset payin_2nd = val(PAYIN)>
                <cfset epf_a = val(PAYIN)>
				<cfquery name="paytra1_qry" datasource="#db#">
					SELECT cpf_amt,EPFWW,additionalwages, EPFCC from paytra1 
					where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> <!---   and "#val(payin)#" = "#val(payin)#" --->
				</cfquery>
                <cfset oldadditionalwages =  additionalwages>
              	 <cfif val(paytra1_qry.additionalwages) neq 0>
                <cfset additionalwages = additionalwages + val(paytra1_qry.additionalwages)>
				</cfif>
                
				<cfif aw2_qry.abcdrepf eq "Y" or pay_to eq "Y">
                <cfelse>
				<cfset PAYIN = val(PAYIN) + val(paytra1_qry.cpf_amt)>
                </cfif>
<!---                 		<cfquery name="caiquery" datasource="#db#">
            SELECT * FROM PMAST WHERE "#PAYIN#" = "#PAYIN#" and "#val(paytra1_qry.cpf_amt)#" = "#val(paytra1_qry.cpf_amt)#"
            </cfquery> --->
            	<cfif get_now_month.balancecpf eq "paytran">
                <cfset choosepayin = val(PAYIN) + val(bonus_qry.basicpay) + val(comm_qry.basicpay)>
                <cfelse>
                <cfset choosepayin = val(PAYIN)>
                </cfif>
				
		        <cfquery name="get_epf_fml" datasource="#db#">
		        	SELECT entryno FROM rngtable WHERE EPFPAYF <= #choosepayin# AND EPFPAYT >= #choosepayin#
		        </cfquery>
		        
		        <cfset epf_entryno = get_epf_fml.entryno>    
		        <cfquery name="get_epf" datasource="#db#">
		        	SELECT * FROM rngtable WHERE entryno = "#epf_entryno#"
		        </cfquery>
		        
		        <cfquery name="get_epf1" datasource="#db#">
		        	SELECT cpf_ceili,tcpf_ceili FROM rngtable where entryno="1"
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
                <cfset payin_2nd = PAYIN>
                </cfif>
                
				<cfset oldpayin1 = PAYIN>
                <cfif get_now_month.balancecpf eq "paytran">
                <cfset PAYIN = PAYIN + val(bonus_qry.basicpay) + val(comm_qry.basicpay)>
                <cfelse>
                <cfset PAYIN = PAYIN >
                </cfif>
                <cfif oldpayin gt #get_epf1.cpf_ceili# and val(additionalwages) neq 0>
                <cfset PAYIN = PAYIN + val(additionalwages)>
                <cfset payin_2nd = payin_2nd + val(additionalwages)>
               <!---  <cfset epf_a = val(epf_a) + val(additionalwages)> --->
				</cfif>
                
               
               	<cfif val(get_epf1.tcpf_ceili) neq 0>
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
                    
                    <cfif get_now_month.mmonth eq 1>
                    <cfset yearlypay = val(getyearbrate.brate) * 12>
                    <cfelse>
                    <cfquery name="getprevmonth" datasource="#db#">
                    SELECT coalesce(epf_pay_a,0)-coalesce(additionalwages,0) as basiclast FROM pay_12m WHERE tmonth < "#get_now_month.mmonth#"
                    and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                    </cfquery>
                    
                    <cfquery name="getmonth1" datasource="#db#">
                    SELECT coalesce(epf_pay_a,0)-coalesce(additionalwages,0) as basiclast FROM pay_12m WHERE tmonth = "#val(get_now_month.mmonth)-1#"
                    and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                    </cfquery>
                    
                    <cfset yearlypay = 0>
                    <cfloop query="getprevmonth">
                    <cfif val(getprevmonth.basiclast) gt val(get_epf1.cpf_ceili)>
                    <cfset yearlypay = yearlypay + val(get_epf1.cpf_ceili)>
                    <cfelse>
                    <cfset yearlypay = yearlypay + val(getprevmonth.basiclast)>
					</cfif>
                    </cfloop>
                    
                    <cfset currentmonthpay = val(getmonth1.basiclast)>
                    <cfif currentmonthpay  gt val(get_epf1.cpf_ceili)>
                    <cfset currentmonthpay = val(get_epf1.cpf_ceili)>
					</cfif>
                    
					<!---CPF ceiling months updated by Max Tan, 02-11-15--->
                   <cfif get_now_month2.cpfceilmonth eq "1" and compccode eq "SG">
                       <cfset yearlypay = yearlypay + (val(currentmonthpay)*(12))>
                   <cfelseif get_now_month2.cpfceilmonth eq "0" or compccode neq "SG">
                       <cfset yearlypay = yearlypay + (val(currentmonthpay)*(12-(val(get_now_month.mmonth)-1)))>
                   </cfif>
                    <!---end CPF ceiling months--->

                    </cfif>
                    
                   <!---  <cfquery name="getpayindetail" datasource="#db#">
                select * from paytran where "#gettotalepf.totaladdaw#" = "#gettotalepf.totalepf#"
                </cfquery> --->
                    
                    <cfif val(yearlypay) gt (val(get_epf1.cpf_ceili)*12)>
                    <cfset yearlypay = (val(get_epf1.cpf_ceili)*12)>
                    </cfif> 
                    <cfset addallow = val(get_epf1.tcpf_ceili) - val(yearlypay)>
      				
                    <cfif val(addallow) - (val(gettotalepf.totalepf) + val(gettotalepf.totaladdaw)) lte 0>
                    	<cfset payin = oldpayin1>
                        <cfset originalaw = additionalwages>
                        <cfset additionalwages = 0>
                    <cfelse>
                    	<cfset leftover = val(addallow) - (val(gettotalepf.totalepf) + val(gettotalepf.totaladdaw))>
                        <cfif val(payin)-val(oldpayin1) gt val(leftover)>
                        <cfset payin = val(oldpayin1) + val(leftover)>
                        <!--- <cfset originalaw = additionalwages> 
                        <cfset additionalwages = val(leftover)>--->
                        <cfif val(bonus_qry.basicpay) eq 0 and  val(comm_qry.basicpay) eq 0>
                        <cfset additionalwages = val(leftover)>
						</cfif>
						</cfif>
                        
					</cfif>
                    
                   
                   <!---  <cfif val(get_epf1.tcpf_ceili)-val(gettotalepf.totalepf) lte 0>
                    	<cfset payin = 0>
                    <cfelse>
						<cfset leftover = val(get_epf1.tcpf_ceili)-val(gettotalepf.totalepf)>
                        <cfif val(payin) gt val(leftover)>
                        <cfset payin = val(leftover)>
                        </cfif>
                    </cfif> --->
				</cfif>
                
                
               
                
		        <cfset epf_yee = #get_epf['epfyee#epf_selected#'][1]#>
		        <cfset epf_yer = #get_epf['epfyer#epf_selected#'][1]#>
                
                <cfset payin = numberformat(payin,'0.00')>

                <!---   enhance for manpower customised EPF rate [17/03/2016, by Max Tan--->
                <cfif val(select_empdata.epf_fyee) gt 0 and compccode eq "MY">
                    <cfset percentyee = select_empdata.epf_fyee / 100>
                    <cfif payin lte 5000> 
                        <cfset epf_yee = CEILING(((ROUND((CEILING(PAYIN/10))/2))*20)*percentyee)>
                    <cfelseif payin lte 20000> 
                        <cfset epf_yee = CEILING(((CEILING(PAYIN/100))*100)*percentyee)>
                    <cfelseif payin gt 20000>
                        <cfset epf_yee = CEILING(PAYIN*percentyee)>
                    </cfif>
                </cfif>

                <cfif val(select_empdata.epf_fyer) gt 0 and compccode eq "MY">
                    <cfset percentyer = select_empdata.epf_fyer / 100>
                    <cfif payin lte 5000> 
                        <cfset epf_yer = CEILING(((ROUND((CEILING(PAYIN/10))/2))*20)*percentyer)>
                    <cfelseif payin lte 20000> 
                        <cfset epf_yer = CEILING(((CEILING(PAYIN/100))*100)*percentyer)>
                    <cfelseif payin gt 20000>
                        <cfset epf_yer = CEILING(PAYIN*percentyer)>
                    </cfif>
                </cfif>
                <!---   end --->

 
		        <cfset EPFW = #val(evaluate(#epf_yee#))#>
<!---  <cfquery name="getpayindetail" datasource="#db#">
                select * from paytran where "#EPFW#" = "#EPFW#"
                </cfquery> --->
		        <cfset result= #Replace(epf_yer,"ROUND","NumberFormat")#>
		        <cfset EPFY = #val(evaluate(#result#))#>
		     <!---  <cfquery name="getpayindetail" datasource="#db#">
                select * from paytran where "#payin_2nd#" = "#payin_2nd#"
                </cfquery> --->
		      <!---   cpf amount not round --->
		        
		         
                 
                 
                <!---new rounding for Shi Cai's SG companies, 07/09/2015 by Max Tan---> 
                <cfif compccode eq 'SG'>
			        <cfset result1= #ReplaceNoCase(Replacenocase(epf_yee,"INT"," ", "all"),"PAYIN","(PAYIN+0.0001)", "all")#>
                <cfelse>
			        <cfset result1= #REReplace(epf_yee,"INT"," ", "all")#>
				</cfif>
                <!---end--->
                
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
                 
                 <cfif get_now_month.balancecpf eq "paytran" and (val(bonus_qry.epfww) neq 0 or val(bonus_qry.epfcc) neq 0)>
                <cfset EPFW = EPFW - val(bonus_qry.epfww)>
                <cfset EPFY = EPFY - (val(bonus_qry.EPFCC)+val(bonus_qry.EPFWW)-val(bonus_qry.EPFWW))>
                <cfset EPFW_nt_round = EPFW_nt_round - (val(bonus_qry.epfww))>
                <cfset epf_yer_nt_round = epf_yer_nt_round - (val(bonus_qry.EPFCC)+val(bonus_qry.EPFWW)-val(bonus_qry.EPFWW))>
<!---                  
				<cfelseif get_now_month.balanceepf neq "1">				 
                <cfset EPFW = EPFW * val(oldpayin1) / val(PAYIN)>
                <cfset EPFY = EPFY * val(oldpayin1) / val(PAYIN)>
                <cfset EPFW_nt_round = EPFW_nt_round * val(oldpayin1) / val(PAYIN)>
                <cfset epf_yer_nt_round = epf_yer_nt_round * val(oldpayin1) / val(PAYIN)> --->
                </cfif>
		         
                 
<!--- 				 <cfif val(additionalwages) neq 0 and oldpayin gt #get_epf1.cpf_ceili# and get_now_month.balanceepf neq "1">
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
				  </cfif> --->
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
                    <cfset pay_to = select_empdata.epfbrinsbp>
					<cfset nspay = 0>
                    <cfif val(ns) neq 0>
                    <cfif val(wDay) neq 0>
                    <cfset nspay = val(ns)/ val(wDay) * brate >
                    <cfset nspay = numberformat(nspay,'.__')>
                    </cfif>
                    </cfif>
                    
                    <cfif aw2_qry.abcdrepf eq "Y">
                        <cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# >
                    <cfelseif pay_to eq "Y">
                        <cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf#>
                    <cfelse>
                        <cfset PAYIN = #val(basicpay)# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# + val(nspay) >
                    </cfif> 
                	<cfset epf_a = PAYIN>
                    <cfquery name="get1sthalf" datasource="#db#">
                    SELECT epfww,epfcc FROM paytra1 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                    </cfquery>
		        	<cfquery name="update_round_cpf_pay_tm" datasource="#db#">
					UPDATE pay_tm 
					SET p_epfww = #val(EPFW)+val(get1sthalf.epfww)#,
						p_epfcc = #val(EPFY)+val(get1sthalf.epfcc)#
					WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
		    		
				<cfif get_now_month.comp_id neq "zoenissi">
					
					<cfset payin_2nd = 0>
                    <!--- <cfset additionalwages= 0> --->
					
				<cfelse>
					
					<cfset pay_to = select_empdata.epfbrinsbp>
					<cfset nspay = 0>
					<cfif val(ns) neq 0>
               		 <cfif val(wDay) neq 0>
              			  <cfset nspay = val(ns)/ val(wDay) * brate >
                          <cfset nspay = numberformat(nspay,'.__')>
             	  	 </cfif>
              	 	</cfif>
					 <cfif aw2_qry.abcdrepf eq "Y">
						<cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# >
		       		 <cfelseif pay_to eq "Y">
		        		<cfset PAYIN = #brate# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf#>
		       		 <cfelse>
		        		<cfset PAYIN = #val(basicpay)# <!--- + #val(dirfee)# ---> + #additional_CPF# - #ded_cpf# + val(nspay) >
					</cfif> 
					 <cfset payin_2nd = val(PAYIN)>
					 <cfset epf_a = val(PAYIN)>
				</cfif>	
				
		    <cfelse>

			        <cfset EPFY = 0>
			        <cfset EPFW = 0>
			        <cfset payin_2nd = 0>
                    <cfset additionalwages= 0>
                    <cfset epf_a = 0>
                    <cfquery name="update_round_cpf_pay_tm" datasource="#db#">
					UPDATE pay_tm 
					SET p_epfww = 0,
						p_epfcc = 0
					WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
	        </cfif>
	        <cfif isdefined('oldadditionalwages')>
	        <cfset additionalwages = oldadditionalwages>
            </cfif>
            
<!---            <cfif GetAuthUser() eq 'ultramax'>
<cfoutput>
#EPFW#,#EPFY# ,#payin#,#epf_selected#
</cfoutput>
<cfabort>
</cfif> --->
            
            <!---28-08-2015 by Max Tan--->
			<!---calculate jkk jkm after jht for indo --->
	        <cfif compccode eq 'ID' and epfno neq "" and epfcat neq "X">
            <cfquery name="getbpjs" datasource="#db#">
            	SELECT * FROM 
                ((SELECT jkm from rngtable where entryno = 1) as a
                JOIN
                (SELECT jkk from rngtable where entryno = #select_empdata.jkktbl#) b)
            </cfquery>
			<cfset jkkrate = val(getbpjs.jkk)>
			<cfset jkmrate = val(getbpjs.jkm)>

			<cfquery name="updatebpjs" datasource="#db#">
            	UPDATE comm set jkk = "#round(jkkrate*payin)#", jkm = "#round(jkmrate*payin)#"
                WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
            </cfquery>
            </cfif>
            
            <!---end of jkk jkm--->
            
	        <cfif compccode eq "MY">
            
            <cfset fix_ss = find("S", ucase(select_data.FIXOESP))>
            
            <cfif fix_ss gte 1>
            
                <cfquery name="getssfixed" datasource="#db#">
                SELECT socsoww,socsocc FROM paytran WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
                </cfquery>
                
            	<cfset socso_yee = getssfixed.socsoww>
	        	<cfset socso_yer = getssfixed.socsocc>
                
            <cfelse>
            	<cfset socso_rate = val(basicpay) + val(add_hrd_ot) + val(add_hrd)- val(dedt_hrd)>	       
		       	<cfinvoke component="cfc.socsoprocess" method="calsocso" empno="#empno#" db="#db#" returnvariable="socso_array" payrate="#socso_rate#"/>
	        	<cfset socso_yee = socso_array[1]>
	        	<cfset socso_yer = socso_array[2]>
                       
            </cfif>
         		
            <cfquery name="update_socso_qry" datasource="#db#">
                UPDATE paytran 
                set socsoww = #val(socso_yee)# ,
                    socsocc = #val(socso_yer)# 
                where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
            </cfquery>

            <!---PCB Calculation--->
            
            <cfquery name="getdeduc" datasource="#db#">
            SELECT ded101, ded102, ded103, ded104, ded105, ded106, ded107, ded108, ded109, ded110, ded111, ded112, ded113, ded114,AW101, AW102, AW103, AW104, AW105, AW106, AW107, AW108, AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117 FROM paytran
            WHERE empno = "#empno#"
            </cfquery>
            
            <cfquery name="pcbfields" datasource="#db#">
            SELECT * FROM pcbtable
            </cfquery>
            
            <cfquery name="checkbonus" datasource="#db#">
                SELECT bonus,b_epfww,ded115 from pay_tm where empno="#empno#"
            </cfquery> 
               
            <cfset deduc = val(tded)>
            
<!---            <cfif select_empdata.itaxno neq "" and select_empdata.itaxcat neq "X">--->
            <cfif select_empdata.itaxcat neq "X">
            <cfif findnocase('T',select_data.fixoesp) gt 0>
                <cfset currentpcb = select_data.ded115>
                <cfset pcbgrosspay = grosspay>
            <cfelse>


		   	   <!---PCB Deduction--->
				<cfset M = 0>
				<cfset Mb = 0>
                <cfset R = 0>
                <cfset Rb = 0>
                <cfset B = 0>
                <cfset Bb = 0>
                <cfset cate = 0>
                <cfset net = 0>
                <cfset netb = 0>
                <cfset tzakat = 0>
                <cfset currentpcb = 0>
                <cfset pded = 0>
  		
        		<!--- if employee disable --->
                <cfif select_empdata.disble eq "Y">
					<cfset pded += val(pcbfields.disab)> 	<!---6000--->
                </cfif>
        		<!--- if spouse disable --->
                <cfif select_empdata.sdisble eq "Y">
					<cfset pded += val(pcbfields.sdisab)>	<!---3500--->
                </cfif>
                
                <!---check deductable allowances for pcb--->
                <cfquery name="awqry" datasource="#db#">
                    SELECT aw_cou,aw_tax FROM awtable
                    where aw_cou < 18 and aw_tax = 0
				</cfquery>
                
                <cfquery name="getawceil" datasource="#db#">
                    SELECT aw_cou,aw_ceil FROM awtable
                    where aw_cou < 18 and aw_ceil > 0 and aw_tax = 1
				</cfquery>
                
                <cfquery name="getytd" datasource="#db#">
                    SELECT itaxpcb,epfww,ded115,
                    AW101, AW102, AW103, AW104, AW105, AW106, AW107, AW108, AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117 
                    FROM pay_ytd WHERE empno="#empno#"
                </cfquery>
                
                <cfset sumoverceil = 0>
                <cfloop query="getawceil">
                    <cfset ytdaw = evaluate("val(getytd.AW#(100 + getawceil.aw_cou)#)")>
                    <cfset mtdaw = evaluate("val(getdeduc.AW#(100 + getawceil.aw_cou)#)")>
                    <cfset sumaw = ytdaw + mtdaw>
    
                    <cfif sumaw gt getawceil.aw_ceil>
                        <cfif ytdaw lt getawceil.aw_ceil>
                            <cfif mtdaw gt val(getawceil.aw_ceil) - val(ytdaw)>
                                <cfset sumoverceil += val(getawceil.aw_ceil) - val(ytdaw)>                            
                            </cfif>
                        </cfif>
                    <cfelse>
                        <cfset sumoverceil += val(mtdaw)>
                    </cfif>            
                </cfloop>
                
                <cfset pcbgrosspay = grosspay>
            
            <cfloop query="awqry">
	           	<cfset pcbgrosspay = evaluate("#pcbgrosspay# - val(getdeduc.AW#(100 + awqry.aw_cou)#)")>
			</cfloop>
            
          	<cfset pcbgrosspay = numberformat(pcbgrosspay-val(sumoverceil),'.__')>
                              
 					<!--- enhance to variable type, 01/12/2015 by Max Tan --->
                    <cfset pded += val(select_empdata.child_edu_m) * val(pcbfields.childstdy)>		<!--- 1000, if kid study after 18 --->
                    <cfset pded += val(select_empdata.child_edu_f)  * val(pcbfields.childhedu)> 	<!--- 6000, if kid study diploma++ --->
                    <cfset pded += val(select_empdata.child_disable) * val(pcbfields.cdisab)> 	<!--- 6000, if kid disable --->
                    <cfset pded += val(select_empdata.child_edu_disable) * val(pcbfields.cdisabstdy)> <!---12000, if kid study + disable --->
                    <cfset pded += val(select_empdata.num_child)  * val(pcbfields.child18)> 	<!---1000,kid below 18yrs old--->
                    
			<cfif select_empdata.mstatus eq "S"> 			<!--- single --->
                    <cfset cate = "1">
                    <cfset pded += val(pcbfields.cate1)> 	<!---9000>		--->
  
			<cfelseif select_empdata.mstatus eq "M">		<!--- married --->
				<cfif select_empdata.sname neq "" > 		<!--- spouse not working --->
                    <cfset cate = "2">
                    <cfset pded += val(pcbfields.cate2)>	<!---3000+9000> spouse not working deduction + personal deduction--->                    
                <cfelseif select_empdata.sname eq "" > 		<!--- spouse working--->
                    <cfset cate = "3">
                    <cfset pded += val(pcbfields.cate3)>	<!--- 9000>    --->
                </cfif>

			<cfelseif select_empdata.mstatus eq "O"> 		<!--- other,divorced, widow --->
            		<cfset cate = "3">
            		<cfset pded += val(pcbfields.cate3)>	<!--- 9000>    --->
			</cfif>
      		
            <cfset capepf = val(pcbfields.epfcap)>
            <cfset epfnow = epfw>
            
            <cfset pregrosspay = getytd.itaxpcb>
            <cfset preepfww = getytd.epfww>
            
            <cfif val(getytd.epfww) gt capepf>
				<cfset preepfww = capepf>            
            <cfelse>
                <cfset preepfww = getytd.epfww>
            </cfif>
            
            <cfset preded115 = getytd.ded115>
                
<!---             <cfelse>
            <!--- get previous pcb data from pmast if dcomm not before this year--->
 				<cfset pregrosspay = select_empdata.pregrosspay>
                <cfif val(select_empdata.preepfww) gt 6000>
    				<cfset preepfww = 6000>            
                <cfelse>
					<cfset preepfww = select_empdata.preepfww>
                </cfif>
                <cfset preitaxpcb = select_empdata.preitaxpcb> 
            </cfif> --->
            
            
            <!--- epf cap 6000 and average of remaing months --->
            <cfset divby = 12 - val(get_now_month.mmonth)>
            <cfif divby lte 0>
				<cfset divby = 1>
            </cfif>
            <cfset avgepf = int((capepf-val(epfw)-val(preepfww))/(divby)*100)/100>
			<cfif avgepf gt epfw>
            	<cfset avgepf = epfw>
            </cfif>
            <cfif avgepf lt 0>
            	<cfset avgepf = 0>
            </cfif>
<!---             <cfoutput>
       #avgepf#, #epfw#  aaa    </cfoutput> --->
            <cfif val(preepfww) gte capepf>
            	<cfset epfnow = 0>
            <cfelseif val(preepfww) + val(epfnow) gte capepf>
            	<cfset epfnow = capepf - preepfww>
            </cfif>
            <!--- calculate net formula p --->
            <cfset net = ((val(pregrosspay)-val(preepfww))+(val(pcbgrosspay)-val(epfnow))+ 
			(val(pcbgrosspay)-avgepf)*(12-val(get_now_month.mmonth))-pded)>
              
                <!--- Deductions/PCB Calculation Table (Refer Schedule 1 of PCB Document 2014) --->
				<!--- START TABLE --->
                <!--- enhance to variable table, 01/12/2015 by Max Tan--->
                
				<cfloop query="pcbfields">
                	<cfif net gte pcbfields.pfrom and net lte pcbfields.pto>
                    	<cfset M = pcbfields.mamount>
                        <cfset R = pcbfields.ramount/100>
                    	<cfloop from="1" to="3" index="j">
                        	<cfif cate eq j>
                            	<cfset B = evaluate("pcbfields.category#j#")>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    </cfif>
                </cfloop>

			<cfset currentpcb =  int((((net-m)*r+b-tzakat-val(preded115))
				/(12-val(get_now_month.mmonth)+1)*100))/100>
                
            <!--- pcb rebate less than rm10 --->
			<cfif currentpcb lt 10>
				<cfset currentpcb = 0>
            </cfif>
            
            <cfset temppcb = currentpcb>
            
            <!---   check bonus --->   
            <cfset pbonus = 0>
            <cfif val(checkbonus.bonus) gt 0 >
            	<cfset pbonus = val(checkbonus.bonus)>
                <cfset pbonusepf = val(checkbonus.b_epfww)>
            
				<!--- epf cap 6000 and average of remaing months --->
                <cfset bavgepf = int((capepf-val(pbonusepf)-val(epfnow)-val(preepfww))/(divby)*100)/100>
    
                <cfif bavgepf gt val(epfnow)>
                    <cfset bavgepf = val(epfnow)>
                </cfif>
                <cfif bavgepf lt 0>
                    <cfset bavgepf = 0>
                </cfif>
                
                <cfif val(preepfww) + val(epfnow) gte capepf>
                    <cfset pbonusepf = 0>
                <cfelseif val(preepfww) + val(epfnow) + val(pbonusepf) gte capepf>
                    <cfset pbonusepf = capepf - val(preepfww) - val(epfnow)>
                </cfif>
                 
                <cfset NETb = val(pregrosspay)-val(preepfww)+val(pcbgrosspay)-val(epfnow)+ 
                ((val(pcbgrosspay)-bavgepf)*(12-val(get_now_month.mmonth)))+val(pbonus)-val(pbonusepf)-pded>
            
				<!--- START TABLE --->
                <!--- enhance to variable table, 01/12/2015 by Max Tan--->
				<cfloop query="pcbfields">
                	<cfif NETb gte pcbfields.pfrom and NETb lte pcbfields.pto>
                    	<cfset Mb = pcbfields.mamount>
                        <cfset Rb = pcbfields.ramount/100>
                    	<cfloop from="1" to="3" index="j">
                        	<cfif cate eq j>
                            	<cfset Bb = evaluate("pcbfields.category#j#")>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    </cfif>
                </cfloop>
                

				<cfset pcbbonus =  numberformat((NETb-Mb)*Rb+Bb,'.__')>
    
                <cfset currentpcb12 = numberformat(val(preded115) + val(currentpcb)*(val(12-val(get_now_month.mmonth))+1),'.__')>
                         
<!---      <cfoutput>
#currentpcb#, #net#, #pcbbonus#, #currentpcb12#, #int((pcbbonus - currentpcb12 + currentpcb)*100)/100#, #bavgepf#
<cfabort>   
</cfoutput> --->      
            	<cfset currentpcb = int((pcbbonus - currentpcb12 + currentpcb)*100)/100>
            </cfif>            
            
            <!--- round final result --->
                        
			<cfset currentpcb = ceiling(currentpcb*20)/20> 
                    
            <!--- pcb rebate less than rm10 --->
			<cfif currentpcb lt 10>
				<cfset currentpcb = 0>
            </cfif>
   
<!--- pcb result, enter employee no to compare PCB with ecalculator: http://calcpcb.hasil.gov.my/index.php?&lang=may, 01/12/2015 by Max Tan--->  


<!---<cfif GetAuthUser() eq 'ultramax'>
   <!---<cfif empno eq '001'> --->
    <cfoutput>
    currentpcb = #currentpcb#  <br>
    pcbgrosspay = #pcbgrosspay# <br>
    grosspay = #grosspay# <br>
    <br>
    
    P = #pregrosspay# - #preepfww#  + #pcbgrosspay# - #epfnow# + (#pcbgrosspay# - #avgepf#) * #(12-val(get_now_month.mmonth))# - #pded#<br>
    PCB = #net# - #m# * #r# +#B# - #tzakat# - #preded115# / #(12-val(get_now_month.mmonth)+1)#<br>
    currentpcb = #temppcb#<br>
    cate=#cate# <br><br>
    <cfdump var="#getytd#"><br>
    m:#m#<br>
    r:#r#<br>
    b:#b#<br>
    
    <cfif isdefined("bavgepf")>
    Bonus p = #pregrosspay# - #preepfww#  + #pcbgrosspay# - #epfnow# + (#pcbgrosspay# - #bavgepf#)* #(12-val(get_now_month.mmonth))# - #pbonus# -#pbonusepf#  - #pded# <br>
    
    ((NETb-Mb)*Rb+Bb-tzakat-val(getytd.ded115))/(12-val(get_now_month.mmonth)+1 <br><br>
    net = ((val(pregrosspay)-val(preepfww))+(val(pcbgrosspay)-val(epfnow))+ 
                (val(pcbgrosspay)-avgepf)*(12-val(get_now_month.mmonth))-pded)<br>
    PCB bonus = #NETb#-#Mb#*#Rb#+#Bb#<br>
    
    SUM PCB =(#pcbbonus# - #currentpcb12# + #temppcb#)*100)/100
    
       </cfif>                  
    <cfabort>
    </cfoutput> 
<!--- </cfif> --->
</cfif>
--->
            </cfif>

            <cfset expatded = 0>
            <!---   enhance for manpower expatriate tax [18/3/16, by Max Tan]  --->
            <cfif select_empdata.expattbl neq "" and select_empdata.expatdate neq "" and select_empdata.expatdate neq ''>
                <cfset currentpcb = 0>
                <cfset expatgross = val(pcbgrosspay) + val(pbonus)>
                <cfif select_empdata.expattbl eq 3>
                    <cfset expatperc = 0.10>
                <cfelseif select_empdata.expattbl eq 2>
                    <cfset expatperc = 0.15>
                <cfelse>
                    <cfset expatperc = 0.28>
                </cfif>
                <cfif isdate(dcomm) and get_now_month.mmonth eq dateformat(dcomm,'m')>
                    <cfset expatdays = datediff('d',dcomm,sys_lastday)+1>
                    <cfset expatded = numberformat(expatgross*expatperc*expatdays/daysinmonth(sys_date),'.__')>
                <cfelseif isdate(select_empdata.expatdate) and get_now_month.mmonth eq dateformat(select_empdata.expatdate,'m')>
                    <cfset expatdays = datediff('d',sys_date,select_empdata.expatdate)+1>
                    <cfset expatded = numberformat(expatgross*expatperc*expatdays/daysinmonth(sys_date),'.__')>
                    <cfif isdate(dresign) and get_now_month.mmonth eq dateformat(dresign,'m')>
                        <cfset expatdays = datediff('d',sys_date,dresign)+1>
                        <cfset expatded = numberformat(expatgross*expatperc*expatdays/daysinmonth(sys_date),'.__')>
                    </cfif>
                <cfelse>
                    <cfset expatded = numberformat(expatgross*expatperc,'.__')>
                </cfif>
            </cfif>
            <!---   end --->  
                        
            <!---   deduct bonus pcb into paytran   --->
            <cfif val(checkbonus.bonus) gt 0>
                <cfset currentpcb = val(currentpcb) - val(bonus_qry.ded115)>
            </cfif>

<!---            #currentpcb#<br>
            #checkbonus.ded115#
            </cfoutput>
            
            <cfabort>--->
            
            <!---   end --->

            <!--- update to deduction 15 for pcb records ---> 
            <cfquery name="update_pcb_to_paytran" datasource="#db#">
                  UPDATE paytran SET DED115 = #currentpcb#, itaxpcb = #pcbgrosspay#, DED114 = #expatded# WHERE empno = "#empno#"
            </cfquery>
                <cfset tded = #deduc# + #currentpcb# + expatded>
            </cfif>
    
            <!---End PCB Calculation--->
                            
            <cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)# - #val(socso_yee)#>

        <cfelseif compccode eq "ID">
                 
            	<!---calculate bpjs kesehatan for indo--->
            	<cfset socso_rate = val(basicpay) + val(add_hrd_ot) + val(add_hrd)- val(dedt_hrd)>	       
				<cfset socso_yee = 0>
				<cfset socso_yer = 0>                                
                <cfif select_empdata.socsono neq "">

                    <cfquery name="socsoww_qry" datasource="#db#">
                        SELECT kesehatan,kesehatancap FROM rngtable 
                        where entryno = '1'
                    </cfquery>
					<cfif socso_rate gt val(socsoww_qry.kesehatancap)/val(socsoww_qry.kesehatan)>
                        <cfset socso_yee = val(socsoww_qry.kesehatancap)>
                    <cfelse>
                        <cfset socso_yee = round(socso_rate*val(socsoww_qry.kesehatan))>
                    </cfif>

                    <cfquery name="socsocc_qry" datasource="#db#">
                        SELECT kesehatan,kesehatancap FROM rngtable 
                        where entryno = '2'
                    </cfquery>
					<cfif socso_rate gt val(socsocc_qry.kesehatancap)/val(socsocc_qry.kesehatan)>
                        <cfset socso_yer = val(socsocc_qry.kesehatancap)>
                    <cfelse>
                        <cfset socso_yer = round(socso_rate*val(socsocc_qry.kesehatan))>
                    </cfif>
                </cfif>
                <!---end of kesehatan--->
      		
	       		<cfquery name="update_socso_qry" datasource="#db#">
					UPDATE paytran 
					set socsoww = #socso_yee# ,
						socsocc = #socso_yer#
					where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
				</cfquery>
               
           	<!---calculate pph21--->
            
                <cfif select_empdata.itaxnoki eq "Y" and select_empdata.itaxcat neq "X">
                
                <cfquery name="getdeduc" datasource="#db#">
                SELECT ded101, ded102, ded103, ded104, ded105, ded106, ded107, ded108, ded109, ded110, ded111, ded112, ded113, ded114,AW101, AW102, AW103, AW104, AW105, AW106, AW107, AW108, AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117 FROM paytran
	       		WHERE empno = "#empno#"
                </cfquery>

			   	<cfset deduc = val(tded)>   
        	    <cfset pphgrosspay = grosspay>

                <!---check deductable allowances for pcb--->
                <cfquery name="awqry" datasource="#db#">
                    SELECT aw_cou,aw_tax FROM awtable
                    where aw_cou < 18 and aw_tax = 0
				</cfquery>

                <cfloop query="awqry">
                    <cfset pphgrosspay = evaluate("#pphgrosspay# - val(getdeduc.AW#(100 + awqry.aw_cou)#)")>
                </cfloop>
                            
				<!---check deductable deductions for pcb--->
                <cfquery name="dedqry" datasource="#db#">
                    SELECT ded_cou,ded_tax FROM dedtable
                    where ded_cou < 15 and ded_tax = 1
				</cfquery>
                
                <cfloop query="dedqry">
                    <cfset pphgrosspay = evaluate("#pphgrosspay# + val(getdeduc.ded#(100 + dedqry.ded_cou)#)")>
                </cfloop>
             
<!---            <cfoutput>
            #pphgrosspay#
            </cfoutput>
            <cfabort>--->   
                         
				<cfquery name="getrng" datasource="#db#">
                	SELECT * FROM rngtable WHERE entryno BETWEEN 1 AND 6
                </cfquery>
				
                
				<cfset bjabat = val(pphgrosspay) * val(getrng.bjabat[1])>
                <cfif bjabat gt getrng.bjabatcap[1]>
	                <cfset bjabat = getrng.bjabatcap[1]>
                </cfif>
                
				<cfset sumpay = (val(pphgrosspay) - val(bjabat) - val(epfw) - val(socso_yee)) * 12>

				<!---deduct ptkp from pmast settings--->              
                <cfset sumpay = sumpay - getrng.ptkprange[#select_empdata.itaxcat#]>
                <cfset lpkp = 0>
                <cfset sumlpkp = 0>
                <cfset pph21 = 0>

				<cfif sumpay gt 0>
                    <cfloop from="4" to="1" index="i" step="-1">
                        <cfif sumpay gt getrng.lpkprange[#i#]>
                            <cfset loop = i>
                            <cfbreak>
                        </cfif>
                    </cfloop>   
    
                    <cfloop from="1" to=#loop# index="i">
                        <cfif loop eq 1>
                            <cfset sumlpkp = sumpay * getrng.lpkp[1]>
                        <cfelse>
                            <cfif loop eq i>
                                <cfset sumlpkp = (lpkp + ((sumpay-getrng.lpkprange[i]) * getrng.lpkp[i]))>
                            <cfelse>
                                <cfset lpkp = lpkp+(getrng.lpkprange[#i#+1] * getrng.lpkp[#i#])>
                            </cfif>
                        </cfif> 
                    </cfloop> 

			         <!---round to 000 and check npwp--->
					<cfif select_empdata.itaxno neq "">
                        <cfset pph21 = int((int(sumlpkp/1000)*1000)/12)>
                    <cfelse>
                        <cfset pph21 = int((int(sumlpkp/1000)*1000)/12*1.2)>
                    </cfif>
                    
                    
                <!---check bonus available--->
                <cfquery name="checkbonus" datasource="#db#">
                    SELECT bonus,b_epfww from pay_tm where empno="#empno#"
                </cfquery>    
                <cfif val(checkbonus.bonus) gt 0 or getdeduc.aw117 gt 0>
                    <cfset pbonus = val(checkbonus.bonus)+val(getdeduc.aw117)>
                	<cfset bgrosspay = (val(pphgrosspay)*12) + val(pbonus)>
                    
				<cfset bjabat = val(bgrosspay) * val(getrng.bjabat[1])>
                <cfif bjabat gt getrng.bjabatcap[1]*12>
	                <cfset bjabat = getrng.bjabatcap[1]*12>
                </cfif>
                
				<cfset sumpayb = val(bgrosspay) - val(bjabat) - (val(epfw)*12) - (val(socso_yee)*12)>

				<!---deduct ptkp from pmast settings--->              
                <cfset sumpayb = sumpayb - getrng.ptkprange[#select_empdata.itaxcat#]>
                <cfset lpkp = 0>
                <cfset sumlpkp = 0>
                <cfset pph21b = 0>
				<cfset loop = 0>
                
				<cfif sumpayb gt 0>
                    <cfloop from="4" to="1" index="i" step="-1">
                        <cfif sumpayb gt getrng.lpkprange[#i#]>
                            <cfset loop = i>
                            <cfbreak>
                        </cfif>
                    </cfloop>   
    
                    <cfloop from="1" to=#loop# index="i">
                        <cfif loop eq 1>
                            <cfset sumlpkp = sumpayb * getrng.lpkp[1]>
                        <cfelse>
                            <cfif loop eq i>
                                <cfset sumlpkp = (lpkp + ((sumpayb-getrng.lpkprange[i]) * getrng.lpkp[i]))>
                            <cfelse>
                                <cfset lpkp = lpkp+(getrng.lpkprange[#i#+1] * getrng.lpkp[#i#])>
                            </cfif>
                        </cfif> 
                    </cfloop> 

			         <!---round to 000 and check npwp--->
					<cfif select_empdata.itaxno neq "">
                        <cfset pph21b = int((int(sumlpkp/1000)*1000)) - (pph21*12) >
                    <cfelse>
                        <cfset pph21b = int((int(sumlpkp/1000)*1000)*1.2) - (pph21*12) >
                    </cfif>
                
                	<cfset pph21 = pph21b + pph21>
                   
				</cfif>
                </cfif>
                <cfelse> 
                	<cfset pph21 = 0>
 				</cfif>

<!---<cfif db eq 'indo_p' and empno eq '0001'>
<cfoutput>
pph21 = #pph21#
<br>

sumpay #sumpay# = ((#pphgrosspay# - #evaluate("iif(val(pphgrosspay) * val(getrng.bjabat[1]) gt getrng.bjabatcap[1],#getrng.bjabatcap[1]#,#val(pphgrosspay) * val(getrng.bjabat[1])#)")# - #epfw# - #socso_yee#) *12) - 
lpkp #evaluate("getrng.ptkprange[#select_empdata.itaxcat#]")#
<br>
<cfif val(checkbonus.bonus) gt 0 >
sumpayb #sumpayb# = ((#bgrosspay# - #bjabat# - #epfw*12# - #socso_yee*12#)  - lpkp #evaluate("getrng.ptkprange[#select_empdata.itaxcat#]")# <br>
sumlpkp #sumlpkp#<br>
pph21 for bonus #pph21b#<br>
pph21 for monthly #pph21-pph21b#
</cfif>
</cfoutput>
<cfabort>
</cfif>--->

			<!--- update to deduction 15 and itaxpcb for pph21 records --->
          
                <cfquery name="update_pph21_to_paytran" datasource="#db#">
                    UPDATE paytran SET DED115 = #pph21#, itaxpcb = #pphgrosspay# WHERE empno = "#empno#"
                </cfquery>
                <cfset tded = #deduc# + #pph21#>
            </cfif>
			<!---end of pph21--->
            
			<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)# - #val(socso_yee)#>
                
	       	<cfelseif compccode eq "SG">   
	       		<cfset netpay = #val(grosspay)# - #val(EPFW)# - #val(tded)#>
<!---<cfif GetAuthUser() eq 'ultrauser7'>
<cfoutput>
#netpay#
</cfoutput>
<cfabort>
</cfif> --->
			</cfif>
            
            
<!---            <cfif db eq "mcjim_p">
            	<cfset netpay =roundno(netpay,'#get_now_month.sud_rnd#','#get_now_month.sud_psu#')>
			</cfif>--->
            
            <!---	netpay rounding open for all on 24/10/15 by Max Tan	--->
           	<cfset netpay = roundno(netpay,'#get_now_month.sud_rnd#','#get_now_month.sud_psu#')>            
            
	       	<!--- calculate epf a
	        <cfset epf_a = val(payin_2nd)> --->
            <cfif isdefined('epf_a') eq false>
            <cfset epf_a = 0>
			</cfif>
	        <cfset epf_pay = #val(epfw)# + #val(epfy)# >
	  
      		<!--- <cfquery name="checkepfa" datasource="#db#">
            SELECT empno FROM pmast WHERE empno = "#epf_a#"
            </cfquery> --->
	  		<cfif isdefined('originalaw') and additionalwages eq 0>
            <cfset epf_a = epf_a - val(originalaw)>
            </cfif>    
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
				epf_pay_a = #epf_a# , cpf_amt="#epf_a#"
                <cfif isdefined('additionalwages')>
                <!--- <cfif isdefined('paytra1_qry.additionalwages')>
                <cfif val(paytra1_qry.additionalwages) neq 0>
                <cfset additionalwages = additionalwages - val(paytra1_qry.additionalwages)>
				</cfif></cfif> --->
                
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