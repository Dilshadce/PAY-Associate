<cfset currentURL = CGI.SERVER_NAME >
<cfoutput>
<cfif CGI.SERVER_NAME eq "mp4u.com.my">
<cflocation addtoken="no" url="https://www.mp4u.com.my">
</cfif>
<script type="text/javascript">
if (location.protocol != 'https:')
{
 location.href = 'https:' + window.location.href.substring(window.location.protocol.length);
}
</script>
</cfoutput>

<!--- <cfif findnocase('.co.id',CGI.SERVER_NAME) NEQ 0>
<cfelse>
<cfif cgi.SERVER_PORT_SECURE eq 0>
		<cflocation addtoken="no" url="https://#currentURL#">
	</cfif>
<cfif findnocase('pro',CGI.SERVER_NAME) neq 0>
<cfelse>
<cfif isdefined('url.loaddone') eq false>
<cfif mid(currentURL,'8','1') eq "2">
<cfset servername = "appserver2">
<cfelse>
<cfset servername = "appserver1">
</cfif>

<cfquery name="checkload" datasource="loadbalance">
SELECT servername,serveraddress FROM redirection where applicationtype = "PAYROLL" AND serverside = "asia"  order by memoryload desc
</cfquery>

<cfif checkload.servername neq servername>
<cflocation url="#checkload.serveraddress#?loaddone=yes" addtoken="no">
</cfif>
</cfif>
</cfif>
</cfif>
<cfif cgi.SERVER_PORT_SECURE eq 0>
		<cflocation addtoken="no" url="https://www.mp4u.com.my">
	</cfif>
<cfif not cgi.SERVER_PORT_SECURE>
<cfoutput>
#CGI.SERVER_NAME#
</cfoutput>
<cfabort>
</cfif> --->

<cfif IsDefined("url.logout")>
	<cfif IsDefined ("session.id")>
		<cfset dummy = StructDelete(application.sessiontracker, "#session.company_name#(#session.id#)")>
		<cfset session.islogin="No">
	</cfif>
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
<link rel="shortcut icon" href="/images/mp.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>MP4U</title>
<link rel="stylesheet" type="text/css" href="/css/login/style.css" />
<link rel="stylesheet" type="text/css" href="/css/login/lessframework4.css" />
</head>
<body>
	<div class="main fix">
		<div class="header_area fix">
			<div class="header structure fix">
				<img src="/img/login/head_text.png" alt="MP4U Logo"  width="330" />
			</div>
		</div>
		<div class="main_body_area fix">
			<div class="main_body structure fix">
				<cfif IsDefined("url.msg")>
				    <cfif url.msg eq 'SessionOut'>
                        <nobr><h2 style="color:red;">Session Timed Out</h2></nobr>
                        <p style="color:red; text-align:center"><cfoutput>Your session has timed out. Please login again.</cfoutput></p>
                    <cfelse>
                        <nobr><h2 style="color:red;">Login Error</h2></nobr>
                        <p style="color:red; text-align:center"><cfoutput>#url.msg#</cfoutput></p>
                    </cfif>
				<cfelseif IsDefined("url.logout")>
					<nobr><h3>You had been successfully logged off.</h3></nobr>
					<nobr><p style="text-align:center;">Please enter your Username and Password.</p></nobr>
				<cfelse>
					<nobr><h2>Secured Login</h2></nobr>
					<nobr><p style="text-align:center;">Please enter your Username and Password.</p></nobr>
				</cfif>
				<div class="form_heading fix" style="text-align:center">
					<br/>
<h1>MP4U</h1><br/>
				</div>
				<div class="input fix">
					<cfform action="/index.cfm" method="post" name="login" id="login" preservedata="no" target="_top">
						<p>Username</p>
						<cfinput type="text" name="userid" id="userid" autofocus="autofocus" message="Please enter your Username." required="yes" maxlength="50" />
						<p>Password</p>
						<cfinput type="password" name="userpwd" id="userpwd" required="yes" message="Please enter your Password." maxlength="32" />
                        <div style="display:none">
						<p>Company ID</p>
						<cfinput type="hidden" name="companyid" id="companyid" required="yes" message="Please enter your Company ID"  maxlength="32" value="manpower"  />
                        </div>
						<div class="sign">
							<input type="submit" name="submit" id="submit" value="Login" />
						</div>
					</cfform>
				</div>
			</div>


            <cfif cgi.SERVER_PORT_SECURE eq 1>
			    <p id="secured"><img src="/img/login/lock.png" alt="Lock Icon" /> This website is secured by 256-bit SSL security</p><br />
            </cfif>
            
            <!---Added reset password link, [20170927, Alvin]--->
            <cfif "#cgi.REMOTE_ADDR#" EQ "175.139.199.9">
                <center><p><a class="reset" href="/reset/resetpassword.cfm" target="_self" style="color: blue">Forgot Password</a></p></center>
            </cfif>
            <!---Added reset password link--->


		</div>
	</div>
<script type="text/javascript">
if(window.self != window.top)
{
	parent.location.reload(true);
}
</script>
</body>
</html>