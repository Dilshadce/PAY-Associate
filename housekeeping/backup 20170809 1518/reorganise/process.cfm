<cfquery name="getunpay" datasource="#dts#">
SELECT p.empno FROM paytra1 p, paytran pp,pmast pm
WHERE p.empno = pm.empno AND p.empno = pp.empno and (p.payyes<>"Y" or p.payyes is null) and (pp.payyes<>"Y" or pp.payyes is null) and confid >= #hpin#
<cfif form.empno neq "">
and p.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.empno#">
</cfif>
</cfquery>
<cfloop query="getunpay">
<cfinvoke component="cfc.sum_pay_tm" method="sum_pay" empno="#getunpay.empno#" db="#dts#"  db1="#dts_main#" 
				compid= "#HcomID#" returnvariable="update" />
                
<cfquery name="updateone" datasource="#dts#">
UPDATE PAY_TM SET  payyes = "N", hrd_pay = 0 where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getunpay.empno#">
</cfquery>

<cfquery name="updateone" datasource="#dts#">
UPDATE comm SET  levy_sd = 0, levy_fw_w = 0, payyes = "N" where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getunpay.empno#">
</cfquery>

<cfquery name="updateone" datasource="#dts#">
UPDATE bonus SET  payyes = "N" where empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getunpay.empno#">
</cfquery>

</cfloop>
<cfoutput><form name="pc"  action="index.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="status" value="Done" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	 pc.submit();
</script>