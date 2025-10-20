
<cfset dts = replace(dsname,'_p','_i')>
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<script src="/js/jquery/jquery-3.1.1.min.js"></script>

<script src="/javascripts/CalendarControl.js" language="javascript"></script>
 <cfif isdefined('form.pno') eq false>
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

        <cfquery name="getplacementlist" datasource="#dts#">
        SELECT * FROM placement WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> and startdate <= "#dateformat(startdate,'yyyy-mm-dd')#" and completedate >= "#dateformat(enddate,'yyyy-mm-dd')#" and placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
        </cfquery>
        
        <cfquery name="gettimesheetdetail" datasource="#dts#">
        SELECT * FROM iccolorid  WHERE colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.timesheet#">
        </cfquery>
        
        <!---removed dts replacement from i to a, [20170105, Alvin]--->
        <cfquery name="getcustdetail" datasource="#dts#">
        SELECT * FROM <!---#replace(dts,'_i','_a')#.--->arcust WHERE custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.custno#">
        </cfquery>
        <!---edited--->
        
        <cfif getplacementlist.recordcount eq 0 >
        <cfoutput>
        <h1>No Valid Placement Found!</h1>
        </cfoutput>
		<cfabort>
		</cfif>
        <!---Save current placement custno, [20170727, Alvin]--->
        <cfoutput>
        	<input type="hidden" id="custno" value="#getplacementlist.custno#">
        	<input type="hidden" id="exceptioncustno" value="300033881">
        </cfoutput>
        <!---Save current placement custno--->
        
        <!---Add exception placementno to enable custom submit for samsung only, [20170807, Alvin]--->
        <cfoutput>
            <cfset exceptionList = "100130342,100129566,100131378,100129975,100130385,100130136,100130774,100130014,100129846,100129815,100130869,100131215,100129873,100129814,100131065,10129582,100130822,100130666,100131167,100108995,100131454,100131578,100131443,100129627,100129992,100104879,100130337,100129752,100129581,100129947,100131381,100130464,100130339,100129751,100129853,100130728,100131446,100131379,100130792,100129976,100129644,100129626,100130869,100131442,100129973,100131212,100130684,100131071,100131318,100130426,100131440,100131116,100130476,100131463,100129988,100129946,100129754,100131441,100131116,100130803,100130617,100131017,100130744,100129685">
            <input type="hidden" id="exceptionFlag" value="#ListFind(exceptionList, getplacementlist.empno, ',')#">
        </cfoutput>
        <!---Add exception--->
        
         <cfset startcount = 1>
	<cfquery name="getplacementdetail" datasource="#dts#">
    SELECT 
    <cfloop list="Sun,Mon,Tues,Wednes,Thurs,Fri,Satur" index="i">
    #i#totalhour as th#startcount#,
    #i#halfday as hd#startcount#,
    <cfset startcount = startcount + 1>
    </cfloop>
    placementno,ottable FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
    </cfquery>
    
    <cfquery name="getottable" datasource="#dts#">
    SELECT * FROM icsizeid WHERE trim(sizeid) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getplacementdetail.ottable)#">
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
    
    
<!--- <cfquery name="holiday_qry" datasource="#replace(dts,'_i','_p')#">
SELECT entryno,Hol_Date,hol_desp FROM holtable WHERE 
hol_date >= "#dateformat(startdate,'YYYY-MM-DD')#"
and hol_date <="#dateformat(enddate,'YYYY-MM-DD')#"
</cfquery> --->

<cfset holidaylist = "">

<cfif getplacementlist.phdate eq "">
<cfset getplacementlist.phdate = createdate('1986','7',11)>
</cfif>

<!--- <cfif getplacementlist.phbillable eq "Y" or getplacementlist.phpayable eq "Y"> --->
<!--- <cfloop query="holiday_qry">
<cfset holidaydate = createdate(year(holiday_qry.Hol_Date),month(holiday_qry.Hol_Date),day(holiday_qry.Hol_Date))>

<cfif holidaydate gte createdate(year(getplacementlist.phdate),month(getplacementlist.phdate),day(getplacementlist.phdate))>
<cfset holidaylist = holidaylist&dateformat(holidaydate,'dd/mm/yyyy')&",">
</cfif>

</cfloop> --->

<cfloop from="1" to="30" index="bb">
<cfif evaluate('getottable.phdate#bb#') neq "0000-00-00">
<cfif evaluate('getottable.phdate#bb#') gte getplacementlist.phdate>
<cfset holidaylist = holidaylist&dateformat(evaluate('getottable.phdate#bb#'),'dd/mm/yyyy')&",">
</cfif>
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
<cfset arrayappend(leavearray,'OD')>
<cfset arrayappend(leavedesparray,'')> 
<cfset arrayappend(leavearray,'RD')>
<cfset arrayappend(leavedesparray,'')> 
    
   
		
<cfoutput>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<script type="text/javascript">
<!---added document ready to disable input time class, [20170727, Alvin]--->
$(document).ready(function(){
	
	if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value){
		$('.inputTime').prop('disabled', true);
		$('.inputOT').prop('readonly', true);
	}
    <!---Added enable timesheet for 2 months ahead if end of contract reached, [20171002 1728, Alvin]--->
    <cfif (#form.nexmonth# GT '2') AND (DateCompare('#DateFormat("#CreateDate(company_details.myear, form.nexmonth, 1)#", "yyyy-mm-dd")#', '#DateFormat(getplacementlist.completedate, "yyyy-mm-dd")#', 'm') NEQ 0)>
        if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value){
            $('##save').prop('disabled', true);
            $('##sub_btn').prop('disabled', true);
        }
    </cfif>
    <!---Added enable timesheet for 2 months ahead if end of contract reached, [20171002 1728, Alvin]--->
});
<!---added document ready to disable input time class --->

