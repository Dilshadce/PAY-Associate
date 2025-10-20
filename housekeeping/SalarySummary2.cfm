<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/report.css" rel="stylesheet" type="text/css" />

<cfset total_basic = 0>
<cfset total_injury = 0>
<cfset total_aw = 0>
<cfset total_ded105 = 0>
<cfset total_sdl = 0>
<cfset total_comm = 0>
<cfset total_gross = 0>
<cfset total_totalone = 0>
<cfset total_socsoww = 0>
<cfset total_epfww = 0>
<cfset total_net = 0>
<cfset total_socsocc = 0>
<cfset total_epfcc = 0>
<cfset total_ded114 = 0>

<cfquery name="get_sdl_for" datasource="#dts#">
 SELECT sdl_con, sdl_for, sdlcal FROM ottable
</cfquery>

<cfquery name="ded_qry" datasource="#dts#">
		SELECT ded_hrd,ded_cou FROM dedtable where ded_cou < 16
	</cfquery>	
    
    <cfquery name="aw_qry" datasource="#dts#">
		SELECT aw_hrd,aw_cou FROM awtable where aw_cou < 18
	</cfquery>
    <cfloop from="1" to="6" index="ii">
        <cfquery name="check_cpf_addtional#ii#" datasource="#dts#">
        	SELECT OT_HRD FROM ottable where ot_cou = #ii#
        </cfquery>
        </cfloop>
	
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

 <cfset PAY_TM.BONUS = 0>
       <cfset PAY_TM.COMM = 0>

       <cfset sdl_condition = #get_sdl_for.sdl_con# >
       
		<cfset sdl_formula= #get_sdl_for.sdl_for# >
	
       <cfset sdl_new_formula = #Replace(sdl_formula,">="," gte ")# >

<cfoutput>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
	
<cfif #form.month# eq #company_details.mmonth#>
<cfset db_select = "pay_tm">
<cfelse>
<cfset db_select = form.paytype >
</cfif>

<cfset mon = #form.month#>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset days = daysinmonth(date) >
<cfset newdate = createdate(yrs,mon,days) >
<table width="1300px" >
<tr>
<th style="text-transform:uppercase" colspan="20">SALARY SUMMARY - #dateformat(date,'MMMM YYYY')#</th>
</tr>
<tr>
<td style="text-transform:uppercase" colspan="20" align="center">PRINTED BY #HUserName#</td>
</tr>
<tr>
<th align="left" colspan="8">#company_details.comp_name#</th>
<td align="right" colspan="9">#dateformat(newdate,'DD/MM/YYYY')#</td>
</tr>
<tr>
<th colspan="20">
<hr />
</th>
</tr>
</table>
</cfoutput>


<cfquery name="getdept" datasource="#dts#">
	select deptcode from pmast group by deptcode
</cfquery>
<table width="1300px">
<cfloop query="getdept">
	
<cfquery name="selectList" datasource="#dts#">
SELECT * FROM #db_select# AS db LEFT JOIN pmast AS pm ON db.empno = pm.empno WHERE <cfif db_select neq "pay_tm"> db.tmonth = #form.month# and</cfif> pm.deptcode ="#getdept.deptcode#"
and pm.confid >= #hpin#
<cfif form.confid neq "">
and pm.confid = "#form.confid#"
</cfif>
<cfif #form.empno# neq "">
	AND pm.empno >= "#form.empno#"
</cfif>
<cfif #form.empno1# neq "">
	AND pm.empno <= "#form.empno1#"
</cfif>
<cfif #form.lineno# neq "">
	AND pm.plineno >= "#form.lineno#"
</cfif>
<cfif #form.lineno1# neq "">
	AND pm.plineno <= "#form.lineno1#"
</cfif>
<cfif #form.brcode# neq "">
	AND pm.brcode >= "#form.brcode#"
</cfif>
<cfif #form.brcode1# neq "">
	AND pm.brcode <= "#form.brcode1#"
