<!---   <script src="javascripts/prototype.js" type="text/javascript"></script>
	<script src="javascripts/idleState.js" type="text/javascript"></script> --->
<cfsilent><!---
************************************************************************
Program Name : application.cfm
Program : To SET Application informations to all pages
************************************************************************
--->
<cfapplication name="payroll" sessionmanagement="yes" clientmanagement="no" sessiontimeout="#createTimespan(0,1,0,0)#">

<cfinclude template="/login/loginProcess.cfm">

<!---<cferror    type ="request"   template = "/defaultError.cfm"   mailTo = "shicai@mynetiquette.com">--->

<!--- <cfset tracker = createObject('java', 'coldfusion.runtime.SessionTracker')> 
<cfset sessions = tracker.getSessionCollection(application.applicationName)> 
<cfloop item='S'collection='#sessions#'> 
<cfif structKeyExists(sessions[S],'Auth')> 
<cfif sessions[S].Auth.UserID EQ LoginQ.UserID> 
<cflocation url='loginerr.cfm' addtoken='no'> 
</cfif> 
</cfif> 
</cfloop> --->


<cfparam name="SESSION.loginTime" default="">  
<cfparam name="SESSION.isLogIn" default="No">
<cfparam name="SESSION.path" default="">
<cfparam name="session.hcredit_limit_exceed" default="">
<cfparam name="session.bcredit_limit_exceed" default="">
<cfparam name="session.customercode" default="">
<cfparam name="session.tran_refno" default="">
<cfparam name="session.pass" default="">
<cfset sessiontime = 30>

<cfquery datasource='payroll_main' name="getHQstatus">
	Select * from 
	<cfif isdefined('SESSION.usercty')>
		<cfif #SESSION.usercty# eq "manpowertest">
			hmuserstest
		<cfelse>
			hmusers 
		</cfif>	
	<cfelse>
		hmusers 
	</cfif>	
	where userId = '#GetAuthUser()#'
    <!---Updated by Nieo 201905417 1104, to solve bugs in password reset--->
    <cfif #CGI.script_name# NEQ '/logout.cfm'>
        AND userpwd = "#SESSION.pass#"
    </cfif>
    <!---Updated by Nieo 201905417 1104, to solve bugs in password reset--->
</cfquery>
    
<cfif isdefined('session.checkprofile')>
    <cfset gethqstatus.userDsn = ''>
</cfif>

<cfif gethqstatus.userDsn neq "">
	<cfset dts = gethqstatus.userDsn>
	<cfset localdb = gethqstatus.userDsn>
	<cfset dts_main = "payroll_main">
	<cfset HEntryID = getHQstatus.entryID>
	<cfset HcomID = getHQstatus.userCmpID>
	<cfset HUserID = getHQstatus.userId>
	<cfset HUserName = getHQstatus.userName>
	<cfset HUserGrpID = getHQstatus.UserGrpID>
	<cfset HUserCty = getHQstatus.UserCty>
	<cfset Huseremail = getHQstatus.userEmail>
	<cfset Hserver = "mail.singnet.com.sg">
	<cfset HVariable1 = "">
	<cfset HDir = getHQstatus.userDirectory>
	<cfset HRootPath = "C:\Inetpub\wwwroot\payasia">
	<cfquery name="userpin_qry" datasource="#dts#">
		SELECT pin from userpin where usergroup = "#getHQstatus.userGrpID#"
	</cfquery>
	<cfset Hpin = userpin_qry.pin >
	<cfif getHQstatus.userGrpID eq "super">
		<cfset Hpin = 0>
	</cfif>
	<cfquery name="gsetup_qry" datasource="payroll_main">
		SELECT ccode,mmonth,myear,comp_name from gsetup where comp_id = '#HcomID#'
	</cfquery>
	<cfset HuserCcode = gsetup_qry.ccode>
	<cfset HcomCode = gsetup_qry.comp_name>
	<cfset Hmmonth = gsetup_qry.mmonth>
	<cfset Hmyear = gsetup_qry.myear>
        
    <cfif isdefined('dts')>
        <cfquery datasource="#dts#">
            SET SESSION binlog_format = 'MIXED'
        </cfquery>
    </cfif>

