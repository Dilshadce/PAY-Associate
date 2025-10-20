
<!---
<cfquery name="getGsetup" datasource="payroll_main">
	SELECT dflanguage FROM gsetup
</cfquery>
<cfif getGsetup.dflanguage NEQ "english">
	<cfset menuname=getGsetup.dflanguage>
<cfelse>
	<cfset menuname="menu_name">
</cfif>
--->
<cfquery name="getLevel1Menu" datasource="payroll_main">
	SELECT *
	FROM menu_emp
	WHERE menu_level=1
	ORDER BY menu_order;
</cfquery>
<cfquery name="getCurrentActiveMenu" datasource="payroll_main">
	SELECT menu_id
	FROM menu_emp
	WHERE link_url LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.SCRIPT_NAME#%">
</cfquery>
<!---
<cfif getCurrentActiveMenu.RecordCount GT 0>
	<cfset session.menuid = getCurrentActiveMenu.menu_id>
</cfif>
--->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Netiquette Payroll Management System</title>
<link rel="stylesheet" href="/css/hoverscroll/jquery.hoverscroll.css" />
<link rel="stylesheet" href="/css/side/side.css" />
<link rel="stylesheet" href="/css/side/sidemenu.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/hoverscroll/jquery.hoverscroll.js"></script>
<script type="text/javascript" src="/js/side/sidemenu.js"></script>
</head>
<body>
<cfoutput>
<div id="logo_div" class="section"><a href="" target="_blank"><img alt="PMS Logo" src="/img/pmslogo.png" /></a></div>
<div class="section">
	<ul id="menu" class="accordion">
<!---		<cfloop query="getLevel1Menu">
		<li id="item#getLevel1Menu.menu_id#" class="item#getLevel1Menu.menu_id#"><a href="../#getLevel1Menu.link_url#" target="mainFrame">#getLevel1Menu.menu_name#</a>
			<ul class="sub-menu">
				<cfquery name="getLevel2Menu" datasource="payroll_main">
					SELECT menu_id,menu_name,link_url
					FROM menu_emp
					WHERE menu_parent=#getLevel1Menu.menu_id#
					ORDER BY menu_order;
				</cfquery>
				<cfloop query="getLevel2Menu">
					<li id="item#getLevel2Menu.menu_id#" class="item#getLevel2Menu.menu_id#"><a href="../#getLevel2Menu.link_url#" target="mainFrame">#getLevel2Menu.menu_name#</a></li>
				</cfloop>
			</ul>
		</li>	
		</cfloop>--->
		<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Maintenance</a>
			<ul class="sub-menu">
					<li id="itemMP1" class="itemMP1"><a href="/eleave/personalAccount.cfm" target="mainFrame">Change Password</a></li>
<!---					<li id="itemMP1" class="itemMP1"><a href="/eleave/incident/incidentlist.cfm" target="mainFrame">Incident Listing</a></li>
--->			</ul>
		</li>
		<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Incident</a>
			<ul class="sub-menu">
					<li id="itemMP1" class="itemMP1"><a href="/eleave/selectjo.cfm?type=incident" target="mainFrame">Log Incident</a></li>
<!---					<li id="itemMP1" class="itemMP1"><a href="/eleave/incident/incidentlist.cfm" target="mainFrame">Incident Listing</a></li>
--->			</ul>
		</li>
		<li id="itemMP2" class="itemMP2"><a href="" target="mainFrame">Payslip & EA Form</a>
			<ul class="sub-menu">
					<li id="itemMP2" class="itemMP2"><a href="/eleave/payslip/printpayslip.cfm" target="mainFrame">Print Pay Slip</a></li>
					<li id="itemMP2" class="itemMP2"><a href="/eleave/EA/ealisting_main.cfm" target="mainFrame">Print EA Form</a></li>
			</ul>
		</li>
		<li id="itemMP3" class="itemMP3"><a href="" target="mainFrame">Leave</a>
			<ul class="sub-menu">
					<li id="itemMP3" class="itemMP3"><a href="/eleave/selectjo.cfm?type=leave" target="mainFrame">Submit Leave</a></li>
					<li id="itemMP3" class="itemMP3"><a href="/eleave/beps/leavestatus.cfm" target="mainFrame">Leave Status</a></li>
			</ul>
		</li>
		<li id="itemMP4" class="itemMP4"><a href="" target="mainFrame">Claim</a>
			<ul class="sub-menu">
					<li id="itemMP4" class="itemMP4"><a href="/eleave/selectjo.cfm?type=claim" target="mainFrame">Submit Claim</a></li>
					<li id="itemMP4" class="itemMP4"><a href="/eleave/beps/claimstatus.cfm" target="mainFrame">Claim Status</a></li>
			</ul>
		</li>
		<li id="itemMP4" class="itemMP4"><a href="" target="mainFrame">Timesheet</a>
			<ul class="sub-menu">
					<li id="itemMP4" class="itemMP4"><a href="/eleave/bepsnew/selecttimesheet.cfm" target="mainFrame">Update Timesheet</a></li>
			</ul>
		</li>
	</ul>
</div>
<div id="bottomDiv" class="bottomNavigationDiv">

</div>
</cfoutput>
</body>
</html>