</cfif>
<cfif #form.deptcode# neq "">
	AND pm.deptcode >= "#form.deptcode#"
</cfif>
<cfif #form.deptcode1# neq "">
	AND pm.deptcode <= "#form.deptcode1#"
</cfif>
<cfif #form.category# neq "">
	AND pm.category >= "#form.category#"
</cfif>
<cfif #form.category1# neq "">
	AND pm.category <= "#form.category1#"
</cfif>
<cfif #form.emp_code# neq "">
	AND pm.emp_code >= "#form.emp_code#"
</cfif>
<cfif #form.emp_code1# neq "">
	AND pm.emp_code <= "#form.emp_code1#"
</cfif>
<cfif isdefined('form.exclude0')>
    AND db.netpay > 0
</cfif>
order by length(pm.empno),pm.empno
</cfquery>



<cfoutput>



<tr style="font-size:12px">
<th align="left" width="10px">S/N</th>
<th align="left" width="200px">Name (#deptcode# Department)</th>
<th align="left" width="100px">NRIC</th>
<th align="right" width="72px">DateOfBirth</th>
<th align="right" width="200px">Salary Date</th>
<th align="right" width="20px">Age</th>
<th align="right" width="72px">Department</th>
<th align="right" width="72px">Basic Pay</th>
<th align="right" width="72px">Commission</th>
<th align="right" width="72px">Allowance</th>
<th align="right" width="72px">Gross Salary</th>
<th align="right" width="72px">Reimburse</th>
<cfif company_details.ccode eq 'SG'><th align="right" width="72px">Deduction (CDAC)</th></cfif>
<cfif company_details.ccode eq 'MY'><th align="right" width="72px">Employee Socso</th></cfif>
<th align="right" width="72px">Employee <cfif company_details.ccode eq 'MY'>E<cfelse>C</cfif>PF</th>
<th align="right" width="72px">Nett Salary</th>
<cfif company_details.ccode eq 'MY'><th align="right" width="72px">Employer Socso</th></cfif>
<th align="right" width="72px">Employer <cfif company_details.ccode eq 'MY'>E<cfelse>C</cfif>PF</th>
<cfif company_details.ccode eq 'SG'><th align="right" width="72px">Injury 0.4%</th></cfif>
<cfif company_details.ccode eq 'SG'><th align="right" width="72px">SDL 0.25%</th></cfif>
<th align="right" width="72px">Total</th>
<th align="right" width="72px">Remarks</th>
</tr>
<tr>
<th colspan="20">
<hr />
</th>
</tr>
<!--- <cfset paytype = form.paytype >
<cfif paytype eq "1">
<cfset db_select = "pay1_12m" >
<cfelseif paytype eq "2">
<cfset db_select = "pay_12m" >
</cfif> --->


<cfloop query="selectList">
	
<cfset selectList.grosspay = val(selectList.grosspay) + val(selectList.bonus) + val(selectList.extra)+ val(selectList.comm)>
<cfset selectList.netpay = val(selectList.netpay) + val(selectList.bonus) + val(selectList.extra)+ val(selectList.comm)>
<tr>
<td align="left">#selectList.currentrow#</td>
<td align="left">#selectList.name#</td>
<td align="left"><cfif #selectList.nricn# neq "">#selectList.nricn#<cfelse>#selectList.nric#</cfif></td>
<td align="left">#dateformat(selectList.dbirth,'dd-mm-yyyy')#</td>
<td aling="left">#dateformat(newdate,'DD-MMM-YYYY')#</td>

<cfset nowyear = "#dateformat(date,'yyyy')#">
<cfset dob = "#dateformat(selectList.dbirth,'yyyy')#">
<cfset age = #val(nowyear)# - #val(dob)#> 
<td aling="left"><cfif age eq "#dateformat(date,'yyyy')#"> 0 <cfelse>#age#</cfif></td>

<td align="left">#getdept.deptcode#</td>

<td align="right">#numberformat(val(selectList.basicpay),'.__')#</td>
<cfset total_basic = total_basic + #numberformat(val(selectList.basicpay),'.__')# >

<td align="right">#numberformat(val(selectList.comm),'.__')#</td>
<cfset total_comm = total_comm + #numberformat(val(selectList.comm),'.__')#>

<td align="right">#numberformat(val(selectList.taw),'.__')#</td>
<cfset total_aw = total_aw + #numberformat(val(selectList.taw),'.__')#>

<td align="right">#numberformat(val(selectList.grosspay),'.__')#</td>
<cfset total_gross = total_gross + #numberformat(val(selectList.grosspay),'.__')#>

<td align="right">#numberformat(val(selectList.ded105),'.__')#</td>
<cfset total_ded105 = total_ded105 + #val(selectList.ded105)#>

<cfif company_details.ccode eq 'SG'><td align="right">#numberformat(val(selectList.ded114),'.__')#</td>
<cfset total_ded114 = total_ded114 + #val(selectList.ded114)#></cfif>

<cfif company_details.ccode eq 'MY'><td align="right">#numberformat(val(selectList.socsoww),'.__')#</td>
<cfset total_socsoww = total_socsoww + #numberformat(val(selectlist.socsoww),'.__')#></cfif>

<td align="right">#numberformat(val(selectList.epfww)+ val(selectList.epfwwext),'.__')#</td>
<cfset total_epfww = total_epfww + #numberformat(val(selectList.epfww)+ val(selectList.epfwwext),'.__')# >

<td align="right">#numberformat(val(selectList.netpay),'.__')#</td>
<cfset total_net = total_net + #numberformat(val(selectList.netpay),'.__')# >

<cfif company_details.ccode eq 'MY'><td align="right">#numberformat(val(selectlist.socsocc),'.__')#</td>
<cfset total_socsocc = total_socsocc + #numberformat(val(selectlist.socsocc),'.__')#></cfif>

<td align="right">#numberformat(val(selectList.epfcc) + val(selectList.epfccext),'.__')#</td>
<cfset total_epfcc = total_epfcc + #numberformat(val(selectList.epfcc) + val(selectList.epfccext),'.__')#>

<cfset injury = #numberformat(val(selectList.grosspay) * 0.4/100,'.__')#>
<cfif company_details.ccode eq 'SG'><td align="right">#numberformat(injury,'.__')#</td>
<cfset total_injury = total_injury + #numberformat(injury,'.__')#></cfif>


<cfset totded_sdl = 0>	
	<cfloop query="ded_qry">
		<cfset ded_var_cou = '100'+ ded_qry.ded_cou>
		<cfset var_ded = "ded"&#ded_var_cou#>
		
		<!--- <cfoutput>#var_ded#</cfoutput><cfabort> --->
		<cfset result_ded = #selectList['#var_ded#'][1]# >
		
		
		<cfif ded_qry.ded_hrd gt 0>
        	<cfset totded_sdl = totded_sdl + result_ded>
        </cfif>
	</cfloop>	
	
		
	
	<cfset totaw_sdl = 0>	
	<cfloop query="aw_qry">
		<cfset aw_cou_var = 100 + aw_qry.aw_cou>
		<cfset var_aw = "aw"&#aw_cou_var#>
		<cfset result_aw = #selectList['#var_aw#'][1]# >
		<cfif aw_qry.aw_hrd gt 0>
        	<cfset totaw_sdl = val(totaw_sdl) + val(result_aw)>
        </cfif>
	</cfloop>	
	
	<cfset add_hrd_ot = 0>
  	<cfloop from="1" to="6" index="ii">
    
        <cfset ot_var = "OT"&#ii# >
     
		<cfset result_ot = #selectList['#ot_var#'][1]# >
              
        <cfif ot_var gt 0 and evaluate('check_cpf_addtional#ii#.OT_HRD') gt 0>
       		<cfset add_hrd_ot =  val(add_hrd_ot) + val(result_ot)>
       	</cfif>	
	</cfloop>	
		
	<cfset hrd_paya = val(selectList.basicpay) + val(add_hrd_ot ) + val(totaw_sdl) - val(totded_sdl)>
    
       
       <cfset PAY_TM.HRD_PAY = val(hrd_paya)>
       <cfset check_sdl_con = #evaluate('#sdl_condition#')# >
       <cfif check_sdl_con is true and #get_sdl_for.sdlcal# eq "1">
       		<cfset sdl_value = #evaluate('#sdl_new_formula#')# >
		<cfelse>
			<cfset sdl_value = 0>
		</cfif>

<cfset sdl = sdl_value>
<cfif company_details.ccode eq 'SG'><td align="right">#numberformat(sdl,'.__')#</td>
<cfset total_sdl = total_sdl + #numberformat(sdl,'.__')#></cfif>

<cfif company_details.ccode eq 'SG'>
<cfset totalone = #val(selectList.ded114)# + #val(selectList.epfww)# + #val(selectList.epfwwext)# + #val(selectList.netpay)# +
#val(selectList.epfcc)# + #val(selectList.epfccext)# + #val(injury)# + #val(sdl)# >
<cfelse>
<cfset totalone = #val(selectList.epfww)# + #val(selectList.epfwwext)# + #val(selectList.netpay)# +
#val(selectList.epfcc)# + #val(selectList.epfccext)# + #val(selectlist.socsoww)# + #val(selectlist.socsocc)# >
</cfif>

<td align="right">#numberformat(totalone,',.__')#</td>
<cfset total_totalone = total_totalone + #val(totalone)#>

<td align="right"><input type="text" name="text1" id="text1"</td>
</tr>
</cfloop>


</cfoutput>
</cfloop>

<cfoutput>
<tr>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td align="right"><hr />#numberformat(total_basic,'.__')#</td>
<td align="right"><hr />#numberformat(total_comm,'.__')#</td>
<td align="right"><hr />#numberformat(total_aw,'.__')#</td>
<td align="right"><hr />#numberformat(total_gross,'.__')#</td>
<td align="right"><hr />#numberformat(total_ded105,'.__')#</td>
<cfif company_details.ccode eq 'SG'><td align="right"><hr />#numberformat(total_ded114,'.__')#</td></cfif>
<cfif company_details.ccode eq 'MY'><td align="right"><hr />#numberformat(total_socsoww,'.__')#</td></cfif>
<td align="right"><hr />#numberformat(total_epfww,'.__')#</td>
<td align="right"><hr />#numberformat(total_net,'.__')#</td>
<cfif company_details.ccode eq 'MY'><td align="right"><hr />#numberformat(total_socsocc,'.__')#</td></cfif>
<td align="right"><hr />#numberformat(total_epfcc,'.__')#</td>
<cfif company_details.ccode eq 'SG'><td align="right"><hr />#numberformat(total_injury,'.__')#</td></cfif>
<cfif company_details.ccode eq 'SG'><td align="right"><hr />#numberformat(total_sdl,'.__')#</td></cfif>
<td align="right"><hr />#numberformat(total_totalone,'.__')#</td>
<td align="right"></td>
<td align="right"></td>

</tr>

<tr>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td><hr /></td>
<td><hr /></td>
<td><hr /></td>
<td><hr /></td>
<td><hr /></td>
<cfif company_details.ccode eq 'SG'><td><hr /></td></cfif>
<cfif company_details.ccode eq 'MY'><td><hr /></td></cfif>
<td><hr /></td>
<td><hr /></td>
<cfif company_details.ccode eq 'MY'><td><hr /></td></cfif>
<td><hr /></td>
<cfif company_details.ccode eq 'SG'><td><hr /></td></cfif>
<cfif company_details.ccode eq 'SG'><td><hr /></td></cfif>
<td><hr /></td>
<td></td>
<td></td>
</tr>
</cfoutput>
</table>