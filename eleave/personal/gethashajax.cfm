<cfsetting showdebugoutput="No">
<cfset url.password=urldecode(url.password)>
<cfoutput>
<input type="hidden" name="hashedpassword" id="hashedpassword" value="#hash(url.password)#" />
</cfoutput>