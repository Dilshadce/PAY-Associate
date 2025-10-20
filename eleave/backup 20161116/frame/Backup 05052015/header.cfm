<cfsetting showdebugoutput="no">
<!--- 
<cfquery name="getGsetup" datasource="#dts_main#">
	select * from gsetup WHERE comp_id = "#HcomID#"
</cfquery>  --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Payroll Management System</title>
<link rel="stylesheet" href="/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/css/pnotify/jquery.pnotify.default.css" />
<link rel="stylesheet" href="/css/header/header.css" />
<cfoutput>
<style>
body {
	margin: 0;
}
##container {
	height: 62px;
	margin: 0;
	border-bottom: 6px solid ##C67FD8;
}
</style>

<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/pnotify/jquery.pnotify.min.js"></script>
<script type="text/javascript" src="/js/header/header.js"></script>
</cfoutput>
</head>
<body>
<cfoutput>
<div id="container">
<div>	
	
	<div class="lastLoginInfo">
		<strong>Company ID:</strong> #HcomID# &nbsp;&nbsp;&nbsp;
        <strong>User ID:</strong> #HUserID# &nbsp;&nbsp;&nbsp;
		<strong>Login On:</strong> #DayOfWeekAsString(DayOfWeek(SESSION.loginTime))#,  #DateFormat(SESSION.loginTime, "dd-mm-yyyy")#, #TimeFormat(SESSION.loginTime, "HH:MM:SS")# &nbsp;&nbsp;&nbsp;
		<strong>IP Address:</strong> #cgi.REMOTE_ADDR# &nbsp;&nbsp;&nbsp;
<!---         <strong>System Month:</strong> #getGsetup.mmonth# &nbsp;&nbsp;&nbsp; 		
        <strong>System Year:</strong>#getGsetup.myear# &nbsp;&nbsp;&nbsp; --->
	</div>  

	<div class="menu">
		<div class="item">
			<a class="link logout" title="Logout" href="/logout.cfm" target="_parent"></a>
		</div>
		<div class="item expandable">
			<a class="link company" title="Click to change Company Logo" href="/body/uploadLogo.cfm" target="mainFrame"></a>
			<div class="item_content">
					<span class="company_name" title="#HcomCode#">#HcomCode#</span><br/>
					<span class="company_id" title="Company ID: #HcomID#">Company ID: #HcomID#</span>
				</div>
		</div>
		<div class="item">
			<a class="link contact" title="Contact" href="/body/contact.cfm" target="mainFrame"></a>
		</div>
		<div class="item">
			<a class="link support" title="Help & Support" href="/eleave/support.cfm" target="mainFrame"></a>
		</div>
		<div class="item">
			<a class="link home" title="Overview" href="/eleave/overview.cfm" target="mainFrame"></a>
		</div>
	</div>
</div>
</div>
</cfoutput>
</body>
</html>