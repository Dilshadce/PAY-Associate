<html>
<head>
<title>View All IMS Users</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_formcheck(this.recordset);</script>

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact2" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact2" event="ondatasetcomplete">show_reply(this.recordset);</script>

<script language="JavaScript">
	
function submitaction(){
 	if(document.itemform.newgroup.value == ''){
 		alert("The Group Name Cannot Be Empty!");
 		return false;
 	}
 	else{
 		var newgroupname = document.itemform.newgroup.value;
 		document.all.feedcontact1.dataurl="databind/formcheck.cfm?action=add&groupname=" + newgroupname;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();
 	}
 }
 
 
 function show_formcheck(rset){
 	rset.MoveFirst();
 	if(rset.fields("error").value != 0){
 		alert(rset.fields("msg").value);
 	}
 	else{
 		if(rset.fields("action").value == "add"){
 			var newgroupname = document.itemform.newgroup.value;
 			document.all.feedcontact2.dataurl="databind/act_insertusergroup.cfm?newgroupname=" + newgroupname;
			//prompt("D",document.all.feedcontact2.dataurl);
			document.all.feedcontact2.charset=document.charset;
			document.all.feedcontact2.reset();
 		}else{
 			var groupname = rset.fields("groupname").value;
 			document.all.feedcontact2.dataurl="databind/act_deleteusergroup.cfm?groupname=" + groupname;
			//prompt("D",document.all.feedcontact2.dataurl);
			document.all.feedcontact2.charset=document.charset;
			document.all.feedcontact2.reset();
 		}
 		
 	}
 }
 
 function show_reply(rset){
 	rset.MoveFirst();
 	window.location.reload();
 }
 
 function confirmdelete(usergroup){
 	if (confirm("Are you sure you want to delete")) {
 		document.all.feedcontact1.dataurl="databind/formcheck.cfm?action=delete&groupname=" + usergroup;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();
 	}
 }
</script>

</head>
<body>
<h4>
	<cfif husergrpid eq "Muser">
		<a href="/home2.cfm"><u>Home</u></a>
	</cfif>
</h4>

<h1>User Group Maintenance</h1>
<hr>

<form name="itemform" action="index.cfm">
	<table align="center" width="50%">
		<tr>
			<td>New Group Name :&nbsp;&nbsp; <input type="text" name="newgroup" value="" size="25">&nbsp;<font color="red" face="arial">*maximun 10 characters</font></td>
			<td><input type="button" value="Add Group" onClick="submitaction();"></td>
		</tr>
	</table>
</form>

<cfquery datasource="#dts#" name="getusergroup">
	select * 
	from userpin2 
	where level <> 'super' 
	order by level
</cfquery>
<table align="center" class="data" width="50%">
	<tr>
		<th>No. </th>
		<th>Group Name</th>
		<th>Action</th>
	</tr>
	<cfoutput>
	<cfloop query="getusergroup">
		<cfif getusergroup.level eq "Standard">
			<cfset thisgroupname = "Standard User">	
		<cfelseif getusergroup.level eq "General">	
			<cfset thisgroupname = "General User">	
		<cfelseif getusergroup.level eq "Limited">	
			<cfset thisgroupname = "Limited User">
		<cfelseif getusergroup.level eq "Mobile">	
			<cfset thisgroupname = "Mobile User">
		<cfelseif getusergroup.level eq "Admin">	
			<cfset thisgroupname = "Administrator">	
		<cfelseif getusergroup.level eq "Super">	
			<cfset thisgroupname = "Super User">	
		<cfelse>	
			<cfset thisgroupname = "#getusergroup.level#">				
		</cfif>
		<tr>
			<td align="center">#getusergroup.currentrow#</td>
			<td>#thisgroupname#</td>
			<td align="center">
				<!---a href='dsp_userdefinedmenu.cfm?groupname=#getusergroup.level#' target='mainFrame')>edit</a--->
				<cfif husergrpid neq "super" and getusergroup.level eq "Admin">
					<img src="../../../images/userdefinedmenu/iedit_disabled.gif" alt="Edit">
				<cfelse>
					<img src="../../../images/userdefinedmenu/iedit.gif" alt="Edit" onClick="window.location.href='dsp_userdefinedmenu.cfm?groupname=#getusergroup.level#'" style="cursor: hand;">
				</cfif>
				
				<cfif getusergroup.level eq "Admin" or getusergroup.level eq "General" or getusergroup.level eq "Standard" or getusergroup.level eq "Limited" or getusergroup.level eq "Mobile">
					<img src="../../../images/userdefinedmenu/idelete_disabled.gif" alt="Delete">
				<cfelse>
					<img src="../../../images/userdefinedmenu/idelete.gif" alt="Delete" style="cursor: hand;" onClick="confirmdelete('#getusergroup.level#');">
				</cfif>
			
			</td>
		</tr>
	</cfloop>
	</cfoutput>
</table>

</body>
</html>