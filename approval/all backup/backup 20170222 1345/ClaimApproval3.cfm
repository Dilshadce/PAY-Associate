<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<script src="/javascripts/tabber.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<title>Timesheet Approval</title>
<link rel="shortcut icon" href="/PMS.ico" /> 
<cfset dts2 = replace(dts,'_p','_i')>
<cfoutput>

<cfif isdefined("form.uploadfilefield")> 
    <cfset uploaddir = "/upload/#dts#/signature/claim/">
    <cfset uploaddir = expandpath("#uploaddir#")> 
    <cfif directoryexists(uploaddir) eq false>
        <cfdirectory action="create" directory="#uploaddir#" >
    </cfif>
    <cfif isdefined('form.uploadfilefield')>
        <cfif form.uploadfilefield neq "">
        <cffile action="upload" destination="#uploaddir#" nameconflict="makeunique" filefield="uploadfilefield" >
        </cfif>
    </cfif>
    <cfquery name="Approve" datasource="#dts2#">
     UPDATE claimlist SET STATUS = "APPROVED",updated_by = "#HUserName#", mgmtremarks = "#form.remarks#", updated_on = now(), 
     signdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="/upload/#dts#/signature/claim/#file.serverfile#">     
     WHERE id = #form.id# 
    </cfquery>
    
    <cfquery name="getemail" datasource="#dts2#">
    SELECT * FROM notisetting
    </cfquery>
    
    <cfset template = getemail.template16>
    <cfset header = getemail.header16>
    <cfset template2 = getemail.template17>
    <cfset header2 = getemail.header17>
    
     <cfquery name="getdata" datasource="#dts2#">
     SELECT * FROM claimlist a 
     LEFT JOIN placement b on a.placementno = b.placementno
     LEFT JOIN #dts#.pmast c on b.empno = c.empno 
     WHERE id = '#form.id#'
     </cfquery>
    
    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;claimtype&amp;,&amp;claimamount&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.claimamount#, #getdata.remarks#, #ucase(HComID)#, #getdata.mgmtremarks#, #getdata.status#">

    <cfset templatelist2 = "&empno&, &name&, &claimtype&, &remarks&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.claimtype#, #getdata.remarks#, #ucase(HComID)#">

    <cfset count1 = 0>
    <cfloop list="#templatelist1#" index="i" delimiters=",">
        <cfset count1 += 1>
        <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
        <cfset template2 = replace(template2,i,listgetat(replacelist1,count1),'all')>
    </cfloop>

    <cfset count2 = 0>
    <cfloop list="#templatelist2#" index="i" delimiters=",">
        <cfset count2 += 1>
        <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
        <cfset header2 = replace(header2,i,listgetat(replacelist2,count2),'all')>
    </cfloop>
    
    <cfquery name="getempno" datasource="#dts2#">
    SELECT empno,claimtype FROM claimlist a LEFT JOIN placement b on a.placementno = b.placementno WHERE id = '#form.id#'
    </cfquery>
            <cfset emailserver = "smtpcorp.com">
    <cfset emailaccount = "noreply@mynetiquette.com">
    <cfset emailpassword = "Netiquette168">
    <cfset emailport = "2525">
    <cfset emailssl = "no">
    <cfset emailtls = "no">
    <cfif getempno.recordcount NEQ 0 and getdata.email neq "">
<!---        <cfmail from="#emailaccount#" to="#trim(getdata.email)#" subject="#header#" 
        type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.email)#" subject="#header#">
            #template#
        </cfmail>
<!---        <cfmail from="#emailaccount#" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" 
        type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
        <cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#">
            #template2#
        </cfmail>
        </cfif>
    </cfif>
    
    <cflocation url='/approval/claimapprovalmain.cfm'>
    
<cfelse>
    <cfform name="pform" method="post" action="claimapproval3.cfm" enctype="multipart/form-data">
    <table>
        <tr>
            <th width="200px">Claim ID</th>
            <td>#url.id#</td>
        </tr>
        <tr>
            <th>Remarks</th>
            <td><input type="text" id="remarks" name="remarks" value=""></td>
        </tr>   
        <tr>
        <th>Signed Document</th>
        <td>
            <cfinput type="file" name="uploadfilefield" id="uploadfilefield" required="yes" message="Must attach receipt">
            <input type="hidden" name="id" class="id" value="#url.id#">
        </td>     
        </tr>
        <tr>
            <td/>    
            <td><input type="submit" id="submit" name="submit" value="Approve">
                <input type="button" id="back" name="back" onclick="window.open('/approval/claimapprovalmain.cfm','_self')" value="Back"></td>
        </tr>

    </cfform>         
</cfif>
</cfoutput>
</body>
</html> 
