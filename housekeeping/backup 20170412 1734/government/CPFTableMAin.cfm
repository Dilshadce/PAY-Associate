<html>
<head>
	<title>CPF Table Main</title>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest <cfif HuserCcode eq 'MY'>E<cfelse>C</cfif>PF Rate (Jan 2015)?');
	if(answer)
	{
	window.location.href="updatecpf.cfm";
	}
	
	}
    </script>
    
</head>

<body>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM rngtable
WHERE entryno between 1 and 10
ORDER BY entryno
</cfquery>

<cfoutput>
<div class="mainTitle"><cfif HuserCcode eq 'MY'>E<cfelse>C</cfif>PF Table</div>

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

</html>