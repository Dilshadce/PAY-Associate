<cfif #url.checked# EQ "1">
	<cfquery name="updateSmsEmail" datasource="#dts#">
		UPDATE smsemail
        SET auto = "Y"
        WHERE id = "#url.id#"
    </cfquery>
    <cfquery name="getSmsEmail" datasource="#dts#">
    	SELECT RIGHT(schedule, 8) AS scheduletime
        FROM smsemail
        WHERE id = #url.id#	
    </cfquery>
    <cfschedule action = "update"
        task = "#dts#_sendBodMsg_id=#url.id#"
        operation = "HTTPRequest"
        url = "http://crm.netiquette.asia/bodAutoSend.cfm?dts=#dts#&cate=#url.cate#&id=#url.id#&userid=#Huserid#&userloc=#Huserloc#"
        startDate = "#dateformat(now(),'YYYY-MM-DD')#"
        startTime = "#getSmsEmail.scheduletime#"
        interval = "daily"
        resolveURL = "Yes"
        requestTimeOut = "1800">
<cfelseif #url.checked# EQ "0">
	<cfquery name="updateSmsEmail" datasource="#dts#">
		UPDATE smsemail
        SET auto = "N"
        WHERE id = "#url.id#"
    </cfquery>
    <cftry>
    	<cfschedule action="delete" task="#dts#_sendBodMsg_id=#url.id#">
    <cfcatch type="any">
    </cfcatch>
    </cftry>
</cfif>

<cfif #url.cate# EQ "SMS">
	<script type="text/javascript">
		window.open("smsMaintenance.cfm","_self");
	</script>
<cfelseif #url.cate# EQ "EMAIL">
	<script type="text/javascript">
    	window.open("emailMaintenance.cfm","_self");
    </script>
</cfif>
