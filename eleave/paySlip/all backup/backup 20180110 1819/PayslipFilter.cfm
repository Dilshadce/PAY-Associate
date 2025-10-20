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
    
    <cfquery name="checkPay" datasource="#dts#">
        <!---SELECT a.empno, a.batches, b.appstatus, date_add(c.giropaydate, INTERVAL 2 DAY) AS avail_date
        FROM assignmentslip a
        LEFT JOIN argiro b ON a.batches = b.batchno
        LEFT JOIN icgiro c on b.batchno = c.batchno
        WHERE a.empno = "#getEmpno.empno#"
        AND a.payrollperiod = "#form.month#"
        AND b.appstatus = "Approved";--->
        SELECT a.empno, a.batches, b.appstatus, b.girorefno, b.generated_on AS argenerated, c.generated_on AS icgenerated
        FROM assignmentslip a
        LEFT JOIN argiro b ON a.batches = b.batchno
        LEFT JOIN icgiro c ON b.uuid = c.uuid AND b.batchno = c.batchno
        WHERE a.empno = "#getEmpno.empno#"
        AND c.empno = "#getEmpno.empno#"
        AND a.payrollperiod = "#form.month#"
        AND b.appstatus = "Approved"
    </cfquery>
    
    <cfif #checkPay.recordcount# NEQ 0 AND ("#checkPay.girorefno#" NEQ "" OR ("#checkPay.icgenerated#" LTE now() AND "#checkPay.icgenerated#" NEQ "") OR ("#checkPay.argenerated#" LTE now() AND "#checkPay.argenerated#" NEQ ""))> <!---#DateFormat(now(), 'yyyy-mm-dd')# GTE #DateFormat(checkPay.avail_date, 'yyyy-mm-dd')#--->
        <cfif #dsname# eq 'manpowertest_p'>
            <cfset payslip_directory = "#GetDirectoryFromPath(GetCurrentTemplatePath())#/Generated_payslip/test">
        <cfelse>
            <cfset payslip_directory = "#GetDirectoryFromPath(GetCurrentTemplatePath())#/Generated_payslip">
        </cfif>
    
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
            <cfinvokeargument name="printtype" value="PDF">
        </cfinvoke>

        <cfheader name="Content-Disposition" value="attachment;filename=#getEmpno.empno#_#MonthAsString(form.month)##company_details.myear#_payslip.pdf">
        <cfcontent type="application/octet-stream" file="#payslip_directory#/#getEmpno.empno#_#MonthAsString(form.month)##company_details.myear#_payslip.pdf" deletefile="Yes">
    <cfelse>
        <script type="text/javascript">
            alert('There are no Pay Slip found for the selected month.');
            window.location="/eleave/payslip/printpayslip.cfm";
        </script>        
    </cfif>
    
</cfoutput>