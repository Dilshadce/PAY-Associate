<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<title>CPF91 Payment Advice</title>
<cfset no = 0>
CPF BOARD
<font size="5" color="blue"><i><center>CPF91 Payment Advice Report</center></i></font>
<hr>
<cfquery name="getComp_qry" datasource="payroll_main">
SELECT c_acfwl FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfoutput>

<table border="1">
<cfset BFCPF = form.BFCPFinterest >
<cfset ICOLP = form.interestCOLP >
<cfset LPPFFWL = form.LPPFFWL>
<cfset cat = form.cat>
<cfset uen = form.uen>
<cfif len(uen) eq 9>
	<cfset uen = uen&" " >
</cfif>
<cfset paytype = form.payType>
<cfset serial_num = form.sno>
<cfset s_mode = form.s_mode>
<cfset ndate = createdate(right(form.s_date,4),mid(form.s_date,4,2),left(form.s_date,2))>
<cfset s_date = ndate>
<cfset s_time_HH = #numberformat(form.s_time_HH,'00')#>
<cfset s_time_MM = #numberformat(form.s_time_MM,'00')#>
<cfset s_time_SS = #numberformat(form.s_time_SS,'00')#>

<cfif isdefined("form.cpf_M")>
<cfset nNdate = createdate(right(form.CPF_M,4),mid(form.CPF_M,4,2),left(form.CPF_M,2))>
<cfset CPF_M = nNdate>
</cfif>

<cfif isdefined("form.FWL")>
<cfset FWL = form.FWL>
</cfif>

<cfif isdefined("form.SINDA")>
<cfset SINDA = form.SINDA>
</cfif>

<cfif isdefined("form.SDL")>
<cfset SDL = form.SDL>
</cfif>

<cfif isdefined("form.CDAC")>
<cfset CDAC = form.CDAC>
</cfif>

<cfif isdefined("form.CChest")>
<cfset CChest = form.CChest>
</cfif>

<cfif isdefined("form.ECF")>
<cfset ECF = form.ECF>
</cfif>

<cfif isdefined("form.MBMF")>
<cfset MBMF = form.MBMF>
</cfif>

<cfset total_record_count = 1 >

<cfquery name="getList_qry" datasource="#dts#">
SELECT 
sum(p_epfww) as p_epfww , sum(epfwwext) as epfwwext, 
sum(p_epfcc) as p_epfcc, sum(b_epfcc) as b_epfcc, sum(b_epfww) as b_epfww, 
sum(c_epfcc) as c_epfcc, sum(c_epfww) as c_epfww, 
sum(epfccext) as epfccext, sum(re_cpf_all) as re_cpf_all, 
sum(ded109) as MF, sum(ded110) as CC, sum(ded111) as MB, sum(ded113) as SD, 
sum(ded114) as CDAC, sum(ded115) as eu 
,sum(ded102) as fwl
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>

