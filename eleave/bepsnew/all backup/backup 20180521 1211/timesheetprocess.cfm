<cfsetting showdebugoutput="yes">

<cfif val(HMmonth) eq "13">
    <cfset company_details.mmonth = 12 >
</cfif>
    
<cfset startdate = form.tsdates>
<cfset enddate = form.tsdatee>  
        
<cfquery name="emp_data" datasource="#DSNAME#" >
    SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
</cfquery>
        
<cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
    AND tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#">
    AND tyear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tyear#">
    AND (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#">) 
    AND pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#">
    AND <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> 
    ORDER BY pdate
</cfquery>
    
<cfif isdefined("url.type") and url.type eq "save">

    <cfloop from="0" to="#form.totalrow#" index="i">
        <cfset currentdate = dateadd('d','#i#',startdate)>

        <cfquery name="GetSpecificTime" dbtype="query">
            SELECT * FROM gettimesheet 
            WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
            and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#">)
            and pdate = '#dateformat(currentdate,'yyyy-mm-dd')#'
            ORDER BY updated_on DESC
        </cfquery>

        <cfif GetSpecificTime.recordcount neq 0> <!---if record exists---><br>

            <cfquery name="update" datasource="#dsname#">
                UPDATE timesheet 
                SET
                pdate = "#evaluate('form.day#i#')#",
                stcol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
                <cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "" and evaluate('form.leavetype#i#') neq "OD" and evaluate('form.leavetype#i#') neq "RD">
                    ampm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
                <cfelse>
                    ampm = '',
                </cfif>
                    ot_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ottype#i#')#">,
                    starttime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timestart#i#')#">,
                    endtime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timeoff#i#')#">,
                    breaktime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.break#i#')#">,
                    workhours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.totalhour#i#')#">,
                    othour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot#i#')#">,
                    ot15hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot15#i#')#">,
                    ot2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot20#i#')#">,
                    ot3hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot30#i#')#">,
                    otrd1hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd1#i#')#">,
                    otrd2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd2#i#')#">,
                    otph1hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph1#i#')#">,
                    otph2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph2#i#')#">,
                    remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">
                <cfif trim(form.enddate) neq "">
                    ,assigndate = "#dateformatnew(form.enddate,'yyyy-mm-dd')#"
                </cfif>
                    ,status = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                    ,updated_on = now()
                    ,created_on = now()
                    ,editable = "Y"
                    ,updated_by = '#HUserID#'
                    ,created_by = '#HUserID#'
                    WHERE 
                    empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
                    and pdate = '#dateformat(currentdate,'yyyy-mm-dd')#'
                    and (placementno = "#form.hidpno#" or placementno = "")
                </cfquery>

            <cfelse> <!---record does not exist--->

                <cfquery name="Insertrow" datasource="#dsname#">
                    INSERT INTO timesheet 
                    (
                        pdate, stcol, ampm, ot_type, starttime, endtime, breaktime, workhours, othour, ot15hour, ot2hour, ot3hour,
                        otrd1hour, otrd2hour, otph1hour, otph2hour, remarks, empno, tmonth, tyear, tsrowcount, halfday, placementno
                        <cfif trim(form.enddate) neq "">
                            ,assigndate
                        </cfif>
                        ,status , updated_on, created_on, editable, updated_by, created_by
                    )
                    VALUES
                    (
                        "#evaluate('form.day#i#')#",
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
                        <cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "" and evaluate('form.leavetype#i#') neq "OD" and evaluate('form.leavetype#i#') neq "RD">
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
                        <cfelse>
                        '',
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ottype#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timestart#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timeoff#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.break#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.totalhour#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot15#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot20#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot30#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd1#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd2#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph1#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph2#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">,
                        "#form.nexmonth#",
                        "#form.tyear#",
                        "#i#",
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.halfday#i#')#">
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> 
                        <cfif trim(form.enddate) neq "">
                        ,"#dateformatnew(form.enddate,'yyyy-mm-dd')#"
                        </cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="">
                        ,now()
                        ,now()
                        ,"Y"
                        ,"#HUserID#"
                        ,"#HUserID#"
                     )
                </cfquery>
        </cfif>
    </cfloop>  

	<script type="text/javascript">
        alert("Data Saved");
        window.location.href='selecttimesheet.cfm';
    </script>

<cfelse> <!---submit--->
        
    <cfinclude template="/object/dateobject.cfm">
    <cfset dts = replace(dsname,'_p','_i')>
        
    <cfif isdefined('form.hidpno') eq false>
        <cfabort>
    <cfelse>
        <cfset startdate = form.tsdates>
        <cfset enddate = form.tsdatee>
        <cfset currentdate = form.tsdates>
    </cfif>
            
    <cfquery name="company_details" datasource="payroll_main">
       SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
    </cfquery>

    <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
    </cfif>

    <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm 
        LEFT JOIN emp_users as ep ON pm.empno = ep.empno 
        WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
    </cfquery>

    <cfloop from="0" to="#form.totalrow#" index="i">

        <cfset currentdate = dateadd('d','#i#',startdate)>
            
        <cfquery name="GetSpecificTime" dbtype="query">
            SELECT * FROM gettimesheet 
            WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
            and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#">)
            and pdate = '#dateformat(currentdate,'yyyy-mm-dd')#'
            ORDER BY updated_on DESC
        </cfquery>

        <cfif #GetSpecificTime.recordcount# neq 0 > <!---record found, update it to latest--->
        
            <cfquery name="update" datasource="#dsname#">
                UPDATE timesheet 
                SET
                pdate = "#evaluate('form.day#i#')#",
                stcol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
                <cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "" and evaluate('form.leavetype#i#') neq "OD" and evaluate('form.leavetype#i#') neq "RD">
                    ampm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
                <cfelse>
                    ampm = '',
                </cfif>
                ot_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ottype#i#')#">,
                starttime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timestart#i#')#">,
                endtime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timeoff#i#')#">,
                breaktime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.break#i#')#">,
                workhours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.totalhour#i#')#">,
                othour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot#i#')#">,
                ot15hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot15#i#')#">,
                ot2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot20#i#')#">,
                ot3hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot30#i#')#">,
                otrd1hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd1#i#')#">,
                otrd2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd2#i#')#">,
                otph1hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph1#i#')#">,
                otph2hour = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph2#i#')#">,
                remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">
                <cfif trim(form.enddate) neq "">
                    ,assigndate = "#dateformatnew(form.enddate,'yyyy-mm-dd')#"
                </cfif>
                ,status = <cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">
                ,updated_on = now()
                ,created_on = now()
                ,editable = "N"
                ,updated_by = "#HUserID#"
                ,created_by = "#HUserID#"
                WHERE 
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
                and pdate = '#dateformat(currentdate,'yyyy-mm-dd')#'
                and (placementno = "#form.hidpno#" or placementno = "")
            </cfquery>

        <cfelse> <!---record not found, insert into database--->

            <cfquery name="Insertrow" datasource="#dsname#">
                INSERT INTO timesheet 
                (
                pdate,
                stcol,
                ampm,
                ot_type,
                starttime,
                endtime,
                breaktime,
                workhours,
                othour,
                ot15hour,
                ot2hour,
                ot3hour,
                otrd1hour,
                otrd2hour,
                otph1hour,
                otph2hour,
                remarks,
                empno,
                tmonth,
                tyear,
                tsrowcount,
                halfday
                ,placementno
                <cfif trim(form.enddate) neq "">
                    ,assigndate
                </cfif>
                ,status
                ,updated_on
                ,created_on
                ,editable
                ,updated_by
                ,created_by
                )
                VALUES
                (
                "#evaluate('form.day#i#')#",
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
                <cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "" and evaluate('form.leavetype#i#') neq "OD" and evaluate('form.leavetype#i#') neq "RD">
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
                <cfelse>
                '',
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ottype#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timestart#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.timeoff#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.break#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.totalhour#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot15#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot20#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.ot30#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd1#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otrd2#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph1#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.otph2#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">,
                "#form.nexmonth#",
                "#form.tyear#",
                "#i#",
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.halfday#i#')#">
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> 
                <cfif trim(form.enddate) neq "">
                ,"#dateformatnew(form.enddate,'yyyy-mm-dd')#"
                </cfif>
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="Submitted For Approval">
                ,now()
                ,now()
                ,"Y"
                ,"#HuserID#"
                ,"#HuserID#"
                )
            </cfquery>

        </cfif>
    </cfloop>

    <cfquery name="getemail" datasource="#dts#">
        SELECT * FROM notisetting
    </cfquery>
    
    <cfset template = getemail.template1>
    <cfset header = getemail.header1>
    
    <cfquery name="getdata" datasource="#dts#">
        SELECT * FROM #dsname#.timesheet a 
        LEFT JOIN placement b on a.placementno = b.placementno
        LEFT JOIN #dsname#.pmast c on b.empno = c.empno 
        WHERE a.placementno = "#form.hidpno#"
    </cfquery>

	<cfset templatelist1 = "&amp;empno&amp;,&amp;name&amp;,&amp;hcomid&amp;,&amp;mgmtremarks&amp;,&amp;status&amp;">
    <cfset replacelist1 = "#getdata.empno#, #getdata.name#, #HComID#, #getdata.mgmtremarks#, #getdata.status#">
    
    <cfset templatelist2 = "&empno&, &name&, &HComID&">
    <cfset replacelist2 = "#getdata.empno#, #getdata.name#, #ucase(HComID)#">
    
    <cfset count1 = 0>
    <cfloop list="#templatelist1#" index="i" delimiters=",">
        <cfset count1 += 1>
        <cfset template = replace(template,i,listgetat(replacelist1,count1),'all')>
    </cfloop>
    
    <cfset count2 = 0>
    <cfloop list="#templatelist2#" index="i" delimiters=",">
        <cfset count2 += 1>
        <cfset header = replace(header,i,listgetat(replacelist2,count2),'all')>
    </cfloop>

	<cfif #getemail.setting1# eq 'Y'>
		<cfif isvalid("email",trim(getdata.hrmgremail))>
            <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.hrmgremail)#" subject="#header#" type="html"
                    bcc="alvin.hen@manpower.com.my,jiexiang.nieo@manpower.com.my,myhrhelpdesk@manpower.com.my">
                <html>
                #template#
                </html>
            </cfmail>
        </cfif>
    </cfif>

    	
	<cfoutput>
		<script type="text/javascript">
            alert("Submitted for Approval");
            window.location.href='selecttimesheet.cfm';
        </script>
    </cfoutput>
