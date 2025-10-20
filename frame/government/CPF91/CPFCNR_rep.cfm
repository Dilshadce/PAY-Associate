<cfquery name="getaddress" datasource="#dts#">
SELECT *
FROM address 
WHERE CATEGORY = '#form.cat#' 
AND org_type in ('CPF')
</cfquery>

<cfquery name="getEmp" datasource="#dts#">
SELECT *
FROM pmast
WHERE EMPNO = EMPNO
 <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
							<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
							AND paystatus = "A"
</cfquery>


<cfquery name="getList_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN bonu_12m AS b ON a.empno=b.empno
WHERE epfcat = '#form.cat#' <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
							<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>

<cfquery name="get_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN comm_12m AS c ON a.empno=c.empno
WHERE epfcat = '#form.cat#' <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
							<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>

<cfquery name="List_qry" datasource="#dts#">
SELECT *
FROM pmast AS a LEFT JOIN pay_12m AS d ON a.empno=d.empno
WHERE epfcat = '#form.cat#' <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
							<cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
</cfquery>

<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset date = #dateFormat(Now(),"dd/mm/yyyy")#>

<cfswitch expression="#form.result#">
	
<cfcase value="HTML">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF CNR / FORM CARP</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfset sum1 = 0>
<cfset sum2 = 0>
<cfset sum3 = 0>
<cfset sum4 = 0>
<cfset sum5 = 0>
<cfset sum6 = 0>

<cfloop query="getEmp">
<cfset mon = val(getList_qry.NUMOFMTH)>
                <cfset wage_ordinary = List_qry.epf_pay>
                <cfset wage_add = (val(getList_qry.epf_pay)+val(get_qry.epf_pay) )>
                <cfset num1 = (val(getList_qry.epfcc)+val(getList_qry.epfccext)+val(get_qry.epfcc)+val(get_qry.epfccext)) >
                <cfset ordinary_employer = (val(List_qry.epfcc) + val(List_qry.epfccext) - num1)>
                <cfset ordinary_employee = val(List_qry.epfww)+val(List_qry.epfwwext)-(val(getList_qry.epfww)+val(getList_qry.epfwwext)+val(get_qry.epfww)+val(get_qry.epfwwext)) >
                <cfset add_employer = (val(getList_qry.epfcc)+val(getList_qry.epfccext)+val(get_qry.epfcc)+val(get_qry.epfccext) )>
                <cfset add_employee = (val(getList_qry.epfww)+val(getList_qry.epfwwext)+val(get_qry.epfww)+val(get_qry.epfwwext) )>
				<cfset sum1 = sum1 + val(wage_ordinary)>
                <cfset sum2 = sum2 + val(wage_add)>
                <cfset sum3 = sum3 + val(ordinary_employer)>
                <cfset sum4 = sum4 + val(ordinary_employee)>
                <cfset sum5 = sum5 + val(add_employer)>
                <cfset sum6 = sum6 + val(add_employee)>	
<cfif sum1 neq "0" OR sum2 neq "0" OR sum3 neq "0" OR sum4 neq "0" OR sum5 neq "0" OR sum6 neq "0">
	<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="page-break-after:always">
