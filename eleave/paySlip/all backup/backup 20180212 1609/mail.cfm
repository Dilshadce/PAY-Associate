

<cfquery datasource="manpower_p" name="getEmp">
	SELECT empno FROM emp_users where userName = '#getAuthUser()#'
</cfquery>
<cfoutput>#getEmp.empno#</cfoutput>

<cfset dts = "manpower_i" >
<cfsetting requesttimeout="0" >

<cfscript>

	testTable = [];

	sumFields = ['selfsalary','selfexception',
				 'selfcpf','selfsdf','selftotal',
				 "lvltotalee1"
				 ];

	OTFields = [];
	deductionFields = [];

	// OT fields
	for(i = 1 ; i <= 8; i = i+1){
		ArrayAppend(OTFields,"selfOT"&i);
	}

	//deductions
	for(i=1; i<=3; i = i+1 ){
		ArrayAppend(deductionFields,"ded"&i);
	}

	sumFields.addAll(OTFields);
	sumFields.addAll(deductionFields);

</cfscript>
<cfquery name="getAssignment" datasource="manpower_p">
	SELECT SUM(EPFCC) as sum_EPFCC, SUM(SOCSOCC) as sum_SOCSOCC,
	(SELECT department from manpower_i.placement where placementno = a.placementno ) as dept,
	<cfloop array="#sumFields#" index="i">
		<cfoutput>
			SUM(#i#) as 'sum_#i#',
		</cfoutput>
	</cfloop>
	a.*,YEAR(assignmentslipdate) as a_year
	 FROM (
	SELECT aa.*,p.socsono,p.nricn,p.epfno,p.itaxno, p.bankcode, p.bankaccno,
	(SELECT invnogroup from manpower_i.bo_jobtypeinv WHERE
	jobtype = ( SELECT jobpostype from manpower_i.placement where placementno = aa.placementno) and officecode =
	 ( SELECT location from manpower_i.placement where placementno = aa.placementno)
	) as entity,
	CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN EPFCC is null then 0 else EPFCC END FROM pay2_12m_fig where empno = aa.empno
		AND TMONTH = '#form.month#')
	else
		(SELECT CASE WHEN EPFCC is null then 0 else EPFCC END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END as EPFCC,
	CASE WHEN aa.paydate = "paytran" then
		(SELECT CASE WHEN SOCSOCC is null then 0 else SOCSOCC END FROM pay2_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	else
		(SELECT CASE WHEN SOCSOCC is null then 0 else SOCSOCC END FROM pay1_12m_fig where empno = aa.empno AND TMONTH = '#form.month#')
	END as SOCSOCC,
	if(claimadd1 = 'Y',coalesce(addchargeself,0),0)+if(claimadd2 = 'Y',coalesce(addchargeself2,0),0)+if(claimadd3 = 'Y',coalesce(addchargeself3,0),0)+if(claimadd4 = 'Y',coalesce(addchargeself4,0),0)+if(claimadd5 = 'Y',coalesce(addchargeself5,0),0)+if(claimadd6 = 'Y',coalesce(addchargeself6,0),0) as totalamt
	FROM manpower_i.assignmentslip aa
	LEFT JOIN manpower_p.pmast p ON aa.empno = p.empno
	WHERE batches != ''
	AND payrollperiod = "1"
	and aa.empno = "#getEmp.empno#"
	) as a
	group by empno
	order by a.custno, a.empno;
</cfquery>



<cfloop query="getAssignment">
<cfquery name="getEntity" datasource="#dts#">
	SELECT * FROM manpower_i.invaddress WHERE invNogroup = "#getAssignment.entity#"
</cfquery>
	<cfquery name="getPayYTD" datasource="manpower_p">
		SELECT *,CASE WHEN DED115 is null then 0 else DED115 end as DED115
		FROM pay_ytd where empno = "#getAssignment.empno#";
	</cfquery>
	<cfquery name="getAw" datasource="#dts#">
		SELECT refno,batches,
		<cfloop from='1' to="18" index="i">
			awee#i#, allowance#i#,
			</cfloop>
			<cfloop from='1' to="6" index="i">
				fixawcode#i#,fixawee#i#,
			</cfloop>
			(SELECT invnogroup from manpower_i.bo_jobtypeinv WHERE
				jobtype = ( SELECT jobpostype from manpower_i.placement where placementno = aa.placementno) and officecode =
				 ( SELECT location from manpower_i.placement where placementno = aa.placementno)
			) as entity

			FROM manpower_i.assignmentslip aa
			WHERE batches != ''
			AND payrollperiod = "1"


			and aa.empno = "#getAssignment.empno#"
			having entity = "#form.entity#"
	</cfquery>
	<cfquery name="getPCB" datasource="#dts#">
		SELECT CASE WHEN SUM(funddd) IS NOT NULL THEN SUM(funddd) ELSE 0 END as PCB FROM manpower_i.icgiro c
		WHERE empno = "#getAssignment.empno#"
		and (SELECT appstatus from manpower_i.argiro WHERE uuid = c.uuid ORDER BY submited_on DESC LIMIT 1) = "Approved"
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
	     	ArrayAppend(deductions_amt,getAssignment.sum_selfCPF);

	     }
	     if(getAssignment.sum_selfSDF > 0 ){
	     	ArrayAppend(deductions,"EMPLOYEE SOCSO");
	     	ArrayAppend(deductions_amt,getAssignment.sum_selfSDF);
	     }

	     if( getPCB.PCB > 0){
	     	ArrayAppend(deductions,"EMPLOYEE Tax");
	     	ArrayAppend(deductions_amt,getPCB.PCB);
	     }

		 if(getAssignment.sum_lvltotalee1 != 0 and getAssignment.sum_lvltotalee1 != ''){
		 	ArrayAppend(deductions,"NPL");
		 	ArrayAppend(deductions_amt , (getAssignment.sum_lvltotalee1 * -1));
		 }

		// adding OT FIELDS

		OTLabels = ["OT 1.0","OT 1.5","OT 2.0","OT 3.0", "RD 1.0","RD 2.0","PH 1.0","PH 2.0"];
		 for(i = 1; i <= ArrayLen(OTFields); i = i + 1){
		 	if(getAssignment["sum_" & OTFields[i]][getAssignment.currentRow] > 0 ){
				ArrayAppend(earnings,OTLabels[i]);
				ArrayAppend(earnings_amt,getAssignment["sum_" & OTFields[i]][getAssignment.currentRow] );
		 	}
	 	}

	 	allowances = StructNew();
		for(i = 1; i <= getAw.recordCount; i++){
			for(aw = 1; aw<= 18; aw++){ // variable allowances
				if(getAw['awee'&aw][i] > 0){
					addToAllowance(getAw['allowance'&aw][i],getAw['awee'&aw][i]);

				}
			}

			for(fixaw= 1; fixaw <= 6; fixaw++){ //fixed allowances
				if(getAw['fixawee'&fixaw][i] > 0){
						addToAllowance(getAw['fixawcode'&fixaw][i],getAw['fixawee'&fixaw][i]);

				}
			}

		}


		for(key in allowances){
				ArrayAppend(earnings,getAllowance(key));
				ArrayAppend(earnings_amt,allowances[key]);
		}


		// adding deduction fields
		for(i = 1; i <= ArrayLen(deductionFields); i = i + 1){
		 	if(getAssignment["sum_" & deductionFields[i]][getAssignment.currentRow] > 0 ){
				ArrayAppend(deductions,getAssignment["ded" & i & "desp"][getAssignment.currentRow]);
				ArrayAppend(deductions_amt,getAssignment["sum_" & deductionFields[i]][getAssignment.currentRow] );
		 	}
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

		totalEarnings = 0;
		 for(i = 1; i <= ArrayLen(earnings_amt); i++){
		 	totalEarnings += earnings_amt[i];
		 }

		 totalDeductions = 0;
		 for(i=1; i <= ArrayLen(deductions_amt); i++){
		 	totalDeductions += deductions_amt[i];
		 }
		 nettPay = getAssignment.sum_selftotal - getPCB.PCB;

		//  y_epf = numberFormat(getAssignment.sum_selfCPF,'9.99') & " / " & numberformat(EPFCC,'9.99');
		// y_socso = numberformat(getAssignment.sum_selfSDF,'9.99') & " / " & numberformat(SOCSOCC,'9.99');
		 y_epf = numberFormat(getPayYTD.EPFWW,'9.99') & " / " & numberformat(getPayYTD.EPFCC,'9.99');
		 y_socso = numberformat(getPayYTD.SOCSOWW,'9.99') & " / " & numberformat(getPayYTD.SOCSOCC,'9.99');
		 tax = getPayYTD.DED115;

		function addToAllowance(code,value){
			if(StructKeyExists(allowances,code)){
				allowances[code] += value;
			}else{
				allowances[code] = value;
			}
		}


		params = {
		 "compName" : getEntity.name,
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
		 "totalEarnings" : totalEarnings,
		 "totalDeductions" : totalDeductions,
		 "nett" : nettPay,
		 "EPFCC" : getAssignment.EPFCC,
		 "SOCSOCC" : getAssignment.SOCSOCC,
		 "YTDNett" : nettPay,
		 "YTDGROSS" : getPayYTD.GROSSPAY,
		 "YTDEPFCC" : getPayYTD.EPFCC,
		 "YTDEPFWW" : getPayYTD.EPFWW,

		 "YTDSOCSOCC" : getPayYTD.SOCSOCC,
		 "YTDSOCSOWW" : getPayYTD.SOCSOWW,
		 "YTDTax" : getPayYTD.DED115
		};
	</cfscript>

	<cfreport template="payslip.cfr" format="PDF">
		<cfloop collection="#params#" item="field">
			<cfreportparam name="#field#" value="#params[field]#">
		</cfloop>
		<!---            <cfreportparam name="nextmonth" value="#nextmonth#">--->
	</cfreport>
</cfloop>

<cffunction name="getAllowance" access="public">
	<cfargument name="code">
	<cfquery name="shelf" datasource="manpower_i">
		SELECT*  FROM icshelf where shelf = '#code#';
	</cfquery>
	<cfreturn shelf.DESP>
</cffunction>
