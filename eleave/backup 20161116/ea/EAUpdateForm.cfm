<html>
<head>
	<title>Update EA Figures</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	<script src="/javascripts/remaintabber.js" type="text/javascript"></script>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
    <script type="text/javascript">
    function totalup(){
        var a = document.getElementById('b1a_gross').value || 0;
        var b = document.getElementById('b1b_fees').value || 0;
        var c = document.getElementById('b1c_amount').value || 0;
        var d = document.getElementById('b1d_amount').value || 0;
        var e = document.getElementById('b2aa_amount').value || 0;
        var f = document.getElementById('b2ab_amount').value || 0;
        var g = document.getElementById('b2b_amount').value || 0;
        var h = document.getElementById('b2ca_amount').value || 0;
        var i = document.getElementById('b2cb_amount').value || 0;
        var j = document.getElementById('b2cc1_amount').value || 0;
        var k = document.getElementById('b2cc2_amount').value || 0;
        var l = document.getElementById('b2cc3_amount').value || 0;
        var m = document.getElementById('b2d_amount').value || 0;
        var n = document.getElementById('b2e_amount').value || 0;
        var o = document.getElementById('b2f_amount').value || 0;
        var p = document.getElementById('b3_amount').value || 0;
        var q = document.getElementById('b4_amount').value || 0;
        var r = document.getElementById('b5_amount').value || 0;
        var s = document.getElementById('c1_pencen').value || 0;
        var t = document.getElementById('c2_amount').value || 0;
        
		document.getElementById('ctotal_amount').value = (parseInt(a)+parseInt(b)+parseInt(c)+parseInt(d)+parseInt(e)+parseInt(f)+parseInt(g)+
                                        parseInt(h)+parseInt(i)+parseInt(j)+parseInt(k)+parseInt(l)+parseInt(m)+parseInt(n)+parseInt(o)+
                                        parseInt(p)+parseInt(q)+parseInt(r)+parseInt(s)+parseInt(t)).toFixed(2);

    }
    </script>
</head>

<body>
<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT *
FROM pmast
WHERE empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.empno)#">
</cfquery>

<cfquery name="pay_ytd" datasource="#dts#">
SELECT *
FROM pay_ytd
WHERE empno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.empno)#">
</cfquery>

<cfquery name="eatable" datasource="#dts#">
SELECT *
FROM eatable
WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.empno)#">
</cfquery>

