<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
	
     <cfquery name="getdts" datasource="payroll_main">
     	SELECT userDsn  AS dts ,userid,usergrpid FROM users WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
    </cfquery>
    
    <cfset husergrpid=trim(getdts.usergrpid)>
    <cfset huserid=trim(getauthuser())>
    <cfif husergrpid eq "Super">
    <cfset dts = trim(form.dts)>
    <cfelse>
    <cfset dts = trim(getdts.dts)>
	</cfif>
			
	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>		
	
	<cfset sOrder="">
	<cfif IsDefined("form.iSortCol_0")>
        <cfset sOrder="ORDER BY `">
        <cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
            <cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
                <cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
                    <cfif Evaluate('form.sSortDir_'&i) EQ "asc">
                        <cfset sOrder=sOrder&"` ASC,`">
                    <cfelse>
                        <cfset sOrder=sOrder&"` DESC,`">
                    </cfif>
            </cfif>
        </cfloop>
        <cfset sOrder=Left(sOrder,Len(sOrder)-2)>
        <cfif sOrder EQ "ORDER BY `">
            <cfset sOrder="">
        </cfif>  
    </cfif>
    	
	<cfquery name="getFilteredDataSet" datasource="payroll_main">  	
		<cfif husergrpid EQ "super">
            SELECT * 
            FROM users 
            WHERE userDsn = '#trim(dts)#'
<!---            AND userGrpID != 'SUPER'--->
            <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            	AND (
                	<cfloop from="0" to="#form.iColumns-1#" index="i" step="1"> 
						<cfif Evaluate('form.bSearchable_'&i) EQ "true">
                            `#Evaluate('form.mDataProp_#i#')#` LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                        </cfif>
                        <cfif i neq form.iColumns-1>
                            OR 
                        </cfif>  
                        <cfif i eq form.iColumns-1>
                            )
                        </cfif>  
                    </cfloop>
			</cfif>
			#sOrder#
			#sLimit#;
        <cfelseif husergrpid EQ "admin">
            SELECT * 
            FROM users 
            WHERE (userDsn = '#trim(dts)#' OR userID IN (SELECT userID FROM multicomusers WHERE FIND_IN_SET('#dts#',comlist)))
            	  AND usergrpid != 'super' 
            	  AND userid NOT LIKE 'ultra%'
            	  <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            		AND (
                        <cfloop from="0" to="#form.iColumns-1#" index="i" step="1"> 
                            <cfif Evaluate('form.bSearchable_'&i) EQ "true">
                                `#Evaluate('form.mDataProp_#i#')#` LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                            </cfif>
                            <cfif i neq form.iColumns-1>
                                OR 
                            </cfif>  
                            <cfif i eq form.iColumns-1>
                                )
                            </cfif>  
                        </cfloop>
                	</cfif>
			#sOrder#
			#sLimit#;    
        <cfelse>
            SELECT * 
            FROM users 
            WHERE userid='#trim(huserid)#' 
                  AND userDsn='#trim(dts)#'
                  <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            		AND (
                        <cfloop from="0" to="#form.iColumns-1#" index="i" step="1"> 
                            <cfif Evaluate('form.bSearchable_'&i) EQ "true">
                                `#Evaluate('form.mDataProp_#i#')#` LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.sSearch)#%">
                            </cfif>
                            <cfif i neq form.iColumns-1>
                                OR 
                            </cfif>  
                            <cfif i eq form.iColumns-1>
                                )
                            </cfif>  
                        </cfloop>
                	</cfif>
			#sOrder#
			#sLimit#;      
        </cfif>
	</cfquery>
    
	<cfquery name="getFilteredDataSetLength" datasource="payroll_main">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>

	<cfquery name="getTotalDataSetLength" datasource="payroll_main">
		<cfif husergrpid EQ "super">
            SELECT COUNT(userid) AS iTotal
            FROM users 
            WHERE userDsn = '#trim(dts)#';
        <cfelseif husergrpid EQ "admin">
            SELECT COUNT(userid) AS iTotal
            FROM users 
            WHERE userDsn='#trim(dts)#' 
                  AND usergrpid != 'super' 
                  AND userid NOT LIKE 'ultra%';
        <cfelse>
        	SELECT COUNT(userid) AS iTotal 
            FROM users 
            WHERE userid='#trim(huserid)#' 
                  AND userDsn='#trim(dts)#';
        </cfif>		
	</cfquery>
    
	<cfset aaData=ArrayNew(1)>
    <cfloop query="getFilteredDataSet">	
        <cfset data=StructNew()>
        <cfset data["userDsn"]=" "&getFilteredDataSet.userDsn> 
        <cfset data["userid"]=" "&getFilteredDataSet.userid> 
        <cfset data["username"]=" "&getFilteredDataSet.username> 
        <cfset data["usergrpid"]=" "&usergrpid>  
        <cfset data["useremail"]=" "&useremail>
        <cfset data["getmail"]=" "&getmail>
        <cfset data["pilotrep"]=" "&pilotrep>
        <cfset data["mobileaccess"]=" "&mobileaccess>   
        <cfset data["lastlogin"]=" "&lastlogin>
        <cfset ArrayAppend(aaData,data)>
    </cfloop>
	
	<cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["aaData"]=aaData>
	<cfreturn output>
</cffunction>
</cfcomponent>