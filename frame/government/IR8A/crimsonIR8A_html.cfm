<html>
<head>
	<title>Summary of IR8A Files</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
</head>

<body>
<cfoutput>
<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset year_sys = getComp_qry.myear>

<cfquery name="getList_qry" datasource="#dts#">
	SELECT * FROM(SELECT * FROM pmast p where year(dresign) >= #year_sys# or dresign is null or dresign ="0000-00-00") as pm 
	left join itaxea as pt on pt.empno = pm.empno
	WHERE 0=0
    AND pm.confid >= #hpin#
    <cfif form.empnoFrom neq ""> AND pm.empno >= '#form.empnoFrom#' </cfif>
	<cfif form.empnoTo neq ""> AND pm.empno <= '#form.empnoTo#' </cfif>
	<cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
	  and itaxcat <> "X"
      <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0 or (coalesce(ea_aw_t,0)+coalesce(ea_aw_e,0)+coalesce(ea_aw_o,0))<> 0 or coalesce(FLOOR(EA_COMM),0)+coalesce(FLOOR(EAFIG02),0)+coalesce(FLOOR(EA_AW_T),0)+coalesce(FLOOR(EA_AW_E),0)
	+coalesce(FLOOR(EA_AW_O),0)+coalesce(FLOOR(ecfig05),0)+coalesce(FLOOR(EAFIG05),0)+coalesce(FLOOR(EAFIG06),0)+
	coalesce(FLOOR(EA_EPFCEXT),0)+coalesce(FLOOR(EAFIG08),0)+coalesce(FLOOR(EAFIG09),0) <> 0 )</cfif>
	  order by pm.empno
</cfquery>

<cfset i = 0>

<h1>Summary of IR8A Files</h1>
<table border="1">
<tr>
	<td align="center"><b>No</b></td>
	<td align="center"><b>ID Type</b></td>
	<td align="center"><b>Employee ID</b></td>
	<td align="center"><b>Employee Name</b></td>
	<td align="center"><b>Salary</b></td>
	<td align="center"><b>Bonus</b></td>
	<td align="center"><b>Director's Fee</b></td>
	<td align="center"><b>Others</b></td>
	<td align="center"><b>CPF/Designated Pension or Provident Fund</b></td>
	<td align="center"><b>Donation</b></td>
	<td align="center"><b>MBF</b></td>
</tr>	
<cfloop query="getList_qry">
<cfset i = i +1>	
	

<!--- check id type --->
<cfif getList_qry.national eq "SG" OR getList_qry.r_statu eq "PR">
	<cfset ID_TYPE= "1">
<cfelseif getList_qry.r_statu eq "EP" or getList_qry.r_statu eq "SP" or getList_qry.r_statu eq "WP" and #getList_qry.fin# neq "">
	<cfset ID_TYPE= "2" >
<cfelseif getList_qry.IMS neq "">
	<cfset ID_TYPE= "3" >
<cfelseif getList_qry.r_statu eq "WP">
	<cfset ID_TYPE="4">
<cfelseif getList_qry.national eq "MY" AND getList_qry.passport eq "">
	<cfset ID_TYPE= "5">
<cfelseif getList_qry.passport neq "" AND getList_qry.national neq "SG" >
	<cfset ID_TYPE= "6">
</cfif>
<!--- check number id --->
<cfif ID_TYPE eq "1" >
	<cfif getList_qry.national eq "SG">
		<cfset nric = ucase(getList_qry.nricn)>
	<cfelseif getList_qry.r_statu eq "PR">
		<cfset nric = ucase(getList_qry.pr_num)>
	</cfif>
	
	<cfset num_reg = REFind("^[S|T|F|G]", ucase(getList_qry.nricn))>
	<cfset nnric = replace(getList_qry.nricn, "-","","all")>
	<cfset new_reg_nric = REFind("[[:punct:]]", nnric)>
	
	<cfif nnric neq "" and new_reg_nric eq "0" and num_reg eq "1">
		<cfset num_ID = "#nnric#">
		<cfloop condition="len(num_ID) lt 12">
			<cfset num_ID = num_ID&" " >
		</cfloop>
	</cfif>

<cfelseif ID_TYPE eq "2">
	<cfset num_reg = REFind("^[F|G]", ucase(getList_qry.fin))>
	<cfif getList_qry.fin neq "" and num_reg eq 1>
		<cfset num_ID = "#getList_qry.fin#">
		<cfloop condition="len(num_ID) lt 12">
			<cfset num_ID = num_ID&" " >
		</cfloop>	
	</cfif>
