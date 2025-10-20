<cfoutput>
<cfif #form.leavebalance# lt #form.days_d#> <!---leave insufficient--->
	<script>
		alert("You have insufficient leave balance!");
		window.location = '/eleave/selectJO.cfm?type=leave';
	</script>
<cfelse>
	<cfif isdefined('form.pno')>
    <cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
    SELECT empno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
    </cfquery>
    <cfif getempno.empno neq get_comp.empno>
    <cfabort>
    </cfif>
    </cfif>
    <cfset dts = replace(dsname,'_p','_i')>
    
    <cfquery name="getemail" datasource="#dts#">
    SELECT * FROM notisetting
    </cfquery>
    
    <cfset template = getemail.template8>
    <cfset header = getemail.header8>
    
    <cfset createdBY = form.createdBY >
    <cfset empno = form.empno>
    <cfset name = form.name>
    <cfset leaveType = form.leaveType>
    <cfset datefrom = form.dateFrom>
    <cfset dateto = form.dateTo>
    <cfset leave_option = form.leave_option>
    <cfset email = form.email>
    <cfset applicant_remarks = form.applicant_remarks>
    <cfset mstaff = "N">
    <cfset leavelist = "">
    
    <cfif mstaff eq "N">
        <cfif form.timeTo neq "">
            <cfset form.timeto = replace(form.timeto,'.',':','all')>
            <cfset timeTo =  #TimeFormat(form.timeTo, "HH:mm")# >
        <cfelse>
            <cfset timeTo = '00:00' >
        </cfif>
    
        <cfif form.timeFr neq "">
        <cfset form.timeFr = replace(form.timeFr,'.',':','all')>
            <cfset timeFr = #TimeFormat(form.timeFr, "HH:mm")# >
        <cfelse>
            <cfset timeFr = '00:00' >
        </cfif>
    
        <cfset hours = TimeFormat(DateAdd('n', DateDiff('n', timeFr, timeTo) ,'00:00'), 'HH:mm')>
        <cfif isdefined('form.halfday') eq false>
            <cfif hours eq "00:00">
                <cfif isdefined('form.days') eq false>
                <h3>Time Format is Wrong. The format should be HH:MM.<br />Click <u><a style="cursor:pointer" onclick="history.go(-1);">here</a></u> to go back.
                </h3>
                <cfabort>
                </cfif>
                <cfset days = #val(form.days)#>
            <cfelseif hours LTE "2:00">
                <cfset days = 0.25>
            <cfelseif hours LTE "4:00">
                <cfset days = 0.5>
            <cfelseif hours LTE "6:00">
                <cfset days = 0.75>
            <cfelseif hours LTE "8:00">
                <cfset days = 1>
            </cfif>
        </cfif>
        
        <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateFrom#" returnvariable="cfc_lfdate" />
        <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#form.dateTo#" returnvariable="cfc_ltdate" />
    
        <cfquery name="getcontract" datasource="#dts#">
        SELECT * FROM placement WHERE placementno = '#form.pno#'
        </cfquery>
        
        <cfinvoke component="cfc.dateformat" method="dbDateFormat" inputDate="#getcontract.contract_end_d#" returnvariable="cfc_condate" />
    
        <cfquery name="insert_application" datasource="#dts#" result="result">
        INSERT into leavelist (placementno,leavetype,days,submitted,remarks,submited_on,submit_date,startdate,enddate,
                                contractenddate,startampm,endampm,status) <!---leavebalance,timefr,timeto--->
        values
        ('#form.pno#','#leaveType#','#val(days)#','Y','#applicant_remarks#',now(),now(),'#cfc_lfdate#','#cfc_ltdate#','#cfc_condate#'
        ,'#timefr#','#timeto#','IN PROGRESS')
        </cfquery>
            
         <cfquery name="getdata" datasource="#dts#">
         SELECT * FROM leavelist a 
         LEFT JOIN placement b on a.placementno = b.placementno
         LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
         WHERE id = '#result.generatedkey#'
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
        <cfif isvalid("email",trim(getdata.hrmgremail))>
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.hrmgremail)#" subject="#header#">>
                #template#
            </cfmail>
        </cfif>
        </cfif>
    
        <script type="text/javascript">
            window.location.href="/eleave/selectjo.cfm?type=leavestatus";
        </script>
    </cfif>
</cfif>
</cfoutput>