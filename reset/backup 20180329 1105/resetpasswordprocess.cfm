<cfsetting showDebugOutput = 'NO'>
<cfoutput>
    <!---<cflocation url="resetsuccess.cfm" addtoken="no">--->
    <cfquery datasource="manpower_p">
	    SET SESSION binlog_format = 'MIXED';
    </cfquery>
    <cfset validuser = ''>
    <cfset validemail = ''>
    <cfset name = ''>
    <cfset uuid = "#CreateUUID()#">
    
    <cfquery name="checkhm" datasource="payroll_main">                            <!---Check hiring manager validity--->
        SELECT userid, username, useremail FROM hmusers WHERE userid = '#trim(form.userid)#'
    </cfquery>
    
    <cfif #checkhm.recordcount# EQ 0>
        <cfquery name="checkuser" datasource="manpower_p">                        <!---Check associate validity--->
            SELECT emp.username, pm.name, CASE WHEN pm.workemail = "" THEN pm.email ELSE pm.workemail END AS mailaddress
            FROM emp_users emp
            LEFT JOIN pmast pm ON emp.empno = pm.empno
            WHERE emp.username = '#trim(form.userid)#'
        </cfquery>
        
        <cfif #checkuser.recordcount# NEQ 0>                                     <!---Associate valid--->
            <cfset validuser = "#checkuser.username#">
            <cfset validemail = "#trim(checkuser.mailaddress)#">
            <cfset name = "#checkuser.name#">
            
            <cfquery name="reset_emp_account" datasource="manpower_p">
                UPDATE emp_users 
                SET
                <!---UserPass = "#hash(newitem)#",
                realpass = "#newitem#",
                emailsent = now()--->
                defaultkey = "#uuid#"
                WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validuser#">
            </cfquery>
        </cfif>
    <cfelse>
        <cfset validuser = "#checkhm.userid#">                             <!---Hiring manager valid--->
        <cfset validemail = "#trim(checkhm.useremail)#">                         
        <cfset name = "#checkhm.username#">
            
            <cfquery name="reset_hm_account" datasource="payroll_main">
                UPDATE hmusers 
                SET 
                <!---UserName = "#sendemail#" ,---> 
                <!---UserPass = "#hash(newitem)#",
                realpass = "#newitem#",
                emailsent = now()--->
                defaultkey = "#uuid#"
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validuser#">
            </cfquery>   
    </cfif>
    
    <cfif "#validuser#" NEQ "" AND "#validemail#" NEQ "">
        <cfset securitylink = Hash("#validuser##uuid#")>
        <cfmail from="donotreply@manpower.com.my" failto="myhrhelpdesk@manpower.com.my" to="#validemail#" subject="MP4U Password Reset" 
                replyto="myhrhelpdesk@manpower.com.my" type="html"
                bcc="myhrhelpdesk@manpower.com.my,alvin.hen@manpower.com.my,jiexiang.nieo@manpower.com.my,alvinh.mpg@gmail.com,nieo.netiquette@gmail.com">
            Dear #name#,<br/><br/>
            <!---Your user id for MP4U System is #validuser#. The default password is #trim(newitem)#.<br/>--->
            A password reset request has been sent. Kindly click on this <a href="https://security.mp4u.com.my?uid=#EncodeForURL(validuser)#&link=#securitylink#" style="color: blue">link</a> to change your password.
            
            <br /> <br />This is a system generated email.
            <!---Please login at <a href="https://www.mp4u.com.my">https://www.mp4u.com.my</a> and change your password.--->
        </cfmail>
    </cfif>
    
    <cfquery name="log_reset" datasource="manpower_p">
       INSERT INTO reset_pass_log
       (username_requested, requested_on)
       VALUES
       ("#form.userid#", now())        
    </cfquery>
    
    <cfform action="resetsuccess.cfm" target="_self" name="resetpass" id="resetpass">
        <cfinput name="username" value="#trim(form.userid)#">
    </cfform>
    
    <script>
        document.getElementById('resetpass').submit();    
    </script>
    
</cfoutput>