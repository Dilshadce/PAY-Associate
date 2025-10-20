<html>
<head>
	<title>CPF 91 Payment Advice</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    <script src="../../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
    <script type="text/javascript">
	function generatecpf()
	{
	document.pForm.action = "generateCPFfile.cfm";
	}
	
	function generateDisk()
	{
	var selectedval = document.getElementById('UEN').value;
	if (selectedval == "")
	{
	window.alert('Please insert UEN number!');
	}
	else
	{
		if (document.getElementById('cpffile').value == "CPF")
		{
		document.pForm.action = "generateDisk.cfm";
		}
		else
		{
		document.pForm.action = "generateDiskCrimson.cfm";
		}
		document.pForm.target ="_BLANK";
		document.pForm.submit();
	}
	}
	
	function generateHTML()
	{
	var selectedval = document.getElementById('UEN').value;
	if (selectedval == "")
	{
	window.alert('Please insert UEN number!');
	}
	else
	{
		if (document.getElementById('cpffile').value == "CPF")
		{
		document.pForm.action = "generateHTML.cfm";
		}
		else
		{
		document.pForm.action = "generateHTMLCrimson.cfm";
		}
		document.pForm.target ="_BLANK";
		document.pForm.submit();
	}
	}
	
	function generateDiskCrimson()
	{
	var selectedval = document.getElementById('UEN').value;
	if (selectedval == "")
	{
	window.alert('Please insert UEN number!');
	}
	else
	{
		document.pForm.action = "generateDiskCrimson.cfm";
		document.pForm.target ="_BLANK";
		document.pForm.submit();
	}
	}
	function process()
	{
	document.pForm.action = "cpf91pa_process.cfm";
	document.pForm.target ="_BLANK";
	document.pForm.submit();
	}
	</script>
    <link href="../../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type in ('CPF')
</cfquery>

<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset days = daysinmonth(date)>
<cfset lastdate = createdate(yrs,mon,days)>
<cfset comp_ROC = company_details.comp_roc>
<body>
<cfoutput>
<div class="mainTitle">CPF91 Payment Advice</div>
<form name="pForm" id="pForm" action="" method="post">
<table class="form" border="0">
	<tr>
		<th colspan="6">CPF Contribution For All Employees Of The Category</th>
	</tr>
	<tr>
		<td colspan="5">B/F CPF Late Payment Interest</td>
		<td><input type="text" name="BFCPFinterest" value="#numberformat(0,'.__')#"></td>
	</tr>
	<tr>
		<td colspan="5">Interest Charged On Last Payment</td>
		<td><input type="text" name="interestCOLP" value="#numberformat(0,'.__')#"></td>
	</tr>
	<tr>
		<td colspan="5">Late Payment Penalty For Foreign Worker Levy</td>
		<td><input type="text" name="LPPFFWL" value="#numberformat(0,'.__')#"></td>
	</tr>
	<tr>
		<td>CPF Category</td>
		<td>
		<select name="cat" onChange="document.getElementById('sno').value=this.value;">
		<cfloop query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category# - #cpf_qry.com_fileno#</option>
		</cfloop>
		</select>
		</td>
	</tr>
	<tr>
		<td colspan="2">Bank</td>
		<td colspan="2"><input type="text" name="bank" value="" size="10"></td>
	</tr>
	<tr>
		<td colspan="2">Cheque No.</td>
		<td colspan="2"><input type="text" name="chequeno" value="" size="10"></td>
	</tr>
	<tr>
		<td colspan="2">Date</td>
		<td colspan="2"><input type="text" name="date" value="#dateformat(lastdate,'dd/mm/yyyy')#" size="10"></td>
	</tr>
	<tr>
		<th colspan="6">Send Data To Disk</th>
	</tr>
    <tr>
    <td colspan="2">
    CPF FILE TYPE
    </td>
    <td>
    <select name="cpffile" id="cpffile">
    <option value="CPF">CPF BOARD</option>
    <option <cfif HcomID eq "jcity">selected</cfif> value="CRIMSON">CRIMSON</option>
    </select>
    </td>
    </tr>
    <tr>
		<td colspan="2">UEN Number</td>
		<td colspan="4"><span id="sprytextfield1">
        <input type="text" id="UEN" name="UEN" value="#company_details.UEN#" size="30">
        <span class="textfieldRequiredMsg">UEN is required.</span><span class="textfieldMinCharsMsg">Minimum number of characters not met.</span><span class="textfieldMaxCharsMsg">Exceeded maximum number of characters.</span></span></td>
	</tr>
    <tr>
		<td colspan="2">Payment Type</td>
