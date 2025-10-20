<html>
<head>
	<title>Amendment IR8A Figures</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>

<script type="text/javascript">

function validate_form(thisform)
{
	
		var Dir_date = document.amend_form.EXTRADATE1.value;
		var Dir_amt = document.amend_form.amd_dif.value;
		var Gross_Comm = document.amend_form.amd_com.value;
		var Date_From = document.amend_form.EATXT5.value;
		var Date_To = document.amend_form.EATXT6.value;
		var Date_IRAS = document.amend_form.EX_42.value;
		var Comp_Retre = document.amend_form.amd_com_ret.value;
		var fund_1993 = document.amend_form.EATXT9.value;
		var ret_1993 = document.amend_form.amd_1993.value;
		var Dec_1992 = document.amend_form.amd_1992.value;
		var Income_Tax = document.amend_form.EX_38.value;
		var borne_emper = document.amend_form.amd_tax_yer.value;
		var borne_empee = document.amend_form.amd_tax_yee.value;
		var Basic_year1 = document.amend_form.basic_year.value;
		
		var Basic_year_year = Basic_year1.substring(4,8) * 1;
		var datefday = Date_From.substring(0,2) * 1;
		var datetday = Date_To.substring(0,2) * 1;
		var datefmonth = Date_From.substring(3,5) * 1;
		var datetmonth = Date_To.substring(3,5) * 1;
		var datefyear = Date_From.substring(6,10) * 1;
		var datetyear = Date_To.substring(6,10) * 1;
		var Dir_date1 = Dir_date.substring(6,10) * 1;
		
		 if(Dir_amt != 0 && Dir_date == "")	
			{
				alert("Dir.Fees approved date must be filled out !")
				return false;
			}
		
		 if(Basic_year_year != Dir_date1 && Dir_amt != 0  )
			{
				alert("Dir.Fees approved date must be within System year")
				return false;
			}
			
		 if(datefyear > datetyear)
			 {
				 alert("Date To should be bigger than Date From");
				 return false;
			 }
			 else if( datefmonth > datetmonth && datefyear == datetyear)
			 {
				 alert("Date To should be bigger than Date From");
				 return false;
			 }
			 else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
			 {
				 alert("Date To should be bigger than Date From");
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

			if (Date_IRAS == "" && Comp_Retre != 0)
			{
				alert(" Date of approval must be filled out ! ")
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
			

}
</script>

<!----	
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
  if (charCode > 31 && (charCode < 48 || charCode > 57 ))
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
------->	
	
</head>
<body>	
<cfoutput>
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


<cfquery name="itaxea" datasource="#dts#">
SELECT *
FROM itaxea
WHERE empno="#url.empno#"
</cfquery>

<h2>Crimson Logic Only</h2>
<form name="amend_form" id="amend_form" action="PrintIR8AUpdateForm_Amend_process.cfm" method="post" onSubmit="return validate_form(this)">	
<table>
	
<input type="hidden" name="basic_year" id="basic_year" value="#dateformat(lastdays,'DDMMYYYY')#">	
	
<tr>
	<td colspan="6"><center><h1>Amendment</h1></center></td>
</tr>		
<tr>
<td colspan="5">Employee <input type="text" name="empno" value="#url.empno#" size="10" readonly>
<input type="text" name="empname" value="#url.name#" size="40" readonly></td>	
</tr>	
	
<tr>
	<td>1.</td>
	<td  colspan="3">Gross Salary</td>
	<td><input type="text" name="amd_salary" id="amd_salary" value="#itaxea.amd_salary#" size="10"></td>
</tr>	
<tr>
	<td>2.</td>
	<td  colspan="3">Bonus</td>
	<td><input type="text" name="amd_bonus" id="amd_bonus" value="#itaxea.amd_bonus#" size="10"></td>
</tr>	
<tr>
	<td>3.</td>
	<td>Director's fees</td>
	<td colspan="2" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="TEXT" name="EXTRADATE1" id="EXTRADATE1" value="#DateFormat(itaxea.EXTRADATE1, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EXTRADATE1);"></td>
	<td><input type="text" name="amd_dif" id="amd_dif" value="#itaxea.amd_dif#" size="10"></td>
</tr>	
<tr>
	<td>4.</td>
	<td >Gross Commission&nbsp&nbsp;</td>
		<td >Period<input type="TEXT" name="EATXT5" id="EATXT5" value="#DateFormat(itaxea.EATXT5, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17  height=15 border=0 onClick="showCalendarControl(EATXT5);">&nbsp;To
		<input type="TEXT" name="EATXT6" id="EATXT6" value="#DateFormat(itaxea.EATXT6, "dd/mm/yyyy")#" size="10">
		<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EATXT6);"></td>
		<td><select name="PBAYARAN">
			<option value="M" #IIF(itaxea.PBAYARAN eq "M",DE('selected'),DE(''))#>Monthly</option>
			<option value="O" #IIF(itaxea.PBAYARAN eq "O",DE('selected'),DE(''))#>Other than monthly</option>
			<option value="B" #IIF(itaxea.PBAYARAN eq "B",DE('selected'),DE(''))#>Both</option>
		</select></td>
	<td><input type="text" name="amd_com" id="amd_com" value="#itaxea.amd_com#" size="10"></td>
</tr>	
<tr>
	<td>5.</td>
	<td colspan="3">Pension</td>
	<td><input type="text" name="amd_pen" id="amd_pen" value="#itaxea.amd_pen#" size="10"></td>
</tr>	
<tr>
	<td>6.</td>
	<td colspan="3">Transport Allowance</td>
	<td><input type="text" name="amd_tran_alw" id="amd_tran_alw" value="#itaxea.amd_tran_alw#" size="10"></td>
</tr>	
<tr>
	<td>7.</td>
	<td colspan="3">Entertainment Allowance </td>
	<td><input type="text" name="amd_ent_alw" id="amd_ent_alw" value="#itaxea.amd_ent_alw#" size="10"></td>
</tr>	
<tr>
	<td>8.</td>
	<td colspan="3">Other Allowance</td>
	<td><input type="text" name="amd_oth_alw" id="amd_oth_alw" value="#itaxea.amd_oth_alw#" size="10"></td>
</tr>		
<tr>
	<td>9.</td>
	<td colspan="2">Compensation/Retrenchment Benefits/Other</td>
	<td >
	<input type="TEXT" name="EX_42" id="EX_42" value="#DateFormat(itaxea.EX_42, "dd/mm/yyyy")#" size="10">
	<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EX_42);">
	</td>
	<td><input type="text" name="amd_com_ret" id="amd_com_ret" value="#itaxea.amd_com_ret#" size="10"></td>