<!--- <cfoutput> --->
  <tr>
    <td colspan="2"><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>CENTRAL PROVIDENT FUND BOARD </td>
      </tr>
      <tr>
        <td>#getaddress.addr1# </td>
      </tr>
      <tr>
        <td>#getaddress.addr2# </td>
      </tr>
      <tr>
        <td>#getaddress.addr3# </td>
      </tr>
      <tr>
        <td>#getaddress.addr4# </td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2">APPLICATION FOR REFUND OF EXCESS CONTRIBUTIONS ON ADDITIONAL WAGES </td>
  </tr>
  <tr>
    <td colspan="2"><table width="100%" border="1" cellspacing="0" cellpadding="0">
      <tr>
        <td><table border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td colspan="6">IMPORTANT: Please read the important notes, authorisation and indernity stated overleaf before completing this application form </td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(A) PARTICULAR OF EMPLOYER </td>
          </tr>
          <tr>
            <td width="140">Name of Company : </td>
            <td width="13">#getComp_qry.COMP_NAME#</td>
            <td colspan="3" align="right">Reference No : </td>
            <td width="337">&nbsp;</td>
          </tr>
          <tr>
            <td>Address : </td>
            <td>#getComp_qry.COMP_ADD1# #getComp_qry.COMP_ADD2# #getComp_qry.COMP_ADD3#</td>
            <td colspan="3" align="right">Fax : </td>
            <td>#getComp_qry.COMP_FAX#</td>
          </tr>
          <tr>
            <td>Contact Officer : </td>
            <td>#getComp_qry.PM_NAME#</td>
            <td colspan="3" align="right">Tel : </td>
            <td>#getComp_qry.COMP_PHONE#</td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(B) PARTICULARS OF EMPLOYEE </td>
          </tr>
          <tr>
            <td>Name of Employee : </td>
            <td>#getEmp.name#</td>
            <td colspan="3"  align="right" >NRIC No: </td>
            <td>#getEmp.nricn#</td>
          </tr>
          <tr>
            <td>Email : </td>
            <td>&nbsp;</td>
            <td colspan="3" align="right">Tel : </td>
            <td>#getEmp.phone#</td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(C) WAGE &amp; CONTRIBUTION DETAILS OF EMPLOYEE </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="1" cellpadding="3" cellspacing="0" >
                <tr align="center">
                  <td colspan="3" >Wages Paid ($) </td>
                  <td colspan="2">Contribution Paid on ordinary Wages ($)</td>
                  <td colspan="2">Contribution Paid on Additional Wages ($)</td>
                </tr>
                <tr align="center">
                  <td>Month </td>
                  <td>Ordinary </td>
                  <td>Additional </td>
                  <td>Employer</td>
                  <td>Employee</td>
                  <td>Employer</td>
                  <td>Employee</td>
                </tr>
                
                <tr align="center">
                  <td>#mon#</td>
                  <td align="right">#NumberFormat(wage_ordinary, ",_.__")#</td>
                  <td align="right">#NumberFormat(wage_add, ",_.__")#</td>
                  <td align="right">#NumberFormat(ordinary_employer, ",_.__")#</td>
                  <td align="right">#NumberFormat(ordinary_employee, ",_.__")#</td>
                  <td align="right">#NumberFormat(add_employer, ",_.__")#</td>
                  <td align="right">#NumberFormat(add_employee, ",_.__")#</td>
                </tr>
                
                <tr align="center">
                  <td>Total</td>
                  <td align="right">#NumberFormat(sum1, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum2, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum3, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum4, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum5, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum6, ",_.__")#</td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(D) DECLARATION BY EMPLOYER </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                  <td width="17">1) </td>
                  <td width="1185">Preceding Year Additional Wage Ceiling Applied? Yes / No* </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>if Yes, Please specify Total Wages in preceding year </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Total Wages :$ _________________</td>
                        <td>Total Ordinary Wages : $ _________________</td>
                        <td>Total Ordinary Wages $ _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>2) </td>
                  <td>Employee left employment? Yes/No* </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>If Yes, please indicate lasat date of employment __________ (dd/mm/ccyy) </td>
                </tr>
                <tr>
                  <td>3)</td>
                  <td> Employer's Bank Account Information (For Non-GIRO employers only) </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>Please attach a copy of the Bank Statement ( Showing the name and bank account no. of employer). </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td ><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Bank Name :_________________</td>
                        <td>Branch :_________________</td>
                        <td>Bank Account No : _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>4)</td>
                  <td colspan="2">We certify that the information given in this form is true, correct and complete. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">I / We agree to the authorisation and indernity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>________________________________</td>
                        <td>______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Name / Designation of Authorised Officer </td>
                        <td>Signature of Authorised Officer &amp; Company Stamp </td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>5)</td>
                  <td colspan="2">I certify that the employer's bank account information is true and correct. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">I / We agree to the authorisation and indernnity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>________________________________</td>
                        <td>_______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Name / Designation of Authorised Officer </td>
                        <td>Signature of Authorised Officer &amp; Company Stamp </td>
                      </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(E) DECLARATION BY EMPLOYEE </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                  <td width="2%">1) </td>
                  <td width="98%">Employee's bank Account Information. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>Please attach a copy of the Bank Book or Bank Statement ( showing the name and bank account no. of employee). </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Bank Name :_________________</td>
                        <td>Branch :_________________</td>
                        <td>Bank Account No : _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>2)</td>
                  <td>I certify that the wage &amp; contribution details and my book account information stated in this form is true, correct and complete. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>I agree to the authorisation and indernnity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Signature of Employee </td>
                      </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  </cfoutput>
