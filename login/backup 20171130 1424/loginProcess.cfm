<cfset identity = 0>
<cflogin >
	
	<cfset testFlag = FALSE>
	<cfif isdefined("form.userId") is false or isdefined("form.userPwd") is false>
		<cfinclude template="login.cfm">
		<cfabort>
	</cfif>
	<cfif isdefined('url.crmin') eq false>
	<cfset form.userPwd = hash(form.userPwd)>
	</cfif>
	
	<cfset tempID = form.userid>
	<!--- To detect last 4 character and remove test, [20170724, Alvin]--->
	<cfif right(form.userid, 4) eq 'test'>
        <cfset idLength = val(Len(form.userid) - 4)>
	    <!---<cfset form.userid = #rereplace(form.userid,'(.*)(test)','\1\3','one')#>--->
	    <cfset form.userid = #Left(form.userid, idLength)#>
	</cfif>
	<!--- To detect last 4 character and remove test--->
		
	<cfif left(form.userid,8) eq 'testuser' or left(form.userid,6) eq 'testhr' or right(tempID, 4) eq 'test'>
		<cfset form.companyid = 'manpowertest'>
		<cfset testFlag = TRUE>
	</cfif>
        <!--- check bruteforce	---> 

    <cfset nowtimezone = dateformat(dateadd('n',-15,now()),'YYYY-MM-DD')&" "&timeformat(dateadd('n',-15,now()),'HH:MM:SS')>
    
    <cfquery name="checkbrute" datasource="payroll_main">
		SELECT count(id) as idtry FROM tracklogin 
		where ip = '#cgi.remote_Addr#' 
		and timetry >= "#nowtimezone#"
		and companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#"> 
		and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
    </cfquery>
    
	<cfif checkbrute.idtry gte 5>
    	<cflocation url="login/login.cfm?status=failed&msg=You+have+been+blocked+for+too+many+attempts.<br>+Please+try+to+sign+in+later." addtoken="no">
    	<cfabort/>	
	</cfif>

    
    <cfquery name="getultrauser" datasource="net_c">
    SELECT * FROM ultrauser
    </cfquery>
    
	<cfquery name="validateUser" datasource="payroll_main">
		SELECT * 
		FROM
		<cfif #testFlag# eq "TRUE">
			hmuserstest
		<cfelse>
			hmusers
		</cfif> 
		WHERE 
		userid="#form.userid#"
		AND userPwd="#form.userpwd#"
		AND status = "Y"
	</cfquery>
   
    <cfset validlogin = 1>
    
    <cfif (listfindnocase(getultrauser.username,trim(form.userId)) neq 0) and form.companyid eq "netiquette">
		<cfquery name="validateUser" datasource="payroll_main">
			SELECT * 
			FROM 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
			limit 2
		</cfquery>
	</cfif>
	
	<cfif validateUser.Recordcount eq 1 and (listfindnocase(getultrauser.username,trim(form.userId)) neq 0)>
		<cfquery name="checkuserlink" datasource="payroll_main">
			SELECT userid,usercty from 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
			where userCmpID=<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">
		</cfquery>
		<cfif checkuserlink.recordcount neq 0>
			<cfquery name="updatemain" datasource="payroll_main">
			Update 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
			SET 
			userCmpID = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">, 
			userDsn = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.companyid)#_p">,
			usercty = <cfqueryparam cfsqltype="cf_sql_char" value="#checkuserlink.usercty#">
			WHERE
			USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
			</cfquery>

			<cfset validateUser.userCmpID ="#form.companyid#">
			<cfset validateUser.userDsn ="#trim(form.companyid)#_p">
		<cfelse>
			<cfset validlogin = 0>
		</cfif>
	</cfif>
    
    <cfquery name="validate_company_id" datasource="payroll_main">
    	SELECT * 
		FROM 
		<cfif testFlag eq "TRUE">
			hmuserstest
		<cfelse>
			hmusers
		</cfif> 
		WHERE 
	    userCmpID="#form.companyid#"
    </cfquery>
    
    <cfif validate_company_id.recordcount neq 0 and validate_company_id.userDSN neq "">
		<cfquery name="get_DB_DATA" datasource="payroll_main">
			SELECT DS_NAME FROM payroll_dscontrol WHERE CompID="#form.companyid#"
		</cfquery>

		<cfquery name="validateEmp" datasource="#get_DB_DATA.DS_NAME#">
			SELECT * 
			FROM EMP_USERS E
			INNER JOIN 
			PMAST P 
			ON e.empno=p.empno
			WHERE 
			UserName="#form.userid#"
			AND UserPass="#form.userpwd#"
			AND CompanyID="#form.companyid#"
			AND p.paystatus ="A"
			<!--- AND status = '1'; --->
		</cfquery>
    <cfelse>
		<cflocation url="login/login.cfm?status=failed&msg=Incorrect+username+or+password.+Please+try+again." addtoken="no">
    </cfif>
	
	<cfif validateUser.Recordcount eq 1 and validlogin eq 1>
		<cfloginuser name="#form.userid#" password="#form.userpwd#" roles="admin">
		
		
		<cfif left(form.userid,8) eq 'testuser' or left(form.userid,6) eq 'testhr' or right(tempID, 4) eq 'test'>

    	<cfquery name="updatemain" datasource="payroll_main">
            Update 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
            SET 
            userCmpID = <cfqueryparam cfsqltype="cf_sql_char" value="manpowertest">, 
            userDsn = <cfqueryparam cfsqltype="cf_sql_char" value="manpowertest_p">
            WHERE
            USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
            </cfquery>

		<cfelse>
        <cfquery name="updatemain" datasource="payroll_main">
            Update 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
            SET 
            userCmpID = <cfqueryparam cfsqltype="cf_sql_char" value="manpower">, 
            userDsn = <cfqueryparam cfsqltype="cf_sql_char" value="manpower_p">
            WHERE
            USERID = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
            </cfquery>
		</cfif>
            
		<cfset time = now()>
		<cfset SESSION.loginTime = "#time#">
		<cfset SESSION.isLogIn = "Yes">
		<cfset SESSION.userCty = "#validateUser.userCmpID#">
		<cfset SESSION.pass = form.userPwd>
		
		<cfquery name="insert_user_log" datasource="payroll_main">
			INSERT INTO USERLOG 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status
			) 
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.userid#">,
				now(),
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.companyid#">,
				'#cgi.remote_addr#',
				'Success'
			)
		</cfquery>
        
        
				<cfset SessionRotate()>
                
        <cfquery name="resetbrute" datasource="payroll_main">
        	DELETE FROM tracklogin WHERE companyid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">
        	and userid = <cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#">
        </cfquery>
        
        <cfquery name="deleteallold" datasource="payroll_main">
			DELETE FROM tracklogin where timetry < "#nowtimezone#"
        </cfquery>
		<cfquery name="update_user_last_login" datasource="payroll_main">
			UPDATE 
			<cfif #testFlag# eq "TRUE">
				hmuserstest
			<cfelse>
				hmusers
			</cfif> 
			SET 
			lastlogin=#now()# 
			WHERE userid="#form.userid#"
			AND userpwd="#form.userpwd#"
			AND userCmpID="#form.companyid#"
		</cfquery>
        
    <cfelseif validateEmp.Recordcount eq 1 >
    
    <cfloginuser name="#form.userid#" password="#form.userpwd#" roles="employee">
		
		<cfset time = now()>
		<cfset SESSION.loginTime = "#time#">
		<cfset SESSION.isLogIn = "Yes">
		<cfset SESSION.userCty = "#validateEmp.CompanyID#">
		<cfset SESSION.pass = form.userpwd>
		
		<cfquery name="insert_user_log" datasource="#get_DB_DATA.DS_NAME#">
			INSERT INTO EMP_USERS_LOG 
			(
				USER_ID,
                LOGDT,
                LOG_IP
			) 
			VALUES
			(
				'#form.userid#',
				now(),
				'#cgi.remote_addr#'
			)
		</cfquery>
        <cfset SessionRotate()>
   		<cflock timeout=20 scope="Session" type="Exclusive">
		<cfset Session.DSNAME = #get_DB_DATA.DS_NAME#>
		</cflock>
 	<cfset identity = 1>
	<cfelse>
		<!--- <cfloginuser name="#form.userid#" password="#form.userpwd#" roles="">
		
		<cfset time = now()>
		<cfset SESSION.loginTime = "#time#">
		<cfset SESSION.isLogIn = "No">
		<cfset SESSION.userCty = "#validateUser.userCmpID#">
		<cfset SESSION.pass = form.userpwd> --->
		
		<cfquery datasource="payroll_main">
			INSERT INTO USERLOG 
			(
				userlogid,
				userlogtime,
				udatabase,
				uipaddress,
				status
			) 
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.userid#">,
				now(),
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.companyid#">,
				'#cgi.remote_Addr#',
				'Failure'
			)
		</cfquery>
		
      
		<cfquery name="trackbruteforce" datasource="payroll_main">
        INSERT INTO tracklogin (ip,companyid,timetry,userid)
        VALUES ('#cgi.remote_Addr#',<cfqueryparam cfsqltype="cf_sql_char" value="#form.companyid#">,now(),<cfqueryparam cfsqltype="cf_sql_char" value="#form.userid#"> )
        </cfquery>
        
		<cflocation url="login/login.cfm?status=failed&msg=Incorrect+username+or+password.+Please+try+again." addtoken="no">
		<cfabort>
	</cfif>
</cflogin>

<cfif identity eq 1>

<cflocation url="/eleave/" addtoken="no">

</cfif>


<cfif isdefined("SESSION.isLogIn") and SESSION.ISLOGIN eq "Yes" and CGI.SCRIPT_NAME eq "login.cfm">
	<h1>You are already logged in.</h1> 
    <cflocation url="home.cfm">
</cfif>
<!--- <cfif isdefined("SESSION.isLogIn") and SESSION.ISLOGIN eq "Yes" and CGI.SCRIPT_NAME neq "login.cfm">
	<h1>You are already logged in.</h1> 
    <cflocation url="/test.cfm">
</cfif> --->
