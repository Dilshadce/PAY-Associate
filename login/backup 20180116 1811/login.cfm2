<cfset currentURL = CGI.SERVER_NAME >
<!--- <cfif cgi.SERVER_PORT_SECURE eq 0>
		<cflocation addtoken="no" url="https://#currentURL#">
	</cfif> --->
<!--- <cfif isdefined('url.loaddone') eq false>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Netiquette Payroll Management System | Login</title>
<link rel="stylesheet" type="text/css" href="/css/login/style.css" />
<link rel="stylesheet" type="text/css" href="/css/login/lessframework4.css" />
</head>
<body>
	<div class="main fix">
		<div class="header_area fix">
			<div class="header structure fix">
				<img src="/img/login/head_text.png" alt="Netiquette Logo" />
			</div>
		</div>
		<div class="main_body_area fix">
			<div class="main_body structure fix">
				<cfif IsDefined("url.msg")>
					<nobr><h2 style="color:red;">Login Error</h2></nobr>
					<nobr><p style="color:red; text-align:center"><cfoutput>#url.msg#</cfoutput></p></nobr>
				<cfelseif IsDefined("url.logout")>
					<nobr><h3>You had been successfully logged off.</h3></nobr>
					<nobr><p style="text-align:center;">Please enter your Username, Password and Company ID.</p></nobr>
				<cfelse>
					<nobr><h2>Secured Login</h2></nobr>
					<nobr><p style="text-align:center;">Please enter your Username, Password and Company ID.</p></nobr>
				</cfif>
				<div class="form_heading fix">
					<img src="/img/login/logo.png" alt="Netiquette Payroll Logo" width="276" height="85"/>
				</div>
				<div class="input fix">
					<cfform action="/index.cfm" method="post" name="login" id="login" preservedata="no" target="_top">
						<p>Username</p>
						<cfinput type="text" name="userid" id="userid" autofocus="autofocus" message="Please enter your Username." required="yes" maxlength="50" />
						<p>Password</p>
						<cfinput type="password" name="userpwd" id="userpwd" required="yes" message="Please enter your Password." maxlength="32" />
						<p>Company ID</p>
						<cfinput type="text" name="companyid" id="companyid" required="yes" message="Please enter your Company ID"  maxlength="32"  />
						<div class="sign">
							<input type="submit" name="submit" id="submit" value="Login" />
						</div>
					</cfform>
				</div>
			</div>
            <div id="img1" style="position: fixed;">
				<a href="">
					<img class="apps" src="/img/login/Android.png" title="Coming Soon" alt="Coming Soon" />
				</a>
			</div>
            
            <div id="img2" style="position: fixed;">
				<a href="">
					<img class="apps" src="/img/login/IOS.png" title="Coming Soon" alt="Coming Soon" />
				</a>
			</div>
            
			<p id="secured"><img src="/img/login/lock.png" alt="Lock Icon" /> This website is secured by 256-bit SSL security</p>

			<div class="right">
				<a href="http://crm.netiquette.com.sg/signupnew/signup.cfm">
					<p id="user" class="link_color">Not A User Yet?</p>
					<p id="sign">Sign Up Here</p>
				</a>
			</div>
		</div>
	</div>
	<div class="footer_area fix">
		<div class="footer structure fix">
			<p class="other">Other Netiquette Business Applications </p>
			<p class="system">
				<a class="payroll_color" href="http://ams.netiquette.asia/">
					<!--- <img src="/img/login/bottom.png" alt="IMS Icon" /> --->Accounting Management System
				</a>
			</p>
			<p class="system">
				<a class="inventory_color" href="http://ims.netiquette.asia/">
					<!--- <img src="/img/login/bottom.png" alt="IMS Icon" /> --->Inventory Management System
				</a>
			</p>
			<p class="system">
				<a class="crm_color" href="http://crm.netiquette.asia/">
					<!--- <img src="/img/login/bottom.png" alt="IMS Icon" /> --->Customer Relationship Management System
				</a>				
			</p>
		</div>
		<div class="footer_bottom_area">
			<p class="Terms"><a href="http://www.netiquette.com.sg/terms-and-conditions/">Terms of Use </a> <a href="http://www.netiquette.com.sg/privacy-policy/">Privacy</a></p>
			<p class="ltd">Netiquette Software Pte Ltd</p>
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