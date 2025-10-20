<cfif isdefined("url.type")>
	<cfif url.type eq "update">
		<cfloop from="1" to="50" index="i">
			
			<cfquery name="update_rngtble_qry" datasource="#dts#">
				update rngtable 
				set socpayf ="#evaluate('form.socpayf__#i#')#",
					socpayt ="#evaluate('form.socpayt__#i#')#",
					socyee1 ="#evaluate('form.socyee1__#i#')#",
					socyer1 ="#evaluate('form.socyer1__#i#')#",
					socyee2 ="#evaluate('form.socyee2__#i#')#",
					socyer2 ="#evaluate('form.socyer2__#i#')#",
					socyee3 ="#evaluate('form.socyee3__#i#')#",
					socyer3 ="#evaluate('form.socyer3__#i#')#",
					socyee4 ="#evaluate('form.socyee4__#i#')#",
					socyer4 ="#evaluate('form.socyer4__#i#')#"    
				where entryno="#i#"
			</cfquery>
		</cfloop>	
	</cfif>
</cfif>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Socso Table Maintainance</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>
<body>
	<cfoutput>
	<cfquery name="rngtable_qry" datasource="#dts#">
		SELECT entryno, socpayf, socpayT,socyee1,socyer1,socyer2,socyee2, socyer3,socyee3, socyer4,socyee4 
		FROM rngtable 
	</cfquery>
	<div class="mainTitle">Socso Table</div>
	<form action="socsotablemain.cfm?type=update" method="post" name="aform">
	
		<div class="tabber">
			<div class="tabbertab">
				<h3>1. ACCIDENT AND DISABLE </h3>
				
				<Table>
					<tr>
						<th width="80">Pay From</th>
						<th width="80">Pay To</th>
						<th width="80">Employee</th>
						<th width="80">Employer</th>
					</tr>
				</table>	
				<div style="height:300px;overflow:auto;">
				<table>	
					<cfloop query="rngtable_qry">
						<tr>
							<td><input type="text" name="socpayf__#rngtable_qry.entryno#" id="socpayf__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayf),'.__')#" size="10"></td>
							<td><input type="text" name="socpayt__#rngtable_qry.entryno#" id="socpayt__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayt),'.__')#" size="10"></td>
							<td><input type="text" name="socyee1__#rngtable_qry.entryno#" id="socyee1__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyee1),'.__')#" size="10"></td>
							<td><input type="text" name="socyer1__#rngtable_qry.entryno#" id="socyer1__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyer1),'.__')#" size="10"></td>
						</tr>
					</cfloop>
				</table>
				</div>
			</div>
			<div class="tabbertab">
				<h3>2. DISABLE ONLY </h3>
				
				<Table>
					<tr>
						<th width="80">Pay From</th>
						<th width="80">Pay To</th>
						<th width="80">Employee</th>
						<th width="80">Employer</th>
					</tr>
				</table>	
				<div style="height:300px;overflow:auto;">
				<table>	
					<cfloop query="rngtable_qry">
						<tr>
							<td><input type="text" name="dsocpayf__#rngtable_qry.entryno#" id="dsocpayf__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayf),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="dsocpayt__#rngtable_qry.entryno#" id="dsocpayt__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayt),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="socyee2__#rngtable_qry.entryno#" id="socyee2__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyee2),'.__')#" size="10"></td>
							<td><input type="text" name="socyer2__#rngtable_qry.entryno#" id="socyer2__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyer2),'.__')#" size="10"></td>
						</tr>
					</cfloop>
				</table>
				</div>
			</div>
			<div class="tabbertab">
				<h3>3. ACCIDENCE ONLY </h3>
				
				<Table>
					<tr>
						<th width="80">Pay From</th>
						<th width="80">Pay To</th>
						<th width="80">Employee</th>
						<th width="80">Employer</th>
					</tr>
				</table>	
				<div style="height:300px;overflow:auto;">
				<table>	
					<cfloop query="rngtable_qry">
						<tr>
							<td><input type="text" name="asocpayf__#rngtable_qry.entryno#" id="asocpayf__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayf),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="asocpayt__#rngtable_qry.entryno#" id="asocpayt__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayt),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="socyee3__#rngtable_qry.entryno#" id="socyee3__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyee3),'.__')#" size="10"></td>
							<td><input type="text" name="socyer3__#rngtable_qry.entryno#" id="socyer3__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyer3),'.__')#" size="10"></td>
						</tr>
					</cfloop>
				</table>
				</div>
			</div>
			<div class="tabbertab">
				<h3>4. ACCIDENCE AND DISABLE</h3>
				
				<Table>
					<tr>
						<th width="80">Pay From</th>
						<th width="80">Pay To</th>
						<th width="80">Employee</th>
						<th width="80">Employer</th>
					</tr>
				</table>	
				<div style="height:300px;overflow:auto;">
				<table>	
					<cfloop query="rngtable_qry">
						<tr>
							<td><input type="text" name="adsocpayf__#rngtable_qry.entryno#" id="adsocpayf__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayf),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="adsocpayt__#rngtable_qry.entryno#" id="adsocpayt__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socpayt),'.__')#" size="10" readonly/></td>
							<td><input type="text" name="socyee4__#rngtable_qry.entryno#" id="socyee4__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyee4),'.__')#" size="10"></td>
							<td><input type="text" name="socyer4__#rngtable_qry.entryno#" id="socyer4__#rngtable_qry.entryno#" value="#numberformat(val(rngtable_qry.socyer4),'.__')#" size="10"></td>
						</tr>
					</cfloop>
				</table>
				</div>
			</div>
		</div>
		
		<br>
		&nbsp&nbsp&nbsp<input type="submit" name="save" id="save" value="Save">
		&nbsp&nbsp&nbsp<input type="button" name="cancel" id="cancel" value="Cancel" onclick="window.location='/housekeeping/setupList.cfm'">
	</form>
	</cfoutput>
</body>
</html>