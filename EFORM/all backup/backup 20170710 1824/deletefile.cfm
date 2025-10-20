<cfif isdefined('url.filetype')>
<cfsetting showdebugoutput="no">
<cfoutput>
<input  type="file" name="upload#url.filetype#" id="upload#url.filetype#">
</cfoutput>
</cfif>