<!---added for enabling disabled input, [20170731, Alvin] --->
function enableInputTime()
{
    if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value){
	   $('.inputTime').prop('disabled', false);
    }
	document.getElementById('Book1_8828').style.display = 'none';
	document.getElementById('submitnotice').style.display= 'block';
}
<!---added for enabling disabled input --->
	
<!---added set start end time to 00 when leavetype chosen, [20170119, Alvin]--->
function SetLeaveTime(leavetype, ampm, hourstart, minstart, hourend, minend, breaktime)
{
	if(leavetype != '')
	{
		document.getElementById(hourstart).value = '00';
		document.getElementById(minstart).value = '00';
		document.getElementById(hourend).value = '00';
		document.getElementById(minend).value = '00';	
		document.getElementById(breaktime).value = '0';				
	}
}
<!---added leave startend time change--->
	
<!---set default time in out, [20170727, Alvin]--->
function SetDefaultTime(ampm, hourstart, minstart, hourend, minend, breaktime, remarks)
{
	document.getElementById(ampm).style.display='none';
	document.getElementById(hourstart).value = document.getElementById('normalstarthourtime').value;
	document.getElementById(minstart).value = document.getElementById('normalstartminutetime').value;
	document.getElementById(hourend).value = document.getElementById('normalendhourtime').value;
	document.getElementById(minend).value = document.getElementById('normalendminutetime').value;	
	document.getElementById(breaktime).value = document.getElementById('normalbreak').value;
	document.getElementById(remarks).value = '';
}
<!---set default time in out--->
	
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

function ot15total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('ot15'+i).value);
	}
	
	document.getElementById('totalot15').value = parseFloat(startval).toFixed(2);
}

function ot2total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('ot20'+i).value);
	}
	
	document.getElementById('totalot2').value = parseFloat(startval).toFixed(2);
}

function ot3total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('ot30'+i).value);
	}
	
	document.getElementById('totalot3').value = parseFloat(startval).toFixed(2);
}

function otrd1total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('otrd1'+i).value);
	}
	
	document.getElementById('totalotrd1').value = parseFloat(startval).toFixed(2);
}

function otrd2total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('otrd2'+i).value);
	}
	
	document.getElementById('totalotrd2').value = parseFloat(startval).toFixed(2);
}

function otph1total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('otph1'+i).value);
	}
	
	document.getElementById('totalotph1').value = parseFloat(startval).toFixed(2);
}

function otph2total()
{
	var startcount = parseFloat(document.getElementById('totalrow').value);
	var startval = 0;
	for(var i = 0;i<=startcount;i++)
	{
		startval = parseFloat(startval) + parseFloat(document.getElementById('otph2'+i).value);
	}
	
	document.getElementById('totalotph2').value = parseFloat(startval).toFixed(2);
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
	calot(dayvar);
}
<!---remove disabled property from input to submit form, [20170727,Alvin]--->
function savebtn(){
	//$(".inputTime").prop("disabled",false);
    document.getElementById('form1').action="timesheetprocess.cfm?type=save";
    document.getElementById('form1').target="_self";
    document.getElementById('form1').submit();
    }
