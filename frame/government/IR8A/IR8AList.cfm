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
	<cfif title_define[321000] eq "TRUE">
	<td><a href="/government/IR8A/PrintIR8AMain.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Print IR8A</a></td>
	</cfif>
	<cfif title_define[321000] eq "TRUE">
	<td><a href="/government/IR8A/Appendix8AMain.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Appendix 8A</a></td>
	</cfif>
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define[322000] eq "TRUE">
	<td><a href="/government/IR8A/PrintIR8SMain.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Print IR8S</a></td>
	</cfif>	
	<cfif title_define[322000] eq "TRUE">
	<td><a href="/government/IR8A/Appendix8BMain.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Appendix 8B</a></td>
	</cfif>
</tr>
<tr><td><br /></td></tr>
<tr>
	<cfif title_define[323000] eq "TRUE">
	<td><a href="/government/IR8A/GenerateIR8ASpecMain.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Generate IR8A Spec</a></td>
	</cfif>	
	<cfif title_define[323000] eq "TRUE">
	<td><a href="/government/IR8A/GenerateIR8ASpecMainCL.cfm">
		<img name="Cash Sales" src="/images/reportlogo.gif">Summary of IR8A Files</a></td>
	</cfif>	
</tr>
</table>
</cfoutput>
</body>

</html>