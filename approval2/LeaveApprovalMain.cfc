<cfcomponent>
    <cffunction name="listAccount" access="remote" returntype="struct"> 
        
        <cfset targetTable=form.targetTable>
        <cfset cancelrequest="N">
            
        <cfquery name="checkverifier" datasource="payroll_main">
            SELECT ApprovalView,ApproveVerify FROM hmusers 
            WHERE entryid = "#form.huserid#"
        </cfquery>
            
        <cfif "#tstatus#" EQ "Submitted For Cancellation">
            <cfset form.tstatus = "Approved">    
            <cfset cancelrequest = "Y">  
        <cfelseif "#tstatus#" EQ "Submitted For Approval">
            <cfset form.tstatus = "In Progress">    
            <cfset cancelrequest = "N">
                
            <!---<cfif checkverifier.ApprovalView eq 'VERIFIED'>
                <cfset form.tstatus = "VERIFIED">  
            </cfif>--->
            <cfif findnocase('Submitted For Approval',checkverifier.ApprovalView) and findnocase('VERIFIED',checkverifier.ApprovalView)>
                <cfset form.tstatus = form.tstatus & "," & "VERIFIED">
            <cfelseif checkverifier.ApprovalView eq 'VERIFIED'>
                <cfset form.tstatus = "VERIFIED">  
            </cfif>
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
            
        <cfquery name="getleavetype" datasource="#dts#">
            SELECT costcode FROM iccostcode        
        </cfquery>
                
        <cfquery name="getFilteredDataSet" datasource="#dts#">
            SELECT SQL_CALC_FOUND_ROWS *
            FROM 
            (
                SELECT a.id, a.placementno, b.empname, a.startdate, a.enddate, a.days, a.leavetype, a.startampm, a.endampm, a.status, a.submit_date, a.remarks,
                a.signdoc, b.empno, a.cancel_req
                <cfloop query="getleavetype">
                , COALESCE(#getleavetype.costcode#totaldays, 0) AS "#getleavetype.costcode#totaldays"
                </cfloop>
                FROM #targetTable# a
                LEFT JOIN placement b ON a.placementno = b.placementno
                WHERE 1=1
                    <cfif checkverifier.approveverify eq 'VERIFIED'>
                        AND b.verifier = "#form.huserid#"
                    <cfelse>
                        AND b.hrmgr = "#form.huserid#"
                    </cfif>   
                <!---AND a.status = "#form.tstatus#"--->
                <cfif listlen(form.tstatus,",") gt 1>
                    AND (
                    (a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(form.tstatus,',')#"> and verifier="")
                    or (a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(form.tstatus,',')#"> and verifier != "")
                    )
                <cfelse>
                    AND a.status in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#form.tstatus#">)
                </cfif>
                AND a.cancel_req = "#cancelrequest#"
                ORDER BY b.empname, a.placementno ASC, a.startdate ASC
            ) AS aa
            
            #sWhere#
            #sOrder#
            #sLimit#
        </cfquery>
                
        <cfquery name="groupPno" dbtype="query">
            SELECT placementno FROM getFilteredDataSet GROUP BY placementno 
        </cfquery>
        
        <cfquery name="getleavelist" datasource="#dts#">
            SELECT * FROM leavelist WHERE placementno IN 
            (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#ValueList(groupPno.placementno)#">)
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
            
            <cfquery name="getbalance" dbtype="query">
                SELECT SUM(days) AS taken FROM getleavelist WHERE placementno = '#getFilteredDataSet.placementno#'
                AND leavetype = '#getFilteredDataSet.leavetype#' AND status = 'APPROVED'
            </cfquery>
            
            <cfset data=StructNew()>
            <cfset data["CurrentRow"]=CurrentRow>
			<cfset data["id"]=id>
			<cfset data["placementno"]=placementno>
			<cfset data["empname"]=empname>
			<cfset data["startdate"]=#DateFormat(startdate, 'yyyy-mm-dd')#>
			<cfset data["enddate"]=#DateFormat(enddate, 'yyyy-mm-dd')#>
			<cfset data["days"]=days>
			<cfset data["leavetype"]=leavetype>
			<cfset data["startampm"]=#TimeFormat(startampm)#>
			<cfset data["endampm"]=#TimeFormat(endampm)#>
			<cfset data["status"]=status>
			<cfset data["submit_date"]=#DateFormat(submit_date, 'yyyy-mm-dd')#>
			<cfset data["remarks"]=remarks>
            <cfif #signdoc# NEQ "" AND FileExists(ExpandPath("/upload/#Replace(dts, '_i', '_p')#/leave/#empno#/#placementno#/#signdoc#")) >
                <cfset data["signdoc"]="/upload/#Replace(dts, '_i', '_p')#/leave/#empno#/#placementno#/#signdoc#">
            <cfelse>
                <cfset data["signdoc"]="">
            </cfif>
            <cfset data["balance"]=#Val(Evaluate('getFilteredDataSet.#leavetype#totaldays'))#-#Val(getbalance.taken)#>
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