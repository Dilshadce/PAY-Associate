<cfquery datasource="#dsname#" name="getEmp">
	SELECT empno,
	(SELECT nricn FROM pmast where empno = emp_users.empno) as nric,
	(SELECT passport FROM pmast where empno = emp_users.empno) as passport 
FROM emp_users where userName = '#getAuthUser()#'
</cfquery>
<cfset dts = "#replace(dsname,'_p','_i')#" >
<cfsetting requesttimeout="3500" >

<cfscript>

	testTable = [];

	sumFields = ['selfsalary','selfexception',
				 'selfcpf','selfsdf','selftotal',
				 "lvltotalee1"
				 ];

	OTFields = [];
	OTHourFields = [];
	deductionFields = [];

	// OT fields
	for(i = 1 ; i <= 8; i = i+1){
		ArrayAppend(OTFields,"selfOT"&i);
	}
	
	// OT Hour fields
	for(i = 1 ; i <= 8; i = i+1){
		ArrayAppend(OTHourFields,"selfOTHour"&i);
	}

	//deductions
	for(i=1; i<=3; i = i+1 ){
		ArrayAppend(deductionFields,"ded"&i);
	}

	sumFields.addAll(OTFields);
	sumFields.addAll(OTHourFields);
	sumFields.addAll(deductionFields);

