<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<title>User Pin Define Menu</title>
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<script type="text/javascript">
function updaterights(groupid,pincode){
	ajaxFunction(document.getElementById('ajaxfield'),'updaterights.cfm?groupid=' + groupid + '&pincode=' + pincode);
	 }

<!--- <OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_reply(this.recordset);</script>

<script language="JavaScript">
	function updaterights(groupid,pincode){
	
		var x = document.getElementById('cb_' + groupid + pincode);
		x.style.backgroundColor  = 'red';
	 	document.all.feedcontact1.dataurl="updaterights.cfm?groupid=" + groupid + "&pincode=" + pincode;
		//prompt("D",document.all.feedcontact1.dataurl);
		document.all.feedcontact1.charset=document.charset;
		document.all.feedcontact1.reset();
	 } --->
</script>

</head>
<body>
<div id="ajaxfield" style="display:none">
</div>
<cfquery name="uerpin_qry" datasource="#dts#">
	SELECT * from userpin
</cfquery>
<cfquery name="userdefine_tbl" datasource="#dts#"> 
	SELECT * FROM newuserdefine 
    WHERE (company_id = "" or company_id = '#HcomID#')
    AND (ccode = "" or ccode is null or ccode = "#HUserCcode#")
    order by code
</cfquery>
<cfquery name="uerpin_qry_2" datasource="#dts#">
	SELECT usergroup from userpin where pin = "#Hpin#"
</cfquery>
<div>Housekeeping - User Defined Menu</div><br>
<cfoutput>
<table><tr><td width='100'>User ID</td><td><input type="text" value="#uerpin_qry_2.usergroup#" readonly/></td></tr></table>

<cfform name="pForm" action="user_define_menu.cfm?type=update" method='post'>
<table>
	<tr><Th width="350px" colspan='2' ><center>DESCRIPTION</center></th><cfloop query="uerpin_qry"><th width="50">PIN #uerpin_qry.pin#</th></cfloop></tr>
</table>
<div style="width:1000px;height:300px;overflow:auto;">
<table>	
	<cfloop query="userdefine_tbl">
	
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td width="50px"></td>
			<td width="300px">#userdefine_tbl.desp#</td>
			<cfloop query="uerpin_qry">
				<cfset var_pin = uerpin_qry.pin>
				<cfset code_pin = "PIN"&#var_pin#>
				<cfset pin_status = userdefine_tbl['#code_pin#']>
				<td width="50">
					<input type="checkbox" id="cb_#code_pin##userdefine_tbl.code#" value="" onchange="updaterights('#code_pin#','#userdefine_tbl.code#');" <cfif pin_status eq "TRUE">checked</cfif>>
				</td>
			</cfloop>
		</tr>
	</cfloop>
	<tr><td></td><td></td></tr>
</table>
</div>

</cfform>
</cfoutput>
</body>
</html>