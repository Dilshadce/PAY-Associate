
<cfif isdefined('form.sub_btn')>
	<cfquery name="company_details" datasource="#dts_main#">
		SELECT mmonth,myear FROM gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	<cfset mon = company_details.mmonth>
	<cfset yrs = company_details.myear>
    <cfset date = createdate(yrs,mon,1)>
	<cfset date1 = createdate(yrs,mon,daysinmonth(date))>
    
    <!---assign holiday ,sunday date to sunpubdate--->
    <cfset pubdate = "0">
    <cfset sundate ="0">
	<cfquery name="getpubdate" datasource="#dts#">
    	SELECT hol_date FROM holtable WHERE hol_date between '#dateformat(date,'yyyy-mm-dd')#' 
        AND '#dateformat(date1,'yyyy-mm-dd')#' order by hol_date  
    </cfquery>
	
    <cfif getpubdate.recordcount gt 0>
    <cfloop query="getpubdate">
    	<cfset pubdate = pubdate & dateformat(getpubdate.hol_date,'dd')*2-1 & ",">
    	<cfset pubdate = pubdate & dateformat(getpubdate.hol_date,'dd')*2 & ",">
    </cfloop>
    </cfif>
    
    <cfset firstsun = dateformat(dateadd("d",(8-dayOfWeek(date))mod 7,date),'yyyy-mm-dd')>
    <cfset nextsun = firstsun>
	<cfset sundate = sundate & dateformat(firstsun,'dd')*2-1 &",">
	<cfset sundate = sundate & dateformat(firstsun,'dd')*2 &",">
        				
	<cfset mdays = (8-dayOfWeek(date))mod 7 + 8>
    <cfloop condition="mdays lte daysinmonth(date)">
		<cfset nextsun = dateformat(dateadd('d',7,nextsun),'yyyy-mm-dd')>
    	<cfset sundate = sundate & dateformat(nextsun,'dd')*2-1 &",">
      	<cfset sundate = sundate & dateformat(nextsun,'dd')*2 &",">
        <cfset mdays +=7>
    </cfloop> 
	

    <cfif len(sundate) gt 1>
	 	<cfset sundate = mid(sundate,1,len(sundate)-1)>
    </cfif>
    
    <cfif len(pubdate) gt 1>
		<cfset pubdate = mid(pubdate,1,len(pubdate)-1)>
    </cfif>
	<!---end of assign holiday ,sunday date to sunpubdate--->

    <cfquery name="gettotalot" datasource="#dts#">
    SELECT * FROM (SELECT sum(ot)as totalot2,sum(ot)as totalot6,empno FROM #replace(dts,'_p','_i')#.emptimesheet where month='#mon#' and year='#yrs#' GROUP BY empno) as a where a.totalot2 > 0
    </cfquery>
    
    <cfquery name="getsun" datasource="#dts#">
	SELECT count(day)/2 as totalot5, e.* FROM imiqgroup_i.emptimesheet e WHERE
    day in (#sundate#) AND (timefrom != 0 or timeto != 0) and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
        
    <cfquery name="getpub" datasource="#dts#">
	SELECT count(day)/2 as totalot6, e.* FROM imiqgroup_i.emptimesheet e WHERE
    day in (#pubdate#) AND (timefrom != 0 or timeto != 0) AND activity not in('25','23')
    and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>

    <cfquery name="getal" datasource="#dts#">
	SELECT count(day)/2 as total, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity = '15' and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    <cfquery name="getcl" datasource="#dts#">
	SELECT count(day)/2 as total, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity = '17' and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    <cfquery name="gethl" datasource="#dts#">
	SELECT count(day)/2 as total, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity = '20' and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    <cfquery name="getmc" datasource="#dts#">
	SELECT count(day)/2 as total, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity = '22' and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    <cfquery name="getnpl" datasource="#dts#">
	SELECT count(day)/2 as total, e.* FROM imiqgroup_i.emptimesheet e WHERE
    activity = '23' and month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>
    <cfquery name="refresh" datasource="#dts#">
	SELECT empno FROM imiqgroup_i.emptimesheet e WHERE month= #mon# AND year= #yrs# GROUP BY empno
    </cfquery>

<!---<cfif GetAuthUser() eq 'ultrauser7'>   
<cfoutput>
<cfdump var= "#firstsun#">
</cfoutput>
<cfabort>   
</cfif>--->
  
	<cfloop query="refresh">
    <cfquery name="refreshdata" datasource="#dts#">
 	UPDATE paytran set hr2=null, hr5=null, hr6=null,al=null,cl=null,hl=null,mc=null,npl=null,payyes='N'
    WHERE empno='#refresh.empno#'
    </cfquery>
    
    </cfloop>
    <cfloop query="gettotalot">
    <cfquery name="updatetotalot" datasource="#dts#">
    UPDATE paytran SET hr2='#gettotalot.totalot2#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#gettotalot.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getsun">

    <cfquery name="updatesun" datasource="#dts#">
    UPDATE paytran SET hr5='#getsun.totalot5#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getsun.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getpub">
    <cfquery name="updatepub" datasource="#dts#">
    UPDATE paytran SET hr6='#getpub.totalot6#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getpub.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getal">
    <cfquery name="updateal" datasource="#dts#">
    UPDATE paytra1 SET al='#getal.total#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getal.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getcl">
    <cfquery name="updatepub" datasource="#dts#">
    UPDATE paytra1 SET cl='#getcl.total#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getcl.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="gethl">
    <cfquery name="updatepub" datasource="#dts#">
    UPDATE paytra1 SET hl='#gethl.total#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#gethl.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getmc">
    <cfquery name="updatepub" datasource="#dts#">
    UPDATE paytra1 SET mc='#getmc.total#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getmc.empno#">
    </cfquery>
    </cfloop>
    <cfloop query="getnpl">
    <cfquery name="updatepub" datasource="#dts#">
    UPDATE paytra1 SET npl='#getnpl.total#', payyes = "Y"     WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getnpl.empno#">
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
 <h2>Pull data from timesheet into Payroll</h2>
<form name="form1" id="form1" action="" method="post" onSubmit="return confirm('Are You Sure You Want to Pull data from timesheet into Payroll? Existing figures will be overwrite!');">
<input type="submit" name="sub_btn" value="GO">
</form>
</div>
 </cfoutput>