<!---remove disabled property from input to submit form properly--->
<cfoutput>
function calot(dayvar)
{
	var daytype = document.getElementById('leavetype'+dayvar).value;
	var hournowobj = document.getElementById('totalhour'+dayvar);
	var othourpoint = 0;
	var minothourpoint = 0;
	var maxothourpoint = 0;
	var roundothourpoint = 0;
    
	if (daytype == '')
	{
		<cfloop from="1" to="8" index="ee">
		<cfif val(evaluate('getottable.WDOT#ee#')) neq 0>
		othourpoint = #val(evaluate('getottable.WDOT#ee#'))#;
		<cfbreak>
		</cfif>
		</cfloop>
        minothourpoint = #val(evaluate('getottable.WDMINOT'))#;
        maxothourpoint = #val(evaluate('getottable.WDMAXOT'))#;
        roundothourpoint = #val(evaluate('getottable.WDROUNDUP'))#;
	}
	else if (daytype == 'OD')
	{
		<cfloop from="1" to="8" index="ee">
		<cfif val(evaluate('getottable.ODOT#ee#')) neq 0>
		othourpoint = #val(evaluate('getottable.ODOT#ee#'))#;
		<cfbreak>
		</cfif>
		</cfloop>
        minothourpoint = #val(evaluate('getottable.ODMINOT'))#;
        maxothourpoint = #val(evaluate('getottable.ODMAXOT'))#;
        roundothourpoint = #val(evaluate('getottable.ODROUNDUP'))#;
	}
	else if (daytype == 'RD')
	{
		<cfloop from="1" to="8" index="ee">
		<cfif val(evaluate('getottable.RDOT#ee#')) neq 0>
		othourpoint = #val(evaluate('getottable.RDOT#ee#'))#;
		<cfbreak>
		</cfif>
		</cfloop>
        minothourpoint = #val(evaluate('getottable.RDMINOT'))#;
        maxothourpoint = #val(evaluate('getottable.RDMAXOT'))#;
        roundothourpoint = #val(evaluate('getottable.RDROUNDUP'))#;
	}
	else if (daytype == 'PH')
	{
		<cfloop from="1" to="8" index="ee">
		<cfif val(evaluate('getottable.PHOT#ee#')) neq 0>
		othourpoint = #val(evaluate('getottable.PHOT#ee#'))#;
		<cfbreak>
		</cfif>
		</cfloop>
        minothourpoint = #val(evaluate('getottable.PHMINOT'))#;
        maxothourpoint = #val(evaluate('getottable.PHMAXOT'))#;
        roundothourpoint = #val(evaluate('getottable.PHROUNDUP'))#;
	}
    
	if(parseFloat(othourpoint) == -1)
	{
		var otnow = hournowobj.value;
		document.getElementById('ot'+dayvar).value=parseFloat(otnow).toFixed(2);
		hournowobj.value = "0.00";
	}
	else
	{
        if(parseFloat(othourpoint) != 0 )
        {
            var hournow = parseFloat(hournowobj.value);
    
            if(hournow > parseFloat(othourpoint))                                               //total hour exceed normal working hour - eligible for ot
            {
                var otnow = hournow - parseFloat(othourpoint);
    
                if(minothourpoint != 0 || maxothourpoint != 0 || roundothourpoint != 0)         //either value will enter if statement
                {
                    if(roundothourpoint != 0 && (otnow >= roundothourpoint))                    //round up first
                    {
                        otnow = Math.round(parseFloat(otnow));
                    }
    
                    if(minothourpoint != 0 && (otnow < minothourpoint))                         //check minimum
                    {   
                        otnow = 0.00;
                    }
    
                    if(maxothourpoint != 0 && (otnow >= maxothourpoint))                        //check maximum
                    {
                        otnow = parseFloat(maxothourpoint);
                    }
                }
    
                document.getElementById('ot'+dayvar).value=parseFloat(otnow).toFixed(2);
                hournowobj.value = parseFloat(othourpoint).toFixed(2);
            }
            else
            {
            document.getElementById('ot'+dayvar).value="0.00";
            }
        }
        else
        {
            document.getElementById('ot'+dayvar).value="0.00";
        }
	}
	
	ottotal();
}
</cfoutput>
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
	color:##000;
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
	color:##000;
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
	color:##000;
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
	background:##e77c22;
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
	background:##e77c22;
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
	background:##e77c22;
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
	background:##e77c22;
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
	background:##e77c22;
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
	color:##000;
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
	color:##000;
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
	color:##000;
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
	color:##000;
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
	color:##000;
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
<div id="submitnotice" align="center" style="display:none">
	<h2> Processing Timesheet.</h2>
</div>
<div id="Book1_8828" align=center x:publishsource="Excel">
<form name="form1" id="form1" method="post" action="timesheetprocess.cfm">
<input type="hidden" name="hidpno" id="hidpno" value="#form.pno#">
<input type="hidden" name="tsdates" id="tsdates" value="#form.tsdates#">
<input type="hidden" name="tsdatee" id="tsdatee" value="#form.tsdatee#">
<input type="hidden" name="nexmonth" id="nexmonth" value="#form.nexmonth#">
<input type="hidden" name="tyear" id="tyear" value="#form.tyear#">
<table border=0 cellpadding=0 cellspacing=0 width=735 style='border-collapse:
 collapse;table-layout:fixed;width:520pt'>
 <col width=40 span=3 style='width:40pt'>
 <col width=45 span=2 style='width:45pt'>
 <col width=80 span=2 style='width:80pt'>
  <col width=70 span=2 style='width:70pt'>
  <col width=50 span=1 style='width:50pt'>
 <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:140pt'>
 <col width=0 style='display:none;mso-width-source:userset;mso-width-alt:2340'>
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

 </tr>
 <!---edited by alvin on 30/12/2016
    <cfquery name="gettimesheet" datasource="#dsname#">
        SELECT * FROM timesheet 
        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
       <!--- and tmonth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nexmonth#"> --->
        and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> or placementno = "") 
        and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">  
        ORDER BY <!---tsrowcount---> pdate
    </cfquery>
  edited--->
  
   <!---edited by alvin on 18/01/2017--->
    <cfquery name="gettimesheet" datasource="#dsname#">
        SELECT * FROM 
            (
                SELECT * FROM timesheet 
                WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#"> 
                and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> or placementno = "") 
                and pdate between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#">  
                ORDER BY pdate
            ) AS sort
            GROUP by pdate	
    </cfquery>
  <!---edited--->
  
  
 <tr height=20 style='height:15.0pt'>
  <td colspan=7 height=20 class=xl1258828 style='border-right:1pt solid black;
  height:15.0pt;border-left:none'>#getplacementlist.empname#</td>
  <!---get ic from emp_data instead of getplacementlist, [2017/01/05, Alvin]--->
  <td colspan=7 class=xl1288828 width=128 style='border-left:none;width:96pt'>#emp_data.nricn#</td>
  <!---edited--->
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
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
  <td class=xl738828 style='border-top:none; display:none'>&nbsp;</td>
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
  width:96pt'>Day Type<!---Leave---><br><!---Changed leave to day type, [20170727, Alvin]--->