<td colspan="4"><select name="payType" >
		  <option value="PTE">PTE</option>
		  <option value="VCT">AMS</option>
		  <option value="VCT">VCT</option>
		  <option value="VSE">VSE</option>
		  <option value="MSE">MSE</option>
        
        </select></td>
	</tr>
    <tr>
		<td colspan="2">Serial Number(Sno)</td>
		<td colspan="4"><input type="text" name="sno" id="sno" value="1" size="30"></td>
	</tr>
    <tr>
		<td colspan="2">Payment Advice</td>
		<td colspan="4"><input type="text" name="payadvice" id="payadvice" value="01" size="30"></td>
	</tr>
	<tr>
		<td colspan="2">Submission Mode</td>
		<td colspan="2"><input type="text" name="s_mode" value="F" size="3"></td>
		<td colspan="2">'F' For Internet Online File Transfer</td>
	</tr>
	<tr>
		<td colspan="2">Submission Date</td>
		<td colspan="2"><input type="text" name="s_date" value="#dateformat(NOW(),'dd/mm/yyyy')#" size="10"></td>
	</tr>
	<tr>
		<td colspan="2">Submission Time &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HH</td>
		<cfset hnow=#timeformat(now(),'HH')#>
		<td colspan="2"><input type="text" name="s_time_HH" value="#hnow#" size="10"></td>
		<cfset mnow=#timeformat(now(),'mm')#>
		<td>MM<input type="text" name="s_time_MM" value="#mnow#" size="10"></td>
		<cfset snow=#timeformat(now(),'ss')#>
		<td>SS<input type="text" name="s_time_SS" value="#snow#" size="10"></td>
	</tr>
	<tr>
		<td colspan="2">CPF For The Month</td>
		<td colspan="2"><input type="text" name="CPF_M" value="#dateformat(lastdate,'dd/mm/yyyy')#" size="10"></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="FWL" <cfif dts eq "epoint_p" or dts eq "aecoz_p" or dts eq "supervalu_p" or dts eq "agape_p"><cfelse> checked=""</cfif> value="FWL"></td>
		<th>With FWL</th>
		<td><input type="checkbox" name="SINDA" checked="" value="SINDA"></td>
		<th>With SINDA</th>
	</tr>
	<tr>
		<td><input type="checkbox" name="SDL" checked="" value="SDL"></td>
		<th>With SDL</th>
		<td><input type="checkbox" name="CDAC" checked="" value="CDAC"></td>
		<th>With CDAC</th>
	</tr>
	<tr>
		<td><input type="checkbox" name="CChest" checked="" value="CChest"></td>
		<th>With C.Chest</th>
		<td><input type="checkbox" name="ECF" checked="" value="ECF"></td>
		<th>With ECF</th>
	</tr>
	<tr>
		<td><input type="checkbox" name="MBMF" checked="" value="MBMF"></td>
		<th>With MBMF</th>
	</tr>
	<tr>
		<td colspan="6" align="center"><br />
			<!--- <input type="submit" name="generate" value="Generate"  onClick="javascript:generatecpf();"> 
            <input type="button" name="crimsondisk" value="Crimson Disk" onClick="javascript:generateDiskCrimson();">--->
            <input type="button" name="htmlreport" value="HTML" onClick="javascript:generateHTML();">
			<input type="button" name="disk" value="Disk" onClick="javascript:generateDisk();">
			<input type="button" name="ok" value="OK" onClick="javascript:process();">
			<input type="button" name="exit" value="Exit" onClick="window.location='/government/CPF91/CPF91List.cfm'">
		</td>
	</tr>
</table>
</form>
</cfoutput>
        <script type="text/javascript">
<!--
var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1", "none", {validateOn:["blur"], minChars:9, maxChars:10});
//-->
        </script>
</body>

</html>