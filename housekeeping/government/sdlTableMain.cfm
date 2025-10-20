<cfscript>
	tLen1 = 200;
	tLen2 = 200;
</cfscript>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>SDL Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	
	<SCRIPT LANGUAGE="JavaScript">
	function textCounter(field, countfield, maxlimit){ 
	if (field.value.length > maxlimit) // if too long...trim it!
	field.value = field.value.substring(0, maxlimit);
	else // otherwise, update 'characters left' counter
	//countfield.value = maxlimit - field.value.length;
	document.getElementById(countfield).value = maxlimit - field.value.length;
	}
	<cfoutput>
	function init(){
		textCounter(document.getElementById("sdl_con"),'textLen1',#tLen1#);
		textCounter(document.getElementById("sdl_for"),'textLen2',#tLen2#);
	}
	</cfoutput>
	
	<!---cfoutput>
	function init(){
		textCounter(document.sdlForm.sdl_con,document.sdlForm.textLen1,#tLen1#);
		textCounter(document.sdlForm.sdl_for,document.sdlForm.textLen2,#tLen2#);
	}
	</cfoutput--->
	</script>
</head>

<body onLoad="init()">
<cfquery datasource="#dts#" name="sdlt_qry">
SELECT* FROM ottable WHERE ot_cou='1'
</cfquery>

	<div class="mainTitle">SDL Table Main</div>
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif--->
	<form name="sdlForm" action="sdlTableMain_process.cfm" method="post">
		<table class="form" border="0">
		<tr>
			<th colspan="2">Skills Development Levy (SDL) Formula</th>
		</tr>
		<cfoutput query="sdlt_qry">
		<tr>
			<td>Condition</td>
			<td><textarea id="sdl_con" name="sdl_con" cols="80" rows="5" onKeyDown="textCounter(this,'textLen1',#tLen1#);" onKeyUp="textCounter(this,'textLen1',#tLen1#);">#sdlt_qry.sdl_con#</textarea><br />
				<input type="text" id="textLen1" name="textLen1" size="3" maxlength="3" value="#tLen1#" readonly>characters left ( You may enter up to #tLen1# characters. )
			</td>
		</tr>
		<tr>
			<td>Formula</td>
			<td><textarea id="sdl_for" name="sdl_for" cols="80" rows="5" onKeyDown="textCounter(this,'textLen2',#tLen2#);" onKeyUp="textCounter(this,'textLen2',#tLen2#);">#sdlt_qry.sdl_for#</textarea><br />
				<input type="text" id="textLen2" name="textLen2" size="3" maxlength="3" value="#tLen2#" readonly>characters left ( You may enter up to #tLen2# characters. )
			</td>
		</tr>
		<tr><td align="right"><input type="checkbox" name="sdlcal" #IIF(sdlt_qry.sdlcal eq 1,DE("checked"),DE(""))#></td><td>Calculate SDL</td></tr>
		</cfoutput>
		</table>
		<br />
		<cfoutput>
		<center>
			<!--- <input type="reset" name="reset" value="Reset" > --->
			<input type="submit" name="submit" value="OK" />
			<input type="button" name="cancel" value="Cancel" onClick="window.location='/housekeeping/setupList.cfm'">
		</center>
		
		<!-- need these if there's an error with the required fields so they'll be available in the next event -->
		<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" /--->
		<!---input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
		</cfoutput>
	</form>
</body>
</html>
