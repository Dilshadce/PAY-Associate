<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Shift Allowance Table</title>
</head>

<body>
	<div class="mainTitle">Shift Allowance Table</div>
	<cfquery name="shftable" datasource="#dts#">
	SELECT * FROM shftable WHERE SHF_COU='#url.SHF_COU#'
	</cfquery>
	<form name="eForm" action="shiftAllowanceForm_update.cfm" method="post">
	<cfoutput>
	<table class="form" border="0">
		<tr>
			<th width="25%" align="right">SHF_DESP:</th><td><input type="text"  name="SHF_DESP" size="15" maxlength = "15" value="#shftable.SHF_DESP#" /></td>
		</tr><tr>
			<th align="right">SHIFT1:</th><td><input type="text"  name="SHIFT1" size="10" maxlength = "5" value="#shftable.SHIFT1#" /></td>
		</tr><tr>
			<th align="right">SHIFT2:</th><td><input type="text"  name="SHIFT2" size="10" maxlength = "5" value="#shftable.SHIFT2#" /></td>
		</tr><tr>
			<th align="right">SHIFT3:</th><td><input type="text"  name="SHIFT3" size="10" maxlength = "5" value="#shftable.SHIFT3#" /></td>
		</tr><tr>
			<th align="right">SHIFT4:</th><td><input type="text"  name="SHIFT4" size="10" maxlength = "5" value="#shftable.SHIFT4#" /></td>
		</tr><tr>
			<th align="right">SHIFT5:</th><td><input type="text"  name="SHIFT5" size="10" maxlength = "5" value="#shftable.SHIFT5#" /></td>
		</tr><tr>
			<th align="right">SHIFT6:</th><td><input type="text"  name="SHIFT6" size="10" maxlength = "5" value="#shftable.SHIFT6#" /></td>
		</tr><tr>
			<th align="right">SHIFT7:</th><td><input type="text"  name="SHIFT7" size="10" maxlength = "5" value="#shftable.SHIFT7#" /></td>
		</tr><tr>
			<th align="right">SHIFT8:</th><td><input type="text"  name="SHIFT8" size="10" maxlength = "5" value="#shftable.SHIFT8#" /></td>
		</tr><tr>
			<th align="right">SHIFT9:</th><td><input type="text"  name="SHIFT9" size="10" maxlength = "5" value="#shftable.SHIFT9#" /></td>
		</tr><tr>
			<th align="right">SHIFT10:</th><td><input type="text"  name="SHIFT10" size="10" maxlength = "5" value="#shftable.SHIFT10#" /></td>
		</tr><tr>
			<th align="right">SHIFT11:</th><td><input type="text"  name="SHIFT11" size="10" maxlength = "5" value="#shftable.SHIFT11#" /></td>
		</tr><tr>
			<th align="right">SHIFT12:</th><td><input type="text"  name="SHIFT12" size="10" maxlength = "5" value="#shftable.SHIFT12#" /></td>
		</tr><tr>
			<th align="right">SHIFT13:</th><td><input type="text"  name="SHIFT13" size="10" maxlength = "5" value="#shftable.SHIFT13#" /></td>
		</tr><tr>
			<th align="right">SHIFT14:</th><td><input type="text"  name="SHIFT14" size="10" maxlength = "5" value="#shftable.SHIFT14#" /></td>
		</tr><tr>
			<th align="right">SHIFT15:</th><td><input type="text"  name="SHIFT15" size="10" maxlength = "5" value="#shftable.SHIFT15#" /></td>
		</tr><tr>
			<th align="right">SHIFT16:</th><td><input type="text"  name="SHIFT16" size="10" maxlength = "5" value="#shftable.SHIFT16#" /></td>
		</tr><tr>
			<th align="right">SHIFT17:</th><td><input type="text"  name="SHIFT17" size="10" maxlength = "5" value="#shftable.SHIFT17#" /></td>
		</tr><tr>
			<th align="right">SHIFT18:</th><td><input type="text"  name="SHIFT18" size="10" maxlength = "5" value="#shftable.SHIFT18#" /></td>
		</tr><tr>
			<th align="right">SHIFT19:</th><td><input type="text"  name="SHIFT19" size="10" maxlength = "5" value="#shftable.SHIFT19#" /></td>
		</tr><tr>
			<th align="right">SHIFT20:</th><td><input type="text"  name="SHIFT20" size="10" maxlength = "5" value="#shftable.SHIFT20#" /></td>
		</tr>
		</table>
	<center>
			<!--- <input type="button" name="list" value="List" onclick="history.back()" /> --->
			<!--- <input type="reset" name="reset" value="Reset"> --->
			<input type="submit" name="save" value="Save" />
			<input type="button" name="cancel" value="Cancel" onclick="history.back()">
	</center>
<br />
		<input type="hidden"  name="SHF_COU" value="#shftable.SHF_COU#" />
		<input type="hidden"  name="SHIFT_D1" value="#shftable.SHIFT_D1#" />
		<input type="hidden"  name="SHIFT_D2" value="#shftable.SHIFT_D2#" />
		<input type="hidden"  name="SHIFT_D3" value="#shftable.SHIFT_D3#" />
		<input type="hidden"  name="SHIFT_D4" value="#shftable.SHIFT_D4#" />
		<input type="hidden"  name="SHIFT_D5" value="#shftable.SHIFT_D5#" />
		<input type="hidden"  name="SHIFT_D6" value="#shftable.SHIFT_D6#" />
		<input type="hidden"  name="SHIFT_D7" value="#shftable.SHIFT_D7#" />
		<input type="hidden"  name="SHIFT_D8" value="#shftable.SHIFT_D8#" />
		<input type="hidden"  name="SHIFT_D9" value="#shftable.SHIFT_D9#" />
		<input type="hidden"  name="SHIFT_D10" value="#shftable.SHIFT_D10#" />
		<input type="hidden"  name="SHIFT_D11" value="#shftable.SHIFT_D11#" />
		<input type="hidden"  name="SHIFT_D12" value="#shftable.SHIFT_D12#" />
		<input type="hidden"  name="SHIFT_D13" value="#shftable.SHIFT_D13#" />
		<input type="hidden"  name="SHIFT_D14" value="#shftable.SHIFT_D14#" />
		<input type="hidden"  name="SHIFT_D15" value="#shftable.SHIFT_D15#" />
		<input type="hidden"  name="SHIFT_D16" value="#shftable.SHIFT_D16#" />
		<input type="hidden"  name="SHIFT_D17" value="#shftable.SHIFT_D17#" />
		<input type="hidden"  name="SHIFT_D18" value="#shftable.SHIFT_D18#" />
		<input type="hidden"  name="SHIFT_D19" value="#shftable.SHIFT_D19#" />
		<input type="hidden"  name="SHIFT_D20" value="#shftable.SHIFT_D20#" />
		
		<!-- need these if there's an error with the required fields so they'll be available in the next event -->
		<!---input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" />
		<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" /--->
	</form>
	</cfoutput>
</body>
</html>