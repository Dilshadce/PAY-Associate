<!DOCTYPE html PUBLIC "-//W3C//DTD XHTL 1.0 Transitional//EN" "http://www.w3.org/TR/xhtl1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>PCB Table</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

    <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest Rate?');
	if(answer)
	{
	window.location.href="updatepcb.cfm";
	}
	
	}
    </script>
    
</head>
<body>
<cfoutput>
<div class="mainTitle">PCB Table</div>
    <cfquery name="pcb_qry" datasource="#dts#">
	    SELECT * FROM pcbtable order by entryno
    </cfquery>
   
    <form name="pcbForm" action="LHDNTableMain_process.cfm" method="post">
	<table>
        <tr>
            <th>From</th>
            <th>To</th>
            <th>M</th>
            <th>R(%)</th>
            <th>Category 1</th>
            <th>Category 2</th>
            <th>Category 3</th>
       </tr>
        
        <cfloop query="pcb_qry">
        <tr>
            <td><input type="text" name="pfrom#pcb_qry.entryno#" value="#pcb_qry.pfrom#" size="15" maxlength="10" /></td>
            <td><input type="text" name="pto#pcb_qry.entryno#" value="#pcb_qry.pto#" size="15" maxlength="10" /></td>
            <td><input type="text" name="mamount#pcb_qry.entryno#" value="#pcb_qry.mamount#" size="15" maxlength="10" /></td>
            <td><input type="text" name="ramount#pcb_qry.entryno#" value="#pcb_qry.ramount#" size="8" maxlength="8" /></td>
            <td><input type="text" name="category1#pcb_qry.entryno#" value="#pcb_qry.category1#" size="15" maxlength="10" /></td>
            <td><input type="text" name="category2#pcb_qry.entryno#" value="#pcb_qry.category2#" size="15" maxlength="10" /></td>
            <td><input type="text" name="category3#pcb_qry.entryno#" value="#pcb_qry.category3#" size="15" maxlength="10" /></td>
        </tr>
        </cfloop>

    	<tr><td colspan="7"><br /></td></tr>
        <tr><th colspan="7">Deductions</th></tr>
        <tr>
            <td>Disabled</td>
            <td><input type="text" name="disab" value="#pcb_qry.disab#"  size="5" maxlength="10" /></td>
		</tr>
        <tr>
            <td>Spouse Disabled</td>
            <td><input type="text" name="sdisab" value="#pcb_qry.sdisab#" size="5" maxlength="10" /></td>
		</tr>
        <tr>
            <td>Child below 18 </td>
            <td><input type="text" name="child18" value="#pcb_qry.child18#" size="5" maxlength="10" /></td>
		</tr>
            <td>Child Study</td>
            <td><input type="text" name="childstdy" value="#pcb_qry.childstdy#" size="5" maxlength="10" /></td>
		</tr>
            <td>Child High Edu</td>
            <td><input type="text" name="childhedu" value="#pcb_qry.childhedu#" size="5" maxlength="10" /></td>
		</tr>
            <td>Child Disabled</td>
            <td><input type="text" name="cdisab" value="#pcb_qry.cdisab#" size="5" maxlength="10" /></td>
		</tr>
            <td>Child Disabled and Study</td>
            <td><input type="text" name="cdisabstdy" value="#pcb_qry.cdisabstdy#" size="5" maxlength="10" /></td>
		</tr>
        <tr>
            <td>Category 1</td>
            <td><input type="text" name="cate1" value="#pcb_qry.cate1#" size="5" maxlength="10" /></td>
		</tr>
            <td>Category 2</td>
            <td><input type="text" name="cate2" value="#pcb_qry.cate2#" size="5" maxlength="10" /></td>
		</tr>
            <td>Category 3</td>
            <td><input type="text" name="cate3" value="#pcb_qry.cate3#" size="5" maxlength="10" /></td>
		</tr>
		</tr>
            <td>EPF</td>
            <td><input type="text" name="epfcap" value="#pcb_qry.epfcap#" size="5" maxlength="10" /></td>
		</tr>

        <tr><td colspan="7" align="center">
		<input type="submit" name="submit" value="Save" />
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	    <input type="button" name="update" value="UPDATE NEW RATE" onClick="updateconfirm()" />
	    </td></tr>
    </table>


	</form>

</cfoutput>
</body>

</html>