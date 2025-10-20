<!---cfscript>
	ti_qry = event.getArg('txtImportData');
</cfscript--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Piece Rate Table</title>
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
		newCel0.innerHTML = '<input type="text" name="nprcode__r'+row+'" size="15" maxlength="12" />';
		var newCel1 = newRow.insertCell(1);
		newCel1.innerHTML = '<input type="text" name="nprdesp__r'+row+'" size="88" maxlength="75" />';
		var newCel2 = newRow.insertCell(2);
		newCel2.innerHTML = '<input type="text" name="nxrate__r'+row+'" size="25" maxlength="9" />';
		var newCel3 = newRow.insertCell(3);
		newCel3.innerHTML = '<input type="text" name="nyrate__r'+row+'" size="25" maxlength="9" />';
	}
	
	function confirmDelete(entryno,type) {
	var answer = confirm("Confirm Delete?")
	if (answer){
		window.location = "/housekeeping/maintenance/pieceRateTable_process.cfm?type="+type+ "&entryno="+entryno;
		}
	else{
		
		}
	}
	
	</script>
</cfoutput>
</head>

<body>
	<div class="mainTitle">Piece Rate Table</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif>
	<cfform name="tiForm" action="../index.cfm?event=#event.getArg('xe.submit')#" method="post"--->
	<cfquery name="pc_qry" datasource="#dts#">
	SELECT * FROM pctab2
	</cfquery>
	<form name="eForm" action="/housekeeping/maintenance/pieceRateTable_process.cfm" method="post">
		<input type="hidden" name="count" id="count" value="0" >
		<table id="tit" class="form" border="0">
		<tr>
			<th width="110px">Code</th>
			<th width="540px">Description</th>
			<th width="150px">X Rate</th>
			<th width="150px">Y Rate</th>
			<th width="">Action</th>
		</tr>
		<cfoutput query="pc_qry">
		<tr>
			<td><input type="hidden" name="entryno" value="#pc_qry.entryno#">
				<input type="text" name="pccode__r#entryno#" value="#pc_qry.pc_code#" size="15" maxlength="12"></td>
			<td><input type="text" name="pcdesp__r#entryno#" value="#pc_qry.pc_desp#" size="90" maxlength="65"></td>
			<td><input type="text" name="xrate__r#entryno#" value="#pc_qry.pc_xrate#" size="25" maxlength="9"></td>
			<td><input type="text" name="yrate__r#entryno#" value="#pc_qry.pc_yrate#" size="25" maxlength="9"></td>
			<td>
				<a href="##" onclick="confirmDelete(#pc_qry.entryno#,'del')">
				<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>			
			</td>
		</tr>
		</cfoutput>
		</table>
	<br />
	<cfoutput>
	<center>
		<!--- <input type="reset" name="reset" value="Reset"> --->
		<input type="button" name="add" value="ADD" onClick="appendRow()">
		<input type="submit" name="save" value="Save">
		<input type="button" name="exit" value="Exit" onclick="window.location='/housekeeping/setupList.cfm'">
		<!---input type="submit" value="#event.getArg('submitLabel', '')#" /--->
	</center>
	
	<!-- need these if there's an error with the required fields so they'll be available in the next event -->
	<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
	</cfoutput>
	</form>
</body>
</html>
