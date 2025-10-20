<!---cfscript>
	at_qry = event.getArg('allowanceData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Allowance Table</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script language="javascript">
	function copyStr(obj){
		for(var i=1;i<3;i++){document.getElementById('t'+i+obj.name).value=obj.value;}
	}
	function text2Cbx(obj){
		var numStr=obj.value;
		for(var i=1;i<14;i++){document.getElementById(obj.name+'c'+i).checked = false;}
		for(var i=1;i<14;i++){if(numStr.substring(i-1,i)=='1'){document.getElementById(obj.name+'c'+i).checked = true;}}
	}
	function cbx2Text(obj){
		var text='';
		var textObjNm=obj.name.substring(0,obj.name.indexOf("c"));
		for(var i=1;i<14;i++){
			if(document.getElementById(textObjNm+'c'+i).checked) text=text+'1';
			else text=text+'0';
		}
		document.getElementById(textObjNm).value=text;
	}
	</script>
</head>

<body>
	<div class="mainTitle">Allowance Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="otForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="at_qry" datasource="#dts#">
	SELECT * FROM awtable
	</cfquery>
	<cfif HuserCcode eq "MY">
		<cfset cpf_ccode = "EPF">
		<cfset sdl_code = "SOC">
	<cfelse>
		<cfset cpf_ccode = "CPF">
		<cfset sdl_code = "SDL">
	</cfif>
	<form name="otForm" action="allowanceTableMain_process.cfm" method="post">
	<div class="tabber">
		<div class="tabbertab">
			<h3>STEP 1</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="4%">OT1</th>
				<th width="4%">OT2</th>
				<th width="4%">OT3</th>
				<th width="4%">OT4</th>
				<th width="4%">OT5</th>
				<th width="4%">OT6</th>
				<cfoutput>
				<th width="4%">#cpf_ccode#</th>
				<th width="4%">TAX</th>
				<th width="4%">#sdl_code#</th></cfoutput>
				<th width="4%">NPL</th>
				<th width="4%">Late</th>
				<th width="4%">Bonus</th>
				<th width="4%">PAY</th>
                <th>ADDW</th>
			</tr>
			<cfoutput query="at_qry">
			<tr <cfif at_qry.aw_cou gt 17> style="display:none"</cfif>>
				<td>#at_qry.aw_cou#</td>
				<td><input type="text" name="aw_desp__r#at_qry.aw_cou#" value="#at_qry.aw_desp#" onkeyup="copyStr(this)" size="15" maxlength="12" /></td>
				<td><input type="checkbox" name="aw_ot1__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot1 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_ot2__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot2 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_ot3__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot3 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_ot4__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot4 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_ot5__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot5 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_ot6__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_ot6 eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_epf__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_epf eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_tax__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_tax eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_hrd__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_hrd eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_npl__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_npl eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_late__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_late eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_bonus__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_bonus eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_pay__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_pay eq 0,DE(""),DE("checked"))# /></td>
                <td><input type="checkbox" name="aw_addw__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_addw eq 0,DE(""),DE("checked"))# /></td>
				<!--- <td><input type="checkbox" name="aw_note__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_note eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_dbase eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_type__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_type eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_for__r#at_qry.aw_cou#" value="1" #IIF(at_qry.aw_for eq 0,DE(""),DE("checked"))# /></td> --->
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>STEP 2</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="4%">Note</th>
				<th width="4%">Day Based</th>
				<th width="4%">DW</th>
				<th width="4%">PH</th>
				<th width="4%">AL</th>
				<th width="4%">MC</th>
				<th width="4%">MT</th>
				<th width="4%">MR</th>
				<th width="4%">CL</th>
				<th width="4%">HL</th>
				<th width="4%">OPL</th>
				<th width="4%">ADJ</th>
				<th width="4%">EX</th>
				<th width="4%">PT</th>
				<th>AD</th>
			</tr>
			<cfoutput query="at_qry">
			<tr <cfif at_qry.aw_cou gt 17> style="display:none"</cfif>>
				<td>#at_qry.aw_cou#</td>
				<td><input type="text" name="t1aw_desp__r#at_qry.aw_cou#" id="t1aw_desp__r#at_qry.aw_cou#" value="#at_qry.aw_desp#" size="15" readonly="yes" /></td>
				<td><select name="aw_note__r#at_qry.aw_cou#">
					<option value=""></option>
					<option value="TRANS" #IIF(at_qry.aw_note eq "TRANS",DE("selected"),DE(""))#>TRANS|Transport</option>
					<option value="ENTNM" #IIF(at_qry.aw_note eq "ENTNM",DE("selected"),DE(""))#>ENTNM|Entertainment</option>
					<option value="COMM" #IIF(at_qry.aw_note eq "COMM",DE("selected"),DE(""))#>COMM|Commision</option>
					<option value="GROSS" #IIF(at_qry.aw_note eq "GROSS",DE("selected"),DE(""))#>GROSS|Gross Pay</option>
                    <option value="BONUS" #IIF(at_qry.aw_note eq "BONUS",DE("selected"),DE(""))#>BONUS|Bonus Pay</option>
					</select>
				</td>
				<td><input type="text" name="aw_dbase__r#at_qry.aw_cou#" id="aw_dbase__r#at_qry.aw_cou#" value="#at_qry.aw_dbase#" onkeyup="text2Cbx(this)" size="15" maxlength="13" /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c1" id="aw_dbase__r#at_qry.aw_cou#c1" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,1,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c2" id="aw_dbase__r#at_qry.aw_cou#c2" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,2,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c3" id="aw_dbase__r#at_qry.aw_cou#c3" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,3,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c4" id="aw_dbase__r#at_qry.aw_cou#c4"  value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,4,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c5" id="aw_dbase__r#at_qry.aw_cou#c5" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,5,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c6" id="aw_dbase__r#at_qry.aw_cou#c6" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,6,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c7" id="aw_dbase__r#at_qry.aw_cou#c7" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,7,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c8" id="aw_dbase__r#at_qry.aw_cou#c8" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,8,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c9" id="aw_dbase__r#at_qry.aw_cou#c9" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,9,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c10" id="aw_dbase__r#at_qry.aw_cou#c10" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,10,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c11" id="aw_dbase__r#at_qry.aw_cou#c11" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,11,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c12" id="aw_dbase__r#at_qry.aw_cou#c12" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,12,1) eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="aw_dbase__r#at_qry.aw_cou#c13" id="aw_dbase__r#at_qry.aw_cou#c13" value="1" onclick="cbx2Text(this)" #IIF(Mid(at_qry.aw_dbase,13,1) eq 0,DE(""),DE("checked"))# /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>STEP 3</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="4%">Type</th>
				<th width="60%">Formula for type F and V</th>
				<th rowspan="18">
					<fieldset style="border:1px ridge ##ff00ff; padding: 1.5em; margin:1em;">
					<legend>Variable</legend><br />
					WDAY<br />
					DW<br />
					PH<br />
					AL<br />
					MC<br />
					MT<br />
					MR<br />
					CL<br />
					HL<br />
					OPL<br />
					ADJ<br />
					LS<br />
					NPL<br />
					AB<br />
					ONPL<br />
					TIPPOINT<br />
					TIPRATE<br />
					NDOM<br />
					LATEHR<br />
					</fieldset>
				</th>
			</tr>
			<cfoutput query="at_qry">
			<tr <cfif at_qry.aw_cou gt 17> style="display:none"</cfif>>
				<td>#at_qry.aw_cou#</td>
				<td><input type="text" name="t2aw_desp__r#at_qry.aw_cou#" value="#at_qry.aw_desp#" size="15" readonly="yes" /></td>
				<td><input type="text" name="aw_type__r#at_qry.aw_cou#" value="#at_qry.aw_type#" size="3" maxlength="1" /></td>
				<td><input type="text" name="aw_for__r#at_qry.aw_cou#" value="#at_qry.aw_for#" size="100" maxlength="100" /></td>
			</tr>
			</cfoutput>
			<tr>
				<td colspan="3">Reverse Attendance (RATTN)</td>
				<td><input type="text" name="aw_rattn__r1" value="<cfoutput>#at_qry.aw_rattn#</cfoutput>" size="100" maxlength="50" /></td>
				<td></td>
			</tr>
			</table>
		</div>
	</div>
	<br />
	<cfoutput>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/body/bodymenu.cfm?id=218'">
		<!---input type="submit" value="#event.getArg('submitLabel', '')#" /--->
	</center>
	
	<!-- need these if there's an error with the required fields so they'll be available in the next event -->
	<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
	</cfoutput>
	</form>
</body>
</html>