<cfquery name="sumFWLevy_qry" datasource="#dts#">
	select sum(levy_fw_w) as fwlevy from comm as c where empno in
		(SELECT a.empno FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
			WHERE epfcat = #cat# and a.paystatus = "A" AND b.payyes = "Y") 
	and levy_fw_w <> ''
</cfquery>

<cfif getComp_qry.c_acfwl neq "1">
	<cfset sum_fwl = getList_qry.fwl>
<cfelse>
	<cfset sum_fwl = sumFWLevy_qry.fwlevy>
</cfif>

<cfquery name="get_count_MBMF" datasource="#dts#">
	SELECT ded109,ded111
	FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
	WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>
<cfset mbmf_count = 0>
<cfloop query="get_count_MBMF">
	<cfif #val(get_count_MBMF.ded109)# gt 0 or #val(get_count_MBMF.ded111)# gt 0>
		<cfset mbmf_count = mbmf_count + 1>
	</cfif>
</cfloop>

<cfquery name="get_count_sinda" datasource="#dts#">
	SELECT ded113
	FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
	WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>
<cfset sinda_count = 0>
<cfloop query="get_count_sinda">
<cfif #val(get_count_sinda.ded113)# gt 0>
<cfset sinda_count = sinda_count + 1>
</cfif>
</cfloop>

<cfquery name="get_count_cdac" datasource="#dts#">
SELECT ded114
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>
<cfset cdac_count = 0>
<cfloop query="get_count_cdac">
<cfif #val(get_count_cdac.ded114)# gt 0>
<cfset cdac_count = cdac_count + 1>
</cfif>
</cfloop>

<cfquery name="get_count_eu" datasource="#dts#">
SELECT ded115
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>
<cfset eu_count = 0>
<cfloop query="get_count_eu">
	<cfif #val(get_count_eu.ded115)# gt 0>
		<cfset eu_count = eu_count + 1>
	</cfif>
</cfloop>


<cfif getComp_qry.c_acfwl neq "1">
	<cfquery name="get_count_fwl" datasource="#dts#">
		SELECT ded102
		FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
		WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
	</cfquery>
	<cfset get_FWL = get_count_fwl.ded102>
<cfelse>
	<cfquery name="get_count_fwl" datasource="#dts#">
		select levy_fw_w from comm where empno in
		(SELECT a.empno FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
			WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y")
		and levy_fw_w <> ''
	</cfquery>
	<cfset get_FWL = get_count_fwl.levy_fw_w>
</cfif>
<cfset fwl_count = 0>
<cfloop query="get_count_fwl">
	<cfif val(get_FWL) gt 0>
		<cfset fwl_count = fwl_count + 1>
	</cfif>
</cfloop>

<cfquery name="get_count_cc" datasource="#dts#">
	SELECT ded110
	FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
	WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>
<cfset cc_count = 0>
<cfloop query="get_count_cc">
<cfif #val(get_count_cc.ded110)# gt 0>
<cfset cc_count = cc_count + 1>
</cfif>
</cfloop>

<cfquery name="get_sdl_sum" datasource="#dts#">
SELECT sum(levy_sd) as sdl
FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
WHERE epfcat = #cat# AND a.paystatus = "A"
</cfquery>

<cfquery name="get_count_sdl" datasource="#dts#">
SELECT levy_sd
FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A"
</cfquery>
<cfset sdl_count = 0>
<cfloop query="get_count_sdl">
<cfif #val(get_count_sdl.levy_sd)# gt 0>
<cfset sdl_count = sdl_count + 1>
</cfif>
</cfloop>

<cfquery name="get_count_pay_tm" datasource="#dts#">
SELECT epfww , epfwwext, epfcc, epfccext, re_cpf_all
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A"  AND b.payyes = "Y"
</cfquery>
<cfset i = 0>
<cfset total_epf_a = 0 >
<cfloop query="get_count_pay_tm">
	<cfif get_count_pay_tm.re_cpf_all gt 0>
		<cfset total_epf_a = total_epf_a + #round(get_count_pay_tm.re_cpf_all)# >
		<cfset i = i + 1>
	</cfif>
</cfloop>


<cfset total_epf = #total_epf_a# * 100 >
<cfset CSN = "#uen#"&"#paytype#"&"#numberformat(serial_num,'00')#">

<cfset new_s_date = #dateformat(s_date,'ddmmyyyy')# >
<cfset header = "#s_mode#"&" #CSN#"&" "&"01"&"#dateformat(s_date,'YYYYMMDD')#"&"#s_time_HH##s_time_MM##s_time_SS#FTP.DTL">
<cfloop condition="len(header) lt 150">
<cfset header = header&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header#</td>
</tr>
<cfset total_empcc_contrib = round(val(getList_qry.re_cpf_all)) >

<cfif isdefined("form.MBMF")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.MF)# + #val(getList_qry.MB)# >
</cfif>

<cfif isdefined("form.CChest")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.cc)# >
</cfif>

<cfif isdefined("form.SINDA")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.SD)# >
</cfif>

