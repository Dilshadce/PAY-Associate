<cfset currentURL = CGI.SERVER_NAME >
<cfoutput>
<!---<cfif CGI.SERVER_NAME eq "mp4u.com.my">
<cflocation addtoken="no" url="https://www.mp4u.com.my">
</cfif>--->
<!---<script type="text/javascript">
if (location.protocol != 'https:')
{
 location.href = 'https:' + window.location.href.substring(window.location.protocol.length);
}
</script>--->
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
				<div class="form_heading fix" style="text-align:center">
					<br/>
<h1>Choose Profile</h1><br/>
				</div>
				<div class="input fix">
					<cfform action="/index.cfm" method="post" name="login" id="login" preservedata="no" target="_top">
                        <div style="display:none">
						<cfinput type="text" name="userid" id="userid"  value="#form.userId#"/>
                        <cfinput type="password" name="userpwd" id="userpwd" value="#form.userPwd#"/>
                        <cfinput type="text" name="companyid" id="companyid" value="manpower"  />
                        <cfinput type="text" name="profile" id="profile" value="profile"  />
                        </div>
                        <p><div style="padding-left: 23%"><input type="submit" name="submit" id="submit" size="50" value="Associate"/></div></p>
                        <p><div style="padding-left: 13%"><input type="submit" name="submit" id="submit" size="50" value="Hiring Manager"/></div></p>
					</cfform>
				</div>
			</div>


		</div>
	</div>
</body>
</html>