<link rel="shortcut icon" href="/PMS.ico" />
<cfset db_select = form.paytype >
<cfquery name="selectList" datasource="#dts#">
SELECT db.empno,db.brate,taw,grosspay,ded114,ded111,ded113,epfww,epfcc,netpay,pm.name,pm.epfno,cm.levy_sd,pm.name FROM #db_select# AS db 
LEFT JOIN pmast AS pm ON db.empno = pm.empno 
LEFT JOIN (select empno as empno2, levy_sd from comm_12m WHERE tmonth= #form.month# and levy_sd <> 0 group by empno) as cm on cm.empno2 = pm.empno
WHERE db.tmonth = #form.month#
and pm.confid >= #hpin#
<cfif form.confid neq "">
and pm.confid = "#form.confid#"
</cfif>
<cfif #form.empno# neq "">
	AND pm.empno >= "#form.empno#"
</cfif>
<cfif #form.empno1# neq "">
	AND pm.empno <= "#form.empno1#"
</cfif>
<cfif #form.lineno# neq "">
	AND pm.plineno >= "#form.lineno#"
</cfif>
<cfif #form.lineno1# neq "">
	AND pm.plineno <= "#form.lineno1#"
</cfif>
<cfif #form.brcode# neq "">
	AND pm.brcode >= "#form.brcode#"
</cfif>
<cfif #form.brcode1# neq "">
	AND pm.brcode <= "#form.brcode1#"
</cfif>
<cfif #form.deptcode# neq "">
	AND pm.deptcode >= "#form.deptcode#"
</cfif>
<cfif #form.deptcode1# neq "">
	AND pm.deptcode <= "#form.deptcode1#"
</cfif>
<cfif #form.category# neq "">
	AND pm.category >= "#form.category#"
</cfif>
<cfif #form.category1# neq "">
	AND pm.category <= "#form.category1#"
</cfif>
<cfif #form.emp_code# neq "">
	AND pm.emp_code >= "#form.emp_code#"
</cfif>
<cfif #form.emp_code1# neq "">
	AND pm.emp_code <= "#form.emp_code1#"
</cfif>
<cfif isdefined('form.exclude0')>
    AND db.netpay > 0
</cfif>
order by length(pm.empno),pm.empno
</cfquery>
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfreport template="newreport.cfr" query="selectList" format="#url.type#">
 	<cfreportparam name="compname" value="#company_details.COMP_NAME#">
	<cfreportparam name="month1" value="#form.month#">
	<cfreportparam name="year1" value="#company_details.myear#">
</cfreport>