</cfscript>
<cfquery name="getAssignment" datasource="#dsname#">
	SELECT SUM(EPFCC) as sum_EPFCC, SUM(SOCSOCC) as sum_SOCSOCC,
	(SELECT department from #dts#.placement where placementno = a.placementno ) as dept,
	<cfloop array="#sumFields#" index="i">
		<cfoutput>
			SUM(#i#) as 'sum_#i#',
		</cfoutput>
	</cfloop>
	a.*,YEAR(assignmentslipdate) as a_year
	 FROM (
	SELECT aa.*,p.socsono,p.nricn,p.epfno,p.itaxno, p.bankcode, p.bankaccno,
	(SELECT invnogroup from #dts#.bo_jobtypeinv WHERE
	jobtype = ( SELECT jobpostype from #dts#.placement where placementno = aa.placementno) and officecode =
	 ( SELECT location from #dts#.placement where placementno = aa.placementno)
	) as entity,

	<!---CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN SUM(EPFCC) is null then 0 else SUM(EPFCC)  END FROM pay2_12m_fig where empno = aa.empno
		AND TMONTH = '#form.month#')
	else
		(SELECT CASE WHEN SUM(EPFCC) is null then 0 else SUM(EPFCC)  END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END as EPFCC,

	CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN SOCSOCC is null then 0 else SOCSOCC END FROM pay2_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	else
		(SELECT CASE WHEN SOCSOCC is null then 0 else SOCSOCC END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END as SOCSOCC,

	CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN SUM(ded115) is null then 0 else SUM(ded115) END FROM pay2_12m_fig where empno = aa.empno
		AND TMONTH = '#form.month#')
	else
		(SELECT CASE WHEN SUM(ded115) is null then 0 else SUM(ded115)  END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END as DED115,--->
	<!---CASE WHEN aa.paydate = "paytran" then--->
		(SELECT CASE WHEN SUM(coalesce(c.EPFCC,0.00)+coalesce(cc.EPFCC,0.00)) is null then 0 else SUM(coalesce(c.EPFCC,0.00)+coalesce(cc.EPFCC,0.00))  END FROM pay1_12m_fig c
        LEFT JOIN  pay2_12m_fig cc on c.empno=cc.empno  
        where c.empno = aa.empno
		AND c.TMONTH = '#form.month#'
        AND cc.TMONTH = '#form.month#')
	<!---else
		(SELECT CASE WHEN SUM(EPFCC) is null then 0 else SUM(EPFCC)  END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END---> as EPFCC,

	<!---CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN SOCSOCC is null then 0 else SOCSOCC END FROM pay2_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	else--->
		(SELECT CASE WHEN SUM(coalesce(d.SOCSOCC,0.00)+coalesce(dd.SOCSOCC,0.00)) is null then 0 else SUM(coalesce(d.SOCSOCC,0.00)+coalesce(dd.SOCSOCC,0.00)) END FROM pay1_12m_fig d
         LEFT JOIN  pay2_12m_fig dd on d.empno=dd.empno  
        where d.empno = aa.empno
		AND d.TMONTH = '#form.month#'
        AND dd.TMONTH = '#form.month#')
	<!---END---> as SOCSOCC,

	<!---CASE WHEN aa.paydate = "paytran" then--->
		(SELECT CASE WHEN SUM(coalesce(b.ded115,0.00)+coalesce(bb.ded115,0.00)+coalesce(b.ded114,0.00)+coalesce(bb.ded114,0.00)) is null then 0 
        else SUM(coalesce(b.ded115,0.00)+coalesce(bb.ded115,0.00)+coalesce(b.ded114,0.00)+coalesce(bb.ded114,0.00)) END FROM pay1_12m_fig b 
        LEFT JOIN pay2_12m_fig bb on b.empno=bb.empno 
        WHERE b.empno = aa.empno
		AND b.TMONTH = '#form.month#'
        AND bb.TMONTH = '#form.month#')
	<!---else
		(SELECT CASE WHEN SUM(ded115+ded114) is null then 0 else SUM(ded115+ded114)  END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END---> as DED115,

	if(claimadd1 = 'Y',coalesce(addchargeself,0),0)+if(claimadd2 = 'Y',coalesce(addchargeself2,0),0)+if(claimadd3 = 'Y',coalesce(addchargeself3,0),0)+if(claimadd4 = 'Y',coalesce(addchargeself4,0),0)+if(claimadd5 = 'Y',coalesce(addchargeself5,0),0)+if(claimadd6 = 'Y',coalesce(addchargeself6,0),0) as totalamt
	FROM #dts#.assignmentslip aa
	LEFT JOIN #dsname#.pmast p ON aa.empno = p.empno
	WHERE batches != ''
	AND payrollperiod = "#form.month#"

	and aa.empno = "#getEmp.empno#"


	) as a
	<!---group by empno--->
	order by a.custno, a.empno;
</cfquery>

<cfif getAssignment.payrollperiod eq ''>
	<cfoutput>
	<script type="text/javascript">
		alert('There are no Pay Slip found for the selected month.');
		window.location="/eleave/payslip/printpayslip.cfm";
	</script>
	</cfoutput>
	<cfabort>
</cfif>


<cfloop query="getAssignment">
<cfquery name="getEntity" datasource="#dts#">
	SELECT * FROM invaddress WHERE invNogroup = "#getAssignment.entity#"
</cfquery>
	<cfquery name="getPayYTD" datasource="#dsname#">
	SELECT SUM(grosspay) as grosspay,sum(netpay) as netpay,SUM(EPFWW) as EPFWW,SUM(EPFCC) as EPFCC, SUM(DED115) as DED115,
	SUM(SOCSOWW) as SOCSOWW, SUM(SOCSOCC) as SOCSOCC
	 FROM (
		SELECT
			case when SUM(grosspay) is null then 0 else SUM(grosspay) end as grosspay,
			CASE WHEN SUM(netPay) is null then 0 else SUM(netpay) end as netpay,
			CASE WHEN SUM(EPFWW) +SUM(EPFWW_ADJUSTMENT) is null then 0 else sum(EPFWW) +SUM(EPFWW_ADJUSTMENT) end as EPFWW,
			CASE WHEN SUM(EPFCC) +SUM(EPFCC_ADJUSTMENT)  is null then 0 else SUM(EPFCC) +SUM(EPFCC_ADJUSTMENT)  end as EPFCC,
			<!---CASE WHEN SUM(DED115) is null then 0 else SUM(DED115) end as DED115,--->
			CASE WHEN SUM(coalesce(DED115,0.00)+coalesce(DED114,0.00)) is null then 0 else SUM(coalesce(DED115,0.00)+coalesce(DED114,0.00)) end as DED115,
			CASE WHEN SUM(SOCSOWW) IS NULL THEN 0 ELSE SUM(SOCSOWW) END AS SOCSOWW,
			CASE WHEN SUM(SOCSOCC) IS NULL THEN 0 ELSE SUM(SOCSOCC) END AS SOCSOCC
			FROM pay1_12m_fig where empno = "#getAssignment.empno#" AND TMONTH <= "#form.month#"

		UNION

		SELECT
			case when SUM(grosspay) is null then 0 else SUM(grosspay) end as grosspay,
			CASE WHEN SUM(netPay) is null then 0 else SUM(netpay) end as netpay,
			CASE WHEN SUM(EPFWW) +SUM(EPFWW_ADJUSTMENT) is null then 0 else sum(EPFWW) +SUM(EPFWW_ADJUSTMENT) end as EPFWW,
			CASE WHEN SUM(EPFCC)  +SUM(EPFCC_ADJUSTMENT) is null then 0 else SUM(EPFCC) +SUM(EPFCC_ADJUSTMENT)  end as EPFCC,
			<!---CASE WHEN SUM(DED115) is null then 0 else SUM(DED115) end as DED115,--->
			CASE WHEN SUM(coalesce(DED115,0.00)+coalesce(DED114,0.00)) is null then 0 else SUM(coalesce(DED115,0.00)+coalesce(DED114,0.00)) end as DED115,
			CASE WHEN SUM(SOCSOWW) IS NULL THEN 0 ELSE SUM(SOCSOWW) END AS SOCSOWW,
			CASE WHEN SUM(SOCSOCC) IS NULL THEN 0 ELSE SUM(SOCSOCC) END AS SOCSOCC
			FROM pay2_12m_fig where empno = "#getAssignment.empno#" AND TMONTH <= "#form.month#"
		) t
	</cfquery>
	<cfquery name="getAw" datasource="#dts#">
		SELECT refno,batches,
		<cfloop from='1' to="18" index="i">
			awee#i#, allowance#i#,
			</cfloop>
			<cfloop from='1' to="6" index="i">
				fixawcode#i#,fixawee#i#,
			</cfloop>
			(SELECT invnogroup from bo_jobtypeinv WHERE
				jobtype = ( SELECT jobpostype from placement where placementno = aa.placementno) and officecode =
				 ( SELECT location from placement where placementno = aa.placementno)
			) as entity

			FROM assignmentslip aa
			WHERE batches != ''
			AND payrollperiod = "#form.month#"


			and aa.empno = "#getAssignment.empno#"
	</cfquery>
	<cfquery name="getPCB" datasource="#dts#">
		SELECT CASE WHEN SUM(funddd) IS NOT NULL THEN SUM(funddd) ELSE 0 END as PCB FROM icgiro c
		WHERE empno = "#getAssignment.empno#"
		and (SELECT appstatus from #dts#.argiro WHERE uuid = c.uuid ORDER BY submited_on DESC LIMIT 1) = "Approved"
		AND batchno IN (
			<cfloop query="#getAw#">
				'#getAw.batches#',
				</cfloop>''
		);
	</cfquery>
	<cfscript>


		//initialize the earnings and deductions columns
		 earnings = ["Normal"];
	     earnings_amt = [getAssignment.sum_selfsalary];

		  deductions = [];
		 deductions_amt = [];
	     if(getAssignment.sum_selfCPF > 0 ){
	     	ArrayAppend(deductions,"EMPLOYEE EPF");
	     	ArrayAppend(deductions_amt,numberformat(getAssignment.sum_selfCPF,'.__'));
	     }
	     if(getAssignment.sum_selfSDF > 0 ){
	     	ArrayAppend(deductions,"EMPLOYEE SOCSO");
	     	ArrayAppend(deductions_amt,numberformat(getAssignment.sum_selfSDF,'.__'));
	     }

	     if( getAssignment.DED115 > 0){
	     	ArrayAppend(deductions,"EMPLOYEE Tax");
	     	ArrayAppend(deductions_amt,getAssignment.DED115);
	     }

		 if(getAssignment.sum_lvltotalee1 != 0 and getAssignment.sum_lvltotalee1 != ''){
		 	ArrayAppend(deductions,"NPL");
		 	ArrayAppend(deductions_amt , (getAssignment.sum_lvltotalee1 * -1));
		 }

		// adding OT FIELDS

		OTLabels = ["OT 1.0","OT 1.5","OT 2.0","OT 3.0", "RD 1.0","RD 2.0","PH 1.0","PH 2.0"];
		 for(i = 1; i <= ArrayLen(OTFields); i = i + 1){
		 	if(getAssignment["sum_" & OTFields[i]][getAssignment.currentRow] > 0 ){
				ArrayAppend(earnings,OTLabels[i]&' - '&numberformat(getAssignment["sum_" & OTHourFields[i]][getAssignment.currentRow],'_.__')&' Hour(s)');
				ArrayAppend(earnings_amt,getAssignment["sum_" & OTFields[i]][getAssignment.currentRow] );
		 	}
	 	}

	 	allowances = StructNew();
		for(i = 1; i <= getAw.recordCount; i++){
			for(aw = 1; aw<= 18; aw++){ // variable allowances

				if(getAw['awee'&aw][i] != 0 ){
					addToAllowance(getAw['allowance'&aw][i],getAw['awee'&aw][i]);

				}
			}

			for(fixaw= 1; fixaw <= 6; fixaw++){ //fixed allowances
				if(getAw['fixawee'&fixaw][i]  != 0 ){
						addToAllowance(getAw['fixawcode'&fixaw][i],getAw['fixawee'&fixaw][i]);

				}
			}

		}

		for(key in allowances){
			if(allowances[key] > 0){
				ArrayAppend(earnings,getAllowance(key));
				ArrayAppend(earnings_amt,numberformat(allowances[key],'.__'));
				}else{
					ArrayAppend(deductions,getAllowance(key));
				ArrayAppend(deductions_amt,numberformat((allowances[key] * -1),'.__'));
				}
		}


		// adding deduction fields
		for(i = 1; i <= ArrayLen(deductionFields); i = i + 1){
		 	if(getAssignment["sum_" & deductionFields[i]][getAssignment.currentRow] > 0 ){
				ArrayAppend(deductions,getAssignment["ded" & i & "desp"][getAssignment.currentRow]);
				ArrayAppend(deductions_amt,getAssignment["sum_" & deductionFields[i]][getAssignment.currentRow] );
		 	}
		 }


		 totalEarnings = 0;
		 totalDeductions = 0;

		 for(i = 1; i <= ArrayLen(earnings); i++){
		 	totalEarnings += val(trim(earnings_amt[i]));
		 }

		 for(i = 1;i <= ArrayLen(deductions); i++){
		 	totalDeductions += deductions_amt[i];
		 }


		// Y-T-D amount
		 tgrossPay = getPayYTD.grosspay;
		 tnettPay = getPayYTD.netpay;


		 if(getPayYTD.DED115 == ""){
		 	getPayYTD.DED115 = 0;
		 }

		 if(getPayYTD.SOCSOWW == ""){
		 	getPayYTD.SOCSOWW = 0;
		 }

		 if(getPayYTD.EPFWW == ""){
		 	getPayYTD.EPFWW = 0;
		 }

		 nettPay = val(getAssignment.sum_selftotal) - val(getAssignment.DED115);
		 //y_epf = numberFormat(getAssignment.sum_selfCPF,'9.99') & " / " & numberformat(EPFCC,'9.99');
		 //y_socso = numberformat(getAssignment.sum_selfSDF,'9.99') & " / " & numberformat(SOCSOCC,'9.99');
		 y_epf = numberFormat(getPayYTD.EPFWW,'9.99') & " / " & numberformat(getPayYTD.EPFCC,'9.99');
		 y_socso = numberformat(getPayYTD.SOCSOWW ,'9.99') & " / " & numberformat(getPayYTD.SOCSOCC,'9.99');
		 tax = getPayYTD.DED115;


		params = {
		 "compName" : getEntity.name,
		 "empNo" : getAssignment.empno,
		 "empName" : getAssignment.empname,
		 "date" : 	getAssignment.a_year & '-' & left(MonthAsString(getAssignment.payrollperiod),3),
		 "epfNo" : getAssignment.epfno,
		 "icNo" : getAssignment.nricn,
		 "socsoNo" : getAssignment.socsoNo,
		 "taxNo" : getAssignment.iTaxNo,
		 "dept" : getAssignment.dept,
		 "bank" : #getAssignment.bankcode# & " " & #getAssignment.bankaccno#,
		 "earningsName" : ArrayToList(earnings,chr(13)),
		 'earningsAmt' : ArrayToList(earnings_amt,chr(13)),
		 "deductionsName" : ArrayToList(deductions,chr(13)),
		 "deductionsAmt" : ArrayToList(deductions_amt,chr(13)),
		 "totalEarnings" : numberFormat(totalEarnings,"9.99"),
		 "totalDeductions" : numberFormat(totalDeductions,"9.99"),
		 "nett" : numberFormat(nettPay,"9.99"),
		 "EPFCC" : numberFormat(getAssignment.EPFCC,"9.99"),
		 "SOCSOCC" : numberFormat(getAssignment.SOCSOCC,"9.99"),
		 "YTDNett" : numberFormat(getPayYTD.netPay,"9.99"),
		 "YTDGROSS" : numberFormat(getPayYTD.GROSSPAY,"9.99"),
		 "YTDEPFCC" : numberFormat(getPayYTD.EPFCC,"9.99"),
		 "YTDEPFWW" : numberFormat(getPayYTD.EPFWW,"9.99"),

		 "YTDSOCSOCC" : numberFormat(getPayYTD.SOCSOCC,"9.99"),
		 "YTDSOCSOWW" : numberFormat(getPayYTD.SOCSOWW,"9.99"),
		 "YTDTax" : numberFormat(getPayYTD.DED115,"9.99")
		};

		function addToAllowance(code,value){
			if(StructKeyExists(allowances,code)){
				allowances[code] += value;
			}else{
				allowances[code] = value;
			}
		}
	</cfscript>

	<cfif #getEmp.nric# neq "">
		<cfset payslippassword = "#getEmp.nric#">
	<cfelseif #getEmp.passport# neq "">
		<cfset payslippassword = "#getEmp.passport#">
	<cfelse>
		<cfset payslippassword = "">
	</cfif>	

<!---<cfoutput>#ArrayToList(earnings_amt,chr(13))#</cfoutput><cfabort>--->
	<cfreport template="payslip.cfr" permissions="allowprinting" filename="#getEmp.empno#_payslip.pdf"  format="PDF" userpassword="#payslippassword#"
	overwrite="yes"
	encryption="128-bit"
	>
		<cfloop collection="#params#" item="field">
			<cfreportparam name="#field#" value="#params[field]#">
		</cfloop>
		<!---            <cfreportparam name="nextmonth" value="#nextmonth#">--->
	</cfreport>
<cfoutput>C:/inetpub/wwwroot/PAY-Associate/eleave/paySlip/#getEmp.empno#_payslip.pdf</cfoutput>


<cfheader name="Content-Disposition" value="attachment;filename=payslip.pdf">
<cfcontent type="application/octet-stream" file="C:/NEWSYSTEM/PAY-Associate/eleave/paySlip/#getEmp.empno#_payslip.pdf" deletefile="Yes">

</cfloop>

<cffunction name="getAllowance" access="public">
	<cfargument name="code">
	<cfquery name="shelf" datasource="#dts#">
		SELECT*  FROM icshelf where shelf = '#code#';
	</cfquery>
	<cfreturn shelf.DESP>
</cffunction>
