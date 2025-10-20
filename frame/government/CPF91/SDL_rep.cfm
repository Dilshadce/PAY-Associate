<cfquery name="getList_qry" datasource="#dts#">
SELECT a.empno,b.empno,name,epfno,levy_sd
FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
WHERE epfcat = '#form.cat#' AND levy_sd != '0.00' AND paystatus = "A" and confid >= #hpin#
<cfif form.empno neq "">AND  a.empno>='#form.empno#'</cfif><cfif form.empno1 neq "">AND a.empno<='#form.empno1#'</cfif>
<cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif> 
order by a.empno
</cfquery>

<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfquery name="getgross" datasource="#dts#">
SELECT hrd_pay,empno,bonus,comm FROM pay_tm
</cfquery>
<cfset sys_month = getComp_qry.mmonth>
<cfset sys_year = getComp_qry.myear>
<cfset date2 = createdate(val(sys_year),val(sys_month),1) >
<cfset getdays = daysinmonth(date2)>
<cfset date2 = createdate(val(sys_year),val(sys_month),getdays) >
<cfset date = #dateformat(date2,'DD/MM/YYYY')# >
<!--- <cfset date = #dateFormat(Now(),"dd/mm/yyyy")#> --->


<cfswitch expression="#form.result#">
	
<cfcase value="HTML">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Skill Development Levy(SDL)</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="1000px">
	<cfoutput>
	<tr><td colspan="7" align="center"><h1>SKILL DEVELOPMENT LEVY (SDL)</h1></tr>
	<tr>
		<td colspan="6">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="7"><hr></td></tr>
	<tr>
		<td width="50px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="250px">NAME</td>
        <td width="250px" align="right">GROSS PAY</td>
        <td width="250px" align="right">BONUS</td>
        <td width="250px" align="right">COMM</td>
		<td width="250px" align="right">AMOUNT</td>
	</tr>
	<tr><td colspan="7"><hr></td></tr>
	<cfset i = 1>
    <cfset total_sdl = 0 >
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
        <cfquery name="getgrosspay" datasource="#dts#">
        SELECT hrd_pay,bonus,comm FROM pay_tm WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList_qry.empno#">
        </cfquery>
        <td width="250px" align="right">#numberformat(getgrosspay.hrd_pay,'.__')#</td>
        <td width="250px" align="right">#numberformat(getgrosspay.bonus,'.__')#</td>
        <td width="250px" align="right">#numberformat(getgrosspay.comm,'.__')#</td>
		<td width="250px" align="right">#getList_qry.levy_sd#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_sdl = total_sdl + val(getList_qry.levy_sd)>
	</cfoutput>
	<tr>
		<td colspan="6">&nbsp</td>		
		<td width="250px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="6" align="left">TOTAL:</td>		
		<td width="250px" align="right">
        #numberformat(int(val(total_sdl)+0.000000000001),'.__')#</td>
	</tr>
	<tr>
		<td colspan="6">&nbsp</td>		
		<td width="250px"><hr><hr></td>
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
<cfheader name="Content-Disposition" value="attachment; filename=SDLReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Skill Development Levy(SDL)</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="1000px">
	<cfoutput>
	<tr><td colspan="7" align="center"><h1>SKILL DEVELOPMENT LEVY (SDL)</h1></tr>
	<tr>
		<td colspan="6">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="7"><hr></td></tr>
	<tr>
		<td width="50px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="250px">NAME</td>
        <td width="250px" align="right">GROSS PAY</td>
        <td width="250px" align="right">BONUS</td>
        <td width="250px" align="right">COMM</td>
		<td width="250px" align="right">AMOUNT</td>
	</tr>
	<tr><td colspan="7"><hr></td></tr>
	<cfset i = 1>
    <cfset total_sdl = 0 >
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="250px">#getList_qry.name#</td>
        <cfquery name="getgrosspay" datasource="#dts#">
        SELECT hrd_pay,bonus,comm FROM pay_tm WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList_qry.empno#">
        </cfquery>
        <td width="250px" align="right">#numberformat(getgrosspay.hrd_pay,'.__')#</td>
        <td width="250px" align="right">#numberformat(getgrosspay.bonus,'.__')#</td>
        <td width="250px" align="right">#numberformat(getgrosspay.comm,'.__')#</td>
		<td width="250px" align="right">#getList_qry.levy_sd#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_sdl = total_sdl + #val(getList_qry.levy_sd)#>
	</cfoutput>
	<tr>
		<td colspan="6">&nbsp</td>		
		<td width="250px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="6" align="left">TOTAL:</td>		
		<td width="250px" align="right">#numberformat(int(total_sdl),'.__')#</td>
	</tr>
	<tr>
		<td colspan="6">&nbsp</td>		
		<td width="250px"><hr><hr></td>
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