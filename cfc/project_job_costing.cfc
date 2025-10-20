<cfcomponent>
	<cffunction name="cal_project" access="public" returntype="any">
		<cfargument name="db" required="yes">
		<cfargument name="empno" required="yes">
		<cfargument name="CPFWW_ADD_PRJ" required="yes">
	    <cfargument name="CPFCC_ADD_PRJ" required="yes">
	    <cfargument name="qry_tbl_pay" required="yes">
	    <cfargument name="proj_pay_qry" required="yes">   
		<cfargument name="compid" required="yes">
		<cfargument name="db_main" required="yes">	
			
			<cfquery name="gsetup_qry" datasource="#db_main#">
				Select proj_base_basicpay,c_acfwl from gsetup where comp_id="#compid#"
			</cfquery>
			
			<cfquery name="pay_qry" datasource="#db#">
				SELECT basicpay,netpay,EPFCC, EPFWW,grosspay,tded,DED102,taw,aw103 FROM #qry_tbl_pay#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
			</cfquery>
			
			<cfquery name="prj_rcd_qry" datasource="#db#">
				SELECT ot1_p,ot2_p,ot3_p,ot4_p,ot5_p,ot6_p,project_code,dw_p, entryno FROM #proj_pay_qry#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfquery name="cal_dw" datasource="#db#">
				SELECT SUM(coalesce(dw_p,0)) as dw_sum FROM #proj_pay_qry#
				WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and payyes="Y"
			</cfquery>
			
			<cfquery name="comm_qry" datasource="#db#">
				SELECT levy_fw_w from comm where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
			</cfquery>
			
			<cfquery name="select_new_rate" datasource="#db#">
	        SELECT RATE1, RATE2, RATE3, RATE4, RATE5, RATE6 from paytran where empno = "#empno#"
	        </cfquery>
			
			<cfloop query="prj_rcd_qry">
				
			<cfset OT1 = #val(select_new_rate.rate1)# * #val(prj_rcd_qry.ot1_p)#>
	  		<cfset OT2 = #val(select_new_rate.rate2)# * #val(prj_rcd_qry.ot2_p)#>
	        <cfset OT3 = #val(select_new_rate.rate3)# * #val(prj_rcd_qry.ot3_p)#>
	        <cfset OT4 = #val(select_new_rate.rate4)# * #val(prj_rcd_qry.ot4_p)#>
	        <cfset OT5 = #val(select_new_rate.rate5)# * #val(prj_rcd_qry.ot5_p)#>
	        <cfset OT6 = #val(select_new_rate.rate6)# * #val(prj_rcd_qry.ot6_p)#>
				
				<!-- cal salary pay per project  -->
            <cfif val(cal_dw.dw_sum) eq 0 and val(prj_rcd_qry.dw_p) eq 0>
            <cfset cal_dw.dw_sum = 1>
			</cfif>
                
			<cfif #gsetup_qry.proj_base_basicpay# eq 1>
				<cfset project_saly_pay = numberformat(val(pay_qry.basicpay),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')+#ot1#+#ot2#+#ot3#+#ot4#+#ot5#+#ot6#>
			<cfelse>	
				<cfset project_saly_pay = numberformat(val(pay_qry.netpay),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
			</cfif>	
				<cfset project_saly_pay = numberformat(project_saly_pay,'.__')>
			
				<!--  	cal costing pay per project 	 -->
			<cfif #gsetup_qry.proj_base_basicpay# eq 1> 
				<cfset PRJ_NET = numberformat(val(pay_qry.basicpay),'.__') - numberformat(pay_qry.tded,'.__') + numberformat(pay_qry.taw,'.__')>
			<cfelse>	
				<cfset PRJ_NET = numberformat(val(pay_qry.grosspay),'.__') - numberformat(pay_qry.tded,'.__') + numberformat(pay_qry.taw,'.__')>
			</cfif>	
				
				<cfif CPFWW_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - numberformat(val(pay_qry.epfww),'.__')>
				</cfif>
				
				<cfif CPFCC_ADD_PRJ eq "1">
					<cfset PRJ_NET = PRJ_NET - numberformat(val(pay_qry.epfcc),'.__')>
				</cfif>
			<cfif #gsetup_qry.proj_base_basicpay# eq 1> 
				 <cfset project_cost_pay = numberformat(val(PRJ_NET),'.__')* numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')+#ot1#+#ot2#+#ot3#+#ot4#+#ot5#+#ot6#>
			<cfelse> 
				<cfset project_cost_pay = numberformat(val(PRJ_NET),'.__')* numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
			</cfif>	
				<cfset project_cost_pay = numberformat(project_cost_pay,'.__')>
			
				
				<!--  	cal cpf per project -->
				<cfset project_epfww_pay = numberformat(val(pay_qry.epfww),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				<cfset project_epfcc_pay = numberformat(val(pay_qry.epfcc),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
				
				<!--  	cal gross per project -->
			<cfif #gsetup_qry.proj_base_basicpay# eq 1> 
				<cfset project_grosspay = (numberformat(val(pay_qry.basicpay),'.__')+ numberformat(pay_qry.taw,'.__')-numberformat(pay_qry.aw103,'.__')) * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')+#ot1#+#ot2#+#ot3#+#ot4#+#ot5#+#ot6#>
			<cfelse>
				<cfset project_grosspay = numberformat(val(pay_qry.grosspay),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
			</cfif>	
            
           
            <cfset proj_post_aw =  numberformat(val(numberformat(val(pay_qry.taw),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')),'.__')>
             <cfset proj_post_ded =  numberformat(val(numberformat(val(pay_qry.tded),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')),'.__')>
              <cfset proj_post_basic = numberformat(val(project_grosspay),'.__') <!--- + proj_post_ded + project_epfww_pay ---> - proj_post_aw >
            <cfset proj_post_totalepf = project_epfww_pay + project_epfcc_pay>
			
				<cfset project_fwl = 0>
				
				<cfif qry_tbl_pay eq "paytran">
					<cfif gsetup_qry.c_acfwl eq "1" >
						
						<cfset project_fwl = numberformat(val(comm_qry.levy_fw_w),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
					<cfelse>
						<cfset project_fwl = numberformat(val(pay_qry.DED102),'.__') * numberformat(val(prj_rcd_qry.dw_p),'.__')/numberformat(val(cal_dw.dw_sum),'.__')>
					</cfif>
				 </cfif>
				 <!--- <cfoutput>#empno# #qry_tbl_pay# #comm_qry.levy_fw_w#</cfoutput> --->
                 
                 <cfif gsetup_qry.proj_base_basicpay eq 1>
                 <cfset project_saly_pay = val(project_saly_pay) + val(proj_post_aw) - val(proj_post_ded) - val(project_epfww_pay)>
                 </cfif>
                 
				 <cfquery name="update_prj_rcd" datasource="#db#">
					UPDATE #proj_pay_qry#
					SET netpay = #val(project_saly_pay)#,
						jobcosting = #val(project_cost_pay)#,
						proj_epfww = #val(project_epfww_pay)#,
						proj_epfcc = #val(project_epfcc_pay)#,
						proj_gross = #val(project_grosspay)#,
						proj_fwl = #val(project_fwl)#,
                        proj_post_aw = "#val(proj_post_aw)#",
                        proj_post_ded = "#val(proj_post_ded)#",
                        proj_post_basic = "#val(proj_post_basic)#",
                        proj_post_totalepf = "#val(proj_post_totalepf)#"
					WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> 
					and entryno = #prj_rcd_qry.entryno#
				 </cfquery> 
		<!--- 	<cfoutput>#prj_rcd_qry.entryno# #prj_rcd_qry.project_code# #val(project_epfcc_pay)# <br></cfoutput> --->
			</cfloop>
		<!--- <cfabort> --->
	
	
        <cfset myResult = "success">
		<cfreturn myResult>
	</cffunction>

</cfcomponent>