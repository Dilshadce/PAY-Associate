<html>
<head>
	<title>Update Appendix 8A Figures</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	<script src="/javascripts/remaintabber.js" type="text/javascript"></script>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	
	
<script type="text/javascript">

function validate_form(thisform)
{
		var CYear = document.form3.CompanyYear.value;	
		var Date_From = document.form3.sec_83a.value;
		var Date_To = document.form3.sec_83b.value;
			
			 var CYear1 = CYear.substring(0,4) * 1;
			 var datefday = Date_From.substring(0,2) * 1;
			 var datetday = Date_To.substring(0,2) * 1;
			 var datefmonth = Date_From.substring(3,5) * 1;
			 var datetmonth = Date_To.substring(3,5) * 1;
			 var datefyear = Date_From.substring(6,10) * 1;
			 var datetyear = Date_To.substring(6,10) * 1;
		
	  if(Date_From !="" && Date_To !="" || Date_From !="" || Date_To !="")	
	  {
		 if(datefyear > datetyear)
			 {
				 alert("Date to must be equal ro earlier than Date From");
				 return false;
			 }
			 else if( datefmonth > datetmonth && datefyear == datetyear)
			 {
				 alert("Date to must be equal ro earlier than Date From");
				 return false;
			 }
			 else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
			 {
				 alert("Date to must be equal ro earlier than Date From");
				 return false;
			 }
			 else if (datefyear != CYear1 || datetyear != CYear1)
			 {
				 alert("Period of Overseas posting Date must be within basis year");
				 return false;
			 }	
	}
	
	
		var Date_From_02 = document.form3.EA2DAT02.value;
		var Date_To_03 = document.form3.EA2DAT03.value;
		var Date_From_07 = document.form3.EA2DAT07.value;
		var Date_To_08 = document.form3.EA2DAT08.value;
		var Date_From_12 = document.form3.EA2DAT12.value;
		var Date_To_13 = document.form3.EA2DAT13.value;
			
		var datefyear02 = Date_From_02.substring(6,10) * 1;
		var datetyear03 = Date_To_03.substring(6,10) * 1;
		var datefyear07 = Date_From_07.substring(6,10) * 1;
		var datetyear08 = Date_To_08.substring(6,10) * 1;
		var datefyear12 = Date_From_12.substring(6,10) * 1;
		var datetyear13 = Date_To_13.substring(6,10) * 1;
			 
	     if (Date_From_02 != "" && Date_To_03 != "" || Date_From_02 != "" || Date_To_03 != "") {
		 	if (datefyear02 != CYear1 || datetyear03 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
		 if (Date_From_07 != "" && Date_To_08 != "" || Date_From_07 != "" || Date_To_08 != "") {
		 	if (datefyear07 != CYear1 || datetyear08 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
		 if (Date_From_12 != "" && Date_To_13 != "" || Date_From_12 != "" || Date_To_13 != "") {
		 	if (datefyear12 != CYear1 || datetyear13 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
			 
			 
	
}


</script>




<script language="javascript">
function calctotal(){

document.forms[0].EA_AW.value = 
 parseFloat(document.forms[0].EA_AW_T.value) +
 parseFloat(document.forms[0].EA_AW_E.value) +
 parseFloat(document.forms[0].EA_AW_O.value);
}


function isNumberKey(evt)
{
  var charCode = (evt.which) ? evt.which : event.keyCode
  if (charCode > 31 && (charCode < 48 || charCode > 57))
  return false;

  return true;
}

  function isNumberPoint(evt)
  {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode != 46 && charCode > 31 
    && (charCode < 48 || charCode > 57))
    return false;

    return true;
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
WHERE empno="#url.empno#"
</cfquery>

<cfquery name="itaxea2" datasource="#dts#">
SELECT *
FROM itaxea2
WHERE empno="#url.empno#"
</cfquery>
<cfoutput>

<form name="form3" action="/government/IR8A/PrintIR8S_act.cfm?type=update" method="post" onSubmit="return validate_form(this)">
<table class="form" border="0">
	<tr>
		<td colspan="8">Employee No.
			<input type="text" name="empno" value="#emp_qry.empno#" size="5" readonly>
			<input type="text" name="name" value="#emp_qry.name#" size="40" readonly></td>
	</tr>
</table>

<div class="tabber">
<div class="tabbertab" title="1)Place of Residence">
<table class="form" border="0">
	
	<input type="hidden" name="CompanyYear" id="CompanyYear" value="#getComp_qry.myear#">

<tr>
	<td colspan="3"><strong>1. Value of The Place of Residence</strong></td> 
</tr>
<tr><td><br></td></tr>	
<tr>
	<td colspan="2"><a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a>Address :</td>
	<td colspan="4">Line 1 <input type="text" name="" id="" value="" size="50"></td>
</tr>
<tr>
	<td colspan="2"></td>
	<td colspan="4">Line 2 <input type="text" name="" id="" value="" size="50"></td>
</tr>
<tr>
	<td colspan="2"></td>
	<td colspan="4">Line 3 <input type="text" name="" id="" value="" size="50"></td>
</tr>
<tr>
	<td colspan="3">Period Of Occupation</td>
	<td colspan="1" align="right">From <input type="text" name="" id="" value="" size="10"></td>
	<td colspan="1" >To <input type="text" name="" id="" value="" size="10"></td>
</tr>
<tr>
	<td colspan="3">Annual Value</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td colspan="3">Rent Paid by Employer</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td colspan="3">Rent Paid by Employee</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td colspan="3">Value of the Place of Residence</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10"></td>
</tr>
<tr>
	<td colspan="3">No. Of Days</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10" maxlength="3" onkeypress="return isNumberKey(event)"></td>
</tr>
<tr>
	<td colspan="3">No. of Employees Sharing</td>
	<td colspan="2" align="right"><input type="text" name="" id="" value="" size="10" maxlength="2" onkeypress="return isNumberKey(event)"></td>
</tr>

<tr><td><br></br></td></tr>
</table>
</div>

<div class="tabbertab" title="2)Furniture & Fittings/ Driver/ Gardener">
<table class="form" border="0">
<tr>
	<td colspan="2"><Strong>2. Value of Furniture & Fittings / Driver / Gardener (Total of 2a to 2y)</Strong></td>
</tr>
<tr><td><br></td></tr>
<tr>
	<th><a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a>Item</th>
	<th>A.No.of units</th>
	<th>B.Rate per unit p.m($)</th>
	<th>Value($)</th>
</tr>
<tr>
	<td >a. Furniture: Hard & Soft</td>
	<td></td>
	<td align="center">10.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8"></td>	
</tr>
<tr>
	<td >b. Refrigerator</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">10.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >c. Video Recorder/DVD/VCD Player</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">20.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >d. Washing Machine</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">15.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >e. Dryer</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">15.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >f. Dish Washer</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">15.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >g. Air Conditioner :</td>
</tr>
<tr>
	<td >&nbsp;&nbsp; - Unit / Air Purifier</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">10.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >&nbsp;&nbsp; - Dining</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">15.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >&nbsp;&nbsp; - Sitting</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">15.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >&nbsp;&nbsp; - Additional</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">10.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >h. TV/Home Entertainment Theatre/Plasma TV/High Definition TV</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">30.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >i. Radio</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">30.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >j. Surveillance System</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">30.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >k. Hi-Fi Stereo</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">30.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >l. Electric Guitar</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">30.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >m. Computer</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">40.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >n. Organ</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">40.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td >o. Swimming Pool</td>
	<td><input type="text" name="" id="" value="" size="8" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">100.00</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>
<tr>
	<td>p. Public Utilities</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td >q. Telephone</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>r. Pager</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>s. Suitcase</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td >t. Golf Bag & Accessories</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td >u. Camera</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td >v. Servant</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>w. Driver</td>
	<td></td>
	<td align="center">Annual Wages x (private / total mileage)</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>x. Gardener or Upkeep of Compound</td>
	<td></td>
	<td>$35.00 p.m or the actual wages, whichever is lesser</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>y. Other benefits which do not fall within the above items</td>
	<td></td>
	<td align="center">Actual Amount</td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total</b></td>
	<td></td>
	<td></td>
	<td><input type="text" name="" id="" value="" size="10" maxlength="8" readonly></td>
</tr>

<tr>
	<td colspan="3">Value for (2a) to (2o) & (2y) = A (No. of Units) x B (Rate p.m) x 12 x No. of Days /365</td>
</tr>

<tr><td><br></td></tr>
</table>
</div>

<div class="tabbertab" title="3)Hotel Accomodation">
<table class="form" border="0">
<tr>
	<td colspan="3"><strong>3. Value of Hotel Accommodation Provided (Total of 3a, 3b & 3c))</strong></td>
</tr>
<tr><td><br></td></tr>
<tr>
	<td><a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a></td>
	<th>A. NO.of Persons</th>
	<th>B. Rate per person pm($)</th>
	<th>C. Period provided <br>(No.of days)</th>
	<th>Value ($)<br>A x B x 12 x C / 365</th>
</tr>
<tr>
	<td>a. Self / spouse / child > 20 years old</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">250.00</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="3" onkeypress="return isNumberKey(event)"></td>
	<td><input type="text" name="" id="" value="" size="15" readonly></td>
</tr>
<tr>
	<td>b. Children</td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
</tr>
<tr>
	<td>&nbsp;&nbsp; i) 8 to 20 years old</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">100.00</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="3" onkeypress="return isNumberKey(event)"></td>
	<td><input type="text" name="" id="" value="" size="15" readonly></td>
</tr>
<tr>
	<td>&nbsp;&nbsp; ii) 3 to 7 years old</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">50.00</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="3" onkeypress="return isNumberKey(event)"></td>
	<td><input type="text" name="" id="" value="" size="15" readonly></td>
</tr>
<tr>
	<td>&nbsp;&nbsp; iii) 3 years old</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td align="center">25.00</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="3" onkeypress="return isNumberKey(event)"></td>
	<td><input type="text" name="" id="" value="" size="15" readonly></td>
</tr>
<tr>
	<td>c. Plus 2% of basic salary for period provided</td>
	<td><input type="text" name="" id="" value="" size="13" maxlength="1" onkeypress="return isNumberKey(event)"></td>
	<td></td>
	<td></td>
	<td><input type="text" name="" id="" value="" size="15" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total</b></td>
	<td></td>
	<td></td>
	<td></td>
	<td><input type="text" name="" id="" value="" size="15"></td>
</tr>


<tr><td><br></td></tr>
</table>
</div>

<div class="tabbertab" title="4)Others">
<table class="form" border="0">
<tr>
	<td><strong>4. Others</strong></td>
</tr>
<tr><td><br></td></tr>
<tr>
	<td>a. Cost of home leave passages and incidental benefits :<a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a></td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>- No. of passags for self</td>
	<td><input type="text" name="" id="" value="" size="5" maxlength="2" onkeypress="return isNumberKey(event)"></td>
</tr>
<tr>
	<td>- No. of passages for spouse</td>
	<td><input type="text" name="" id="" value="" size="5" maxlength="2" onkeypress="return isNumberKey(event)"></td>
</tr>
<tr>
	<td>- No. of passages for chidren</td>
	<td><input type="text" name="" id="" value="" size="5" maxlength="2" onkeypress="return isNumberKey(event)"></td>
</tr>
<tr>
	<td>Pioneer/export/pioneer service/OHQ Staus was awarded or granted extension prior to 1 Jan 2004</td>
	<td>Yes<input type="radio" name="" id="" value="Y"> 
		No<input type="radio" name="" id="" value="N"> </td>
</tr>
<tr>
	<td>b. Interest payment made by the employer to a third party on behalf of an employee and/or loans provided by employer interest 
	<br>free or at a rate below market rate to the employee who has substantial shareholding or control or influence over the company :
	<a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a></td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>

</tr>
<tr>
	<td>c. Life insurance premiums paid by the employer</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>d. Free or subsidised holidays including air passage, etc: </td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>e. Educational expenses including tutor provided:</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>f. Non-monetary awards for long service (excluding awards with little commercial value):</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>g. Entrance/transfer fees and annual subscription to social or recreational clubs:</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>h. Gains from assets, e.g. vehicles, property, etx. sold to employees at a price lower than open market value:</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>i. Full cost of motor vehicles given to employee:</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>j. Car benefits: <a href="/government/IR8A/iHelp.cfm" target="_blank"><input type="button" value=" i "></a></td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>k. Other non-monetary benefits which do not fall within the aboce items:</td>
	<td><input type="text" name="" id="" value="" size="12" maxlength="10" onkeypress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>TOTAL VALUE OF BENEFITS-IN-KIND (ITEMS 1 TO 4) TO BE REFLECTED IN ITEM d9 OF FORM IR8A</td>
	<td><input type="text" name="" id="" value="" size="12" readonly></td>
</tr>
	
</table>
<br />
</div>

</div>
<center>
	<input type="button" name="exit" value="Exit" onClick="window.close();">
	<input type="submit" name="submit" value="Save">
</center>

</form>
</cfoutput>
</body>

</html>