<cfsetting showdebugoutput="yes">
<cfset pno = "">
<cfset datestart = "">
<cfset dateend = "">
<cfset tmonth = '8'>
<cfset dts2 = #dts#>
<cfset dts = #replace(dts, '_i', '_p')#>
<cfset hcomid = replace(hcomid,'_i','')>
<cfset counter = 1>

<cfquery name="gettimelist" datasource="#dts2#">
    SELECT b.placementno, max(b.tsrowcount) as end, min(b.tsrowcount) as start
    FROM placement a
    LEFT JOIN #dts#.timesheet b
    ON a.placementno = b.placementno
    WHERE b.tmonth = '#tmonth#'
    AND a.custname like '%samsung%'
    AND status = 'Approved'
    GROUP BY b.placementno
</cfquery>

<cfloop query="gettimelist">
    <cfquery name="getstart" datasource="#dts#">
        SELECT pdate
        FROM timesheet
        WHERE placementno = '#gettimelist.placementno#'
        AND tmonth = '#tmonth#'
        AND tsrowcount = '#gettimelist.start#'
    </cfquery>
    
    <cfquery name="getend" datasource="#dts#">
        SELECT pdate
        FROM timesheet
        WHERE placementno = '#gettimelist.placementno#'
        AND tmonth = '#tmonth#'
        AND tsrowcount = '#gettimelist.end#'
    </cfquery>
    
    <cfset pno = gettimelist.placementno>
    <cfset datestart = getstart.pdate>
    <cfset dateend = getend.pdate>
    <cfset tmonth = #tmonth#>
    
