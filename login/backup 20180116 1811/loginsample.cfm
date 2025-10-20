<!---<cfif cgi.SERVER_PORT_SECURE eq 0>
<cflocation addtoken="no" url="https://payroll.netiquette.com.sg">
</cfif>--->

<!-------------
<cfif CGI.SERVER_NAME eq "payrollpro.mynetiquette.com">
<cfelse>
<cfset currentURL =  CGI.SERVER_NAME>
<cfif isdefined('url.loaddone') eq false>
<cfif mid(currentURL,'8','1') eq "2">
<cfset servername = "appserver2">
<cfelse>
<cfset servername = "appserver1">
</cfif>

<cfquery name="checkload" datasource="loadbalance">
SELECT servername,serveraddress FROM redirection where applicationtype = "PAYROLL" order by memoryload desc
</cfquery>

<cfif checkload.servername neq servername>
<cflocation url="#checkload.serveraddress#?loaddone=yes" addtoken="no"> 
</cfif>
</cfif>
</cfif>
---------------->
<html>
<style>
* {
	margin:0; 
}
</style>	
	
	
<head>
<title>Netiquette Software Pte Ltd :: User Login</title>
<!------<link rel="stylesheet" href="/stylesheet/app.css"/>---------->
</head>

<body onLoad="document.login.userId.focus()">

<table width="100%" border="0" align="center">
<tr align="center">
	<td>
   		<img src="/images/payroll1.png" alt="Payroll System" width='100%' height='100%'><br />
	</td>
</tr>
<tr align="center">
	<td>
		<br /><br /><br />
   		<img src="/images/payroll2.png" alt="Payroll System" ><br />
        Version 2.0 (Feb 2011)
	</td>
</tr>
</table>

<cfform action="/index.cfm" method="post" name="login" preservedata="no">
<table width="100%" border="0" align="center">
<tr>
	<td> <br/>
		<div align="center">
		<cfif isdefined("url.login")>
  			<h3>Incorrect User Id or Password. Please try again.</h3>
		</cfif>
			<!---h3>Maintenance Is In Progess.</h3--->
  		<cfif isdefined("url.logout")>
			<h3>You had been successfully logged off.</h3>
		</cfif>
			<a class="a2"><b>Please enter your User ID, Password and Company ID</b></a>
   			 <!--- <h3><font size="3">The System Is Under Maintenance!</font></h3> --->
		</div>
	</td>
</tr>
</table>

<div class="fieldset" style="width:100%">
<table width="100%" border="0" align="center">
<tr>
	<td colspan="3">
		
	</td>
</tr>
<tr align="center">
	<td width="330px"></td> 
	<td width="150px" class="labeltxt" align="right"><FONT COLOR="#808080" face="Microsoft Sans Serif">USER iD&nbsp;&nbsp;</FONT></td>
	<td width="10px">:</td>
	<td width="200px" align="left"><cfinput type="text" required="yes" maxlength="50" size="60" name="userId" message="Please enter your user ID." tabindex="1">
	</td>
	<td width="350px" rowspan="4" align="left"><!-- Begin DigiCert/ClickID site seal HTML and JavaScript -->
<div id="DigiCertClickID_D9mHo8n4" align="left">
	<a href="http://www.digicert.com/welcome/wildcard-plus.htm"></a>
</div>
<script type="text/javascript">
var __dcid = __dcid || [];__dcid.push(["DigiCertClickID_D9mHo8n4", "7", "m", "black", "D9mHo8n4"]);(function(){var cid=document.createElement("script");cid.type="text/javascript";cid.async=true;cid.src=("https:" === document.location.protocol ? "https://" : "http://")+"seal.digicert.com/seals/cascade/seal.min.js";var s = document.getElementsByTagName("script");var ls = s[(s.length - 1)];ls.parentNode.insertBefore(cid, ls.nextSibling);}());
</script>
<!-- End DigiCert/ClickID site seal HTML and JavaScript --></td>
</tr>
<tr> 
	<td></td>
	<td width="150px" class="labeltxt" align="right"><FONT COLOR="#808080" face="Microsoft Sans Serif">PASSWORD&nbsp;&nbsp;</FONT></td>
	<td>:</td>
	<td>
		<cfinput type="password" required="yes" maxlength="32" size="61" name="userPwd" message="Please enter your password." tabindex="2">
	</td>

</tr>
<tr>
	<td></td> 
	<td width="150px" class="labeltxt" align="right"><FONT COLOR="#808080" face="Microsoft Sans Serif">COMPANY&nbsp;ID&nbsp;&nbsp;</FONT></td>
	<td>:</td>
	<td>
		<cfinput type="text" required="yes" maxlength="50" size="60" name="companyId" message="Please enter your Company ID." tabindex="3">
	</td>
</tr>
<tr> 
	<td colspan="3"><br/><br/><br/>&nbsp;</td>
	<td colspan="1" align="left">
		<input class="button" name="submit"  TYPE="image" SRC="/images/button1.png" HEIGHT="30" WIDTH="80" BORDER="0" ALT="Submit Form" value="Login">
		&nbsp;
		<input class="button" name="Cancel" TYPE="image" SRC="/images/button2.png" HEIGHT="30" WIDTH="80" BORDER="0" onclick="document.login.reset();return false;" value="Cancel" tabindex="4">
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</div>
</cfform>

<div>
<table width="100%" border="0" align="center">
<tr>
	<td colspan="3">
		<cfoutput>
   		<img src="/images/footerLogin1.png" alt="Payroll System" width='100%' height='100%'>
	</td>
  		</cfoutput>
</tr>
</table>
</div>
</body>
</html>