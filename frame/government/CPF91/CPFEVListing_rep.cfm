<cfquery name="getList_qry" datasource="#dts#">
SELECT a.empno,b.empno,name,epfno,epfww,epfwwext,epfcc,epfccext,epfcat 
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = '#form.cat#' AND paystatus = "A"
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
	<title>CPF Excess / Voluntary Listing</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>


<table width="100%">
	<cfoutput>
	<tr><td colspan="9" align="center"><h1>CPF EXCESS / VOLUNTARY LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="9">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="9"><hr></td></tr>
	<tr>
		<td width="50px">ITEM</td>
		<td width="100px">EMPNO.</td>
		<td width="250px">NAME</td>
		<td width="140px">CPF A/C NO.</td>
		<td width="240px" colspan="2" align="center">COMPULSORY</td>
		<td width="240px" colspan="2" align="center">EXCESS/VOLUNTARY</td>
		<td width="140px">TOTAL CPF</td>
	</tr>
	<tr>
		<td width="50px">&nbsp</td>
		<td width="100px">&nbsp</td>
		<td width="250px">&nbsp</td>
		<td width="140px">&nbsp</td>
		<td width="120px">CPF Y'EE</td>
		<td width="120px">CPF Y'ER</td>
		<td width="120px">CPF Y'EE</td>
		<td width="120px">CPF Y'ER</td>
		<td width="140px">&nbsp</td>
	</tr>
	<tr><td colspan="9"><hr></td></tr>
	<cfset i = 1>
	<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
	<cfset s = 0>
	<cfset t = 0>
	
 	
	<cfoutput query="getList_qry">
		
	<cfset comyee = getList_qry.epfww>
	<cfset comyer = getList_qry.epfcc>
	<cfset excyee = getList_qry.epfwwext>
	<cfset excyer = getList_qry.epfccext>
	<cfset total = val(getList_qry.epfww) + val(getList_qry.epfcc) + val(getList_qry.epfwwext) + val(getList_qry.epfccext)>	
	<cfif #total# neq 0>
		<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
		<td width="140px">#getList_qry.epfno#</td>
		<td width="120px" align="right">#numberformat(comyee,".__")#</td>
		<td width="120px" align="right">#numberformat(comyer,".__")#</td>
		<td width="120px" align="right">#numberformat(excyee,".__")#</td>
		<td width="120px" align="right">#numberformat(excyer,".__")#</td>
		<td width="140px" align="right">#numberformat(total,".__")#</td>
	</tr>
	
	<cfset i = i + 1>
	<cfset p = p + val(getList_qry.epfww)>
	<cfset q = q + val(getList_qry.epfcc)>
	<cfset r = r + val(getList_qry.epfwwext)>
	<cfset s = s + val(getList_qry.epfccext)>
	<cfset t = p + q + r + s>
	 </cfif> 
	</cfoutput>
  
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="4" align="left">TOTAL:</td>		
		<td width="120px" align="right">#numberformat(p,".__")#</td>
		<td width="120px" align="right">#numberformat(q,".__")#</td>
		<td width="120px" align="right">#numberformat(r,".__")#</td>
		<td width="120px" align="right">#numberformat(s,".__")#</td>
		<td width="140px" align="right">#numberformat(t,".__")#</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
	</tr>
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
<cfheader name="Content-Disposition" value="attachment; filename=CPFEVListingReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF Excess / Voluntary Listing</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="9" align="center"><h1>CPF EXCESS / VOLUNTARY LISTING FOR MONTH #monthAsString(month)# #year#</h1></tr>
	<tr><td colspan="9">#getComp_qry.comp_name#</td></tr>
	</cfoutput>
	<tr><td colspan="9"><hr></td></tr>
	<tr>
		<td width="50px">ITEM</td>
		<td width="100px">EMPNO.</td>
		<td width="250px">NAME</td>
		<td width="140px">CPF A/C NO.</td>
		<td width="240px" colspan="2" align="center">COMPULSORY</td>
		<td width="240px" colspan="2" align="center">EXCESS/VOLUNTARY</td>
		<td width="140px">TOTAL CPF</td>
	</tr>
	<tr>
		<td width="50px">&nbsp</td>
		<td width="100px">&nbsp</td>
		<td width="250px">&nbsp</td>
		<td width="140px">&nbsp</td>
		<td width="120px">CPF Y'EE</td>
		<td width="120px">CPF Y'ER</td>
		<td width="120px">CPF Y'EE</td>
		<td width="120px">CPF Y'ER</td>
		<td width="140px">&nbsp</td>
	</tr>
	<tr><td colspan="9"><hr></td></tr>
	<cfset i = 1>
	<cfset p = 0>
	<cfset q = 0>
	<cfset r = 0>
	<cfset s = 0>
	<cfset t = 0>
	<cfoutput query="getList_qry">
		
	<cfset comyee = getList_qry.epfww>
	<cfset comyer = getList_qry.epfcc>
	<cfset excyee = getList_qry.epfwwext>
	<cfset excyer = getList_qry.epfccext>
	<cfset total = val(getList_qry.epfww) + val(getList_qry.epfcc) + val(getList_qry.epfwwext) + val(getList_qry.epfccext)>	
	<cfif #total# neq 0>
		<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
		<td width="140px">#getList_qry.epfno#</td>
		<td width="120px" align="right">#numberformat(comyee,".__")#</td>
		<td width="120px" align="right">#numberformat(comyer,".__")#</td>
		<td width="120px" align="right">#numberformat(excyee,".__")#</td>
		<td width="120px" align="right">#numberformat(excyer,".__")#</td>
		<td width="140px" align="right">#numberformat(total,".__")#</td>
	</tr>
	
	<cfset i = i + 1>
	<cfset p = p + val(getList_qry.epfww)>
	<cfset q = q + val(getList_qry.epfcc)>
	<cfset r = r + val(getList_qry.epfwwext)>
	<cfset s = s + val(getList_qry.epfccext)>
	<cfset t = p + q + r + s>
	 </cfif> 
	</cfoutput>
  
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="120px"><hr></td>
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="4" align="left">TOTAL:</td>		
		<td width="120px" align="right">#numberformat(p,".__")#</td>
		<td width="120px" align="right">#numberformat(q,".__")#</td>
		<td width="120px" align="right">#numberformat(r,".__")#</td>
		<td width="120px" align="right">#numberformat(s,".__")#</td>
		<td width="140px" align="right">#numberformat(t,".__")#</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="4" align="left">&nbsp</td>		
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="120px"><hr><hr></td>
		<td width="140px"><hr><hr></td>
	</tr>
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