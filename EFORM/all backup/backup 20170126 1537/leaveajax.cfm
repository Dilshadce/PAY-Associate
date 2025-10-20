<cfsetting showdebugoutput="no">
<cfif isdefined('url.action')>
<cfset dts = dsname>
<cfoutput>
<cfinclude template="/object/dateobject.cfm">
<cfquery name="getempno" datasource="#dts#">
SELECT empno FROM emp_users WHERE 
username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>
 <cfquery name="getplacementno" datasource="#replace(dts,'_p','_i')#">
                SELECT placementno FROM placement 
                WHERE 
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> ORDER BY completedate desc limit 1
                </cfquery>
<cfset url.placementno = getplacementno.placementno>
<cfif isdefined('url.action')>
	<cfif url.action eq "delete">
    	<cfquery name="deletelist" datasource="#dts#">
        	DELETE from leaveutl WHERE id = "#url.id#"
            AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
            AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#">
        </cfquery>
    <cfelseif url.action eq "add">
    	<cfset leavetype1 = URLDECODE(url.leavetype)>
        <cfset startdate1 = URLDECODE(url.startdate)>
        <cfset startampm1 = URLDECODE(url.startampm)>
        <cfset enddate1 = URLDECODE(url.enddate)>
        <cfset endampm1 = URLDECODE(url.endampm)>
        <cfset leavedays1 = URLDECODE(url.leavedays)>
        <cfset remarks1 = URLDECODE(url.remarks)>
        
        <cfset datestartleave = createdate(listlast(startdate1,'/'),listgetat(startdate1,'2','/'),listfirst(startdate1,'/'))>
        <cfset dateendleave = createdate(listlast(enddate1,'/'),listgetat(enddate1,'2','/'),listfirst(enddate1,'/'))>
        <cfset datestartampm = startampm1>
        <cfset dateendampm = endampm1>
        
        <cfquery name="getleavecheck" datasource="#dts#">
        SELECT * FROM leaveutl WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">
        AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
        and ((startdate > "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate < "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate > "#dateformat(datestartleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(dateendleave,'yyyy-mm-dd')#" and enddate > "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate > "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate = "#dateformat(datestartleave,'yyyy-mm-dd')#" and (startampm = "#datestartampm#" or startampm = "FULL DAY" or "#datestartampm#" = "FULL DAY")) 
        or (enddate = "#dateformat(dateendleave,'yyyy-mm-dd')#" and (endampm = "#dateendampm#" or endampm = "FULL DAY" or "#dateendampm#" = "FULL DAY"))
        or (enddate = "#dateformat(datestartleave,'yyyy-mm-dd')#" and (endampm = "#datestartampm#" or endampm = "FULL DAY" or "#datestartampm#" = "FULL DAY")) 
        or (startdate = "#dateformat(dateendleave,'yyyy-mm-dd')#" and (startampm = "#dateendampm#" or startampm = "FULL DAY" or "#dateendampm#" = "FULL DAY"))
        )
        </cfquery>
        
        <cfquery name="getleavecheck2" datasource="#dts#">
        SELECT * FROM leaveutl WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">
        AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
        and ((startdate > "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate < "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate > "#dateformat(datestartleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(dateendleave,'yyyy-mm-dd')#" and enddate > "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate < "#dateformat(datestartleave,'yyyy-mm-dd')#" and enddate > "#dateformat(dateendleave,'yyyy-mm-dd')#")
        or (startdate = "#dateformat(datestartleave,'yyyy-mm-dd')#" and (startampm = "#datestartampm#" or startampm = "FULL DAY" or "#datestartampm#" = "FULL DAY")) 
        or (enddate = "#dateformat(dateendleave,'yyyy-mm-dd')#" and (endampm = "#dateendampm#" or endampm = "FULL DAY" or "#dateendampm#" = "FULL DAY"))
        or (enddate = "#dateformat(datestartleave,'yyyy-mm-dd')#" and (endampm = "#datestartampm#" or endampm = "FULL DAY" or "#datestartampm#" = "FULL DAY")) 
        or (startdate = "#dateformat(dateendleave,'yyyy-mm-dd')#" and (startampm = "#dateendampm#" or startampm = "FULL DAY" or "#dateendampm#" = "FULL DAY"))
        )
        </cfquery>
        
        <cfif getleavecheck2.recordcount neq 0 or getleavecheck2.recordcount neq 0>
        <cfabort showerror="Duplicate Leave Entry found">
        </cfif>
        
                    
       <!---  <cfquery name="getplacementdetails" datasource="#dts#">
        SELECT * FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">
        </cfquery>
        <cfif evaluate('getplacementdetails.#leavetype1#entitle') neq "Y">
        <input type="hidden" name="alerttext" id="alerttext" value="#leavetype1# IS NOT ENTITLED FOR PLACEMENT #url.placementno#">
        <cfabort showerror="#evaluate('#leavetype1#entitle')# IS NOT ENTITLED FOR PLACEMENT #url.placementno#">
        <cfelse> 
        	
            <cfset currentleaveclaimdate = evaluate('getplacementdetails.#leavetype1#date')>
            <cfif currentleaveclaimdate eq "">
             <cfset dateclaimfrom = createdate('1986','7','11')>
			<cfelse>
            <cfset dateclaimfrom = createdate(year(currentleaveclaimdate),month(currentleaveclaimdate),day(currentleaveclaimdate))>
            </cfif>
            <cfset dateclaimto = createdate(listlast(startdate1,'/'),listgetat(startdate1,'2','/'),listfirst(startdate1,'/'))>
        	
            <cfif dateclaimfrom gt dateclaimto>
            <input type="hidden" name="alerttext" id="alerttext" value="">
        	<cfabort showerror="Leave start date is earlier than claimable date">
			<cfelse>
            
                <cfquery name="gettotalleavetaken" datasource="#dts#">
                SELECT sum(days) as takendays FROM leavelist WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#"> and leavetype = "#leavetype1#"<cfif isdefined('url.id')> and id = "#url.id#"</cfif>
                </cfquery>
                
                <cfquery name="gettotalleavetakentemp" datasource="#dts#">
                SELECT sum(days) as takendays FROM leavelisttemp WHERE 
                uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newuuid#"> 
                and leavetype = "#leavetype1#"
                and placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#"> 
                </cfquery>
                
                <cfif leavetype1 eq "AL">
                <cfset cf = evaluate('getplacementdetails.#leavetype1#bfdays')>
                <cfelse>
                <cfset cf = 0 >
                </cfif>
                
                <cfset entitledays = numberformat(evaluate('getplacementdetails.#leavetype1#days'),'.__')>
                
                <cfif evaluate('getplacementdetails.#leavetype1#earndays') eq "Y">
                	<cfset contractstartdate = createdate(year(getplacementdetails.startdate),month(getplacementdetails.startdate),day(getplacementdetails.startdate))>
           			<cfset contractenddate = createdate(year(getplacementdetails.completedate),month(getplacementdetails.completedate),day(getplacementdetails.completedate))>         
                    <cfset contractlength = datediff('m',contractstartdate,contractenddate)>
                    
                    <cfset currentmonth = datediff('m',contractstartdate,dateclaimto)>
                    
                    <cfif val(contractlength) neq 0 and contractlength gte currentmonth>
                    <cfset entitledays = val(entitledays) * (val(currentmonth)/val(contractlength))>
                    <cfset entitledays = ceiling(entitledays)>
					</cfif> 
                    <cfif leavetype1 eq "AL" and evaluate('getplacementdetails.#leavetype1#type') neq "lmwd">
                    	<cfif entitledays lt numberformat(evaluate('getplacementdetails.#leavetype1#days'),'.__')>
                        	<cfif val(entitledays) + 1 lte numberformat(evaluate('getplacementdetails.#leavetype1#days'),'.__')>
                            	<cfset 	entitledays = entitledays + 1>
							<cfelse>
                            	<cfset entitledays = numberformat(evaluate('getplacementdetails.#leavetype1#days'),'.__')>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
                
                <cfset balance = numberformat(entitledays,'.__') + numberformat(cf,'.__') - numberformat(gettotalleavetaken.takendays,'.__')-numberformat(gettotalleavetakentemp.takendays,'.__')>
                
                <cfif val(balance) lt val(leavedays1) and numberformat(evaluate('getplacementdetails.#leavetype1#days'),'.__') neq 0>
                <input type="hidden" name="alerttext" id="alerttext" value="Insufficient leave: Leave balance = #val(balance)# and leave applied = #val(leavedays1)#">
                <cfabort showerror="Insufficient leave: Leave balance = #val(balance)# and leave applied = #val(leavedays1)#">
                <cfelse>--->
                
                    
                    <cfquery name="insertleave" datasource="#dts#">
                    INSERT INTO leaveutl
                    (
                    empno,
                    placementno,
                    leavetype,
                    days,
                    remarks,
                    startdate,
                    startampm,
                    enddate,
                    endampm,
                    created_on
                    )
                    VALUES
                    (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.placementno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#leavetype1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(leavedays1)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#remarks1#">,
                    "#dateformatnew(startdate1,'YYYY-MM-DD')#",
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#startampm1#">,
                    "#dateformatnew(enddate1,'YYYY-MM-DD')#",
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#endampm1#">,
					now()
                    )
                    </cfquery>
               
       <!---                 </cfif>
            </cfif>
            
        	
            
 </cfif> --->
        
	</cfif>
</cfif>

<cfquery name="getleavelist" datasource="#dts#">
SELECT * FROM (
SELECT * FROM leaveutl WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> 
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementno.placementno#">
                ORDER BY startdate desc) as a
                LEFT JOIN
                (SELECT costcode,desp FROM #replace(dts,'_p','_i')#.iccostcode) as b
                on a.leavetype = b.costcode
</cfquery>
<table width="100%">
<tr>
<th>Leave Type</th>
<th>Start Date</th>
<th>AM/PM</th>
<th>End Date</th>
<th>AM/PM</th>
<th>Days Taken</th>
<th>Remarks</th>
<th>Action</th>
</tr>
<cfloop query="getleavelist">
<tr>
<td>#getleavelist.desp#</td>
<td>#dateformat(getleavelist.startdate,'dd/mm/yyyy')#</td>
<td>#getleavelist.startampm#</td>
<td>#dateformat(getleavelist.enddate,'dd/mm/yyyy')#</td>
<td>#getleavelist.endampm#</td>
<td>#getleavelist.days#</td>
<td>#getleavelist.remarks#</td>
<td><input type="button" name="deleteleave" id="deleteleave" value="Delete" onClick="if(confirm('Are You Sure You Want To Delete Leave #getleavelist.desp# From #dateformat(getleavelist.startdate,'dd/mm/yyyy')# to #dateformat(getleavelist.enddate,'dd/mm/yyyy')#?')){addleave('#getleavelist.id#','delete')}"></td>
</tr>
</cfloop>
</table>
        </cfoutput>
        </cfif>
