<cfoutput>

<cfquery name="update_sdltable" datasource="#dts#">
	UPDATE ottable SET 
		   sdl_con='#form.sdl_con#',
		   sdl_for='#form.sdl_for#',
		   sdlcal=<cfif isdefined("form.sdlcal")>'1'<cfelse>'0'</cfif>

</cfquery>

<cflocation url="/housekeeping/government/sdlTableMain.cfm">

</cfoutput>

