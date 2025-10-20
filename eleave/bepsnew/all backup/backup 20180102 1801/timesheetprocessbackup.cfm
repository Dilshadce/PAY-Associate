<cfif isdefined("url.type") and url.type eq "save">
            <cfif val(HMmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
        </cfquery>
        
         <cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> ORDER BY tsrowcount
    </cfquery>
        
<cfif gettimesheet.recordcount neq 0>

<cfloop from="0" to="#form.totalrow#" index="i">
<cfquery name="update" datasource="#dsname#">
UPDATE timesheet 
SET
pdate = "#evaluate('form.day#i#')#",
stcol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
<cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "">
ampm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
<cfelse>
ampm = '',
</cfif>
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
and tmonth = "#form.nexmonth#"
and tsrowcount = "#i#"
and (placementno = "#form.hidpno#" or placementno = "")
</cfquery>
</cfloop>

<cfelse>

<cfloop from="0" to="#form.totalrow#" index="i">
<cfquery name="Insertrow" datasource="#dsname#">
INSERT INTO timesheet 
(
pdate,
stcol,
ampm,
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
<cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "">
<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
<cfelse>
'',
</cfif>
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
</cfloop>
</cfif>
<script type="text/javascript">
    alert("Data Saved");
    history.go(-1);
</script>
<cfelse>
<cfsetting showdebugoutput="yes">
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
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
        </cfquery>
        
         <cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> ORDER BY tsrowcount
    </cfquery>
        
<cfif gettimesheet.recordcount neq 0>

<cfloop from="0" to="#form.totalrow#" index="i">
<cfquery name="update" datasource="#dsname#">
UPDATE timesheet 
SET
pdate = "#evaluate('form.day#i#')#",
stcol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.leavetype#i#')#">,
<cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "">
ampm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
<cfelse>
ampm = '',
</cfif>
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
and tmonth = "#form.nexmonth#"
and tsrowcount = "#i#"
and (placementno = "#form.hidpno#" or placementno = "")
</cfquery>
</cfloop>

<cfelse>

<cfloop from="0" to="#form.totalrow#" index="i">
<cfquery name="Insertrow" datasource="#dsname#">
INSERT INTO timesheet 
(
pdate,
stcol,
ampm,
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
<cfif evaluate('form.leavetype#i#') neq "PH" and evaluate('form.leavetype#i#') neq "">
<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.startampm#i#')#">,
<cfelse>
'',
</cfif>
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

<!---
<cfquery name="getempno" datasource="#dts2#">
SELECT empno,leavetype FROM leavelist a LEFT JOIN placement b on a.placementno = b.placementno WHERE id = "#url.id#"
</cfquery>
--->
<!---<cfif getempno.recordcount NEQ 0>--->

<!---    <cfmail from="#emailaccount#" to="#trim(getdata.hrmgremail)#" subject="#header#" 
    type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
    <cfif isvalid("email",trim(getdata.hrmgremail))>
        <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.hrmgremail)#" subject="#header#">>
            #template#
        </cfmail>
    </cfif>
<!---                <cfmail from="#emailaccount#" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#" 
    type="html" server="#emailserver#" username="#emailaccount#" password="#emailpassword#" port="#emailport#" usessl="#emailssl#" usetls="#emailtls#">--->
<!---    <cfmail from="donotreply@manpower.com.my" to="#trim(getdata.mppicemail)#;#trim(getdata.mppicemail2)#;#trim(getdata.mppicspemail)#" subject="#header2#">
        #template2#
    </cfmail>
</cfif>--->

</cfif>

<cfset dts = replace(dsname,'_p','_i')>

 
 <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
        </cfquery>
        
        <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
       
        

        
        <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#" 
        </cfquery>
        
        
         
        
        <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(startdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(enddate,'yyyy-mm-dd')#" and placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#">
        </cfquery>
        
        <cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
        </cfquery>
        
        <cfquery name="getcustdetail" datasource="#dts#">
        SELECT * FROM #replace(dts,'_i','_a')#.arcust WHERE custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.custno#">
        </cfquery>
        
        <cfif getplacementlist.recordcount eq 0 >
        <cfoutput>
        <h1>Online timesheet is not applicable at this moment.  Please contact Business Edge at 6745-4288 during office hour (9am to 6pm) if you have further queries.</h1>
        </cfoutput>
		<cfabort>
		</cfif>
        
         <cfset startcount = 1>
	<cfquery name="getplacementdetail" datasource="#dts#">
    SELECT 
    <cfloop list="Sun,Mon,Tues,Wednes,Thurs,Fri,Satur" index="i">
    #i#totalhour as th#startcount#,
    #i#halfday as hd#startcount#,
    <cfset startcount = startcount + 1>
    </cfloop>
    placementno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
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
    
    
<cfquery name="holiday_qry" datasource="#replace(dts,'_i','_p')#">
SELECT entryno,Hol_Date,hol_desp FROM holtable WHERE 
hol_date >= "#dateformat(startdate,'YYYY-MM-DD')#"
and hol_date <="#dateformat(enddate,'YYYY-MM-DD')#"
</cfquery>

<cfset holidaylist = "">

<cfif getplacementlist.phdate eq "">
<cfset getplacementlist.phdate = createdate('1986','7',11)>
</cfif>

<cfif getplacementlist.phbillable eq "Y" or getplacementlist.phpayable eq "Y">
<cfloop query="holiday_qry">
<cfset holidaydate = createdate(year(holiday_qry.Hol_Date),month(holiday_qry.Hol_Date),day(holiday_qry.Hol_Date))>

<cfif holidaydate gte createdate(year(getplacementlist.phdate),month(getplacementlist.phdate),day(getplacementlist.phdate))>
<cfset holidaylist = holidaylist&dateformat(holidaydate,'dd/mm/yyyy')&",">
</cfif>

</cfloop>
</cfif>


 <cfquery name="getleave" datasource="#dts#">
        Select * from iccostcode order by costcode
        </cfquery>
		<cfset leavearray = arraynew(1)>
        <cfset leavedesparray = arraynew(1)>
  
        
        <cfloop query="getleave">
        
        <cfif evaluate('getplacementlist.#getleave.costcode#entitle') eq "Y">
        <cfset arrayappend(leavearray,'#getleave.costcode#')>
        <cfset arrayappend(leavedesparray,'#getleave.desp#')>
        </cfif>
        </cfloop>

<cfset arrayappend(leavearray,'PH')>
<cfset arrayappend(leavedesparray,'')> 
    
   
		
<cfoutput>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">

<!--- <head>
<style type="text/css">
    @media print
    {
    	##non-printable { display: none; }

    }
    </style>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 14">
<link rel=File-List href="Book3_files/filelist.xml">
<style id="Book1_8828_Styles">
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
.xl158828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl658828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl668828
	{color:black;
	font-size:6.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;
	padding-left:135px;
	mso-char-indent-count:15;}
.xl678828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:justify;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl688828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:justify;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl698828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl708828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:Fixed;
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl718828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl728828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl738828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl748828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl758828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl768828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:blue;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:"\@";
	text-align:center;
	vertical-align:bottom;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl778828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:"Short Time";
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl788828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:Fixed;
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl798828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:Fixed;
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl808828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:Fixed;
	text-align:justify;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl818828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl828828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl838828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl848828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl858828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl868828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl878828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl888828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:bottom;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl898828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl908828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl918828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl928828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:d;
	text-align:center;
	vertical-align:bottom;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl938828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:ddd;
	text-align:justify;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl948828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:"mmm\\-yyyy";
	text-align:left;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl958828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:"mmm\\-yyyy";
	text-align:left;
	vertical-align:top;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl968828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:"mmm\\-yyyy";
	text-align:left;
	vertical-align:top;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl978828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl988828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl998828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1008828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1018828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1028828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl1038828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:##0000CC;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1048828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1058828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:red;
	font-size:9.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:"Times New Roman", serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl1068828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:red;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl1078828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:top;
	border:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:normal;}
.xl1088828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1098828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl1108828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1118828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl1128828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1138828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl1148828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:15.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl1158828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl1168828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1178828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl1188828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:none;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1198828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1208828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:none;
	border-bottom:none;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1218828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:none;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1228828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1238828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1248828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	background:##D9D9D9;
	mso-pattern:black none;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl1258828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl1268828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl1278828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:nowrap;}
.xl1288828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:top;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	mso-protection:unlocked visible;
	white-space:normal;}
