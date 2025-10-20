<cfset dts2 = replace(dts,'_p','_i')>
<cfoutput>
<cfif isdefined('form.leaveid') eq false>
    <script type="text/javascript">
    alert('Please Kindly Select At Least One Leave');
    </script>
    <cfabort>
</cfif>

<cfquery name="getdate" datasource="#dts_main#">
    SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
    
<cfloop list="#form.leaveid#" index="a">
    <cfset url.remarks = "">
    <cfset url.leaveid = a>
    
    <cfset finalapprove = 0>
    <cfset status = "">
  <!---edited by alvin 20170101--->  
    <cfquery name="getplacementdata" datasource="#dts2#">
    	select *
        FROM leavelist as leavelists
        LEFT join placement as placements
        ON leavelists.placementno = placements.placementno
        WHERE id = '#url.leaveid#';
    </cfquery>
 <!---edited--->   
    <cfquery name="checkcancellve" datasource="#dts2#">
        SELECT id, placementno, leavetype FROM leavelist WHERE id = '#url.leaveid#'
    </cfquery>
    
    <!---edited by alvin 20170101--->
    <cfif checkcancellve.recordcount neq 0>
    	<cfif evaluate('getplacementdata.#checkcancellve.leavetype#days') lt val(getplacementdata.days)>
        	
        <cfelse>
            <cfquery name="approve_leave" datasource="#dts2#">
            UPDATE leavelist SET STATUS = "APPROVED",updated_by = "#HUserName#", mgmtremarks = "#url.remarks#", updated_on = now() WHERE id = #url.leaveid#
            </cfquery>
            <cfset finalapprove = 1>
        </cfif>
    </cfif>
   <!---edited--->
    <cfif finalapprove eq 1>
   
        <cfset mon = #numberformat(getdate.mmonth,'00')# >
        <cfset yrs = getdate.myear>
        
        <cfquery name="getemail" datasource="#dts#">
        SELECT * FROM notisetting
        </cfquery>
        
        <cfset template = getemail.template9>
        <cfset header = getemail.header9>
        
         <cfquery name="getdata" datasource="#dts2#">
         SELECT * FROM leavelist a 
         LEFT JOIN placement b on a.placementno = b.placementno
         LEFT JOIN #dts#.pmast c on b.empno = c.empno 
         WHERE id = "#url.leaveid#"
         </cfquery>
        
        <cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;leavetype&amp;,&amp;datestart&amp;,&amp;dateend&amp;,&amp;day&amp;,&amp;timefrom&amp;,&amp;timeto&amp;,&amp;remarks&amp;,&amp;hcomid&amp;">
        <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #HComID#">
    
        <cfset templatelist2 = "&empno&, &name&, &leavetype&, &datestart&, &dateend&, &day&, &timefrom&, &timeto&, &remarks&, &HComID&">
        <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #getdata.leavetype#, #dateformat(getdata.startdate,'dd/mm/yyyy')#, #dateformat(getdata.enddate,'dd/mm/yyyy')#, #getdata.days#, #getdata.startampm#, #getdata.endampm#, #getdata.remarks#, #ucase(HComID)#">
    
        <cfset count1 = 0>
        <cfloop list="#templatelist1#" index="i" delimiters=",">
            <cfset count1 += 1>
            <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
        </cfloop>
    
        <cfset count2 = 0>
        <cfloop list="#templatelist2#" index="i" delimiters=",">
            <cfset count2 += 1>
            <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
        </cfloop>
        
        <cfif getcontract.recordcount NEQ 0>
        <cfif getdata.email neq "">
            <cfmail from="#emailaccount#" to="#trim(getdata.email)#" subject="#header#" 
            type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.email)#" subject="#header#">
                <html>#template#</html>
            </cfmail>
            <cfmail from="#emailaccount#" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" 
            type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">
        <cfif isvalid("email",trim(getdata.mppicemail)) or isvalid("email",trim(getdata.mppicemail2)) or isvalid("email",trim(getdata.mppicspemail))>   
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#">
           <html> #template2# </html>
        </cfmail>
        </cfif>
        </cfif>
        </cfif>
        
        <cfquery name="getempno" datasource="#dts2#">
        SELECT empno,leavetype FROM leavelist a 
        LEFT JOIN placement b on a.placementno = b.placementno
        WHERE id = "#url.leaveid#"
        </cfquery>        
        
        <cfif getempno.recordcount eq 0>
        <cfoutput>
        <script type="text/javascript">
        alert('Employee Record Not Found!');
        history.go(-1);
        </script>
        </cfoutput>
        <cfabort>
        </cfif>
     </cfif>   
	
</cfloop>
    
<!---<script type="text/javascript">
alert('Approve Success!');
window.location.href = 'LeaveApprovalMain.cfm';
</script>--->

</cfoutput>