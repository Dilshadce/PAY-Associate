<cfquery name="gs_qry" datasource="payroll_main">
    SELECT * FROM gsetup WHERE comp_id = 'manpower'
</cfquery>

<cfquery name="getdata" datasource="#dsname#">
    SELECT * FROM pmast a LEFT JOIN emp_users b on a.empno = b.empno 
    LEFT JOIN payroll_main.bankcodemy c on a.bankcode = c.bankcode
    LEFT JOIN address d on a.bankcat = d.refno 
    WHERE b.username = '#HUserID#' 
</cfquery>

<cfreport template="printTaxLetterRep.cfr" format="PDF" query="getdata">
 	<cfreportparam name="compname" value="#gs_qry.COMP_NAME#">
 	<cfreportparam name="add1" value="#gs_qry.comp_add1#">
 	<cfreportparam name="add2" value="#gs_qry.comp_add2#">
 	<cfreportparam name="fax" value="#gs_qry.comp_fax#">
 	<cfreportparam name="tel" value="#gs_qry.comp_phone#">
 	<cfreportparam name="pm_name" value="#gs_qry.pm_name#">
 	<cfreportparam name="pm_position" value="#gs_qry.pm_position#">
	<cfreportparam name="date" value="#dateformat(now(),'dd mmmm yyyy')#"> 
</cfreport>
