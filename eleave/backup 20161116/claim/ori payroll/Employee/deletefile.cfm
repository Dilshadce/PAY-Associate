<cfsetting showdebugoutput="false" >
<cftry>
	<cffile 
    action = "delete"
    file = "C:\Jrun4\servers\cfusion\cfusion-ear\cfusion-war\PAYROLL\upload\#dts#\#url.filename#">
<cfcatch type="any">
</cfcatch>
</cftry>
<input type="file" name="uploadfilefield" id="uploadfilefield">