<cfif IsDefined('url.comid')>
	<cfset URLcompanyID = trim(urldecode(url.comid))>
</cfif>

<cfquery name="getMasterUser" datasource="netiquette_c">
    SELECT username
    FROM directpayroll
</cfquery>

<cfif ListFindnocase(getMasterUser.username,getauthuser())>
    <cfif IsDefined('url.comid')>
    <cfif findnocase("_p",URLcompanyID) eq 0>
    <cfset URLcompanyID = URLcompanyID&"_p">
	</cfif>
    <cfoutput>
    
            <cfquery name="updateUser" datasource="payroll_main">
                Update users 
                SET 
                	usercmpid = <cfqueryparam cfsqltype="cf_sql_char" value="#replacenocase(URLcompanyID,'_p','')#">, 
                    userdsn = <cfqueryparam cfsqltype="cf_sql_char" value="#URLcompanyID#">
                WHERE USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(huserid)#">;
            </cfquery>
            <script type="text/javascript">
                top.location.href=top.location.href;
            </script>
    </cfoutput>
    </cfif>
</cfif>

