
<cfif isdefined('form.sub_btn')>
	<cfquery name="company_details" datasource="#dts_main#">
		SELECT mmonth,myear FROM gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	<cfset mon = company_details.mmonth>
	<cfset yrs = company_details.myear>
    
    <cfquery name="gettotalot" datasource="#dts#">
    SELECT * FROM (SELECT sum(ot)as totalot2,sum(ot)as totalot6,empno FROM #replace(dts,'_p','_i')#.emptimesheet where month='#mon#' and year='#yrs#' GROUP BY empno) as a where a.totalot2 > 0
    </cfquery>
    
    <cfquery name="getsunpub" datasource="#dts#">
	SELECT count(day)/2 as totalot6, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity in(25,27) AND (timefrom != 0 or timeto != 0) and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    
    <cfloop query="gettotalot">
    <cfquery name="updatetotalot" datasource="#dts#">
    UPDATE paytran SET hr2='#gettotalot.totalot2#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#gettotalot.empno#">
    </cfquery>
    </cfloop>
    
    <cfloop query="getsunpub">
    <cfquery name="updatesunpub" datasource="#dts#">
    UPDATE paytran SET hr6='#getsunpub.totalot6#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getsunpub.empno#">
    </cfquery>
    </cfloop>
    
    <cfoutput>
    <script type="text/javascript">
	alert('Update Success!');
    </script>
    </cfoutput>
 </cfif>
 <link href="/stylesheet/app.css" rel="stylesheet" type="text/css">	
 <cfoutput>
 <div align="center">
 <h2>Pull OT hour from timesheet into 2nd Half Payroll</h2>
<form name="form1" id="form1" action="" method="post" onSubmit="return confirm('Are You Sure You Want to Pull OT hour from timesheet into 2nd Half Payroll? Existing OT figures will be overwrite!');">
<input type="submit" name="sub_btn" value="GO">
</form>
</div>
 </cfoutput>
