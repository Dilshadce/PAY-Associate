<cfcomponent>
	<cffunction name="createnew" access="public" returntype="string">
    	<cfargument name="db" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
        <cfargument name="userid" type="string" required="no">
        <cfargument name="passwordnew" type="string" required="no">
        <cfargument name="companyid" type="string" required="no">
        <cfargument name="email" type="string" required="no">
        <cfargument name="maindb" type="string" required="no">
        <cfargument name="serverside" type="string" required="no">
        
        <cfset emptydb = "empty_p">
        
        <cfif isdefined('maindb')>
        <cfif maindb neq "">
        <cfset emptydb = maindb&"_p" > 
		</cfif>
		</cfif>
        
        <cfset serverrealside = "asia">
        <cfif isdefined('serverside')>
        <cfif serverside neq "">
        <cfset serverrealside = serverside>
        </cfif>
		</cfif>
        
        <cfset username = userid>
        <cfset password = passwordnew>
        
        <cfset dbname = #companyid#&"_p" >
        <cfset userid = #username#&"_"&#companyid# >
	 	<cfquery name="create_DB" datasource="#dsn#">
        CREATE DATABASE #dbname#;
        </cfquery>
        <cfquery name="select_tbl" datasource="#db#">
        show tables from #emptydb#
        </cfquery>
        
        <cfloop query="select_tbl">
        <cfquery name="createtbl" datasource="#dsn#">
        CREATE TABLE #dbname#.#evaluate('select_tbl.tables_in_#emptydb#')# like #emptydb#.#evaluate('select_tbl.tables_in_#emptydb#')#
        </cfquery>
        
        <cfquery name="inserttbl" datasource="#dsn#">
        INSERT INTO #dbname#.#evaluate('select_tbl.tables_in_#emptydb#')# SELECT * FROM #emptydb#.#evaluate('select_tbl.tables_in_#emptydb#')#
        </cfquery>
        </cfloop>
        

<cfquery name="insert_gsetup" datasource="#dsn#">
INSERT INTO payroll_main.gsetup (comp_ID,TC_CPRATIO,PC_PCF,myear,mmonth,ccode) VALUES ("#companyid#","IIF(WDAY=0,0,DW/WDAY)","IIF(PMAST.EPFCAT=''X'',ROUND(BASICPAY * 17.5/100,2),0)","#dateformat(now(),'yyyy')#","#dateformat(now(),'m')#",<cfif emptydb eq 'empty_p'>"SG"<cfelseif emptydb eq 'emptym_p'>"MY"<cfelseif emptydb eq 'emptyind_p'>"ID"<cfelseif emptydb eq 'emptyhk_p'>"HK"<cfelseif emptydb eq 'emptyph_p'>"PH"<cfelse>"SG"</cfif>)
</cfquery>

<cfquery name="insert_user" datasource="#dsn#">
INSERT INTO payroll_main.users (entryID,userID,userPwd,userGrpID,userName,userCmpID,userDSN,userCty,userEmail) VALUES ("#userid#","#username#","#hash(password)#","admin","#username#","#companyid#","#dbname#","SINGAPORE","#listfirst(email,';')#")
</cfquery>

<cfquery name="insert_dsn" datasource="#dsn#">
INSERT INTO payroll_main.payroll_dscontrol (compID,DS_NAME)
VALUES ("#companyid#","#dbname#")
</cfquery>

<cfquery name="insert_userlimit" datasource="#dsn#">
INSERT INTO payroll_main.useraccountlimit (companyid,serverside) VALUES ("#dbname#","#serverrealside#")
</cfquery>

<cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","appserver1","Nickel266(","sg")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","appserver2","Nickel266(","sg")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","root","Toapayoh831","sg")
        </cfquery>
        
         <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","appserver1","Nickel266(","asia")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","root","Nickel266(","asia")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","appserver1","Nickel266(","exa")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","appserver2","Nickel266(","exa")
        </cfquery>
        
        <cfquery name="insert_dsn" datasource="#dsn#">
        INSERT INTO loadbal.createdatasource (dbname,servername,password,serverside)
        VALUES ("#dbname#","root","Nickel266(","exa")
        </cfquery>

		<cfset myResult="Sucess!">
		<cfreturn myResult>
	</cffunction>
</cfcomponent>