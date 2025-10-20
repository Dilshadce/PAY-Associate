<cfquery name="default_mail_qry" datasource="payroll_main">
    SELECT notif_email, default_email, emailserver, emailaccount, emailpassword, emailport, ELEAVEEMAIL,  	 
    ELEAVEAPEMAIL, myear, emailsecure FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

    <cfif #default_mail_qry.notif_email# neq "" and #default_mail_qry.default_email# eq "Y">
        <cfset emailAddress = "#default_mail_qry.notif_email#">	
    <cfelse> 	
        <cfset emailAddress = "noreply@mynetiquette.com">	
    </cfif>	
    
    <cfif default_mail_qry.emailserver eq "">
        <cfset emailserver = "smtpcorp.com">
        <cfset emailaccount = "noreply@mynetiquette.com">
        <cfset emailpassword = "Netiquette168">
        <cfset emailport = "2525">
        <cfset emailssl = "no">
        <cfset emailtls = "no">
    <cfelse>
        <cfset emailserver = default_mail_qry.emailserver>
        <cfset emailaccount = default_mail_qry.emailaccount>
        <cfset emailpassword = default_mail_qry.emailpassword>
        <cfset emailport = default_mail_qry.emailport>
        <cfif default_mail_qry.emailsecure neq "">
            <cfif default_mail_qry.emailsecure eq "ssl">
                <cfset emailssl = "yes">
                <cfset emailtls = "no">
            <cfelseif default_mail_qry.emailsecure eq "tls">
                <cfset emailssl = "no">
                <cfset emailtls = "yes">
            </cfif>
        <cfelse>
            <cfset emailssl = "no">
            <cfset emailtls = "no">
        </cfif>
 	</cfif>
   
   
<cfset ccEmailList = "">
<cfquery name="getloop" datasource="#dts#">
    SELECT c.*,pm.name,claimdes from claimlist c left join pmast pm on c.empno = pm.empno
    WHERE status 
    <cfif company_details.eclaimapp eq "deptadmin">
     IN ('Submitted For Approval', 'close','approve') group by empno
    <cfelseif company_details.eclaimapp eq "admindept">
     IN ('Submitted For Approval 2', 'close','approve') group by empno
    </cfif>
</cfquery>

<cfloop query="getloop"> 
<cfif company_details.eclaimapp eq "deptadmin">
<cfquery name="getdetails" datasource="#dts#">
    SELECT * FROM claimlist c 
    INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
    INNER JOIN (SELECT deptdesp,deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
    INNER JOIN (SELECT entryid, usercmpid,username FROM payroll_main.users) AS u ON d.headdept = u.entryid
    WHERE status IN ('Submitted For Approval', 'close','approve') AND empno='#getloop.empno#' and usercmpid = 		    '#HcomID#'
</cfquery>
    <cfquery name="select_email_cc" datasource="#dts#">
		SELECT email, empno, companyid FROM emp_users 
		WHERE empno = '#getloop.empno#'
        UNION ALL
        SELECT useremail as email,entryid,usercmpid FROM payroll_main.users WHERE
        usercmpid="#HcomID#" and getmail ="Y" and entryid !="#HEntryID#"
    </cfquery>
    
    <cfset receiver = "All">
    <cfset subject = "2nd Level Claim Approval Notification">
    
    <cfloop query="select_email_cc">
    	<cfif findnocase(select_email_cc.email, ccemaillist) eq 0>
	        <cfset ccEmailList = ccEmailList & select_email_cc.email & ";" >
		</cfif>
    </cfloop>
    
<cfelseif company_details.eclaimapp eq "admindept">
<cfquery name="getdetails" datasource="#dts#">
    SELECT * FROM claimlist c 
    INNER JOIN (select name,empno as pempno,deptcode from pmast) AS p ON c.empno = p.pempno 
    INNER JOIN (SELECT deptdesp,deptcode, headdept FROM dept) AS d ON d.deptcode =  p.deptcode 
    INNER JOIN (SELECT entryid, usercmpid,username as uusername FROM payroll_main.users) AS u ON d.headdept = u.entryid
    WHERE status IN ('Submitted For Approval 2', 'close','approve') AND empno='#getloop.empno#' and usercmpid = 		    '#HcomID#'
</cfquery>
    <cfquery name="select_email_cc" datasource="#dts#">
		SELECT email, empno, companyid FROM emp_users 
		WHERE empno = '#getloop.empno#'
        UNION ALL
        SELECT useremail as email,entryid,usercmpid
        FROM payroll_main.users 
        where entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdetails.headdept#"> 
        and usercmpid="#HcomID#" and getmail ="Y";
    </cfquery>
    
    <cfset receiver = #getdetails.uusername#>
    <cfset subject = "2nd Level Claim Approval For " & #getdetails.name# & " - Department : " & #getdetails.deptdesp#>

    <cfloop query="select_email_cc">
    	<cfif findnocase(select_email_cc.email, ccemaillist) eq 0>
	        <cfset ccEmailList = ccEmailList & select_email_cc.email & ";" >
		</cfif>
    </cfloop>
</cfif>

<cfif ccemaillist neq "">
	<cfmail from="#emailAddress#" 
            to="#ccEmailList#"
            subject="#subject#"
            type="html" server="#emailserver#"
            username="#emailaccount#"
            password="#emailpassword#"
            port="#emailport#"
            usessl="#emailssl#" 
            usetls="#emailtls#">
                
		<p>Dear #reReplace(receiver,"(^[a-z]|\s+[a-z])","\U\1","ALL")#,</p>
		<p>To be inform that there are claim(s) submission pending for your approval.</p>
		<p>Details as below: </p>
		<p>Employee No : #getloop.empno# ( #getloop.name# ) </p>
            <table border ="1">
			<tr>
            <td width="150" align="center">Claim Description</td>
            <td width="100" align="center">Claim Amount</td>
            <td width="200" align="center">Remarks</td>
            <td width="120" align="center">Updated On</td>
            </tr>
            <cfloop query="getdetails">
                <cfoutput>
                    <tr>
                    <td align="center">#getdetails.claimdes#</td>
                    <td align="right">#numberformat(getdetails.claimamount,'.__')#</td>
                    <td align="left">#getdetails.remarks#</td>
                    <td align="center">#getdetails.updatedon#</td>
                    </tr>
                </cfoutput>
            </cfloop>
        </table>
		<br />
		From: Netiquette Payroll System<br />
		Company ID: #HComID#
		<p style="font-size:smaller">This email is auto generated by system. Please do not reply to this email.</p>
    </cfmail>
</cfif> 
</cfloop>
