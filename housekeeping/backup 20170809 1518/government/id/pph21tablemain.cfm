<html>
<head>
	<title>PPH 21 Table Main</title>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    <link rel="shortcut icon" href="/PMS.ico" />
    <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest official rate? Old rate will be deleted!');
	if(answer)
	{
	window.location.href="update.cfm?type=pph21";
	}
	
	}
    </script>
    
</head>

<body>

<cfquery name="rng_qry" datasource="#dts#">
SELECT bjabat, bjabatcap, ptkpcode,ptkprange,lpkp,lpkprange, npwp FROM rngtable
WHERE entryno between 1 and 10
ORDER BY entryno
</cfquery>

<cfoutput>
<div class="mainTitle">PPH 21</div>
<form name="eform" id='eform' action="./process.cfm?type=pph21" method="post">

<table id="tit" class="form" border="0">
<tr>
	<th>Table</th>
	<th>Biaya Jabatan %</th>
	<th>Biaya Jabatan(Cap)</th>
	<th>PTKP Group</th>
	<th>PTKP Amount</th>
    <th>LPKP Group</th>
    <th>LPKP %</th>
    <th>NPWP %</th>
</tr>
	
	<cfloop query="rng_qry">
    <tr> 
    	<td>#rng_qry.currentrow#</td>
        <td><input type="text" id="bjabat_#rng_qry.currentrow#" name="bjabat_#rng_qry.currentrow#" value="#rng_qry.bjabat*100#" size=12/></td>
        <td><input type="text" id="bjabatcap_#rng_qry.currentrow#" name="bjabatcap_#rng_qry.currentrow#" value="#rng_qry.bjabatcap#" size=15/></td>
        <td><input type="text" id="ptkpcode_#rng_qry.currentrow#" name="ptkpcode_#rng_qry.currentrow#" value="#rng_qry.ptkpcode#" size=12/></td>
        <td><input type="text" id="ptkprange_#rng_qry.currentrow#" name="ptkprange_#rng_qry.currentrow#" value="#rng_qry.ptkprange#" size=15/></td>
        <td><input type="text" id="lpkprange_#rng_qry.currentrow#" name="lpkprange_#rng_qry.currentrow#" value="#rng_qry.lpkprange#" size=15/></td>
        <td><input type="text" id="lpkp_#rng_qry.currentrow#" name="lpkp_#rng_qry.currentrow#" value="#rng_qry.lpkp*100#" size=12/></td>
        <td><input type="text" id="npwp_#rng_qry.currentrow#" name="npwp_#rng_qry.currentrow#" value="#rng_qry.npwp*100#" size=12/></td>
	</tr>
	</cfloop>
</table>
</br>
<center>
	<!--- <input type="reset" name="reset" value="Reset"> --->
	<input type="submit" name="save" value="Save">
	<input type="button" name="cancel" value="Cancel" onClick="window.location='/body/bodymenu.cfm?id=236'">
    <input type="button" name="update" value="UPDATE NEW RATE" onClick="updateconfirm()" />

</center>

</form>
</div>
</cfoutput>
</body>

</html>

<!--- <html>
<head>
	<title>CPF Table Main</title>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest JHT rate?');
	if(answer)
	{
	window.location.href="updatejht.cfm";
	}
	
	}
    </script>
    
</head>

<body>

<cfquery name="jht_qry" datasource="#dts#">
SELECT * FROM rngtable
WHERE entryno between 1 and 10
ORDER BY entryno
</cfquery>

<cfoutput>
<div class="mainTitle">BPJS & Tax</div>

<table id="tit" class="form" border="0">
<tr>
	<td>Range
		<select id="range" name="range" onChange="ajaxFunction(document.getElementById('ajaxField'),'CPFTableMain_ajax.cfm?c='+this.options[this.selectedIndex].id);">
			<cfloop query="cpf_qry">
			<option value="#cpf_qry.entryno#" id="#cpf_qry.entryno#">
				<cfif cpf_qry.epfpayf eq "">0.00<cfelse>#cpf_qry.epfpayf#</cfif>
				<cfif cpf_qry.epfpayt eq "">0.00<cfelse>#cpf_qry.epfpayt#</cfif>
			</option>
			</cfloop>
		</select>
	</td>
</tr>
</table>

<div id="ajaxField" name="ajaxField">
<form name="eForm" action="/housekeeping/government/CPFTableMain_process.cfm?e=#cpf_qry.entryno#" method="post">
<table class="form" border="0">
<tr>
	<td colspan="2">Pay From
	<input type="text" name="payFrom" value="#cpf_qry.epfpayf#" size="8">
	To
	<input type="text" name="payTo" value="#cpf_qry.epfpayt#" size="8"></td>
</tr>

	<tr >
		<th width="10">Table</th>
		<th width="450">Employee</th>
		<th width="450">Employer</th>
	</tr>
	<cfset i=1>
	<cfloop from="1" to="30" index="i">
	<tr>
		<td>#i#</td>
		<td><input type="text" name="epfyee#i#" value="#evaluate('cpf_qry.epfyee#i#')#" size="72"></td>
		<td><input type="text" name="epfyer#i#" value="#evaluate('cpf_qry.epfyer#i#')#" size="72"></td>
	</tr>
	<cfset i= i +1>
	</cfloop>
	
</table>


<table>
<tr>
	<td>Ceiling for normal pay <cfif HuserCcode eq 'MY'>E<cfelse>C</cfif>PF calculated</td>
	<td><input type="text" name="cNormal" value="#cpf_qry.cpf_ceili#" size="10"></td>
</tr>
<tr>
	<td>Ceiling for Bonus <cfif HuserCcode eq 'MY'>E<cfelse>C</cfif>PF calculated</td>
	<td><input type="text" name="cBonus" value="#cpf_qry.tcpf_ceili#" size="10"></td>
</tr>
</table>
</br>
<center>
	<!--- <input type="reset" name="reset" value="Reset"> --->
	<input type="submit" name="save" value="Save">
	<input type="button" name="cancel" value="Cancel" onClick="window.location='/housekeeping/setupList.cfm'">

    <input type="button" name="update" value="UPDATE NEW <cfif HuserCcode eq 'MY'>E<cfelse>C</cfif>PF RATE" onClick="updateconfirm()" />

</center>

</form>
</div>
</cfoutput>
</body>

</html> --->