</tr>	
<tr>
	<td>10.</td>
	<td colspan="3">Gratuity</td>
	<td><input type="text" name="amd_grat" id="amd_grat" value="#itaxea.amd_grat#" size="10"></td>
</tr>	
<tr>
	<td>11.</td>
	<td colspan="3">Retirement Benefits from 1993</td>
	<td><input type="text" name="amd_1993" id="amd_1993" value="#itaxea.amd_1993#" size="10"></td>
</tr>	
<tr>
	<td>12.</td>
	<td colspan="3">Amt.accrued up to 31 Dec 1992</td>
	<td><input type="text" name="amd_1992" id="amd_1992" value="#itaxea.amd_1992#" size="10"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="3">Fund Name &nbsp;
	<input type="text" name="EATXT9" value="#itaxea.EATXT9#" size="30" maxlength="60"></td>
</tr>	
<tr>
	<td>13.</td>
	<td colspan="3">Contribution MADE by employer to any pension/Provident Fund consitituted outside Singapore</td>
	<td><input type="text" name="amd_con_yer" id="amd_con_yer" value="#itaxea.amd_con_yer#" size="10"></td>
</tr>	
<tr>
	<td>14.</td>
	<td colspan="3">Excess/voluntary contribution to CPF by employer</td>
	<td><input type="text" name="amd_exces_yer" id="amd_exces_yer" value="#itaxea.amd_exces_yer#" size="10"></td>
