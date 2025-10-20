<!---cfscript>
	ot_qry = event.getArg('overtimeData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Overtime Table</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script language="javascript">
	function copyStr(obj){
		for(var i=2;i<7;i++){document.getElementById('t'+i+obj.name).value=obj.value;}
	}
	</script>
</head>

<body>
	<div class="mainTitle">Overtime Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="otForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="ot_qry" datasource="#dts#">
	SELECT * FROM ottable
	</cfquery>
	<cfif HuserCcode eq "MY">
		<cfset cpf_ccode = "EPF">
		<cfset sdl_code = "SOC">
	<cfelse>
		<cfset cpf_ccode = "CPF">
		<cfset sdl_code = "SDL">
	</cfif>
	<form name="otForm" action="overtimeTableMain_process.cfm" method="post">
	<div class="tabber">
		<div class="tabbertab">
			<h3>Table 1</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th width="12%">Constant</th>
				<th width="12%">Rate</th>
				<th width="4%">DEC</th>
				<cfoutput>
				<th width="4%">#cpf_ccode#</th>
				<th width="4%">TAX</th>
				<th>#sdl_code#</th>
				</cfoutput>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" name="ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" onkeyup="copyStr(this)" size="10" maxlength="9" /></td>
				<td><select name="ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select>
				</td>
				<td><input type="text" name="ot_ratio__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const__r#ot_qry.ot_cou#" value="#ot_qry.ot_const#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_mrate__r#ot_qry.ot_cou#" value="#ot_qry.ot_mrate#" size="15" maxlength="9" /></td>
				<td><select name="ot_rtdec__r#ot_qry.ot_cou#">
					<cfloop from="2" to="4" index="i">
						<option value= "#i#" #IIF(ot_qry.ot_rtdec eq i,DE("selected"),DE(""))#>#i#</option>
					</cfloop>
					</select>
				
				</td>
				<td><input type="checkbox" name="ot_epf__r#ot_qry.ot_cou#" value="1" #IIF(ot_qry.ot_epf eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ot_tax__r#ot_qry.ot_cou#" value="1" #IIF(ot_qry.ot_tax eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ot_hrd__r#ot_qry.ot_cou#" value="1" #IIF(ot_qry.ot_hrd eq 0,DE(""),DE("checked"))# /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Table 2</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th>Constant</th>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" id="t2ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
				<td><select id="t2ot_unit__r#ot_qry.ot_cou#" name="t2ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select></td>
				<td><input type="text" name="ot_ratio2__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio2#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const2__r#ot_qry.ot_cou#" value="#ot_qry.ot_const2#" size="15" maxlength="9" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Table 3</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th>Constant</th>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" id="t3ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
				<td><select id="t3ot_unit__r#ot_qry.ot_cou#" name="t3ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select></td>
				<td><input type="text" name="ot_ratio3__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio3#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const3__r#ot_qry.ot_cou#" value="#ot_qry.ot_const3#" size="15" maxlength="9" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Table 4</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th>Constant</th>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" id="t4ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
				<td><select id="t4ot_unit__r#ot_qry.ot_cou#" name="t4ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select></td>
				<td><input type="text" name="ot_ratio4__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio4#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const4__r#ot_qry.ot_cou#" value="#ot_qry.ot_const4#" size="15" maxlength="9" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Table 5</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th>Constant</th>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" id="t5ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
				<td><select id="t5ot_unit__r#ot_qry.ot_cou#" name="t5ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select></td>
				<td><input type="text" name="ot_ratio5__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio5#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const5__r#ot_qry.ot_cou#" value="#ot_qry.ot_const5#" size="15" maxlength="9" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Table 6</h3>
			<table class="form" border="0">
			<tr>
				<th width="2%">No.</th>
				<th width="8%">Description</th>
				<th width="5%">Unit</th>
				<th width="12%">Ratio</th>
				<th>Constant</th>
			</tr>
			<cfoutput query="ot_qry">
			<tr>
				<td>#ot_qry.ot_cou#</td>
				<td><input type="text" id="t6ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
				<td><select id="t6ot_unit__r#ot_qry.ot_cou#" name="t6ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
					<option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
					<option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
					</select></td>
				<td><input type="text" name="ot_ratio6__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio6#" size="15" maxlength="9" /></td>
				<td><input type="text" name="ot_const6__r#ot_qry.ot_cou#" value="#ot_qry.ot_const6#" size="15" maxlength="9" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
    <div class="tabbertab">
                <h3>Table 7</h3>
                <table class="form" border="0">
                <tr>
                    <th width="2%">No.</th>
                    <th width="8%">Description</th>
                    <th width="5%">Unit</th>
                    <th width="12%">Ratio</th>
                    <th>Constant</th>
                </tr>
                <cfoutput query="ot_qry">
                <tr>
                    <td>#ot_qry.ot_cou#</td>
                    <td><input type="text" id="t7ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
                    <td><select id="t7ot_unit__r#ot_qry.ot_cou#" name="t7ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
                        <option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
                        <option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
                        </select></td>
                    <td><input type="text" name="ot_ratio7__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio7#" size="15" maxlength="9" /></td>
                    <td><input type="text" name="ot_const7__r#ot_qry.ot_cou#" value="#ot_qry.ot_const7#" size="15" maxlength="9" /></td>
                </tr>
                </cfoutput>
                </table>
            </div>
    <div class="tabbertab">
                <h3>Table 8</h3>
                <table class="form" border="0">
                <tr>
                    <th width="2%">No.</th>
                    <th width="8%">Description</th>
                    <th width="5%">Unit</th>
                    <th width="12%">Ratio</th>
                    <th>Constant</th>
                </tr>
                <cfoutput query="ot_qry">
                <tr>
                    <td>#ot_qry.ot_cou#</td>
                    <td><input type="text" id="t8ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
                    <td><select id="t8ot_unit__r#ot_qry.ot_cou#" name="t8ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
                        <option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
                        <option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
                        </select></td>
                    <td><input type="text" name="ot_ratio8__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio8#" size="15" maxlength="9" /></td>
                    <td><input type="text" name="ot_const8__r#ot_qry.ot_cou#" value="#ot_qry.ot_const8#" size="15" maxlength="9" /></td>
                </tr>
                </cfoutput>
                </table>
            </div>
    <div class="tabbertab">
                <h3>Table 9</h3>
                <table class="form" border="0">
                <tr>
                    <th width="2%">No.</th>
                    <th width="8%">Description</th>
                    <th width="5%">Unit</th>
                    <th width="12%">Ratio</th>
                    <th>Constant</th>
                </tr>
                <cfoutput query="ot_qry">
                <tr>
                    <td>#ot_qry.ot_cou#</td>
                    <td><input type="text" id="t9ot_desp__r#ot_qry.ot_cou#" value="#ot_qry.ot_desp#" size="10" readonly="yes" /></td>
                    <td><select id="t9ot_unit__r#ot_qry.ot_cou#" name="t9ot_unit__r#ot_qry.ot_cou#" onchange="copyStr(this)">
                        <option value="HRS" #IIF(ot_qry.ot_unit eq "HRS",DE("selected"),DE(""))#>HRS</option>
                        <option value="DAYS" #IIF(ot_qry.ot_unit eq "DAYS",DE("selected"),DE(""))#>DAYS</option>
                        </select></td>
                    <td><input type="text" name="ot_ratio9__r#ot_qry.ot_cou#" value="#ot_qry.ot_ratio9#" size="15" maxlength="9" /></td>
                    <td><input type="text" name="ot_const9__r#ot_qry.ot_cou#" value="#ot_qry.ot_const9#" size="15" maxlength="9" /></td>
                </tr>
                </cfoutput>
                </table>
            </div>
	</div>
	<br />
	<cfoutput>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
		<!---input type="submit" value="#event.getArg('submitLabel', '')#" /--->
	</center>
	
	<!-- need these if there's an error with the required fields so they'll be available in the next event -->
	<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
	</cfoutput>
	</form>
</body>
</html>
