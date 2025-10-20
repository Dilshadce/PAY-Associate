<cfsetting showdebugoutput="True" requesttimeout="0">
<cfset dsname = "#dts#">
<cfset dts = "#Replace(dts, '_p', '_i')#">
<cfset tempentitle = "">
    
<cfquery name="getpno" datasource="#dts#">
    SELECT placementno, empno, rlentitle, IFNULL(rldays, 0) AS rldays FROM placement
    WHERE placementno IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" list="true" separator="," value="#form.checkerlist#">)
</cfquery>
    
<cfquery datasource="#dts#">
    SET SESSION binlog_format = 'MIXED'
</cfquery>
    
<cfloop list="#form.checkerlist#" delimiters="," index="pno">
    <cfquery name="getoldvalue" dbtype="query">
        SELECT placementno, empno, rlentitle, rldays
        FROM getpno WHERE placementno = '#pno#'
    </cfquery>
    
    <cfif "#IsDefined('form.entitle_#pno#')#">
        <cfset tempentitle = "Y">
    <cfelse>
        <cfset tempentitle = "N">
    </cfif>
    
    <cfquery name="update_log" datasource="#dsname#">
        INSERT INTO leave_entitlement_self
        (placementno, empno, updated_on, updated_by, ori_entitle, new_entitle, ori_days, new_days)
        VALUES
        ("#getoldvalue.placementno#", "#getoldvalue.empno#", now(), "#HuserID#", "#getoldvalue.rlentitle#", "#tempentitle#", "#Val(getoldvalue.rldays)#", 
        "#Evaluate('form.days_#pno#')#")
    </cfquery>
        
    <cfquery name="updateJO" datasource="#dts#">
        UPDATE placement SET rlentitle = "#tempentitle#", rldays = "#Evaluate('form.days_#pno#')#", rltotaldays = "#Evaluate('form.days_#pno#')#",
        updated_on = now(), updated_by = "#huserid#"
        WHERE placementno = "#pno#"
    </cfquery>
</cfloop>

<cfoutput>
    <script>
        alert("#ListLen(form.checkerlist)# placement updated!");
        window.open('/entitlement/leaveentitlement.cfm', '_self');
    </script>
</cfoutput>