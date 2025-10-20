<cfoutput>
<cfif isdefined('form.pno')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT empno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfif getempno.empno neq get_comp.empno>
<cfabort>
</cfif>
</cfif>
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
SELECT empno,empname,custname,placementno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_comp.empno#">
</cfquery>

<cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
<h3>Log Incident</h3>

<cfform action="/eleave/incident/incidentprocess.cfm" method="post" name="eForm" id="eform" enctype="multipart/form-data" onsubmit="return confirm('Are You Sure You Want To Submit Incident Log?')">
    <table>
        <tr>
            <th width="200px">Placement No</th>
            <td>#getEmp.placementno#<!--- <input type="text" id="pno" name="pno" value="#form.pno#" readonly> ---></td>
        </tr>
        <tr>
		    <th>Employee</th>
        	<td>
            	#getEmp.empno# - #getemp.empname#</td>
            </td>
        </tr>
        <tr>
        <th>Company</th>
        	<td>
            #getemp.custname#
            </td>
        </tr>
        <tr>
		    <th>Date</th>
        	<td>
            	<cfinput type="text" name="date" id="date" value="#dateformat(now(),'dd/mm/yyyy')#" required="yes" message="Invalid Date / Date cannot be empty" readonly="readonly">
				<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('date'));">
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