.xl1298828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:1pt solid windowtext;
	border-right:none;
	border-bottom:1pt solid windowtext;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1308828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border-top:1pt solid windowtext;
	border-right:1pt solid windowtext;
	border-bottom:1pt solid windowtext;
	border-left:none;
	background:##D9D9D9;
	mso-pattern:black none;
	white-space:nowrap;}
.xl1318828
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	border:1pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
-->
</style>
</head> --->

<body>
<!--[if !excel]>&nbsp;&nbsp;<![endif]-->
<!--The following information was generated by Microsoft Excel's Publish as Web
Page wizard.-->
<!--If the same item is republished from Excel, all information between the DIV
tags will be replaced.-->
<!----------------------------->
<!--START OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD -->
<!----------------------------->

<!--- <div id="Book1_8828" align=center x:publishsource="Excel">
<form name="form1" id="form1" method="post" action="timesheetprocess.cfm">

<table border=0 cellpadding=0 cellspacing=0 width=735 style='border-collapse:
 collapse;table-layout:fixed;width:520pt'>
 <col width=64 span=10 style='width:42pt'>
 <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:100pt'>
 <col width=2 style='mso-width-source:userset;mso-width-alt:73;width:2pt'>
 <col width=0 style='display:none;mso-width-source:userset;mso-width-alt:2340'>
 <tr>
 <td colspan="9" class=xl1138828 style="text-align:left"></td>
 <td colspan="4" class=xl1138828 style="text-align:right;font-size:12px"></td>
 </tr>
 <tr height=26 style='height:18.5pt'>
  <td height=26 class=xl158828 width=64 style='height:18.5pt;width:48pt'></td>
  <td colspan=10 class=xl1138828 width=669 style='width:502pt;'>MONTHLY TIMESHEET</td>
  <td class=xl158828 width=2 style='width:2pt'></td>
  <td class=xl158828 width=0></td>
 </tr>

 <tr height=20 style='height:12.0pt'>
  <td colspan=2 rowspan=3 height=60 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;height:40.0pt'>Client</td>
  <td colspan=7 class=xl1248828 width=384 style='border-left:none;width:288pt'>Company
  Name &amp; Address</td>
  <td colspan=2 class=xl898828 width=221 style='width:166pt'>Contact Person
  &amp; Tel</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:12.0pt;border-left:
  none'>#getplacementlist.custname#</td>
  <td colspan=2 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getplacementlist.contactperson#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:12.0pt;border-left:
  none'>#getcustdetail.add1# #getcustdetail.add2#<cfif getcustdetail.add3 neq ""><br></cfif>#getcustdetail.add3# #getcustdetail.add4# </td>
  <td colspan=2 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getcustdetail.phone#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=21 style='mso-height-source:userset;height:14.75pt'>
  <td colspan=2 rowspan=2 height=41 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;height:30.75pt'>Staff</td>
  <td colspan=6 class=xl1248828 width=320 style='border-right:1pt solid black;
  border-left:none;width:240pt'>Name</td>
  <td colspan=2 class=xl1248828 width=128 style='border-right:1pt solid black;
  border-left:none;width:96pt'>NRIC</td>
  <td class=xl898828 width=157 style='border-top:none;border-left:none;
  width:118pt'>Signature:</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=6 height=20 class=xl1258828 style='border-right:1pt solid black;
  height:12.0pt;border-left:none'>#getplacementlist.empname#</td>
  <td colspan=2 class=xl1288828 width=128 style='border-left:none;width:96pt'>#getplacementlist.nric#</td>
  <td class=xl908828 width=157 style='border-top:none;width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=10 rowspan=2 height=40 class=xl1118828 width=576 style='height:
  30.0pt;width:432pt'>I hereby certify that the hours shown below were rendered
  by me during the specific dates and are certified as being correct by an
  authorized representative of the abovenamed Client.</td>
  <td class=xl818828 style='border-top:none'>My assignment ends on</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> ORDER BY tsrowcount
    </cfquery>
 <tr height=20 style='height:12.0pt'>
  <td height=20 class=xl748828 style='height:12.0pt;border-top:none'>#dateformat(gettimesheet.assigndate,'dd/mm/yyyy')#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=8 height=20 class=xl1038828 style='height:12.0pt'></td>
  <td rowspan=2 class=xl1078828 width=64 style='border-top:none;width:48pt'>Normal
  Hours Worked</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=32 style='height:20.0pt'>
  <td height=32 class=xl828828 width=64 style='height:20.0pt;border-top:none;
  width:48pt'>Month</td>
  <td class=xl848828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Day</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Date</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:96pt' colspan="2">Leave<br>
