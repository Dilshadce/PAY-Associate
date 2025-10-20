<html>
<head>
	<title>Payroll System</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
	<link href="/stylesheet/header.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/header.js" language="javascript"></script>
    
    
</head>

<!--- <cfquery name="lastLogin" datasource="payroll_main">
SELECT * FROM USERS
WHERE entryID = "#HEntryID#"
</cfquery> --->

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../images/home_btn_Dwn.png','../images/logout_btn_Dwn.png','../images/contact_btn_Dwn.png')">
  	<!--DWLayoutTable-->
    
    <img src="/images/netiquette_logo.png" BORDER="0" ALIGN="LEFT" alt="Payroll System">
    

<!--- <h6>
		<div align="left">Welcome, <cfoutput> #variables.ses_user.getUserName()#. Login On: #DayOfWeekAsString(DayOfWeek(ses_user.getLastLogin()))#,  #DateFormat(ses_user.getLastLogin(), "dd-mm-yyyy")#, #TimeFormat(ses_user.getLastLogin(), "HH:MM:SS")#</cfoutput></div>
		<br> 
  		<!--- HQ Location: <strong><font size="2"><cfoutput>#Hhqlocation#</cfoutput></font></strong>  --->
		<div align="right">
			<cfif ses_user.getUserID() eq "weesiong"><a href="../index.cfm?event=showMain&reloadapp=" target="mainFrame">Reload</a></cfif>
		</div>
</h6> --->
<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<h5>
<div align="left">Welcome, <cfoutput>#HUserName#. Login On: #DayOfWeekAsString(DayOfWeek(now()))#,  #DateFormat(now(), "dd-mm-yyyy")#, #TimeFormat(now(), "HH:MM:SS")#</cfoutput><br><br/><cfoutput><font face="Times New Roman, Times, serif" size="3" color="##3300FF">#company_details.comp_name#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Company ID : #company_details.comp_id#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;System Month:#company_details.mmonth#&nbsp;&nbsp; System Year:#company_details.myear#&nbsp;&nbsp;</font></cfoutput>  <div align="right">
    <a href="/main.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('homeBtn','','../images/home_btn_Dwn.png',1)"><img src="../images/home_btn_Up.jpg" alt="Main Page" name="homeBtn" border="0"></a><a href="/contact.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('contactBtn','','../images/contact_btn_Dwn.png',1)"><img  src="../images/contact_btn_Up.jpg" alt="Contact Us!" name="contactBtn" border="0"></a><a href="/help.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('helpbtn','','../images/help_down.jpg',1)"><img  src="../images/help_up.jpg" alt="Help!" name="helpbtn" border="0"></a><a href="/logout.cfm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('logoutBtn','','../images/logout_btn_Dwn.png',1)" target="_parent"><img src="../images/logout_btn_Up.jpg" alt="Logging Off" name="logoutBtn" border="0"></a></div></div>
</h5>
  

</body>
</html>