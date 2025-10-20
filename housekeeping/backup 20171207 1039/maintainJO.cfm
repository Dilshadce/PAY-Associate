<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
				
<title>Approval Setup</title>
</head>
<body>
<cfoutput>

<div class="mainTitle" style="text-transform:uppercase">Approval Setup</div>
<font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
<cfform action="/housekeeping/maintainJOprocess.cfm" method="post">
<table class="form">
    <tr>
        <td width="100px">User ID:</td>
        <td>#HUserID#</td>
    </tr>
    <tr>
        <td>User Name:</td>
        <td>#HUserName#</td>
    </tr>
</table>
<br />
<br />

<cfquery name="getdata" datasource="#dts#">
SELECT approvaltype FROM payroll_main.hmusers WHERE userid = '#HUserID#'
</cfquery>

<table>
    <tr>
        <th>Sign Off Type : </th>
        <td><select id="approvaltype" name="approvaltype">
            <option value="1" <cfif getdata.approvaltype eq 1>selected</cfif> >1 - Click Approve Button</option>
            <option value="2" <cfif getdata.approvaltype eq 2>selected</cfif> >2 - Digital Signature</option>
            <option value="3" <cfif getdata.approvaltype eq 3>selected</cfif> >3 - Upload Signed Document</option>
        </select>
        </td>
    </tr>
</table>
<br />
<br />
&nbsp;&nbsp;&nbsp;<cfinput type="submit" name="submit" id="submit" value="Save" size="6" > <!---style="visibility:hidden"---> 
</cfform>
</cfoutput>
</body>
</html>