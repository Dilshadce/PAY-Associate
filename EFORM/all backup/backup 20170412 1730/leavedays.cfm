<cfif isdefined('url.datefrom')>
<cfset dts = dsname>
	<cfset noofdays = 0>
	<cfset datefromnew = URLDECODE(url.datefrom)>
    <cfset datetonew = URLDECODE(url.dateto)>
    
    <cfset dateclaimto = createdate(listlast(datetonew,'/'),listgetat(datetonew,'2','/'),listfirst(datetonew,'/'))>
    <cfset dateclaimfrom = createdate(listlast(datefromnew,'/'),listgetat(datefromnew,'2','/'),listfirst(datefromnew,'/'))>
    
    <cfquery name="holiday_qry" datasource="#dts#">
SELECT count(entryno) as totalholidays FROM holtable WHERE hol_date >= "#dateformat( dateclaimfrom,'YYYY-MM-DD')#" and hol_date <="#dateformat( dateclaimto,'YYYY-MM-DD')#" AND entryno = 1
</cfquery>
    
   <!---  <cfif dts eq "bepstest_i" or getauthuser() eq "ultracai"> --->
    <cfset startcount = 1>
	<cfquery name="getplacementdetail" datasource="#replace(dts,'_p','_i')#">
    SELECT 
    <cfloop list="Sun,Mon,Tues,Wednes,Thurs,Fri,Satur" index="i">
    #i#totalhour as th#startcount#,
    #i#halfday as hd#startcount#,
    <cfset startcount = startcount + 1>
    </cfloop>
    placementno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">
    </cfquery>
    
    <cfset fulldaylist = ''>
    <cfset halfdaylist = ''>
    
    <cfloop from="1" to="7" index="a">
    <cfif val(evaluate('getplacementdetail.th#a#')) neq 0>
		<cfif evaluate('getplacementdetail.hd#a#') neq "Y">
        	<cfset fulldaylist = fulldaylist&a&",">
        <cfelse>
        	<cfset halfdaylist = halfdaylist&a&",">
        </cfif>    
	</cfif>
    </cfloop>
    
    <cfif holiday_qry.recordcount neq 0>
    <cfset holidaycount = 0>
     <cfquery name="gethollist" datasource="#dts#">
SELECT hol_date FROM holtable WHERE hol_date >= "#dateformat( dateclaimfrom,'YYYY-MM-DD')#" and hol_date <="#dateformat( dateclaimto,'YYYY-MM-DD')#" AND entryno = 1
</cfquery>
    <cfloop query="gethollist">
    <cfif listfind(fulldaylist,DayOfWeek(gethollist.hol_date)) neq 0>
            <cfset holidaycount = holidaycount+1>
            <cfelseif listfind(halfdaylist,DayOfWeek(gethollist.hol_date)) neq 0>
            <cfset holidaycount = holidaycount+0.5>
            </cfif>
    </cfloop>
    
    <cfset holiday_qry.totalholidays = val(holidaycount)>
    
	</cfif>
    
    <cfset countdays = 0>
    
    <cfset noofdayscount = datediff('d',dateclaimfrom,dateclaimto)>
    <!--- <cfoutput>
    #noofdayscount#
    </cfoutput> --->
    <cfloop from="0" to="#noofdayscount#" index="i">
        <cfset currentdate = dateadd('d','#i#',dateclaimfrom)>
			<cfif listfind(fulldaylist,DayOfWeek(currentdate)) neq 0>
            <cfset countdays = countdays+1>
            <cfelseif listfind(halfdaylist,DayOfWeek(currentdate)) neq 0>
            <cfset countdays = countdays+0.5>
            </cfif>
        </cfloop>
   	    <cfset noofdays = countdays>
       
    <!--- <cfelse>
    
    
	<cfquery name="getplacementdetail" datasource="#dts#">
    SELECT wd_p_week FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">
    </cfquery>
    <cfset countdays = 0>
    <cfif getplacementdetail.wd_p_week eq "5">
    	<cfset noofdayscount = datediff('d',dateclaimfrom,dateclaimto)>
        <cfloop from="0" to="#noofdayscount#" index="i">
        <cfset currentdate = dateadd('d','#i#',dateclaimfrom)>
			<cfif DayOfWeek(currentdate) neq 7 and DayOfWeek(currentdate) neq 1>
            <cfset countdays = countdays+1>
            </cfif>
        </cfloop>
   	    <cfset noofdays = countdays>
    <cfelseif getplacementdetail.wd_p_week eq "5.5">
    	<cfset noofdayscount = datediff('d',dateclaimfrom,dateclaimto)>
        <cfloop from="0" to="#noofdayscount#" index="i">
        <cfset currentdate = dateadd('d','#i#',dateclaimfrom)>
			<cfif DayOfWeek(currentdate) eq 7>
            <cfset countdays = countdays+0.5>
            <cfelseif DayOfWeek(currentdate) neq 1>
            <cfset countdays = countdays+1>
            </cfif>
        </cfloop>
    <cfset noofdays = countdays>
    <cfelseif getplacementdetail.wd_p_week eq "7">
    <cfset noofdays = datediff('d',dateclaimfrom,dateclaimto) + 1>
    <cfelse>
    <cfset noofdayscount = datediff('d',dateclaimfrom,dateclaimto)>
		<cfset newdaycount = val(getplacementdetail.wd_p_week)>
        <cfset gethalfday = 0>
		<cfif newdaycount mod 1 eq "0.5">
        <cfset newdaycount = val(getplacementdetail.wd_p_week) - 0.5>
        <cfset gethalfday =  val(getplacementdetail.wd_p_week) + 0.5>
        </cfif>
        <cfset dayslist = "">
    	<cfloop from="1" to="#newdaycount#" index="i">
        <cfset adddays = i + 1>
        <cfset dayslist = dayslist&adddays>
        <cfif i neq newdaycount>
        <cfset dayslist = dayslist&",">
		</cfif>
        </cfloop>
        <cfloop from="0" to="#noofdayscount#" index="i">
            <cfset currentdate = dateadd('d','#i#',dateclaimfrom)>
			<cfif DayOfWeek(currentdate) eq gethalfday>
            <cfset countdays = countdays+0.5>
            <cfelseif listfind(dayslist,DayOfWeek(currentdate)) neq 0>
            <cfset countdays = countdays+1>
            </cfif>
        </cfloop>
		<cfset noofdays = val(countdays)>
	</cfif>
    </cfif> --->
    
    <cfif datefromnew neq datetonew>
    <cfif url.startampm neq "FULL DAY">
    <cfset noofdays = noofdays - 0.5>
	</cfif>
    <cfif url.endampm neq "FULL DAY">
    <cfset noofdays = noofdays - 0.5>
	</cfif>
    <cfelseif datefromnew eq datetonew and url.startampm eq url.endampm and (url.startampm eq "PM" or url.startampm eq "AM")>
    <cfset noofdays = noofdays - 0.5>
	</cfif>
    
    <cfif holiday_qry.totalholidays neq 0 and url.leavetype neq "NS">
    <cfset noofdays = noofdays - val(holiday_qry.totalholidays)>
	</cfif>
    
    <cfif noofdays lt 0>
    <cfset noofdays = 0 >
	</cfif>
    <cfoutput>
    <input type="hidden" name="newleavedays" id="newleavedays" value="#noofdays#">
    </cfoutput>
</cfif>