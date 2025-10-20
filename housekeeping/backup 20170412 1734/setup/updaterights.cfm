
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfquery name="getinfo" datasource="#dts#">
	select #groupid#  as pin 
	from newuserdefine
	where code = '#pincode#'
</cfquery>

<cfif getinfo.recordcount neq 0>
	<cfif getinfo.pin eq "TRUE">
		<cfset nextcode = "FALSE">
	<cfelse>
		<cfset nextcode = "TRUE">
	</cfif>
	<cfquery name="update" datasource="#dts#">
		update newuserdefine set #groupid# = '#nextcode#'
		where code = '#pincode#'
	</cfquery>
    <cfabort>
</cfif>

<cfset header = "count|alert|msg|codeid">
<cfset value = "1|0|0|#pincode##tabchr#">	

<cfoutput>#header##tabchr##value#</cfoutput>