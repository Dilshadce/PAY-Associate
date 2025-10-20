<cfquery name="getSmsEmail" datasource="#dts#">
    SELECT type, title, content, category, race
    FROM smsemail
    WHERE id = "#url.id#"
</cfquery>

<cfquery name="getMember" datasource="#dts#">
    SELECT * 
    FROM member 
    WHERE status <> "DELETED" <cfif getSmsEmail.race NEQ "">AND race = "#getSmsEmail.race#"</cfif>
</cfquery>
    
<cfif #getMember.RecordCount# GT 0>
	<cfif #getSmsEmail.category# EQ "SMS">
		<cfloop query="getMember">               
			<cfset newMobileNo = #Replace(getMember.mobileno, "-", "", "all")#>
			
			<cfquery name="getSetting2" datasource="#dts#">
				SELECT setting1, setting2, setting3, setting4
				FROM marketingsetting
				WHERE type = "SMS"
			</cfquery>
			
			<cfhttp url="#getSetting2.setting4#" method="GET" resolveurl="false">
				<cfhttpparam type="url" name="apiusername" value="#getSetting2.setting1#">
				<cfhttpparam type="url" name="apipassword" value="#getSetting2.setting2#">
				<cfhttpparam type="url" name="mobileno" value="#newMobileNo#">
				<cfhttpparam type="url" name="senderid" value="#getSetting2.setting3#">
				<cfhttpparam type="url" name="languagetype" value="1">
				<cfhttpparam type="url" name="message" value="RM0.00 #getSmsEmail.content#">
			</cfhttp>
			
			<!--- <cfoutput>
				#getSetting2.setting4#<br>
				#newMobileNo#<br>
				#getSmsEmail.content#<br>
			</cfoutput> --->
		</cfloop>
	<cfelseif #getSmsEmail.category# EQ "EMAIL">
		<cfloop query="getMember">                
			<cfquery name="getSetting2" datasource="#dts#">
				SELECT setting1, setting2, setting3, setting4, setting5
				FROM marketingsetting
				WHERE type = "Email"
			</cfquery>
			
			<cfset mailAttributes = {
				server="#getSetting2.setting3#",
				username="#getSetting2.setting1#",
				password="#getSetting2.setting2#",
				from="#getSetting2.setting1#",
				to="#getMember.email#",
				subject="#getSmsEmail.title#"
			}/>
			
			<cfif #getSetting2.setting5# EQ "None">
				<cfmail port="#getSetting2.setting4#" attributeCollection="#mailAttributes#" type="html">
					#getSmsEmail.content#
				</cfmail>
			<cfelseif #getSetting2.setting5# EQ "SSL">
				<cfmail port="#getSetting2.setting4#" useSSL="yes" attributeCollection="#mailAttributes#" type="html">
					#getSmsEmail.content#
				</cfmail>
			<cfelseif #getSetting2.setting5# EQ "TLS">
				<cfmail port="#getSetting2.setting4#" useTLS="yes" attributeCollection="#mailAttributes#" type="html">
					#getSmsEmail.content#
				</cfmail>
			</cfif>
			
			<!--- <cfoutput>
				#getSetting2.setting1#<br>
				#getSetting2.setting2#<br>
				#getSetting2.setting3#<br>
				#getMember.email#<br>
				#getSmsEmail.content#<br>
			</cfoutput>  --->   
		</cfloop>
	</cfif>  
</cfif>
<cfquery name="updateSmsEmail" datasource="#dts#">
	UPDATE smsemail
	SET status = "SENT"
	WHERE id = #url.id#
</cfquery>

<cfif #getSmsEmail.category# EQ "SMS">
	<script type="text/javascript">
		window.open("smsMaintenance.cfm","_self");
	</script>
<cfelseif #getSmsEmail.category# EQ "EMAIL">
	<script type="text/javascript">
    	window.open("emailMaintenance.cfm","_self");
    </script>
</cfif>