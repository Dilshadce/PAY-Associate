<cfcomponent>
<cfsetting showdebugoutput="no">
<cffunction name="listLoggingHistory" access="remote" returntype="struct">
    <cfset DSNAME=form.DSNAME>

	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>		
	
	<cfset sOrder="">
	<cfif IsDefined("form.iSortCol_0")>
		<cfset sOrder="ORDER BY ">
		<cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
			<cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
				<cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
				<cfif Evaluate('form.sSortDir_'&i) EQ "asc">
					<cfset sOrder=sOrder&" ASC,">
				<cfelse>
					<cfset sOrder=sOrder&" DESC,">
				</cfif>
			</cfif>
		</cfloop>
		<cfset sOrder=Left(sOrder,Len(sOrder)-1)>
		<cfif sOrder EQ "ORDER BY">
			<cfset sOrder="">
		</cfif>		
	</cfif>
	
	<cfset sWhere="">
	<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
		<cfset sWhere=" AND (">
		<cfloop from="0" to="#form.iColumns-1#" index="i" step="1">	
			<cfif Evaluate('form.bSearchable_'&i) EQ "true">
				<cfset sWhere=sWhere&Evaluate('form.mDataProp_'&i)&" LIKE ""%"&form.sSearch&"%"" OR ">
			</cfif>
		</cfloop>
		<cfset sWhere=Left(sWhere,Len(sWhere)-4)>
		<cfset sWhere=sWhere&")">
	</cfif>
	
	<!--- <cfquery name="getFilteredDataSet" datasource="#DSNAME#">
		SELECT SQL_CALC_FOUND_ROWS a.userlogid,a.userlogtime,a.uipaddress,a.status
		FROM EMP_USERS_LOG AS a
		LEFT JOIN users AS b
		ON a.userlogid=b.userid
		#sWhere#
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#DSNAME#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#DSNAME#">
		SELECT COUNT(u_id) AS iTotal
		FROM EMP_USERS_LOG AS a
		LEFT JOIN users AS b
		ON a.userlogid=b.userid
	</cfquery>  --->
    
 
 <cfquery name="query_log" datasource="#DSNAME#">
SELECT * FROM EMP_USERS_LOG WHERE USER_ID = "#HUserID#" ORDER BY LOGDT DESC limit 0 , 20
		#sWhere#
		#sOrder#
		#sLimit#
</cfquery>
 
	<cfset aaData=ArrayNew(1)>
	<cfloop query="query_log">	
		<cfset data=StructNew()>
		<cfset data["User_ID"]=User_ID>
		<cfset data["LogDT"]=LogDT>
		<cfset data["Log_IP"]=Log_IP>
 		<cfset ArrayAppend(aaData,data)>
	</cfloop>
	<!--- <cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getFilteredDataSetLength.iFilteredTotal>
	<cfset output["aaData"]=aaData> --->
	<cfreturn output>
</cffunction>
</cfcomponent>