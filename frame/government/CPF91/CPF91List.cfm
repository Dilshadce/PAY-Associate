<html>
<head>
	<title>Government Reports List</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfoutput>
<cfset user_pin = "PIN"&Hpin >
<cfquery name="pin_qry" datasource="#dts#">
	SELECT code, #user_pin# as pin from userdefine 
</cfquery>


<cfset title_define = StructNew()>
<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, pin_qry.pin)>
</cfloop>
<div class="mainTitle">Government - CPF91</div>
<table class="list">
<tr>
	<cfif title_define[311000] eq "TRUE">
	<td><a href="/government/CPF91/CPF91PA_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CPF 91 Payment Advice</a></td>
	</cfif>
	<cfif title_define[312000] eq "TRUE">
	<td><a href="/government/CPF91/CPFListing_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CPF Listing</a></td>
	</cfif>
	<cfif title_define[313000] eq "TRUE">
	<td><a href="/government/CPF91/CPFEVListing_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CPF Excess/Voluntary Listing</a></td>
	</cfif>
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define[314000] eq "TRUE">
	<td><a href="/government/CPF91/FWL_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Foreign Worker Levy</a></td>
	</cfif>
	<cfif title_define[315000] eq "TRUE">
	<td><a href="SDL_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Skills Development Levy (SDL)</a></td>
	</cfif>
	<cfif title_define[316000] eq "TRUE">
	<td><a href="/government/CPF91/YMF_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Yayasan Mendaki Fund</a></td>
	</CFIF>
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define[317000] eq "TRUE">
	<td><a href="/government/CPF91/DCC_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Donation To Community Chest</a></td>
	</cfif>
	<cfif title_define[318000] eq "TRUE">
	<td><a href="/government/CPF91/MBF_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Mosque Building Fund</a></td>
	</cfif>
	<cfif title_define[319000] eq "TRUE">
	<td><a href="/government/CPF91/SINDA_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">SINDA Fund</a></td>
	</cfif>	
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define["319000-1"] eq "TRUE">
	<td><a href="/government/CPF91/CDAC_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CDAC Fund</a></td>
	</cfif>
	<cfif title_define["319000-2"] eq "TRUE">
	<td><a href="/government/CPF91/ECF_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Eurasian Community Fund</a></td>
	</cfif>
	<cfif title_define["319000-3"] eq "TRUE">
	<td><a href="/government/CPF91/CPFRefund_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CPF Refund</a></td>
	</cfif>
	
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define["319000-4"] eq "TRUE">
	<td><a href="/government/CPF91/CPFCNR_main.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">CPF CNR/FORM CAPR</a></td>
	</cfif>
</tr>
</table>
</cfoutput>
</body>

</html>