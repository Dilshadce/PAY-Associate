<html>
<head>
	<title>Update IR8A Figures</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>

<script type="text/javascript">

function validate_form(thisform)
{
		var Dir_amt = document.form.dirf.value;
		var Appr_IRAS = document.form.EX_41.checked;
		var Date_IRAS = document.form.EX_42.value;
		var Appr_granted = document.form.yesno.checked;
		var Appr_Date = document.form.appr_date.value;
		var Comp_Retre = document.form.EX_56.value;
		var Income_Exempt = document.form.EX_33.value;
		var Tax_Exempt = document.form.EX_45.value;
		var Income_Tax = document.form.EX_38.value;
		var borne_emper = document.form.EX_34.value;
		var borne_empee = document.form.EX_35.value;
		var Gross_Comm = document.form.ea_comm.value;
		var Date_From = document.form.EATXT5.value;
		var Date_To = document.form.EATXT6.value;
		var ret_1993 = document.form.EAFIG05.value;
		var fund_1993 = document.form.EATXT9.value;
		var contri_CPF = document.form.EA_EPF.value; 
		var contri_fund = document.form.EX_70.value;
		var Dir_date = document.form.EXTRADATE1.value;
		var Basic_year1 = document.form.basic_year.value;
		var Dec_1992 = document.form.EAFIG07.value;
		
			 var datefday = Date_From.substring(0,2) * 1;
			 var datetday = Date_To.substring(0,2) * 1;
			 var datefmonth = Date_From.substring(3,5) * 1;
			 var datetmonth = Date_To.substring(3,5) * 1;
			 var datefyear = Date_From.substring(6,10) * 1;
			 var datetyear = Date_To.substring(6,10) * 1;
		
		var Basic_year_year = Basic_year1.substring(4,8) * 1;
		var Dir_date1 = Dir_date.substring(6,10) * 1;
		
		 if(Dir_amt != 0 && Dir_date == "")	
			{
				alert("Dir.Fees approved date must be filled out !")
				return false;
			}
		
		 if(Basic_year_year != Dir_date1 && Dir_amt != 0  )
			{
				alert("Dir.Fees approved date must be within basic year")
				return false;
			}
			
		 if(datefyear > datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
			 else if( datefmonth > datetmonth && datefyear == datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
			 else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
			  else if(Gross_Comm != 0 && datefyear != Basic_year_year || Gross_Comm != 0 && datetyear != Basic_year_year)
			 {
				 alert("Date From and Date TO must be within System Year");
				 return false;
			 }
			 
			if(Gross_Comm != 0 && Date_From == "" || Gross_Comm != 0 && Date_To == "" )
			{
				alert(" Gross Commission period must be filled out !")
				return false;
			}		
		
			if (Appr_IRAS == true)
			{
				if (Date_IRAS == ""){
					alert(" Date of approval must be filled out ! ")
					return false;}
			
				if (Comp_Retre == "" || Comp_Retre == 0) {
					alert(" Compensation/Retrenchment Benefits/Other must be filled out ! ")
					return false;}	
			} 
			
			if (Appr_granted == true && Appr_Date == "")
			{
				alert(" State date of approval must be filled out ! ")
				return false;
			}
			
			if(Income_Exempt != 0 && Tax_Exempt =="N")
			{
				alert(" Tax exempt/Remission income Indicator must be filled out ! ")
				return false;
			}
			 
			if(Income_Tax == "P" && borne_emper == "" || Income_Tax == "P" && borne_emper == 0)
			{
				alert(" Income for which tax is borne by employer must be filled out ! ")
				return false;
			}
			
			if(Income_Tax == "H" && borne_empee == "" || Income_Tax == "H" && borne_empee == 0)
			{
				alert("Fixed amount of Income Tax borne by employee must be filled out !")
				return false;
			}
			
			if (ret_1993 != 0 && fund_1993 == "") 
			{
				alert("Retirement Benefits from 1993 Fund Name must be filled out !")
				return false;
			}
			
			if (Dec_1992 != 0 && fund_1993 == "")
			{
				alert("Retirement Benefits from 1993 Fund Name must be filled out !")
				return false;
			}
			
			if (contri_CPF != 0 && contri_fund == "")
			{
				alert("EMPLOYEE'S COMPULSORY contributions to *CPF Fund Name must be fill out !")
				return false;
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

<cfset mon = getComp_qry.mmonth>
<cfif #mon# eq 13>
<cfset mon = 12>
</cfif>	

<cfset yrs = getComp_qry.myear>
<cfset date1= createdate(yrs,mon,1)>
<cfset daysmonth = daysinmonth(date1) >
<cfset lastdays = createdate(yrs,mon,daysmonth)>



<cfquery name="emp_qry" datasource="#dts#">
SELECT *
FROM pmast
WHERE empno="#url.empno#"
</cfquery>

<cfquery name="itaxea" datasource="#dts#">
SELECT *
FROM itaxea
WHERE empno="#url.empno#"
</cfquery>

<cfquery name="itaxea2"  datasource="#dts#">
	select * from itaxea2 where empno="#url.empno#"
</cfquery>


<cfset grosssalasy = VAL(itaxea.EA_BASIC)<!---  + VAL(itaxea.EA_OT) --->>
<cfset bonus = VAL(itaxea.EA_BONUS) + VAL(emp_qry.bonusfrny)>

<cfoutput>
<form name="form" id="form" action="/government/IR8A/PrintIR8A_act.cfm?type=update" method="post" onSubmit="return validate_form(this)">
<table class="form" border="0">
	
<input type="hidden" name="basic_year" id="basic_year" value="#dateformat(lastdays,'DDMMYYYY')#">

<tr>
	<td colspan="7">Employee No.
		<input type="text" name="empno" value="#emp_qry.empno#" size="5" readonly>
		<input type="text" name="name" value="#emp_qry.name#" size="40" readonly></td>
</tr>
<tr>
	<td>a)</td>
	<td colspan="5">Gross Salary, Fees, Leave Pay, Wages and Overtime Pay :</td>
	<td><input type="text" name="grosssalasy" value="#grosssalasy#" size="10" readonly disabled="disabled"></td>
</tr>
<tr>
	<td>b)</td>
	<td colspan="2">Bonus (non-contractual and/or contractual)</td>
	<td colspan="2">&nbsp; Non-contractual bonus declared date</td>
	<td><input type="TEXT" name="BONUSDATE1" id="BONUSDATE1" value="#DateFormat(itaxea.BONUSDATE1, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(BONUSDATE1);"></td>
	<td><input type="TEXT" name="bonus" value="#bonus#" size="10" readonly disabled="disabled"></td>
</tr>
<tr>
	<td>c)</td>
	<td colspan="2">Director's fees</td>
	<td colspan="2">&nbsp; Dir.Fees approved date</td>
	<td><input type="TEXT" name="EXTRADATE1" id="EXTRADATE1" value="#DateFormat(itaxea.EXTRADATE1, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EXTRADATE1);"></td>
	<td><input type="text" name="dirf" id="dirf" value="#itaxea.EA_DIRF#" size="10" readonly disabled="disabled"></td>
</tr>
<tr>
	<td>d)</td>
	<td colspan="2">1. Gross Commission</td>
	<td>&nbsp; Period</td>
	<td><input type="TEXT" name="EATXT5" id="EATXT5" value="#DateFormat(itaxea.EATXT5, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17  height=15 border=0 onClick="showCalendarControl(EATXT5);">&nbsp;To
		<input type="TEXT" name="EATXT6" id="EATXT6" value="#DateFormat(itaxea.EATXT6, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EATXT6);"></td>
	<td><select name="PBAYARAN">
			<option value="M" #IIF(itaxea.PBAYARAN eq "M",DE('selected'),DE(''))#>Monthly</option>
			<option value="O" #IIF(itaxea.PBAYARAN eq "O",DE('selected'),DE(''))#>Other than monthly</option>
			<option value="B" #IIF(itaxea.PBAYARAN eq "B",DE('selected'),DE(''))#>Both</option>
		</select></td>
	<td><input type="text" name="ea_comm" id="ea_comm" value="#itaxea.EA_COMM#" size="10" readonly disabled="disabled"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">2. Pension</td>
	<td><input type="text" name="EAFIG02" value="#itaxea.EAFIG02#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>3. Allowance :</td>
	<td>Transport &nbsp;<input type="text" name="EA_AW_T" value="#itaxea.EA_AW_T#" size="8" onKeyUp="calctotal();" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
	<td colspan="3">Entertainment &nbsp;<input type="text" name="EA_AW_E" value="#itaxea.EA_AW_E#" size="8" onKeyUp="calctotal();" maxlength="9" onKeyPress="return isNumberPoint(event)">
	&nbsp;&nbsp;&nbsp;&nbsp; Other &nbsp;<input type="text" name="EA_AW_O" value="#itaxea.EA_AW_O#" size="8" onKeyUp="calctotal();" maxlength="9" onKeyPress="return isNumberPoint(event)" readonly ></td>
	<td>
	<input type="text" name="EA_AW" value="#itaxea.EA_AW#" size="10" onFocus="this.blur();"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">4. Lump sum payment</td>
	<td><input type="text" name="eafig04" value="#numberformat(itaxea.eafig04,'.__')#" size="10" disabled="disabled"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;Compensation/Retrenchment Benefits/Other</td>
	<td ><input type="text" name="EX_56" id="EX_56" value="#itaxea.EX_56#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Approval obtained from IRAS</td>
	<td colspan="2">
		<input type="checkbox" name="EX_41" id="EX_41" value="Y" <cfif #itaxea.EX_41# eq "Y"> checked="yes" </cfif>>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date of approval &nbsp;&nbsp;</td>
	<td>
	<input type="TEXT" name="EX_42" id="EX_42" value="#DateFormat(itaxea.EX_42, "dd/mm/yyyy")#" size="10">
	<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EX_42);">
	</td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Approval granted</td>
	<td colspan="2">
		<input type="checkbox" name="yesno" id="yesno" value="Yes" <cfif #itaxea.appr# eq "Yes"> checked="yes" </cfif>>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;State date of approval &nbsp;</td>
		<td>
		<input type="TEXT" name="appr_date" id="appr_date" value= <cfif #itaxea.appr# eq "Yes"> "#DateFormat(itaxea.appr_date, "dd/mm/yyyy")#"<cfelse>""</cfif> size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(appr_date);"></td>
		</td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Reason for payment</td>
	<td colspan="3"><input type="text" name="COM_ADD" value="#itaxea.COM_ADD#" size="40"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Basic of arriving at the payment</td>
	<td colspan="2"><input type="text" name="EATXT8" value="#itaxea.EATXT8#" size="40" maxlength="20"></td>
	<td>Service Length</td>
	<td><input type="text" name="ECFIG10" value="#itaxea.ECFIG10#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Gratuity</td>
	<td colspan="2"><input type="text" name="ecfig05" value="#numberformat(itaxea.ecfig05,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
	<td>Compensation for loss of the office</td>
	<td><input type="text" name="ecfig06" value="#numberformat(itaxea.ecfig06,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Notice Pay</td>
	<td colspan="2"><input type="text" name="ecfig07" value="#numberformat(itaxea.ecfig07,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
	<td>Ex-gratia payment</td>
	<td><input type="text" name="ecfig08" value="#numberformat(itaxea.ecfig08,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;Others</td>
	<td colspan="2"><input type="text" name="ecfig09" value="#numberformat(itaxea.ecfig09,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">5. Retirement Benefits from 1993</td>
	<td><input type="text" name="EAFIG05" id="EAFIG05" value="#itaxea.EAFIG05#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)" ></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;Fund Name</td>
		<td colspan="3"><input type="text" name="EATXT9" value="#itaxea.EATXT9#" size="30" maxlength="60"></td>
	<td>Amt.accrued up to 31 Dec 1992</td>
	<td><input type="text" name="EAFIG07" id="EAFIG07" value="#itaxea.EAFIG07#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)" ></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">6. Contribution MADE by employer to any pension/Provident Fund consitituted outside Singapore</td>
	<td><input type="text" name="EAFIG06" value="#numberformat(itaxea.EAFIG06,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">7. Excess/voluntary contribution to CPF by employer</td>
	<td><input type="text" name="EA_EPFCEXT" value="#numberformat(itaxea.EA_EPFCEXT,'.__')#" size="10" maxlength="9" onKeyPress="return isNumberPoint(event)" readonly></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">8. Gains and profits from ESOP/ESOW Plans</td>
	<td><input type="text" name="EAFIG08" value="#numberformat(itaxea.EAFIG08,'.__')#" size="10" disabled="disabled"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">9. Value of benefits-in-kind</td>
	<td><input type="text" name="EAFIG09" value="#numberformat(itaxea.EAFIG09,'.__')#" size="10" disabled="disabled"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="5">EMPLOYEE'S COMPULSORY contributions to *CPF/Designated Pension or Provident Fund</td>
	<td><input type="text" name="EA_EPF" value="#numberformat(itaxea.EA_EPF,'.__')#" size="10" readonly disabled="disabled"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;Fund Name</td>
	<td colspan="3"><input type="text" name="EX_70" value="#itaxea.EX_70#" size="30" maxlength="60"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Donation deducted for Yayasan Mendaki Fund/Community Chest of Singapore/SINDA/CDA/ECF</td>
	<td><input type="text" name="EA_DED" value="#numberformat(itaxea.EA_DED)#" size="10" maxlength="5" onKeyPress="return isNumberKey(event)"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Contributions deducted for Mosque Building Fund</td>
	<td><input type="text" name="EAFIG15" value="#numberformat(itaxea.EAFIG15)#" size="10" maxlength="5" onKeyPress="return isNumberKey(event)" readonly></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Insurance</td>
	<td><input type="text" name="ins_ded" value="#numberformat(itaxea.ins_ded)#" size="10" maxlength="5" onKeyPress="return isNumberKey(event)"></td>
