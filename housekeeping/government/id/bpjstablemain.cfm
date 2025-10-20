<html>
<head>
	<title>BPJS Table Main</title>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    <link rel="shortcut icon" href="/PMS.ico" />
    <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest official rate? Old rate will be deleted!');
	if(answer)
	{
	window.location.href="update.cfm?type=bpjs";
	}
	
	}
    </script>
    
</head>

<body>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM rngtable
WHERE entryno between 1 and 30
ORDER BY entryno
</cfquery>

<cfoutput>
<div class="mainTitle">BPJS</div>

<table id="tit" class="form" border="0" width="80%">
<tr>
<!--- 	<td>Range
		<select id="range" name="range" onChange="ajaxFunction(document.getElementById('ajaxField'),'CPFTableMain_ajax.cfm?c='+this.options[this.selectedIndex].id);">
			<cfloop query="cpf_qry">
			<option value="#cpf_qry.entryno#" id="#cpf_qry.entryno#">
				<cfif cpf_qry.epfpayf eq "">0.00<cfelse>#cpf_qry.epfpayf#</cfif>
				<cfif cpf_qry.epfpayt eq "">0.00<cfelse>#cpf_qry.epfpayt#</cfif>
			</option>
			</cfloop>
		</select>
	</td> --->
</tr>
</table>

<div id="ajaxField" name="ajaxField">
<form name="eForm" action="process.cfm?type=bpjs" method="post">
<table class="form" border="0">
<tr>
	<td colspan="4">Pay From
	<input type="text" name="payFrom" value="#cpf_qry.epfpayf#" size="12">
	To
	<input type="text" name="payTo" value="#cpf_qry.epfpayt#" size="12"></td>
</tr>

	<tr >
		<th >Table</th>
		<th >JHT Employee</th>
		<th >JHT Employer</th>
		<th >JKK % 'yer</th>
		<th >JKM % 'yer</th>
		<th >Kesehatan % (both)</th>
		<th >Kesehatan Cap (both)</th>
	</tr>
	<cfset i=1>
	<cfloop from="1" to="30" index="i">
	<tr>
		<td>#i#</td>
		<td><input type="text" name="epfyee#i#" value="#evaluate('cpf_qry.epfyee#i#')#" size="25"></td>
		<td><input type="text" name="epfyer#i#" value="#evaluate('cpf_qry.epfyer#i#')#" size="25"></td>
        
        <cfquery name="getrate" datasource="#dts#">
        	SELECT JKK, JKM, kesehatan,kesehatancap from rngtable where entryno = "#i#"
        </cfquery>
             
		<td><input type="text" name="jkk_#i#" id="jkk_#i#" value="#getrate.jkk*100#" size="15"></td>
		<td><input type="text" name="jkm_#i#" id="jkm_#i#" value="#getrate.jkm*100#" size="15"></td>
		<td><input type="text" name="kesehatan_#i#" id="kesehatan_#i#" value="#getrate.kesehatan*100#" size="15"></td>
		<td><input type="text" name="kesehatancap_#i#" id="kesehatancap_#i#" value="#getrate.kesehatancap#" size="16"></td>
	</tr>

	</cfloop>
	
</table>


<table>
<tr>
	<td>Ceiling for normal pay JHT calculated</td>
	<td><input type="text" name="cNormal" value="#cpf_qry.cpf_ceili#" size="10"></td>
</tr>
<tr>
	<td>Ceiling for Bonus  pay JHT calculated</td>
	<td><input type="text" name="cBonus" value="#cpf_qry.tcpf_ceili#" size="10"></td>
</tr>
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