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

<cffunction name="cal_HRD_SDL" access="public" returntype="Any">
	<cfargument name="empno" required="yes">	
	<cfargument name="db" required="yes">		
	
	<cfquery name="pay_tm_qry" datasource="#db#">
		SELECT basicpay, 
		 OT1, OT2, OT3, OT4, OT5, OT6,
		 AW101, AW102, AW103, AW104, AW105, AW106, AW107, AW108, 
		 AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117, 
		 DED101, DED102, DED103, DED104, DED105, DED106, DED107, DED108, 
		 DED109, DED110, DED111, DED112, DED113, DED114, DED115 
		 from pay_tm 
		 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	</cfquery>	
	
	<cfquery name="ded_qry" datasource="#db#">
		SELECT ded_hrd,ded_cou FROM dedtable where ded_cou < 16
	</cfquery>	
	
	<cfset totded_sdl = 0>	
	<cfloop query="ded_qry">
		<cfset ded_var_cou = '100'+ ded_qry.ded_cou>
		<cfset var_ded = "ded"&#ded_var_cou#>
		
		<!--- <cfoutput>#var_ded#</cfoutput><cfabort> --->
		<cfset result_ded = #pay_tm_qry['#var_ded#'][1]# >
		
		
		<cfif ded_qry.ded_hrd gt 0>
        	<cfset totded_sdl = totded_sdl + result_ded>
        </cfif>
	</cfloop>	
	
	<cfquery name="aw_qry" datasource="#db#">
		SELECT aw_hrd,aw_cou FROM awtable where aw_cou < 18
	</cfquery>	
	
	<cfset totaw_sdl = 0>	
	<cfloop query="aw_qry">
		<cfset aw_cou_var = 100 + aw_qry.aw_cou>
		<cfset var_aw = "aw"&#aw_cou_var#>
		<cfset result_aw = #pay_tm_qry['#var_aw#'][1]# >
		<cfif aw_qry.aw_hrd gt 0>
        	<cfset totaw_sdl = val(totaw_sdl) + val(result_aw)>
        </cfif>
	</cfloop>	
	
	<cfset add_hrd_ot = 0>
  	<cfloop from="1" to="6" index="ii">
        <cfquery name="check_cpf_addtional" datasource="#db#">
        	SELECT OT_HRD FROM ottable where ot_cou = #ii#
        </cfquery>
        <cfset ot_var = "OT"&#ii# >
     
		<cfset result_ot = #pay_tm_qry['#ot_var#'][1]# >
              
        <cfif ot_var gt 0 and check_cpf_addtional.OT_HRD gt 0>
       		<cfset add_hrd_ot =  val(add_hrd_ot) + val(result_ot)>
       	</cfif>	
	</cfloop>	
		
	<cfset hrd_pay = val(pay_tm_qry.basicpay) + val(add_hrd_ot ) + val(totaw_sdl) - val(totded_sdl)>
		
	<cfquery name="update_pay_tm_qry" datasource="#db#">
		update pay_tm set HRD_PAY = #val(hrd_pay)# 
		where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
	</cfquery>
		
		
  <!--- for SDL calculation --->
       
       <cfquery name="get_sdl_for" datasource="#db#">
       	SELECT sdl_con, sdl_for, sdlcal FROM ottable
       </cfquery>
       
       <cfquery name="pay_tm" datasource="#db#">
       	SELECT coalesce(HRD_PAY,0) as HRD_PAY, coalesce(BONUS,0) as BONUS, coalesce(COMM,0) as COMM FROM pay_tm where empno =  "#empno#"
       </cfquery>
       <cfset PAY_TM.HRD_PAY = val(PAY_TM.HRD_PAY)>
       <cfset PAY_TM.BONUS = val(PAY_TM.BONUS)>
       <cfset PAY_TM.COMM = val(PAY_TM.COMM)>

      <!---  <cfoutput>#PAY_TM.HRD_PAY#+#PAY_TM.BONUS#+#PAY_TM.COMM#<br></cfoutput> --->
       <cfset sdl_condition = #get_sdl_for.sdl_con# >
       
		<cfset sdl_formula= #get_sdl_for.sdl_for# >
	
       <cfset sdl_new_formula = #Replace(sdl_formula,">="," gte ")# >
       
       <cfset check_sdl_con = #evaluate('#sdl_condition#')# >
	
	
       <cfif check_sdl_con is true and #get_sdl_for.sdlcal# eq "1">
       		<cfset sdl_value = #evaluate('#sdl_new_formula#')# >
		<cfelse>
			<cfset sdl_value = 0>
		</cfif>
<!-------IF EMP_STATUS == O WILL BE 0.00---------->		
	<cfquery name="getemp" datasource="#db#">
			select emp_status from pmast where empno ="#empno#"
		</cfquery>	
			
		<cfif #getemp.emp_status# neq "O">
       <cfquery name="update_sdl" datasource="#db#">
       		UPDATE comm SET levy_sd = #numberformat(sdl_value,'.__')#  
			where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
       </cfquery>
		<cfelse>
	   	      <cfquery name="update_sdl" datasource="#db#">
       		UPDATE comm SET levy_sd = "0.00"  
			where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
       </cfquery>
		</cfif>
<!-------------------------------------------------->		
		<cfset myResult = "success">
	<cfreturn myResult>
</cffunction>
</cfcomponent>