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
    <!---AND tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#">
    AND tyear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tyear#">--->
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
                    remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">,
                    tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.nexmonth')#">,
                    tyear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.tyear')#">,
                    tsrowcount = <cfqueryparam  cfsqltype="CF_SQL_INTEGER" value="#i#">
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
                remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remarks#i#')#">,
                tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.nexmonth')#">,
                tyear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.tyear')#">,
                tsrowcount = <cfqueryparam  cfsqltype="CF_SQL_INTEGER" value="#i#">
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
    
    <cfset dts = replace(dsname,'_p','_i')>
    <cfset daylist = "WD,OD,RD,PH">
    <cfset OTspecial = "MINOT,MAXOT,ROUNDUP">
        
    <cfquery name="gettimesheet" datasource="#dsname#">
        SELECT * FROM 
        (
        SELECT a.*, CASE WHEN a.stcol = "" THEN "WD" ELSE a.stcol END AS stcol2, b.custno FROM timesheet a
        LEFT JOIN #dts#.placement b ON a.placementno = b.placementno
        WHERE a.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
        and (a.placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or a.placementno = "") 
        and a.pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">  
        ORDER BY a.pdate
        ) AS sort
        GROUP by pdate	
    </cfquery>
        
    <cfquery name="groupcustno" dbtype="query">
        SELECT custno FROM gettimesheet GROUP BY custno    
    </cfquery>
    
    <cfquery name="groupottype" dbtype="query">
        SELECT ot_type FROM gettimesheet GROUP BY ot_type
    </cfquery>
        
    <cfquery name="gettimesheetblock" datasource="#dsname#">
        SELECT Stop_Calc_OT FROM timesheet_block WHERE block_id IN 
        (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#ValueList(groupcustno.custno)#">)
        OR block_id = "#gettimesheet.empno#"
    </cfquery>

    <cfquery name="ot_calc" datasource="#dts#">
        SELECT * FROM icsizeid 
        WHERE sizeid IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" separator="," value="#ValueList(groupottype.ot_type)#">)
    </cfquery>
        
    <cfscript>
        //-----------------loop to get OT table-------------------------------//
        FOR (i = 1; i <= ot_calc.recordcount; i++)                           //>
        {
            FOR (daytype IN daylist)
            {
                '#daytype#OT#ot_calc["sizeid"][i]#' = ArrayNew(1);              //to declare variable array
                FOR(j = 1; j <= 8; j++)                                     //>
                {
                    getOtStruct = StructNew();
                    getOtStruct.otrate = j;
                    getOtStruct.otvalue = ot_calc["#daytype#ot#j#"][i];
                    ArrayAppend(#Evaluate('#daytype#OT#ot_calc["sizeid"][i]#')#, getotstruct);
                }
                
                otstruct = StructNew();
                otstruct = {ot1=Evaluate('ot_calc["#daytype#ot1"][i]'),
                            ot2=Evaluate('ot_calc["#daytype#ot2"][i]'), 
                            ot3=Evaluate('ot_calc["#daytype#ot3"][i]'), 
                            ot4=Evaluate('ot_calc["#daytype#ot4"][i]'), 
                            ot5=Evaluate('ot_calc["#daytype#ot5"][i]'), 
                            ot6=Evaluate('ot_calc["#daytype#ot6"][i]'), 
                            ot7=Evaluate('ot_calc["#daytype#ot7"][i]'), 
                            ot8=Evaluate('ot_calc["#daytype#ot8"][i]')};

                otstruct = StructSort(otstruct, 'Numeric', 'ASC');
                
                '#daytype#OT#ot_calc["sizeid"][i]#filtered' = ArrayNew(1);
        
                FOR(otkey IN otstruct)
                {
                    IF (#Evaluate('ot_calc["#daytype##otkey#"][i]')# !=0)
                    {
                        newstruct = StructNew();
                        newstruct.otrate = Right(otkey, 1);
                        IF (#Evaluate('ot_calc["#daytype##otkey#"][i]')# < 0)//>
                        {
                            newstruct.otvalue = 0;
                        }
                        ELSE
                        {
                            newstruct.otvalue = #Evaluate('ot_calc["#daytype##otkey#"][i]')#;
                        }
                        ArrayAppend(#Evaluate('#daytype#OT#ot_calc["sizeid"][i]#filtered')#, newstruct);
                    }
                }
            }
                
            FOR (specialkey IN OTspecial)
            {
                '#specialkey##ot_calc["sizeid"][i]#' = ArrayNew(1);              //to declare variable array
                specialOT = StructNew();
                specialOT = {'WD#specialkey#' = ot_calc["WD#specialkey#"][i],
                             'OD#specialkey#' = ot_calc["OD#specialkey#"][i],
                             'RD#specialkey#' = ot_calc["RD#specialkey#"][i],
                             'PH#specialkey#' = ot_calc["PH#specialkey#"][i]};
                ArrayAppend(#Evaluate('#specialkey##ot_calc["sizeid"][i]#')#, specialOT);
            }
        }
        
        //-------------------------------------------------------------------//
        
        FOR (row IN gettimesheet)
        {
            IF (ListFind(daylist, '#row.stcol2#', ',') == 0)
            {
                othourstruct = StructNew();
                othourstruct = {ot1=0.00,
                                ot2=0.00, 
                                ot3=0.00, 
                                ot4=0.00, 
                                ot5=0.00, 
                                ot6=0.00, 
                                ot7=0.00, 
                                ot8=0.00};
                updateTimesheet(#row.id#, othourstruct, dsname);
                continue;
            }
            day_type = "#row.stcol2#";
            date_sel = "#DateFormat(row.pdate, 'yyy-mm-dd')#";
            ot_selected = "#row.ot_type#";
            IF (Left(row.starttime, 2) > Left(row.endtime, 2))
            {
                start_time = "#date_sel# #row.starttime#";
                end_time = "#DateFormat(DateAdd('d', 1, date_sel), 'yyyy-mm-dd')# #row.endtime#";
            }
            ELSE
            {
                start_time = "#date_sel# #row.starttime#";
                end_time = "#date_sel# #row.endtime#";
            }
            break_selected = "#row.breaktime#";
            totalminutes = Abs(DateDiff('n', '#start_time#', '#end_time#'));
            totalworkhour = #ListFirst(totalminutes/60, '.')#+#NumberFormat((totalminutes mod 60)/60, '.__')#-#break_selected#;
            totalOT = 0.00;
            totalOTbalance = 0.00;
            timeToCountOT = 0.00;
            //--------------------------segregrate OT----------------------------//
            
            /*IF (gettimesheetblock.recordcount != 0 && gettimesheetblock.ot_calculate == "Y")    //--associate or client is flagged out to calculate OT on server side
            {        
                
            }
            ELSE
            {
                totalOT = row.othour;
            }*/
                
            IF(ArrayIsEmpty("#Evaluate('#day_type#OT#ot_selected#filtered')#") == "NO")       //check if array exists or not
            {
                timeToCountOT = #Evaluate('#day_type#OT#ot_selected#filtered[1].otvalue')#;   //----retrieve 1st value of filtered OT
            }

            IF (totalworkhour > timeToCountOT)                                         //work hour must more than the smallest OT hour required
            {
                totalOT = totalworkhour - timeToCountOT;        
            }    
                
                //--------------------------to apply min,max, roundup---------------//
                minOT = #Evaluate('minOT#ot_selected#[1].#day_type#minOT')#;
                maxOT = #Evaluate('maxOT#ot_selected#[1].#day_type#maxOT')#;
                roundup = #Evaluate('roundup#ot_selected#[1].#day_type#roundup')#;
                IF (minOT != 0 || maxOT != 0 || roundup != 0)
                {
                    IF (roundup != 0 && (totalOT >= roundup))
                    {
                        totalOT = NumberFormat(totalOT, '_');       //numberformat rounding 
                    }
                
                    IF (minOT != 0 && (totalOT < minOT))             //>check minimum OT
                    {
                        totalOT = 0.00;
                    }
                
                    IF (maxOT != 0 && (totalOT >= maxOT))           //check maximum OT
                    {
                        totalOT = maxOT;
                    }
                }
                //-----------------------------------------------------------------//
                
            totalOTbalance = totalOT;
            OTlen = #Evaluate('ArrayLen(#day_type#OT#ot_selected#filtered)')#;
            othourstruct = StructNew();
            othourstruct = {ot1=0.00,
                            ot2=0.00, 
                            ot3=0.00, 
                            ot4=0.00, 
                            ot5=0.00, 
                            ot6=0.00, 
                            ot7=0.00, 
                            ot8=0.00};
            
            FOR (k = 1; k <= OTlen; k++) //>
            {
                OTvalue = #Evaluate('#day_type#OT#ot_selected#filtered[k].otvalue')#;             //store value into variable
                OTrate = #Evaluate('#day_type#OT#ot_selected#filtered[k].otrate')#;               //store value into variable
                
                IF (k != OTlen)
                {   
                    hourBetweenOT = #Evaluate('#day_type#OT#ot_selected#filtered[k+1].otvalue')# -
                                        #Evaluate('#day_type#OT#ot_selected#filtered[k].otvalue')#;   //to calculate the difference between 2 ot
                    
                    IF (totalOTbalance <= hourBetweenOT) //>                                     //OT is less than the hour between 2 ot
                    {
                        'othourstruct.ot#otrate#' = totalOTbalance;
                        break;
                    }
                    ELSE IF (OTvalue == 0 )                                                          //from the beginning of the hour
                    {
                        IF (totalOTbalance < #Evaluate('#day_type#OT#ot_selected#filtered[k+1].otvalue')#)//>     //OT is less than the next OT hour
                        {
                            'othourstruct.ot#otrate#' = totalOTbalance;
                            break;
                        }
                        ELSE
                        {
                            'othourstruct.ot#otrate#' = #Evaluate('#day_type#OT#ot_selected#filtered[k+1].otvalue')#;
                            totalOTbalance -= #Evaluate('#day_type#OT#ot_selected#filtered[k+1].otvalue')#;
                        }
                    }
                    ELSE
                    {   
                        'othourstruct.ot#otrate#' = #hourBetweenOT#;                            //OT more than next OT
                        totalOTbalance -= #hourBetweenOT#;
                    }
                }
                ELSE
                {
                    'othourstruct.ot#otrate#' = totalOTbalance;                                 //reached last OT rules
                }
            }
            
            if (gettimesheetblock.Stop_Calc_OT != "Y"){
                updateTimesheet(#row.id#, othourstruct, dsname);
            }
        }
    </cfscript>
</cfif>

<cffunction name="updateTimesheet">
    <cfargument name="row_id" required="true">
    <cfargument name="otstruct" required="true" type="struct">
        
    <cfquery name="updateOT" datasource=#dsname#>
        UPDATE timesheet SET ot1 = #otstruct.ot1#,
                             ot2 = #otstruct.ot2#,
                             ot3 = #otstruct.ot3#,
                             ot4 = #otstruct.ot4#,
                             ot5 = #otstruct.ot5#,
                             ot6 = #otstruct.ot6#,
                             ot7 = #otstruct.ot7#,
                             ot8 = #otstruct.ot8#
        WHERE id = #row_id#
    </cfquery>
</cffunction>