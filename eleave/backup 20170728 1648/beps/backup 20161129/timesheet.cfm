
<cfset dts = replace(dsname,'_p','_i')>
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">

<script src="/javascripts/CalendarControl.js" language="javascript"></script>
 
 <cfquery name="company_details" datasource="payroll_main">
        SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
        </cfquery>
        
        <cfif val(company_details.mmonth) eq "13">
        <cfset company_details.mmonth = 12 >
        </cfif>
        
        <cfset currentdate = createdate(val(company_details.myear),val(company_details.mmonth),1)>
       
        

        
        <cfquery name="emp_data" datasource="#DSNAME#" >
        SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#"> 
        </cfquery>
        
         <cfquery name="checkplacementlist" datasource="#dts#">
        SELECT startdate FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and month(startdate) = "#dateformat(currentdate,'m')#" and year(startdate) = "#dateformat(currentdate,'yyyy')#"
        </cfquery>
        
        <cfif checkplacementlist.recordcount neq 0>
        <cfset currentdate = checkplacementlist.startdate>
		</cfif>
        
        
         <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(currentdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(currentdate,'yyyy-mm-dd')#"
        </cfquery>
        
        <cfif getplacementlist.timesheet eq "">
        <cfoutput>
        <h1>Online timesheet is not applicable at this moment.  Please contact Business Edge at 6745-4288 during office hour (9am to 6pm) if you have further queries.</h1>
        </cfoutput>
        <cfabort>
		</cfif>
        
        <cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
        </cfquery>
        
         <cfset startno  = left(trim(getplacementlist.timesheet),2)>
<cfset endno = mid(trim(getplacementlist.timesheet),4,2)>
        <cfif startno gt endno>
        <cfset startmonth = dateadd('m',-1,currentdate)>
        <cfelse>
        <cfset startmonth = currentdate>
		</cfif>
        
        <cfif endno eq "31">
        <cfset endno = daysinmonth(currentdate)>
		</cfif>
        
        <cfset startdate = createdate(year(startmonth),month(startmonth),val(startno))>
        <cfset enddate = createdate(year(currentdate),month(currentdate),val(endno))>
        
        <cfif getplacementlist.completedate lt enddate>
        <cfset enddate = getplacementlist.completedate>
        </cfif>
        
        <cfif getplacementlist.startdate gt startdate>
        <cfset startdate = getplacementlist.startdate>
		</cfif>
        
        
        <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(startdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(enddate,'yyyy-mm-dd')#"
        </cfquery>
        
        
        <cfquery name="getcustdetail" datasource="#dts#">
        SELECT * FROM #replace(dts,'_i','_a')#.arcust WHERE custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.custno#">
        </cfquery>
        
        <cfif getplacementlist.recordcount eq 0 >
        <cfoutput>
        <h1>No Valid Placement Found!</h1>
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

<!--- <cfif getplacementlist.phbillable eq "Y" or getplacementlist.phpayable eq "Y"> --->
<cfloop query="holiday_qry">
<cfset holidaydate = createdate(year(holiday_qry.Hol_Date),month(holiday_qry.Hol_Date),day(holiday_qry.Hol_Date))>

<cfif holidaydate gte createdate(year(getplacementlist.phdate),month(getplacementlist.phdate),day(getplacementlist.phdate))>
<cfset holidaylist = holidaylist&dateformat(holidaydate,'dd/mm/yyyy')&",">
</cfif>

</cfloop>
<!--- </cfif> --->
<!--- <cfoutput>
#holidaylist#
</cfoutput> --->
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

<head>
<script type="text/javascript">
function ottotal()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('ot'+i).value);
	}
	
	document.getElementById('totalot').value = parseFloat(startval).toFixed(2);
}

function hourtotal()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('totalhour'+i).value);
	}
	
	document.getElementById('totalhour').value = parseFloat(startval).toFixed(2);
}

