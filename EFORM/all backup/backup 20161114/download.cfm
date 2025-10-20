<cfif isdefined('url.filetype')>
<cfset dts = dsname>
<cfquery name="getempno" datasource="#dts#">
SELECT empno FROM emp_users WHERE 
username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<cfif url.filetype eq "ic">
	<cfset filefieldname = "cvfile">
    <cfset pathtofile = "/upload/#dts#/cv/">
<cfelseif url.filetype eq "passport">
	<cfset filefieldname = "passportfile">
    <cfset pathtofile = "/upload/#dts#/passport/">
<cfelseif url.filetype eq "employmentpass">
    <cfset pathtofile = "/upload/#dts#/photo/">
	<cfset filefieldname = "photo">
<cfelseif left(url.filetype,4) eq "cert">
	<cfset filefieldname = "contractfile"&replacenocase(url.filetype,'cert','')>
    <cfset pathtofile = "/upload/#dts#/contract/">
</cfif>

<cfquery name="getfile" datasource="#dts#">
SELECT #filefieldname# as filename FROM pmast 
WHERE 
empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
</cfquery>

<cfif getfile.filename eq "">
<h1>File Not Found</h1>
<cfabort>
</cfif>
<cfset serverfile = expandpath(pathtofile)&getfile.filename>
<cfheader name="Content-Disposition" value="attachment; filename=#getfile.filename#">
<cfcontent type="application/unknown" file="#ServerFile#" deletefile="No">
</cfif>