</tr>

<tr>
	<td>e)</td>
	<td colspan="5">Gains & Profit from Share Option granted before 01/01/2003 S10(1)(g)</td>
	<td><input type="text" name="EX_32" value="#itaxea.EX_32#" size="10" maxlength="9" onKeyPress="return isNumberKey(event)" disabled="disabled"></td>
</tr>

<tr>
	<td>f)</td>
	<td colspan="3">Income Tax borne by Employer</td>
	<td colspan="2" align="left"><select name="EX_38" id="EX_38">
			<option value="N" <cfif #itaxea.EX_38# eq "" or #itaxea.EX_38# eq "N">selected="selected" </cfif>>Not Applicable</option>
			<option value="F" <cfif #itaxea.EX_38# eq "F">selected="selected"</cfif>>Tax fully borne by employer on employment income only</option>
			<option value="P" <cfif #itaxea.EX_38# eq "P">selected="selected"</cfif>>Tax partially borne by employer on certain employment income items</option>
			<option value="H" <cfif #itaxea.EX_38# eq "H">selected="selected"</cfif>>A fixed amount of income tax liability borne by employee</option>
		</select>
	</td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Income for which tax is borne by employer</td>
	<td><input type="text" name="EX_34" id="EX_34" value="#numberformat(itaxea.EX_34)#" size="10" maxlength="9" onKeyPress="return isNumberKey(event)"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Fixed amount of Income Tax borne by employee</td>
	<td><input type="text" name="EX_35" id="EX_35" value="#numberformat(itaxea.EX_35)#" size="10" maxlength="9" onKeyPress="return isNumberKey(event)"></td>
