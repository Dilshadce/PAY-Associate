<title>Payment Advice</title>
<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getList_qry" datasource="#dts#">
SELECT * FROM pmast WHERE paystatus = "A" 
</cfquery>
<cfset BFCPF = form.BFCPFinterest >
<cfset ICOLP = form.interestCOLP >
<cfset LPPFFWL = form.LPPFFWL>
<cfset bank = form.bank>
<cfset cheque = form.chequeno>
<cfset date = form.date>
<cfset month = dateformat(date,'mmm')>
<cfset nxtmonthdate = DateAdd('m',1,date)>
<cfset nxtmonth = dateformat(nxtmonthdate,'mmm')>

<cfquery name="get_amt_qry" datasource="#dts#">
	SELECT *
	FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
	WHERE epfcat = '#form.cat#' AND b.payyes="Y" AND 
    paystatus = "A"	<!--- AND ((coalesce(p_epfww,0) + coalesce(p_epfcc,0) + coalesce(epfwwext,0) + coalesce(epfccext,0) +
	coalesce(B_EPFWW,0) + coalesce(B_EPFCC,0) + coalesce(c_epfww,0) + coalesce(c_epfww,0)) <> 0 or ((epfno <> "" or epfno is not null) and coalesce(epf_pay_a,0) <> 0)) ---> and confid >= #hpin#
</cfquery>

<cfquery name="getLevy_qry" datasource="#dts#">
	SELECT a.empno,b.empno,name,epfno,levy_sd
	FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
	WHERE epfcat = '#form.cat#' AND levy_sd != '0.00' AND paystatus = "A" and confid >= #hpin#
</cfquery>

<cfquery name="getList_qry" datasource="#dts#">
	SELECT *
	FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
	WHERE epfcat = '#form.cat#' AND b.payyes="Y" AND paystatus = "A" 
	AND ((coalesce(p_epfww,0) + coalesce(p_epfcc,0) + coalesce(epfwwext,0) + coalesce(epfccext,0) +
	coalesce(B_EPFWW,0) + coalesce(B_EPFCC,0) + coalesce(c_epfww,0) + coalesce(c_epfww,0)) <> 0  or ((epfno <> "" or epfno is not null) and coalesce(epf_pay_a,0) <> 0)) and confid >= #hpin#
	order by name
</cfquery>

<cfquery name="getFWL_qry" datasource="#dts#">
	SELECT levy_fw_w 
	FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
	WHERE epfcat = '#form.cat#' AND levy_fw_w != '0.00' AND paystatus = "A" and confid >= #hpin#
</cfquery>

<cfset sum_cpf = 0>
<cfset sum_fwl = 0>
<cfset sum_sdl = 0>
<cfset sum_cc = 0>
<cfset sum_MBMF = 0>
<cfset sum_sinda = 0>
<cfset sum_cdac = 0>
<cfset sum_ECF = 0>
<cfset count_cpf = 0>
<cfset count_fwl = 0>
<cfset count_sdl = 0>
<cfset count_cc = 0>
<cfset count_MBMF = 0>
<cfset count_sinda = 0>
<cfset count_cdac = 0>
<cfset count_ECF = 0>
<cfset paytype = form.payType>
<cfset serial_num = form.sno>
<cfset CSN = "#form.uen#"&"#paytype#"&"#numberformat(serial_num,'00')#">

<cfloop query="get_amt_qry">
	  <cfif get_amt_qry.re_cpf_all gt 0>
	    <cfset sum_cpf = sum_cpf + round(get_amt_qry.re_cpf_all)>
	    <cfset count_cpf = count_cpf + 1>
	  </cfif>
	  <cfif isdefined('form.fwl')>
	  <cfif getComp_qry.c_acfwl neq "1">
	  	<cfif #val(get_amt_qry.ded102)# gt 0>
		    <cfset sum_fwl = sum_fwl + val(get_amt_qry.ded102) >
		    <cfset count_fwl = count_fwl + 1>
		</cfif>
	  </cfif>
      </cfif>
	  <cfif isdefined('form.CChest')>
	  <cfif #val(get_amt_qry.ded110)# gt 0>
	    <cfset sum_cc = sum_cc + #val(get_amt_qry.ded110)# >
	    <cfset count_cc = count_cc + 1>
	  </cfif>
      </cfif>
      <cfif isdefined('form.MBMF')>
	  <cfif #val(get_amt_qry.ded111)# gt 0 or #val(get_amt_qry.ded109)# gt 0>
	    <cfset sum_MBMF = sum_MBMF + #val(get_amt_qry.ded111)# + #val(get_amt_qry.ded109)# >
	    <cfset count_MBMF = count_MBMF + 1>
	  </cfif>
      </cfif>
      <cfif isdefined('form.SINDA')>
	  <cfif #val(get_amt_qry.ded113)# gt 0>
	    <cfset sum_sinda = sum_sinda +  #val(get_amt_qry.ded113)# >
	    <cfset count_sinda = count_sinda + 1>
	  </cfif>
      </cfif>
      <cfif isdefined('form.cdac')>
	  <cfif #val(get_amt_qry.ded114)# gt 0>
	    <cfset sum_cdac = sum_cdac +  #val(get_amt_qry.ded114)# >
	    <cfset count_cdac = count_cdac + 1>
	  </cfif>
      </cfif>
      <cfif isdefined('form.cdac')>
	  <cfif #val(get_amt_qry.ded115)# gt 0>
	    <cfset sum_ECF = sum_ECF +  #val(get_amt_qry.ded115)# >
	    <cfset count_ECF = count_ECF + 1>
	  </cfif>
      </cfif>
