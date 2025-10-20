<cfset dts = dsname>
<cfquery name="getempno" datasource="#dts#">
SELECT empno FROM emp_users WHERE
username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<cfquery name="getempdetails" datasource="#dts#">
SELECT * FROM pmast WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
</cfquery>

<cfif getempdetails.recordcount eq 0>
<cfoutput>
<h1>Please kindly contact system administrator</h1>
</cfoutput>
<cfabort>
</cfif>

<cfoutput>
<cfheader name="expires" value="#GetHttpTimeString(Now())#">
<cfheader name="pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">

<script src="/javascripts/CalendarControl.js" type="text/javascript"></script>
<script type="text/javascript" src="/javascripts/prototypenew.js" ></script>
<script src="/EFORM/CalendarControlmp.js" language="javascript"></script>
<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script>
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<script src="/eleave/js/tabber.js" type="text/javascript"></script>
<script type="text/javascript">
function applyleavedatecheck2()
{
				var datef = document.getElementById('startdate').value;
				var datet = document.getElementById('enddate').value;
				var datefday = datef.substring(0,2) * 1;
				var datetday = datet.substring(0,2) * 1;
				var datefmonth = datef.substring(3,5) * 1;
				var datetmonth = datet.substring(3,5) * 1;
				var datefyear = datef.substring(6,10) * 1;
				var datetyear = datet.substring(6,10) * 1;

				if(datefyear > datetyear)
				{
				 alert("Start Date Should Be Earlier Than End Date");
				 return false;
				}
				else if( datefmonth > datetmonth && datefyear == datetyear)
				{
				 alert("Start Date Should Be Earlier Than End Date");
				 return false;
				}
				else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
				{
				 alert("Start Date Should Be Earlier Than End Date");
				 return false;
				}
				else{
					return true;
				}
}


function trim(strval)
	{
	return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}

function addleave(id,atype)
{
	if(atype == 'delete')
	{
		var addleaveurl = 'leaveajax.cfm?action=delete&id='+id;
	}
	else if(atype == 'add')
	{

		var getleavetype = escape(document.getElementById('leavetype').value);
		var getstartdate = escape(document.getElementById('startdate').value);
		var getstartampm = escape(document.getElementById('startampm').value);
		var getenddate = escape(document.getElementById('enddate').value);
		var getendampm = escape(document.getElementById('endampm').value);
		var getleavedays = escape(document.getElementById('leavedays').value);
		var getremarks= escape(document.getElementById('remarks').value);

		var addleaveurl = 'leaveajax.cfm?action=add&leavetype='+getleavetype+'&startdate='+getstartdate+'&startampm='+getstartampm+'&enddate='+getenddate+'&endampm='+getendampm+'&leavedays='+getleavedays+'&remarks='+getremarks;
		var msg = '';

		if(trim(getstartdate) == '')
		{
			msg = msg + 'Start Date is Required\n';
		}
		if(trim(getenddate) == '')
		{
			msg = msg + 'End Date is Required\n';
		}
		if(parseFloat(trim(getleavedays)) == 0.00)
		{
			msg = msg + 'Leave Taken Should Not Be Zero\n';
		}
		if(msg == '')
		{

				if(applyleavedatecheck2())
				{

				}
				else
				{
					return false;
				}
		}
		else
		{
			alert(msg);
			return false;
		}

	}

	new Ajax.Request(addleaveurl,
			{
				method:'get',
				onSuccess: function(getdetailback){
					document.getElementById('leavelist').innerHTML = trim(getdetailback.responseText);
				},
				onFailure: function(response){
					alert(response.statusText); },

				onComplete: function(transport){
					 try{
						alert(document.getElementById('alerttext').value);
					}
					catch(err)
					{
					}

				}
			})
}

