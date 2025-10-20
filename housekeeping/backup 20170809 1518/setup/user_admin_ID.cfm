<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<title>USER GROUP MAINTANANCE</title>
	<script>
	function edit(entryno)
	{
		window.location="user_admin_ID.cfm?type=edit&entryno="+entryno;	
	}
	function comfirmdelete(type,entryno)
	{
		var answer = confirm("Confirm Delete?")
		if (answer){
			
			window.location = "user_admin_ID.cfm?type="+type+ "&entryno="+entryno;
		}
		else{
			
		}	
	}
	</script>
</head>

<body>

<cfquery name="user_qry" datasource="#dts#">
SELECT * FROM userpin u;
</cfquery>
<CFOUTPUT>
<div>Maintainance User Pin</div>
<table >
<tr><td colspan="2">&nbsp</td></tr>
<tr><th width="200px">USER ID</th><Th>PIN</Th></tr>

<cfloop query="user_qry">
<TR ONclick="edit('#user_qry.entry#');">
	<TD >#user_qry.userGroup#</TD>
	<td><input type="text" name="pin_#user_qry.entry#" value="#user_qry.PIN#" size="1" maxlength="1" /></td>
</TR>
</cfloop>

<cfif isdefined("url.type")>
	<cfif url.type eq "add_qry">
		<cfquery name="insert_qry" datasource="#dts#">
			INSERT INTO userpin (usergroup, pin) values("#form.userid_a#", "#form.pin_a#")
		</cfquery>
		<cflocation url="user_admin_ID.cfm">
	<cfelseif url.type eq "up_qry">
		<cfquery name="insert_qry" datasource="#dts#">
			update userpin set pin="#form.pin_u#"
			where entry="#form.entry#"
		</cfquery>
		<cflocation url="user_admin_ID.cfm">
	<cfelseif url.type eq "del">
		<cfquery name="insert_qry" datasource="#dts#">
			delete from userpin 
			where entry="#url.entryno#"
		</cfquery>
		<cflocation url="user_admin_ID.cfm">
		
	<cfelseif url.type eq "add">
	
	<tr><td colspan="2">
			<form method="post" action="user_admin_ID.cfm?type=add_qry" name="aform">
			<table>
				<tr><th>USER ID</th>
					<td><input type="text" id="userid_a" name="userid_a" value=""></td>
					<th>PIN</th>
					<td><input type="text" id="pin_a" name="pin_a" value="" size="1" maxlength="1" /></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<cfelseif url.type eq "edit">
	<cfquery name="user_qry_update" datasource="#dts#">
		SELECT * FROM userpin where entry="#url.entryno#";
	</cfquery>
	<tr>
		<td colspan="2">
			<form method="post" action="user_admin_ID.cfm?type=up_qry" name="aform">
			<table>
				<input type="hidden" id="entry" name="entry" value="#url.entryno#">
				<tr><th>USER ID</th>
					<td><input type="text" name="userid_u" value="#user_qry_update.userGroup#" readonly/></td>
					<th>PIN</th>
					<td><input type="text" name="pin_u" value="#user_qry_update.pin#" size="1" maxlength="1" /></td>
				</tr>
			</table>
		</td>
	</tr>
	</cfif>
</cfif>

<tr>
	<td colspan="2">
	
			<input type="button" name="addbutton" value="Add" 
        		onclick="window.location = 'user_admin_ID.cfm?type=add'">
				<cfif isdefined("url.type")>
					<cfif url.type eq "add" or url.type eq "edit" >
						<input type="submit" name="submit" value="save">
					</cfif>
					<cfif url.type eq "edit">
						<input type="button" name="delete" value="delete" onclick="comfirmdelete('del','#url.entryno#')">
					</cfif>
					<input type="button" id='delbutton' name="delbutton" value="Cancel" 
        			onclick="window.location = 'user_admin_ID.cfm'"</td>
				<cfelse>
					<input type="button" name="delbutton" value="Cancel" 
	        		onclick="window.location = '/housekeeping/setupList.cfm'"></td>
				</cfif>
</tr></form>
</table>
</CFOUTPUT>