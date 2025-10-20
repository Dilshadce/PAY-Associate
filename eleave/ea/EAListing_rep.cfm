<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
    
<cfif form.yearchose neq getComp_qry.myear>
    <cfset yearnow = right(form.yearchose,2)>
    <cfset dts = replace(DSNAME,'_p','#yearnow#_p')>        
    <cfset dts_i = replace(dts,'_p','_i')>
<cfelse>
    <cfset dts = DSNAME>        
    <cfset dts_i = replace(dts,'_p','_i')>
</cfif>
    
<cfquery datasource="#dts#">
	SET SESSION binlog_format = 'MIXED'
</cfquery>

<cfquery name="emp_data" datasource="#dts#" >
SELECT pm.empno FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#"  
</cfquery>
        
<cfset empno = emp_data.empno>
    
<cfquery name="checkemp" datasource="#dts#">
SELECT empno FROM eatable
WHERE empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
</cfquery>

<cfif checkemp.recordcount eq 0>
<cfquery name="insertemp" datasource="#dts#">
INSERT IGNORE eatable
(empno,
e1_detail,
updated_on)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">,
'Employees Provident Fund',
now()
)
</cfquery>
</cfif>

<cfquery name="updatedata" datasource="#dts#">
update eatable a, pay_ytd b
set a.b1a_gross=ifnull(b.itaxpcb,0.00)-ifnull(b.bonus,0.00),
a.b1b_fees=ifnull(b.bonus,0.00),
a.d1_amount=ifnull(b.ded115,0.00),
a.d2_amount=ifnull(b.ded114,0.00),
a.d3_amount=ifnull(b.ded112,0.00),
a.e1_amount=ifnull(b.epfww,0.00),
a.e2_amount=ifnull(b.socsoww,0.00),
e1_detail='Employees Provident Fund'
where a.empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and a.empno=b.empno
</cfquery>

<!---<cfquery name="checkemp" datasource="#dts_i#">
SELECT ic.empno FROM icgiro ic
LEFT JOIN argiro ar
ON ic.uuid=ar.uuid AND ic.batchno=ar.batchno 
WHERE appstatus="Approved"
AND empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
AND ic.batchno in (SELECT batches FROM assignmentslip WHERE payrollperiod=#getComp_qry.mmonth#)
GROUP BY empno
</cfquery>--->

<!---<cfif checkemp.recordcount neq 0>--->
    <cfquery name="updatedata" datasource="#dts#">
    update eatable a, payout_tm c
    set a.b1a_gross=a.b1a_gross+ifnull(c.itaxpcb,0.00)-ifnull(c.bonus,0.00),
    a.b1b_fees=a.b1b_fees+ifnull(c.bonus,0.00),
    a.d1_amount=a.d1_amount+ifnull(c.ded115,0.00),
    a.d2_amount=a.d2_amount+ifnull(c.ded114,0.00),
    a.d3_amount=a.d3_amount+ifnull(c.ded112,0.00),
    a.e1_amount=a.e1_amount+ifnull(c.epfww,0.00),
    a.e2_amount=a.e2_amount+ifnull(c.socsoww,0.00)
    where a.empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and a.empno=c.empno
    </cfquery>
<!---</cfif>--->

<cfquery name="updatedata" datasource="#dts#">
update eatable a, 
    (
        select empno,sum(ifnull(vola,0.00)) vola,sum(ifnull(totalbik,0.00)) totalbik from bik 
        group by empno
    ) b
set a.b4_amount=ifnull(b.vola,0.00),
a.b3_amount=ifnull(b.totalbik,0.00)
where a.empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#"> and a.empno=b.empno
</cfquery>

<cfquery name="updatedata" datasource="#dts#">
update eatable
set ctotal_amount=ifnull(b1a_gross,0.00)+ifnull(b1b_fees,0.00)+ifnull(b1c_amount,0.00)+ifnull(b1d_amount,0.00)+ifnull(b1e_amount,0.00)+ifnull(b1f_amount,0.00)+ifnull(b2_amount,0.00)+ifnull(b3_amount,0.00)+ifnull(b4_amount,0.00)+ifnull(b5_amount,0.00)+ifnull(b6_amount,0.00)+ifnull(c1_pencen,0.00)+ifnull(c2_amount,0.00)
where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
</cfquery>
    
<cfquery name="getList_qry" datasource="#dts#">
SELECT *,tax_no as nomajikan 
FROM pmast AS a LEFT JOIN eatable AS b ON a.empno=b.empno
LEFT JOIN (
    SELECT empno,right(replace(tax_no,'-',''),11) tax_no,
    bb.name compName,bb.add1 compAdd1,bb.add2 compAdd2,bb.add3 compAdd3,bb.add4 compAdd4,bb.add5 compAdd5
    FROM (
        SELECT * FROM (
            SELECT empno,branch FROM #replace(dts,'_p','_i')#.assignmentslip 
            WHERE payrollperiod<>99 
            ORDER BY payrollperiod desc
        ) assign 
        GROUP BY empno
    ) aa 
    LEFT JOIN (SELECT * FROM #replace(dts,'_p','_i')#.invaddress GROUP BY shortcode) bb
    ON branch=shortcode
) AS c
ON a.empno=c.empno
WHERE a.empno = '#empno#'
</cfquery> 
 
<cfset DATE = #DateFormat(Now(), "dd-mm-yyyy")#>
<cfset YDATE = form.yearchose>

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

<cfreport template="EA2017 Form.cfr" format="PDF" query="getList_qry">
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
    <cfreportparam name="dts" value="#dts#">
</cfreport>