function dateajaxfunction()
{
	var datef = document.getElementById('startdate').value;
	var datet = document.getElementById('enddate').value;
	var startampmval = document.getElementById('startampm').value;
	var endampmval = document.getElementById('endampm').value;
	var getleavetype = document.getElementById('leavetype').value;

	if(datef == datet && startampmval !=endampmval && datef != '' && datet != '')
	{
		alert('If Start date date is the same as end date, there should not be different AM / PM sessions');
		return false;
	}
	if(datef != '' && datet != '')
	{
	var placementno = document.getElementById('placementno').value;
	var leavedaysvar = document.getElementById('leavedays');
	var getleeavedaysurl = 'leavedays.cfm?datefrom='+escape(datef)+'&dateto='+escape(datet)+'&placementno='+placementno+'&startampm='+startampmval+'&endampm='+endampmval+'&leavetype='+getleavetype;
		new Ajax.Request(getleeavedaysurl,
			{
				method:'get',
				onSuccess: function(getdetailback){
					document.getElementById('ldayscal').innerHTML = trim(getdetailback.responseText);
				},
				onFailure: function(response){
					alert(response.statusText); },

				onComplete: function(transport){
					leavedaysvar.value = document.getElementById('newleavedays').value;
				}
			})

	}
}
</script>
<link href="/eleave/js/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
<cfform name="eform" id="eform" method="post" action="process.cfm"  enctype="multipart/form-data">
<div class="tabber">
			<div class="tabbertab">
				<h3>Personal Information</h3>
                <table>
                <tr>
                <th>Name*</th>
                <td>:</td>
                <td><cfinput type="text" name="name" id="name" value="#getempdetails.name#" maxlength="200" size="70" required="yes" message="Name is Required!"></td>
                </tr>
                <tr>
                <th>Address*</th>
                <td>:</td>
                <td><cfinput type="text" name="add1" id="add1" value="#getempdetails.add1#" maxlength="200" size="70" required="yes" message="Address is Required!"></td>
                </tr>
                <tr>
                <th></th>
                <td>:</td>
                <td><cfinput type="text" name="add2" id="add2" value="#getempdetails.add2#" maxlength="200" size="70"></td>
                </tr>
                 <tr>
                <th>Date of Birth*</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="dbirth" id="dbirth" value="#dateformat(getempdetails.dbirth,'dd/mm/yyyy')#" maxlength="10" required="yes" message="Date of Birth is Required!" validate="eurodate" validateat="onsubmit">&nbsp;&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dbirth'));">&nbsp;(dd/mm/yyyy)
                </td>
                </tr>
                <tr>
                <th>Gender</th>
                <td>:</td>
                <td><select name="sex" id="sex">
								<option value="M" <cfif getempdetails.sex eq "M">Selected</cfif>>Male</option>
								<option value="F" <cfif getempdetails.sex eq "F">Selected</cfif>>Female</option>
								</select></td>
                </tr>
                <cfquery name="race_qry" datasource="#dts#">
					SELECT *
					FROM race
					ORDER BY racedesp
				</cfquery>
                <tr>
                <th>Race</th>
                <td>:</td>
                <td><select name="race" id="race">
								<cfloop query="race_qry"><option value="#race_qry.racecode#" <cfif getempdetails.race eq race_qry.racecode>Selected</cfif>>#race_qry.racedesp#</option></cfloop>
								</select></td>
                </tr>

                <cfquery name="country_qry" datasource="payroll_main">
					SELECT *
					FROM councode
					ORDER BY cname
				</cfquery>
                <tr>
                <th>Country of Origin</th>
                <td>:</td>
                <td><select id="Country_Code_address" name="Country_Code_address" >
					<cfloop query="country_qry">
						<option value="#country_qry.ccode#" <cfif getempdetails.Country_Code_address eq country_qry.ccode> selected</cfif>>#country_qry.ccode# - #country_qry.cname#</option>
					</cfloop>
					</select></td>
                </tr>
                <tr>
                <th>Contact No*</th>
                <td>:</td>
                <td>
                <cfinput type="text" name="phone" id="phone" value="#getempdetails.phone#" maxlength="50" size="70" required="yes" message="Contact is Required!">
                </td>
                </tr>
                <tr>
                <th>Personal Email*</th>
                <td>:</td>
                <td>
                <cfinput type="text" name="email" id="email" value="#getempdetails.email#" maxlength="250" size="70" required="yes" message="Personal Email is Invalid / Required!" validate="email" validateat="onsubmit">
                </td>
                </tr>
                <tr>
                <th>Work Email*</th>
                <td>:</td>
                <td>
                <cfinput type="text" name="workemail" id="workemail" value="#getempdetails.workemail#" maxlength="250" size="70" required="yes" message="Work Email is Invalid / Required!" validate="email" validateat="onsubmit">
                </td>
                </tr>
                <tr>
                <th>Marital Status</th>
                <td>:</td>
                <td>
                <select name="mstatus" id="mstatus">
						<option value="S" <cfif getempdetails.mstatus eq "S">Selected</cfif>>Single</option>
						<option value="M" <cfif getempdetails.mstatus eq "M">Selected</cfif>>Married</option>
						<option value="O" <cfif getempdetails.mstatus eq "O">Selected</cfif>>Other</option>
					</select>
                </td>
                </tr>
                 <tr>
                <th>Passport No / IC No*</th>
                <td>:</td>
                <td>
				<cfif #getempdetails.nricn# neq "">
              		<cfinput type="text" name="nricn" id="nricn" value="#getempdetails.nricn#" maxlength="22" size="70" required="yes" message="Passport No / IC No is Required!">
                <cfelseif #getempdetails.passport# neq "">
					<cfinput type="text" name="nricn" id="nricn" value="#getempdetails.passport#" maxlength="22" size="70" required="yes" message="Passport No / IC No is Required!">
				<cfelse>
					<cfinput type="text" name="nricn" id="nricn" value="" maxlength="22" size="70" required="yes" message="Passport No / IC No is Required!">
				</cfif>
				</td>
                </tr>
                <tr>
                <th>Passport Expiring Date</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="passprt_to" id="passprt_to" value="#dateformat(getempdetails.passprt_to,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" validateat="onsubmit" message="Passport Expiring Date is Invalid" readonly="readonly">&nbsp;&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('passprt_to'));">&nbsp;(dd/mm/yyyy)
                </td>
                </tr>
                <tr>
                <th>Second Passport</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="passport" id="passport" value="#getempdetails.passport#" maxlength="12" size="70">
                </td>
                </tr>
                <tr>
                <th>Highest Education</th>
                <td>:</td>
                <td>
                <cfset edulist = "Primary,Secondary,Diploma,Degree,Master,PHD">
                   <select name="edu" id="edu">
                   <cfloop list="#edulist#" index="a">
                   <option value="#a#" <cfif a eq getempdetails.edu>Selected</cfif>>#a#</option>
                   </cfloop>
					</select>
                </td>
                </tr>
                <tr>
                <th>Nationality</th>
                <td>:</td>
                <td><select id="national" name="national">
					<cfloop query="country_qry">
						<option value="#country_qry.ccode#" <cfif getempdetails.national eq country_qry.ccode >Selected</cfif>>#country_qry.ccode# - #country_qry.cname#</option>
					</cfloop>
					</select></td>
                </tr>

                  <tr>
                <th>Emergency Contact Person*</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="econtact" id="econtact" value="#getempdetails.econtact#" maxlength="150" size="70" required="yes" message="Emergency Contact Person is Required!">
                </td>
                </tr>
                <tr>
                <th>Emergency Contact No*</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="etelno" id="etelno" value="#getempdetails.etelno#" maxlength="24" size="70" required="yes" message="Emergenct Contact No is Required!">
                </td>
                </tr>
                <tr>
                <th>Address of Original Country</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="eadd1" id="eadd1" value="#getempdetails.eadd1#" maxlength="150" size="70">
                </td>
                </tr>
                <tr>
                <th></th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="eadd2" id="eadd2" value="#getempdetails.eadd2#" maxlength="150" size="70">
                </td>
                </tr>



                </table>
            </div>
            <div class="tabbertab">
				<h3>Tax Information</h3>

                <table>
                <tr>
                <th>Tax No</th>
                <td>:</td>
                <td>
                <!---added required field, [20170106, Alvin]--->
                   <cfinput type="text" name="itaxno" id="itaxno" value="#getempdetails.itaxno#" maxlength="20" size="70" > <!---required="yes" message="Tax No is required!"--->
                <!---required field--->
                </td>
                </tr>
                <tr>
                <th>Tax Branch</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="itaxbran" id="itaxbran" value="#getempdetails.itaxbran#" maxlength="15" size="70">
                </td>
                </tr>
                <tr>
                <th>Spouse Working</th>
                <td>:</td>
                <td>

                <select name="spousework" id="spousework" onChange="if(this.value == 'Y'){document.getElementById('s1').style.display='none';document.getElementById('s2').style.display='none';document.getElementById('s3').style.display='none';}else{document.getElementById('s1').style.display='';document.getElementById('s2').style.display='';document.getElementById('s3').style.display='';}">
                <option value="Y">Yes</option>
                <option value="N"  <cfif getempdetails.sname neq "">Selected</cfif>>No</option>
                </select>
                </td>
                </tr>
               <tr id="s1" <cfif getempdetails.sname eq ""> style="display:none"</cfif>>
                <th>Spouse Name</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="sname" id="sname" value="#getempdetails.sname#" maxlength="30" size="70">
                </td>
                <td> **Please leave spouse information blank if spouse is working </td>
                </tr>
                <tr id="s2" <cfif getempdetails.sname eq ""> style="display:none"</cfif>>
                <th>Spouse IC No</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="snric" id="snric" value="#getempdetails.snric#" maxlength="22" size="70">
                </td>
                <td> **Please leave spouse information blank if spouse is working </td>
                </tr>
                <tr id="s3" <cfif getempdetails.sname eq ""> style="display:none"</cfif>>
                <th>Spouse Disable</th>
                <td>:</td>
                <td>
                   <select name="sdisble" id="sdisble">
                    <option value="N" #IIF(getempdetails.sdisble eq "N",DE('selected'),DE(''))#>No</option>
                    <option value="Y" #IIF(getempdetails.sdisble eq "Y",DE('selected'),DE(''))#>Yes</option>
                    </select>
                </td>
                </tr>
				<cfif getempdetails.sex eq "F">
                <tr>
                <th colspan="100%">
				<div align="center" <cfif getempdetails.sex eq "F"> <cfif getempdetails.numchild neq 0> style="display:none" <cfelse></cfif> </cfif>>
                <input type="button" name="confirmrelief" id="confirmrelief" value="Confirm Child Not Relief on Husband" onClick="if(confirm('Are You Confirm Child Not Relief on Husband?')){document.getElementById('childrelief').style.display='block';}">
                </div>
                </th>
                </tr>
                </cfif>
				<tr>
                <td colspan="100%">
                <div id="childrelief" <cfif getempdetails.sex eq "F"> <cfif getempdetails.numchild neq 0> <cfelse>style="display:none"</cfif> </cfif>>
                <table>
                <tr>
                <th>## Total Number Of Child</th>
                <td>:</td>
                <td>
                <cfinput type="text" name="numchild" id="numchild" value="#val(getempdetails.numchild)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                 <tr>
                <th>## Child Below 18</th>
                <td>:</td>
                 <td>
                <cfinput type="text" name="num_child" id="num_child" value="#val(getempdetails.num_child)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                <tr>
                <th>## Child Study Above 18 <br>("A-Level", certificate, matriculation or preparatory courses)</th>
                <td>:</td>
                 <td>
                <cfinput type="text" name="child_edu_m" id="child_edu_m" value="#val(getempdetails.child_edu_m)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                <tr>
                <th>## Child Study Diploma Above</th>
                <td>:</td>
                 <td>
                <cfinput type="text" name="child_edu_f" id="child_edu_f" value="#val(getempdetails.child_edu_f)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                <tr>
                <th>## Disabled Child</th>
                <td>:</td>
                 <td>
                <cfinput type="text" name="child_disable" id="child_disable" value="#val(getempdetails.child_disable)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                 <tr>
                <th>## Disabled Child Study</th>
                <td>:</td>
                <td>
                <cfinput type="text" name="child_edu_disable" id="child_edu_disable" value="#val(getempdetails.child_edu_disable)#" size="2" maxlength="2" validate="integer" validateat="onsubmit" />
                </td>
                </tr>
                </table>
                </div>
                </td>
                </tr>

                </table>

            </div>
             <div class="tabbertab">
				<h3>Other Information</h3>
                <table>
                <tr>
                <th>EPF No*</th>
                <td>:</td>
                <td>
                <!---added required field, [20170106, Alvin]--->
				<cfif getempdetails.national eq 'MY'>
                   <cfinput type="text" name="epfno" id="epfno" value="#getempdetails.epfno#" maxlength="12" size="70" required="yes" message="EPF is Required for Local Worker!">
                <cfelse>
                   <cfinput type="text" name="epfno" id="epfno" value="#getempdetails.epfno#" maxlength="12" size="70">
                </cfif>
                <!---required field--->
                </td>
                </tr>
                <tr>
                <th>Country Public Holiday Observe</th>
                <td>:</td>
                <td>
              	<cfselect id="PBholiday" name="PBholiday" >
					<cfloop query="country_qry">
						<option value="#country_qry.ccode#" <cfif getempdetails.PBholiday eq country_qry.ccode> selected</cfif>>#country_qry.ccode# - #country_qry.cname#</option>
					</cfloop>
					</cfselect>
                </td>
                </tr>
                <tr>
                <th>Country Serve</th>
                <td>:</td>
                <td>
              	<cfselect id="countryserve" name="countryserve">
					<cfloop query="country_qry">
						<option value="#country_qry.ccode#" <cfif getempdetails.countryserve eq country_qry.ccode> selected</cfif>>#country_qry.ccode# - #country_qry.cname#</option>
					</cfloop>
					</cfselect>
                </td>
                </tr>
                <cfquery name="getplacement" datasource="#replace(dts,'_p','_i')#">
                SELECT hrmgr,department,position,placementno FROM placement
                WHERE
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> ORDER BY completedate desc limit 1
                </cfquery>
                <input type="hidden" name="placementno" id="placementno" value="#getplacement.placementno#">
                <cfif getplacement.hrmgr neq "">
                <cfquery name="gethmdetails" datasource="payroll_main">
                SELECT username, userid FROM 
                <cfif #dsname# contains 'test'>
                	hmuserstest
                <cfelse>
                	hmusers 
                </cfif>
                WHERE entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacement.hrmgr#">
                </cfquery>
                <cfset hmname = gethmdetails.username>
                <cfset hmemail = gethmdetails.userid>
                <cfelse>
                <cfset hmname = "">
                <cfset hmemail = "">
				</cfif>
                <tr>
                <th>Hiring Manager Name*</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="hmname" id="hmname" value="#hmname#" maxlength="50" size="70" required="yes" message="Hiring Manager Name is Required!">
                </td>
                </tr>
                <tr>
                <th>Hiring Manager Email*</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="hmemail" id="hmemail" value="#hmemail#" maxlength="50" size="70" validate="email" validateat="onsubmit" required="yes" message="Hiring Manager Email is Invalid / Required!">
                </td>
                </tr>
                <tr>
                <th>Employment Pass No</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="wpermit" id="wpermit" value="#getempdetails.wpermit#" maxlength="20" size="70">
                </td>
                </tr>
                <tr>
                <th>Employment Pass Valid From</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="wp_from" id="wp_from" value="#dateformat(getempdetails.wp_from,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" validateat="onsubmit" message="Employment Pass Valid From is Invalid" readonly="readonly">&nbsp;&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('wp_from'));">&nbsp;(dd/mm/yyyy)
                </td>
                </tr>
                <tr>
                <th>Employment Pass Valid To</th>
                <td>:</td>
                <td>
              	<cfinput type="text" name="wp_to" id="wp_to" value="#dateformat(getempdetails.wp_to,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" validateat="onsubmit" message="Employment Pass Valid To is Invalid" readonly="readonly">&nbsp;&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('wp_to'));">&nbsp;(dd/mm/yyyy)
                </td>
                </tr>
			 	<cfquery name="getbanklist" datasource="payroll_main">
					SELECT bankcode,concat(bankname,'-',bankcode) as bankname FROM bankcodemy
				</cfquery>
                <tr>
                <th>Bank Name</th>
                <td>:</td>
                <td>
                        <cfselect name="bankcode" id="bankcode" query="getbanklist" display="bankname" value="bankcode" selected="#getempdetails.bankcode#" />
                </td>
                </tr>
                <tr>
                <th>Bank Account No</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="bankaccno" id="bankaccno" value="#getempdetails.bankaccno#" maxlength="20" size="70">
                </td>
                </tr>
                <tr>
                <th>Bank Beneficial Name</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="bankbefname" id="bankbefname" value="#getempdetails.bankbefname#" maxlength="150" size="70">
                </td>
                </tr>

                <tr>
                <th>Work Place Department</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="department" id="department" value="#getplacement.department#" maxlength="150" size="70">
                </td>
                </tr>
                 <tr>
                <th>Designation*</th>
                <td>:</td>
                <td>
                   <cfinput type="text" name="position" id="position" value="#getplacement.position#" maxlength="200" size="70" required="yes" message="Designation is Required!">
                </td>
                </tr>
                <tr>
                <th colspan="100%">
                <div align="center">Upload allow for Picture, PDF, WORD &amp; Excel document Only.</div>
                </th>
                </tr>
                <tr>
                <th>Upload IC</th>
                <td>:</td>
                <td>
                <cfif #getempdetails.cvfile# neq "">
				<div id="ajaxFieldCV">
				<a href="/eform/download.cfm?filetype=ic" target="_blank">#getempdetails.cvfile#</a>
				<input type="button" name="delete_btn" id="delete_btn" value="Delete"
				onClick="if(confirm('Are You Sure You Want To Delete IC File?')){ajaxFunction(document.getElementById('ajaxFieldCV'),'deletefile.cfm?filetype=cv');}" >
				</div>
		<cfelse>
				<input  type="file" name="uploadcv" id="uploadcv">
		</cfif>
                </td>
                </tr>
                <tr>
                <th>Upload Passport</th>
                <td>:</td>
                <td>
                <cfif #getempdetails.Passportfile# neq "">
				<div id="ajaxFieldPassport">
				<a href="/eform/download.cfm?filetype=passport" target="_blank">#getempdetails.Passportfile#</a>
				<input type="button" name="delete_btn" id="delete_btn" value="Delete"
				onClick="if(confirm('Are You Sure You Want To Delete Passport File?')){ajaxFunction(document.getElementById('ajaxFieldPassport'),'deletefile.cfm?filetype=passport');}" >
				</div>
		<cfelse>
				<input  type="file" name="uploadpassport" id="uploadpassport">
		</cfif>
                </td>
                </tr>
                <tr>
                <th>Upload Employment Pass</th>
                <td>:</td>
                <td>
                <cfif #getempdetails.Photofile# neq "">
				<div id="ajaxFieldPhoto">
				<a href="/eform/download.cfm?filetype=employmentpass" target="_blank">#getempdetails.Photofile#</a>
				<input type="button" name="delete_btn" id="delete_btn" value="Delete"
				onClick="if(confirm('Are You Sure You Want To Delete Employment Pass File?')){ajaxFunction(document.getElementById('ajaxFieldPhoto'),'deletefile.cfm?filetype=photo');}" >
				</div>
		<cfelse>
				<input  type="file" name="uploadphoto" id="uploadphoto">
		</cfif>
                </td>
                </tr>
                    <cfloop from="1" to="10" index="a">
                    <tr>

                    <th>Upload Certification #a#</th>
                    <td>:</td>
                    <td><input type="text" name="contractname#a#" id="contractname#a#" value="#evaluate('getempdetails.contractname#a#')#">&nbsp;&nbsp;&nbsp;
                    <cfif evaluate('getempdetails.contractfile#a#') neq "">
				<div id="ajaxFieldContract#a#" style="display:inline">
				<a href="/eform/download.cfm?filetype=cert#a#" target="_blank">#evaluate('getempdetails.contractfile#a#')#</a>
				<input type="button" name="delete_btn" id="delete_btn" value="Delete"
				onClick="if(confirm('Are You Sure You Want To Delete Certification #a# File?')){ajaxFunction(document.getElementById('ajaxFieldContract#a#'),'deletefile.cfm?filetype=contractfile#a#');}" >
				</div>
		<cfelse>
				<input type="file" name="uploadcontractfile#a#" id="uploadcontractfile#a#">
		</cfif>

        </td>
        </tr>
          </cfloop>
                </table>
            </div>
             <div class="tabbertab2" style="display: none">
				<h3>Leave Information</h3>
                <table>
                <tr>
                <th colspan="100%">Leave Entitlement</th>
                </tr>
                <tr>
                <th>Leave Type</th>
                <th>Days Entitled</th>
                </tr>

                <cfquery name="getleavetype" datasource="#replace(dts,'_p','_i')#">
                Select * from iccostcode WHERE costcode <> "cc1" and costcode <> "HPL" and costcode <> "NPL" order by costcode
                </cfquery>

                <cfquery name="getleave" datasource="#dts#">
                SELECT * FROM leaveent WHERE
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacement.placementno#">
                </cfquery>

                <cfloop query="getleave">
                <cfset "#getleave.leavetype#days" = getleave.leavedays>
                </cfloop>

                <cfloop query="getleavetype">
                <cfif isdefined('#getleavetype.costcode#days')>
				<cfset leaveent = evaluate('#getleavetype.costcode#days')>
                <cfelse>
                <cfset leaveent = 0>
				</cfif>
                <tr>
                <td>#getleavetype.desp#</td>
                <td>
                <cfinput type="text" name="#getleavetype.costcode#_days" id="#getleavetype.costcode#_days" value="#leaveent#" maxlength="20">
                </td>
                </tr>
                </cfloop>
                </table>

               <br>