<cfelseif ID_TYPE eq "3">
	<cfset num_reg = REFind("^\d{8}$" , ucase(getList_qry.IMS))>
	<cfif getList_qry.IMS neq "" and num_reg eq 1>
		<cfset num_ID = "#getList_qry.IMS#">
		<cfloop condition="len(num_ID) lt 12">
			<cfset num_ID = num_ID&" " >
		</cfloop>
	</cfif>
<cfelseif ID_TYPE eq "4">
		<cfif getList_qry.wpermit neq "">
			<cfset num_ID = "#getList_qry.wpermit#">
			<cfloop condition="len(num_ID) lt 12">
				<cfset num_ID = num_ID&" " >
			</cfloop>
		<cfelseif getList_qry.fin neq "">
			<cfset num_ID = "#getList_qry.fin#">
			<cfloop condition="len(num_ID) lt 12">
				<cfset num_ID = num_ID&" " >
			</cfloop>	
		</cfif>

<cfelseif ID_TYPE eq "5">
		
		<cfset nric = getList_qry.nricn>
		<!--- <cfset num_reg = getList_qry.nricn> --->
		
		<cfset nnric = replace(getList_qry.nricn, "-","","all")>
		<cfset new_reg_nric = REFind("[[:punct:]]", nnric)>
		
		<cfif nnric neq "" and new_reg_nric eq "0" >
			<cfset num_ID = "#nnric#">
			<cfloop condition="len(num_ID) lt 12">
				<cfset num_ID = num_ID&" " >
			</cfloop>
		</cfif>
	<!--- <cfoutput>#nnric# #new_reg_nric# #num_reg#</cfoutput> --->
<cfelseif ID_TYPE eq "6">
		<cfif getList_qry.passport neq  "">
			<cfset num_ID = getList_qry.passport>
			<cfloop condition="len(num_ID) lt 12">
				<cfset num_ID = num_ID&" " >
			</cfloop>
		</cfif>
</cfif>

<!--------------------------Bonus------------------------------>
<cfset a=VAL(getList_qry.EA_BONUS) + VAL(getList_qry.bonusfrny)>
<cfset b=round(a)>
		<cfif b-a lte 0>
			<cfset bonus2 = round(a)>
		<cfelse>
			<cfset bonus2 = round(a-1)>
		</cfif>
<!-------------------------Director fee------------------------>
<cfset a= val(getList_qry.ea_dirf)>
<cfset b=round(a)>
		<cfif b-a lte 0>
			<cfset dirfee = round(a)>
		<cfelse>
			<cfset dirfee = round(a-1)>
		</cfif>
		
<!------------------------Other ------------------------------>
<cfset other = 0>
<cfset totalamt = 0>
<cfset tbonus = int(VAL(getList_qry.EA_BONUS)) + int(VAL(getList_qry.bonusfrny))>
<cfset other = int(val(getList_qry.EA_COMM))+int(val(getList_qry.EAFIG02))+ int(val(getList_qry.EA_AW_T))
				+ int(val(getList_qry.EA_AW_E))+ int(val(getList_qry.EA_AW_O))+ int(val(getList_qry.ecfig05))+ int(val(getList_qry.EAFIG05))
				+ int(val(getList_qry.EAFIG06))+ int(val(getList_qry.EA_EPFCEXT))+ int(val(getList_qry.EAFIG08))+ int(val(getList_qry.EAFIG09))>
<cfset totalamt = int(VAL(getList_qry.EA_BASIC)) + int(val(tbonus))+ int(val(getList_qry.ea_dirf))+ int(val(other))>		

