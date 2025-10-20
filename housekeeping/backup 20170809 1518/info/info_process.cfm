<cfset status=true>
<cfset status_msg="">

<cfif isdefined("url.type")>
	<cfset infoDate = createDate(ListGetAt(form.infoDate,3,"/"),ListGetAt(form.infoDate,2,"/"),ListGetAt(form.infoDate,1,"/"))>
	<cfif url.type eq "create">
		<cfquery name="checkExist" datasource="payroll_main">
			select info_ID from info
			where info_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codeId#">
		</cfquery>
		
		<cfif checkExist.recordcount>
			<cfset status=false>
			<cfset status_msg="This Code ID (#form.codeId#) Existed in System. Please try use other id again.">
		<cfelse>
			<cftry>
				<cfquery name="insertDb" datasource="payroll_main">
					insert into info 
					(info_desp,info_remark,info_date,info_system,created_by,created_on)
					
					values 
					(
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codeName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.infoRemark#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(infoDate,'yyyy-mm-dd')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.info_system#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,#now()#
					)
				</cfquery>
				
				<cfset status_msg="Successfully Insert Information">
				<cfcatch type="database">
					<cfset status=false>
					<cfset status_msg="Fail to Insert Information. Error Message : #cfcatch.Detail#">
				</cfcatch>
			</cftry>
		</cfif>
	<cfelseif url.type eq "edit">
		<cftry>
			<cfquery name="updateDb" datasource="payroll_main">
				UPDATE info
				SET 
				info_desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codeName#">,
				info_remark=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.infoRemark#">,
				info_date=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(infoDate,'yyyy-mm-dd')#">,
                info_system=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.info_system#">,
				updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">
				WHERE info_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codeId#">
			</cfquery>
			
			<cfset status_msg="Successfully Update Information.">
			<cfcatch type="database">
				<cfset status=false>
				<cfset status_msg="Fail to Update Information. Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
	<cfelseif url.type eq "delete">
		<cfquery name="deleteDb" datasource="payroll_main">
			Delete from info
			WHERE info_Id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codeId#">
		</cfquery>
		<cfset status_msg="Successfully Delete Information">
	</cfif>
</cfif>


<form name="pc" action="info_view.cfm" method="post">
	<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
</form>

<script>
	pc.submit();
</script>

