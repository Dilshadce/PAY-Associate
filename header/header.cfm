<cfsetting showdebugoutput="no">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>MP4U</title>
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
	border-bottom: 6px solid ##e77c22;
}
</style>
</cfoutput>
</head>
<body>
<cfoutput>
<div id="container">
<div>	

	<div class="lastLoginInfo">
		
        	<strong>User ID:</strong> #HUserID# &nbsp;&nbsp;&nbsp;
		<strong>IP Address:</strong> #cgi.REMOTE_ADDR# &nbsp;&nbsp;&nbsp;
		<strong>Company ID:</strong>  #dts#
	</div>  

	<div class="menu">
		<div class="item">
			<a class="link logout" title="Logout" href="/logout.cfm" target="_parent"></a>
		</div>
			<div class="item">
				<a class="link contact" title="Contact" href="/contactus.cfm" target="mainFrame"></a>
			</div>
		<div class="item">
			<a class="link home" title="Overview" href="/body/overview.cfm" target="mainFrame"></a>
		</div>
	</div>
</div>
</div>
</cfoutput>
</body>
</html>