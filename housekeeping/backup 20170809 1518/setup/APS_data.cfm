<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<script src="/javascripts/tabber.js" type="text/javascript"></script>
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
<title>APS Format Setup</title>
<script type="text/javascript">
	

function settext(val1)
{
var x = document.getElementById('valvalue').value;
var oritext = document.getElementById(x).value;
document.getElementById(x).value= oritext +'+' + val1 ;
	
}


	
</script>

<bank>

</head>
<cfif isdefined("url.id")>
<!--- <cfquery name="bank_data_qry" datasource="#dts#">
SELECT *  FROM aps_set a where entryno="#url.id#" ;
</cfquery> --->
<cfquery name="bank_data_qry" datasource="#dts#">
SELECT *  FROM aps_set a where entryno="#url.id#" ;
</cfquery>
</cfif>
<body>
	
	<cfoutput>
<form name="pform" action="act_aps.cfm" method="post">
	<input type="hidden" name="entryno" value="#bank_data_qry.entryno#" id="#url.id#"/>

<table width="1000">
	<td>APS Bank Name:</td>
	<td>
		<input type="text" name="apsbank" value="#bank_data_qry.APSBank#"/>
	</td>
	<td></td>
	<td>APS Note:</td>
	<td><input type="text" name="apsnote" value="#bank_data_qry.apsnote# " id="aps_note"/></td>
	<td align="left"><input type="button" name="default" value="Set As Default"></td>
</tr>

<tr>
	<td>APS File Name:</td>
	<td><input type="text" name="apsfile" value="#bank_data_qry.aps_file#" id="apsfile"/></td>
	<td></td>
	<td>APS File Size:</td>
	<td><input type="text" name="aps_size" value="#bank_data_qry.aps_size# " id="aps_size"/></td>
	<td></td>
</tr>
</table>
<br><br>
<div class="tabber">
	<div class="tabbertab" style="height:450px;">
			<h3>APS Format Setup</h3>
