<cfquery name="getList_qry" datasource="#dts#">
SELECT epfbyer,epfbyee,a.empno,b.empno,name,epfno,p_epfww,epfwwext,p_epfcc,epfccext,cpf_amt,epf_pay_b,epf_pay_c,epfcat,
b_epfww,b_epfcc,c_epfcc,c_epfww,re_cpf_all,b.additionalwages
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = '#form.cat#' AND b.payyes="Y" AND paystatus = "A" and confid >= #hpin# 
<cfif form.empno neq "">AND  a.empno>='#form.empno#'</cfif><cfif form.empno1 neq "">AND a.empno<='#form.empno1#'</cfif>
<cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif> 
order by b.empno asc
</cfquery>

<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset month = getComp_qry.mmonth>
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
	<tr><td colspan="9" align="center"><h1>CPF LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="9">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="9"><hr></td></tr>
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
	<tr><td colspan="9"><hr></td></tr>
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
				<td width="140px" align="right"> #numberformat(ord_wages-val(getList_qry.additionalwages),".__")#</td>
				<td width="140px" align="right">#numberformat(add_wages+val(getList_qry.additionalwages),".__")#</td>
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
	<tr><td colspan="9" align="center"><h1>CPF LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="9">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="9"><hr></td></tr>
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
	<tr><td colspan="9"><hr></td></tr>
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