function makehour(dayvar)
{
	
	var timefrom = parseFloat(document.getElementById('hr'+dayvar).value);
	var minfrom = (parseFloat(document.getElementById('mina'+dayvar).value)/60+0.000001).toFixed(3);
	
	document.getElementById('timestart'+dayvar).value = document.getElementById('hr'+dayvar).value +':'+ document.getElementById('mina'+dayvar).value+':00';
	
	timefrom = parseFloat(timefrom) + parseFloat(minfrom);
	
	var timeto = parseFloat(document.getElementById('hre'+dayvar).value);
	var minto = (parseFloat(document.getElementById('minae'+dayvar).value)/60+0.000001).toFixed(3);
	
	document.getElementById('timeoff'+dayvar).value = document.getElementById('hre'+dayvar).value +':'+ document.getElementById('minae'+dayvar).value+':00';
	
	timeto = parseFloat(timeto) + parseFloat(minto);
	
	if(timefrom <= timeto)
	{
		var totalindex =  parseFloat(timeto) - parseFloat(timefrom);
	}
	else
	{
		var totalindex = document.getElementById('hr'+dayvar).options.length-parseFloat(timefrom) + parseFloat(timeto);
	}
	
	
	var totalhour = parseFloat((parseFloat(totalindex)+0.000001).toFixed(2));
	
	
	if(document.getElementById('break'+dayvar).value == '')
	{
		document.getElementById('totalhour'+dayvar).value = totalhour.toFixed(2);
	}
	else
	{
	document.getElementById('totalhour'+dayvar).value = (totalhour-parseFloat(document.getElementById('break'+dayvar).value)).toFixed(2);
	}
	hourtotal();
}
</script>




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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
	font-size:12.0pt;
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
	font-size:9.0pt;
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
	font-size:9.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:9.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	white-space:nowrap;}
.xl828828
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
	background:##538DD5;
	mso-pattern:black none;
	white-space:normal;}