<!----------------------------------Total amount ----------------------------->
<cfquery name="sumAll" datasource="#dts#">
	SELECT sum(coalesce(FLOOR(EA_COMM),0))+sum(coalesce(FLOOR(EAFIG02),0))+sum(coalesce(FLOOR(EA_AW_T),0))+sum(coalesce(FLOOR(EA_AW_E),0))
	+sum(coalesce(FLOOR(EA_AW_O),0))+sum(coalesce(FLOOR(ecfig05),0))+sum(coalesce(FLOOR(EAFIG05),0))+sum(coalesce(FLOOR(EAFIG06),0))+
	sum(coalesce(FLOOR(EA_EPFCEXT),0))+sum(coalesce(FLOOR(EAFIG08),0))+sum(coalesce(FLOOR(EAFIG09),0))as sum_Other,
	sum(coalesce(FLOOR(EA_BASIC),0)) as sum_Salary, sum(coalesce(FLOOR(ea_dirf),0))as sumDirFee,
	sum(coalesce(FLOOR(EA_BONUS),0))+sum(coalesce(FLOOR(bonusfrny),0)) as sum_bonus, 
	sum(coalesce(ceiling(EA_DED),0)) as sumdonation,
	sum(coalesce(ceiling(EA_EPF),0)) as sumcpf, 
	sum(coalesce(ceiling(EAFIG15),0)) as sumMBF,
	sum(coalesce(ceiling(EX_33),0)) as sum_exem_income,
	sum(coalesce(ceiling(EX_34),0)) as sum_Borne_emper,
	sum(coalesce(ceiling(EX_35),0)) as sum_Borne_empee,
	sum(coalesce(ceiling(ins_ded),0)) as sum_insurance
	FROM itaxea as i left join pmast as p on p.empno=i.empno
	WHERE 0=0 AND p.confid >= #hpin#
		  <cfif form.empnoFrom neq ""> AND i.empno >= '#form.empnoFrom#'</cfif>
		  <cfif form.empnoTo neq ""> AND i.empno <= '#form.empnoTo#'</cfif>
		  <cfif form.cat neq "">AND itaxcat = #form.cat#</cfif>
		  and itaxcat <> "X"
          and (year(dresign) >= #year_sys# or dresign is null or dresign ="0000-00-00")
		  <cfif isdefined('form.exclude0')>and (ea_basic <> 0 or ea_dirf <> 0 or (coalesce(ea_aw_t,0)+coalesce(ea_aw_e,0)+coalesce(ea_aw_o,0))<> 0 or coalesce(FLOOR(EA_COMM),0)+coalesce(FLOOR(EAFIG02),0)+coalesce(FLOOR(EA_AW_T),0)+coalesce(FLOOR(EA_AW_E),0)
	+coalesce(FLOOR(EA_AW_O),0)+coalesce(FLOOR(ecfig05),0)+coalesce(FLOOR(EAFIG05),0)+coalesce(FLOOR(EAFIG06),0)+
	coalesce(FLOOR(EA_EPFCEXT),0)+coalesce(FLOOR(EAFIG08),0)+coalesce(FLOOR(EAFIG09),0) <> 0)</cfif>
		  order by p.empno
	</cfquery>
	

<cfset sum_salary= #int(val(sumAll.sum_Salary))#>

<cfset sum_Bonus= #int(val(sumAll.sum_bonus))#>

<cfset sum_sumDirFee= #int(val(sumAll.sumDirFee))#>

<cfset sum_Other= #int(val(sumAll.sum_Other))#>

<cfset sum_CPF ="#ceiling(val(sumAll.sumcpf))#">

<cfset sum_donation ="#ceiling(val(sumAll.sumdonation))#">

<cfset sum_MBF = "#ceiling(val(sumAll.sumMBF))#" >


<tr>
	<td>#i#</td>
	<td>#ID_TYPE#</td>
	<td>#num_ID#</td>
	<td>#name#</td>
	<td align="right">#numberformat(int(VAL(getList_qry.EA_BASIC)),'.__')#</td>
	<td align="right">#numberformat(bonus2,'.__')#</td>
	<td align="right">#numberformat(dirfee,'.__')#</td>
	<td align="right">#numberformat(other,'.__')#</td>
	<td align="right">#numberformat(ceiling(val(getList_qry.EA_EPF)),'.__')#</td>
	<td align="right">#numberformat(ceiling(val(getList_qry.EA_DED)),'.__')#</td>
	<td align="right">#numberformat(ceiling(val(getList_qry.EAFIG15)),'.__')#</td>
</tr>

</cfloop>

<tr>
	<td colspan="4" align="center"><strong>TOTAL AMOUNT</strong></td>
	<td align="right">#numberformat(sum_salary,'.__')#</td>
	<td align="right">#numberformat(sum_Bonus,'.__')#</td>
	<td align="right">#numberformat(sum_sumDirFee,'.__')#</td>
	<td align="right">#numberformat(sum_Other,'.__')#</td>
	<td align="right">#numberformat(sum_CPF,'.__')#</td>
	<td align="right">#numberformat(sum_donation,'.__')#</td>
	<td align="right">#numberformat(sum_MBF,'.__')#</td>
</tr>

</table>




</cfoutput>
</body>
</html>