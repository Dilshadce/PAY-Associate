<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
       <!--- <cfset dts=form.dts>--->
       <cfquery name="getdts" datasource="payroll_main">
     	SELECT userdsn AS dts FROM users WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
    </cfquery>
    <cfset dts = trim(getdts.dts)>
        <cfset term=form.term>
        <cfset limit=form.limit>
        <cfset page=form.page>
        <cfset start=page*limit>
        <cfset matchedAccountList=ArrayNew(1)>
        
        <cfquery name="listMatchedAccount" datasource="#dts#">
            SELECT compid as companyID
			FROM payroll_main.payroll_dscontrol
			WHERE ds_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#term#%" />
            ORDER BY 
            	CASE left(right(compid,2),1) WHEN 1 THEN 1
              	WHEN 2 THEN 1
                ELSE -1
                END ASC, compid
            LIMIT #start#,#limit#;
        </cfquery>
        
        <cfquery name="getMatchedAccountLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS matchedAccountLength
        </cfquery>	
        
        <cfloop query="listMatchedAccount">
            <cfset matchedAccount=StructNew()>
            <cfset matchedAccount["id"]=evaluate('listMatchedAccount.companyID')>
            <cfset matchedAccount["companyID"]=evaluate('listMatchedAccount.companyID')>
            <cfset ArrayAppend(matchedAccountList,matchedAccount)>
        </cfloop>
        <cfset output=StructNew()>
        <cfset output["total"]=getMatchedAccountLength.matchedAccountLength>
        <cfset output["result"]=matchedAccountList>
        <cfreturn output>
    </cffunction>
    
    <cffunction name="getSelectedAccount" access="remote" returntype="struct">
        <!---<cfset dts=form.dts>--->
    <cfquery name="getdts" datasource="payroll_main">
     	SELECT userdsn AS dts FROM users WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
    </cfquery>
    <cfset dts = trim(getdts.dts)>
        <cfset value=form.value>
        
        <cfquery name="getSelectedAccount" datasource="#dts#">
             SELECT compid as companyID
			FROM payroll_main.payroll_dscontrol
			WHERE compid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#value#" />;
        </cfquery>
        
        <cfset selectedAccount=StructNew()>
        <cfset matchedAccount["id"]=evaluate('getSelectedAccount.companyID')>
        <cfset selectedAccount["companyID"]=evaluate('getSelectedAccount.companyID')>
        <cfreturn selectedAccount>
        
    </cffunction>
</cfcomponent>