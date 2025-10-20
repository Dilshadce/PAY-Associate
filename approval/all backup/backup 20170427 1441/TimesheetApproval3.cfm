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
    <cfset uploaddir = "/upload/#dts#/signature/timesheet/">
    <cfset uploaddir = expandpath("#uploaddir#")> 
    <cfif directoryexists(uploaddir) eq false>
        <cfdirectory action="create" directory="#uploaddir#" >
    </cfif>
    <cfif isdefined('form.uploadfilefield')>
        <cfif form.uploadfilefield neq "">
        <cffile action="upload" destination="#uploaddir#" nameconflict="makeunique" filefield="uploadfilefield" >
        </cfif>
    </cfif>
    <cfquery name="Approve" datasource="#dts#">
     UPDATE timesheet SET STATUS = "APPROVED",updated_by = "#HUserName#", mgmtremarks = "#form.remarks#", updated_on = now(), 
     signdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="/upload/#dts#/signature/timesheet/#file.serverfile#">     
     WHERE tmonth = #form.id# and placementno = '#form.placementno#'
    </cfquery>
    
    <cfquery name="getemail" datasource="#dts2#">
    SELECT * FROM notisetting
    </cfquery>
    
    <cfset template = getemail.template2>
    <cfset header = getemail.header2>
    <cfset template2 = getemail.template3>
    <cfset header2 = getemail.header3>

    <cfquery name="getdata" datasource="#dts2#">
    SELECT * FROM #dts#.timesheet a 
    LEFT JOIN placement b on a.placementno = b.placementno
    LEFT JOIN #dts#.pmast c on b.empno = c.empno 
    WHERE tmonth = '#form.id#' AND a.placementno = '#form.placementno#'
    </cfquery>
    
    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">
    
    <cfset templatelist2 = "&empno&, &name&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #ucase(HComID)#">
    
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
    
            <!---
    <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;leavetype&amp;,&amp;startdate&amp;,&amp;enddate&amp;,&amp;days&amp;,&amp;startampm&amp;,&amp;endampm&amp;,&amp;remarks&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">
    
    <cfset templatelist2 = "&empno&, &name&, &leavetype&, &datestart&, &dateend&, &days&, &timefrom&, &timeto&, &remarks&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #ucase(HComID)#">
    
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
    SELECT empno,leavetype FROM leavelist a LEFT JOIN placement b on a.placementno = b.placementno WHERE id = "#url.id#"
    </cfquery>
    --->
    <!---<cfif getempno.recordcount NEQ 0>--->

    <cfif getdata.email neq "">
<!---            <cfmail from="#emailaccount#" to="#trim(getdata.email)#" subject="#header#" 
        type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.email)#" subject="#header#">>
            #template#
        </cfmail>
<!---            <cfmail from="#emailaccount#" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" 
        type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
        <cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#">
            #template2#
        </cfmail>
        </cfif>
    </cfif>
    
    <cflocation url='/approval/timesheetapprovalmain.cfm'>
    
<cfelse>
    <cfform name="pform" method="post" action="timesheetapproval3.cfm" enctype="multipart/form-data">
    <table>
        <tr>
            <th width="200px">Timesheet ID</th>
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
            <input type="hidden" name="placementno" class="placementno" value="#url.placementno#">
        </td>     
        </tr>
        <tr>
            <td/>    
            <td><input type="submit" id="submit" name="submit" value="Approve">
                <input type="button" id="back" name="back" onclick="window.open('/approval/timesheetapprovalmain.cfm','_self')" value="Back"></td>
        </tr>

    </cfform>         
</cfif>
</cfoutput>
</body>
</html> 