<cfelse>
		
        <cfset HUserName = #GetAuthUser()#>
		<cfset HUserID = #GetAuthUser()#>
        
		<cfset DSNAME ="manpower_p">
   		<!---<cflock timeout=20 scope="Session" type="Exclusive">--->
        <cfif isdefined('Session.DSNAME')>
		  <cfset DSNAME = "#Session.DSNAME#" >
        </cfif>
            
        <cfif isdefined('DSNAME')>
            <cfquery datasource="#DSNAME#">
                SET SESSION binlog_format = 'MIXED'
            </cfquery>
        </cfif>
       
		<!---</cflock>--->
         <cfquery name="get_comp" datasource="#DSNAME#">
         SELECT * FROM emp_users WHERE username = "#GetAuthUser()#"
         </cfquery>
        <cfset HcomID = get_comp.companyID >
        <cfquery name="gsetup_qry" datasource="payroll_main">
            SELECT ccode,mmonth,myear,comp_name from gsetup where comp_id = '#HcomID#'
        </cfquery>
        <cfset HuserCcode = gsetup_qry.ccode>
        <cfset HcomCode = gsetup_qry.comp_name>
        <cfset Hmmonth = gsetup_qry.mmonth>
        <cfset Hmyear = gsetup_qry.myear>         
         
	<!--- <h2>Please assign a database for this user.</h2>
	<cfabort> --->
</cfif>



<!--- ADD ON 050608 --->
<!--- <cfif husergrpid eq "suser">
	<cfset thislevel = "standard">
<cfelseif husergrpid eq "guser">
	<cfset thislevel = "general">
<cfelseif husergrpid eq "luser">
	<cfset thislevel = "limited">
<cfelseif husergrpid eq "muser">
	<cfset thislevel = "mobile">
<cfelse>
	<cfset thislevel = husergrpid>
</cfif> --->
<!--- ADD ON 050608 --->
<!--- <cfquery name="getpin2" datasource="#dts#">
	select * 
	from userpin2 
	where level = '#thislevel#'
</cfquery> --->

<!--- REMARK ON 050608 AND REPLACE WITH THE UPPER ONE --->
<!---cfquery name="getpin2" datasource="#dts#">
	select * 
	from userpin2 
	where 
	<cfswitch expression="#husergrpid#">
		<cfcase value="super">level='super'</cfcase>
		<cfcase value="admin">level='admin'</cfcase>
		<cfcase value="suser">level='standard'</cfcase>
		<cfcase value="guser">level='general'</cfcase>
		<cfcase value="luser">level='limited'</cfcase>
		<cfcase value="muser">level='mobile'</cfcase>
	</cfswitch>
</cfquery--->
        

        
</cfsilent>

<!---Added Nieo, session timeout 20170804--->
    <cfif isdefined('SESSION.loginTime')>
        <cfif datediff('n',SESSION.loginTime,now()) gt sessiontime>
            <cfset SessionInvalidate()>
            <cflogout>
            <script>
                window.open("/logout.cfm?msg=sessionout", "_top");
            </script>
        </cfif>

        <cfset time = now()>
        <cfset SESSION.loginTime = "#time#">
    <cfelse>
        <cfset SessionInvalidate()>
        <cflogout>
        <script>
            window.open("/logout.cfm?msg=sessionout", "_top");
        </script>
    </cfif>
<!---End Added Nieo, session timeout 20170804--->

<cferror type="exception" template="/error/error.cfm">
    <cferror type="request" template="/error/error.cfm">
    <cferror type="validation" template="/error/error.cfm"> 
