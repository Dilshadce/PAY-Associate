<!---cfscript>
	address = event.getArg('addressData');
	aps_qry = event.getArg('aps'); 
</cfscript---->

<html>
<head>
	<title>Addresses & Account No.</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<script src="/javascripts/resizeSel.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	
	<script type="text/javascript">
		
		function apsfilename()
		{
		var listobj = document.getElementById('aps_num');
		document.getElementById('aps_file').value  = listobj.options[listobj.selectedIndex].id;
		}
		
		
 		function checkform(){
 		var com_accno= document.getElementById('com_accno').value;
 		var illegalChars = /[\W_]/;
 		if (illegalChars.test(com_accno))
 		{
        alert("The account number should not included symbol.");
		return false;
		}
 		}
	</script>
	
	
	
</head>
<body>
<cfoutput>
	<div class="mainTitle">Addresses & Account No.</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfoutput>
	<cfform name="eForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="address" datasource="#dts#">
		SELECT * FROM address  WHERE org_type="#org_type#" AND category="#category#"
	</cfquery>
	<cfform name="eForm" action="addressForm_process.cfm?org_type=#address.org_type#&category=#address.category#&refno=#address.refno#" method="post" >
	<table class="form">
	<tr>
		<td width="150px">Organisation Type</td>
		<td width="200px"><input type="text" name="org_type" value="#address.org_type#" size="6" readonly /></td>
		<td width="100px">Category</td>
		<td><input type="text" name="category" value="#address.category#" size="2" readonly /></td>
	</tr>
	</table>
    <cfset cpf = "CPF">
    <cfif HUserCcode eq "MY">
        <cfset cpf = "EPF">
    </cfif>
	<div class="tabber">
		<div class="tabbertab">
			<h3>Organisation</h3>
			<table class="form" border="0">
			<!--- <tr>
				<th width="25%">Organisation Type</th>
				<td width="40%"><input type="text" name="org_type" value="#address.org_type#" size="6" readonly="yes" /></td>
				<th width="25%">Category</th>
				<td><input type="text" name="category" value="#address.category#" size="2" readonly="yes" /></td>
			</tr> --->
			<tr>
				<td>Name</td>
				<td colspan="3"><input type="text" name="org_name" value="#address.org_name#" size="40" maxlength="40" /></td>
			</tr>
			<tr>
				<td>Code</td>
				<td colspan="3"><input type="text" name="org_code" id="org_code" value="#address.org_code#" size="12" maxlength="12" /></td>
			</tr>
			<tr>
				<td>Branch Name</td>
				<td colspan="3"><input type="text" name="bran_name" value="#address.bran_name#" size="50" maxlength="50" /></td>
			</tr>
			<tr>
				<td>Branch Code</td>
				<td colspan="3"><input type="text" name="bran_code" value="#address.bran_code#" size="6" maxlength="6" /></td>
			</tr>
			<tr>
				<td>Address</td>
				<td colspan="3"><input type="text" name="addr1" value="#address.addr1#" size="40" maxlength="40" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="addr2" value="#address.addr2#" size="40" maxlength="40" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="addr3" value="#address.addr3#" size="40" maxlength="40" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="addr4" value="#address.addr4#" size="40" maxlength="40" /></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3"><input type="text" name="addr5" value="#address.addr5#" size="40" maxlength="40" /></td>
			</tr>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Your Company Registered Information</h3>
			<table class="form" border="0">
			<tr>
				<td width="25%">Registered Name</td>
				<td colspan="4"><input type="text" name="com_name_f" value="#address.com_name_f#" size="45" maxlength="45" /></td>
			</tr>
			<cfswitch expression="#address.org_type#">
				<cfcase value="BANK">
				<tr>
					<td>Account No.</td>
					<td width="15%"><cfinput type="text" id="com_accno" name="com_accno" value="#address.com_accno#" size="20" maxlength="11" required="No" validateat="onSubmit" validate="integer" message="Account number should not more than 11 digit and must be integer." /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td  colspan="5">&nbsp;</td>
				</tr>
				<tr>
					<td  colspan="5">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3"></td>
					<td width="15%">State Code</td>
					<td><input type="text" name="com_stcode" value="#address.com_stcode#" size="2" maxlength="2" /></td>
				</tr>
				</cfcase>
				<cfcase value="EPF,CPF">
				<tr>
					<td>File No.</td>
					<td width="15%"><input type="text" name="com_fileno" value="#address.com_fileno#" size="20" maxlength="20" /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td  colspan="5">&nbsp;</td>
				</tr>
				<tr>
					<td>#CPF# Bank Code</td>
					<td width="15%"><input type="text" name="epf_bcode" value="#address.epf_bcode#" size="12" maxlength="12" /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td>#CPF# Bank Account No.</td>
					<td colspan="2"><input type="text" name="epf_baccno" value="#address.epf_baccno#" size="20" maxlength="20" /></td>
					<td width="15%">State Code</td>
                    <td>
                    <cfif HUserCcode eq "SG">
    					<input type="text" name="com_stcode" value="#address.com_stcode#" size="2" maxlength="2" />
                    <cfelseif HUserCcode eq "MY">
                        <select id="com_stcode" name="com_stcode">
                            <option value="01">01 - Johor</option>
                            <option value="02">02 - Kedah</option>
                            <option value="03">03 - Kelantan</option>
                            <option value="04">04 - Melaka</option>
                            <option value="05">05 - N.Sembilan</option>
                            <option value="06">06 - Pahang</option>
                            <option value="07">07 - P.Pinang</option>
                            <option value="08">08 - Perak</option>
                            <option value="09">09 - Perlis</option>
                            <option value="10">10 - Selangor</option>
                            <option value="11">11 - Terengganu</option>
                            <option value="12">12 - Sabah</option>
                            <option value="13">13 - Sarawak</option>
                            <option value="14">14 - W.Persekutuan</option>
                            <option value="15">15 - W.P Labuan</option>
                            <option value="16">16 - W.P Putrajaya</option>
                        </select>
                    </cfif>    
                    </td>
				</tr>
				</cfcase>
				<cfcase value="TAX">
				<tr>
					<td>Employee File No.</td>
					<td width="15%"><input type="text" name="com_fileno" value="#address.com_fileno#" size="20" maxlength="20" /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td>Income Tax File No.</td>
					<td width="15%"><input type="text" name="com_accno" value="#address.com_accno#" size="20" maxlength="20" /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td>Bank Code</td>
					<td width="15%"><input type="text" name="epf_bcode" value="#address.epf_bcode#" size="12" maxlength="12" /></td>
					<td  colspan="3"></td>
				</tr>
				<tr>
					<td>Bank Account No.</td>
					<td colspan="2"><input type="text" name="epf_baccno" value="#address.epf_baccno#" size="20" maxlength="20" /></td>
					<th width="15%">State Code</th>
					<td><input type="text" name="com_stcode" value="#address.com_stcode#" size="2" maxlength="2" /></td>
				</tr>
				</cfcase>
			</cfswitch>
			<tr>
				<th class="subheader" colspan="5">APS - Auto Pay System</th>
			</tr>
			<tr>
				<td>Short Name (APS)</td>
				<td width="30%" colspan="2"><input type="text" name="com_name" value="#address.com_name#" size="45" maxlength="45" /></td>
				<td width=""></td>
			</tr>
			<tr>
				<td>Given ID (APS)</td>
				<td colspan="4"><input type="text" name="com_id" value="#address.com_id#" size="20" maxlength="20" /></td>
			</tr>
			<tr>
				<td>Organization ID (APS)</td>
				<td colspan="4"><input type="text" name="com2_id" value="#address.com2_id#" size="20" maxlength="20" /></td>
			</tr>
			<tr>
				<td>Encryption Program Folder</td>
				<td colspan="4"><input type="text" name="encryptdir" value="#address.encryptdir#" size="40" maxlength="50" /></td>
			</tr>
			<cfquery name="aps_qry" datasource="#dts#">
				SELECT entryno,apsbank,APS_FILE FROM aps_set
			</cfquery>
			<tr>
				<td colspan="2">APS Format No. In Aps_Set.DBF</tdh>
				<td colspan="3"><select name="aps_num" onChange="apsfilename()">
								<option value="0">----  Please Select  ----</option>
								<cfloop query="aps_qry"><option id="#aps_qry.APS_FILE#" value="#aps_qry.entryno#" #IIF(address.aps_num eq aps_qry.entryno,DE('selected'),DE(''))#>#aps_qry.entryno#. #aps_qry.apsbank#</option></cfloop>
								</select></td>
			</tr>
			<tr>
				<td colspan="2">File Name For disk/Internet Transfer</td>
				<td colspan="3"><input type="text" name="aps_file" id="aps_file" value="#address.aps_file#" size="25" maxlength="25" /></td>
			</tr>
			<tr>
				<td colspan="2">Field To Store RCFIG</td>
				<td colspan="3"><input type="text" name="rc_figf" value="#address.rc_figf#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<td colspan="2">Field To Store RCFIG2</td>
				<td colspan="3"><input type="text" name="rc_fig2f" value="#address.rc_fig2f#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<td colspan="2">Field To Store RCFIG3</td>
				<td colspan="3"><input type="text" name="rc_fig3f" value="#address.rc_fig3f#" size="50" maxlength="50" /></td>
			</tr>
			<tr>
				<td colspan="2">Field To Store RCFIG4</td>
				<td colspan="3"><input type="text" name="rc_fig4f" value="#address.rc_fig4f#" size="50" maxlength="50" /></td>
			</tr>
			</table>
		</div>
		<div class="tabbertab">
			<h3>Officer In Charge</h3>
			<table class="form" border="0">
			<tr>
				<td width="25%">Name</td>
				<td><input type="text" name="pm_name" value="#address.pm_name#" size="40" maxlength="45" /></td>
			</tr>
			<tr>
				<td>Nric</td>
				<td><input type="text" name="pm_nric" value="#address.pm_nric#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<td>Position</td>
				<td><input type="text" name="pm_post" value="#address.pm_post#" size="15" maxlength="20" /></td>
			</tr>
			<tr>
				<td>Tel.</td>
				<td><input type="text" name="pm_tel" value="#address.pm_tel#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<td>Fax</td>
				<td><input type="text" name="pm_fax" value="#address.pm_fax#" size="15" maxlength="15" /></td>
			</tr>
			<tr>
				<td>E-mail</td>
				<td><input type="text" name="pm_email" value="#address.pm_email#" size="40" maxlength="50" /></td>
			</tr>
			</table>
		</div>
	</div>
	<br />
	<center>
		<!--- <input type="button" name="back" value="List" onClick="history.back()" /> --->
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="submit" name="update" value="Update Address" onclick="return checkform()" >
		<input type="button" name="exit" value="Exit" onClick="window.location='/housekeeping/setup/addressMain.cfm'">
		<!---input type="submit" name="save" value="#event.getArg('submitLabel')#" /--->
	</center>
	
		<input type="hidden" name="refno" value="#address.refno#" />
		<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
		<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
</cfform>
</cfoutput>	
</body>
</html>