<!---cfscript>
	ded_qry = event.getArg('deductionData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Deduction Table</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script language="javascript">
	function copyStr(obj){
		for(var i=1;i<2;i++){document.getElementById('t'+i+obj.name).value=obj.value;}
	}
	</script>
</head>

<body>
	<div class="mainTitle">Deduction Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="otForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="ded_qry" datasource="#dts#">
	SELECT * FROM dedtable
	</cfquery>
	<cfif HuserCcode eq "MY">
		<cfset cpf_ccode = "EPF">
		<cfset sdl_code = "SOC">
	<cfelse>
		<cfset cpf_ccode = "CPF">
		<cfset sdl_code = "SDL">
	</cfif>
	<form name="otForm" action="deductionTableMain_process.cfm" method="post">
	<div class="tabber">
		<div class="tabbertab">
			<h3>STEP 1</h3>
			
				<table class="form" border="0">
				<cfoutput>
				<tr>
					<th width="10px">No.</th>
					<th width="100px">Description</th>
					<th width="20px">OT</th>
					<th width="20px">#cpf_ccode#</th>
					<th width="20px">TAX</th>
					<th width="20px">#sdl_code#</th>
					<th width="20px">NPL</th>
					<th width="20px">PAY</th>
					<th width="20px">FORMULA</th>
					<th width="100px">File No.</th>
					<th rowspan="18">
						<fieldset style="border:1px ridge ##ff00ff; padding: 1.5em; margin:1em;">
						<legend>Notes</legend><br />
                        <cfif HuserCcode eq "MY">
                        15 --> PCB<br />
                        <cfelseif HuserCcode eq "SG">
						9  --> Mendaki<br />
						10 --> C.Chest<br />
						11 --> Mosque<br />
						12 --> Loan Return<br />
						13 --> SINDA<br />
						14 --> CDAC<br />
						15 --> Eurasion<br />
                        <cfelse>
                        
                        </cfif>
						</fieldset>
					</th>
				</tr>
			</cfoutput>
			<cfoutput query="ded_qry">
			<tr>
				<td>#ded_qry.ded_cou#</td>
				<td><input type="text" name="ded_desp__r#ded_qry.ded_cou#" value="#ded_qry.ded_desp#" onkeyup="copyStr(this)" size="15" maxlength="12" /></td>
				<td><input type="checkbox" name="ded_ot__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_ot eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ded_epf__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_epf eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ded_tax__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_tax eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ded_hrd__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_hrd eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ded_npl__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_npl eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="ded_pay__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.ded_pay eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="checkbox" name="DED_FOR_USE__r#ded_qry.ded_cou#" value="1" #IIF(ded_qry.DED_FOR_USE eq 0,DE(""),DE("checked"))# /></td>
				<td><input type="text" name="ded_mem__r#ded_qry.ded_cou#" value="#ded_qry.ded_mem#" size="15" maxlength="12" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
		<div class="tabbertab">
			<h3>STEP 2</h3>
			<table class="form" border="0">
			<tr>
				<th width="10px">No.</th>
				<th width="100px">Description</th>
				<th width="30px">Type</th>
				<th width="600px">Formula</th>
			</tr>
			<cfoutput query="ded_qry">
			<tr>
				<td>#ded_qry.ded_cou#</td>
				<td><input type="text" name="t1ded_desp__r#ded_qry.ded_cou#" value="#ded_qry.ded_desp#" size="15" readonly="yes" /></td>
				<td><input type="text" name="ded_type__r#ded_qry.ded_cou#" value="#ded_qry.ded_type#" size="3" maxlength="1" /></td>
				<td><input type="text" name="ded_for__r#ded_qry.ded_cou#" value="#ded_qry.ded_for#" size="100"  /></td>
			</tr>
			</cfoutput>
			<cfoutput>
			<tr>
				<td colspan="3">Field To Store DEDFIG1</td>
				<td><input type="text" name="ded_fig1__r1" value="#ded_qry.ded_fig1[1]#" size="100" maxlength="80" /></td>
			</tr>
			<tr>
				<td colspan="3">Field To Store DEDFIG2</td>
				<td><input type="text" name="ded_fig2__r1" value="#ded_qry.ded_fig1[1]#" size="100" maxlength="80" /></td>
			</tr>
			</cfoutput>
			</table>
		</div>
        
		<div class="tabbertab">
        	<cfoutput>
			<h3>Remarks</h3>
            <table class="form" border="0">
           	  <tr>
              	<th>No</th>
                <th>Remarks</th>
	          </tr>
                <cfloop query="ded_qry">
                <tr>
                	<td>#ded_qry.currentrow#</td>
                	<td><input id="rmk#ded_qry.currentrow#" name="rmk#ded_qry.currentrow#" value="#ded_qry.ded_rmk#" size="100" ></td>
	            </tr>
                </cfloop>
    
            </table>
			</cfoutput>            
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
