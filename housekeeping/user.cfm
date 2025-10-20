<cfif left(trim(url.userId),5) eq "ultra" and husergrpid neq "super">
<cfabort>
</cfif>

<html>
<head>
<title>Create An Payroll User</title>
<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/pspl_multiselect.js"></script>
<link href="/stylesheet/pspl_multiselect.css" rel="stylesheet" type="text/css">

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_reply(this.recordset);</script>

<script language="JavaScript">
	function validate()
	{
		if(document.userForm.mode.value!='Delete')
		{
			if (document.userForm.userPwd.value!=document.userForm.rePwd.value)
			{
				alert("Your passwords does not tally. Please re-enter");
				document.userForm.userPwd.value='';
				document.userForm.rePwd.value='';
				document.userForm.userPwd.focus();
				return false;
			}
			if (document.userForm.mode.value == 'Edit' && husergrpid != 'super' && husergrpid != 'admin'){
				if(document.userForm.olduserPwd.value == ''){
					alert("Please enter your old password!");
					return false;
				}
			}
			return true;
		}
	}
	
	function checkpassword(){
		var userid = document.userForm.userID.value;
		var oldpwd = document.userForm.olduserPwd.value;
		document.all.feedcontact1.dataurl="databind/checkpwd.cfm?userid=" + userid + "&oldpwd=" + oldpwd;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();

	}
	
	function show_reply(rset){
 		rset.MoveFirst();
 		var error = rset.fields("error").value;
 		var msg = rset.fields("msg").value;
 		if(error == 1){
 			alert(msg);
 			document.userForm.olduserPwd.value='';
 			document.userForm.olduserPwd.focus();
 		}
 	}
 	
</script>
</head>

<body onLoad="document.userForm.userPwd.focus()">


<cfset mode = isdefined("url.type")>


<cfif url.type eq "Edit">
	<cfquery datasource='payroll_main' name="getUsers">
		select * 
		from users 
		where userId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userId#">;
	</cfquery>
	
	<cfif getUsers.recordcount gt 0>
		<cfoutput query="getUsers">
				<cfset userId = getUsers.userID>
			<cfset userName = getUsers.userName>
			<cfset userPwd = "">
			<cfset userCmpID = getUsers.userCmpID>
			<cfset userGrpID = getUsers.userGrpID>
			<cfset userDsn = getUsers.userDsn>
			<cfset userCty = getUsers.userCty>
			<cfset userEmail = getUsers.userEmail>
            <cfset getmail = getUsers.getmail>
			<cfset pilotrep = getUsers.pilotrep>
			<cfset mobile = getUsers.mobileaccess>
			<cfset lastlogin = getUsers.lastlogin>
			<cfset mode = "Edit">
			<cfset title = "Edit Users">
			<cfset button = "Edit">
		</cfoutput>
		
	<cfelse>
		<cfset status="Sorry, the user, #url.userId# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		
		<form name="done" action="vUser.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			done.submit();
		</script>
	</cfif>

<cfelseif url.type eq "Delete">
	<cfquery datasource='payroll_main' name="getUsers">
		select * 
		from users 
		where userId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userId#">;
	</cfquery>
	
	<cfif getUsers.recordcount gt 0>
		<cfoutput query="getUsers">
			<cfset userId = getUsers.userID>
			<cfset userName = getUsers.userName>
			<cfset userPwd = "">
			<cfset userCmpID = getUsers.userCmpID>
			<cfset userGrpID = getUsers.userGrpID>
			<cfset userDsn = getUsers.userDsn>
			<cfset userCty = getUsers.userCty>
            <cfset getmail = getUsers.getmail>
			<cfset userEmail = getUsers.userEmail>
			<cfset pilotrep = getUsers.pilotrep>
			<cfset mobile = getUsers.mobileaccess>
			<cfset lastlogin = getUsers.lastlogin>
			<cfset mode = "Delete">
			<cfset title = "Delete Users">
			<cfset button = "Delete">
		</cfoutput>
		
	<cfelse>
		<cfset status="Sorry, the user, #url.userId# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		
		<form name="done" action="vUser.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		
		<script language="javascript" type="text/javascript">
			done.submit();
		</script>
	</cfif>
