<!DOCTYPE html>
<head>
  <meta charset="utf-8">
  <title>Accept a Signature · Signature Pad</title>
  <style>
    body { font: normal 100.01%/1.375 "Helvetica Neue",Helvetica,Arial,sans-serif; }
  </style>
  <link href="/js/signature/jquery.signaturepad.css" rel="stylesheet">
  <!--[if lt IE 9]><script src="/js/signature/flashcanvas.js"></script><![endif]-->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
</head>
<body>
<cfset dts2 = replace(dts,'_p','_i')>

<cfif isdefined('form.output')>
<!---    <cfthread name="processPhoto" action="run">--->
    
    <cfinclude template="/cfc/toImage2.cfm">
    <CFSET TheImage = sigJsonToImage(form.output)>
    
    <CFIF IsImage(TheImage)>
         <!--- Display Image inline --->
         <cfimage action = "writeToBrowser" source="#TheImage#">
    
         <!--- Save file --->
         <cfoutput>
         <cfset uploaddir = "/upload/#dts#/signature/claim/">
         <cfset uploaddir = expandpath("#uploaddir#")> 
         <cfif directoryexists(uploaddir) eq false>
            <cfdirectory action="create" directory="#uploaddir#" >
        </cfif>
         <cfset ImageWrite(TheImage, "#uploaddir#\#form.id#.png")>
         </cfoutput>
        <cfquery name="Approve" datasource="#dts2#">
         UPDATE claimlist SET STATUS = "APPROVED",updated_by = "#HUserName#", mgmtremarks = "#form.remarks#", updated_on = now(), 
         signdoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="/upload/#dts#/signature/claim/#form.id#.png">     
         WHERE id = #form.id# 
        </cfquery> 
    </CFIF>
<!---    </cfthread>--->
   
    <cfquery name="checkid" datasource="#dts2#">
     SELECT id FROM claimlist WHERE signdoc != '' and id = '#form.id#'
    </cfquery> 
    
    <cfif checkid.recordcount eq 0>
        <script type="text/javascript">
            alert("Please Sign First");
            history.go(-1);
        </script>
    <cfelse>
    
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
<!---            <cfmail from="#emailaccount#" to="#trim(getdata.email)#" subject="#header#" 
            type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.email)#" subject="#header#">
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

    
        <cflocation url='/approval/claimapprovalmain.cfm'> 
    </cfif>
<cfelse>

    <form method="post" action="claimapproval2.cfm" class="sigPad">
       <!--- <label for="name">Print your name</label>--->
        <!---<input type="text" name="name" id="name" class="name">--->
        <!---<p class="typeItDesc">Review your signature</p>--->
        <p class="drawItDesc">Draw your signature</p>
        <ul class="sigNav">
        <!---      <li class="typeIt"><a href="#type-it" class="current">Type It</a></li>--->
            <li class="drawIt"><a href="#draw-it">Draw It</a></li>
            <li class="clearButton"><a href="#clear">Clear</a></li>
        </ul>
    
<!---    <div id="signimgdiv" style>
        <p style="font-size:18px; font-weight:bolder; color:##F00">Signature</p>
        <img style="background-color:##FFF" src="/signature/123.png" width="288" height="185">
    </div>--->
    
    <div class="sig sigWrapper">
        <div class="typed"></div>
            <cfoutput>
            <canvas class="pad" width="280" height="80"></canvas>
            <input type="hidden" name="output" class="output" >
            <input type="hidden" name="id" class="id" value="#url.id#">
            </cfoutput>
        </div>
        <table>

        <tr>
            <th>Remarks</th>
            <td><input type="text" id="remarks" name="remarks" value=""></td>
        </tr>   
        </table>
        <button type="submit">Approve</button>
        <button type="button" onClick="location.href='/approval/claimapprovalmain.cfm'">Back</button>
    </form>
    
    <script src="/js/signature/jquery.signaturepad.js"></script>
    <script>
        $(document).ready(function() {
        $('.sigPad').signaturePad();
        });
    </script>
    <script src="/js/signature/json2.min.js"></script>

</cfif>
</body>