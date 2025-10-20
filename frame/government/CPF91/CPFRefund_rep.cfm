<cfquery name="getList_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN bonu_12m AS b ON a.empno=b.empno
WHERE paystatus = "A" 
AND epfcat = '#form.cat#' and confid >= #hpin#
<cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>

<cfquery name="get_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN comm_12m AS c ON a.empno=c.empno
WHERE paystatus = "A" AND epfcat = '#form.cat#' 
and confid >= #hpin#
<cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>

<cfquery name="List_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN pay_12m AS d ON a.empno=d.empno
WHERE paystatus = "A"
and confid >= #hpin#
AND epfcat = '#form.cat#' 
<cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>


<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset date = #dateFormat(Now(),"dd/mm/yyyy")#>


<cfswitch expression="#form.result#">
	
<cfcase value="HTML">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF Refund</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfloop query="getList_qry">
 		<cfset addwagespaid = val(getList_qry.epf_pay)+val(get_qry.epf_pay)>
		<cfset Paid = val(getList_qry.epfww)+val(getList_qry.epfcc)+val(get_qry.epfww)+val(get_qry.epfcc)>
		<cfset Payable = val(List_qry.tawcpfcc)+val(List_qry.tawcpfww)>
		<cfset Excess = (val(getList_qry.epfww)+val(getList_qry.epfcc) + val(get_qry.epfww)+val(get_qry.epfcc)) - (val(List_qry.tawcpfcc)+val(List_qry.tawcpfww))>
		<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
	<cfset s = 0>
	<cfset t = 0>
	<cfset p = p + val(getList_qry.epf_pay)+val(get_qry.epf_pay)>
	<cfset q = q + val(List_qry.tawcpf)>
	<cfset r = r + val(getList_qry.epfww)+val(getList_qry.epfcc)+val(get_qry.epfww)+val(get_qry.epfcc)>
	<cfset s = s + val(List_qry.tawcpfcc)+val(List_qry.tawcpfww)>
	<cfset t = t + (val(getList_qry.epfww)+val(getList_qry.epfcc) + val(get_qry.epfww)+val(get_qry.epfcc)) - (val(List_qry.tawcpfcc)+val(List_qry.tawcpfww))>
<cfif #q# neq 0 OR #r# neq 0 OR #s# neq 0 OR #t# neq 0> 
<cfoutput>
<div>
<p style="page-break-after:always">
<table width="100%">
	 <cfoutput> 
	<tr>
		<td width="100px">Employee No.</td>
		<td width="120px">#getList_qry.EMPNO#</td>
	</tr>
	<tr>
		<td width="100px">Employee Name</td>
		<td width="250px" colspan="3">#getList_qry.name#</td>
	</tr>
	<tr>
		<td width="100px">CPF Ref. No.</td>
		<td width="120px">#getList_qry.epfno#</td>
	</tr>
	 </cfoutput> 
	<tr><td colspan="6"><hr></td></tr>
	<tr>
		<td width="120px" rowspan="3">(1) Month</td>
		<td width="120px" rowspan="3">(2) Additional Wages Paid</td>
		<td width="120px" rowspan="3">(3) Additional Wages Ceiling</td>
		<td colspan="3" align="center">Contribution On AW</td>
	</tr>
	<tr>
		<td colspan="3"><hr></td>
	</tr>
	<tr>
		<td width="120px">(4) Paid</td>
		<td width="120px">(5) Payable</td>
		<td width="120px">(6) Excess (4)-(5)</td>
	</tr>
	<tr><td colspan="6"><hr></td></tr>
	
	 <cfoutput> 
	<tr>
		<td width="100px" align="right">#getList_qry.NUMOFMTH#</td>
		<td width="120px" align="right">#numberformat(addwagespaid,'.__')#</td>
		<td width="120px" align="right">#List_qry.tawcpf#</td>
		<td width="120px" align="right">#numberformat(Paid,'.__')#</td>
		<td width="120px" align="right">#numberformat(Payable,'.__')#</td>
		<td width="120px" align="right">#numberformat(Excess,'.__')#</td>
	</tr>
	
	 </cfoutput> 
	<tr>
		<td width="100px">&nbsp</td>		
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
	</tr>
 	<cfoutput> 
	
	<tr>
		<td>TOTAL:</td>		
		<td width="120px">#p#</td>
		<td width="120px">#q#</td>
		<td width="120px">#r#</td>
		<td width="120px">#s#</td>
		<td width="120px">#t#</td>
	</tr>
	 </cfoutput> 
	<tr>
		<td>&nbsp</td>		
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
	</tr>
	
	<cfif getList_qry.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
	</cfif>
