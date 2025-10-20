<cfif #url.action# EQ "create">
    <cfset schedule = "#form.scheduleDate#" & " #form.scheduleTime#">
    <cfquery name="insertSms" datasource="#dts#">
    	INSERT INTO smsemail (type, title, content, schedule, created_by, created_on, category, race)
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Promotion">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.content#">,
            <cfif #schedule# EQ " ">
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="0000-00-00 00:00:00">,
            <cfelse>
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#schedule#">,
            </cfif>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(Now(), 'yyyy-mm-dd HH:mm:ss')#">,
            "SMS",
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.race#">
        )       
    </cfquery>
    <cfquery name="getSms" datasource="#dts#">
    	SELECT id
        FROM smsemail
        ORDER BY id DESC
        LIMIT 1
    </cfquery>
    <cfif #form.scheduleTime# NEQ "">
        <cfschedule action = "update"
                    task = "#dts#_sendBodMsg_id=#getSms.id#"
                    operation = "HTTPRequest"
                    url = "http://crm.netiquette.asia/gold/bodAutoSend.cfm?dts=#dts#&cate=SMS&id=#getSms.id#&userid=#Huserid#&userloc=#Huserloc#"
                    startDate = "#dateformat(now(),'YYYY-MM-DD')#"
                    startTime = "#form.scheduleTime#"
                    interval = "once"
                    resolveURL = "Yes"
                    requestTimeOut = "1800">
    </cfif>
	<script>
        window.open("smsMaintenance.cfm","_self");
    </script>
<cfelseif #url.action# EQ "edit">
	<cfif isDefined("form.scheduleDate")>
    	<cfset schedule = "#form.scheduleDate#" & " #form.scheduleTime#">
    <cfelse>
    	<cfset schedule = "2015-06-10" & " #form.scheduleTime#">
    </cfif> 
	<cfquery name="updateSms" datasource="#dts#">
    	UPDATE smsemail
        SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">,
            content = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.content#">,
            <cfif #schedule# EQ " ">
            	schedule = <cfqueryparam cfsqltype="cf_sql_varchar" value="0000-00-00 00:00:00">,
            <cfelse>
            	schedule = <cfqueryparam cfsqltype="cf_sql_varchar" value="#schedule#">,
            </cfif>
            updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
            updated_on = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(Now(), 'yyyy-mm-dd HH:mm:ss')#">,
            race = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.race#">
        WHERE id = #url.id#
    </cfquery>
    <cfquery name="getSms" datasource="#dts#">
    	SELECT type
        FROM smsemail
        WHERE id = #url.id#
    </cfquery>
    <cfif #schedule# NEQ " ">
    	<cfif #getSms.type# EQ "Birthday">
            <cfschedule action = "update"
                        task = "#dts#_sendBodMsg_id=#url.id#"
                        operation = "HTTPRequest"
                        url = "http://crm.netiquette.asia/gold/bodAutoSend.cfm?dts=#dts#&cate=SMS&id=#url.id#&userid=#Huserid#&userloc=#Huserloc#"
                        startDate = "#dateformat(now(),'YYYY-MM-DD')#"
                        startTime = "#form.scheduleTime#"
                        interval = "daily"
                        resolveURL = "Yes"
                        requestTimeOut = "1800">
        <cfelse>
        	<cfif #form.scheduleTime# NEQ "">
                <cfschedule action = "update"
                            task = "#dts#_sendBodMsg_id=#url.id#"
                            operation = "HTTPRequest"
                            url = "http://crm.netiquette.asia/gold/bodAutoSend.cfm?dts=#dts#&cate=SMS&id=#url.id#&userid=#Huserid#&userloc=#Huserloc#"
                            startDate = "#dateformat(now(),'YYYY-MM-DD')#"
                            startTime = "#form.scheduleTime#"
                            interval = "once"
                            resolveURL = "Yes"
                            requestTimeOut = "1800">
            </cfif>    
        </cfif>
    <cfelse>
    	<cftry>
    		<cfschedule action="delete" task="#dts#_sendBodMsg_id=#url.id#">
        <cfcatch type="any">
        </cfcatch>
        </cftry>
    </cfif>
    <script>
		window.open("smsMaintenance.cfm","_self");
	</script>
<cfelseif #url.action# EQ "delete">
	<cfquery name="deleteSms" datasource="#dts#">
    	UPDATE smsemail
        SET is_deleted = "DELETED"
        WHERE id = "#url.id#"
    </cfquery>
    <cftry>
    	<cftry>
    		<cfschedule action="delete" task="#dts#_sendBodMsg_id=#url.id#">
        <cfcatch type="any">
        </cfcatch>
        </cftry>
    <cfcatch type="any">
    </cfcatch>
    </cftry>
    <script>
		window.open("smsMaintenance.cfm","_self");
	</script>
</cfif>
