<cfif IsDefined('url.comid')>
	<cfset URLcompanyID = trim(urldecode(url.comid))>
</cfif>

<cfif HUserGrpID eq "SUPER" and left(trim(huserid),5) eq "ultra">
	<!---ultra user --->
    <cfif IsDefined('url.comid')>
    <cfoutput>
        <cfquery name="checkLinkAMS" datasource="#dts_main#">
            SELECT linktoams 
            FROM users 
            WHERE userdsn = <cfqueryparam cfsqltype="cf_sql_char" value="#URLcompanyID#">
        </cfquery>
        <cfif checkLinkAMS.recordcount NEQ 0>
            <cfquery name="updateUser" datasource="#dts_main#">
                Update users 
                SET 
                	userdsn = <cfqueryparam cfsqltype="cf_sql_char" value="#URLcompanyID#">, 
                    usercmpid = <cfqueryparam cfsqltype="cf_sql_char" value="#left(URLcompanyID,len(URLcompanyID)-2)#">,
                    linktoams = "#checkLinkAMS.linktoams#"
                WHERE USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(huserid)#">;
            </cfquery>
            <script type="text/javascript">
                top.location.href=top.location.href;
            </script>
        </cfif>
    </cfoutput>
    </cfif>
<cfelse>
	<!---Not ultra user --->
    <cfif IsDefined('url.comid')>
        <cfquery datasource='#dts_main#' name="getmulticompany">
            select * 
            from multicomusers 
            where userid='#huserid#' 
        </cfquery>
        
        <cfset multicomlist=valuelist(getmulticompany.comlist)>
        <cfif ListFindNoCase(multicomlist,'#URLcompanyID#') GT 0>
            <cfoutput>
            <cfquery name="checkLinkAMS" datasource="#dts_main#">
                SELECT linktoams from users where userdsn=<cfqueryparam cfsqltype="cf_sql_char" value="#URLcompanyID#">
            </cfquery>
                <cfif checkLinkAMS.recordcount neq 0>
                    <cfquery name="updateUser" datasource="#dts_main#">
                        Update users SET 
                        userdsn = <cfqueryparam cfsqltype="cf_sql_char" value="#URLcompanyID#">, 
                        usercmpid = <cfqueryparam cfsqltype="cf_sql_char" value="#left(URLcompanyID,len(URLcompanyID)-2)#">,
                        linktoams = "#checkLinkAMS.linktoams#"
                        WHERE
                        USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#huserid#">
                    </cfquery>
                <script type="text/javascript">
                    top.location.href='/index.cfm';
                </script>
                </cfif>
            </cfoutput>
        </cfif>
    <cfelse>
    	<cfabort/>
    </cfif>
<!--- --->
</cfif>

