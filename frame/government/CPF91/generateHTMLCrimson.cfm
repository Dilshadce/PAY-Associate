<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<title>CPF91 Payment Advice</title>
<cfset no = 0>
CRIMSON
<font size="5" color="blue"><i><center>CPF91 Payment Advice Report</center></i></font>
<hr>
<cfquery name="getComp_qry" datasource="payroll_main">
SELECT c_acfwl,comp_name FROM gsetup WHERE comp_id = "#HcomID#"
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
	select sum(levy_fw_w) as fwlevy from comm as c left join 
		(SELECT a.empno FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
			WHERE epfcat = #cat# and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y") 
	as d on c.empno=d.empno where levy_fw_w <> ''
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
		select levy_fw_w from comm as c left join
		(SELECT a.empno FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
			WHERE epfcat = 1 and epfno <> "" and a.paystatus = "A" AND b.payyes = "Y")
		as d on c.empno=d.empno where levy_fw_w <> ''
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


<cfset total_epf = total_epf_a>
<cfset CSN = "#uen#"&"#paytype#"&"#numberformat(serial_num,'00')#">

<cfset new_s_date = #dateformat(s_date,'ddmmyyyy')# >
<cfset header = "UNB"&" "&"CPFPAY">
<cfloop condition="len(header) lt 255">
<cfset header = header&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header#</td>
</tr>
   
<cfset header1 = "UNH"&" "&"CPFPAY20">
<cfloop condition="len(header1) lt 255">
<cfset header1 = header1&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header1#</td>
</tr>
   
<cfset header2 = "BGM"&" "&"450">
<cfloop condition="len(header2) lt 255">
<cfset header2 = header2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header2#</td>
</tr>
   
<cfset header3 = "DTM"&" "&"137"&dateformat(s_date,'YYYYMMDD')>
<cfloop condition="len(header3) lt 255">
<cfset header3 = header3&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header3#</td>
</tr>
   
<cfset header4 = "DTM"&" "&"335"&dateformat(CPF_M,'YYYYMM')>
<cfloop condition="len(header4) lt 255">
<cfset header4 = header4&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header4#</td>
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
  
<cfset sub_header = "MOA"&" "&"AV1"&val(total_epf)>
<cfloop condition="len(sub_header) lt 255">
	<cfset sub_header = sub_header&" " >
</cfloop>   
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header#</td>
</tr>
   
<cfif isdefined("form.CChest")>
<cfif cc_count gt 0>
<cfset total_cc = val(getList_qry.cc)>
<cfset sub_header1 = "MOA"&" "&"AV3"&numberformat(val(total_cc),'.__')>
<cfloop condition="len(sub_header1) lt 255">
<cfset sub_header1 = sub_header1&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header1#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.SDL")>
<cfif sdl_count gt 0>
<cfset total_sdl = val(int(get_sdl_sum.sdl))>
<cfset sub_header2 = "MOA"&" "&"AV4"&numberformat(val(total_sdl),'.__')>
<cfloop condition="len(sub_header2) lt 255">
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

<cfif isdefined("form.MBMF")>
<cfif mbmf_count gt 0>
<cfset mbmf = #val(getList_qry.mb)# + #val(getList_qry.mf)#>
<cfset sub_header3 = "MOA"&" "&"AV5"&numberformat(val(mbmf),'.__')>
<cfloop condition="len(sub_header3) lt 255">
<cfset sub_header3 = sub_header3&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header3#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.FWL")>
<cfif fwl_count gt 0>
<cfset total_fwl = val(sum_fwl)>
<cfset sub_header4 = "MOA"&" "&"AV7"&numberformat(val(total_fwl),'.__')>
<cfloop condition="len(sub_header4) lt 255">
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

<cfset total_fwl_penalty = val(LPPFFWL)>
<cfif total_fwl_penalty gt 0>
<cfset sub_header5 = "MOA"&" "&"AV8"&numberformat(val(total_fwl_penalty),'.__')>
<cfloop condition="len(sub_header5) lt 255">
<cfset sub_header5 = sub_header5&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header5#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>


<cfset total_cpf_penalty = (#val(BFCPF)# + #val(ICOLP)#) >
<cfif total_cpf_penalty gt 0>
<cfset sub_header6 = "MOA"&" "&"AV9"&numberformat(val(total_cpf_penalty),'.__')>
<cfloop condition="len(sub_header6) lt 255">
<cfset sub_header6 = sub_header6&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header6#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.SINDA")>
<cfif sinda_count gt 0>
<cfset total_sinda = val(getList_qry.SD) >
<cfset sub_header7 = "MOA"&" "&"AVA"&numberformat(val(total_sinda),'.__')>
<cfloop condition="len(sub_header7) lt 255">
<cfset sub_header7 = sub_header7&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#sub_header7#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>

<cfif isdefined("form.CDAC")>
<cfif cdac_count gt 0>
<cfset total_cdac = val(getList_qry.cdac) >
<cfset sub_header8 = "MOA"&" "&"AVE"&numberformat(val(total_cdac),'.__')>
<cfloop condition="len(sub_header8) lt 255">
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


<cfif isdefined("form.ECF")>
<cfif eu_count gt 0>
<cfset total_eu = val(getList_qry.eu)>
<cfset sub_header9 = "MOA"&" "&"AVG"&numberformat(val(total_eu),'.__')>
<cfloop condition="len(sub_header9) lt 255">
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

<cfif len(CSN) gt 15>
<cfset CSN = RIGHT(CSN,15)>
<cfelseif len(CSN) lt 15>
<cfloop condition="len(CSN) lt 15">
<cfset CSN = CSN&" " >
</cfloop>
</cfif>
<cfset compname = getComp_qry.comp_name>
<cfif len(compname) gt 35>
<cfset compname = LEFT(compname,35)>
</cfif>

<cfset header5 = "NAD"&" "&"BG"&" "&CSN&" "&compname>
<cfloop condition="len(header5) lt 255">
<cfset header5 = header5&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header5#</td>
</tr>

<cfset header6 = "RFF"&" "&"ALL"&numberformat(form.payadvice,'00')>
<cfloop condition="len(header6) lt 255">
<cfset header6 = header6&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#header6#</td>
</tr>

<cfif isdefined("form.MBMF")>
<cfif mbmf_count gt 0>
<cfset qtyheader = "QTY"&" "&"MUS"&mbmf_count>
<cfloop condition="len(qtyheader) lt 255">
<cfset qtyheader = qtyheader&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#qtyheader#</td>
</tr>
</cfif>
</cfif>

<cfif isdefined("form.CChest")>
<cfif cc_count gt 0>
<cfset qtyheader1 = "QTY"&" "&"SHA"&cc_count>
<cfloop condition="len(qtyheader1) lt 255">
<cfset qtyheader1 = qtyheader1&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#qtyheader1#</td>
</tr>
</cfif>
</cfif>

<cfif isdefined("form.SINDA")>
<cfif sinda_count gt 0>
<cfset qtyheader2 = "QTY"&" "&"SIN"&sinda_count>
<cfloop condition="len(qtyheader2) lt 255">
<cfset qtyheader2 = qtyheader2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#qtyheader2#</td>
</tr>
</cfif>
</cfif>

<cfif isdefined("form.CDAC")>
<cfif cdac_count gt 0>
<cfset qtyheader3 = "QTY"&" "&"CDA"&cdac_count>
<cfloop condition="len(qtyheader3) lt 255">
<cfset qtyheader3 = qtyheader3&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#qtyheader3#</td>
</tr>
</cfif>
</cfif>

<cfif isdefined("form.ECF")>
<cfif eu_count gt 0>
<cfset qtyheader4 = "QTY"&" "&"ECF"&eu_count>
<cfloop condition="len(qtyheader3) lt 255">
<cfset qtyheader4 = qtyheader4&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#qtyheader4#</td>
</tr>
</cfif>
</cfif>





<cfquery name="getContent_qry" datasource="#dts#">
SELECT *, round(re_cpf_all) as r_re_cpf_all
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE a.epfcat = #cat# and a.epfno <> "" and a.paystatus = "A"
</cfquery>

<cfloop query="getContent_qry">
<cfset cpf_no = getContent_qry.epfno >
<cfset emp_acc_no = "#cpf_no#">
<cfloop condition="len(emp_acc_no) lt 9">
	<cfset emp_acc_no = emp_acc_no&" " >
</cfloop>


<cfset total_emp_cpf = #val(getContent_qry.r_re_cpf_all)#  >
<cfset emp_gross_pay = (#val(getContent_qry.epf_pay_a)#-val(getContent_qry.additionalwages))>
<cfset emp_gross_pay1 = (#val(getContent_qry.epf_pay_b)# + #val(getContent_qry.epf_pay_c)#+val(getContent_qry.additionalwages))>

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

<cfset dateconfirm = #dateformat(getContent_qry.dcomm,'YYYYMMDD')# >
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
<cfset name_list = Left(name1, 22) >


<cfif #total_emp_cpf# neq 0 and (#emp_gross_pay1# neq 0 OR #emp_gross_pay# neq 0)>
<cfif emp_status1 eq "L" or emp_status1 eq "E">
<cfset content = "MOA"&" "&"AV2"&total_emp_cpf>
<cfloop condition="len(content) lt 255">
<cfset content = content&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content#</td>
</tr>
<cfset total_record_count = total_record_count + 1 >


<cfif isdefined("form.MBMF")>
<cfif #getContent_qry.ded111# gt 0 or #getContent_qry.ded109# gt 0>
<cfset con_total_mbmf = (#val(getContent_qry.ded111)# + #val(getContent_qry.ded109)#)>
<cfif #con_total_mbmf# neq 0>
<cfset content1 = "MOA"&" "&"AV6"&numberformat(con_total_mbmf,'.__')>
<cfloop condition="len(content1) lt 255">
<cfset content1 = content1&" " >
</cfloop>
<cfset no = no + 1>
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
<cfset con_total_sinda = (#val(getContent_qry.ded113)#) >
<cfif #con_total_sinda# neq 0>
<cfset content2 = "MOA"&""&"AVB"&numberformat(con_total_sinda,'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif val(emp_gross_pay) neq 0>
<cfset content2 = "MOA"&" "&"AVC"&numberformat(val(emp_gross_pay),'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif val(emp_gross_pay1) neq 0>
<cfset content2 = "MOA"&" "&"AVD"&numberformat(val(emp_gross_pay1),'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.CDAC")>
<cfif #getContent_qry.ded114# neq "">
<cfset con_total_CDAC = (#val(getContent_qry.ded114)#)>
<cfif #con_total_CDAC# neq 0>
<cfset content3 = "MOA"&" "&"AVF"&numberformat(con_total_CDAC,'.__')>
<cfloop condition="len(content3) lt 255">
<cfset content3 = content3&" " >
</cfloop>
<cfset no = no + 1>
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
<cfset con_total_EU = (#val(getContent_qry.ded115)#)>
<cfif #con_total_EU# neq 0>
<cfset content4 = "MOA"&" "&"ACH"&numberformat(con_total_EU,'.__')>
<cfloop condition="len(content4) lt 255">
<cfset content4 = content4&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content4#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>


<cfset empdetail = "NAD"&" "&"PE"&" "&emp_acc_no&" "&name_list>
<cfloop condition="len(empdetail) lt 255">
<cfset empdetail = empdetail&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#empdetail#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >

<cfif emp_status1 eq "L">
<cfset termidate = "DTM"&" "&"337"&dateresign>
<cfloop condition="len(termidate) lt 255">
<cfset termidate = termidate&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#termidate#</td>
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
<cfset total_fwl_penalty = val(LPPFFWL)>
<cfif total_fwl_penalty gt 0>
<cfset total_empcc_contrib = total_empcc_contrib + val(total_fwl_penalty)>
</cfif>
<cfset total_cpf_penalty = (#val(BFCPF)# + #val(ICOLP)#) >
<cfif total_cpf_penalty gt 0>
<cfset total_empcc_contrib = total_empcc_contrib + val(total_cpf_penalty)>
</cfif>

<cfset total_empcc_contrib = total_empcc_contrib>

<cfset content5 = "CNT"&" "&"128"&#numberformat(total_empcc_contrib,'.__')#>
<cfloop condition="len(content5) lt 255">
<cfset content5 = content5&" " >
</cfloop>

<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content5#</td>
</tr>
   

<cfloop query="getContent_qry">
<cfset cpf_no = getContent_qry.epfno >
<cfset emp_acc_no = "#cpf_no#">
<cfloop condition="len(emp_acc_no) lt 9">
	<cfset emp_acc_no = emp_acc_no&" " >
</cfloop>


<cfset total_emp_cpf = #val(getContent_qry.r_re_cpf_all)#  >
<cfset emp_gross_pay = (#val(getContent_qry.epf_pay_a)#-val(getContent_qry.additionalwages))>
<cfset emp_gross_pay1 = (#val(getContent_qry.epf_pay_b)# + #val(getContent_qry.epf_pay_c)#+val(getContent_qry.additionalwages))>

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

<cfset dateconfirm = #dateformat(getContent_qry.dcomm,'YYYYMMDD')# >
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
<cfset name_list = Left(name1, 22) >


<cfif #total_emp_cpf# neq 0 and (#emp_gross_pay1# neq 0 OR #emp_gross_pay# neq 0)>
<cfif emp_status1 eq "N" or emp_status1 eq "O">

<cfset empdetail = "NAD"&" "&"PE"&" "&emp_acc_no&" "&name_list>
<cfloop condition="len(empdetail) lt 255">
<cfset empdetail = empdetail&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#empdetail#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >


<cfset content = "MOA"&" "&"AV2"&total_emp_cpf>
<cfloop condition="len(content) lt 255">
<cfset content = content&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content#</td>
</tr>
<cfset total_record_count = total_record_count + 1 >


<cfif isdefined("form.MBMF")>
<cfif #getContent_qry.ded111# gt 0 or #getContent_qry.ded109# gt 0>
<cfset con_total_mbmf = (#val(getContent_qry.ded111)# + #val(getContent_qry.ded109)#)>
<cfif #con_total_mbmf# neq 0>
<cfset content1 = "MOA"&" "&"AV6"&numberformat(con_total_mbmf,'.__')>
<cfloop condition="len(content1) lt 255">
<cfset content1 = content1&" " >
</cfloop>
<cfset no = no + 1>
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
<cfset con_total_sinda = (#val(getContent_qry.ded113)#) >
<cfif #con_total_sinda# neq 0>
<cfset content2 = "MOA"&" "&"AVB"&numberformat(con_total_sinda,'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif val(emp_gross_pay) neq 0>
<cfset content2 = "MOA"&" "&"AVC"&numberformat(val(emp_gross_pay),'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif val(emp_gross_pay1) neq 0>
<cfset content2 = "MOA"&" "&"AVD"&numberformat(val(emp_gross_pay1),'.__')>
<cfloop condition="len(content2) lt 255">
<cfset content2 = content2&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content2#</td>
</tr>
<cfset total_record_count = total_record_count + 1 >
</cfif>

<cfif isdefined("form.CDAC")>
<cfif #getContent_qry.ded114# neq "">
<cfset con_total_CDAC = (#val(getContent_qry.ded114)#)>
<cfif #con_total_CDAC# neq 0>
<cfset content3 = "MOA"&" "&"AVF"&numberformat(con_total_CDAC,'.__')>
<cfloop condition="len(content3) lt 255">
<cfset content3 = content3&" " >
</cfloop>
<cfset no = no + 1>
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
<cfset con_total_EU = (#val(getContent_qry.ded115)#)>
<cfif #con_total_EU# neq 0>
<cfset content4 = "MOA"&" "&"ACH"&numberformat(con_total_EU,'.__')>
<cfloop condition="len(content4) lt 255">
<cfset content4 = content4&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#content4#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>
</cfif>
</cfif>

<cfif emp_status1 eq "O">
<cfset termidate = "DTM"&" "&"337"&dateresign>
<cfloop condition="len(termidate) lt 255">
<cfset termidate = termidate&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#termidate#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >
</cfif>


</cfif>
</cfif>
</cfloop>

<cfset RES = "RES"&" "&"ZZ">
<cfloop condition="len(RES) lt 255">
<cfset RES = RES&" " >
</cfloop>
<cfset no = no + 1>
<tr>
	<td><font size="4" color="black">#no#.</font></td>
	<td>#RES#</td>
</tr>
   <cfset total_record_count = total_record_count + 1 >

<cfset s_date = #UCASE(DATEFORMAT(CPF_M,'MMMYYYY'))# >
<cfset filename="CRIMSON"&"#s_date#"&"01">


 </table>
 
 </cfoutput>

         
