<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=printPaySlip.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
        <cfinclude template="printbonuspayslip.cfm">
<cfoutput>
<cfdocumentitem type="footer">
	<font size="2">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</font>
</cfdocumentitem>
</cfoutput>
</body>
</html>
</cfdocument>
