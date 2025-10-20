<!--- MT<cfscript>
	gs_qry = event.getArg('gsetupData');
	c_qry = event.getArg('ccountry');
</cfscript>--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Parameter Setup</title> 
    <link rel="shortcut icon" href="/PMS.ico" />
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	
	<script language="javascript">
	function rdate(){
	var thisDate = new Date();
	thisDate.setYear(document.paraForm.myear.value);
	thisDate.setMonth(parseInt(document.paraForm.mmonth.value));
	//var ddate = thisDate.setFullYear(dyear,dmonth-1,1);
	thisDate.setDate(0);
	//thisDate.setDate(0);
	document.getElementById("lyear").innerHTML = thisDate.getDate()+'/'+parseInt(document.paraForm.mmonth.value)+'/'+thisDate.getFullYear();
	//alert(thisDate.getDate()+'/'+thisDate.getMonth()+'/'+thisDate.getFullYear());
	//dstring = thisDate.toLocaleString()
	//alert(thisDate);
	}
	
	function addLoadEvent()
	{
		/* This function adds tabberAutomatic to the window.onload event,
		so it will run after the document has finished loading.*/
		var oldOnLoad;
		/* Taken from: http://simon.incutio.com/archive/2004/05/26/addLoadEvent */
		oldOnLoad = window.onload;
		if (typeof window.onload != 'function') {
			window.onload = function(){
			rdate();
			};
		}else{
			window.onload = function() {
				oldOnLoad();
				rdate();
			};
		}
	}
	addLoadEvent();
	</script>
</head>