<cfoutput>
<form name="form3" action="/government/updateea.cfm" method="post" onSubmit="return validate_form(this)">
<table class="form" border="0">
	<tr>
    	<td colspan="8">Employee No.
			<input type="text" name="empno" id="empno" value="#emp_qry.empno#" size="5" readonly>
			<input type="text" name="empname" id="empname" value="#emp_qry.name#" size="40" readonly></td>
    </tr>
    <br/>
    <tr>
    	<th colspan="5">B. EMPLOYMENT INCOME, BENEFITS AND LIVING ACCOMMODATION (Excluding Tax Exempt Allowances/Perquisites/Gifts/Benefits)</th>
        <th>RM</th>
    </tr>
    <tr>
    	<td>1.</td>
    	<td colspan="2">Gross salary, wages or leave pay (including overtime pay)</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b1a_gross" id="b1a_gross" value="#NumberFormat(eatable.b1a_gross,'.__')#" size="10" readonly></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">Fees (including director fees), commissions or bonuses</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b1b_fees" id="b1b_fees" value="#NumberFormat(eatable.b1b_fees,'.__')#" size="10" readonly></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">Gross tips, perquisites, awards/rewards or other allowances (Details of payment 
                    <input type="text" name="b1c_detail" id="b1c_detail" value="#eatable.b1c_detail#" size="10">)</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b1c_amount" id="b1c_amount" value="#NumberFormat(eatable.b1c_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">Income tax borne by the employer in respect of his employee</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b1d_amount" id="b1d_amount" value="#NumberFormat(eatable.b1d_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td>2.</td>
        <td colspan="3">Value of benefits-in-kind:</td>
        <td></td>
        <td></td>
    </tr>
    <tr>
    	<td></td>
        <td>(a) Motorcars (Actual date provided <input type="text" name="b2a_date" id="b2a_date" 
        value="#dateformat(eatable.b2a_date,'dd/mm/yyyy')#" size="10">&nbsp;
        <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('b2a_date'));">)</td>
        <td colspan="2">(i) Value of motorcar and petrol</td>
        <td></td>
        <td><input type="text" name="b2aa_amount" id="b2aa_amount" value="#NumberFormat(eatable.b2aa_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td>(Type<input type="text" name="b2a_type" id="b2a_type" value="#eatable.b2a_type#" size="10"> 
        Year<input type="text" name="b2a_year" id="b2a_year" value="#eatable.b2a_year#" size="10"> Model
        <input type="text" name="b2a_model" id="b2a_model" value="#eatable.b2a_model#" size="10"> )</td>
        <td colspan="2">(ii) Value of driver</td>
        <td></td>
        <td><input type="text" name="b2ab_amount" id="b2ab_amount" value="#NumberFormat(eatable.b2ab_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(b) Electricity, water, telephone and other benefits</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2b_amount" id="b2b_amount" value="#NumberFormat(eatable.b2b_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="3">(c) Value of household benefits:</td>
        <td></td>
        <td></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(i) Semi-furnished with furniture*/air-conditioners*/curtains*/carpets*, or</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2ca_amount" id="b2ca_amount" value="#NumberFormat(eatable.b2ca_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(ii) Fully-furnished with kitchen equipment, crockery, utensils and appliances, or</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2cb_amount" id="b2cb_amount" value="#NumberFormat(eatable.b2cb_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td>(iii) Separate Items: </td>
        <td colspan="2">Furniture and fittings</td>
        <td></td>
        <td><input type="text" name="b2cc1_amount" id="b2cc1_amount" value="#NumberFormat(eatable.b2cc1_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td></td>
        <td colspan="2">Kitchen equipment</td>
        <td></td>
        <td><input type="text" name="b2cc2_amount" id="b2cc2_amount" value="#NumberFormat(eatable.b2cc2_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td></td>
        <td colspan="2">Entertainment and recreation</td>
        <td></td>
        <td><input type="text" name="b2cc3_amount" id="b2cc3_amount" value="#NumberFormat(eatable.b2cc3_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(d) Household servant and gardener</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2d_amount" id="b2d_amount" value="#NumberFormat(eatable.b2d_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(e) Benefit of leave passage for travel</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2e_amount" id="b2e_amount" value="#NumberFormat(eatable.b2e_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">(f) Others (for example food and garments)</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b2f_amount" id="b2f_amount" value="#NumberFormat(eatable.b2f_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td>3.</td>
        <td colspan="2">Value of living accommodation provided (Address <input type="text" name="address" id="address" value="#eatable.address#" size="60">)</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b3_amount" id="b3_amount" value="#NumberFormat(eatable.b3_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td>4.</td>
        <td colspan="2">Refund from unapproved Pension/Provident Fund, Scheme Or Society</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b4_amount" id="b4_amount" value="#NumberFormat(eatable.b4_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td>5.</td>
        <td colspan="2">Compensation for loss of employment</td>
        <td></td>
        <td></td>
        <td><input type="text" name="b5_amount" id="b5_amount" value="#NumberFormat(eatable.b5_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<th colspan="6">C. PENSIONS AND OTHERS</th>
    </tr>
    <tr>
    	<td>1.</td>
        <td colspan="2">Pensions</td>
        <td></td>
        <td></td>
        <td><input type="text" name="c1_pencen" id="c1_pencen" value="#NumberFormat(eatable.c1_pencen,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td>2.</td>
        <td colspan="2">Annuities or other Periodical Payments</td>
        <td></td>
        <td></td>
        <td><input type="text" name="c2_amount" id="c2_amount" value="#NumberFormat(eatable.c2_amount,'.__')#" size="10" onBlur="totalup();"></td>
    </tr>
    <tr>
    	<td></td>
        <td colspan="2">TOTAL</td>
        <td></td>
        <td></td>
        <td><input type="text" name="ctotal_amount" id="ctotal_amount" value="#NumberFormat(eatable.ctotal_amount,'.__')#" size="10"></td>
    </tr>
    <tr>
    	<th colspan="6">D. TOTAL DEDUCTION</th>
    </tr>
	<tr>
    	<td>1.</td>
        <td colspan="2">Current Year's Monthly Tax Deductions (MTD) remitted to LHDNM</td>
        <td></td>
        <td></td>
        <td><input type="text" name="d1_amount" id="d1_amount" value="#NumberFormat(eatable.d1_amount,'.__')#" size="10"></td>
    </tr>
    <tr>
    	<td>2.</td>
        <td colspan="2">CP 38 Deductions</td>
        <td></td>
        <td></td>
        <td><input type="text" name="d2_amount" id="d2_amount" value="#NumberFormat(eatable.d2_amount,'.__')#" size="10"></td>
    </tr>
    <tr>
    	<td>3.</td>
        <td colspan="2">Deductions for Zakat remitted to the collection authority of Malaysian zakat</td>
        <td></td>
        <td></td>
        <td><input type="text" name="d3_amount" id="d3_amount" value="#NumberFormat(eatable.d3_amount,'.__')#" size="10"></td>
    </tr>
    <tr>
    	<th colspan="6">E. CONTRIBUTIONS TO APPROVED PENSION/PROVIDENT FUND, SCHEME OR SOCIETY</th>
    </tr>
    <tr>
    	<td></td>
    	<td colspan="5">Name of Provident Fund &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="text" name="e1_detail" id="e1_detail" value="#eatable.e1_detail#" size="40"></td>
    </tr>
    <tr>
    	<td></td>
    	<td colspan="3">Amount of contribution (state the employee's share of contribution only)</td>
        <td align="right">RM</td>
        <td><input type="text" name="e2_amount" id="e2_amount" value="#NumberFormat(eatable.e2_amount,'.__')#" size="10" readonly></td>
    </tr>
    </table>
    <table class="form" border="0">
    <tr>
    	<th colspan="6">F. PARTICULARS OF PAYMENT IN ARREARS AND OTHER PAYMENTS IN RESPECT OF PRECEDING YEARS (PRIOR TO CURRENT YEAR)</th>
    </tr>
    <tr>
    	<td align="center">Year for which Paid</td>
        <td align="center">Type of Income</td>
        <td align="center">Total Payment (RM)</td>
        <td align="center">EPF Contribution (RM)</td>
        <td align="center">Monthly Tax Deductions (MTD) (RM)</td>
    </tr>
    <tr>
    	<td align="center"><input type="text" name="f1_year" id="f1_year" value="#eatable.f1_year#" size="10"></td>
        <td align="center"><input type="text" name="f1_type" id="f1_type" value="#eatable.f1_type#" size="10"></td>
        <td align="center"><input type="text" name="f1total_payment" id="f1total_payment" value="#NumberFormat(eatable.f1total_payment,'.__')#" size="10"></td>
        <td align="center"><input type="text" name="f1epf_amount" id="f1epf_amount" value="#NumberFormat(eatable.f1epf_amount,'.__')#" size="10"></td>
        <td align="center"><input type="text" name="f1mtd_amount" id="f1mtd_amount" value="#NumberFormat(eatable.f1mtd_amount,'.__')#" size="10"></td>
    </tr>
    <tr>
    	<td align="center"><input type="text" name="f2_year" id="f2_year" value="#eatable.f2_year#" size="10"></td>
        <td align="center"><input type="text" name="f2_type" id="f2_type" value="#eatable.f2_type#" size="10"></td>
        <td align="center"><input type="text" name="f2total_payment" id="f2total_payment" value="#NumberFormat(eatable.f2total_payment,'.__')#" size="10"></td>
        <td align="center"><input type="text" name="f2epf_amount" id="f2epf_amount" value="#NumberFormat(eatable.f2epf_amount,'.__')#" size="10"></td>
        <td align="center"><input type="text" name="f2mtd_amount" id="f2mtd_amount" value="#NumberFormat(eatable.f2mtd_amount,'.__')#" size="10"></td>
    </tr>
    </table>
    <table class="form" border="0">
    <tr>
    	<th>G. TOTAL TAX EXEMPT ALLOWANCES / PERQUISITES / GIFTS / BENEFITS</th>
        <td>RM<input type="text" name="g_amount" id="g_amount" value="#NumberFormat(eatable.g_amount,'.__')#" size="10"></td>
    </tr>
    </table>
    <center>
	<input type="button" name="exit" value="Exit" onClick="window.close();">
	<input type="submit" name="submit" value="Save">
	</center>
</form>
</cfoutput>
</body>
<script type="text/javascript">
totalup();
</script>
</html>