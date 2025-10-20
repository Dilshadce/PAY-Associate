<cfset paytable = "pay_tm">
<cfset commtable = "comm">
<cfif isdefined('form.month')>
<cfset paytable = form.paytype>
<cfset commtable = "comm_12m">
<cfset paytable1 = "pay1_12m_fig">
</cfif>
<cfquery name="getList_qry" datasource="#dts#">

SELECT epfbyer,epfbyee,a.empno,b.empno,name,epfno,e.jname,national,
<cfif isdefined('form.month')>epfww as </cfif>p_epfww,
epfwwext,
<cfif isdefined('form.month')>epfcc as </cfif>p_epfcc,
epfccext,<cfif isdefined('form.month')>epf_pay_a as </cfif>cpf_amt,epf_pay_b,epf_pay_c,epfcat,b.ded101,b.grosspay,b.netpay,f.np,
<cfif isdefined('form.month')>0 as </cfif>b_epfww,
<cfif isdefined('form.month')>0 as </cfif>b_epfcc,
<cfif isdefined('form.month')>0 as </cfif>c_epfcc,
<cfif isdefined('form.month')>0 as </cfif>c_epfww,
<cfif isdefined('form.month')>epfww+epfcc as </cfif>re_cpf_all,
b.additionalwages,b.ded109,b.ded111,b.ded113,b.ded114,b.ded110,b.ded115,c.levy_sd
FROM pmast AS a LEFT JOIN (SELECT * FROM #paytable# <cfif isdefined('form.month')>WHERE tmonth = "#form.month#"</cfif>) AS b ON a.empno=b.empno
LEFT JOIN (SELECT LEVY_SD,empno FROM #commtable# <cfif isdefined('form.month')>WHERE tmonth = "#form.month#"</cfif>) as c on a.empno = c.empno
LEFT JOIN (SELECT * FROM (SELECT jobcode,empno as dempno FROM #replace(dts,'_p','_i')#.placement order by created_on desc) as aa GROUP BY aa.dempno ) as d
on a.empno = d.dempno
LEFT JOIN (SELECT name as jname,driverno FROM #replace(dts,'_p','_i')#.driver) as e
on d.jobcode = e.driverno 
LEFT JOIN
(SELECT empno as empn, netpay as np FROM <cfif isdefined('form.month')>pay2_12m_fig<cfelse>paytran</cfif> <cfif isdefined('form.month')>WHERE tmonth = "#form.month#"</cfif>) as f
on a.empno = f.empn
WHERE epfcat = '<cfif isdefined('form.month')>1<cfelse>#form.cat#</cfif>' AND <cfif isdefined('form.month')>b.netpay <> 0<cfelse>b.payyes="Y" AND b.netpay <> 0</cfif> <cfif isdefined('form.month') eq false>AND paystatus = "A"</cfif> and confid >= #hpin# 
<cfif form.empno neq "">AND  a.empno>='#form.empno#'</cfif><cfif form.empno1 neq "">AND a.empno<='#form.empno1#'</cfif>
<cfif isdefined('form.month')>
<cfelse>
<cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif> 
</cfif>
order by b.empno asc
</cfquery>

<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset month = getComp_qry.mmonth>
<cfif isdefined('form.month')>
<cfset month = form.month>
</cfif>
<cfset year = getComp_qry.myear>
<!--- <cfset month = #month(Now())#>
<cfset year = #year(Now())#> --->

<cfswitch expression="#form.result#">
	
<cfcase value="HTML">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF Listing</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="23" align="center"><h1>CPF LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="23">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="23"><hr></td></tr>
	<tr>
		<td width="50px" align="center">ITEM</td>
		<td width="100px" align="center">EMPNO.</td>
		<td width="250px" align="center">NAME</td>
        
		<td width="140px" align="center">CPF A/C NO.</td>
        <td width="140px" align="center">POSITION</td>
		<td width="140px" align="center">CPF Y'EE</td>
		<td width="140px" align="center">CPF Y'ER</td>
		<td width="140px" align="center">TOTAL CPF</td>
		<td width="140px" align="center">ORDINARY WAGES</td>
		<td width="140px" align="center">ADDITIONAL WAGES</td>
        <td width="100px" align="center">CDAC</td>
        <td width="100px" align="center">MENDAKI</td>
        <td width="100px" align="center">MBMF</td>
        <td width="100px" align="center">SINDA</td>
        <td width="100px" align="center">CC</td>
        <td width="100px" align="center">ECF</td>
        <td width="100px" align="center">SDL</td>
        <td width="100px" align="center">TOTAL</td>
        <td width="100px" align="center">NS Claims</td>
        <td width="100px" align="center">2nd Pay</td>
        <td width="100px" align="center">Foreigners</td>
        <td width="100px" align="center">Net 1(w 2nd PD)</td>
        <td width="100px" align="center">Net 1(w/o 2nd PD)</td>
	</tr>
	<tr><td colspan="23"><hr></td></tr>
	<cfset i = 1>
	<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
    <cfset totalori = 0>
    <cfset totaladd = 0>
    <cfset alltotal = 0>
    <cfset cdactotal = 0>
    <cfset mendakitotal = 0>
    <cfset mbmftotal = 0>
    <cfset sindatotal = 0>
    <cfset cctotal = 0 >
    <cfset ecftotal = 0>
    <cfset levytotal = 0>
    <cfset nstotal = 0>
    <cfset spaytotal = 0>
    <cfset frtotal = 0 >
    <cfset net1w2 = 0>
    <cfset net1wo2 = 0>
	<cfoutput query="getList_qry">
	<cfif #getList_qry.epfbyer# eq "Y" and #getList_qry.epfbyee# eq "N">
		<cfset totcpf = val(round(getList_qry.re_cpf_all))>
		<cfset cpfyee = 0>
		<cfset cpfyer = totcpf>		
	<cfelse>	
		<cfset totcpf = val(round(getList_qry.re_cpf_all))>
		<cfset cpfyee = int(val(getList_qry.p_epfww) + val(getList_qry.epfwwext)+val(getList_qry.b_epfww)+val(getList_qry.c_epfww))>
		<cfset cpfyer = val(totcpf)- val(cpfyee)>
	</cfif>	
		
		<cfset ord_wages = val(getList_qry.cpf_amt)>
		<cfset add_wages = val(getList_qry.epf_pay_b) + val(getList_qry.epf_pay_c)>
		<!--- <cfif #totcpf# neq 0> --->
			<tr>
				<td width="50px" >#i#</td>
				<td width="100px">#getList_qry.empno#</td>
				<td width="250px">#getList_qry.name#</td>
                
				<td width="140px">#getList_qry.epfno#</td>
                <td>#getList_qry.jname#</td>
				<td width="140px" align="right"> #cpfyee#</td>
				<td width="140px" align="right">#cpfyer#</td>
				<td width="140px" align="right"> #totcpf#</td>
				<td width="140px" align="right"> #numberformat(ord_wages-val(getList_qry.additionalwages),".__")#</td>
                <cfset totalori = totalori + numberformat(ord_wages-val(getList_qry.additionalwages),".__")>
				<td width="140px" align="right">#numberformat(add_wages+val(getList_qry.additionalwages),".__")#</td>
                <cfset totaladd = totaladd + numberformat(add_wages+val(getList_qry.additionalwages),".__")>
                <td align="right">#numberformat(getList_qry.ded114,".__")#</td>
                <cfset cdactotal = cdactotal + numberformat(getList_qry.ded114,".__")>
                <td align="right">#numberformat(getList_qry.ded109,".__")#</td>
                <cfset mendakitotal = mendakitotal + numberformat(getList_qry.ded109,".__")>
                <td align="right">#numberformat(getList_qry.ded111,".__")#</td>
                <cfset mbmftotal = mbmftotal + numberformat(getList_qry.ded111,".__")>
                <td align="right">#numberformat(getList_qry.ded113,".__")#</td>
                <cfset sindatotal = sindatotal + numberformat(getList_qry.ded113,".__")>
                 <td align="right">#numberformat(getList_qry.ded110,".__")#</td>
                <cfset cctotal = cctotal + numberformat(getList_qry.ded110,".__")>
                <td align="right">#numberformat(getList_qry.ded115,".__")#</td>
                <cfset ecftotal = ecftotal + numberformat(getList_qry.ded115,".__")>
                <td align="right">#numberformat(getList_qry.levy_sd,".__")#</td>
                <cfset levytotal = levytotal + numberformat(getList_qry.levy_sd,".__")>
                <td align="right">#numberformat(val(totcpf)+val(getList_qry.ded113)+val(getList_qry.ded111)+val(getList_qry.ded109)+val(getList_qry.ded114)+val(getList_qry.levy_sd),".__")#</td>
                <td align="right">#numberformat(getList_qry.ded101,".__")#</td>
                 <cfset nstotal = nstotal + numberformat(getList_qry.ded101,".__")>
                <td align="right">#numberformat(getList_qry.np,".__")#</td>
    			<cfset spaytotal = spaytotal + numberformat(getList_qry.np,".__")>
                <td align="right"><cfif val(ord_wages) eq 0><cfset frtotal = frtotal +  numberformat(getList_qry.netpay,".__")>#numberformat(getList_qry.netpay,".__")#<cfelse>0.00</cfif></td>
    			<td align="right">#numberformat(getList_qry.netpay,".__")#</td>
    			<cfset net1w2 = net1w2 + numberformat(getList_qry.netpay,".__")>
                <cfset net1new = numberformat(getList_qry.netpay,".__")-numberformat(getList_qry.np,".__")>
                <td align="right">#numberformat(net1new,".__")#</td>
    			<cfset net1wo2 = net1wo2 + numberformat(net1new,".__")>
                <cfset alltotal = alltotal + numberformat(val(totcpf)+val(getList_qry.ded113)+val(getList_qry.ded111)+val(getList_qry.ded109)+val(getList_qry.ded114)+val(getList_qry.levy_sd)+val(getList_qry.ded110)+val(getList_qry.ded115),".__")>
			</tr>
			<cfset i = i + 1>
			<cfset p = p + cpfyee>
			<cfset q = q + cpfyer>
			<cfset r = r + val(totcpf)>
		<!--- </cfif> --->
	</cfoutput>
	
	<tr>
		<td colspan="5" align="left">&nbsp</td>		
		<td width="140px"><hr></td>
		<td width="140px"><hr></td>
		<td width="140px"><hr></td>
		<td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
        <td><hr /></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="5" align="left">TOTAL:</td>		
		<td width="140px" align="right">#numberformat(p,"0")#</td>
		<td width="140px" align="right">#numberformat(q,"0")#</td>
		<td width="140px" align="right">#numberformat(r,"0")#</td>
		<td align="right">#numberformat(totalori,'.__')#</td>
        <td align="right">#numberformat(totaladd,'.__')#</td>
        <td align="right">#numberformat(cdactotal,'.__')#</td>
        <td align="right">#numberformat(mendakitotal,'.__')#</td>
        <td align="right">#numberformat(mbmftotal,'.__')#</td>
        <td align="right">#numberformat(sindatotal,'.__')#</td>
        <td align="right">#numberformat(cctotal,'.__')#</td>
        <td align="right">#numberformat(ecftotal,'.__')#</td>
        <td align="right">#numberformat(levytotal,'.__')#</td>
        <td align="right">#numberformat(alltotal,'.__')#</td>
        <td align="right">#numberformat(nstotal,'.__')#</td>
        <td align="right">#numberformat(spaytotal,'.__')#</td>
        <td align="right">#numberformat(frtotal,'.__')#</td>
        <td align="right">#numberformat(net1w2,'.__')#</td>
        <td align="right">#numberformat(net1wo2,'.__')#</td>
	</tr>
	<tr>
		<td colspan="5" align="left">&nbsp</td>		
		<td width="140px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
		<td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
          <td><hr /><hr></td>
          <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
        <td><hr /><hr></td>
	</tr>
	
	</cfoutput>
	<cfif getList_qry.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
	</cfif>
</table>

<div>
</body>
</html>

</cfcase>

<cfcase value="EXCELDEFAULT">
<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=CPFListingReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF Listing</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="23" align="center"><h1>CPF LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="23">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="23"><hr></td></tr>
	<tr>
		<td width="50px" align="center">ITEM</td>
		<td width="100px" align="center">EMPNO.</td>
		<td width="250px" align="center">NAME</td>
		<td width="140px" align="center">CPF A/C NO.</td>
		<td width="140px" align="center">CPF Y'EE</td>
		<td width="140px" align="center">CPF Y'ER</td>
		<td width="140px" align="center">TOTAL CPF</td>
		<td width="140px" align="center">ORDINARY WAGES</td>
		<td width="140px" align="center">ADDITIONAL WAGES</td>
	</tr>
	<tr><td colspan="23"><hr></td></tr>
	<cfset i = 1>
	<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
	<cfoutput query="getList_qry">
		
	<cfif #getList_qry.epfbyer# eq "Y" and #getList_qry.epfbyee# eq "N">
		<cfset totcpf = val(round(getList_qry.re_cpf_all))>
		<cfset cpfyee = 0>
		<cfset cpfyer = totcpf>
	<cfelse>	
		<cfset totcpf = val(round(getList_qry.re_cpf_all))>
		<cfset cpfyee = int(val(getList_qry.p_epfww) + val(getList_qry.epfwwext)+val(getList_qry.b_epfww)+val(getList_qry.c_epfww))>
		<cfset cpfyer = val(totcpf)- val(cpfyee)>
	</cfif>	
		
		<cfset ord_wages = val(getList_qry.cpf_amt)>
		<cfset add_wages = val(getList_qry.epf_pay_b) + val(getList_qry.epf_pay_c)>
		<cfif #totcpf# neq 0>
			<tr>
				<td width="50px" >#i#</td>
				<td width="100px">#getList_qry.empno#</td>
				<td width="250px">#getList_qry.name#</td>
				<td width="140px">#getList_qry.epfno#</td>
				<td width="140px" align="right"> #cpfyee#</td>
				<td width="140px" align="right">#cpfyer#</td>
				<td width="140px" align="right"> #totcpf#</td>
				<td width="140px" align="right"> #numberformat(ord_wages,".__")#</td>
				<td width="140px" align="right">#numberformat(add_wages,".__")#</td>
			</tr>
			<cfset i = i + 1>
			<cfset p = p + cpfyee>
			<cfset q = q + cpfyer>
			<cfset r = r + val(totcpf)>
		</cfif>
	</cfoutput>
	
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="140px"><hr></td>
		<td width="140px"><hr></td>
		<td width="140px"><hr></td>
		<td width="140px">&nbsp</td>
		<td width="140px">&nbsp</td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="4" align="left">TOTAL:</td>		
		<td width="140px" align="right">#numberformat(p,"0")#</td>
		<td width="140px" align="right">#numberformat(q,"0")#</td>
		<td width="140px" align="right">#numberformat(r,"0")#</td>
		<td width="140px" align="right">&nbsp</td>
		<td width="140px" align="right">&nbsp</td>
	</tr>
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="140px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
		<td width="140px">&nbsp</td>
		<td width="140px">&nbsp</td>
	</tr>
	
	</cfoutput>
	<cfif getList_qry.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
	</cfif>
</table>

<div>
</body>
</html>
<cfoutput>
<cfdocumentitem type="footer">
	<font size="2">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</font>
</cfdocumentitem>
</cfoutput>
</body>
</html>
</cfdocument>
	</cfcase>

</cfswitch>