.xl838828
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
.xl848828
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
	font-size:9.0pt;
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
	font-size:9.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
	font-size:10.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
	font-size:11.0pt;
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
	font-size:10.0pt;
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
.xl1098828
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
	font-size:9.0pt;
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
	font-size:9.0pt;
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
	font-size:11.0pt;
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
	font-size:15.0pt;
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
	font-size:10.0pt;
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
.xl1178828
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
	font-size:11.0pt;
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
<form name="form1" id="form1" method="post" action="timesheetprocess.cfm" target="_blank">
<table border=0 cellpadding=0 cellspacing=0 width=800 style='border-collapse:
 collapse;table-layout:fixed;width:759pt'>
 <col width=64 span=5 style='width:48pt'>
 <col width=68 span=2 style='width:65pt'>
  <col width=64 span=3 style='width:48pt'>
 <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:118pt'>
 <col width=2 style='mso-width-source:userset;mso-width-alt:73;width:2pt'>
 <col width=0 style='display:none;mso-width-source:userset;mso-width-alt:2340'>
 <tr height=26 style='height:19.5pt'>
  <td colspan=13 class=xl1138828 width=669 style='width:502pt'>MONTHLY TIMESHEET</td>
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
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=2 rowspan=3 height=60 class=xl1188828 style='border-right:1pt solid black;
  border-bottom:1pt solid black;height:45.0pt'>Client</td>
  <td colspan=7 class=xl1248828 width=384 style='border-left:none;width:288pt'>Company
  Name &amp; Address</td>
  <td colspan=2 class=xl898828 width=221 style='width:166pt'>Contact Person
  &amp; Tel</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:15.0pt;border-left:
  none'>#getplacementlist.custname#</td>
  <td colspan=2 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getplacementlist.contactperson#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1028828 style='height:15.0pt;border-left:
  none'>#getcustdetail.add1# #getcustdetail.add2#<cfif getcustdetail.add3 neq ""><br></cfif>#getcustdetail.add3# #getcustdetail.add4# </td>
  <td colspan=2 class=xl1288828 width=221 style='border-left:none;width:166pt'>#getcustdetail.phone#</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=21 style='mso-height-source:userset;height:15.75pt'>
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
 <cfquery name="gettimesheet" datasource="#dsname#">
    SELECT * FROM timesheet WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#company_details.mmonth#"> ORDER BY tsrowcount
    </cfquery>
 <tr height=20 style='height:15.0pt'>
  <td colspan=6 height=20 class=xl1258828 style='border-right:1pt solid black;
  height:15.0pt;border-left:none'>#getplacementlist.empname#</td>
  <td colspan=2 class=xl1288828 width=128 style='border-left:none;width:96pt'>#getplacementlist.nric#</td>
  <td class=xl908828 width=157 style='border-top:none;width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=10 rowspan=2 height=40 class=xl1118828 width=576 style='height:
  30.0pt;width:432pt'>I hereby certify that the hours shown below were rendered
  by me during the specific dates and are certified as being correct by an
  authorized representative of the abovenamed Client.<span
  style='mso-spacerun:yes'>&nbsp;</span></td>
  <td class=xl818828 style='border-top:none'>My assignment ends on<span
  style='mso-spacerun:yes'>&nbsp;</span></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl748828 style='height:15.0pt;border-top:none'><input type="text" name="enddate" id="enddate" value="<cfif gettimesheet.recordcount neq 0>#dateformat(gettimesheet.assigndate,'dd/mm/yyyy')#</cfif> " size="12" readonly><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('enddate'));"></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=8 height=20 class=xl1038828 style='height:15.0pt'></td>
  <td rowspan=2 class=xl1078828 width=64 style='border-top:none;width:48pt'>Normal
  Hours Worked</td>
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
  <td class=xl878828 width=64 style='border-top:none;width:48pt'>OT<br>
    (##)</td>
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
  <td class=xl858828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Hour</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=11 height=20 class=xl1298828 style='border-right:1pt solid black;
  height:15.0pt'><cfif month(startdate) eq month(enddate)>#dateformat(startdate,'Mmm yyyy')#<cfelse>#dateformat(startdate,'Mmm yyyy')# to #dateformat(enddate,'Mmm yyyy')#</cfif></td>
  <td class=xl158828></td>
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
           
            <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl948828 style='height:15.0pt;border-top:none'><cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>#dateformat(currentdate,'Mmm')#<cfset startmonth = dateformat(currentdate,'Mmm - yyyy')></cfif></td>
  <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
  <td class=xl928828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#dateformat(currentdate,'dd')#</td>
  <td class=xl768828 style='border-top:none;border-left:none'><select name="leavetype#gettimesheet.tsrowcount#" id="leavetype#gettimesheet.tsrowcount#" onChange="if(this.value != 'PH' && this.value != ''){document.getElementById('startampm#gettimesheet.tsrowcount#').style.display='block';document.getElementById('remarks#gettimesheet.tsrowcount#').value=this.options[this.selectedIndex].id} else {document.getElementById('startampm#gettimesheet.tsrowcount#').style.display='none'}">
  <cfif gettimesheet.stcol eq "PH">
  <option value="PH">PH</option>
  <cfelse>
  <option value=""></option>
        <cfloop from="1" to="#arraylen(leavearray)#" index="i">
        <option <cfif gettimesheet.stcol eq leavearray[i]>Selected</cfif> value="#leavearray[i]#" id="#leavedesparray[i]#">#leavearray[i]#</option>
        </cfloop>
        </cfif>
        </select></td>
<td class=xl768828 style='border-top:none;border-left:none'>
   <select name="startampm#gettimesheet.tsrowcount#" id="startampm#gettimesheet.tsrowcount#" <cfif gettimesheet.stcol eq "" or gettimesheet.stcol eq "PH"> style="display:none"</cfif>>
        <option value="FULL DAY" <cfif gettimesheet.ampm eq "FULL DAY">Selected</cfif>>FULL</option>
        <option value="AM" <cfif gettimesheet.ampm eq "AM">Selected</cfif>>AM</option>
        <option value="PM"<cfif gettimesheet.ampm eq "PM">Selected</cfif>>PM</option>
        </select>
        </td>
  <td class=xl778828 width=66 style='border-top:none;border-left:none;
  width:65pt'> 
  <cfset hr = listfirst(gettimesheet.starttime,':')>
                <cfset mina = listgetat(gettimesheet.starttime,2,':')><cfif gettimesheet.stcol neq "PH">
				<select name="hr#gettimesheet.tsrowcount#" id="hr#gettimesheet.tsrowcount#" onChange="makehour('#gettimesheet.tsrowcount#');">
                <cfloop from="0" to="23" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif hr eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select>
                <select name="mina#gettimesheet.tsrowcount#" id="mina#gettimesheet.tsrowcount#" onChange="makehour('#gettimesheet.tsrowcount#');">
                <cfloop from="0" to="59" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif mina eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select></cfif>
              	<input type="hidden" name="timestart#gettimesheet.tsrowcount#" id="timestart#gettimesheet.tsrowcount#" value="#gettimesheet.starttime#">
                
  <!--- <select name="timestart#gettimesheet.tsrowcount#" id="timestart#gettimesheet.tsrowcount#"  onChange="workhour('#gettimesheet.tsrowcount#');">
  <cfif gettimesheet.stcol eq "PH">
  <option value="#gettimesheet.starttime#">#gettimesheet.starttime#</option>
  <cfelse>
  <cfset timenow = createdatetime('2013','1','1','0','0','0')>
                <cfloop from="0" to="1425"  index="a" step="5">
                
                <option value="#timeformat(dateadd('n',a,timenow),'HH:MM')#" <cfif gettimesheet.starttime eq "#timeformat(dateadd('n',a,timenow),'HH:MM')#">selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                </cfloop>
                </cfif>
                </select> --->
                </td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:65pt'>
  <cfset hre = listfirst(gettimesheet.endtime,':')>
                <cfset minae = listgetat(gettimesheet.endtime,2,':')><cfif gettimesheet.stcol neq "PH">
				<select name="hre#gettimesheet.tsrowcount#" id="hre#gettimesheet.tsrowcount#" onChange="makehour('#gettimesheet.tsrowcount#');">
                <cfloop from="0" to="23" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif hre eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select>
                <select name="minae#gettimesheet.tsrowcount#" id="minae#gettimesheet.tsrowcount#" onChange="makehour('#gettimesheet.tsrowcount#');">
                <cfloop from="0" to="59" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif minae eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select></cfif>
              	<input type="hidden" name="timeoff#gettimesheet.tsrowcount#" id="timeoff#gettimesheet.tsrowcount#" value="#gettimesheet.endtime#">
                
 <!---  <select name="timeoff#gettimesheet.tsrowcount#" id="timeoff#gettimesheet.tsrowcount#" onChange="workhour('#gettimesheet.tsrowcount#');">
  <cfif gettimesheet.stcol eq "PH">
  <option value="#gettimesheet.endtime#">#gettimesheet.endtime#</option>
  <cfelse>
  <cfset timenow = createdatetime('2013','1','1','0','0','0')>
                <cfloop from="0" to="1425"  index="a" step="5">
                
                <option value="#timeformat(dateadd('n',a,timenow),'HH:MM')#" <cfif gettimesheet.endtime eq "#timeformat(dateadd('n',a,timenow),'HH:MM')#">selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                </cfloop>
                </cfif>
                </select> ---></td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:48pt'><select name="break#gettimesheet.tsrowcount#" id="break#gettimesheet.tsrowcount#" onChange="makehour('#gettimesheet.tsrowcount#')">
  
  <cfset timenow = createdatetime('2013','1','1','0','0','0')>
  <cfloop from="0" to="105" index="a" step="15">
  <cfif gettimesheet.stcol eq "PH">
  <cfif gettimesheet.breaktime eq a/60>
  <option value="#a/60#">#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
  </cfif>
  <cfelse>
  <option value="#a/60#" <cfif gettimesheet.breaktime eq a/60>selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
  </cfif>
  </cfloop>

  </select><!--- <input type="text" name="break#gettimesheet.tsrowcount#" id="break#gettimesheet.tsrowcount#" value= "#numberformat(gettimesheet.breaktime,'.__')#" size="4" onKeyUp="workhour('#gettimesheet.tsrowcount#');" > ---></td>
  <td class=xl788828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="totalhour#gettimesheet.tsrowcount#" id="totalhour#gettimesheet.tsrowcount#" value="#numberformat(gettimesheet.workhours,'.__')#" size="4" readonly ></td>
  <cfset totalhour = totalhour + numberformat(gettimesheet.workhours,'.__')>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="ot#gettimesheet.tsrowcount#" id="ot#gettimesheet.tsrowcount#" value="#numberformat(gettimesheet.othour,'.__')#" size="4" onKeyUp="ottotal();" ></td>
  <cfset totalot = totalot + numberformat(gettimesheet.othour,'.__')>
  <td class=xl758828 style='border-top:none;border-left:none'><input type="text" name="remarks#gettimesheet.tsrowcount#" id="remarks#gettimesheet.tsrowcount#" value="#gettimesheet.remarks#" maxlength="40"></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
           
        </cfloop>
    
    <cfelse>
         <cfloop from="0" to="#nonscount#" index="i">
           <cfset pholiday = 0>
           <cfset currentdate = dateadd('d','#i#',startdate)>
           
           <cfif holidaylist neq "">
           <cfif listfind(holidaylist,dateformat(currentdate,'dd/mm/yyyy')) neq 0>
           <cfset pholiday = 1>
		   </cfif>
		   </cfif>
           
           <input type="hidden" name="day#i#" id="day#i#" value="#dateformat(currentdate,'yyyy-mm-dd')#">
            <input type="hidden" name="halfday#i#" id="halfday#i#" value="<cfif listfind(halfdaylist,DayOfWeek(currentdate)) neq 0>Y<cfelse>N</cfif>">
           
            <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl948828 style='height:15.0pt;border-top:none'><cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>#dateformat(currentdate,'Mmm - yyyy')#<cfset startmonth = dateformat(currentdate,'Mmm - yyyy')></cfif></td>
  <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
  <td class=xl928828 width=64 style='border-top:none;border-left:none;
  width:48pt'>#dateformat(currentdate,'dd')#</td>
  <td class=xl768828 style='border-top:none;border-left:none'><select name="leavetype#i#" id="leavetype#i#" onChange="if(this.value != 'PH' && this.value != ''){document.getElementById('startampm#i#').style.display='block';document.getElementById('remarks#i#').value=this.options[this.selectedIndex].id} else {document.getElementById('startampm#i#').style.display='none'}">
  <cfif pholiday eq 1 >
  <option value="PH">PH</option>
  <cfelse>
  <option value=""></option>
        <cfloop from="1" to="#arraylen(leavearray)#" index="ii">
        <option <cfif pholiday eq 1 and leavearray[ii] eq "PH">Selected</cfif> value="#leavearray[ii]#" id="#leavedesparray[ii]#">#leavearray[ii]#</option>
        </cfloop>
        </cfif>
        </select></td>
<td class=xl768828 style='border-top:none;border-left:none'>

        <select name="startampm#i#" id="startampm#i#" style="display:none">
        <option value="FULL DAY">FULL</option>
        <option value="AM">AM</option>
        <option value="PM">PM</option>
        </select></td>
  <td class=xl778828 width=66 style='border-top:none;border-left:none;
  width:65pt'> 
  <cfif evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#') eq "">
  <cfset "getplacementdetail.ts#DayOfWeek(currentdate)#" = "00:00:00">
  </cfif>
  <cfset hr = listfirst(evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#'),':')>
                <cfset mina = listgetat(evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#'),2,':')><cfif pholiday neq 1 >
				<select name="hr#i#" id="hr#i#" onChange="makehour('#i#');">
                <cfloop from="0" to="23" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif hr eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select>
                <select name="mina#i#" id="mina#i#" onChange="makehour('#i#');">
                <cfloop from="0" to="59" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif mina eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select></cfif>
              	<input type="hidden" name="timestart#i#" id="timestart#i#" value="#evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#')#">
                
  <!--- <select name="timestart#i#" id="timestart#i#"  onChange="workhour('#i#');">
  <cfif pholiday eq 1 >
  <option value="#timeformat(evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#'),'HH:MM')#">#timeformat(evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#'),'HH:MM')#</option>
  <cfelse><cfset timenow = createdatetime('2013','1','1','0','0','0')>
                <cfloop from="0" to="1425"  index="a" step="5">
                
                <option value="#timeformat(dateadd('n',a,timenow),'HH:MM')#" <cfif evaluate('getplacementdetail.ts#DayOfWeek(currentdate)#') eq "#timeformat(dateadd('n',a,timenow),'HH:MM')#">selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                </cfloop>
                </cfif>
                </select> --->
                </td>
                <cfif evaluate('getplacementdetail.to#DayOfWeek(currentdate)#') eq "">
  <cfset "getplacementdetail.to#DayOfWeek(currentdate)#" = "00:00:00">
  </cfif>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:65pt'><cfset hre = listfirst(evaluate('getplacementdetail.to#DayOfWeek(currentdate)#'),':')>
                <cfset minae = listgetat(evaluate('getplacementdetail.to#DayOfWeek(currentdate)#'),2,':')><cfif pholiday neq 1 >
				<select name="hre#i#" id="hre#i#" onChange="makehour('#i#');">
                <cfloop from="0" to="23" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif hre eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select>
                <select name="minae#i#" id="minae#i#" onChange="makehour('#i#');">
                <cfloop from="0" to="59" index="aaa">
                <option value="#numberformat(aaa,'00')#" <cfif minae eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                </cfloop>
                </select></cfif>
              	<input type="hidden" name="timeoff#i#" id="timeoff#i#" value="#evaluate('getplacementdetail.to#DayOfWeek(currentdate)#')#">
               <!---  <select name="timeoff#i#" id="timeoff#i#" onChange="workhour('#i#');">
  <cfif pholiday eq 1 >
  <option value="#timeformat(evaluate('getplacementdetail.to#DayOfWeek(currentdate)#'),'HH:MM')#">#timeformat(evaluate('getplacementdetail.to#DayOfWeek(currentdate)#'),'HH:MM')#</option>
  <cfelse><cfset timenow = createdatetime('2013','1','1','0','0','0')>
                <cfloop from="0" to="1425"  index="a" step="5">
                
                <option value="#timeformat(dateadd('n',a,timenow),'HH:MM')#" <cfif evaluate('getplacementdetail.to#DayOfWeek(currentdate)#') eq "#timeformat(dateadd('n',a,timenow),'HH:MM')#">selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                </cfloop>
                </cfif>
                </select> ---></td>
  <td class=xl778828 width=64 style='border-top:none;border-left:none;
  width:48pt'><select name="break#i#" id="break#i#" onChange="makehour('#i#')">
  
  <cfset timenow = createdatetime('2013','1','1','0','0','0')>
  <cfloop from="0" to="105" index="a" step="15">
  <cfif pholiday eq 1 >
  <cfif numberformat(evaluate('getplacementdetail.bh#DayOfWeek(currentdate)#'),'.__') eq a/60>
  <option value="#a/60#" >#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
  </cfif>
  <cfelse>
  <option value="#a/60#" <cfif numberformat(evaluate('getplacementdetail.bh#DayOfWeek(currentdate)#'),'.__') eq a/60>selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
  </cfif>
  </cfloop>
  </select><!--- <input type="text" name="break#i#" id="break#i#" value="#numberformat(evaluate('getplacementdetail.bh#DayOfWeek(currentdate)#'),'.__')#" size="4"  onKeyup="workhour('#i#');" > ---></td>
  <td class=xl788828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="totalhour#i#" id="totalhour#i#" value="#numberformat(evaluate('getplacementdetail.th#DayOfWeek(currentdate)#'),'.__')#" size="4" readonly ></td>
  <cfset totalhour = totalhour + numberformat(evaluate('getplacementdetail.th#DayOfWeek(currentdate)#'),'.__')>
  <td class=xl798828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="ot#i#" id="ot#i#" value="0.00" size="4"  onKeyUp="ottotal();"></td>
  <cfif pholiday eq "1">
  <cfquery name="getholidaydesp" datasource="#dsname#">
  SELECT hol_desp FROM holtable WHERE 
hol_date = "#dateformat(currentdate,'yyyy-mm-dd')#"
  </cfquery>
  </cfif>
  <td class=xl758828 style='border-top:none;border-left:none'><input type="text" name="remarks#i#" id="remarks#i#" <cfif pholiday eq "1">value="#getholidaydesp.hol_desp#"</cfif> maxlength="40"></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
           
        </cfloop>
        </cfif>

 
 <tr height=20 style='height:15.0pt'>
  <td colspan=8 height=20 class=xl1158828 width=448 style='border-right:1pt solid black;
  height:15.0pt;width:336pt'>Total hours for the period (exclude breaks)</td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="totalhour" id="totalhour" value="#numberformat(totalhour,'.__')#" size="4" ></td>
  <td class=xl808828 width=64 style='border-top:none;border-left:none;
  width:48pt'><input type="text" name="totalot" id="totalot" value="#numberformat(totalot,'.__')#" size="4" ></td>
  <td class=xl708828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=12 rowspan=3 height=118 class=xl1098828 width=735
  style='height:88.5pt;width:552pt'>#gettimesheetdetail.term#</td>
 </tr>
 <tr height=20 style='height:15.0pt'>
 </tr>
 <tr height=78 style='mso-height-source:userset;height:58.5pt'>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158828 style='height:15.0pt'></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl678828></td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl158828 style='height:15.75pt'></td>
  <td class=xl698828></td>
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
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
 <tr height=20 style='height:15.0pt'>
  <td colspan=13 rowspan=2 height=40 class=xl658828 width=735 style='border-right:1pt solid black;border-bottom:1pt solid black;height:30.0pt;width:552pt'>Please
  email / fax completed &amp; stamped timesheet with all supporting documents to
  &quot;timesheet@businessedge.com.sg&quot; / fax ## 6745-8955<br>
    For further assistance, please call respective offices :<span
  style='mso-spacerun:yes'>&nbsp; </span>Orchard (6732-8233)<span
  style='mso-spacerun:yes'>&nbsp;&nbsp; </span>Jurong (6569-8233)<span
  style='mso-spacerun:yes'>&nbsp; </span>Accounts (6745-4288)</td>
 </tr>
 <tr height=20 style='height:15.0pt'>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td class=xl158828 align="center" colspan="13"><input type="button" name="sub_btn" id="sub_btn" onClick="<cfif gettimesheet.recordcount neq 0 and gettimesheet.editable eq "N">Time Sheet Has Been Retrieved and Update is Not Allow<cfelse>document.getElementById('form1').submit();</cfif>" value="Save"></td>
  
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
  <td height=20 class=xl158828 style='height:15.0pt'></td>
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
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=64 style='width:48pt'></td>
  <td width=157 style='width:118pt'></td>
  <td width=2 style='width:2pt'></td>
  <td width=0></td>
 </tr>
 <![endif]>
</table>
</form>
</div>


<!----------------------------->
<!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
<!----------------------------->
</body>

</html>

</cfoutput>