<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getList_qry" datasource="#dts#">

SELECT * FROM pmast AS a LEFT JOIN itaxea AS b ON a.empno=b.empno
left join itaxea2 as c
on a.empno=c.empno
left join payroll_main.councode as d
on a.national = d.ccode
WHERE 0=0
	  <cfif empnoFrom neq ""> AND a.empno >= '#form.empnoFrom#' </cfif>
	  <cfif empnoTo neq ""> AND a.empno <= '#form.empnoTo#' </cfif>
	  AND itaxcat = '#form.cat#' and confid >= #val(hpin)# <cfif isdefined('form.exclude0')>and (b.ea_bonus <> 0 or b.ea_basic <> 0 or b.ea_dirf <> 0 or (coalesce(ea_aw_t,0)+coalesce(ea_aw_e,0)+coalesce(ea_aw_o,0))<> 0  or coalesce(FLOOR(EA_COMM),0)+coalesce(FLOOR(EAFIG02),0)+coalesce(FLOOR(EA_AW_T),0)+coalesce(FLOOR(EA_AW_E),0)
	+coalesce(FLOOR(EA_AW_O),0)+coalesce(FLOOR(ecfig05),0)+coalesce(FLOOR(EAFIG05),0)+coalesce(FLOOR(EAFIG06),0)+
	coalesce(FLOOR(EA_EPFCEXT),0)+coalesce(FLOOR(EAFIG08),0)+coalesce(FLOOR(EAFIG09),0) <> 0 )</cfif>
	  <cfif form.confidential neq "">and confid = #val(form.confidential)#</cfif>
</cfquery>

<cfif getList_qry.add_type eq "">
	<cfset addtype =  "N">
<cfelse>
	<cfset addtype = "#getList_qry.add_type#" >
</cfif>

<cfif addtype eq "L">
	
	<cfset block_num= getList_qry.block>
	<cfset street_name = getList_qry.street>
	<cfset LevelNo = getList_qry.level_no>
	<cfset UnitNo = getList_qry.unit>
	<cfset postcode1 = getList_qry.postcode>

	
<cfelseif addtype eq "F">
	<cfset line1 = getList_qry.add_line1>
	
	<cfset line2= getList_qry.add_line2>
	
	<cfset line3= getList_qry.add_line3>
	
	<cfset country_add_code = getList_qry.country_code_address>
	
<cfelseif addtype eq "C">
	<cfset line1=getList_qry.add_line1>
		
	<cfset line2=getList_qry.add_line2>
	
	<cfset line3=getList_qry.add_line3>
	<cfset postcode2 = getList_qry.postcode>

<cfelseif addtype eq "N">
	
</cfif>


<cfreport template="#form.reportformat#" format="PDF" query="getList_qry" >
		
<cfreportparam name="compName" value="#getComp_qry.comp_name#">
<cfreportparam name="compCode" value="#getComp_qry.uen#">
<cfreportparam name="add1" value="#getComp_qry.comp_add1#">
<cfreportparam name="add2" value="#getComp_qry.comp_add2#">
<cfreportparam name="add3" value="#getComp_qry.comp_add3#">
<cfreportparam name="pmName" value="#getComp_qry.pm_name#">
<cfreportparam name="pmPost" value="#getComp_qry.pm_position#">
<cfreportparam name="pmTel" value="#getComp_qry.pm_tel#">
<cfreportparam name="rdate" value="#form.rdate#">

</cfreport>