<cfquery name="company_details" datasource="payroll_main">
   SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
        
        <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfquery name="emp_data" datasource="#dts#" >
        SELECT * FROM pmast as pm WHERE empno = '100125327'
        </cfquery>
        
        <!---<cfquery name="gettimesheet" datasource="#dts#">
        SELECT * FROM timesheet WHERE placementno = '#pno#' and pdate between "#datestart#" and "#dateend#" order by pdate
        </cfquery>--->
        
        <!---edited query, [2017/01/18, Alvin]--->
        <cfquery name="gettimesheet" datasource="#dts#">
            SELECT * FROM 
                (
                    SELECT * FROM timesheet 
                    WHERE(placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pno#"> or placementno = "") 
                    and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(datestart, 'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(dateend, 'yyyy-mm-dd')#">  
                    ORDER BY pdate
                ) AS sort
                GROUP by pdate	
        </cfquery>
      <!---edited--->

        <cfquery name="getplacementlist" datasource="#dts2#">
        SELECT * FROM placement WHERE placementno = '#pno#'
        </cfquery>

        <cfquery name="getcustdetail" datasource="#dts2#">
        SELECT * FROM arcust WHERE custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.custno#">
        </cfquery>
        
        <cfquery name="gettimesheetdetail" datasource="#dts2#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
        </cfquery>
        
        <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
        </cfquery>
        
        <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
       
        

        
        <cfquery name="emp_data" datasource="#dts#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#" 
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


 <cfquery name="getleave" datasource="#dts2#">
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

<head>
<style type="text/css">
    @media print
    {
    	##non-printable { display: none; }
        footer {page-break-after: always; }

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
</head>

<body>
<!--[if !excel]>&nbsp;&nbsp;<![endif]-->
<!--The following information was generated by Microsoft Excel's Publish as Web
Page wizard.-->
<!--If the same item is republished from Excel, all information between the DIV
tags will be replaced.-->
<!----------------------------->
<!--START OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD -->
<!----------------------------->

<div id="Book1_8828" align=center x:publishsource="Excel">
<form name="form1" id="form1" method="post" action="timesheetprocess.cfm">

<table border=0 cellpadding=0 cellspacing=0 width=800 style='border-collapse:
 collapse;table-layout:fixed;width:800pt'>
 <col width=32 span=3 style='width:30pt'>
 <col width=64 span=2 style='width:36pt'>
 <col width=68 span=2 style='width:60pt'>
  <col width=64 span=2 style='width:44pt'>
  <col width=34 span=8 style='width:26pt'>
 <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:100pt'>
 <col width=2 style='mso-width-source:userset;mso-width-alt:73;width:2pt'>
 <col width=0 style='display:none;mso-width-source:userset;mso-width-alt:2340'>
 <tr height=26 style='height:19.5pt'>
  <td colspan=20 class=xl1138828 width=669 style='width:502pt'>#counter#: MONTHLY TIMESHEET</td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158828 style='height:15.0pt'></td>
  <td class=xl668828></td>
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
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=2 rowspan=3 height=60 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;height:45.0pt'>Client</td>
  <td colspan=7 class=xl1248828 width=384 style='border-left:none;width:288pt'>Company
  Name &amp; Address</td>
  <td colspan=9 class=xl898828 width=221 style='width:166pt'>Contact Person
  &amp; Tel</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:15.0pt;border-left:
  none'>#getplacementlist.custname#</td>
  <td colspan=9 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getplacementlist.contactperson#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:15.0pt;border-left:
  none'>#getcustdetail.add1# #getcustdetail.add2#<cfif getcustdetail.add3 neq ""><br></cfif>#getcustdetail.add3# #getcustdetail.add4# </td>
  <td colspan=9 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getcustdetail.phone#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=21 style='mso-height-source:userset;height:15.75pt'>
  <td colspan=2 rowspan=2 height=41 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;height:30.75pt'>Staff</td>
  <td colspan=7 class=xl1248828 width=320 style='border-right:1pt solid black;
  border-left:none;width:240pt'>Name</td>
  <td colspan=7 class=xl1248828 width=128 style='border-right:1pt solid black;
  border-left:none;width:96pt'>NRIC</td>
  <td colspan="2" class=xl898828 style='border-top:none;border-left:none'>Signature:</td>
 </tr>
<!---  <cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> or placementno = "") and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">  ORDER BY tsrowcount
    </cfquery> --->
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1258828 style='border-right:1pt solid black;
  height:15.0pt;border-left:none'>#getplacementlist.empname#</td>
  <td colspan=7 class=xl1288828 width=128 style='border-left:none;width:96pt'>#getplacementlist.nric#</td>
  <td rowspan="3" height=20 class=xl748828 style='height:15.0pt;border-top:none' colspan="2"><input type="hidden" name="enddate" id="enddate" value="<cfif gettimesheet.recordcount neq 0>#dateformat(gettimesheet.assigndate,'dd/mm/yyyy')#</cfif> " size="12" readonly><!--- <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('enddate'));"> ---></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=16 rowspan=2 height=40 class=xl1118828 width=576 style='height:
  30.0pt;width:432pt'>I hereby certify that the hours shown below were rendered
  by me during the specific dates and are certified as being correct by an
  authorized representative of the abovenamed Client.<span
  style='mso-spacerun:yes'>&nbsp;</span></td>
    

 </tr>
 <tr height=20 style='height:15.0pt'>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=8 height=20 class=xl1038828 style='height:15.0pt'></td>
  <td rowspan=2 class=xl1078828 width=64 style='border-top:none;width:48pt'>Normal
  Hours Worked</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none'>&nbsp;</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=32 style='height:24.0pt'>
  <td height=32 class=xl828828 width=64 style='height:24.0pt;border-top:none;
  width:48pt'>Month</td>
  <td class=xl848828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Day</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Date</td>
  <td colspan="2" class=xl838828 width=100 style='border-top:none;border-left:none;
  width:96pt'>Leave<br>
(Full Day/AM/PM)</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Start Time</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>End Time</td>
  <td class=xl868828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Break(s)</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 1</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 1.5</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 2</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT 3</td>
  <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt'>Rest</td>
  <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt'>PH</td>
  
  <td class=xl838828 width=157 style='border-top:none;border-left:none;
  width:118pt'>Remarks</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=32 style='height:24.0pt'>
  <td height=32 class=xl728828 style='height:24.0pt;border-top:none'>&nbsp;</td>
  <td colspan=2 class=xl1058828 width=128 style='border-right:1pt solid black;
  border-left:none;width:96pt'>&nbsp;</td>
  <td class=xl718828 width=64 style='border-top:none;border-left:none;
  width:48pt'>&nbsp;</td>
  <td class=xl718828 width=64 style='border-top:none;border-left:none;
  width:48pt'>&nbsp;</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>hh:mm</td>
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>(less break)</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>1.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>2.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>1.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt'>2.0</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr><cfif month(datestart) eq month(dateend)>#dateformat(datestart,'Mmm yyyy')#<cfelse>#dateformat(datestart,'Mmm yyyy')# to #dateformat(dateend,'Mmm yyyy')#</cfif></td>

  <td class=xl158828></td>
 </tr>
 <cfset nonscount = abs(datediff('d',datestart,dateend))>
 <cfset startmonth = "">
 <cfset startcount = 1>
	<cfquery name="getplacementdetail" datasource="#dts2#">
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
    <cfset totalot15 = 0>
    <cfset totalot2 = 0>
    <cfset totalot3 = 0>
    <cfset totalotrd1 = 0>
    <cfset totalotrd2 = 0>
    <cfset totalotph1 = 0>
    <cfset totalotph2 = 0>
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
  width:48pt'>#numberformat(gettimesheet.ot1,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot2,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot3,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot4,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot5,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot6,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot7,'.__')#</td>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(gettimesheet.ot8,'.__')#</td>
  <cfset totalot = totalot + numberformat(gettimesheet.ot1,'.__')>
  <cfset totalot15 = totalot15 + numberformat(gettimesheet.ot2,'.__')>
  <cfset totalot2 = totalot2 + numberformat(gettimesheet.ot3,'.__')>
  <cfset totalot3 = totalot3 + numberformat(gettimesheet.ot4,'.__')>
  <cfset totalotrd1 = totalotrd1 + numberformat(gettimesheet.ot5,'.__')>
  <cfset totalotrd2 = totalotrd2 + numberformat(gettimesheet.ot6,'.__')>
  <cfset totalotph1 = totalotph1 + numberformat(gettimesheet.ot7,'.__')>
  <cfset totalotph2 = totalotph2 + numberformat(gettimesheet.ot8,'.__')>
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
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalot15,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalot2,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalot3,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalotrd1,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalotrd2,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalotph1,'.__')#</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#numberformat(totalotph2,'.__')#</td>
  <td class=xl708828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr>
  <td colspan=18 class=xl658828 width=735 style='border-right:1pt solid black;border-bottom:1pt solid black;height:30.0pt;width:552pt'>#gettimesheetdetail.term#</td>
 </tr>
 <cfset totalhrday = 0 >
 <!--- <tr height=20 style='height:12.0pt'>
 <!---  <td height=20 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;'>Total</td> --->
  <td class=xl1188828><cfif getplacementlist.clienttype eq "hr">Hours<cfelse>Days</cfif></td>
  
   <cfquery name="getleavegroup" datasource="#dts#">
    SELECT stcol,sum(workhours) as totalwh FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tmonth#"> and stcol <> "" and stcol is not null  GROUP BY stcol ORDER BY tsrowcount
    </cfquery>
    
    
    <cfloop query="getleavegroup">
    <td class=xl1188828>#getleavegroup.stcol#</td>
    </cfloop>
    <td class=xl848828>Total <cfif getplacementlist.clienttype eq "hr">Hours<cfelse>Days</cfif></td>
    <td class=xl1188828 style='border-right:1pt solid black;'>OT</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>OT 1.5</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>OT 2.0</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>OT 3.0</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>RD 1.0</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>RD 2.0</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>PH 1.0</td>
    <td class=xl1188828 style='border-right:1pt solid black;'>PH 2.0</td>
    
 </tr>
 
    <cfquery name="getall" datasource="#dts#">
    SELECT sum(workhours) as wh FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> 
    AND placementno = '#pno#'
     and tmonth = '#tmonth#'
    </cfquery>
    
    <cfquery name="getot" datasource="#dts#">
    SELECT sum(othour) as oth
    ,sum(ot15hour) as oth15
    ,sum(ot2hour) as oth2
    ,sum(ot3hour) as oth3
    ,sum(otrd1hour) as othrd1
    ,sum(otrd2hour) as othrd2
    ,sum(otph1hour) as othph1
    ,sum(otph2hour) as othph2
     FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> 
    AND placementno = '#pno#'
     and tmonth = '#tmonth#'
    </cfquery>
    
    <cfquery name="getalldays" datasource="#dts#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> 
    AND placementno = '#pno#'
     and tmonth = '#tmonth#'
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
    <cfquery name="getleave" datasource="#dts#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.empno#"> 
    AND placementno = '#pno#' and tmonth = '#tmonth#'
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
    <td class=xl778828>#numberformat(getot.oth15,'.__')#</td>
    <td class=xl778828>#numberformat(getot.oth2,'.__')#</td>
    <td class=xl778828>#numberformat(getot.oth3,'.__')#</td>
    <td class=xl778828>#numberformat(getot.othrd1,'.__')#</td>
    <td class=xl778828>#numberformat(getot.othrd2,'.__')#</td>
    <td class=xl778828>#numberformat(getot.othph1,'.__')#</td>
    <td class=xl778828>#numberformat(getot.othph2,'.__')#</td>
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
 </tr> --->

<!--- <tr>
 <td colspan="19" align="center"><input type="button" name="print_btn" id="non-printable" onClick="window.print();" value="PRINT"></td>
 </tr>--->
</table>
</form>
</div>


<!----------------------------->
<!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
<!----------------------------->
</body>
<footer>

</footer>

</html>
<!--- <script type="text/javascript">
window.opener.location.reload();
</script> --->

</cfoutput>
<cfset counter += 1>
</cfloop>