</table>
</cfif>
</cfloop>
</body>
</html>
</cfcase>

<cfcase value="EXCELDEFAULT">
<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=CPFRefundReport.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>CPF CNR / FORM CARP</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/report.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfset sum1 = 0>
<cfset sum2 = 0>
<cfset sum3 = 0>
<cfset sum4 = 0>
<cfset sum5 = 0>
<cfset sum6 = 0>

<cfloop query="getEmp">
<cfset mon = val(getList_qry.NUMOFMTH)>
                <cfset wage_ordinary = List_qry.epf_pay>
                <cfset wage_add = (val(getList_qry.epf_pay)+val(get_qry.epf_pay) )>
                <cfset num1 = (val(getList_qry.epfcc)+val(getList_qry.epfccext)+val(get_qry.epfcc)+val(get_qry.epfccext)) >
                <cfset ordinary_employer = (val(List_qry.epfcc) + val(List_qry.epfccext) - num1)>
                <cfset ordinary_employee = val(List_qry.epfww)+val(List_qry.epfwwext)-(val(getList_qry.epfww)+val(getList_qry.epfwwext)+val(get_qry.epfww)+val(get_qry.epfwwext)) >
                <cfset add_employer = (val(getList_qry.epfcc)+val(getList_qry.epfccext)+val(get_qry.epfcc)+val(get_qry.epfccext) )>
                <cfset add_employee = (val(getList_qry.epfww)+val(getList_qry.epfwwext)+val(get_qry.epfww)+val(get_qry.epfwwext) )>
				<cfset sum1 = sum1 + val(wage_ordinary)>
                <cfset sum2 = sum2 + val(wage_add)>
                <cfset sum3 = sum3 + val(ordinary_employer)>
                <cfset sum4 = sum4 + val(ordinary_employee)>
                <cfset sum5 = sum5 + val(add_employer)>
                <cfset sum6 = sum6 + val(add_employee)>	
<cfif sum1 neq "0" OR sum2 neq "0" OR sum3 neq "0" OR sum4 neq "0" OR sum5 neq "0" OR sum6 neq "0">
	<cfoutput>
<p style="page-break-after:always">