</tr>

<tr>
	<td>g)</td>
	<td colspan="3">Section 45 (applicable to non-resident director)</td>
	<td><input type="checkbox" name="EX_37" id="EX_37" value="Y" <cfif #itaxea.EX_37# eq "Y">checked="yes"</cfif> >
	</td>
</tr>


<tr>
	<td>h)</td>
	<td colspan="3">Tax exempt/Remission income Indicator</td>
	<td colspan="2" align="left"><select name="EX_45">
		<option value="N" <cfif #itaxea.EX_45# eq "" or #itaxea.EX_45# eq "N">selected="selected" </cfif>></option>
		<option value="1" <cfif #itaxea.EX_45# eq "1">selected="selected"</cfif>>Tax Remission on Overseas Cost of Living Allowance(OCLA))</option>
		<option value="2" <cfif #itaxea.EX_45# eq "2">selected="selected"</cfif>>Tax remission on Operation Headquarters (OHQ)</option>
		<option value="3" <cfif #itaxea.EX_45# eq "3">selected="selected"</cfif>>Seaman</option>
		<Option value="4" <cfif #itaxea.EX_45# eq "4">selected="selected"</cfif>>Exemption</Option>
		</select>
	</td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="5">Income exempt/subject to tax remission</td>
	<td><input type="text" name="EX_33" value="#numberformat(itaxea.EX_33)#" size="10" maxlength="9" onKeyPress="return isNumberKey(event)"></td>
</tr>


</table>
<br />

<center>
	<input type="button" name="back" value="Back" onClick="window.location='/government/IR8A/PrintIR8AUpdateMain.cfm'">
	<input type="submit" name="submit" value="Save">
	<a href=##   onclick="window.open('/government/IR8A/PrintIR8AUpdateForm_Amend.cfm?empno=#emp_qry.empno#&name=#emp_qry.name#', 'windowname2', 'width=700, height=480, left=100, top=100, scrollbars=yes')"><input type="button" name="amend" value="Amendment"></a>
</center>

</form>
</cfoutput>
</body>

</html>