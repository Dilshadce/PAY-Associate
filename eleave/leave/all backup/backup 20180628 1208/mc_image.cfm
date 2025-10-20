<cfset thisPath = ExpandPath("/ELeave/leave/uploadImages/*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfif DirectoryExists(thisDirectory) eq 'NO'>
	<cfdirectory action="create" directory="#thisDirectory#">
</cfif>
<html>
<head>
<title>Attach Picture</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfoutput>
	<cfif isdefined("form.picture")>
		<cftry>
			<cffile action="upload" 
				filefield="picture" 
				destination="#thisDirectory#\#form.picture_upload#" 
				nameconflict="overwrite" 
				accept="image/*"
			>
		<cfcatch type="any">
				<cfabort showerror="Error! Please Contact Administrator !">
			</cfcatch>
		</cftry>
		
		<script language="javascript" type="text/javascript">
			window.close();
		</script>
	</cfif>
</cfoutput>

</body>
</html>