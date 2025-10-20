<cfcomponent>
<cfsetting showdebugoutput="no">
<cffunction name="listLoggingHistory" access="remote" returntype="struct">
	<cfset dts=form.dts>

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
	<cfquery datasource='payroll_main' name="getHQstatus">
	Select * from users where userId = '#GetAuthUser()#'
	</cfquery>

	<cfquery name="getFilteredDataSet" datasource="payroll_main">
		<!--- SELECT SQL_CALC_FOUND_ROWS a.userLogID,a.userLogTime,a.uipaddress,a.status
		FROM userlog AS a
		LEFT JOIN users AS b
		ON a.userLogID = b.userID
		WHERE a.udatabase = "#dts#"
		AND b.userGrpID != 'super'
		#sWhere#
		#sOrder#
		#sLimit# --->
        SELECT * FROM USERLOG ul, USERS u
WHERE ul.userLogID = u.userID
		WHERE a.udatabase = "#dts#"

	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="payroll_main">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="payroll_main">
<!--- 		SELECT COUNT(u_id) AS iTotal
 --->		<!--- FROM userlog AS a
		LEFT JOIN users AS b
		ON a.userLogID = b.userID
		WHERE a.udatabase = "#dts#"
		AND b.userGrpID != 'super' --->
        SELECT * FROM USERLOG ul, USERS u
WHERE ul.userLogID = u.userID
		WHERE a.udatabase = "#dts#"

	</cfquery>
	
	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">	
		<cfset data=StructNew()>
		<cfset data["userlogid"]=userlogid>
		<cfset data["userlogtime"]=userlogtime>
		<cfset data["uipaddress"]=uipaddress>
		<cfset data["status"]=status>
		<cfset ArrayAppend(aaData,data)>
	</cfloop>
	<cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getFilteredDataSetLength.iFilteredTotal>
	<cfset output["aaData"]=aaData>
	<cfreturn output>
</cffunction>
</cfcomponent>