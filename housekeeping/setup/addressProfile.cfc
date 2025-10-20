<cfcomponent>
<cffunction name="listAccount" access="remote" returntype="struct">

    <!---<cfset dts=form.dts>--->
    <cfquery datasource='payroll_main' name="getHQstatus">
        Select userDsn,userGrpID from users where userId = '#GetAuthUser()#'
    </cfquery>
    
	<cfset dts=getHQstatus.userdsn>

    <cfquery datasource='payroll_main' name="getccode">
        Select ccode from gsetup where comp_id = '#evaluate("left(dts,len(dts)-2)")#'
    </cfquery>
    
     <cfquery datasource='#dts#' name="getpin">
        SELECT pin from userpin where usergroup = "#getHQstatus.userGrpID#"
    </cfquery>

	<cfif lcase(getHQstatus.userGrpID) eq "super">
    	<cfset hpin=0>
    <cfelse>
	    <cfset hpin=getpin.pin>
    </cfif>
    
	<cfset targetTable=form.targetTable>
		
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

	<cfset sWhere='WHERE (ccode = "'& getccode.ccode &'" or ccode = "") '>
	<cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
		<cfset sWhere='WHERE ((ccode = "'& getccode.ccode &'" or ccode = "") AND '>
		<cfloop from="0" to="#form.iColumns-1#" index="i" step="1">	
			<cfif Evaluate('form.bSearchable_'&i) EQ "true">
				<cfset sWhere=sWhere&Evaluate('form.mDataProp_'&i)&" LIKE ""%"&trim(form.sSearch)&"%"" OR ">
			</cfif>
		</cfloop>
		<cfset sWhere=Left(sWhere,Len(sWhere)-4)>
		<cfset sWhere=sWhere&")">    
	</cfif>
	
	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS org_type,category,com_fileno,com_accno
		FROM #targetTable#
		#sWhere#
		#sOrder#
		#sLimit#
	</cfquery>

	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(org_type) AS iTotal
		FROM #targetTable#
	</cfquery>
    

		<cfset aaData=ArrayNew(1)>
		<cfloop query="getFilteredDataSet">	
			<cfset data=StructNew()>
			<cfset data["org_type"]=org_type>
			<cfset data["category"]=category> 
            <cfset data["com_fileno"]=com_fileno>
            <cfset data["com_accno"]=com_accno>
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