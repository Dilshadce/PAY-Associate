<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfif getComp_qry.c_acfwl eq "1">
	<cfquery name="getList_qry" datasource="#dts#">
		SELECT fwtb.type,a.empno,b.empno,name,levy_fw_w, a.fwlevymtd
		FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
		left join fwltable as fwtb on a.fwlevytbl = fwtb.id
		WHERE epfcat = '#form.cat#' AND levy_fw_w != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        order by a.empno
	</cfquery>
<cfelse>
	<cfquery name="getList_qry" datasource="#dts#">
		SELECT fwtbl.type,a.empno,b.empno,name,DED102, a.fwlevymtd
		FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
		left join fwltable as fwtbl on a.fwlevytbl= fwtbl.id
		WHERE epfcat = '#form.cat#' AND DED102 != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        order by a.empno
	</cfquery>
</cfif>


<cfset date = #dateFormat(Now(),"dd/mm/yyyy")#>

<cfif #getList_qry.fwlevymtd# eq "M">
	<cfset method = "Monthly">
<cfelse>
	<cfset method = "Daily">
</cfif>

<cfswitch expression="#form.result#">
	
<cfcase value="HTML">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Foreign Worker Levy</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="6" align="center"><h1>FOREIGN WORKER LEVY</h1></tr>
	<tr>
		<td colspan="4">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="6"><hr></td></tr>
	<tr>
		<td width="30px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="50px">FWL TYPE</td>
		<td width="210px">NAME</td>
        <td width="100px">METHOD</td>
		<td width="100px">AMOUNT</td>
	</tr>
	<tr><td colspan="6"><hr></td></tr>
	<cfset i = 1>
    <cfset total_levy = 0>
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="50px">#getList_qry.type#</td>
		<td width="250px">#getList_qry.name#</td>
        <td width="100px">#method#</td>
		<cfif getComp_qry.c_acfwl eq "1">
			<cfset FWL = numberformat(getList_qry.levy_fw_w,'.__')>
			
		<cfelse>
			<cfset FWL = numberformat(getList_qry.DED102,'.__')>
		</cfif>
		<td width="140px" align="right">#FWL#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_levy = total_levy + #val(FWL)# >
	</cfoutput>
	<tr>
		<td colspan="5">&nbsp</td>		
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="5" align="left">TOTAL:</td>		
		<td width="140px" align="right">#numberformat(total_levy,'.__')#</td>
	</tr>
	<tr>
		<td colspan="5">&nbsp</td>		
		<td width="140px"><hr><hr></td>
	</tr>
	
	
	<cfif getComp_qry.c_acfwl eq "1">
	<cfquery name="getList_qry2" datasource="#dts#">
		SELECT levy_fw_w, count(levy_fw_w) as numfw
		FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
		WHERE epfcat = '#form.cat#' AND levy_fw_w != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        group by levy_fw_w
	</cfquery>
<cfelse>
	<cfquery name="getList_qry2" datasource="#dts#">
		SELECT ded102 as levy_fw_w, count(ded102) as numfw
		FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
		WHERE epfcat = '#form.cat#' AND DED102 != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        group by ded102
	</cfquery>
</cfif>
<cfloop query="getList_qry2">
	<tr><td></td><td>Number of Employee(s) under <b>#getList_qry2.levy_fw_w#</b> rate : #getList_qry2.numfw#</td></tr>
</cfloop>	
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
<cfheader name="Content-Disposition" value="attachment; filename=FWLReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Foreign Worker Levy</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<div>
<table width="100%">
	<cfoutput>
	<tr><td colspan="6" align="center"><h1>FOREIGN WORKER LEVY</h1></tr>
	<tr>
		<td colspan="5">#getComp_qry.comp_name#</td>
		<td align="right">#date#</td>
	</tr>
	</cfoutput>
	<tr><td colspan="6"><hr></td></tr>
	<tr>
		<td width="30px">NO.</td>
		<td width="100px">EMPLOYEE NUMBER</td>
		<td width="50px">FWL TYPE</td>
		<td align="center" width="210px">NAME</td>
        <td width="100px">METHOD</td>
		<td width="100px">AMOUNT</td>
	</tr>
	<tr><td colspan="6"><hr></td></tr>
	<cfset i = 1>
    <cfset total_levy = 0>
	<cfoutput query="getList_qry">
	<tr>
		<td width="50px">#i#</td>
		<td width="100px">#getList_qry.empno#</td>
		<td width="50px">#getList_qry.type#</td>
		<td align="center" width="250px">#getList_qry.name#</td>
        <td width="100px">#method#</td>
		<cfif getComp_qry.c_acfwl eq "1">
			<cfset FWL = numberformat(getList_qry.levy_fw_w,'.__')>
			
		<cfelse>
			<cfset FWL = numberformat(getList_qry.DED102,'.__')>
		</cfif>
		<td width="140px" align="right">#FWL#</td>
	</tr>
	<cfset i = i + 1>
    <cfset total_levy = total_levy + #val(FWL)# >
	</cfoutput>
	<tr>
		<td colspan="5">&nbsp</td>		
		<td width="140px"><hr></td>
	</tr>
	<cfoutput>
	<tr>
		<td colspan="5" align="left">TOTAL:</td>		
		<td width="140px" align="right">#numberformat(total_levy,'.__')#</td>
	</tr>
	<tr>
		<td colspan="5">&nbsp</td>		
		<td width="140px"><hr><hr></td>
	</tr>
	
	<cfif getComp_qry.c_acfwl eq "1">
	<cfquery name="getList_qry3" datasource="#dts#">
		SELECT levy_fw_w, count(levy_fw_w) as numfw
		FROM pmast AS a LEFT JOIN comm AS b ON a.empno=b.empno
		WHERE epfcat = '#form.cat#' AND levy_fw_w != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        group by levy_fw_w
	</cfquery>
<cfelse>
	<cfquery name="getList_qry3" datasource="#dts#">
		SELECT ded102 as levy_fw_w, count(ded102) as numfw
		FROM pmast AS a LEFT JOIN pay_tm AS b ON a.empno=b.empno
		WHERE epfcat = '#form.cat#' AND DED102 != '0.00' AND paystatus = "A" and confid >= #hpin#
        <cfif form.branchFrom neq "">AND  brcode>='#form.branchFrom#'</cfif><cfif form.branchTo neq "">AND brcode<='#form.branchTo#'</cfif>
		<cfif form.deptFrom neq ""> AND deptcode >='#form.deptFrom#' </cfif><cfif form.deptTo neq ""> AND deptcode <='#form.deptTo#' </cfif>
		<cfif form.categoryFrom neq ""> AND category >='#form.categoryFrom#' </cfif><cfif form.categoryTo neq "">AND category <='#form.categoryTo#' </cfif>
        group by ded102
	</cfquery>
</cfif>	
<cfloop query="getList_qry3">
	<tr><td></td><td colspan="3">Number of Employee(s) under <b>#getList_qry3.levy_fw_w#</b> rate : #getList_qry3.numfw#</td></tr>
</cfloop>	
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