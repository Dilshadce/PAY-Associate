<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Payroll Management System</title>
<link rel="stylesheet" href="/css/hoverscroll/jquery.hoverscroll.css" />
<link rel="stylesheet" href="/css/side/side.css" />
<link rel="stylesheet" href="/css/side/sidemenu.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/hoverscroll/jquery.hoverscroll.js"></script>
<script type="text/javascript" src="/js/side/sidemenu.js"></script>

<script type="text/javascript">
if (document.getElementById){ 
	document.write('<style type="text/css">\n')
	document.write('.submenu{display: none;}\n')
	document.write('</style>\n')
}

function SwitchMenu(obj){
	if(document.getElementById){
		var el = document.getElementById(obj);
		var ar = document.getElementById("masterdiv").getElementsByTagName("span"); 
		if(el.style.display != "block"){ 
			for (var i=0; i<ar.length; i++){
				if (ar[i].className=="submenu") 
				ar[i].style.display = "none";
			}
			el.style.display = "block";
		}else{
			el.style.display = "none";
		}
	}
}
</script>
</head>

<body>
<cfoutput>
<div id="logo_div" class="section"><a href="" target="_blank"><img alt="PMS Logo" src="/img/pmslogo.png" /></a></div>
<div class="section">
	<ul id="menu" class="accordion">
	<div class="accordion" onClick="SwitchMenu('sub2')">Personal</div>
	<span class="sub-menu" id="sub1">
  		<li><a class="sub" href="/Eleave/personal/personalDetails.cfm" target="mainFrame">Personal Particular</a></li>
        <li><a class="sub" href="/Eleave/personal/personalAccount.cfm" target="mainFrame">Maintaince Account</a></li>
    	<li><a class="sub" href="/Eleave/personal/personalHistory.cfm" target="mainFrame">Leave History</a></li>
		
    </span>

	<div class="accordion" onClick="SwitchMenu('sub2')">Leave</div>
	<span class="sub-menu" id="sub2">
  		<li><a class="sub" href="/eleave/leave/leaveApplication.cfm" target="mainFrame">Apply Leave</a></li>
		<li><a class="sub" href="/Eleave/leave/leaveApplicationStatus.cfm" target="mainFrame">Leave Application Status</a></li>
		<li><a class="sub" href="/Eleave/leave/leaveBalance.cfm" target="mainFrame">Leave Balance</a></li>
		<li><a class="sub" href="/Eleave/leave/personal_leave_record .cfm" target="mainFrame">Personal Leave Record</a></li>
    </span>
	<div class="accordion" onClick="SwitchMenu('sub3')">Pay Slip</div>
	<span class="sub-menu" id="sub3">
		<li><a class="sub" href="/Eleave/paySlip/printPaySlip.cfm" target="mainFrame">Print Pay Slip</a></li>
	</span>
	
	<div class="accordion" onClick="SwitchMenu('sub4')">Claim Menu</div>
	<span class="sub-menu" id="sub4">
    	<li><a class="sub" href="/Employee/createlist.cfm?type=mcreate" target="mainFrame">Submit Claim</a></li>
		<li><a class="sub" href="/Employee/index.cfm" target="mainFrame">Claim Status</a></li>
	</span>
	
</cfoutput>
</body>
</html>
