<cfif isdefined("url.type")>
	<cfif url.type eq "add_qry">
		<cfquery name="check_code" datasource="#dts#">
			SELECT * FROM tax_relief
		</cfquery>
		<cfset v = 1>
		<cfloop query="check_code">
			<cfif check_code.code eq "#form.code_add#">
				<cfset v = 0>
				<cfset status_msg="Code exist, please using other code.">
				<cfoutput>	<form name="pc"  action="TaxReliefTableMain.cfm?" method="post">
							<input type="hidden" name="status" value="#status_msg#" />
						</form>
				</cfoutput>
				<script>
					 pc.submit();
				</script>
			</cfif>
		</cfloop>
		
		<cfif v neq 0>		
			<cfquery name="insert_tax_relief_qry" datasource="#dts#">
				Insert into tax_relief (code, description, capping) values 
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.code_add#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp_add#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.capping_add,'.__')#">)
			</cfquery>
			<cflocation url="taxReliefTableMain.cfm">
		</cfif>
	
	<cfelseif url.type eq "update_qry">
		<cfquery name="update_tax_relief_qry" datasource="#dts#">
			UPdate tax_relief 
			set description =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp_add#">,
				capping = <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(form.capping_add,'.__')#">
			where code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.code_add#">
		</cfquery>
		<cflocation url="taxReliefTableMain.cfm">
		
	</cfif>	
</cfif>

<html>
<head>
	<title>Tax Relief Main</title>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script>
		function edit(entryno)
		{
			window.location="taxReliefTableMain.cfm?type=edit&entryno="+entryno;	
		}
	</script>


</head>
<div>Tax Relief Main</div><br>
<cfquery name="tax_relief_qry" datasource="#dts#">
	select * from tax_relief order by code
</cfquery>
<body>
	<cfif isdefined("form.status")>
		<script type="text/javascript">
			window.parent.frames("topFrame").location.reload();
		</script>
		<cfoutput><font color="red" size="2.5">#form.status#</font></cfoutput>
	</cfif>
	
	<cfoutput>
		<div style="height:300px;overflow:auto;">
		<table>
			<tr>
				<th>Code</th>
				<th>Description</th>
				<th>Capping</th>
			</tr>
			<cfloop query="tax_relief_qry">
				<tr ONclick="edit('#tax_relief_qry.code#');">
					<td><input type="text" name="code" id="code" value="#tax_relief_qry.code#" size="15" readable/></td>
					<td ><input type="text" name="desp" id="desp" value="#tax_relief_qry.description#" size="30"></td>
					<td align="right"><input type="text" name="capping" id="capping" value="#tax_relief_qry.capping#" size="10"></td>
				</tr>
			</cfloop>
			</table>
			</div>
				<table>
				<cfif isdefined("url.type")>
					<cfif url.type eq "add">
						<tr><th>ADD NEW TAX ITEM</th></tr>
						<form name='aform' method="post" action="taxReliefTableMain.cfm?type=add_qry" >
						<tr>
							<td><input type="text" name="code_add" id="code_add" value="" size="15" readable/></td>
							<td><input type="text" name="desp_add" id="desp_add" value="" size="30"></td>
							<td align="right"><input type="text" name="capping_add" id="capping_add" value="" size="10"></td>
						</tr>
						
					<cfelseif url.type eq "edit">
						<cfquery name="code_tax_relief_qry" datasource="#dts#">
							select * FROM tax_relief WHERE code =<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entryno#">
						</cfquery>
						<form name='aform' method="post" action="taxReliefTableMain.cfm?type=update_qry" >
						<tr><th>UPDATE TAX ITEM</th></tr>
						<tr>
							<td><input type="text" name="code_add" id="code_add" value="#code_tax_relief_qry.code#" size="15" readable/></td>
							<td><input type="text" name="desp_add" id="desp_add" value="#code_tax_relief_qry.description#" size="30"></td>
							<td align="right"><input type="text" name="capping_add" id="capping_add" value="#code_tax_relief_qry.capping#" size="10"></td>
						</tr>		
					</cfif>
				</cfif>
				</table>
			
			<table>
			<tr>
				<td></td>
				<td>
					<cfif isdefined("url.type") >
						<cfif url.type eq "add" or url.type eq "edit">
							<input type="submit" name="submit" id="submit" value="save" onclick="validate_form();">
							<input type="button" name="canbutton" value="Cancel" 
	        					onclick="window.location = '/housekeeping/setupList.cfm'">
							</form>
						</cfif>
					<cfelse>	
						<input type="button" name="addbutton" value="Add" 
	        				onclick="window.location = 'TaxReliefTableMain.cfm?type=add'">
						<input type="button" name="canbutton" value="Cancel" 
	        				onclick="window.location = '/housekeeping/setupList.cfm'">
					</cfif>
				</td>
				<td></td>
			</tr>
		</table>
		
	
	</cfoutput>
</body>
</html>