</cfif>


<cfif isdefined('form.tsdates') and isdefined('form.tsdatee') and val(form.totalot) gte 0>

    <cfquery name="gettimesheet" datasource="#dsname#">
        SELECT * FROM 
        (
        SELECT * FROM timesheet 
        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") 
        and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">  
        ORDER BY pdate
        ) AS sort
        GROUP by pdate	
    </cfquery>
    
    <cfset dts = replace(dsname,'_p','_i')>
    <cfquery name="getotid" datasource="#dts#">
    	SELECT ottable FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> 
    </cfquery>
        
    <cfquery name="getottable" datasource="#dts#">
        SELECT *, CONCAT(sizeid,',',joint_ot) AS otlist FROM icsizeid 
        WHERE trim(sizeid) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getotid.ottable#">
    </cfquery>

    <cfquery name="ot_calc" datasource="#dts#">
        SELECT * FROM icsizeid 
        WHERE sizeid IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#getottable.otlist#">)
    </cfquery>
    
    <cfif getottable.recordcount neq 0>
        <cfloop query="gettimesheet">
            <cfif val(gettimesheet.othour) neq 0>
                
                <cfquery name="realot" dbtype="query">
                    SELECT * FROM ot_calc
                    WHERE sizeid = '#gettimesheet.ot_type#'
                </cfquery>

                <cfloop from="1" to="8" index="a">
                    <cfset "ot#a#val" = 0>
                </cfloop>

                <cfset totalothour = val(gettimesheet.othour)>
                <cfset daytype = "WD">
                    
                <cfif gettimesheet.stcol eq "RD" or gettimesheet.stcol eq "OD" or gettimesheet.stcol eq "PH">
                    <cfset daytype = gettimesheet.stcol>
                </cfif>

                <cfloop from="1" to="8" index="a">
                    <cfif totalothour gte 0>
                        <cfif evaluate('realot.#daytype#OT#a#') neq 0>
                             <cfset currentothour = totalothour>

                             <cfif a neq 8>
                                 <cfloop from="#a+1#" to="8" index="i">
                                     <cfif evaluate('realot.#daytype#OT#i#') neq 0>
                                        <cfset rate1 = evaluate('realot.#daytype#OT#i#')>
                                        <cfset rate2 = evaluate('realot.#daytype#OT#a#')>

                                        <cfif rate1 lt 0>
                                            <cfset rate1 = 0>
                                        </cfif>
                                        <cfif rate2 lt 0>
                                            <cfset rate2 = 0>
                                        </cfif>

                                        <cfset otallowhour = NUMBERFORMAT(ROUND((rate1 - rate2)*100)/100,'.__')>

                                        <cfif otallowhour gt 0 and otallowhour gte  NUMBERFORMAT(totalothour,'.__')>
                                            <cfset currentothour = totalothour>
                                            <cfset totalothour = 0>
                                        <cfelseif otallowhour gt 0>
                                            <cfset currentothour = otallowhour>
                                            <cfset totalothour = totalothour - otallowhour> 
                                        </cfif>

                                        <cfbreak>  
                                    </cfif>
                                </cfloop>
                             </cfif>

                             <cfset "ot#a#val" = numberformat(ROUND(currentothour*100)/100,'.__')>
                        </cfif>
                     </cfif>
                 </cfloop>

                <cfquery name="updateot" datasource="#dsname#">
                UPDATE timesheet 
                SET
                <cfloop from="1" to="8" index="c">
                    ot#c# = "#numberformat(evaluate('ot#c#val'),'.__')#"<cfif c neq 8>,</cfif>
                </cfloop>
                WHERE id = "#gettimesheet.id#" 
                </cfquery>
                                            
            <cfelse>
                    
                <cfquery name="updateot" datasource="#dsname#">
                UPDATE timesheet 
                SET
                <cfloop from="1" to="8" index="c">
                    ot#c# = "0.00"<cfif c neq 8>,</cfif>
                </cfloop>
                WHERE id = "#gettimesheet.id#" 
                </cfquery>  
            </cfif>
        </cfloop>
    </cfif>
</cfif>