<cfset currentURL = CGI.SERVER_NAME >
<!---  <cfif cgi.SERVER_PORT_SECURE eq 0>
<cfif right(currentURL,2) neq "sg">
<cfset currentURL = "payroll.netiquette.com.sg">
</cfif>
<cflocation addtoken="no" url="https://#currentURL#">
</cfif>
<cfif CGI.SERVER_NAME eq "payrollpro.netiquette.com.sg">
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
</cfif>  --->


<html>
<head>

<link rel="shortcut icon"
 href="/IMS.ico" />
 <meta http-equiv="X-UA-Compatible" content="IE=edge" />

</head>

<body style="text-align:center" onLoad="document.login.userId.focus()">

<div style="height:20%; text-align:left;margin: -15px 0 50PX 0px;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

    ; width:100%">
        <div style="float:left; width:25%">
        <img class="headerlogo" width="100%" style="margin:20px 0 0 30px; float:left; size:100%" src="newlogo.png" alt="Netiquette">
        </div>
        <div style="float:right; width:22%">
			<img class="headerlogo" width="100%" style="margin:25px 30px 0 0" src="starhubH.png" alt="Netiquette">
		</div>


</div>


<cfform action="/index.cfm" method="post" name="login" id="login" preservedata="no">
<div style="width:100%">
<div style="float:left; width:40%">
</div>
<div style="float:right; width:60%">
<table border="0">
	<tr>
		<td>

        <div style="text-align:center"><img src="pmslogo.png" alt="Payroll Management System">
        </div>

        </td>
        </tr>
        <tr>
            
		<td>
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
        <div class="fieldset" style="width:100%">
	<table width="100%" border="0" >
		<tr><td colspan="5">&nbsp;</td></tr>
      	<tr align="center">
			<td width="28%"></td> 
        	<td width="20%" class="labeltxt" align="left"><font style="font-weight:bolder; font-family:Calibri; font-size:14px" color="gray" size="-1"> USER ID</font></td>
			<td width="1%">:</td>
        	<td width="20%" align="left"><cfinput style="background:whitesmoke; border-radius: 6px;-moz-border-radius:6px;-webkit-border-radius: 6px;" type="text" required="yes" maxlength="50" size="39" name="userId" message="Please enter your user ID." tabindex="1"></td>
      		<td width="350px" rowspan="4" align="left"><cfif cgi.SERVER_PORT_SECURE neq 0><!-- Begin DigiCert/ClickID site seal HTML and JavaScript --><div align="left" style="position:absolute"><div id="DigiCertClickID_uiXvm7Mo"></div>
<script type="text/javascript">
var __dcid = __dcid || [];__dcid.push(["DigiCertClickID_uiXvm7Mo", "3", "l", "black", "uiXvm7Mo"]);(function(){var cid=document.createElement("script");cid.type="text/javascript";cid.async=true;cid.src=("https:" === document.location.protocol ? "https://" : "http://")+"seal.digicert.com/seals/cascade/seal.min.js";var s = document.getElementsByTagName("script");var ls = s[(s.length - 1)];ls.parentNode.insertBefore(cid, ls.nextSibling);}());
</script>
<!-- End DigiCert/ClickID site seal HTML and JavaScript -->
</div>
</cfif>            
            </td>
		</tr>
      	<tr> 
			<td></td>
        	<td class="labeltxt"><font style="font-weight:bolder; font-family:Calibri; font-size:14px" color="gray" size="-1">PASSWORD</font></td>
			<td>:</td>
        	<td width="19%" align="left"><cfinput style="background:whitesmoke; border-radius: 6px;-moz-border-radius:6px;-webkit-border-radius: 6px;" type="password" required="yes" maxlength="32" size="40" name="userPwd" id="userPwd" message="Please enter your password." tabindex="2"></td>
            
		</tr>
		<tr> 
			<td></td> 
        	<td class="labeltxt"><font style="font-weight:bolder; font-family:Calibri; font-size:14px" color="gray">COMPANY ID</font></td>
			<td>:</td>
        	<td width="20%" align="left"><cfinput style="background:whitesmoke; border-radius: 6px;-moz-border-radius:6px;-webkit-border-radius: 6px;" type="text" required="yes" maxlength="50" size="39" name="companyId" id="companyId" message="Please enter your Company ID." tabindex="3"></td>
      	</tr>
      	<tr> 
        <td colspan="2">
        </td>
        
        	<!---<td colspan="4" align="right"><input class="button" name="submit" type="submit" value="Login" onClick="validsubmit();" tabindex="4">&nbsp;<input class="button" name="Cancel" type="Reset" value="Cancel"></td>--->
            
            <td colspan="2" align="center">
			<input class="button" name="submit" type="submit" value="Login" tabindex="4" style="display:inline-block;
	border-radius: 6px;
	-moz-border-radius:6px;
	-webkit-border-radius: 6px;
	text-transform:capitalize;
	border:0px;
	width:100px;
	height:30px;
	margin: 0;
	padding: 0;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

	color:#FFF;
	font-weight:bolder;
    font:Calibri;
    font-size:18px;
	cursor: pointer; /* hand-shaped cursor */
	cursor: hand; /* for IE 5.x */">&nbsp;<input class="button" name="Cancel" type="Reset" value="Cancel" tabindex="4" style="display:inline-block;
	border-radius: 6px;
	-moz-border-radius:6px;
	-webkit-border-radius: 6px;
	text-transform:capitalize;
	border:0px;
	width:100px;
	height:30px;
	margin: 0;
	padding: 0;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

	color:#FFF;
	font-weight:bolder;
    font:Calibri;
    font-size:18px;
	cursor: pointer; /* hand-shaped cursor */
	cursor: hand; /* for IE 5.x */"></td>
            
      	</tr>
    </table>
	
</div>
		</td>
	</tr>
</table>
</div></div>


</cfform>
<div style="width:100%; text-align:center; vertical-align:text-bottom" align="center">

   		<img src="/login/footer.png" width="100%" alt="Inventory Management System">


</div>
</body>
</html>