<body>
	<div class="mainTitle">Parameter Setup</div>
	<!---<cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="otForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post">--->
	<cfoutput>
	<cfquery name="gs_qry" datasource="#dts_main#">
	SELECT * FROM gsetup WHERE  comp_id = "#HcomID#"
	</cfquery>
	<cfquery name="gs_qry2" datasource="#dts_main#">
	SELECT * FROM gsetup2 WHERE  comp_id = "#HcomID#"
	</cfquery>

    <cfset cpf_ccode = "CPF">
	<cfif HuserCcode eq "MY">
		<cfset cpf_ccode = "EPF">
	<cfelseif HuserCcode eq "ID">
		<cfset cpf_ccode = "JHT">
	</cfif>
    
	<div class="tabber">
		<div class="tabbertab">
			<h3>Company Details</h3>
			
			<cfform name="paraForm" action="parameterSetupMain_process.cfm" method="post">
			<table class="form" border="0">
			<tr>
				<th class="subheader" colspan="4">Company</th>
			</tr>
			<tr>
				<td width="170px">Company Name</td>
				<td colspan="3"><input type="text" name="comp_name" value="#gs_qry.comp_name#" size="80" maxlength="80" /><cfif HuserCcode eq "SG">**For IR8A E-Submission Purpose</cfif></td>
			</tr>
			<tr>
				<td>Address</td>
				<td colspan="3"><input type="text" name="comp_add1" value="#gs_qry.comp_add1#" size="60" maxlength="60" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="comp_add2" value="#gs_qry.comp_add2#" size="60" maxlength="60" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="comp_add3" value="#gs_qry.comp_add3#" size="60" maxlength="60" /></td>
			</tr>
			<tr>
				<td>Phone No.</td>
				<td colspan="3"><input type="text" name="comp_phone" value="#gs_qry.comp_phone#" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td>Fax No.</td>
				<td colspan="3"><input type="text" name="comp_fax" value="#gs_qry.comp_fax#" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td>R.O.C. Ref.No. <cfif HuserCcode eq "MY">(SSM)</cfif></td>
				<td colspan="3"><input type="text" name="comp_roc" value="#gs_qry.comp_roc#" size="20" maxlength="20" /></td>
			</tr>
            <cfif HuserCcode eq "MY" or HuserCcode eq "ID">
            <tr>
            	<td><cfif HuserCcode eq "MY">No. Majikan (LHDN)<cfelse>NPWP Badan Usaha</cfif></td>
                <td colspan="3"><cfif HuserCcode eq "MY">E&nbsp;&nbsp;</cfif><input type="text" name="nomajikan" value="#gs_qry.nomajikan#" size="20" maxlength="20" /></td>
            </tr>
            <tr>
            	<td><cfif HuserCcode eq "MY">No. Majikan (KWSP)<cfelse>Kode ILO</cfif></td>
                <td colspan="3"><input type="text" name="nomajikanepf" value="#gs_qry.nomajikanepf#" size="20" maxlength="20" /></td>
            </tr>
            <tr>
            	<td><cfif HuserCcode eq "MY">Kod Status<cfelse>Status Badan Usaha</cfif></td>
                <td>
                	<select name="kodstatus" id="kodstatus">
                    <option value=""></option>
					<cfif HuserCcode eq "MY">
                    <option value="01" #IIF(gs_qry.kodstatus eq "01",DE("selected"),DE(""))#>1-Kerajaan</option>
                    <option value="02" #IIF(gs_qry.kodstatus eq "02",DE("selected"),DE(""))#>2-Kerajaan Berkomputer*</option>
                    <option value="03" #IIF(gs_qry.kodstatus eq "03",DE("selected"),DE(""))#>3-Berkanun</option>
                    <option value="04" #IIF(gs_qry.kodstatus eq "04",DE("selected"),DE(""))#>4-Berkanun Berkomputer*</option>
                    <option value="05" #IIF(gs_qry.kodstatus eq "05",DE("selected"),DE(""))#>5-Swasta</option>
                    <option value="06" #IIF(gs_qry.kodstatus eq "06",DE("selected"),DE(""))#>6-Swasta Berkomputer*</option>
                    <option value="07" #IIF(gs_qry.kodstatus eq "07",DE("selected"),DE(""))#>7-Pusat Pengajian Kerajaan</option>
                    <option value="08" #IIF(gs_qry.kodstatus eq "08",DE("selected"),DE(""))#>8-Pusat Pengajian Kerajaan Berkomputer*</option>
                    <option value="09" #IIF(gs_qry.kodstatus eq "09",DE("selected"),DE(""))#>9-Pusat Pengajian Swasta</option>
                    <option value="10" #IIF(gs_qry.kodstatus eq "10",DE("selected"),DE(""))#>10-Pusat Pengajian Swasta Berkomputer*</option>
                    <option value="11" #IIF(gs_qry.kodstatus eq "11",DE("selected"),DE(""))#>11-Tenera</option>
                    <cfelse>
                    <option value="01" #IIF(gs_qry.kodstatus eq "01",DE("selected"),DE(""))#>1-Pusat</option>
                    <option value="02" #IIF(gs_qry.kodstatus eq "02",DE("selected"),DE(""))#>2-Daerah</option>
                    <option value="03" #IIF(gs_qry.kodstatus eq "03",DE("selected"),DE(""))#>3-Cabang</option>
                    <option value="04" #IIF(gs_qry.kodstatus eq "04",DE("selected"),DE(""))#>4-Anak Perusahaan</option>
                    <option value="05" #IIF(gs_qry.kodstatus eq "05",DE("selected"),DE(""))#>5-Cabang Anak Perusahaan</option>
                    </cfif>
                	</select>
               </td>
            </tr>
            </cfif>
            
            <cfif HuserCcode eq "SG" or HuserCcode eq "ID">
			<tr><td><cfif HuserCcode eq "SG">Source<cfelse>Status Kepemilikan</cfif></td>
				<td colspan="3">
					<select name="Source">
                    <cfif HuserCcode eq "SG">
					<option value="Private" #IIF(gs_qry.Source eq "Private",DE("selected"),DE(""))#>Private Sector</option>
					<option value="Mindef" #IIF(gs_qry.Source eq "Mindef",DE("selected"),DE(""))#>Mindef</option>
					<option value="Government" #IIF(gs_qry.Source eq "Government",DE("selected"),DE(""))#>Government Department</option>
					<option value="Statutory" #IIF(gs_qry.Source eq "Statutory",DE("selected"),DE(""))#>Statutory Board</option>
					<option value="Others" #IIF(gs_qry.Source eq "Others",DE("selected"),DE(""))#>Others</option>
					</select>**For IR8A E-Submission Purpose</td>
                    <cfelse>
                    <option value=""></option>
					<option value="1" #IIF(gs_qry.Source eq "1",DE("selected"),DE(""))#>1-Swasta National</option>
					<option value="2" #IIF(gs_qry.Source eq "2",DE("selected"),DE(""))#>2-Swasta Asing</option>
					<option value="3" #IIF(gs_qry.Source eq "3",DE("selected"),DE(""))#>3-BUMN</option>
					<option value="4" #IIF(gs_qry.Source eq "4",DE("selected"),DE(""))#>4-BUMD</option>
					<option value="5" #IIF(gs_qry.Source eq "5",DE("selected"),DE(""))#>5-Koperasi</option>
					<option value="6" #IIF(gs_qry.Source eq "6",DE("selected"),DE(""))#>6-Yayasan</option>
					<option value="7" #IIF(gs_qry.Source eq "7",DE("selected"),DE(""))#>7-Joint Venture</option>
					<option value="8" #IIF(gs_qry.Source eq "8",DE("selected"),DE(""))#>8-Perseorangan</option>
					</select></td>
                    </cfif>
			</tr>
			<tr><td><cfif HuserCcode eq "SG">Organization ID Type<cfelse>Bentuk Badan Hukum</cfif></td>
				<td colspan="3">
					<select name="Organization_ID_Type">
                    <cfif HuserCcode eq "SG">
					<option value="UEN" #IIF(gs_qry.Organization_ID_Type eq "UEN",DE("selected"),DE(""))#>UEN - Business Registration number issued by ACRA</option>
					<option value="UEN2" #IIF(gs_qry.Organization_ID_Type eq "UEN2",DE("selected"),DE(""))#>UEN - Local Company Registration number issued by ACRA</option>
					<option value="ASGD" #IIF(gs_qry.Organization_ID_Type eq "ASGD",DE("selected"),DE(""))#>ASGD - Tax Reference number assigned by IRAS</option>
					<option value="ITR" #IIF(gs_qry.Organization_ID_Type eq "ITR",DE("selected"),DE(""))#>ITR - Income Tax Reference number assigned by IRAS</option>
					<option value="GSTN" #IIF(gs_qry.Organization_ID_Type eq "GSTN",DE("selected"),DE(""))#>GSTN - Goods & Services Tax number issued by IRAS</option>
					<option value="UENO" #IIF(gs_qry.Organization_ID_Type eq "UENO",DE("selected"),DE(""))#>UENO - Unique Entity Number Others (E.g Foreign Company Registration Number)</option>
                    <option value="CRN" #IIF(gs_qry.Organization_ID_Type eq "CRN",DE("selected"),DE(""))#>CRN</option>
                    <option value="MCST" #IIF(gs_qry.Organization_ID_Type eq "MCST",DE("selected"),DE(""))#>MCST</option>
					</select>**For IR8A E-Submission Purpose</td>
                	<cfelse>
                    <option value=""></option>
					<option value="1" #IIF(gs_qry.Organization_ID_Type eq "1",DE("selected"),DE(""))#>1-Perseroan Terbatas(PT)</option>
					<option value="2" #IIF(gs_qry.Organization_ID_Type eq "2",DE("selected"),DE(""))#>2-Persekutuan Komanditer(CV)</option>
					<option value="3" #IIF(gs_qry.Organization_ID_Type eq "3",DE("selected"),DE(""))#>3-Usaha Dagang(UD)</option>
					<option value="4" #IIF(gs_qry.Organization_ID_Type eq "4",DE("selected"),DE(""))#>4-Koperasi</option>
					<option value="5" #IIF(gs_qry.Organization_ID_Type eq "5",DE("selected"),DE(""))#>5-Firma</option>
					<option value="6" #IIF(gs_qry.Organization_ID_Type eq "6",DE("selected"),DE(""))#>6-Yayasan</option>
					</select></td>
                    </cfif>

			</tr>
            </cfif>
            
			<tr>
			  <td><cfif HuserCcode eq "MY">No. Majikan (SOCSO)<cfelseif HuserCcode eq "SG">Organization ID No.<cfelseif HuserCcode eq "ID">NPP</cfif></td>
			  <td colspan="3"><input type="text" name="UEN" value="#gs_qry.uen#" size="20" maxlength="20"  /><cfif HuserCcode eq "SG">**For IR8A E-Submission Purpose</cfif></td>
			</tr>
			<tr>
				<td>Name of Division/ Branch</td>
				<td colspan="3"><input type="text" name="Name_of_Division" value="#gs_qry.Name_of_Division#" size="20" maxlength="30"  /></td>
			</tr>
			<tr>
				<td>Name of authorised person</td>
				<td colspan="3"><input type="text" name="authorised_name" value="#gs_qry.authorised_name#" size="20" maxlength="30"  /><cfif HuserCcode eq "SG">**For IR8A E-Submission Purpose</cfif></td>
			</tr>
            <tr>
				<td>Email of authorised person</td>
				<td colspan="3"><input type="text" name="authorised_email" value="#gs_qry.authorised_email#" size="20" maxlength="30"  /><cfif HuserCcode eq "SG">**For IR8A E-Submission Purpose</cfif></td>
			</tr>
			<tr>
				<th class="subheader" colspan="2">Country</th>
				<th class="subheader" colspan="2">Payroll Manager</th>
			</tr>
			<cfquery name="c_qry" datasource="payroll_main">
				SELECT * FROM councode
			</cfquery>
			<tr>
				<td>Country Code</td>
				<td width="50px">
					<select name="ccode" onchange="document.otForm.ccsymbol.value=this.label;">
					<cfloop query="c_qry">
						<option value="#c_qry.ccode#" #IIF(c_qry.ccode eq gs_qry.ccode,DE("selected"),DE(""))#>#c_qry.cname#</option>
					</cfloop>
					</select>				</td>
				<td>Name</td>
				<td><input type="text" name="pm_name" value="#gs_qry.pm_name#" size="40" maxlength="45" /></td>
			</tr>
			<tr>
				<td>Currency Symbol</td>
				<td><input type="text" name="ccsymbol" value="#gs_qry.ccsymbol#" size="4" maxlength="2" /></td>
				<td>NRIC</td>
				<td><input type="text" name="pm_nric" value="#gs_qry.pm_nric#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<th class="subheader" colspan="2" <cfif HUserGrpID neq 'super'>style="visibility:hidden" </cfif>>Month</th>
				<td>Position</td>
				<td><input type="text" name="pm_position" value="#gs_qry.pm_position#" size="30" maxlength="30" /></td>
			</tr>
			<tr>
				<td <cfif HUserGrpID neq 'super'>style="visibility:hidden" </cfif>>This Month</td>
				<td <cfif HUserGrpID neq 'super'>style="visibility:hidden" </cfif>><select name="mmonth"  onchange="rdate();">
					<cfloop from=1 to=13 index="i">
					<option value="#i#" #IIF("#i#" eq gs_qry.mmonth,DE("selected"),DE(""))#>#i#</option>
					</cfloop>
					</select></td>
				<!--- <input type="text" name="mmonth" value="#gs_qry.mmonth#" size="2" maxlength="2" onblur="checkMonth();" /> --->
				<td>Tel.</td>
				<td><input type="text" name="pm_tel" value="#gs_qry.pm_tel#" size="20" maxlength="30" /></td>
			</tr>
			<tr>
				<td <cfif HUserGrpID neq 'super'>style="visibility:hidden" </cfif>>This Year</td>
				<td <cfif HUserGrpID neq 'super'>style="visibility:hidden" </cfif>><input type="text" name="myear" value="#gs_qry.myear#" size="5" maxlength="4" onblur="rdate();" /></td>
				<td>Fax</td>
				<td><input type="text" name="pm_fax" value="#gs_qry.pm_fax#" size="20" maxlength="30" /></td>
			</tr>
            
            
            <tr>
				<th colspan="2">Interface</th>
                
			</tr>
            
            <tr>
				<td>Interface</td>
                <td><select name="interface" id="interface">
                <option value="old" <cfif gs_qry.interface eq 'old'>selected</cfif>>Previous Interface</option>
                <option value="new" <cfif gs_qry.interface eq 'new'>selected</cfif>>New Interface</option>
                </select>		</td>	</tr>
            
			<tr>
				<td>&nbsp;</td>
			</tr>
			<cfset thisDate = CreateDate(year(now()),month(now()),day(DaysInMonth(now())))>
			<tr>
				<td class="llabel">Report Date :<label id="lyear"></label> <!---div id="lyear"></div---></td>
			</tr>
			<!--- <tr>#DateFormat(getjob.DUE_DATE, "dd-mm-yyyy")#
				<td><input type="text" name="year" value=""></td>
			</tr>
			<tr>
				<td><input type="button" name="" value="date" onclick="window.location='date.cfm?year=2001&month=3&day=1'"></td>
			</tr> --->
			</table>
		</div>
		<div class="tabbertab">
			<h3>Pay Calculation</h3>
			<table class="form" border="0">
			<tr>
				<th class="subheader" colspan="4">Basic Pay (Monthly Rated) Determination</th>
			</tr>
			<tr>
				<td colspan="2">No. of payment per month</td>
				<td colspan="2">
					<select name="bp_payment">
						<option value="1" #IIF(gs_qry.bp_payment eq "1",DE("selected"),DE(""))#>Pay once a month</option>
						<option value="2" #IIF(gs_qry.bp_payment eq "2",DE("selected"),DE(""))#>Pay twice a month</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">1st Half Basic Pay Cal. Method</td>
				<td colspan="2">
					<select name="bp_h1pcm">
						<option value="H" #IIF(gs_qry.bp_h1pcm eq "H",DE("selected"),DE(""))#>Half of the basic rate</option>
						<option value="P" #IIF(gs_qry.bp_h1pcm eq "P",DE("selected"),DE(""))#>Pro-rated to days of month</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">Deduction method for NPL</td>
				<td colspan="2">
					<select name="bp_dedmnpl">
						<option value="WD" #IIF(gs_qry.bp_dedmnpl eq "WD",DE("selected"),DE(""))#>Rate / Working days</option>
                        <option value="NW" #IIF(gs_qry.bp_dedmnpl eq "NW",DE("selected"),DE(""))#>Personel Basic Rate / Whole Month Working days (2nd half NPL only)</option>
						<option value="FD" #IIF(gs_qry.bp_dedmnpl eq "FD",DE("selected"),DE(""))#>Rate / Fixed days per month</option>
						<option value="DW" #IIF(gs_qry.bp_dedmnpl eq "DW",DE("selected"),DE(""))#>Rate / No. of days in the month</option>
                        <option value="WW" #IIF(gs_qry.bp_dedmnpl eq "WW",DE("selected"),DE(""))#>Rate x 12 / No. of days in the week x 52</option>
                        <option value="HP" #IIF(gs_qry.bp_dedmnpl eq "HP",DE("selected"),DE(""))#>Rate / Fix hour per year</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">Leave to allowance rate</td>
				<td colspan="2">
					<select name="alawrate">
						<option value="WD" #IIF(gs_qry.alawrate eq "WD",DE("selected"),DE(""))#>Rate / Working days</option>
                        <option value="NW" #IIF(gs_qry.alawrate eq "NW",DE("selected"),DE(""))#>Personel Basic Rate / Whole Month Working days (2nd half NPL only)</option>
						<option value="FD" #IIF(gs_qry.alawrate eq "FD",DE("selected"),DE(""))#>Rate / Fixed days per month</option>
						<option value="DW" #IIF(gs_qry.alawrate eq "DW",DE("selected"),DE(""))#>Rate / No. of days in the month</option>
                        <option value="WW" #IIF(gs_qry.alawrate eq "WW",DE("selected"),DE(""))#>Rate x 12 / No. of days in the week x 52</option>
                        <option value="HP" #IIF(gs_qry.alawrate eq "HP",DE("selected"),DE(""))#>Rate / Fix hour per year</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">If Payday is less than half of the working day<br />
					Basic Pay = Payday * Day_Rate only if Payday <=</td>
				<td colspan="2"><input type="text" name="bp_payday" value="#gs_qry.bp_payday#" /></td>
			</tr>
			<tr>
				<td colspan="2">Lateness deduction ratio</td>
				<td colspan="2"><input type="text" name="bp_dedratio" value="#gs_qry.bp_dedratio#" /></td>
			</tr>
            <tr>
				<td colspan="2">Pay Hours Rate Round Up</td>
				<td colspan="2"><input type="checkbox" name="payhourrate" id="payhourrate" <cfif gs_qry.payhourrate eq "Y">checked="checked"</cfif> /></td>
			</tr>
            <tr>
				<td colspan="2">Allow Allowance On NPL</td>
				<td colspan="2"><input type="checkbox" name="allowancenpl" id="allowancenpl" <cfif gs_qry.allowancenpl eq "Y">checked="checked"</cfif> /></td>
			</tr>
            <tr>
				<td colspan="2">NPL day Rate Round Off</td>
				<td colspan="2"><input type="checkbox" name="NPLROUND" id="NPLROUND" <cfif gs_qry.NPLROUND eq "Y">checked="checked"</cfif> /></td>
			</tr>
            <tr>
				<td colspan="2">Calculate NPL With HPY</td>
				<td colspan="2"><input type="checkbox" name="NPLHPY" id="NPLHPY" <cfif gs_qry.NPLHPY eq "Y">checked="checked"</cfif> /></td>
			</tr>
            <tr>
				<td colspan="2">Calculate NPL With Deduction Method</td>
				<td colspan="2"><input type="checkbox" name="NPLDED" id="NPLDED" <cfif gs_qry.NPLDED eq "Y">checked="checked"</cfif> /></td>
			</tr>
			<tr>
				<th class="subheader" colspan="4">Overtime Determination</th>
			</tr>
			<tr>
				<td>Maximum pay allowed to calculate HRP</td>
				<td>(1)</td>
				<td colspan="2"><input type="text" name="od_maxpay1" value="#gs_qry.OD_MAXPAY1#" /></td>
			</tr>
			<tr>
				<td></td>
				<td width="50px">(2)</td>
				<td><input type="text" name="od_maxpay2" value="#gs_qry.OD_MAXPAY2#" /></td>
				<td><input type="checkbox" name="od_inclad" value="" #IIF(gs_qry.od_inclad eq 0,DE(""),DE("checked"))# />Inclusive of Allowance / Deduction</td>
			</tr>
			<tr>
				<td colspan="2">Calculation HRP from day based Aw.</td>
				<td colspan="2">
					<select name="od_calhrp">
						<option value="R" #IIF(gs_qry.od_calhrp eq "R",DE("selected"),DE(""))#>HRP = + Rate/Hour</option>
						<option value="DH" #IIF(gs_qry.od_calhrp eq "DH",DE("selected"),DE(""))#>HRP = + AW/Day/Hour (D, H)</option>
						<option value="M" #IIF(gs_qry.od_calhrp eq "M",DE("selected"),DE(""))#>HRP = + AW*12/Hours Per Year (M)</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">Determination of Calculation OT.</td>
				<td colspan="2">
					<select name="paybase">
						<option value="BR" #IIF(gs_qry.paybase eq "BR",DE("selected"),DE(""))#>Calculate OT Base on Basic Rate</option>
						<option value="BP" #IIF(gs_qry.paybase eq "BP",DE("selected"),DE(""))#>Calculate OT Base on Basic Pay</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">Calculation OT From Last Month HRP / ORP</td>
				<td colspan="2">
					<select name="od_calot">
						<option value="Y" #IIF(gs_qry.od_calot eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.od_calot eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
            <tr>
				<td colspan="2">Monthly Rated Based On Hours Per Year</td>
				<td colspan="2">
					<select name="hpy">
						<option value="Y" #IIF(gs_qry.hpy eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.hpy eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
             <tr>
				<td colspan="2">Overtime Round Before Ratio</td>
				<td colspan="2">
					<select name="otrbr">
						<option value="Y" #IIF(gs_qry.otrbr eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.otrbr eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
            <tr>
				<td colspan="2">Round Overtime Rate</td>
				<td colspan="2">
					<select name="otrater">
						<option value="Y" #IIF(gs_qry.otrater eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.otrater eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Project OT Based On Basicpay</td>
				<td> </td>
				<td>
					<input type="checkbox" name="proj_base_basicpay"  #IIF(gs_qry.proj_base_basicpay eq 0,DE(""),DE("checked"))# />
				</td>
			</tr>
			<tr>
				<th class="subheader" colspan="4">#cpf_ccode# Determination</th>
			</tr>
			
			<tr>
				<td colspan="2"></td>
				<td colspan="2">
					<select style="display:none" name="Auto_cpf">
						<option value="Y" #IIF(gs_qry.Auto_cpf eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.Auto_cpf eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
		
			
			<tr>
				<td colspan="2">1st Half #cpf_ccode# equal to half full month #cpf_ccode#</td>
				<td colspan="2">
					<select name="cd_h1cpf">
						<option value="Y" #IIF(gs_qry.cd_h1cpf eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.cd_h1cpf eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">1st Half #cpf_ccode# Select Range Using Personal Basic Rate</td>
				<td colspan="2">
					<select name="cpf_selectrange">
						<option value="Y" #IIF(gs_qry.cpf_selectrange eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.cpf_selectrange eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
			</tr>
            <tr id="fhrs">
            <td colspan="2">1st Half #cpf_ccode# Select Range Include Bonus , Commission & Extra</td>
				<td colspan="2">
					<select name="firsthalfselectrange" id="firsthalfselectrange">
						<option value="Y" #IIF(gs_qry.firsthalfselectrange eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.firsthalfselectrange eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
            </tr>
            <tr id="shrs" >
            <td colspan="2">Bonus #cpf_ccode# Select Range Include 1st Half & 2nd Half</td>
				<td colspan="2">
					<select name="secondhalfselectrange" id="secondhalfselectrange">
						<option value="Y" #IIF(gs_qry.secondhalfselectrange eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.secondhalfselectrange eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
            </tr>
           
            <tr id="balancecpf">
            <td colspan="2">Balance #cpf_ccode# Adjust at</td>
				<td colspan="2">
					<select name="balancecpf" id="balancecpf">
						<option value="paytran" <cfif gs_qry.balancecpf eq "paytran">Selected</cfif> >2nd Half</option>
						<option value="bonus" <cfif gs_qry.balancecpf eq "bonus">Selected</cfif> >Bonus</option>
					</select>
				</td>
            </tr>
             <tr>
            <td colspan="2">Sub #cpf_ccode# With Decimal</td><td colspan="2">
					<select name="subcpfdecimal" id="subcpfdecimal">
						<option value="Y" #IIF(gs_qry.subcpfdecimal eq "Y",DE("selected"),DE(""))#>Yes</option>
						<option value="N" #IIF(gs_qry.subcpfdecimal eq "N",DE("selected"),DE(""))#>No</option>
					</select>
				</td>
            </tr>
            <tr style="display:none">	
				<td><input type="checkbox" name="balanceepf" value="" #IIF(gs_qry.balanceepf eq 0,DE(""),DE("checked"))#>Calculate Bonus First (Balance #cpf_ccode# adjust at must 2nd half)</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="cpf_add_rg" #IIF(gs_qry.cpf_add_rg eq 0,DE(""),DE("checked"))# >Add Allowance, Deduction, OT when select formula #cpf_ccode#. </td>
			</tr>
			<tr>	
				<td><input type="checkbox" name="" value="">Commission is Additional Wages</td>
			</tr>
			<tr>	
				<td><input type="checkbox" name="cpfceilmonth" id="cpfceilmonth" #IIF(gs_qry2.cpfceilmonth eq 0,DE(""),DE("checked"))# 
										<cfif HuserCcode neq "SG">Hidden</cfif>><cfif HuserCcode eq "SG">CPF ceiling with 12 months</cfif></td>
			</tr>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Pay Calculation[2]</h3>
			<table class="form" border="0">
			<tr>
				<th class="subheader" colspan="3">Basic Rate Decimal Setting</th>
			</tr>
			<tr>
				<td width="300">Set Basic Rate To</td>
				<td colspan="2" width="450">
					<select name="brds_rate">
						<option value="2" #IIF(gs_qry.brds_rate eq "2",DE("selected"),DE(""))#>2 decimal point</option>
						<option value="3" #IIF(gs_qry.brds_rate eq "3",DE("selected"),DE(""))#>3 decimal point</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="subheader" colspan="3">Tip Claimable</th>
			</tr>		
			<tr>
				<td>Tip Claimable Point Ratio</td>
				<td colspan="2"><input type="text" name="tc_cpratio" value="#gs_qry.tc_cpratio#" size="53" maxlength="45"></td>
			</tr>
			<tr>
				<th class="subheader" colspan="3">Smallest Unit Determination</th>
			</tr>	
			<tr>
				<td>Payment smallest unit (Overtime)</td>
				<td>
					<select name="sud_otpsu">
						<option value="1" #IIF(gs_qry.sud_otpsu eq "1",DE("selected"),DE(""))#>1 cent</option>
						<option value="2" #IIF(gs_qry.sud_otpsu eq "2",DE("selected"),DE(""))#>2 cents</option>
						<option value="5" #IIF(gs_qry.sud_otpsu eq "5",DE("selected"),DE(""))#>5 cents</option>
						<option value="10" #IIF(gs_qry.sud_otpsu eq "10",DE("selected"),DE(""))#>10 cents</option>
						<option value="20" #IIF(gs_qry.sud_otpsu eq "20",DE("selected"),DE(""))#>20 cents</option>
						<option value="50" #IIF(gs_qry.sud_otpsu eq "50",DE("selected"),DE(""))#>50 cents</option>
						<option value="100" #IIF(gs_qry.sud_otpsu eq "100",DE("selected"),DE(""))#>100 cents</option>
					</select>
				</td>
				<th rowspan="2" width="320px">For OT1,2,3,4,Rest Day Pay,Holiday Pay</th>
			</tr>
			<tr>
				<td>Round (Overtime)</td>
				<td>
					<select name="sud_otrnd" style="width:82px;">
						<option value="U" #IIF(gs_qry.sud_otrnd eq "U",DE("selected"),DE(""))#>Up</option>
						<option value="D" #IIF(gs_qry.sud_otrnd eq "D",DE("selected"),DE(""))#>Down</option>
						<option value="O" #IIF(gs_qry.sud_otrnd eq "O",DE("selected"),DE(""))#>Off</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Payment smallest unit</td>
				<td>
					<select name="sud_psu">
						<option value="1" #IIF(gs_qry.sud_psu eq "1",DE("selected"),DE(""))#>1 cent</option>
						<option value="2" #IIF(gs_qry.sud_psu eq "2",DE("selected"),DE(""))#>2 cents</option>
						<option value="5" #IIF(gs_qry.sud_psu eq "5",DE("selected"),DE(""))#>5 cents</option>
						<option value="10" #IIF(gs_qry.sud_psu eq "10",DE("selected"),DE(""))#>10 cents</option>
						<option value="20" #IIF(gs_qry.sud_psu eq "20",DE("selected"),DE(""))#>20 cents</option>
						<option value="50" #IIF(gs_qry.sud_psu eq "50",DE("selected"),DE(""))#>50 cents</option>
						<option value="100" #IIF(gs_qry.sud_psu eq "100",DE("selected"),DE(""))#>100 cents</option>
					</select>
				</td>
				<th width="330px">For Basic Pay,Total Allowance,Total Deduction or Net Pay</th>
			</tr>
			<tr>
				<td>Round</td>
				<td colspan="2">
					<select name="sud_rnd">
						<option value="U" #IIF(gs_qry.sud_rnd eq "U",DE("selected"),DE(""))#>Round Up Net</option>
						<option value="D" #IIF(gs_qry.sud_rnd eq "D",DE("selected"),DE(""))#>Round Down Net</option>
						<option value="O" #IIF(gs_qry.sud_rnd eq "O",DE("selected"),DE(""))#>Round Off Net</option>
						<option value="UB" #IIF(gs_qry.sud_rnd eq "UB",DE("selected"),DE(""))#>Round Up Basicpay, Total AW, Total DED</option>
						<option value="DB" #IIF(gs_qry.sud_rnd eq "DB",DE("selected"),DE(""))#>Round Down Basicpay, Total AW, Total DED</option>
						<option value="OB" #IIF(gs_qry.sud_rnd eq "OB",DE("selected"),DE(""))#>Round Off Basicpay, Total AW, Total DED</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="subheader" colspan="3">Advance Determination</th>
			</tr>
			<tr rowspan="2">
				<td width="300">Do not generate advance to employees who joined this month and after this day</td>
				<td colspan="2"><input type="text" name="ad_atd" value="#gs_qry.ad_atd#" maxlength="2" size="2"></td>
			</tr>
            <tr>
				<td width="300">No Calculation For SDL if #cpf_ccode# category is X</td>
				<td colspan="2"><input type="checkbox" name="nosdl" id="nosdl" <cfif gs_qry.nosdl eq "Y">checked="checked" </cfif>></td>
			</tr>
			<tr>
				<th class="subheader" colspan="3">Pension Contribution</th>
			</tr>
			<tr>
				<td>Pension Contribution Formula</td>
				<td colspan="2"><input type="text" name="pc_pcf" value="#gs_qry.pc_pcf#" size="70" maxlength="60"></td>
			</tr>
			<tr>
				<th class="subheader" colspan="3">Project #cpf_ccode# Contribution</th>
			</tr>
			<tr>
				<td><input type="checkbox" name="cpfcc_add_prj" #IIF(gs_qry.cpfcc_add_prj eq 0,DE(""),DE("checked"))# >Include #cpf_ccode# employer when cal. project job costing </td>
			</tr>
			<tr>	
				<td><input type="checkbox" name="cpfww_add_prj" #IIF(gs_qry.cpfww_add_prj eq 0,DE(""),DE("checked"))#>Include #cpf_ccode# employee when cal. project job costing </td>
			</tr>
			<tr>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Control</h3>
			<table class="form" border="0">
			<tr>
				<th class="subheader" colspan="4">Transaction</th>
			</tr>
			<tr>
				<td><input type="checkbox" name="t1" #IIF(gs_qry.t1 eq 0,DE(""),DE("checked"))#></td>
				<td width="320px">Allow 1st half under all conditions</td>
				<!--- <td><input type="checkbox" name="t2" #IIF(gs_qry.t2 eq 0,DE(""),DE("checked"))#></td>
				<th width="370px">Deduction No.15 used as CP38</th> --->
			</tr>
			<tr>
				<td><input type="checkbox" name="t3" #IIF(gs_qry.t3 eq 0,DE(""),DE("checked"))#></td>
				<td>Clear Advance on month end</td>
				<td><input type="checkbox" name="t4" #IIF(gs_qry.t4 eq 0,DE(""),DE("checked"))#></td>
				<td>Display Anual Leave & Medical Leave balanced in transaction</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="t5" #IIF(gs_qry.t5 eq 0,DE(""),DE("checked"))#></td>
				<td>Clear bonus on month end</td>
				<td><input type="checkbox" name="t6" #IIF(gs_qry.t6 eq 0,DE(""),DE("checked"))#></td>
				<td>Get hours per year from monthly OT hours table</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="t7" #IIF(gs_qry.t7 eq 0,DE(""),DE("checked"))#></td>
				<td>Clear commission on month end</td>
				<td><input type="checkbox" name="t8" #IIF(gs_qry.t8 eq 0,DE(""),DE("checked"))#></td>
				<td>Full Fixed allowance used to calculate 1st half overtime</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="t9" #IIF(gs_qry.t9 eq 0,DE(""),DE("checked"))#></td>
				<td>Clear extra on month end</td>
				<!--- <td><input type="checkbox" name="t10" #IIF(gs_qry.t10 eq 0,DE(""),DE("checked"))#></td>
				<th>Do not adjust bonus PCB/Comm.PCB/Dir.Fee PCB on 2nd Half</th> --->
                
			</tr>
			<tr>
				<td><input type="checkbox" name="t11" #IIF(gs_qry.t11 eq 0,DE(""),DE("checked"))#></td>
				<td>Delete advance in transaction</td>
				<!--- <td><input type="checkbox" name="t12" #IIF(gs_qry.t12 eq 0,DE(""),DE("checked"))#></td>
				<th>Bonus calculated based on last year December taxable amount</th> --->
			</tr>
			<tr>
				<td><input type="checkbox" name="t13" #IIF(gs_qry.t13 eq 0,DE(""),DE("checked"))#></td>
				<td>Check working days balanced in transaction</td>
				<!--- <td><input type="checkbox" name="t14" #IIF(gs_qry.t14 eq 0,DE(""),DE("checked"))#></td>
				<th>Employee SI paid by Employer is taxable</th> --->
			</tr>
			<tr>
				<td><input type="checkbox" name="t15" #IIF(gs_qry.t15 eq 0,DE(""),DE("checked"))#></td>
				<td>Auto calculate working days in 1st half</td>
				<td><input type="checkbox" name="t16" #IIF(gs_qry.t16 eq 0,DE(""),DE("checked"))#></td>
				<td>Taxable extra amount</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="t17" #IIF(gs_qry.t17 eq 0,DE(""),DE("checked"))#></td>
				<td width="260px">Automatic update Basic Rate</td>
				
			</tr>
			</table>
			<table class="form" border="0">
			<tr>
				<th class="subheader" colspan="3">Control</th>
				<th class="subheader" colspan="3">Notes</th>
			</tr>
			<div>
			<tr>
				<td colspan="2">Pin nos. allowed to write</td>
				<td><input type="text" name="c_pnos" value="#gs_qry.c_pnos#" maxlength="4" size="10"><td>
				<td>e.g : 0123 &nbsp;&nbsp; 0 &nbsp;&nbsp; 01</td>
			</tr>
			<tr>
				<td colspan="2">Default Pay Slip Format</td>
				<td>
					<select name="c_psformat">
						<option value="Q" #IIF(gs_qry.c_psformat eq "Q",DE("selected"),DE(""))#>Q - Pay Slip</option>
						<option value="R" #IIF(gs_qry.c_psformat eq "R",DE("selected"),DE(""))#>R - Piece Rate Summary</option>
						<option value="S" #IIF(gs_qry.c_psformat eq "S",DE("selected"),DE(""))#>S - A4 Pay Slip</option>
						<option value="T" #IIF(gs_qry.c_psformat eq "T",DE("selected"),DE(""))#>T - Pay Slip</option>
						<option value="U" #IIF(gs_qry.c_psformat eq "U",DE("selected"),DE(""))#>U - Pay Slip</option>
						<option value="V" #IIF(gs_qry.c_psformat eq "V",DE("selected"),DE(""))#>V - Pay Slip</option>
						<option value="W" #IIF(gs_qry.c_psformat eq "W",DE("selected"),DE(""))#>W - Pay Slip</option>
						<option value="X" #IIF(gs_qry.c_psformat eq "X",DE("selected"),DE(""))#>X - Pay Slip</option>
						<option value="Y" #IIF(gs_qry.c_psformat eq "Y",DE("selected"),DE(""))#>Y - Pay Slip</option>
						<option value="Z" #IIF(gs_qry.c_psformat eq "Z",DE("selected"),DE(""))#>Z - Pay Slip</option>
					</select>
				</td>
				<td><input type="checkbox" name="c_prmad" value="" #IIF(gs_qry.c_prmad eq 0,DE(""),DE("checked"))#></td>
				<td>Print pay slip with more AW.&DED. in Details</td>
			</tr>
			<tr>
				<td colspan="2">Default Report Paper Size</td>
				<td>
					<select name="c_rpsize">
						<option value="A3" #IIF(gs_qry.c_rpsize eq "A3",DE("selected"),DE(""))#>A3</option>
						<option value="A4" #IIF(gs_qry.c_rpsize eq "A4",DE("selected"),DE(""))#>A4 Landscape</option>
						<option value="LL" #IIF(gs_qry.c_rpsize eq "LL",DE("selected"),DE(""))#>Letter Landscape</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">Annual Leave Entitle Base on</td>
				<td>
					<select name="c_ale">
						<option value="T" #IIF(gs_qry.c_ale eq "T",DE("selected"),DE(""))#>This Year Work Done</option>
						<option value="L" #IIF(gs_qry.c_ale eq "L",DE("selected"),DE(""))#>Last Year Work Done</option>
					</select>
				</td>    
			</tr>
            <tr>
				<td colspan="2">E-Leave Approval Flow</td>
				<td colspan="3">
					<select name="eleaveapp">
					<option value="adminonly" #IIF(gs_qry.eleaveapp eq "adminonly",DE("selected"),DE(""))#>Admin Only</option>
                    <option value="deptonly" #IIF(gs_qry.eleaveapp eq "deptonly",DE("selected"),DE(""))#>Head Of Department Only</option>
                    <option value="deptadmin" #IIF(gs_qry.eleaveapp eq "deptadmin",DE("selected"),DE(""))#>Head Of Department Then Admin</option>
                    <option value="admindept" #IIF(gs_qry.eleaveapp eq "admindept",DE("selected"),DE(""))#>Admin Then Head Of Department</option>
					</select> **Please process all leave(s) before change approval flow
				</td>
			</tr>
            <tr>
				<td colspan="2">Submit Leave Notification</td>
				<td colspan="3">
					<select name="leaveapproval">
					<option value="everyone" #IIF(gs_qry.leaveapproval eq "everyone",DE("selected"),DE(""))#>Everyone</option>
                    <option value="deptonly" #IIF(gs_qry.leaveapproval eq "deptonly",DE("selected"),DE(""))#>Department Only</option>
					</select>
				</td>
			</tr>
            <tr>
            	<td colspan="2">Leave Actions / Daily Leave / Work Permit Notification</td>
				<td colspan="3">
					<select name="leavereceived">
					<option value="everyone" #IIF(gs_qry.leavereceived eq "everyone",DE("selected"),DE(""))#>Everyone</option>
                    <option value="deptonly" #IIF(gs_qry.leavereceived eq "deptonly",DE("selected"),DE(""))#>Department Only</option>
					</select>
				</td>
            </tr>
            
            <tr>
				<td colspan="2">E-Claim Approval Flow</td>
				<td colspan="3">
					<select name="eclaimapp">
					<option value="adminonly" #IIF(gs_qry.eclaimapp eq "adminonly",DE("selected"),DE(""))#>Admin Only</option>
                    <option value="deptonly" #IIF(gs_qry.eclaimapp eq "deptonly",DE("selected"),DE(""))#>Head Of Department Only</option>
                    <option value="deptadmin" #IIF(gs_qry.eclaimapp eq "deptadmin",DE("selected"),DE(""))#>Head Of Department Then Admin</option>
                    <option value="admindept" #IIF(gs_qry.eclaimapp eq "admindept",DE("selected"),DE(""))#>Admin Then Head Of Department</option>
					</select> **Please process all claim(s) before change approval flow
				</td>
			</tr> 
            
         <tr>
				<td colspan="2">Submit Claim Notification</td>
				<td colspan="3">
					<select name="claimapproval">
					<option value="everyone" #IIF(gs_qry.claimapproval eq "everyone",DE("selected"),DE(""))#>Everyone</option>
                    <option value="deptonly" #IIF(gs_qry.claimapproval eq "deptonly",DE("selected"),DE(""))#>Department Only</option>
                    <option value="turnoff" #IIF(gs_qry.claimapproval eq "turnoff",DE("selected"),DE(""))#>Turn off</option>
					</select>
				</td>
			</tr>
         <tr>
				<td colspan="2">Claim Actions Notification</td>
				<td colspan="3">
					<select name="claimreceived">
					<option value="everyone" #IIF(gs_qry.claimreceived eq "everyone",DE("selected"),DE(""))#>Everyone</option>
                    <option value="deptonly" #IIF(gs_qry.claimreceived eq "deptonly",DE("selected"),DE(""))#>Department Only</option>
                    <option value="turnoff" #IIF(gs_qry.claimreceived eq "turnoff",DE("selected"),DE(""))#>Turn off</option>
					</select>
				</td>
			</tr>
            
			<tr>
				<td colspan="2">Calculate No Pay Days based on DW </td>
				<td colspan="3">
				<select name="Pay_to_Nopay">
					<option value=""></option>
					<option value="LS" #IIF(gs_qry.Pay_to_Nopay eq "LS",DE("selected"),DE(""))#>Line Shut Down</option>
					<option value="NPL" #IIF(gs_qry.Pay_to_Nopay eq "NPL",DE("selected"),DE(""))#>Non-Pay Leaves</option>
					<option value="AB" #IIF(gs_qry.Pay_to_Nopay eq "AB",DE("selected"),DE(""))#>Absent</option>
					<option value="NS" #IIF(gs_qry.Pay_to_Nopay eq "NS",DE("selected"),DE(""))#>National Services</option>
				</select>
				<input type="checkbox" name="allow_to_nopay" value="Y" <cfif gs_qry.Pay_to_Nopay eq "LS" or gs_qry.Pay_to_Nopay eq "NPL" or gs_qry.Pay_to_Nopay eq "AB" or gs_qry.Pay_to_Nopay eq "NS">checked</cfif>>
				</td>
			</tr>
			
			<tr>
				<td colspan="2">Email Notification</td>
				<td colspan="3"><input type="text" name="notif_email" id="notif_email" value="#gs_qry.notif_email#" size="25" maxlength="200">
				<input type="checkbox" name="default_email" id="default_email" value="Y" <cfif gs_qry.default_email eq "Y">checked</cfif>> Default
				</td>
			</tr>
            <tr>
				<td colspan="2">Email Server</td>
				<td colspan="3"><input type="text" name="emailserver" id="emailserver" value="#gs_qry.emailserver#" size="50" maxlength="200">
				</td>
			</tr>
            <tr>
				<td colspan="2">Email Account</td>
				<td colspan="3"><input type="text" name="emailaccount" id="emailaccount" value="#gs_qry.emailaccount#" size="50" maxlength="200">
				</td>
			</tr>
            <tr>
				<td colspan="2">Email Password</td>
				<td colspan="3"><input type="password" name="emailpassword" id="emailpassword" value="#gs_qry.emailpassword#" size="25" maxlength="200">
				</td>
			</tr>
            <tr>
				<td colspan="2">Email Port</td>
				<td colspan="3"><input type="text" name="emailport" id="emailport" value="#gs_qry.emailport#" size="10" maxlength="200">
				</td>
			</tr>
            <tr>
            	<td colspan="2">EMAIL Secure</td>
				<td colspan="3"><input type="radio" name="emailsecure" id="emailsecure" value="SSL" <cfif gs_qry.emailsecure eq "SSL">Checked</cfif> />SSL&nbsp;<input type="radio" name="emailsecure" id="emailsecure" value="TLS" <cfif gs_qry.emailsecure eq "TLS">Checked</cfif> />TLS&nbsp;<input type="radio" name="emailsecure" id="emailsecure" value=""  <cfif gs_qry.emailsecure eq "">Checked</cfif>/>None
				</td>
            </tr>
            <tr>
            <td colspan="2">Saving Deduction</td>
				<td colspan="3"><select name="saving" id="saving">
                <option value="">Choose a Saving Deduction</option>
                <cfloop from="1" to="15" index="a">
                <option value="#a#" <cfif gs_qry.saving eq a>Selected</cfif> >Deduction #a+100#</option>
                </cfloop>
                </select>
				</td>
            </tr>
              <tr>
            <td colspan="2">Saving Allowance</td>
				<td colspan="3"><select name="savingaw" id="savingaw">
                <option value="">Choose a Saving Allowance</option>
                <cfloop from="1" to="17" index="a">
                <option value="#a#" <cfif gs_qry.savingaw eq a>Selected</cfif> >Allowance #a+100#</option>
                </cfloop>
                </select>
				</td>
            </tr>
            <tr>
            <td colspan="2">Annual Leave to Allowance</td>
				<td colspan="3"><select name="altaw" id="altaw">
                <option value="">Choose an Allowance</option>
                <cfloop from="1" to="17" index="a">
                <option value="#a#" <cfif gs_qry.altaw eq a>Selected</cfif> >Allowance #a+100#</option>
                </cfloop>
                </select>
				</td>
            </tr>
            <tr>
            <td colspan="2">ePortal Leave Calendar</td>
            <td colspan="3"><select name="epleavecal" id="epleavecal">
            				<option value="off" <cfif gs_qry2.epleavecal eq "off">Selected</cfif>>Turn Off</option>
            				<option value="dept" <cfif gs_qry2.epleavecal eq "dept">Selected</cfif>>Department Only</option>
                            </select>
            </td>
            </tr>
			<tr>
				<td width=""><input type="checkbox" name="c_spitc" value="" #IIF(gs_qry.c_spitc eq 0,DE(""),DE("checked"))#>
						Set personal information to confidential</td>
                        <td></td>
                        <td></td>
				<td><input type="checkbox" name="eleaveemail" value="" #IIF(gs_qry.eleaveemail eq 0,DE(""),DE("checked"))#>
						</td>
                        <td>Stop inform everyone on expired leave approval</td>
	
				<td width=""><!----<input type="checkbox" name="c_mc" value="" #IIF(gs_qry.c_mc eq 0,DE(""),DE("checked"))#>----></td>
				<td width="" colspan=""><!-----Multi Company------></td>
			</tr>
			<tr>
				<td><input type="checkbox" name="c_sttc" value="" #IIF(gs_qry.c_sttc eq 0,DE(""),DE("checked"))#>
						Set transaction to confidential</td>
				<td></td>
				<td></td>
				<td width=""><input type="checkbox" name="c_ucntmcs" value="" #IIF(gs_qry.c_ucntmcs eq 0,DE(""),DE("checked"))#></td>
				<td width="" colspan="">Update Company Name to Multi Company screen</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="c_wprwc" value="1" #IIF(gs_qry.c_wprwc eq 0,DE(""),DE("checked"))#>
						When print report with console</td>
				<td></td>
				<td></td>
				<td width=""><input type="checkbox" name="c_p" value="" #IIF(gs_qry.c_p eq 0,DE(""),DE("checked"))#></td>
				<td width="" colspan="">Photo</td>
			</tr>
			<tr>
				<td><input type="checkbox" name="" value="">Disable survey</td>
				<td></td>
				<td></td>
				<td><input type="checkbox" name="c_acfwl" value="1" #IIF(gs_qry.c_acfwl eq 0,DE(""),DE("checked"))#></td>
				<td>Auto calculate Foreign Worker Levy</td>
				
			</tr>
			<tr>
				<td><input type="checkbox" name="t23" #IIF(gs_qry.t23 eq 0,DE(""),DE("checked"))#>Auto generate employee number</td>
				<td></td>
				<td></td>
				<td><input type="checkbox" name="c_leavebalance" value="1" #IIF(gs_qry.c_leavebalance eq 0,DE(""),DE("checked"))#></td>
				<td>Allow leave key in more than balance</td>
			</tr>
			<tr>
				<td>Last Employee Number</td>
				<td><input type="text" id="last_empno" name="last_empno" value="#gs_qry.last_empno#"/></td>
				<td></td>
				<td><input type="checkbox" name="eleaveapemail" value="" #IIF(gs_qry.eleaveapemail eq 0,DE(""),DE("checked"))#>
						</td>
                        <td>Inform everyone on leave approval</td>
			</tr>
            <tr>
				<td colspan="2"><input type="checkbox" name="editadd" id="editadd" <cfif gs_qry.editadd eq "Y">checked</cfif>>Restrict employee to change information in ePortal</td>
				<td></td>
				<td><input type="checkbox" name="earnleave" value="Y" #IIF(gs_qry.earnleave eq 0,DE(""),DE("checked"))#></td>
				<td>Using Earn leave in Leave Application</td>
			</tr>
             <tr>
				<td><input type="checkbox" name="eportapp" id="eportapp" <cfif gs_qry2.eportapp eq "Y">checked</cfif>>Prompt admin approval for ePortal changes</td>
                <td />
                <td />
				<td><input type="checkbox" name="wpemail" id="wpemail" onclick="wpdays.value=5" <cfif gs_qry.wpemail eq "Y">checked</cfif>></td>
                <td>Remind WP expiry in <cfinput type="text" name="wpdays" id="wpdays" size ="1" maxlength = "3" validate="integer" message="Remind WP expiry in numerics 1 - 999 days only" value="#gs_qry.wpexpdays#" /> days</td>  
                </tr>
           <tr>
				<td><input type="checkbox" name="remarkmust" id="remarkmust" <cfif gs_qry.remarkmust eq "Y">checked</cfif>>Compulsory Remark in Leave Application</td>
                <td />
                <td />
				<td><input type="checkbox" name="dailyleave" id="dailyleave" <cfif gs_qry.dailyleave eq "Y">checked</cfif>></td>
                <td>Daily leave notification</td>                  
                </tr>
           <tr>
				<td><input type="checkbox" name="ncltoal" id="ncltoal" <cfif gs_qry2.ncltoal eq "Y">checked</cfif>>Convert Time Off To AL</td>                  
                <td />
                <td />
				<td><input type="checkbox" name="leavetable" id="leavetable" <cfif gs_qry.leavetable eq "pleave">checked</cfif>></td>
                <td>Daily leave From Leave Maintainance</td>                  
                </tr> 
                           
			<!--- <tr>
				<th colspan="5">Smart Lock Setting</th>
			</tr>
			<tr>
				<td colspan="2"><input type="radio" name="c_sk" value="UK" <cfif gs_qry.c_sk eq "UK">checked</cfif>>USB Key </td>
			</tr>
			<tr>
				<td colspan="2"><input type="radio" name="c_sk" value="UL" <cfif gs_qry.c_sk eq "UL">checked</cfif>>USB Key for LAN </td>
			</tr>
			<tr>
				<td colspan="2"><input type="radio" name="c_sk" value="DS"<cfif gs_qry.c_sk eq "DS">checked</cfif>>Demo Set </td>
			</tr>--->
			<tr>
				<th colspan="5">Administrative Tool</th>
			</tr>
			<tr>
				<td colspan="5">Please backup data before access and in network enviroment, you are the only user access to this option.</td>
			</tr>
			<tr>
				<td><input type="button" name="" value="Administrative Settings" style="width:150px;" onclick=""></td>
			</tr>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Payment Slip</h3>
			<table class="form" border="0">
			<tr><th class="subheader" colspan="4">Edit Payment Slip</th></tr>
			<tr>
				<td ><input type="checkbox" name="t18" #IIF(gs_qry.t18 eq 0,DE(""),DE("checked"))#></td>
				<td width="320px">Show PAYROLL Type</td>
				<td><input type="checkbox" name="t19" #IIF(gs_qry.t19 eq 0,DE(""),DE("checked"))#></td>
				<td width="320px">Show EMPLOYER'S SIGNATURE</td>
				
			</tr>
			<tr>
			<td><input type="checkbox" name="t20" #IIF(gs_qry.t20 eq 0,DE(""),DE("checked"))#></td>
				<td>Show EMPLOYEE'S SIGNATURE</td>
				<td><input type="checkbox" name="t21" #IIF(gs_qry.t21 eq 0,DE(""),DE("checked"))#></td>
				<td>Show DIRECTOR FEE</td>
			</tr>
			<tr>
			<td><input type="checkbox" name="t22" #IIF(gs_qry.t22 eq 0,DE(""),DE("checked"))#></td>
				<td>Show CHEQUE NO.</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
			<td><input type="checkbox" name="t25" #IIF(gs_qry.t25 eq 0,DE(""),DE("checked"))#></td>
				<td>Show RESIGNED DATE.</td>
				<td></td>
				<td></td>
			</tr>
			<tr><th class="subheader" colspan="4">Customized Pay Slip Usage</th></tr>
			<tr><td colspan="2">Use customized pay slip in: </td></tr>
			<tr><td colspan="2">1st Half Payroll</td><td><input type="checkbox" name="firstpscustom" id="firstpscustom" <cfif gs_qry.firstpscustom eq "Y">checked="checked"</cfif> /></td></tr>
			<tr><td colspan="2">2nd Half Payroll</td><td><input type="checkbox" name="secondpscustom" id="secondpscustom" <cfif gs_qry.secondpscustom eq "Y">checked="checked"</cfif> /></td></tr>
			<tr><td colspan="2">Past Months Pay Transaction</td><td><input type="checkbox" name="pmpscustom" id="pmpscustom" <cfif gs_qry.pmpscustom eq "Y">checked="checked"</cfif> /></td></tr>
			<tr><td colspan="2">Employee Print Pay Slip</td><td><input type="checkbox" name="eppscustom" id="eppscustom" <cfif gs_qry.eppscustom eq "Y">checked="checked"</cfif> /></td></tr>
			</table>
		</div>
        <div class="tabbertab">
			<h3>Payroll Rules</h3>
            
           <table>
           <tr>
           <th colspan="2">Year End Rule</th>
           </tr>
           <tr>
           <td width="300px">
           No of AL Brought Forward After Year End
           </td>
           <td>
           <input type="text" name="leavebf" id="leavebf" value="#gs_qry.leavebf#" />
           </td>
           </tr>
             <tr>
           <th colspan="2">User Defined</th>
           <tr>
           <td>Category</td>
           <td><input type="text" name="ud_category" id="ud_category" value="#gs_qry.ud_category#" /></td>
           </tr>
            <tr>
           <td>Line No</td>
           <td><input type="text" name="ud_lineno" id="ud_lineno" value="#gs_qry.ud_lineno#" /></td>
           </tr>
             <tr>
           <td>Branch</td>
           <td><input type="text" name="ud_branch" id="ud_branch" value="#gs_qry.ud_branch#" /></td>
           </tr>
           <tr>
           <td>Department</td>
           <td><input type="text" name="ud_dept" id="ud_dept" value="#gs_qry.ud_dept#" /></td>
           </tr>
           <tr>
           <td>Project</td>
           <td><input type="text" name="ud_project" id="ud_project" value="#gs_qry.ud_project#" /></td>
           </tr>
           <tr>
           <td>Programme</td>
           <td><input type="text" name="ud_program2" id="ud_program2" value="#gs_qry.ud_program2#" /></td>
           </tr>
           <tr>
           <th colspan = "2">Default Working Days </th>
           </tr>
           <tr>
           <td>Monday</td>
            <td><select name="mon" id="mon">
                    <option value="1" #IIF(gs_qry2.mon eq 1,DE("selected"),DE(""))#>Working</option> 
                    <option value="0.5" #IIF(gs_qry2.mon eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                    <option value="0" #IIF(gs_qry2.mon eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Tuesday</td>
            <td><select name="tue" id="tue">
                    <option value="1" #IIF(gs_qry2.tue eq 1,DE("selected"),DE(""))#>Working</option> 
                    <option value="0.5" #IIF(gs_qry2.tue eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                    <option value="0" #IIF(gs_qry2.tue eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Wednesday</td>
            <td><select name="wed" id="wed">
                    <option value="1" #IIF(gs_qry2.wed eq 1,DE("selected"),DE(""))#>Working</option> 
                    <option value="0.5" #IIF(gs_qry2.wed eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                    <option value="0" #IIF(gs_qry2.wed eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Thursday</td>
            <td><select name="thu" id="thu">
                    <option value="1" #IIF(gs_qry2.thu eq 1,DE("selected"),DE(""))#>Working</option> 
    	            <option value="0.5" #IIF(gs_qry2.thu eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
	                <option value="0" #IIF(gs_qry2.thu eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Friday</td>
            <td><select name="fri" id="fri">
                   <option value="1" #IIF(gs_qry2.fri eq 1,DE("selected"),DE(""))#>Working</option> 
                   <option value="0.5" #IIF(gs_qry2.fri eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                   <option value="0" #IIF(gs_qry2.fri eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Saturday</td>
            <td><select name="sat" id="sat">
                    <option value="1" #IIF(gs_qry2.sat eq 1,DE("selected"),DE(""))#>Working</option> 
                    <option value="0.5" #IIF(gs_qry2.sat eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                    <option value="0" #IIF(gs_qry2.sat eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           <tr>
           <td>Sunday</td>
            <td><select name="sun" id="sun">
                    <option value="1" #IIF(gs_qry2.sun eq 1,DE("selected"),DE(""))#>Working</option> 
                    <option value="0.5" #IIF(gs_qry2.sun eq 0.5,DE("selected"),DE(""))#>Half Day</option> 
                    <option value="0" #IIF(gs_qry2.sun eq 0,DE("selected"),DE(""))#>Off Day</option>
                </select>
            </td>
           </tr>
           </table>
            </div>
		<!--- <div class="tabbertab" >
			<h3>Backup</h3>
		</div> --->
	</div>
	<br />
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="Save">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/body/bodymenu.cfm?id=214'">
		<!--- MT<input type="submit" value="#event.getArg('submitLabel', '')#" />--->
	</center>
	</cfform>
	<!-- need these if there's an error with the required fields so they'll be available in the next event -->
	<!--- MT<input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" />--->
	</cfoutput>

</body>
</html>
