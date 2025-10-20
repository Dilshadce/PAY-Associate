<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">
     <cfquery name="getdts" datasource="payroll_main">
     	SELECT userDSN AS dts,userid,usergrpid FROM users WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
    </cfquery>
    <cfset dts = trim(getdts.dts)>
    <cfset husergrpid=trim(getdts.usergrpid)>
    <cfset huserid=trim(getauthuser())>
		
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
    
	<cfquery name="getMultiCompany" datasource='payroll_main'>
		SELECT * 
        FROM multicomusers 
        WHERE userid='#huserid#'; 
	</cfquery>
	
    <cfset multiCompanyList = valuelist(getMultiCompany.comlist)>
	
	<cfquery name="getFilteredDataSet" datasource="payroll_main">  	
    	<cfif husergrpid eq "super">
            SELECT a.userDsn,b.comp_name,b.mmonth,b.myear
            FROM users AS a 
            LEFT JOIN ( SELECT comp_name,mmonth,myear,comp_id
						FROM gsetup) AS b ON b.comp_id=left(a.userdsn,length(a.userdsn)-2)
            WHERE
            a.userDSN != ''
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
            GROUP BY a.userDSN		
			#sOrder#
			#sLimit#
        <cfelseif getMultiCompany.recordcount NEQ 0>
            SELECT a.userDsn,b.comp_name,b.mmonth,b.myear 
            FROM users AS a 
            LEFT JOIN ( SELECT comp_name,mmonth,myear,comp_id 
						FROM gsetup) AS b ON b.comp_id=left(a.userdsn,length(a.userdsn)-2)
            WHERE a.userDsn IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#multiCompanyList#">)
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
            GROUP BY a.userDsn
            #sOrder#
			#sLimit#
        <cfelseif husergrpid eq "admin">
            SELECT a.userDsn,b.comp_name,b.mmonth,b.myear
            FROM users AS a 
            LEFT JOIN ( SELECT comp_name,mmonth,myear,comp_id 
						FROM gsetup) AS b ON b.comp_id=left(a.userdsn,length(a.userdsn)-2)
            WHERE a.userDsn='#trim(dts)#'
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
            GROUP BY a.userDsn
            #sOrder#
			#sLimit#
        <cfelse>
            SELECT a.userDsn,b.comp_name,b.mmonth,b.myear
            FROM users AS a 
            LEFT JOIN ( SELECT comp_name,mmonth,myear,comp_id 
						FROM gsetup) AS b ON b.comp_id=left(a.userdsn,length(a.userdsn)-2)
            WHERE a.userid='#trim(huserid)#' 
            AND a.userDsn='#trim(dts)#' 
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
			#sLimit# 
        </cfif> 
	</cfquery>
    
	<cfquery name="getFilteredDataSetLength" datasource="payroll_main">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
    
	<cfquery name="getTotalDataSetLength" datasource="payroll_main">
    	SELECT COUNT(userDsn) AS iTotal FROM(
        SELECT userDsn
        FROM users
        <cfif husergrpid neq "super">
        WHERE userDsn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dts)#">
        <cfelse>
        WHERE userDsn != ''
        </cfif>		 
        group by userDsn) as aa;
	</cfquery>
    
	<cfset aaData=ArrayNew(1)>
    <cfloop query="getFilteredDataSet">	
        <cfset data=StructNew()>
        <cfset data["userDsn"]=" "&UCASE(userDsn)> 
        <cfset data["comp_name"]=" "&comp_name> 
        <cfset data["mmonth"]=" "&mmonth>
        <cfset data["myear"]=" "&myear>   
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