(Full Day/AM/PM)</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Start Time</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>End Time</td>
  <td class=xl868828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Break(s)</td>
  <td class=xl878828 width=64 style='border-top:none;width:48pt'>OT<br>
    (##)</td>
  <td class=xl838828 width=157 style='border-top:none;border-left:none;
  width:118pt'>Remarks</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=32 style='height:20.0pt'>
  <td height=32 class=xl728828 style='height:20.0pt;border-top:none'>&nbsp;</td>
  <td colspan=2 class=xl1058828 width=128 style='border-right:1pt solid black;
  border-left:none;width:96pt'>&nbsp;</td>
  <td class=xl718828 width=64 style='border-top:none;border-left:none;
  width:48pt'></td>
  <td class=xl718828 width=64 style='border-top:none;border-left:none;
  width:48pt'></td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>(less break)</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Hour</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
<tr height=20 style='height:15.0pt'>
  <td colspan=11 height=20 class=xl1298828 style='border-right:1pt solid black;border-left:1pt solid black;
  height:15.0pt'><cfif month(startdate) eq month(enddate)>#dateformat(startdate,'Mmm yyyy')#<cfelse>#dateformat(startdate,'Mmm yyyy')# to #dateformat(enddate,'Mmm yyyy')#</cfif></td>

  <td class=xl158828></td>
 </tr>
 <cfset nonscount = abs(datediff('d',startdate,enddate))>
 <cfset startmonth = "">
 <cfset startcount = 1>
	<cfquery name="getplacementdetail" datasource="#dts#">
    SELECT 
    <cfloop list="Sun,Mon,Tues,Wednes,Thurs,Fri,Satur" index="i">
    #i#totalhour as th#startcount#,
    #i#halfday as hd#startcount#,
    #i#timestart as ts#startcount#,
    #i#timeoff as to#startcount#,
    #i#breakhour as bh#startcount#,
    <cfset startcount = startcount + 1>
    </cfloop>
    placementno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
    </cfquery>
    
    
    <cfset totalhour = 0 >
    <cfset totalot = 0>
    <input type="hidden" name="totalrow" id="totalrow" value="#nonscount#">
    <input type="hidden" name="month" id="month" value="#company_details.mmonth#">
    
    <cfif gettimesheet.recordcount neq 0>
    <input type="hidden" name="updatefile" id="updatefile" value="">
     <cfloop query="gettimesheet">
           <cfset currentdate = gettimesheet.pdate>
           
           <input type="hidden" name="day#gettimesheet.tsrowcount#" id="day#gettimesheet.tsrowcount#" value="#dateformat(currentdate,'yyyy-mm-dd')#">
           
            <tr height=20 style='height:12.0pt'>
  <td height=20 class=xl948828 style='height:12.0pt;border-top:none;<cfif gettimesheet.recordcount eq gettimesheet.currentrow>; border-bottom:1pt solid black;</cfif>'><cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>#dateformat(currentdate,'Mmm')#<cfset startmonth = dateformat(currentdate,'Mmm - yyyy')></cfif></td>
  <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
  <td class=xl928828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#dateformat(currentdate,'dd')#</td>
  <td class=xl768828 style='border-top:none;border-left:none'>#gettimesheet.stcol#</td>  <td class=xl768828 style='border-top:none;border-left:none'>#gettimesheet.ampm#
        </td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#gettimesheet.starttime#</td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#gettimesheet.endtime#</td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:48pt'>
  <cfset timenow = createdatetime('2013','1','1','0','0','0')>
  #timeformat(dateadd('n',numberformat(gettimesheet.breaktime*60,'.__'),timenow),'HH:MM')#<!--- #replace(numberformat(gettimesheet.breaktime*60,'00.__'),'.',':')# ---></td>
  <td class=xl788828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.workhours,'.__')#</td>
  <cfset totalhour = totalhour + numberformat(gettimesheet.workhours,'.__')>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.othour,'.__')#</td>
  <cfset totalot = totalot + numberformat(gettimesheet.othour,'.__')>
  <td class=xl758828 style='border-top:none;border-left:none'>#gettimesheet.remarks#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
           
        </cfloop>

        </cfif>

 
 <tr height=20 style='height:12.0pt'>
  <td colspan=8 height=20 class=xl1158828 width=448 style='border-right:1pt solid black;
  height:12.0pt;width:336pt'>Total hours for the period (exclude breaks)</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalhour,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalot,'.__')#</td>
  <td class=xl708828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=12 rowspan=3 height=90 class=xl1098828 width=735
  style='height:88.5pt;width:552pt'>#gettimesheetdetail.term#</td>
 </tr>
 <tr height=20 style='height:12.0pt'>
 </tr>
 <tr height=78 style='mso-height-source:userset;height:58.5pt'>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td height=20 class=xl158828 style='height:12.0pt'></td>
  <td class=xl688828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td height=20 class=xl158828 style='height:12.0pt'></td>
  <td class=xl918828 colspan=4><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span>CLIENT NAME/SIGNATURE</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl918828 colspan=2><span
  style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp; </span>COMPANY STAMP</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <cfset totalhrday = 0 >
 <tr height=20 style='height:12.0pt'>
 <!---  <td height=20 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;'>Total</td> --->
  <td class=xl1188828>Work <cfif getplacementlist.clienttype eq "hr">Hours<cfelse>Days</cfif></td>
  
  <cfquery name="getleavegroup" datasource="#dsname#">
    SELECT stcol,sum(workhours) as totalwh FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and stcol <> "" and stcol is not null and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> GROUP BY stcol ORDER BY tsrowcount
    </cfquery>
    
    <cfloop query="getleavegroup">
    <td class=xl1188828>#getleavegroup.stcol#</td>
    </cfloop>
    <td class=xl848828>Total <cfif getplacementlist.clienttype eq "hr">Hours<cfelse>Days</cfif></td>
    <td class=xl1188828 style='border-right:1pt solid black;'>OT</td>
 </tr>
 
  <cfquery name="getall" datasource="#dsname#">
    SELECT sum(workhours) as wh FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> AND (stcol = "" or stcol is null)
    </cfquery>
    
    <cfquery name="getot" datasource="#dsname#">
    SELECT sum(othour) as oth FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">
    </cfquery>
    
    <cfquery name="getalldays" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">
    </cfquery>
    
    <cfset daycount = 0 >
    <cfset daycountwork = 0 >
    <cfset daycountwork2 = 0 >
    <cfloop query="getalldays">
    
    <cfif val(getalldays.workhours) neq 0>
		<cfif getalldays.halfday eq "Y">
        <cfset daycount = daycount + 0.5 > 
			<cfif getalldays.stcol eq "">
            <cfset daycountwork = daycountwork + 0.5 >
            </cfif>
			<cfif getalldays.stcol neq "NPL">
            <cfset daycountwork2 = daycountwork2 + 0.5 >
            </cfif>
        <cfelse>
        <cfset daycount = daycount + 1 > 
        
        	<cfif getalldays.stcol eq "">
            <cfset daycountwork = daycountwork + 1 >
            </cfif>
            <cfif getalldays.stcol neq "" and getalldays.ampm neq "FULL DAY" and getalldays.ampm neq "">
            <cfset daycountwork = daycountwork + 0.5 >
            </cfif>
			<cfif getalldays.stcol neq "NPL">
            <cfset daycountwork2 = daycountwork2 + 1 >
            </cfif>
        </cfif>
        
    </cfif>
    
    </cfloop>
    
     <tr height=20 style='height:12.0pt'>
  <!--- <td height=20  class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;'></td> --->
  <td  class=xl778828>
  <cfif getplacementlist.clienttype eq "hr">
  #numberformat(getall.wh,'.__')#
  <cfset totalhrday = totalhrday +  numberformat(getall.wh,'.__')>
  <cfelseif getplacementlist.clienttype eq "day">
  #numberformat(daycountwork2,'.__')#
  <cfset totalhrday = totalhrday +  numberformat(daycountwork2,'.__')>
  <cfelse>
  #numberformat(daycountwork,'.__')#
   <cfset totalhrday = totalhrday +  numberformat(daycountwork,'.__')>
  </cfif></td>
  
 <cfset leavenonworkday = "">
    <cfloop query="getleavegroup">
    <cfif getplacementlist.clienttype eq "hr">
    <td class=xl778828>#numberformat(getleavegroup.totalwh,'.__')#</td>
    <cfset totalhrday = totalhrday +  numberformat(getleavegroup.totalwh,'.__')>
    <cfelse>
    <cfquery name="getleave" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hidpno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> and editable = "Y" and stcol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getleavegroup.stcol#"> ORDER BY tsrowcount
    </cfquery>
    <cfset startcount = 0 >
    <cfset monthrealcount = 0>
    <cfset showast = 0>
    
    <cfloop query="getleave">
    <cfif val(getleave.workhours) eq 0>
    <cfset showast = 1>
	</cfif>
    <cfif getleave.ampm eq "FULL DAY" or getleave.ampm eq "">
    <cfset startcount = startcount + 1>
		<cfif val(getleave.workhours) neq 0>
        <cfset monthrealcount = monthrealcount + 1>
        </cfif>
    <cfelse>
    <cfset startcount = startcount + 0.5>
		<cfif val(getleave.workhours) neq 0>
        <cfset monthrealcount = monthrealcount + 0.5>
        </cfif>
	</cfif>
    </cfloop>
    <cfif showast neq 0>
    <cfset leavenonworkday =leavenonworkday&"#getleavegroup.stcol# is non workday"&chr(10)>
	</cfif>
    <td class=xl778828><cfif showast neq 0>*</cfif>#numberformat(startcount,'.__')#</td>
    <cfset totalhrday = totalhrday +  numberformat(monthrealcount,'.__')>
	</cfif>
    
    </cfloop>
    <td class=xl778828>#numberformat(totalhrday,'.__')#</td>
    <td class=xl778828>#numberformat(getot.oth,'.__')#</td>
 </tr>
 <cfif leavenonworkday neq "">
 <tr height=20 style='height:12.0pt'>
  <td class=xl1188828 colspan="#val(3+getleavegroup.recordcount)#" style='border-right:1pt solid black;border-bottom:1pt solid black;'><div align="left">#leavenonworkday#</div></td>
 </cfif>
 <tr height=20 style='height:12.0pt'>
  <td height=20 class=xl158828 style='height:12.0pt'></td>
  <td class=xl688828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:12.0pt'>
  <td colspan=12 rowspan=2 height=40 class=xl658828 width=735 style='border-right:1pt solid black;border-bottom:1pt solid black;height:30.0pt;width:552pt'>Please
  email / fax completed &amp; stamped timesheet with all supporting documents to &quot;xxx&quot; / fax ## 99999999<br>
    For further assistance, please call respective offices :<span
  style='mso-spacerun:yes'>&nbsp; </span>xxx (99999999)<span
  style='mso-spacerun:yes'>&nbsp;&nbsp; </span>xxx (99999999)<span
  style='mso-spacerun:yes'>&nbsp; </span>xxx (99999999s)</td>
 </tr>
 <tr height=20 style='height:12.0pt'>
 </tr>
 <tr>
 <td colspan="13" align="center"><input type="button" name="print_btn" id="non-printable" onClick="window.print();" value="PRINT"></td>
 </tr>
</table>
</form>
</div> --->


<!----------------------------->
<!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
<!----------------------------->
</body>

</html>
<!--- <script type="text/javascript">
window.opener.location.reload();
</script> --->
<script type="text/javascript">
    alert("Submited for Approval");
    history.go(-1);
</script>
</cfoutput>
</cfif>