(Full Day/AM/PM)</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Start Time</td>
  <td class=xl838828 width=64 style='border-top:none;border-left:none;
  width:48pt'>End Time</td>
  <td class=xl868828 width=64 style='border-top:none;border-left:none;
  width:48pt'>Break(s)</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt'>OT</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt; display:none'>PH WORK</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt; display:none'>OT 2</td>
  <td class=xl878828 width=36 style='border-top:none;width:24pt; display:none'>OT 3</td>
  <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt; display:none'>Rest</td>
  <td colspan="2" class=xl878828 width=64 style='border-top:none;width:48pt; display:none'>PH</td>
  
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
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>Hour</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>1.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>2.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>1.0</td>
  <td class=xl858828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'>2.0</td>
  <td class=xl718828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td colspan=18 height=20 class=xl1298828 style='border-right:1pt solid black;border-left:1pt solid black;
  height:15.0pt'><cfif month(startdate) eq month(enddate)>#dateformat(startdate,'Mmm yyyy')#<cfelse>#dateformat(startdate,'Mmm yyyy')# to #dateformat(enddate,'Mmm yyyy')#</cfif>
    </td>
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
    placementno,ottable FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#">
    </cfquery>
    
    <cfquery name="getottable" datasource="#dts#">
    SELECT * FROM icsizeid WHERE trim(sizeid) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getplacementdetail.ottable)#">
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
    
    <!---added hidden input to hold working pattern to use it as default value, [20170727, Alvin]--->
    <input type="hidden" id="normalwh" value="#getottable.workh2#">
    <input type="hidden" id="normalstarthourtime" value="#left(getottable.starttime2, 2)#">
    <input type="hidden" id="normalstartminutetime" value="#right(getottable.starttime2, 2)#">
    <input type="hidden" id="normalendhourtime" value="#left(getottable.endtime2, 2)#">
    <input type="hidden" id="normalendminutetime" value="#right(getottable.endtime2, 2)#">
    <input type="hidden" id="normalbreak" value="#getottable.breakh2#">
    <!---added hidden input to hold working pattern to use it as default value--->
    <input type="hidden" name="totalrow" id="totalrow" value="#nonscount#">
    <input type="hidden" name="month" id="month" value="#company_details.mmonth#">
    <input type="hidden" name="placementno" id="placementno" value="#getplacementlist.placementno#">
    
        <cfloop from="0" to="#nonscount#" index="i">
			<cfset pholiday = 0>
            <cfset currentdate = dateadd('d','#i#',startdate)>
            
            <!---new query to take specific time, [20170120, Alvin]--->
            <cfquery name="GetSpecificTime" datasource="#dsname#">
                SELECT * FROM 
                    (
                        SELECT * FROM timesheet 
                        WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
                        and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> )
                        and pdate = '#dateformat(currentdate,'yyyy-mm-dd')#'
                        ORDER BY pdate
                    ) AS sort
                    GROUP by pdate	
            </cfquery>
            <!---new query--->
            
            <cfif #GetSpecificTime.recordcount# neq 0> <!---if data found for that specific date, replace it instead of using default value--->
            
                <input type="hidden" name="day#i#" id="day#i#" value="#dateformat(currentdate,'yyyy-mm-dd')#">
                
                <tr  onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';" height=20 style='height:15.0pt'>
                    <td height=20 class=xl948828 style='height:15.0pt;border-top:none'><cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>#dateformat(currentdate,'Mmm')#<cfset startmonth = dateformat(currentdate,'Mmm - yyyy')></cfif></td>
                    <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
                    <td class=xl928828 width=64 style='border-top:none;border-left:none;width:48pt'>#dateformat(currentdate,'dd')#</td>
                    
                    <td class=xl768828 style='border-top:none;border-left:none'>
                        <!---added javascript to change time in out to 00 when leave selected, [20170119, Alvin]--->
                        <select name="leavetype#i#" id="leavetype#i#" 
                        onChange="if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value && this.value == ''){
                        SetDefaultTime('startampm#i#', 'hr#i#', 'mina#i#', 'hre#i#', 'minae#i#', 'break#i#', 'remarks#i#');
                        document.getElementById('startampm#i#').style.display='none';
                        }
                        else if(this.value != 'PH' && this.value != '' && this.value != 'OD' && this.value != 'RD'){
                        document.getElementById('startampm#i#').style.display='block';document.getElementById('remarks#i#').value=this.options[this.selectedIndex].id
                        } 
                        else{
                        document.getElementById('startampm#i#').style.display='none';document.getElementById('remarks#i#').value='';
                        }
                        SetLeaveTime(this.value, 'startampm#i#', 'hr#i#', 'mina#i#', 'hre#i#', 'minae#i#', 'break#i#');makehour('#i#');">
                        <!---added javascript--->
                            <option value="">WD</option>
                            <cfloop from="1" to="#arraylen(leavearray)#" index="i2">
                                <option <cfif GetSpecificTime.stcol eq leavearray[i2]>Selected</cfif> value="#leavearray[i2]#" id="#leavedesparray[i2]#">#leavearray[i2]#</option>
                            </cfloop>
                        </select>
                    </td>
                    
                    <td class=xl768828 style='border-top:none;border-left:none'>
                    <select name="startampm#i#" id="startampm#i#" <cfif GetSpecificTime.stcol eq "" or GetSpecificTime.stcol eq "PH" or GetSpecificTime.stcol eq "OD" or GetSpecificTime.stcol eq "RD"> style="display:none"</cfif>>
                        <option value="FULL DAY" <cfif GetSpecificTime.ampm eq "FULL DAY">Selected</cfif>>FULL</option>
                        <option value="AM" <cfif GetSpecificTime.ampm eq "AM">Selected</cfif>>AM</option>
                        <option value="PM"<cfif GetSpecificTime.ampm eq "PM">Selected</cfif>>PM</option>
                    </select>
                    </td>
                    
                    <td class=xl778828 width=66 style='border-top:none;border-left:none;width:65pt' nowrap> 
                        <cfset hr = listfirst(GetSpecificTime.starttime,':')>
                        <cfset mina = listgetat(GetSpecificTime.starttime,2,':')>
                        <select class="inputTime" name="hr#i#" id="hr#i#" onChange="makehour('#i#');">
                            <cfloop from="0" to="23" index="aaa">
                                <option value="#numberformat(aaa,'00')#" <cfif hr eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                            </cfloop>
                        </select>
                        <select class="inputTime" name="mina#i#" id="mina#i#" onChange="makehour('#i#');">
                            <cfloop from="0" to="59" index="aaa">
                                <option value="#numberformat(aaa,'00')#" <cfif mina eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                            </cfloop>
                        </select>
                        <input type="hidden" name="timestart#i#" id="timestart#i#" value="#GetSpecificTime.starttime#">
                    </td>
                    
                    <td class=xl778828 width=64 style='border-top:none;border-left:none;width:65pt' nowrap>
                        <cfset hre = listfirst(GetSpecificTime.endtime,':')>
                        <cfset minae = listgetat(GetSpecificTime.endtime,2,':')>
                        <select class="inputTime" name="hre#i#" id="hre#i#" onChange="makehour('#i#');">
                            <cfloop from="0" to="23" index="aaa">
                                <option value="#numberformat(aaa,'00')#" <cfif hre eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                            </cfloop>
                        </select>
                        <select class="inputTime" name="minae#i#" id="minae#i#" onChange="makehour('#i#');">
                            <cfloop from="0" to="59" index="aaa">
                                <option value="#numberformat(aaa,'00')#" <cfif minae eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                            </cfloop>
                        </select>
                        <input type="hidden" name="timeoff#i#" id="timeoff#i#" value="#GetSpecificTime.endtime#">
                    </td>
                    
                    <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt'>
                        <select class="inputTime" name="break#i#" id="break#i#" onChange="makehour('#i#')">
                            <cfset timenow = createdatetime('2013','1','1','0','0','0')>
                            <cfloop from="0" to="105" index="a" step="15">
                                <option value="#a/60#" <cfif GetSpecificTime.breaktime eq a/60>selected</cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                            </cfloop>
                        </select>
                    </td>
                    
                    <td class=xl788828 width=64 style='border-top:none;border-left:none;width:48pt'>
                        <input type="text" name="totalhour#i#" id="totalhour#i#" value="#numberformat(GetSpecificTime.workhours,'.__')#" size="4" readonly >
                    </td>
                    
                    <cfset totalhour = totalhour + numberformat(GetSpecificTime.workhours,'.__')>
                    <cfset GetSpecificTime.othour = trim(ReReplaceNoCase(GetSpecificTime.othour,"[^0-9\.]","","ALL"))>
                    
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt'><input class="inputOT" type="text" name="ot#i#" id="ot#i#" value="#numberformat(GetSpecificTime.othour,'.__')#" size="4" onKeyUp="ottotal();" style="width:40px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot15#i#" id="ot15#i#" value="#numberformat(GetSpecificTime.ot15hour,'.__')#" size="3" onKeyUp="ot15total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot20#i#" id="ot20#i#" value="#numberformat(GetSpecificTime.ot2hour,'.__')#" size="3" onKeyUp="ot2total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot30#i#" id="ot30#i#" value="#numberformat(GetSpecificTime.ot3hour,'.__')#" size="3" onKeyUp="ot3total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otrd1#i#" id="otrd1#i#" value="#numberformat(GetSpecificTime.otrd1hour,'.__')#" size="3" onKeyUp="otrd1total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otrd2#i#" id="otrd2#i#" value="#numberformat(GetSpecificTime.otrd2hour,'.__')#" size="3" onKeyUp="otrd2total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otph1#i#" id="otph1#i#" value="#numberformat(GetSpecificTime.otph1hour,'.__')#" size="3" onKeyUp="otph1total();" style="width:32px" ></td>
                    <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otph2#i#" id="otph2#i#" value="#numberformat(GetSpecificTime.otph2hour,'.__')#" size="3" onKeyUp="otph2total();" style="width:32px" ></td>
                    
                    <cfset totalot = totalot + numberformat(GetSpecificTime.othour,'.__')>
                    <cfset totalot15 = totalot15 + numberformat(GetSpecificTime.ot15hour,'.__')>
                    <cfset totalot2 = totalot2 + numberformat(GetSpecificTime.ot2hour,'.__')>
                    <cfset totalot3 = totalot3 + numberformat(GetSpecificTime.ot3hour,'.__')>
                    <cfset totalotrd1 = totalotrd1 + numberformat(GetSpecificTime.otrd1hour,'.__')>
                    <cfset totalotrd2 = totalotrd2 + numberformat(GetSpecificTime.otrd2hour,'.__')>
                    <cfset totalotph1 = totalotph1 + numberformat(GetSpecificTime.otph1hour,'.__')>
                    <cfset totalotph2 = totalotph2 + numberformat(GetSpecificTime.otph2hour,'.__')>
                    
                    <td class=xl758828 style='border-top:none;border-left:none'>
                        <input type="text" name="remarks#i#" id="remarks#i#" value="#GetSpecificTime.remarks#" size="20" maxlength="40">
                    </td>
                    
                    <td class=xl158828></td>
                    <td class=xl158828></td>
                </tr>
                
            <cfelse> <!---data not found, replace it with default value--->
            
                <cfif holidaylist neq "">
                    <cfif listfind(holidaylist,dateformat(currentdate,'dd/mm/yyyy')) neq 0>
                        <cfset pholiday = 1>
                    </cfif>
                </cfif>
                
                <cfquery name="getLeave" datasource="#dts#">
                    SELECT * from leavelist
                    WHERE placementno = '#form.pno#'
                    AND status = "APPROVED"
                    AND "#dateformat(currentdate, 'yyyy-mm-dd')#"
                    BETWEEN startdate AND enddate
                </cfquery>
                
            
            <input type="hidden" name="day#i#" id="day#i#" value="#dateformat(currentdate,'yyyy-mm-dd')#">
            <input type="hidden" name="halfday#i#" id="halfday#i#" value="<cfif listfind(halfdaylist,DayOfWeek(currentdate)) neq 0>Y<cfelse>N</cfif>">
            <input type="hidden" name="placementno" id="placementno" value="#getplacementlist.placementno#">
            <tr  onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='f3bd90';" height=20 style='height:15.0pt'>
                <td height=20 class=xl948828 style='height:15.0pt;border-top:none'>
                    <cfif startmonth neq dateformat(currentdate,'Mmm - yyyy')>#dateformat(currentdate,'Mmm - yy')#<cfset startmonth = dateformat(currentdate,'Mmm - yyyy')></cfif>
                </td>
                
                <td class=xl938828 style='border-top:none'>#dateformat(currentdate,'Ddd')#</td>
                <td class=xl928828 width=64 style='border-top:none;border-left:none;width:48pt'>#dateformat(currentdate,'dd')#</td>
                
                <cfset daytype = evaluate('getottable.daytype#DayOfWeek(currentdate)#')>
                <td class=xl768828 style='border-top:none;border-left:none'>
                    <!---added javascript to set time in out to 00 when leave selected, [2017/01/19, Alvin]--->
                    <select name="leavetype#i#" id="leavetype#i#" 
                    onChange="if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value && this.value == ''){
                    SetDefaultTime('startampm#i#', 'hr#i#', 'mina#i#', 'hre#i#', 'minae#i#', 'break#i#', 'remarks#i#');a;
					}
                    else if(this.value != 'PH' && this.value != '' && this.value != 'OD' && this.value != 'RD'){
                    document.getElementById('startampm#i#').style.display='block';document.getElementById('remarks#i#').value=this.options[this.selectedIndex].id
                    } 
                    else{
                    document.getElementById('startampm#i#').style.display='none';document.getElementById('remarks#i#').value='';
                    }
                    SetLeaveTime(this.value, 'startampm#i#', 'hr#i#', 'mina#i#', 'hre#i#', 'minae#i#', 'break#i#');makehour('#i#');">
                    <!---added javascript--->
                        <option value="">WD</option>
                        <cfloop from="1" to="#arraylen(leavearray)#" index="ii">
                            <option <cfif #getLeave.recordcount# neq 0> <cfif '#getLeave.leavetype#' eq '#leavearray[ii]#'>Selected </cfif><cfelseif pholiday eq 1 and leavearray[ii] eq "PH">Selected<cfelseif daytype eq leavearray[ii]>Selected</cfif> value="#leavearray[ii]#" id="#leavedesparray[ii]#">#leavearray[ii]#</option>
                        </cfloop>
                    <!---         </cfif> --->
                    </select>
                </td>
                
                <td class=xl768828 style='border-top:none;border-left:none'> 
                    <select name="startampm#i#" id="startampm#i#" <cfif #getLeave.recordcount# neq 0 AND #getLeave.leavetype# neq 'WD' AND #getLeave.leavetype# neq 'OD' AND #getLeave.leavetype# neq 'RD' AND #getLeave.leavetype# neq 'PH'> style="display:block" <cfelse>style="display:none" </cfif> >
                        <cfif #getLeave.recordcount# eq 0>
                            <option value="FULL DAY">FULL</option>
                            <option value="AM">AM</option>
                            <option value="PM">PM</option>
                        <cfelseif (#getLeave.startampm# eq '00:00') AND (#getLeave.endampm# eq '00:00')>
                        	<option value="FULL DAY" selected>FULL</option>
                            <option value="AM">AM</option>
                            <option value="PM">PM</option>
						<cfelseif left(#getLeave.endampm#, 2) gte 12>
                            <option value="FULL DAY">FULL</option>
                            <option value="AM">AM</option>
                            <option value="PM" selected>PM</option>
                        <cfelseif left(#getLeave.endampm#, 2) lt 12>
                            <option value="FULL DAY">FULL</option>
                            <option value="AM" selected>AM</option>
                            <option value="PM">PM</option>
                        </cfif>
                    </select>
                </td>
                
                <td class=xl778828 width=66 style='border-top:none;border-left:none;width:65pt' nowrap> 
                    <cfif evaluate('getottable.starttime#DayOfWeek(currentdate)#') eq "">
                        <cfset "getottable.starttime#DayOfWeek(currentdate)#" = "00:00:00">
                    </cfif>
                    <cfif #getLeave.recordcount# neq 0>
						<cfset hr = left(#getLeave.startampm#, 2)>
                        <cfset mina = right(#getLeave.startampm#, 2)>
                    <cfelseif pholiday neq 1 >
                        <cfif getottable.recordcount neq 0>
                            <cfset hr = listfirst(evaluate('getottable.starttime#DayOfWeek(currentdate)#'),':')>
                            <cfset mina = listgetat(evaluate('getottable.starttime#DayOfWeek(currentdate)#'),2,':')>
                        <cfelse>
                            <cfset hr = "09">
                            <cfset mina = "00">
                        </cfif>
                    <cfelse>
                        <cfset hr = "00">
                        <cfset mina = "00">
                    </cfif>
                    <select class="inputTime" name="hr#i#" id="hr#i#" onChange="makehour('#i#');">
                        <cfloop from="0" to="23" index="aaa">
                            <option value="#numberformat(aaa,'00')#" <cfif hr eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                        </cfloop>
                    </select>
                    <select class="inputTime" name="mina#i#" id="mina#i#" onChange="makehour('#i#');">
                        <cfloop from="0" to="59" index="aaa">
                            <option value="#numberformat(aaa,'00')#" <cfif mina eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                        </cfloop>
                    </select>
                    <input type="hidden" name="timestart#i#" id="timestart#i#" value="#evaluate('getottable.starttime#DayOfWeek(currentdate)#')#">
                </td>
                
                <cfif evaluate('getottable.endtime#DayOfWeek(currentdate)#') eq "">
                    <cfset "getottable.endtime#DayOfWeek(currentdate)#" = "00:00:00">
                </cfif>
                
                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:65pt' nowrap>
                    <cfif #getLeave.recordcount# neq 0>
                    	<cfset hre = left(#getLeave.endampm#, 2)>
                        <cfset minae = right(#getLeave.endampm#, 2)>
					<cfelseif pholiday neq 1 >
                        <cfset hre = listfirst(evaluate('getottable.endtime#DayOfWeek(currentdate)#'),':')>
                        <cfif getottable.recordcount neq 0>
                            <cfset minae = listgetat(evaluate('getottable.endtime#DayOfWeek(currentdate)#'),2,':')>
                        <cfelse>
                            <cfset hre = "17">
                            <cfset minae = "00">
                        </cfif>
                    <!--- <cfif pholiday neq 1 > --->
                    <cfelse>
                        <cfset hre = "00">
                        <cfset minae = "00">
                    </cfif>
                    <select class="inputTime" name="hre#i#" id="hre#i#" onChange="makehour('#i#');">
                    <cfloop from="0" to="23" index="aaa">
                        <option value="#numberformat(aaa,'00')#" <cfif hre eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                    </cfloop>
                    </select>
                    <select class="inputTime" name="minae#i#" id="minae#i#" onChange="makehour('#i#');">
                    <cfloop from="0" to="59" index="aaa">
                        <option value="#numberformat(aaa,'00')#" <cfif minae eq numberformat(aaa,'00')>Selected</cfif>>#numberformat(aaa,'00')#</option>
                    </cfloop>
                    </select>
                    <input type="hidden" name="timeoff#i#" id="timeoff#i#" value="#evaluate('getottable.endtime#DayOfWeek(currentdate)#')#">
                </td>
                
                <td class=xl778828 width=64 style='border-top:none;border-left:none;width:48pt'>
                    <select class="inputTime" name="break#i#" id="break#i#" onChange="makehour('#i#');">
                        <cfset timenow = createdatetime('2013','1','1','0','0','0')>
                        <cfloop from="0" to="105" index="a" step="15">
                            <option value="#a/60#" <cfif #getLeave.recordcount# neq 0><cfif a/60 eq 0>Selected</cfif><cfelseif pholiday neq 1 ><cfif numberformat(evaluate('getottable.breakh#DayOfWeek(currentdate)#'),'.__') eq a/60>Selected</cfif></cfif>>#timeformat(dateadd('n',a,timenow),'HH:MM')#</option>
                        </cfloop>
                    </select>
                </td>
                   
                <td class=xl788828 width=64 style='border-top:none;border-left:none;width:48pt'>
                    <input type="text" name="totalhour#i#" id="totalhour#i#" value="<cfif pholiday neq 1 >#numberformat(evaluate('getottable.workh#DayOfWeek(currentdate)#'),'.__')#<cfelse>0.00</cfif>" size="4" readonly >
                </td>
                
                <cfset totalhour = totalhour + numberformat(evaluate('getottable.workh#DayOfWeek(currentdate)#'),'.__')>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt'><input class="inputOT" type="text" name="ot#i#" id="ot#i#" value="0.00" size="4"  onKeyUp="ottotal();" style="width:40px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot15#i#" id="ot15#i#" value="0.00" size="3"  onKeyUp="ot15total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot20#i#" id="ot20#i#" value="0.00" size="3"  onKeyUp="ot2total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="ot30#i#" id="ot30#i#" value="0.00" size="3"  onKeyUp="ot3total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otrd1#i#" id="otrd1#i#" value="0.00" size="3"  onKeyUp="otrd1total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otrd2#i#" id="otrd2#i#" value="0.00" size="3"  onKeyUp="otrd2total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otph1#i#" id="otph1#i#" value="0.00" size="3"  onKeyUp="otph1total();" style="width:32px"></td>
                <td class=xl798828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="otph2#i#" id="otph2#i#" value="0.00" size="3"  onKeyUp="otph2total();" style="width:32px"></td>
                
                <cfif pholiday eq "1">
                    <cfset phdesp = "">
                    <cfloop from="1" to="30" index="cc">
                        <cfif evaluate('getottable.phdate#cc#') neq "0000-00-00">
                            <cfif evaluate('getottable.phdate#cc#') eq currentdate>
                                <cfset phdesp = evaluate('getottable.phdesp#cc#')>
                                <cfbreak>
                            </cfif>
                        </cfif>
                    </cfloop>
                
                    <cfquery name="getholidaydesp" datasource="#dsname#">
                    SELECT hol_desp FROM holtable WHERE 
                    hol_date = "#dateformat(currentdate,'yyyy-mm-dd')#"
                    </cfquery>
                </cfif>
                
                <td class=xl758828 style='border-top:none;border-left:none'><input type="text" name="remarks#i#" id="remarks#i#" <cfif pholiday eq "1">value="#phdesp#"</cfif> maxlength="40"  size="20"></td>
                <td class=xl158828></td>
                <td class=xl158828></td>
            </tr>
            
            <!---to calculate hour worked if no record found--->
            <script type="application/javascript">
				setTimeout(function(){  
					makehour(#i#);
				}, 1000);
			</script>
            <!---calculate--->
          
            </cfif>
            
        </cfloop>
        <!---comment out to prevent recalculate after generating timesheet, [20170207, Alvin]--->
        <!---<script type="application/javascript">
        setTimeout(function(){  
		for(var i = 1;i<=#val(nonscount)#;i++)
		{
			makehour(i);
		}
        }, 1000);
		</script>--->
        <!---comment out--->

 
 <tr >
  <td colspan=8 height=20 class=xl1158828 width=448 style='border-right:1pt solid black;border-left:1pt solid black; border-bottom:1pt solid black;
 '>Total hours<!---  for the period (exclude breaks) ---></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt'><input type="text" name="totalhour" id="totalhour" value="#numberformat(totalhour,'.__')#" size="4" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt'><input type="text" name="totalot" id="totalot" style="width:40px" value="#numberformat(totalot,'.__')#" size="4" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalot15" id="totalot15" style="width:32px" value="#numberformat(totalot,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalot2" id="totalot2" style="width:32px" value="#numberformat(totalot2,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalot3" id="totalot3" style="width:32px" value="#numberformat(totalot3,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalotrd1" id="totalotrd1" style="width:32px" value="#numberformat(totalotrd1,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalotrd2" id="totalotrd2" style="width:32px" value="#numberformat(totalotrd2,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalotph1" id="totalotph1" style="width:32px" value="#numberformat(totalotph1,'.__')#" size="3" ></td>
  <td class=xl808828 width=36 style='border-top:none;border-left:none; width:26pt; display:none'><input type="text" name="totalotph2" id="totalotph2" style="width:32px" value="#numberformat(totalotph2,'.__')#" size="3" ></td>
  <td class=xl708828 width=157 style='border-top:none;border-left:none;
  width:118pt'>&nbsp;</td>
  <td class=xl158828></td>
  <td class=xl158828></td>
 </tr>
 
	 <!---new query to take specific time, [20170120, Alvin]--->
    <cfquery name="GetAllStatus" datasource="#dsname#">
        SELECT status, editable FROM 
            (
                SELECT * FROM timesheet 
                WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
                and (placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacementlist.placementno#"> )
                and pdate BETWEEN <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdates#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tsdatee#"> 
                ORDER BY pdate
            ) AS sort
            GROUP by pdate	
    </cfquery>
    <!---new query--->
    <cfset submittedStatus = FALSE>
    <cfset editableStatus = FALSE>
    <cfset submittedCount = 0>
    <cfset editableCount = 0>
    
    <cfif #GetAllStatus.recordcount# neq val('#nonscount#')>
    	<cfloop query="GetAllStatus">
        	<cfif #GetAllStatus.status# eq 'Submitted For Approval'>
            	<cfset submittedCount += 1>
            </cfif>
            <cfif #GetAllStatus.editable# eq 'N'>
            	<cfset editableCount += 1>
            </cfif>
        </cfloop>
    </cfif>
    
    <cfif val('#submittedCount#') eq (val('#nonscount#') + 1)>
    	<cfset submittedStatus = TRUE>												<!---submitted, waiting for approval--->
    </cfif>
    
    <cfif val('#editableCount#') eq (val('#nonscount#') + 1)>
    	<cfset editableStatus = TRUE>												<!---if not editable, approved--->
    </cfif>
    
 <tr>
  <td class=xl158828 align="center" colspan="18"><input type="button" name="save" id="save" onClick="
                    <cfif (#submittedStatus# eq True) OR (#editableStatus# eq TRUE)>alert('Timesheet Has Been Submitted, No Update is Allowed')
                    <cfelse>enableInputTime();savebtn();this.disabled = true;
                    </cfif>" value="Save">
        <input type="button" name="sub_btn" id="sub_btn" onClick="
                    <cfif (#submittedStatus# eq True) OR (#editableStatus# eq TRUE)>
                    alert('Timesheet Has Been Submitted, No Update is Allowed')
                    <cfelse>
                       <!--- if(document.getElementById('custno').value == document.getElementById('exceptioncustno').value && document.getElementById('exceptionFlag').value == 0){
                            alert('We are in the midst of updating your leave. You will be able to submit your timesheet once the update is done.');
                        } 
                        else{--->
                            enableInputTime();document.getElementById('form1').submit();this.disabled = true;
                        <!---}---> 
                    </cfif>" value="Submit">
        <input type="button" name="print_btn" id="print_btn" value="Print" onClick="window.print();">
  </td>
    
 </tr>
</table>
</form>
</div>


<!----------------------------->
<!--END OF OUTPUT FROM EXCEL PUBLISH AS WEB PAGE WIZARD-->
<!----------------------------->
</body>

</html>

</cfoutput>