</tr>	
<tr>
	<td>15.</td>
	<td colspan="3">Gains and profits from ESOP/ESOW Plans</td>
	<td><input type="text" name="amd_gain_prof" id="amd_gain_prof" value="#itaxea.amd_gain_prof#" size="10"></td>
</tr>	
<tr>
	<td>16.</td>
	<td colspan="3">Value of benefits-in-kind</td>
	<td><input type="text" name="amd_ben_kind" id="amd_ben_kind" value="#itaxea.amd_ben_kind#" size="10"></td>
</tr>
<tr>
	<td>17.</td>
	<td colspan="3">EMPLOYEE'S COMPULSORY contributions to *CPF/Designated Pension or Provident Fund</td>
	<td><input type="text" name="amd_yee_cont_cpf" id="amd_yee_cont_cpf" value="#itaxea.amd_yee_cont_cpf#" size="10"></td>
</tr>		
<tr>
	<td>18.</td>
	<td colspan="3">Donation deducted for Yayasan Mendaki Fund/Community Chest of Singapore/SINDA/CDA/ECF</td>
	<td><input type="text" name="amd_donation" id="amd_donation" value="#itaxea.amd_donation#" size="10"></td>
</tr>	
<tr>
	<td>19.</td>
	<td colspan="3">Contributions deducted for Mosque Building Fund</td>
	<td><input type="text" name="amd_mbf" id="amd_mbf" value="#itaxea.amd_mbf#" size="10"></td>
</tr>	
<tr>
	<td>20.</td>
	<td colspan="3">Insurance</td>
	<td><input type="text" name="amd_insur" id="amd_insur" value="#itaxea.amd_insur#" size="10"></td>
</tr>	
<tr>
	<td>21.</td>
	<td colspan="3">Gains & Profit from Share Option granted before 01/01/2003 S10(1)(g)</td>
	<td><input type="text" name="amd_gain_profit" id="amd_gain_profit" value="#itaxea.amd_gain_profit#" size="10"></td>
</tr>
<tr>
	<td>22.</td>
	<td colspan="2">Income Tax borne by Employer &nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="3">	
	<select name="EX_38" id="EX_38">
			<option value="N" <cfif #itaxea.EX_38# eq "" or #itaxea.EX_38# eq "N">selected="selected" </cfif>>Not Applicable</option>
			<option value="F" <cfif #itaxea.EX_38# eq "F">selected="selected"</cfif>>Tax fully borne by employer on employment income only</option>
			<option value="P" <cfif #itaxea.EX_38# eq "P">selected="selected"</cfif>>Tax partially borne by employer on certain employment income items</option>
			<option value="H" <cfif #itaxea.EX_38# eq "H">selected="selected"</cfif>>A fixed amount of income tax liability borne by employee</option>
	</select>
	</td>
</tr>	
<tr>
	<td>&nbsp;</td>
	<td colspan="3">Income for which tax is borne by employer</td>
	<td><input type="text" name="amd_tax_yer" id="amd_tax_yer" value="#itaxea.amd_tax_yer#" size="10"></td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="3">Fixed amount of Income Tax borne by employee
	<td><input type="text" name="amd_tax_yee" id="amd_tax_yee" value="#itaxea.amd_tax_yee#" size="10"></td>
</tr>	
<tr>
	<td>23.</td>
	<td colspan="3">Income exempt/subject to tax remission</td>
	<td ><input type="text" name="amd_exe_tax_remi" id="amd_exe_tax_remi" value="#itaxea.amd_exe_tax_remi#" size="10"></td>
</tr>	


<tr><td colspan="6">	
<center>
	<input type="submit" name="submit" value="Save">
	<input type="button" name="exit" value="Exit" Onclick="window.close()">
</center>	
</form>
</td></tr>
</table>	
	

</cfoutput>		
</body>	
</html>