</cfif>

<cfoutput><h1>#title#</h1></cfoutput>

<cfform name="userForm" action="userProcess.cfm" method="post" onsubmit="return validate();">
	<cfoutput>			
	<input type="hidden" name="mode" value="#mode#">
	<cfif isdefined("url.comid")>
		<input type="hidden" name="comid" value="#url.comid#">
	</cfif>
	
	
<table>	
<input type="hidden" name="userName" value="#userName#">
<input type="hidden" name="userID" value="#userId#">
<input type="hidden" name="userDsn" value="#userDsn#">
<input type="hidden" name="userCmpID" value="#userCmpID#">
<input type="hidden" name="userCty" value="#userCty#">
<tr> 
	<td width="150px">User Name </td>
	<td width="300px"><h2>#userID#</h2></tr>
	<cfif mode eq "Edit" and husergrpid neq "super">
			<tr> 
		<td width="150px">Enter Old Password :</td>
		<td width="300px"><input type="password" name="olduserPwd" value="" maxlength="10" size="20" onChange="checkpassword();"></td>
    		</tr>
	</cfif>
    	<tr> 
<td width="150px">Enter Password </td>
<td width="300px">
				<cfif mode eq "Delete">
					<input type="password" name="userPwd" value="#userPwd#" maxlength="10" size="20" readonly>
				<cfelse>
					<cfinput type="password" name="userPwd" value="#userPwd#" <!--- required="yes" message="Please Enter Password !" ---> maxlength="20" size="20">
				</cfif>
			</td>
    	</tr>
    	<tr> 
			<td width="150px">Enter Password Again</td>
			<td width="300px">
				<cfif mode eq "Delete">
					<input type="password" name="rePwd" value="#userPwd#" maxlength="10" size="20" readonly>
				<cfelse>
					<cfinput type="password" name="rePwd" value="#userPwd#" <!--- required="yes" message="Please Enter Re-Password !" ---> maxlength="20" size="20">
				
				</cfif>
			</td>
    	</tr>	
   
      	<tr> 
		<td width="150px">Email </td>
		<td width="300px"><cfinput name="userEmail" type="text" value="#userEmail#" message="Please Enter Correct Email Address !" validate="email" maxlength="35" size="35"></td>
		      	</tr>
				<tr>
		  <td>Choose UserGroup</td>
		  <td><select name="userGrpID">
			<cfif userGrpID eq "super">
				<cfoutput>
					<option value="super" #IIF(userGrpID eq "super",DE('selected'),DE(''))#>SUPER</option>
				</cfoutput>
			</cfif>
			<cfquery name="userpin_qry" datasource="#dts#">
				SELECT * from userpin
			</cfquery>
			<cfloop query="userpin_qry">
			<option value="#userpin_qry.usergroup#" #IIF(userGrpID eq "#userpin_qry.usergroup#",DE('selected'),DE(''))# >#userpin_qry.usergroup#</option>
		 	<!---<option value="USER" #IIF(userGrpID eq "USER",DE('selected'),DE(''))#>USER</option>
			<option value="Admin" #IIF(userGrpID eq "admin",DE('selected'),DE(''))#>ADMIN</option>--->
			</cfloop>
		  	</select>
		  </td>
		</tr>
        <tr>
        <td>Receive Email</td>
        <td>
        <input type="checkbox" name="getmail" id="getmail" value="Y" <cfif getmail eq "Y">checked</cfif>>
        </td>
        </tr>
        <tr>
        <td>Pilot Summary Report</td>
        <td>
        <input type="checkbox" name="pilotrep" id="pilotrep" value="Y" <cfif pilotrep eq "Y">checked</cfif>>
        </td>
        </tr>
        <tr>
        <td>Mobile Access</td>
        <td>
        <input type="checkbox" name="mobileaccess" id="mobileaccess" value="N" <cfif mobile eq "Y">checked</cfif>>
        </td>
        </tr>
		<tr> 
			<td colspan="2" align="center"><input type="submit" value="#button#"></td>
      	</tr>
	</table>
	</cfoutput>			
</cfform>
		
</body>
</html>