<cfsetting showdebugoutput="no">
<cfquery name="gsetup" datasource="#dts_main#">
	SELECT * FROM gsetup WHERE  comp_id = "#HcomID#"
</cfquery>

<cfset comid = replace(getHQstatus.userdsn,'_p','')>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Payroll Management System</title>
<link rel="stylesheet" href="/css/hoverscroll/jquery.hoverscroll.css" />
<link rel="stylesheet" href="/css/side/side.css" />
<link rel="stylesheet" href="/css/side/sidemenu.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/hoverscroll/jquery.hoverscroll.js"></script>
<script type="text/javascript" src="/js/side/sidemenu.js"></script>
</head>
<body>
<cfoutput>

<div id="logo_div" class="section">
    <a href="http://www.mynetiquette.com/" target="_blank">
        <img alt="PMS Logo" src="/img/pmslogo.png" />
    </a>
</div>
<div class="section">
	<ul id="menu" class="accordion">
		<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Maintenance</a>
			<ul class="sub-menu">
        		<li id="itemMP1" class="itemMP1"><a href="/housekeeping/maintainPassword.cfm" target="mainFrame">Change Password</a></li>
            </ul>
		</li>	
		<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Approval</a>
			<ul class="sub-menu">
        		<li id="itemMP1" class="itemMP1"><a href="/approval/timesheetapprovalmain.cfm" target="mainFrame">Timesheet Approval</a></li>
        		<li id="itemMP1" class="itemMP1"><a href="/approval/claimapprovalmain.cfm" target="mainFrame">Claim Approval</a></li>
        		<li id="itemMP1" class="itemMP1"><a href="/approval/leaveapprovalmain.cfm" target="mainFrame">Leave Approval</a></li>
            </ul>
		</li>
    </ul>
</div>

<div id="bottomDiv" class="bottomNavigationDiv">
</div>

</cfoutput>
</body>
</html>