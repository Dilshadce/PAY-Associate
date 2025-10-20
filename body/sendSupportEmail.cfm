<cfsetting showdebugoutput="no">
<cfset companyid=form.companyid>
<cfset subject=form.subject>
<cfset description=form.description>
<cfset attachmentsNumber=form.attachmentsNumber>
<cftry>
<cfmail to="support@mynetiquette.com" from="noreply@mynetiquette.com" subject="[AMS ASIA CUSTOMER SUPPORT REQUEST]#subject#" type="html">
	<p>Username:#getAuthUser()#</p>
	<p>Company ID:#companyid#</p>
	<p>Subject:#subject#</p>
	<p>Description:#description#</p>
	<p>Attachments:<cfif attachmentsNumber GT 0>There are total #attachmentsNumber# attachments. <em>Please see attached files</em><cfelse>No attachement.</cfif></p>
<cfloop from="0" to="#attachmentsNumber-1#" index="i">
<cffile action="upload" filefield="attachment#i#" destination="#GetTempDirectory()#" nameconflict="makeunique">
<cfset strFilePath=(CFFILE.ServerDirectory&"\"&CFFILE.ServerFile)/>
<cfmailparam file="#strFilePath#"/>
</cfloop>
</cfmail>
<cfcatch>
	<script type="text/javascript">
		alert('Error occured. Please try again.');
		window.open('/body/support.cfm','_self');
	</script>
</cfcatch>
</cftry>
<script type="text/javascript">
	alert('Your support request was send to our support team.');
	window.open('/body/support.cfm','_self');
</script>