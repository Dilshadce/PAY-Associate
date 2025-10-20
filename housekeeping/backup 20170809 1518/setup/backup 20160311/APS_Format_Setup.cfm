<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<title>APS Format Setup</title>
<link rel="shortcut icon" href="/PMS.ico" />
</head>



<body>
<div class="mainTitle">APS Format Setup</div>
<div class="subTitle"></div>

<cfquery name="bank_data_qry" datasource="#dts#">
SELECT *  FROM aps_set a;
</cfquery>


<br><br>


<cfoutput>
<form name="pform" action="" method="post">
<table width="1000">
<tr>
	<td>APS Number : </td>
	<td>
		<select name="APS_NUM" onChange="window.frames['aps_data'].location ='/housekeeping/setup/APS_data.cfm?id='+this.value;">	
			<cfloop query="bank_data_qry">
				
			<option value="#bank_data_qry.entryno#" >#bank_data_qry.entryno#-#bank_data_qry.APSBank#</option>
			</cfloop>
		</select>
	</td>
	</tr>
<tr>
	<td colspan="2">
		<cfset firstID = "1">
	<iframe src ="/housekeeping/setup/APS_data.cfm?id=#firstID#" name="aps_data" id="aps_data" width="100%" height="900" frameborder="0" scrolling ="no">
	</iframe>
	</td></tr>
</table>
</form></cfoutput>

