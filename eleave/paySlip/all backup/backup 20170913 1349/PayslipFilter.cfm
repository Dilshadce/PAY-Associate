<cfsetting showDebugOutput = "yes">
<cfoutput>
   
<!---dsname is _p--->
   
    <cfset dts = "#Replace(dsname, '_p', '_i')#">
   
    <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
    </cfquery>
  
    <cfquery datasource="#dsname#" name="getEmpno">
        SELECT empno
        FROM emp_users where userName = '#getAuthUser()#'
    </cfquery>
    
    <cfset payslip_directory = "#GetDirectoryFromPath(GetCurrentTemplatePath())#/Generated_payslip">
    
    <cfif directoryexists(payslip_directory) eq false>
        <cfdirectory action="create" directory="#payslip_directory#" >
    </cfif>
 
    <cfinvoke component="printPaySlipProcess" method="generatePayslip">
        <cfinvokeargument name="dts" value="#dts#">
        <cfinvokeargument name="dsname" value="#dsname#">
        <cfinvokeargument name="empnoselected" value="#getEmpno.empno#">
        <cfinvokeargument name="monthselected" value="#form.month#">
        <cfinvokeargument name="yearselected" value="#company_details.myear#">
        <cfinvokeargument name="channel" value="eportal">
    </cfinvoke>
    
    <cfheader name="Content-Disposition" value="attachment;filename=#getEmpno.empno#_#MonthAsString(form.month)##company_details.myear#_payslip.pdf">
    <cfcontent type="application/octet-stream" file="#payslip_directory#/#getEmpno.empno#_#MonthAsString(form.month)##company_details.myear#_payslip.pdf" deletefile="Yes">
    
</cfoutput>