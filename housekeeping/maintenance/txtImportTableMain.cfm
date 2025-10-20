<!---cfscript>
	ti_qry = event.getArg('txtImportData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Txt Import Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<cfoutput>
	<script language="javascript">
	var row = 0;
	function appendRow()
	{
		//var tbl = document.getElementById(tblId);
		var tbl = document.getElementById('tit');
		var newRow = tbl.insertRow(tbl.rows.length);
		var count = parseInt(document.getElementById('count').value) + 1;
		document.getElementById('count').value = count;
		row=row+1;
		var newCel0 = newRow.insertCell(0);
		newCel0.innerHTML = '<input type="text" name="ndfield__r'+row+'" size="15" maxlength="12" />';
		var newCel1 = newRow.insertCell(1);
		newCel1.innerHTML = '<input type="text" name="niformula__r'+row+'" size="60" maxlength="75" />';
	}
	
	function confirmDelete(entryno,type) {
	var answer = confirm("Confirm Delete?")
	if (answer){
		window.location = "/housekeeping/maintenance/txtImportTableMain_process.cfm?type="+type+ "&entryno="+entryno;
		}
	else{
		
		}
	}
	
	</script>
</cfoutput>
</head>

<body>
	<div class="mainTitle">Txt Import Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="tiForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="ti_qry" datasource="#dts#">
	SELECT * FROM imptable
	</cfquery>
	<form name="eForm" action="/housekeeping/maintenance/txtImportTableMain_process.cfm" method="post">
		<input type="hidden" name="count" id="count" value="0" >
		<table id="tit" class="form" border="0">
		<tr>
			<th width="100px">DBF Field</th>
			<th width="380px">Formula</th>
			<th width="50">Action</th>
		</tr>
		<cfoutput query="ti_qry">
		<tr>
			<td><input type="hidden" name="entryno" value="#ti_qry.entryno#">
				<input type="text" name="dfield__r#entryno#" value="#ti_qry.dfield#" size="15" maxlength="12"></td>
			<td><input type="text" name="iformula__r#entryno#" value="#ti_qry.iformula#" size="60" maxlength="65"></td>
			<cfif ti_qry.entryno gt 15>
			<td>
				<a href="##" onclick="confirmDelete('#ti_qry.entryno#','del')">
				<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>			
			</td>
			</cfif>
		</tr>
		</cfoutput>
		</table>
	<br />
	<cfoutput>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="button" name="add" value="ADD" onClick="appendRow()">
		<input type="submit" name="save" value="Save">
		<input type="button" name="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
		<!---input type="submit" value="#event.getArg('submitLabel', '')#" /--->
	</center>
	
	<!-- need these if there's an error with the required fields so they'll be available in the next event -->
	<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
	</cfoutput>
	</form>
</body>
</html>
