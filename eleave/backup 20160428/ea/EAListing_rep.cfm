<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="getList_qry" datasource="#dsname#">
SELECT * FROM pmast AS a LEFT JOIN eatable AS b ON a.empno=b.empno
WHERE a.empno = '#form.empno#'
</cfquery> 
 
<cfset DATE = #DateFormat(Now(), "dd-mm-yyyy")#>
<cfset YDATE = #getComp_qry.myear#>

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

<cfreport template="EA2014 Form.cfr" format="PDF" query="getList_qry">
    <cfreportparam name="DATE" value="#DATE#">
    <cfreportparam name="YDATE" value="#YDATE#">
    <cfreportparam name="compName" value="#getComp_qry.comp_name#">
    <cfreportparam name="compCode" value="#getComp_qry.comp_roc#">
    <cfreportparam name="add1" value="#getComp_qry.comp_add1#">
    <cfreportparam name="add2" value="#getComp_qry.comp_add2#">
    <cfreportparam name="add3" value="#getComp_qry.comp_add3#">
    <cfreportparam name="pmName" value="#getComp_qry.pm_name#">
    <cfreportparam name="pmPost" value="#getComp_qry.pm_position#">
    <cfreportparam name="nomajikan" value="#getComp_qry.nomajikan#">
</cfreport>

