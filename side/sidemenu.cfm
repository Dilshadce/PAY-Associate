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

<div id="logo_div" >
    <a href="" target="_blank">
        <img alt="PMS Logo" src="/img/pmslogo.png" width="177" />
    </a>
</div>
<div class="section">
	<ul id="menu" class="accordion">
		<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Maintenance</a>
			<ul class="sub-menu">
        		<li id="itemMP1" class="itemMP1"><a href="/housekeeping/maintainPassword.cfm" target="mainFrame">Change Password</a></li>
			<cfif getauthuser() eq "test2@gmail.com">
        		<li id="itemMP1" class="itemMP1"><a href="/housekeeping/maintainJO.cfm" target="mainFrame">Approval Setup</a></li>
</cfif>
            </ul>
		</li>	
        <li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Approval List</a>
			<ul class="sub-menu">
        		<li id="itemMP1" class="itemMP1"><a href="/approvallist.cfm" target="mainFrame">Approval List</a></li>
            </ul>
		</li>	
		<!---<li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Approval</a>
			<ul class="sub-menu">
        		<li id="itemMP1" class="itemMP1"><a href="/approval/timesheetapprovalmain.cfm" target="mainFrame">Timesheet Approval</a></li>
        		<li id="itemMP1" class="itemMP1"><a href="/approval/claimapprovalmain.cfm" target="mainFrame">Claim Approval</a></li>
        		<li id="itemMP1" class="itemMP1"><a href="/approval/leaveapprovalmain.cfm" target="mainFrame">Leave Approval</a></li>
            </ul>
		</li>--->
        <!---<cfif getauthuser() EQ "test3@gmail.com">--->
            <li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Approval</a>
                <ul class="sub-menu">
                    <li id="itemMP1" class="itemMP1"><a href="/approval2/timesheetapprovalmain.cfm" target="mainFrame">Timesheet Approval</a>
                    <li id="itemMP1" class="itemMP1"><a href="/approval2/leaveapprovalmain.cfm" target="mainFrame">Leave Approval</a></li>
                </ul>
            </li>
        <!---</cfif>--->
        <cfif getauthuser() EQ "test34@gmail.com" OR getauthuser() EQ "1rishi@my.ibm.com" OR getauthuser() EQ "hani@my.ibm.com">
            <li id="itemMP1" class="itemMP1"><a href="" target="mainFrame">Entitlement</a>
                <ul class="sub-menu">
                    <li id="itemMP1" class="itemMP1"><a href="/entitlement/leaveentitlement.cfm" target="mainFrame">Replacement Leave</a>
                </ul>
            </li>
        </cfif>
    </ul>
</div>

<div id="bottomDiv" class="bottomNavigationDiv">
<table>
<tr>
<td>&nbsp;&nbsp;</td>
<td><a target="_blank" href="https://www.facebook.com/ManpowerGroupMalaysia"><img src="/img/side/facebook.png" width="64" /></a></td>
<td>&nbsp;&nbsp;</td>
<td><a target="_blank" href="https://twitter.com/ManpowerMY"><img src="/img/side/twitter.png" width="64" /></a></td>
</tr>
<tr>
<td>&nbsp;&nbsp;</td>
<td><a target="_blank" href="https://www.linkedin.com/company/manpower-staffing-services"><img src="/img/side/linkedin.png" width="64" /></a></td>
<td>&nbsp;&nbsp;</td>
<td><a target="_blank" href="https://www.instagram.com/manpowergroup.my/"><img src="/img/side/instagram.png" width="64" /></a></td>
</tr>
</table>
<br />
</div>

</cfoutput>
</body>
</html>