<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td colspan="2"><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td>CENTRAL PROVIDENT FUND BOARD </td>
      </tr>
      <tr>
        <td>#getaddress.addr1# </td>
      </tr>
      <tr>
        <td>#getaddress.addr2# </td>
      </tr>
      <tr>
        <td>#getaddress.addr3# </td>
      </tr>
      <tr>
        <td>#getaddress.addr4# </td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2">APPLICATION FOR REFUND OF EXCESS CONTRIBUTIONS ON ADDITIONAL WAGES </td>
  </tr>
  <tr>
    <td colspan="2"><table width="100%" border="1" cellspacing="0" cellpadding="0">
      <tr>
        <td><table border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td colspan="6">IMPORTANT: Please read the important notes, authorisation and indernity stated overleaf before completing this application form </td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(A) PARTICULAR OF EMPLOYER </td>
          </tr>
          <tr>
            <td width="140">Name of Company : </td>
            <td width="13">#getComp_qry.COMP_NAME#</td>
            <td colspan="3" align="right">Reference No : </td>
            <td width="337">&nbsp;</td>
          </tr>
          <tr>
            <td>Address : </td>
            <td>#getComp_qry.COMP_ADD1# #getComp_qry.COMP_ADD2# #getComp_qry.COMP_ADD3#</td>
            <td colspan="3" align="right">Fax : </td>
            <td>#getComp_qry.COMP_FAX#</td>
          </tr>
          <tr>
            <td>Contact Officer : </td>
            <td>#getComp_qry.PM_NAME#</td>
            <td colspan="3" align="right">Tel : </td>
            <td>#getComp_qry.COMP_PHONE#</td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(B) PARTICULARS OF EMPLOYEE </td>
          </tr>
          <tr>
            <td>Name of Employee : </td>
            <td>#getEmp.name#</td>
            <td colspan="3"  align="right" >NRIC No: </td>
            <td>#getEmp.nricn#</td>
          </tr>
          <tr>
            <td>Email : </td>
            <td>&nbsp;</td>
            <td colspan="3" align="right">Tel : </td>
            <td>#getEmp.phone#</td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(C) WAGE &amp; CONTRIBUTION DETAILS OF EMPLOYEE </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="1" cellpadding="3" cellspacing="0" >
                <tr align="center">
                  <td colspan="3" >Wages Paid ($) </td>
                  <td colspan="2">Contribution Paid on ordinary Wages ($)</td>
                  <td colspan="2">Contribution Paid on Additional Wages ($)</td>
                </tr>
                <tr align="center">
                  <td>Month </td>
                  <td>Ordinary </td>
                  <td>Additional </td>
                  <td>Employer</td>
                  <td>Employee</td>
                  <td>Employer</td>
                  <td>Employee</td>
                </tr>
                
                <tr align="center">
                  <td>#mon#</td>
                  <td align="right">#NumberFormat(wage_ordinary, ",_.__")#</td>
                  <td align="right">#NumberFormat(wage_add, ",_.__")#</td>
                  <td align="right">#NumberFormat(ordinary_employer, ",_.__")#</td>
                  <td align="right">#NumberFormat(ordinary_employee, ",_.__")#</td>
                  <td align="right">#NumberFormat(add_employer, ",_.__")#</td>
                  <td align="right">#NumberFormat(add_employee, ",_.__")#</td>
                </tr>
               
                <tr align="center">
                  <td>Total</td>
                  <td align="right">#NumberFormat(sum1, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum2, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum3, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum4, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum5, ",_.__")#</td>
                  <td align="right">#NumberFormat(sum6, ",_.__")#</td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(D) DECLARATION BY EMPLOYER </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                  <td width="17">1) </td>
                  <td width="1185">Preceding Year Additional Wage Ceiling Applied? Yes / No* </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>if Yes, Please specify Total Wages in preceding year </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Total Wages :$ _________________</td>
                        <td>Total Ordinary Wages : $ _________________</td>
                        <td>Total Ordinary Wages $ _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>2) </td>
                  <td>Employee left employment? Yes/No* </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>If Yes, please indicate lasat date of employment __________ (dd/mm/ccyy) </td>
                </tr>
                <tr>
                  <td>3)</td>
                  <td> Employer's Bank Account Information (For Non-GIRO employers only) </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>Please attach a copy of the Bank Statement ( Showing the name and bank account no. of employer). </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td ><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Bank Name :_________________</td>
                        <td>Branch :_________________</td>
                        <td>Bank Account No : _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>4)</td>
                  <td colspan="2">We certify that the information given in this form is true, correct and complete. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">I / We agree to the authorisation and indernity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>________________________________</td>
                        <td>______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Name / Designation of Authorised Officer </td>
                        <td>Signature of Authorised Officer &amp; Company Stamp </td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>5)</td>
                  <td colspan="2">I certify that the employer's bank account information is true and correct. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="2">I / We agree to the authorisation and indernnity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>________________________________</td>
                        <td>_______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Name / Designation of Authorised Officer </td>
                        <td>Signature of Authorised Officer &amp; Company Stamp </td>
                      </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td colspan="6" bgcolor="##CCCCCC">(E) DECLARATION BY EMPLOYEE </td>
          </tr>
          <tr>
            <td colspan="6"><table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                  <td width="2%">1) </td>
                  <td width="98%">Employee's bank Account Information. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>Please attach a copy of the Bank Book or Bank Statement ( showing the name and bank account no. of employee). </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td>Bank Name :_________________</td>
                        <td>Branch :_________________</td>
                        <td>Bank Account No : _________________</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td>2)</td>
                  <td>I certify that the wage &amp; contribution details and my book account information stated in this form is true, correct and complete. </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>I agree to the authorisation and indernnity stated overleaf.</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>___________________</td>
                        <td>______________________________________</td>
                      </tr>
                      <tr>
                        <td>Date</td>
                        <td>Signature of Employee </td>
                      </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>

  </cfoutput>
</table>
</cfif>
</cfloop>

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