</cfloop>
<cfif isdefined('form.fwl')>
<cfif getComp_qry.c_acfwl eq "1">
	<cfloop query="getFWL_qry">
		<cfif val(getFWL_qry.levy_fw_w ) gt 0>
			<cfset sum_fwl = sum_fwl + val(getFWL_qry.levy_fw_w) >
		    <cfset count_fwl = count_fwl + 1>
		</cfif>
	</cfloop>
</cfif>
</cfif>
<cfif isdefined('form.sdl')>
<cfloop query="getLevy_qry">
	<cfif #val(getLevy_qry.levy_sd)# gt 0>
		<cfset sum_sdl = sum_sdl + #val(getLevy_qry.levy_sd)# >
		<cfset count_sdl = count_sdl + 1>
	</cfif>
</cfloop>
</cfif>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset total_contrib = #val(sum_fwl)#+#val(sum_cpf)# + #val(int(val(sum_sdl)+0.0000000000000001))# + #val(sum_cc)# + #val(sum_MBMF)# 
		+ #val(sum_sinda)# + #val(sum_cdac)# + #val(sum_ecf)# >
<cfset totalPL = #val(BFCPF)# + #val(ICOLP)# >
<cfset total_contrib = total_contrib + val(totalPL) + numberformat(LPPFFWL,'.__')>


<cfreport template="paymentAdvice.cfr" format="PDF" query="getList_qry" >
	
	  <cfreportparam name="compName" value="#getComp_qry.comp_name#">
	  <cfreportparam name="compCode" value="#getComp_qry.comp_roc#">
	  <cfreportparam name="date" value="#date#">
	  <cfreportparam name="month" value="#month#">
	  <cfreportparam name="nxtmonth" value="#nxtmonth#">
	  <cfreportparam name="year" value="#yrs#">
	  <cfreportparam name="sum_cpf" value="#round(sum_cpf)#">
	  <cfreportparam name="sum_fwl" value="#numberformat(sum_fwl,'.__')#">
	  <cfreportparam name="sum_sdl" value="#numberformat(int(val(sum_sdl)+0.00000000001),'.__')#">
	  <cfreportparam name="sum_cc" value="#numberformat(sum_cc,'.__')#">
	  <cfreportparam name="sum_MBMF" value="#numberformat(sum_MBMF,'.__')#">
	  <cfreportparam name="sum_sinda" value="#numberformat(sum_sinda,'.__')#">
	  <cfreportparam name="sum_cdac" value="#numberformat(sum_cdac,'.__')#">
	  <cfreportparam name="sum_ecf" value="#numberformat(sum_ecf,'.__')#">
	  <cfreportparam name="count_cpf" value="#count_cpf#">
	  <cfreportparam name="count_fwl" value="#count_fwl#">
	  <cfreportparam name="count_sdl" value="#count_sdl#">
	  <cfreportparam name="count_cc" value="#count_cc#">
	  <cfreportparam name="count_MBMF" value="#count_MBMF#">
	  <cfreportparam name="count_sinda" value="#count_sinda#">
	  <cfreportparam name="count_cdac" value="#count_cdac#">
	  <cfreportparam name="count_ecf" value="#count_ecf#">
	  <cfreportparam name="bank" value="#bank#">
	  <cfreportparam name="cheque" value="#cheque#">
	  
	  <cfreportparam name="total_contrib" value="#numberformat(total_contrib,'.__')#">
	  <cfreportparam name="BFCPF" value="#numberformat(BFCPF,'.__')#">
	  <cfreportparam name="ICOLP" value="#numberformat(ICOLP,'.__')#">
	  <cfreportparam name="LPPFFWL" value="#numberformat(LPPFFWL,'.__')#">
	  <cfreportparam name="totalLP" value="#numberformat(totalPL,'.__')#">
	  <cfreportparam name="CSN" value="#CSN#">
<!--- contributed report --->

</cfreport>