</table>
<br /><br /><br /><br /><br />
</p> 
</cfoutput>
</cfif>
</cfloop>

<div>
</body>
</html>

</cfcase>

<cfcase value="EXCELDEFAULT">
<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=CPFRefundReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF Refund</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfloop query="getList_qry">
 		<cfset addwagespaid = val(getList_qry.epf_pay)+val(get_qry.epf_pay)>
		<cfset Paid = val(getList_qry.epfww)+val(getList_qry.epfcc)+val(get_qry.epfww)+val(get_qry.epfcc)>
		<cfset Payable = val(List_qry.tawcpfcc)+val(List_qry.tawcpfww)>
		<cfset Excess = (val(getList_qry.epfww)+val(getList_qry.epfcc) + val(get_qry.epfww)+val(get_qry.epfcc)) - (val(List_qry.tawcpfcc)+val(List_qry.tawcpfww))>
		<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
	<cfset s = 0>
	<cfset t = 0>
	<cfset p = p + val(getList_qry.epf_pay)+val(get_qry.epf_pay)>
	<cfset q = q + val(List_qry.tawcpf)>
	<cfset r = r + val(getList_qry.epfww)+val(getList_qry.epfcc)+val(get_qry.epfww)+val(get_qry.epfcc)>
	<cfset s = s + val(List_qry.tawcpfcc)+val(List_qry.tawcpfww)>
	<cfset t = t + (val(getList_qry.epfww)+val(getList_qry.epfcc) + val(get_qry.epfww)+val(get_qry.epfcc)) - (val(List_qry.tawcpfcc)+val(List_qry.tawcpfww))>
<cfif #q# neq 0 OR #r# neq 0 OR #s# neq 0 OR #t# neq 0> 
<cfoutput>
<div>
<p style="page-break-after:always">
<table width="100%">
	 <cfoutput> 
	<tr>
		<td width="100px">Employee No.</td>
		<td width="120px">#getList_qry.EMPNO#</td>
	</tr>
	<tr>
		<td width="100px">Employee Name</td>
		<td width="250px" colspan="3">#getList_qry.name#</td>
	</tr>
	<tr>
		<td width="100px">CPF Ref. No.</td>
		<td width="120px">#getList_qry.epfno#</td>
	</tr>
	 </cfoutput> 
	<tr><td colspan="6"><hr></td></tr>
	<tr>
		<td width="120px" rowspan="3">(1) Month</td>
		<td width="120px" rowspan="3">(2) Additional Wages Paid</td>
		<td width="120px" rowspan="3">(3) Additional Wages Ceiling</td>
		<td colspan="3" align="center">Contribution On AW</td>
	</tr>
	<tr>
		<td colspan="3"><hr></td>
	</tr>
	<tr>
		<td width="120px">(4) Paid</td>
		<td width="120px">(5) Payable</td>
		<td width="120px">(6) Excess (4)-(5)</td>
	</tr>
	<tr><td colspan="6"><hr></td></tr>
	
	 <cfoutput> 
	<tr>
		<td width="100px" align="right">#getList_qry.NUMOFMTH#</td>
		<td width="120px" align="right">#numberformat(addwagespaid,'.__')#</td>
		<td width="120px" align="right">#List_qry.tawcpf#</td>
		<td width="120px" align="right">#numberformat(Paid,'.__')#</td>
		<td width="120px" align="right">#numberformat(Payable,'.__')#</td>
		<td width="120px" align="right">#numberformat(Excess,'.__')#</td>
	</tr>
	
	 </cfoutput> 
	<tr>
		<td width="100px">&nbsp</td>		
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
	</tr>
 	<cfoutput> 
	
	<tr>
		<td>TOTAL:</td>		
		<td width="120px">#p#</td>
		<td width="120px">#q#</td>
		<td width="120px">#r#</td>
		<td width="120px">#s#</td>
		<td width="120px">#t#</td>
	</tr>
	 </cfoutput> 
	<tr>
		<td>&nbsp</td>		
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
	</tr>
	
	<cfif getList_qry.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
	</cfif>
</table>
<br /><br /><br /><br /><br />
</p> 
</cfoutput>
</cfif>
</cfloop>

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