<cfif isdefined("form.CDAC")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.CDAC)# >
</cfif>

<cfif isdefined("form.ECF")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.EU)# >
</cfif>

<cfif isdefined("form.FWL")>
	<cfset total_empcc_contrib = total_empcc_contrib + #val(sum_fwl)# >
</cfif>

<cfif isdefined("form.SDL")>
<cfset total_empcc_contrib = val(total_empcc_contrib) + int(val(get_sdl_sum.sdl)) >
</cfif>

<cfset total_empcc_contrib = total_empcc_contrib * 100 >
  
<cfset sub_header = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#01"&"#numberformat(total_epf,'000000000000')#"&"#numberformat(0,'0000000')#">
<cfloop condition="len(sub_header) lt 150">
	<cfset sub_header = sub_header&" " >
</cfloop> 
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#. </font></td>
	<td>#sub_header#</td>  
</tr>   

<cfif isdefined("form.MBMF")>
<cfif mbmf_count gt 0>
<cfset mbmf = (#val(getList_qry.mb)# + #val(getList_qry.mf)#) * 100 >
<cfset sub_header1 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#02"&"#numberformat(mbmf,'000000000000')#"&"#numberformat(mbmf_count,'0000000')#">
<cfloop condition="len(sub_header1) lt 150">
<cfset sub_header1 = sub_header1&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header1#</td>
</td>	
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.SINDA")>
<cfif sinda_count gt 0>
<cfset total_sinda = #val(getList_qry.SD)# * 100 >
<cfset sub_header2 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#03"&"#numberformat(total_sinda,'000000000000')#"&"#numberformat(sinda_count,'0000000')#">
<cfloop condition="len(sub_header2) lt 150">
<cfset sub_header2 = sub_header2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.CDAC")>
<cfif cdac_count gt 0>
<cfset total_cdac = #val(getList_qry.cdac)# * 100 >
<cfset sub_header3 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#04"&"#numberformat(total_cdac,'000000000000')#"&"#numberformat(cdac_count,'0000000')#">
<cfloop condition="len(sub_header3) lt 150">
<cfset sub_header3 = sub_header3&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font</td>
	<td>#sub_header3#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.ECF")>
<cfif eu_count gt 0>
<cfset total_eu = (#val(getList_qry.eu)#) * 100>
<cfset sub_header4 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#05"&"#numberformat(total_eu,'000000000000')#"&"#numberformat(eu_count,'0000000')#">
<cfloop condition="len(sub_header4) lt 150">
<cfset sub_header4 = sub_header4&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header4#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfset total_cpf_penalty = (#val(BFCPF)# + #val(ICOLP)#) * 100 >
<cfif total_cpf_penalty gt 0>
<cfset sub_header5 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#07"&"#numberformat(total_cpf_penalty,'000000000000')#"&"#numberformat(0,'0000000')#">
<cfloop condition="len(sub_header5) lt 150">
<cfset sub_header5 = sub_header5&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header5#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.FWL")>
<cfif fwl_count gt 0>
<cfset total_fwl = (#val(sum_fwl)#) * 100>
<cfset sub_header6 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#08"&"#numberformat(total_fwl,'000000000000')#"&"#numberformat(0,'0000000')#">
<cfloop condition="len(sub_header6) lt 150">
<cfset sub_header6 = sub_header6&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header6#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfset total_fwl_penalty = #val(LPPFFWL)# * 100 >
<cfif total_fwl_penalty gt 0>
<cfset sub_header7 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#09"&"#numberformat(total_fwl_penalty,'000000000000')#"&"#numberformat(0,'0000000')#">
<cfloop condition="len(sub_header7) lt 150">
<cfset sub_header7 = sub_header7&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header7#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.CChest")>
<cfif cc_count gt 0>
<cfset total_cc = (#val(getList_qry.cc)#) * 100>
<cfset sub_header8 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#10"&"#numberformat(total_cc,'000000000000')#"&"#numberformat(cc_count,'0000000')#">
<cfloop condition="len(sub_header8) lt 150">
<cfset sub_header8 = sub_header8&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header8#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.SDL")>
<cfif sdl_count gt 0>
<cfset total_sdl = val(int(get_sdl_sum.sdl)) * 100>
<cfset sub_header9 = "#s_mode#"&"0#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#11"&"#numberformat(total_sdl,'000000000000')#"&"#numberformat(0,'0000000')#">
<cfloop condition="len(sub_header9) lt 150">
<cfset sub_header9 = sub_header9&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header9#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfquery name="getContent_qry" datasource="#dts#">
SELECT *, round(re_cpf_all) as r_re_cpf_all
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE a.epfcat = #cat# and a.epfno <> "" and a.paystatus = "A" AND b.payyes = "Y"
</cfquery>

<cfloop query="getContent_qry">
<cfset cpf_no = getContent_qry.epfno >
<cfset emp_acc_no = "#cpf_no#">
<cfloop condition="len(emp_acc_no) lt 9">
	<cfset emp_acc_no = emp_acc_no&" " >
</cfloop>


<cfset total_emp_cpf = #val(getContent_qry.r_re_cpf_all)# * 100 >
<cfset total_emp_cpf = #numberformat(total_emp_cpf,'000000000000')# >

<cfset emp_gross_pay = (val(getContent_qry.epf_pay_a)-val(getContent_qry.additionalwages))*100>
<cfset emp_gross_pay = #numberformat(emp_gross_pay,'0000000000')# >
<cfset emp_gross_pay1 = ((#val(getContent_qry.epf_pay_b)# + #val(getContent_qry.epf_pay_c)#)+val(getContent_qry.additionalwages))* 100>
<cfset emp_gross_pay1 = #numberformat(emp_gross_pay1,'0000000000')# >

<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset startdate= createdate(yrs,mon,1)>
<cfset days = daysinmonth(startdate)>
<cfset lastdate = createdate(yrs,mon,days)>

<cfset startdate = #dateformat(startdate,'YYYYMMDD')#>
<cfset lastdate = #dateformat(lastdate,'YYYYMMDD')#>

<cfset dateconfirm = #dateformat(getContent_qry.dconfirm,'YYYYMMDD')# >
<cfset dateresign =  #dateformat(getContent_qry.dresign,'YYYYMMDD')# >

<cfif #dateconfirm# gte #startdate# and #dateresign# eq "">
<cfset emp_status1 = "N">

<cfelseif  #dateconfirm# gte #startdate# and #dateresign# lte #lastdate#>
<cfset emp_status1 = "O">

<cfelseif #dateresign# lte #lastdate# and #dateresign# neq "">
<cfset emp_status1 = "L">

<cfelse>
<cfset emp_status1 = "E">

</cfif>

<cfset name1 = #UCASE(getContent_qry.name)# > 
<cfset name1 = rereplacenocase(name1,'[^A-Za-z0-9_ ]','','all')>
<cfset name_list = Left(name1, 22) >


<cfif #total_emp_cpf# neq 0 OR #emp_gross_pay1# neq 0 OR #emp_gross_pay# neq 0>
<cfset content = "#s_mode#"&"1#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#01"&"#emp_acc_no##total_emp_cpf##emp_gross_pay#"&"#emp_gross_pay1#"&"#emp_status1##name_list#">
<cfloop condition="len(content) lt 150">
<cfset content = content&" " >
</cfloop>
<cfset no = no +1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content#</td>
</tr>
<cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.MBMF")>
<cfif #getContent_qry.ded111# gt 0 or #getContent_qry.ded109# gt 0>
<cfset con_total_mbmf = (#val(getContent_qry.ded111)# + #val(getContent_qry.ded109)#) * 100>
<cfset con_total_mbmf = #numberformat(con_total_mbmf, '000000000000')#>
<cfif #con_total_mbmf# neq 0>
<cfset content1 = "#s_mode#"&"1#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#02"&"#emp_acc_no##con_total_mbmf#0000000000"&"0000000000"&" #name_list#">
<cfloop condition="len(content1) lt 150">
<cfset content1 = content1&" " >
</cfloop>
<cfset no = no +1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content1#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif isdefined("form.SINDA")>
<cfif #getContent_qry.ded113# neq "">
<cfset con_total_sinda = (#val(getContent_qry.ded113)#) * 100>
<cfset con_total_sinda = #numberformat(con_total_sinda, '000000000000')#>
<cfif #con_total_sinda# neq 0>
<cfset content2 = "#s_mode#"&"1#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#03"&"#emp_acc_no##con_total_sinda#0000000000"&"0000000000"&" #name_list#">
<cfloop condition="len(content2) lt 150">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no +1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif isdefined("form.CDAC")>
<cfif #getContent_qry.ded114# neq "">
<cfset con_total_CDAC = (#val(getContent_qry.ded114)#) * 100>
<cfset con_total_CDAC = #numberformat(con_total_CDAC, '000000000000')#>
<cfif #con_total_CDAC# neq 0>
<cfset content3 = "#s_mode#"&"1#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#04"&"#emp_acc_no##con_total_CDAC#0000000000"&"0000000000"&" #name_list#">
<cfloop condition="len(content3) lt 150">
<cfset content3 = content3&" " >
</cfloop>
<cfset no = no +1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content3#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif isdefined("form.ECF")>
<cfif #getContent_qry.ded115# neq "">
<cfset con_total_EU = (#val(getContent_qry.ded115)#) * 100>
<cfset con_total_EU = #numberformat(con_total_EU, '000000000000')#>
<cfif #con_total_EU# neq 0>
<cfset content4 = "#s_mode#"&"1#CSN#"&" "&"01"&"#dateformat(CPF_M,'YYYYMM')#05"&"#emp_acc_no##con_total_EU#0000000000"&"0000000000"&" #name_list#">
<cfloop condition="len(content4) lt 150">
<cfset content4 = content4&" " >
</cfloop>
<cfset no = no +1>
<tr>
	<td><font size="4" color="black">#no#.</font</td>
	<td><font size="3" >#content4#</font</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

</cfloop>

<cfset total_record_count = total_record_count + 1 >

<cfset total_empcc_contrib = val(total_epf_a) >
 <!---<cfoutput>#total_empcc_contrib#<br></cfoutput> --->
<cfif isdefined("form.MBMF")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.MF)# + #val(getList_qry.MB)# >
</cfif>

<cfif isdefined("form.CChest")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.cc)# >
</cfif>

<cfif isdefined("form.SINDA")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.SD)# >
</cfif>

<cfif isdefined("form.CDAC")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.CDAC)# >
</cfif>

<cfif isdefined("form.ECF")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(getList_qry.EU)# >
</cfif>

<cfif isdefined("form.FWL")>
<cfset total_empcc_contrib = total_empcc_contrib + #val(sum_fwl)# >
</cfif>

<cfif isdefined("form.SDL")>
<cfset total_empcc_contrib = total_empcc_contrib + #int(val(get_sdl_sum.sdl))# >
</cfif>

<cfset total_empcc_contrib = total_empcc_contrib * 100 >



<cfset total_empcc_contrib = #numberformat(total_empcc_contrib, '000000000000000')#>
<cfset total_record_count =  #numberformat(total_record_count+1, '0000000')#>
<cfset content5 = "#s_mode#"&"9#CSN#"&" "&"01"&"#total_record_count#"&"#total_empcc_contrib#">
<cfloop condition="len(content5) lt 150">
<cfset content5 = content5&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content5#</td>
</tr>
<cfset s_date = #UCASE(DATEFORMAT(CPF_M,'MMMYYYY'))# >
<cfset filename="#CSN#"&"#s_date#"&"01">

</table>
<!--- <cffile action = "rename" source = "#filedir#" destination = "#filenewdir##filename#.DTL">
 --->


</cfoutput>




 