<cfquery name="getList_qry" datasource="#dts#">
SELECT a.empno,b.empno,name,epfno, DED110
FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
WHERE epfcat = '#form.cat#' AND DED110 !="0.00" AND paystatus = "A" and confid >= #hpin#
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
	<title>Donation to community chest</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="100%" align="center"><h1>DONATION TO COMMUNITY CHEST</h1></tr>
	<tr>
		<td colspan="3">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="100%"><hr></td></tr>
	<tr>
		<td width="50px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="250px">NAME</td>
		<td width="140px">AMOUNT</td>
	</tr>
	<tr><td colspan="100%"><hr></td></tr>
	<cfset i = 1>
    <cfset total_DCC = 0 >
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
		<td width="140px" align ="right">#numberformat(getList_qry.DED110,'.__')#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_DCC = total_DCC + #val(getList_qry.DED110)# >
	</cfoutput>
	<tr>
		<td colspan="3">&nbsp</td>		
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="3" align="left">TOTAL:</td>		
		<td width="140px" align ="right">#numberformat(total_DCC,'.__')#</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp</td>		
		<td width="140px"><hr><hr></td>
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
<cfheader name="Content-Disposition" value="attachment; filename=DCCReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Donation to community chest</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="4" align="center"><h1>DONATION TO COMMUNITY CHEST</h1></tr>
	<tr>
		<td colspan="3">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="4"><hr></td></tr>
	<tr>
		<td width="50px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="250px">NAME</td>
		<td width="140px">AMOUNT</td>
	</tr>
	<tr><td colspan="4"><hr></td></tr>
	<cfset i = 1>
    <cfset total_DCC = 0 >
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
		<td width="140px" align ="right">#numberformat(getList_qry.DED110,'.__')#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_DCC = total_DCC + #val(getList_qry.DED110)# >
	</cfoutput>
	<tr>
		<td colspan="3">&nbsp</td>		
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="3" align="left">TOTAL:</td>		
		<td width="140px" align ="right">#numberformat(total_DCC,'.__')#</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp</td>		
		<td width="140px"><hr><hr></td>
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