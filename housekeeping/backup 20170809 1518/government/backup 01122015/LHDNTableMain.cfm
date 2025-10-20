<!DOCTYPE html PUBLIC "-//W3C//DTD XHTL 1.0 Transitional//EN" "http://www.w3.org/TR/xhtl1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Deduction Table</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script language="javascript">
	function copyStr(obj){
		for(var i=1;i<2;i++){document.getElementById('t'+i+obj.name).value=obj.value;}
	}
	</script>
</head>

<body>
<div class="mainTitle">PCB Table</div>
<cfquery name="pcb_qry" datasource="#dts#">
SELECT * FROM pcbtable order by entryno
</cfquery>

<cfif isdefined("form.status")>
		<script type="text/javascript">
			window.parent.frames("topFrame").location.reload();
		</script>
		<cfoutput><font color="red" size="2.5">#form.status#</font></cfoutput>
	</cfif>
    <form name="pcbForm" action="LHDNTablemain_process.cfm" method="post">
		<div style="height:300px;overflow:auto;">
		<table>
        <cfoutput>
			<tr>
				<th>P From (RM)</th>
                <th>P To (RM)</th>
				<th>M(RM)</th>
				<th>R (%)</th>
                <th>Category 1 (RM)</th>
                <th>Category 2 (RM)</th>
                <th>Category 3 (RM)</th>
			</tr>
        </cfoutput>
        <cfoutput query="pcb_qry">
        <tr>
				<td><input type="text" name="pfrom#pcb_qry.entryno#" value="#pcb_qry.pfrom#" onkeyup="copyStr(this)" size="15" maxlength="12" /></td>
				<td><input type="text" name="pto#pcb_qry.entryno#" value="#pcb_qry.pto#" size="15" maxlength="12" /></td>
                <td><input type="text" name="mamount#pcb_qry.entryno#" value="#pcb_qry.mamount#" size="15" maxlength="12" /></td>
                <td><input type="text" name="ramount#pcb_qry.entryno#" value="#pcb_qry.ramount#" size="15" maxlength="12" /></td>
                <td><input type="text" name="category1#pcb_qry.entryno#" value="#pcb_qry.category1#" size="15" maxlength="12" /></td>
                <td><input type="text" name="category2#pcb_qry.entryno#" value="#pcb_qry.category2#" size="15" maxlength="12" /></td>
				<td><input type="text" name="category3#pcb_qry.entryno#" value="#pcb_qry.category3#" size="15" maxlength="12" /></td>
			</tr>
        </cfoutput>
			</table>
			</div>
            <cfoutput>
	<center>
		<input type="submit" name="submit" value="OK">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/body/bodymenu.cfm?id=236'">
	</center>
	</cfoutput>
	</form>
</body>

</html>