<br>
<table>
<tr>
<th colspan="100%">Leave Utilization (until #dateformat(now(),'dd/mm/yyyy')#)</th>
</tr>
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
<tr>

        <td>
        <select name="leavetype" id="leavetype" onchange="dateajaxfunction();">
        <cfloop query="getleavetype">
        <option value="#getleavetype.costcode#">#getleavetype.desp#</option>
        </cfloop>
        <option value="NPL">No Pay Leave</option>
        </select>
        </td>
        <td>
        <input type="text" name="startdate" id="startdate"  size="12" readonly/>&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControlmp(document.getElementById('startdate'));">&nbsp;(dd/mm/yyyy)
        </td>
        <td>
        <select name="startampm" id="startampm" onchange="dateajaxfunction();">
        <option value="FULL DAY">FULL DAY</option>
        <option value="AM">AM</option>
        <option value="PM">PM</option>
        </select>
        </td>
        <td>
        <input type="text" name="enddate" id="enddate" size="12" readonly />&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControlmp(document.getElementById('enddate'));">&nbsp;(dd/mm/yyyy)
        </td>
        <td>
        <select name="endampm" id="endampm"  onchange="dateajaxfunction();">
        <option value="FULL DAY">FULL DAY</option>
        <option value="AM">AM</option>
        <option value="PM">PM</option>
        </select>
        </td>
        <td>
        <input type="text" name="leavedays" id="leavedays" size="5" value="0.00"/>
        </td>
        <td>
        <input type="text" name="remarks" id="remarks" value="" />
        </td>
        <td>
        <input type="button" name="add_leave" id="add_leave" value="Add" onclick="addleave('','add');" />
        </td>
</tr>
<tr>
<td colspan="100%">
<div id="leavelist">
<cfquery name="getleavelist" datasource="#dts#">
SELECT * FROM (
SELECT * FROM leaveutl WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacement.placementno#">
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
</div>
</td>
</tr>
</table>
<div id="ldayscal"></div>

            </div>
</div><br>

&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="sub_btn" id="sub_btn" value="Save">
</cfform>


</cfoutput>

