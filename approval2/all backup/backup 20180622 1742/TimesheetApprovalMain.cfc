<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct">
        
        <cfset targetTable=form.targetTable>
        <cfset cancelrequest="N">
            
        <cfif "#tstatus#" EQ "Submitted For Cancellation">
            <cfset tstatus = "Approved">    
            <cfset cancelrequest = "Y">    
        </cfif>
            
        <cfset sLimit="">
        <cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
            <cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
        </cfif>		
        
        <cfset sOrder="">
        <cfif IsDefined("form.iSortCol_0")>
            <cfset sOrder="ORDER BY `">
            <cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
                <cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
                    <cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
                        <cfif Evaluate('form.sSortDir_'&i) EQ "asc">
                            <cfset sOrder=sOrder&"` ASC,`">
                        <cfelse>
                            <cfset sOrder=sOrder&"` DESC,`">
                        </cfif>
                </cfif>
            </cfloop>
            <cfset sOrder=Left(sOrder,Len(sOrder)-2)>
            <cfif sOrder EQ "ORDER BY `">
                <cfset sOrder="">
            </cfif>  
        </cfif>
                
        <cfset sWhere="">
        <cfif IsDefined("form.sSearch") AND form.sSearch NEQ "">
            <cfset sWhere=" WHERE (">
            <cfloop from="0" to="#form.iColumns-1#" index="i" step="1">	
                <cfif Evaluate('form.bSearchable_'&i) EQ "true">
                    <cfset sWhere=sWhere&'aa.'&Evaluate('form.mDataProp_'&i)&" LIKE ""%"&form.sSearch&"%"" OR ">
                </cfif>
            </cfloop>
            <cfset sWhere=Left(sWhere,Len(sWhere)-4)>
            <cfset sWhere=sWhere&")">
        </cfif>
            
        <cfquery name="getFilteredDataSet" datasource="#dts#">
            SELECT SQL_CALC_FOUND_ROWS *
            FROM 
            (
                SELECT a.placementno, a.empno, a.created_on, a.tmonth, a.tyear, min(a.pdate) AS 'start', max(a.pdate) AS 'end', a.mgmtremarks, a.status, 
                b.name AS 'empname', a.cancel_req
                FROM #targetTable# a
                LEFT JOIN pmast b ON a.empno = b.empno
                WHERE a.placementno IN
                (SELECT placementno FROM #Replace(dts, '_p', '_i')#.placement WHERE hrmgr = '#huserid#')
                AND a.status = '#tstatus#'
                AND a.cancel_req = "#cancelrequest#"
                GROUP BY a.placementno, a.tmonth, a.tyear
            ) AS aa
            
            #sWhere#
            #sOrder#
            #sLimit#
        </cfquery>
    
        <cfquery name="getFilteredDataSetLength" datasource="#dts#">
            SELECT FOUND_ROWS() AS iFilteredTotal
        </cfquery>
        <cfquery name="getTotalDataSetLength" dbtype="query">
            SELECT COUNT(placementno) AS iTotal
            FROM getFilteredDataSet
        </cfquery>      
    
		<cfset aaData=ArrayNew(1)>
        <cfloop query="getFilteredDataSet">	
            <cfset data=StructNew()>
            <cfset data["CurrentRow"]=CurrentRow>
			<cfset data["empno"]=empno>
			<cfset data["empname"]=empname>
            <cfset data["placementno"]=placementno>
            <cfset data["tmonth"]=monthasstring(tmonth)>
            <cfset data["created_on"]=dateformat(created_on, 'yyyy-mm-dd')>
            <cfset data["start"]=dateformat(start, 'yyyy-mm-dd')>
            <cfset data["end"]=dateformat(end, 'yyyy-mm-dd')>
            <cfset data["status"]=status>
            <cfset data["tmonth1"]=tmonth>
            <cfset data["tyear"]=tyear>
            <cfset data["MGMTREMARKS"]=mgmtremarks>
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