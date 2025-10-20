<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfform action="#cgi.script_name#" preservedata="Yes" format="html">
   <cftree name="Menu" height="400" width="140" align="left"
      font="courier" italic="no" highlighthref="yes" HScroll="yes" VScroll="no"
      completepath="no" lookandfeel="windows" border="No" required="no">
         <cftreeitem value="pm" Display="Payments" expand="yes">
			<cftreeitem parent="pm" value="pm1" Display="1st Half Payroll" >
            <cftreeitem parent="pm" value="pm2" Display="2nd Half Payroll" >
            <cftreeitem parent="pm" value="pm3" Display="Bonus" >
            <cftreeitem parent="pm" value="pm4" Display="Commission" >
            <cftreeitem parent="pm" value="pm5" Display="Extra" >
		
		<cftreeitem value="ps" Display="Personnel" expand="yes">
			<cftreeitem parent="ps" value="ps1" Display="Add/Update Employees" >
            <cftreeitem parent="ps" value="ps2" Display="Update Leave/Fund Entitled" img="">
            <cftreeitem parent="ps" value="ps3" Display="Update Allowance & Deduction" >
            <cftreeitem parent="ps" value="ps4" Display="Commission" >
            <cftreeitem parent="ps" value="ps5" Display="Extra" >
   </cftree>
</cfform>
</body>
</html>
