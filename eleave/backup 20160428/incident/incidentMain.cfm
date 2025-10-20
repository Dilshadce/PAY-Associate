<cfoutput>
<cfset dts = replace(dsname,'_p','_i') >
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<script src="/javascripts/CalendarControl.js" language="javascript"></script>
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<link rel="shortcut icon" href="/PMS.ico" />

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<cfif val(company_details.mmonth) eq "13">
<cfset company_details.mmonth = 12 >
</cfif>

<cfquery name="getEmp" datasource="#dts#">
SELECT empno FROM placement WHERE placementno = '#form.pno#'
</cfquery>

<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
<h3>Log Incident</h3>

<cfform action="/eleave/incident/incidentprocess.cfm" method="post" name="eForm" id="eform" enctype="multipart/form-data">
    <table>
        <tr>
            <th width="200px">Job Order</th>
            <td><input type="text" id="pno" name="pno" value="#form.pno#" readonly></td>
        </tr>
        <tr>
		    <th>Employee No.</th>
        	<td>
            	<input type="text" id="empno" name="empno" value="#getEmp.empno#" readonly></td>
            </td>
        </tr>
        <tr>
		    <th>Date</th>
        	<td>
            	<cfinput type="text" name="date" id="date" value="" required="yes" message="Invalid Date / Date cannot be empty">
				<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateFrom'));">
            </td>
        </tr>
        <tr>
	    	<th>Details</th>
        	<td>
                <textarea id="ePD" name="ePD" rows="20" cols="80" > </textarea>
            </td>
        </tr>
        <tr>    
            <td/>
            <td align="center"><input type="submit" value=" Submit " align=""></td>
        </tr>
    </table> 

</cfform>

</cfoutput>