<table width="100%">
	<tr>
	<th width=""></th>
	<th width="">Variable</th>
	<th width="">Length</th>
	<th width="">Justified</th>
	</tr>
	<tr>
	<td width="">Originator Bank Code</td>
	
	<td width="">OR_Bank</td>
	<td width=""><input type="text" name="orbankl" value="#val(bank_data_qry.orbankl)#"/></td>
	<td width=""><select name="orbankj"><option value="" #IIF(bank_data_qry.orbankj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.orbankj eq "RJWS", DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.orbankj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.orbankj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.orbankj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Originator Branch Code</td>
	
	<td width="">OR_BRAN</td>
	<td width=""><input type="text" name="orbranl" value="#val(bank_data_qry.orbranl)#"/></td>
	<td width=""><select name="orbranj"><option value="" #IIF(bank_data_qry.orbranj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.orbranj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.orbranj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.orbranj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.orbranj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Originator Account No.</td>
	
	<td width="">OR_ACCNO</td>
	<td width=""><input type="text" name="oraccnol" value="#val(bank_data_qry.oraccnol)#"/></td>
	<td width=""><select name="oraccnoj"><option value="" #IIF(bank_data_qry.oraccnoj eq "",DE('selected'),DE(''))#> </option>
							<option value="RJWS" #IIF(bank_data_qry.oraccnoj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.oraccnoj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.oraccnoj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.oraccnoj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select>
	</td>
	</tr>
	<tr>
	<td width="">Originator Name</td>
	
	<td width="">OR_NAME</td>
	<td width=""><input type="text" name="ornamel" value="#val(bank_data_qry.ornamel)#"/></td>
	<td width="">LJWZ</td>
	</tr>
	<tr>
	<td width="">Originator ID</td>
	
	<td width="">OR_ID</td>
	<td width=""><input type="text" name="oridl" value="#val(bank_data_qry.oridl)#"/></td>
	<td width=""><select name="oridj"><option value="" #IIF(bank_data_qry.oridj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.oridj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.oridj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.oridj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.oridj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Batch Number</td>
	
	<td width="">BT_NUM</td>
	<td width=""><input type="text" name="btnuml" value="#val(bank_data_qry.btnuml)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	<tr>
	<td width="">Batch Code</td>
	
	<td width="">BT_CODE</td>
	<td width=""><input type="text" name="btcodel" value="#val(bank_data_qry.btcodel)#"/></td>
	<td width=""><select name="btcodej">
		<option value="" #IIF(bank_data_qry.btcodej eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.btcodej eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.btcodej eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.btcodej eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.btcodej eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Receiver Bank Code</td>
	
	<td width="">RC_BANK</td>
	<td width=""><input type="text" name="rcbankl" value="#val(bank_data_qry.rcbankl)#"/></td>
	<td width=""><select name="rcbankj"><option value="" #IIF(bank_data_qry.rcbankj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.rcbankj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.rcbankj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.rcbankj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.rcbankj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Receiver Branch Code</td>
	
	<td width="">RC_BRAN</td>
	<td width=""><input type="text" name="rcbranl" value="#val(bank_data_qry.rcbranl)#"/></td>
	<td width=""><select name="rcbranj"><option value="" #IIF(bank_data_qry.rcbranj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.rcbranj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.rcbranj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.rcbranj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.rcbranj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Receiver Account No.</td>
	
	<td width="">RC_ACCNO</td>
	<td width=""><input type="text" name="length" value="#val(bank_data_qry.rcaccnol)#"/></td>
	<td width=""><select name="rcaccnoj"><option value="" #IIF(bank_data_qry.rcaccnoj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.rcaccnoj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.rcaccnoj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.rcaccnoj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.rcaccnoj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Receiver Name</td>
	
	<td width="">RC_NAME</td>
	<td width=""><input type="text" name="rcnamel" value="#val(bank_data_qry.rcnamel)#"/></td>
	<td width="">LJWS</td>
	</tr>
	<tr>
	<td width="">Receiver NRIC</td>
	
	<td width="">RC_NRIC</td>
	<td width=""><input type="text" name="rcnricl" value="#val(bank_data_qry.rcnricl)#"/></td>
	<td width=""><select name="rcnricj"><option value="" #IIF(bank_data_qry.rcnricj eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.rcnricj eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.rcnricj eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.rcnricj eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.rcnricj eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Receiver Amount</td>
	
	<td width="">RC_AMT</td>
	<td width=""><input type="text" name="rcamtl" value="#val(bank_data_qry.rcamtl)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	<tr>
	<td width="">Receiver Item</td>
	
	<td width="">RC_ITEM</td>
	<td width=""><input type="text" name="rciteml" value="#val(bank_data_qry.rciteml)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	
	<tr>
	<td width="">Receiver Payment Mode</td>
	
	<td width="">RC_PAYMODE</td>
	<td width=""><input type="text" name="rcpaymodel" value="#val(bank_data_qry.rcpaymodel)#"/></td>
	<td width=""><select name="rcpaymodej"><option value="" #IIF(bank_data_qry.rcpaymodej eq "",DE('selected'),DE(''))#></option>
							<option value="RJWS" #IIF(bank_data_qry.rcpaymodej eq "RJWS",DE('selected'),DE(''))#>RJWS - Right Justified String</option>
							<option value="RJWZ" #IIF(bank_data_qry.rcpaymodej eq "RJWZ",DE('selected'),DE(''))#>RJWZ -Right Justified Zero</option>
							<option value="LJWS" #IIF(bank_data_qry.rcpaymodej eq "LJWS",DE('selected'),DE(''))#>LJWS - Left Justified String</option>
							<option value="LJWZ" #IIF(bank_data_qry.rcpaymodej eq "LJWZ",DE('selected'),DE(''))#>LJWZ - Left Justified Zero</option>
					</select></td>
	</tr>
	<tr>
	<td width="">Footer Amount</td>
	
	<td width="">FF_AMT</td>
	<td width=""><input type="text" name="ffamtl" value="#val(bank_data_qry.ffamtl)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	
	<tr>
	<td width="">Footer Item</td>
	
	<td width="">FF_ITEM</td>
	<td width=""><input type="text" name="ffiteml" value="#val(bank_data_qry.ffiteml)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	
	<tr>
	<td width="">Footer Hash Total</td>
	
	<td width="">FF_HASH</td>
	<td width=""><input type="text" name="ffhashl" value="#val(bank_data_qry.ffhashl)#"/></td>
	<td width="">RJWZ</td>
	</tr>
	</table>
	</div>
	<div class="tabbertab" style="height:450px;">
			<h3>Next</h3>
	<table>
		<tr><td>
			<table width="600">
				
				<tr><td width="10">Originator</td>
				<td></td>
				<td ><textarea name="orrec1" id="orrec1" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'orrec1'" >#bank_data_qry.orrec1#</textarea></td>
				</tr>
				<tr><td width="">Batch Header</td>
				<td></td>
				<td ><textarea name="BTREC1" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'BTREC1'">#bank_data_qry.BTREC1#</textarea></td>
				</tr>
				<tr><td width="">Receiving Record</td>
				<td></td>
				<td ><textarea name="RCREC1" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'RCREC1'">#bank_data_qry.RCREC1#</textarea></td>
				</tr>
				<tr><td width="">Receiving Record 2</td>
				<td></td>
				<td ><textarea name="RCREC2" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'RCREC2'">#bank_data_qry.RCREC2#</textarea></td>
				</tr>
				<tr><td width="">Receiving Record 3</td>
				<td></td>
				<td ><textarea name="RCREC3" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'RCREC3'">#bank_data_qry.RCREC3#</textarea></td>
				</tr>
				<tr><td width="">Footer</td>
				<td></td>
				<td ><textarea name="FFREC1" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'FFREC1'">#bank_data_qry.FFREC1#</textarea></td>
				</tr>
				<tr><td rowspan="3" width="125">Hash Value from RC Record to be accumulated to FF_HASH</td>
				<td></td>
				<td ><textarea name="RCHASH1" cols="70" rows="3" onfocus="document.getElementById('valvalue').value = 'RCHASH1'">#bank_data_qry.RCHASH1#</textarea></td>
				</tr>
				<tr>
				<td></td>
				<td ><input type="text" name="RCHASH2" value="#bank_data_qry.RCHASH2#" size="70" onfocus="document.getElementById('valvalue').value = 'RCHASH2'"/></td>
				</tr>
				<tr></td>
				<td></td>
				<td ><input type="text" name="RCHASH" value="#bank_data_qry.RCHASH#" size="70"/></td>
				</tr>
		
		</table></td>
		<td><table width="300">
		<tr><th>Variable - Description</th></tr>
		<input type="hidden" id="valvalue" name="valvalue">
		<tr><td colspan="2"><select size="10" id="VarFormula" name="VarFormula" onclick="settext(this.value)">
							
							<option value="OR_BANK">OR_BANK - Originator Bank Code</option>
							<option value="OR_BRAN">OR_BRAN - Originator Branch Code</option>
							<option value="OR_ACCNO">OR_ACCNO - Originator Account No.</option>
							<option value="OR_NAME">OR_NAME - Originator Name</option>
							<option value="OR_ID">OR_ID - Originator ID</option>
							<option value="OR2_ID">OR2_ID - Organization ID</option>
							<option value="OR_STATE">OR_STATE - Originator State Code</option>
							<option value="BT_NUM">BT_NUM - Batch Number</option>
							<option value="BT_CODE">BT_CODE - Batch Code</option>
							<option value="RC_BANK">RC_BANK - Receiver Bank Code</option>
							<option value="RC_BRAN">RC_BRAN - Receiver Branch Code</option>
							<option value="RC_ACCNO">RC_ACCNO - Receiver Account No.</option>
							<option value="RC_PAYMODE">RC_PAYMODE - Receiver Payment Mode</option>
							<option value="RC_NAME">RC_NAME - Receiver Name</option>
							<option value="RC_NRIC">RC_NRIC - Receiver NRIC</option>
							<option value="RC_AMT">RC_AMT - Receiver Amount</option>
							<option value="RC_ITEM">RC_ITEM - Receiver Item</option>
							<option value="FF_AMT">FF_AMT - Footer Amount</option>
							<option value="FF_ITEM">FF_ITEM - Footer Item</option>
							<option value="FF_HASH">FF_HASH - Footer Hash Total</option>
							<option value="EPF_BANK_CODE">EPF_BANK_CODE - EPF Bank Code</option>
							<option value="EPF_BANK_ACCNO">EPF_BANK_ACCNO - EPF Bank Account No.</option>
							<option value="RCFIG">RCFIG - Derived Detail Variable</option>
							<option value="RCFIG2">RCFIG2 - Derived Detail Variable</option>
							<option value="TTFIG">TTFIG - Derived Total Variable</option>
							<option value="TTFIG2">TTFIG2 - Derived Total Variable</option>
							<option value="TTITEM">TTITEM - Derived Total Variable</option>
							<option value="TTITEM2">TTITEM2 - Derived Total Variable</option>
							<option value="HIGH_AMT">HIGH_AMT - Highest Receiver Amount</option>
							<option value="DTOC(CRDATE)">DTOC(CRDATE) - On Credit Date</option>
							<option value="CMONTH(CRDATE)">CMONTH(CRDATE) - On Credit Date</option>
							<option value="DD_C">DD_C - On Credit Date</option>
							<option value="MM_C">MM_C - On Credit Date</option>
							<option value="YY_C">YY_C - On Credit Date</option>
							<option value="YYYY_C">YYYY_C - On Credit Date</option>
							<option value="DTOC(RPTDATE)">DTOC(RPTDATE) - On Report Date</option>
							<option value="CMONTH(RPTDATE)">CMONTH(RPTDATE) - On Report Date</option>
							<option value="DD_R">DD_R - On Report Date</option>
							<option value="MM_R">MM_R - On Report Date</option>
							<option value="YY_R">YY_R - On Report Date</option>
							<option value="YYYY_R">YYYY_R - On Report Date</option>
							<option value="DTOC(VALUEDATE)">DTOC(VALUEDATE) - Value Date</option>
							<option value="DTOC(GENDATE)">DTOC(GENDATE) - On Generate Date</option>
							<option value="CMONTH(GENDATE)">CMONTH(GENDATE) - On Generate Date</option>
							<option value="DD_G">DD_G - On Generate Date</option>
							<option value="MM_G">MM_G - On Generate Date</option>
							<option value="YY_G">YY_G - On Generate Date</option>
							<option value="YYYY_G">YYYY_G - On Generate Date</option>
							<option value="HH_G">HH_G - On Generate Date</option>
							<option value="NN_G">NN_G - On Generate Date</option>
							<option value="SS_G">SS_G - On Generate Date</option>
							<option value="HASH_I">HASH_I - Hash Indicator</option>
							</select>
			</td></tr>
			<tr><th>Functions - Description</th></tr>
			<tr><td colspan="2"><select size="10" id="Functions" name="Functions" onclick="settext(this.value)">
								<option value="ATQ(S)">ATQ(S) - "CCCC"</option>
								<option value="ONLY9(S)">ONLY9(S) - Only Digit</option>
								<option value="ONLY9A(S)">ONLY9A(S) - Only Digit & Alpha</option>
								<option value="LJWS(S,L)">LJWS(S,L)</option>
								<option value="LJWZ(S,L)">LJWZ(S,L)</option>
								<option value="RJWS(S,L)">RJWS(S,L)</option>
								<option value="RJWZ(S,L)">RJWZ(S,L)</option>
								<option value="NTOS(N,L)">NTOS(N,L) - 00001122</option>
								<option value="TRIM()">TRIM()</option>
								<option value="ALLTRIM()">ALLTRIM()</option>
								<option value="SUBSTR()">SUBSTR()</option>
								<option value="STRTRAN()">STRTRAN()</option>
								<option value="VAL()">VAL()</option>
								<option value="STR()">STR()</option>
								<option value="ABS()">ABS()</option>
								<option value="SPACE()">SPACE()</option>
								<option value="PADL()">PADL()</option>
								<option value="PADR()">PADR()</option>
								<option value="DAY()">DAY()</option>
								<option value="MONTH()">MONTH()</option>
								<option value="YEAR()">YEAR()</option>
								</select>
			</tr>
		</table></td>
		</tr>
	</table>
	</div>
	</div>
	<table>
	<tr>

	<td width=""><input type="submit" value="List" name="list" onclick="window.open('list.cfm','mywindow','width=500,height=600,scrollbars=yes')" /></td>
	<td width=""><input type="submit" value="ok" name="submit" /></td>
	<td width=""></td>
	<td width=""></td>
	</tr>
	</table>
	</form>
	</cfoutput>
	
	
	</body>
	</html>