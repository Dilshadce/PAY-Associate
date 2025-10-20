<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Left Menu</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/left.css" rel="stylesheet" type="text/css">

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
<div id="masterdiv">
	<div class="menutitle" onClick="SwitchMenu('sub2')">Leave</div>
	<span class="submenu" id="sub2">
  		<li><a class="sub" href="/Eleave/beps/leavestatus.cfm" target="mainFrame">Leave Status</a></li>
    </span>
	<div class="menutitle" onClick="SwitchMenu('sub3')">Pay Slip</div>
	<span class="submenu" id="sub3">
		<li><a class="sub" href="/Eleave/beps/printpayslip.cfm" target="mainFrame">Print Pay Slip</a></li>
	</span>
    <div class="menutitle" onClick="SwitchMenu('sub4')">Time Sheet</div>
	<span class="submenu" id="sub4">
  		<li><a class="sub" href="/Eleave/beps<cfif DSNAME eq "bepstest_p">new</cfif>/<cfif DSNAME eq "bepstest_p">select</cfif>timesheet.cfm" target="mainFrame">Update Time Sheet</a></li>
    </span>
</cfoutput>
</body>
</html>
