<cfif isdefined('form.placementno')>
<!---	<cfif #SESSION.usercty# contains 'test'>
		<cfset tomail = "kelly.lim@manpower.com.my, suyin.kok@manpower.com.my, lakshmi.ramesh@manpower.com.my">
	<cfelseif form.placementno neq "test">--->
		<cfset tomail = "myadmin@manpower.com.my">
<!---	<Cfelse>
		<cfset tomail = "shicai@mynetiquette.com">
	</cfif>--->
<cfoutput>
<cfset dts = dsname>
<cfinclude template="/object/dateobject.cfm">
<cfset sizeLimit = 10240000 />
<cfset uploaddircv = "/upload/#dts#/cv/">
<cfset uploaddircv = expandpath(uploaddircv)>
<cfif directoryexists(uploaddircv) eq false>
<cfdirectory action="create" directory="#uploaddircv#" >
</cfif>
<cfif isdefined('form.uploadcv')>
<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(form.uploadcv)) >
<cfif fileInfo.size Gt sizeLimit>
<script type="text/javascript">
alert('IC File Size Over 10 MB');
history.go(-1);
</script>
<cfabort>
</cfif>
<cfif form.uploadcv neq "">
<cftry>
<cffile action="upload" destination="#uploaddircv#" nameconflict="makeunique" filefield="uploadcv" accept="image/*,application/pdf,application/msword,application/excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" >
<cfcatch type="any">
<script type="text/javascript">
alert('IC file type is INVALID! Only allow PICTURE, PDF, WORD & EXCEL documents.');
history.go(-1);
</script>
<cfabort>
</cfcatch>
</cftry>
<cfset file1 = file.serverfile>
<cfelse>
<cfset file1 = "">
</cfif>
<cfelse>
<cfset file1 = "">
</cfif>



<cfset uploaddirphoto = "/upload/#dts#/photo/">
<cfset uploaddirphoto = expandpath(uploaddirphoto)>
<cfif directoryexists(uploaddirphoto) eq false>
<cfdirectory action="create" directory="#uploaddirphoto#" >
</cfif>
<cfif isdefined('form.uploadphoto')>
<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(form.uploadphoto)) >
<cfif fileInfo.size Gt sizeLimit>
<script type="text/javascript">
alert('Employment Pass File Size Over 10 MB');
history.go(-1);
</script>
<cfabort>
</cfif>
<cfif form.uploadphoto neq "">
<cftry>
<cffile action="upload" destination="#uploaddirphoto#" nameconflict="makeunique" filefield="uploadphoto" accept="image/*,application/pdf,application/msword,application/excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" >
<cfcatch type="any">
<script type="text/javascript">
alert('Employment Pass file type is INVALID! Only allow PICTURE, PDF, WORD & EXCEL documents.');
history.go(-1);
</script>
<cfabort>
</cfcatch>
</cftry>
<cfset file2 = file.serverfile>
<cfelse>
<cfset file2 = "">
</cfif>
<cfelse>
<cfset file2 = "">
</cfif>



<cfset uploaddirpassport = "/upload/#dts#/passport/">
<cfset uploaddirpassport = expandpath(uploaddirpassport)>
<cfif directoryexists(uploaddirpassport) eq false>
<cfdirectory action="create" directory="#uploaddirpassport#" >
</cfif>
<cfif isdefined('form.uploadpassport')>
<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(form.uploadpassport)) >
<cfif fileInfo.size Gt sizeLimit>
<script type="text/javascript">
alert('Passport File Size Over 10 MB');
history.go(-1);
</script>
<cfabort>
</cfif>
<cfif form.uploadpassport neq "">
<cftry>
<cffile action="upload" destination="#uploaddirpassport#" nameconflict="makeunique" filefield="uploadpassport"  accept="image/*,application/pdf,application/msword,application/excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" >
<cfcatch type="any">
<script type="text/javascript">
alert('Passport file type is INVALID! Only allow PICTURE, PDF, WORD & EXCEL documents.');
history.go(-1);
</script>
<cfabort>
</cfcatch>
</cftry>
<cfset file3 = file.serverfile>	
<cfelse>
<cfset file3 = "">
</cfif>
<cfelse>
<cfset file3 = "">
</cfif>

<cfset uploaddircontract = "/upload/#dts#/contract/">
<cfset uploaddircontract = expandpath(uploaddircontract)>
<cfif directoryexists(uploaddircontract) eq false>
<cfdirectory action="create" directory="#uploaddircontract#" >
</cfif>
<cfloop from="1" to="10" index="a">
<cfif isdefined('form.uploadcontractfile#a#')>
<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(evaluate('form.uploadcontractfile#a#'))) >

<cfif fileInfo.size Gt sizeLimit>
<script type="text/javascript">
alert('Certification #a# File Size Over 10 MB');
history.go(-1);
</script>
<cfabort>
</cfif>
</cfif>
<cfif isdefined('form.uploadcontractfile#a#')>
<cfif evaluate('form.uploadcontractfile#a#') neq "">
<cftry>
<cffile action="upload" destination="#uploaddircontract#" nameconflict="makeunique" filefield="uploadcontractfile#a#" accept="image/*,application/pdf,application/msword,application/excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" >
<cfcatch type="any">
<script type="text/javascript">
alert('Certification #a# file type is INVALID! Only allow PICTURE, PDF, WORD & EXCEL documents.');
history.go(-1);
</script>
<cfabort>
</cfcatch>
</cftry>
<cfset "contractfilename#a#" = file.serverfile>	
<cfelse>
<cfset "contractfilename#a#" = "">
</cfif>
<cfelse>
<cfset "contractfilename#a#" = "">
</cfif>
</cfloop>


<cfquery name="getempno" datasource="#dts#">
SELECT empno FROM emp_users WHERE 
username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<cfquery name="getempdetails" datasource="#dts#">
SELECT * FROM pmast WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
</cfquery>

<!---removed bankaccno from pbfield, [20170727,Alvin]--->
<!---<cfset pbfieldlist = "name,add1,add2,Country_Code_address,phone,email,mstatus,nricn,sex,race,dbirth,bankaccno,econtact,etelno,epfno,itaxno">--->
<cfset pbfieldlist = "name,add1,add2,Country_Code_address,phone,email,mstatus,nricn,sex,race,dbirth,econtact,etelno,epfno,itaxno">
<!---removed bankaccno from pbfield--->
<cfset uuid = createuuid()>
<cfloop list="#pbfieldlist#" index="a">
<cfif a eq 'dbirth'>
<cfif dateformatnew(form.dbirth,'yyyy-mm-dd') neq dateformat(getempdetails.dbirth,'yyyy-mm-dd')>
<cfquery name="insertdiff" datasource="#dts#">
INSERT INTO pbupdated
(
empno,
datafield,
pbdata,
mp4u,
requested_on,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"#a#"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="# dateformatnew(form.dbirth,'yyyy-mm-dd')#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="# dateformat(getempdetails.dbirth,'yyyy-mm-dd')#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
</cfquery>
</cfif>
<cfelse>
<cfif trim(evaluate('form.#a#')) neq trim(evaluate('getempdetails.#a#'))>
<cfquery name="insertdiff" datasource="#dts#">
INSERT INTO pbupdated
(
empno,
datafield,
pbdata,
mp4u,
requested_on,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"#a#"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="# trim(evaluate('getempdetails.#a#'))#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="# trim(evaluate('form.#a#'))#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
</cfquery>
</cfif>
</cfif>
</cfloop>

<cfquery name="updatepmast" datasource="#dts#">
    UPDATE PMAST 
    SET
    workemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.workemail#">
    <cfif form.passprt_to neq "">
    	,passprt_to = "#dateformatnew(form.passprt_to,'yyyy-mm-dd')#"
    </cfif>
    ,passport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.passport#">
    ,pbholiday = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pbholiday#">
    ,passport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.passport#">
    ,countryserve = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.countryserve#">
    ,wpermit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.wpermit#">
    <cfif form.wp_from neq "">
    	,wp_from = "#dateformatnew(form.wp_from,'yyyy-mm-dd')#"
    </cfif>
    <cfif form.wp_to neq "">
    	,wp_to = "#dateformatnew(form.wp_from,'yyyy-mm-dd')#"
    </cfif>
    ,eadd1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eadd1#">
    ,eadd2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.eadd2#">
    ,bankbefname  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bankbefname#">
    <!---added bankaccno into update list, [20170727, Alvin]--->
    ,bankaccno = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.bankaccno#">
    <!---added bankaccno into update list--->
    ,bankcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.bankcode#">
    ,edu = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.edu#">
    ,national = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.national#">
    ,itaxbran = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itaxbran#">
    ,sname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sname#">
    ,snric = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.snric#">
    ,sdisble = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sdisble#">
    ,numchild = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.numchild#">
    ,child_disable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.child_disable#">
    ,num_child = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.num_child#">
    ,child_edu_m = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.child_edu_m#">
    ,child_disable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.child_disable#">
    ,child_edu_f = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.child_edu_f#">
    ,cvfile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file1#">
    ,passportfile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file3#">
    ,photofile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file2#">
    <cfloop from="1" to="10" index="a">
        ,contractname#a# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.contractname#a#')#">
        ,contractfile#a# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('contractfilename#a#')#">
    </cfloop>
    WHERE 
    empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
</cfquery>

 <cfquery name="getleavetype" datasource="#replace(dts,'_p','_i')#">
                Select * from iccostcode WHERE costcode <> "cc1" and costcode <> "HPL" and costcode <> "NPL" order by costcode
                </cfquery>
 <cfquery name="removeleaveent" datasource="#dts#">
 DELETE FROM leaveent WHERE 
 empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
 AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#">
 </cfquery>
 
 <cfquery name="insertleaveent" datasource="#dts#">
 INSERT INTO leaveent
 (
 empno,
 placementno,
 leavetype,
 leavedays
 )
 VALUES
 <cfloop query="getleavetype">
 (
 <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">,
 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#">,
 <cfqueryparam cfsqltype="cf_sql_varchar" value="#getleavetype.costcode#">,
 <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.#getleavetype.costcode#_days')#">
 )
 <cfif getleavetype.currentrow neq getleavetype.recordcount>
 ,</cfif>
 </cfloop>
 </cfquery>


<cfquery name="updatedepartment" datasource="#replace(dts,'_p','_i')#">
UPDATE placement 
SET department = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.department#">
WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#">
</cfquery>

<cfquery name="getplacement" datasource="#replace(dts,'_p','_i')#">
    SELECT hrmgr,position FROM placement 
    WHERE 
    placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#">
</cfquery>

<cfif getplacement.position neq form.position>
<cfquery name="insertdiff" datasource="#dts#">
INSERT INTO pbupdated
(
empno,
datafield,
pbdata,
mp4u,
requested_on,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"position"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacement.position#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.position#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
</cfquery>
</cfif>

<cfif getplacement.hrmgr neq "">
    <cfquery name="gethmdetails" datasource="payroll_main">
    SELECT username, userid FROM 
    <cfif "#dts#" contains 'test'>
    	hmuserstest
    <cfelse>
    	hmusers
    </cfif>
    WHERE 
    entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getplacement.hrmgr#">
    </cfquery>
    <cfset nowhmname = gethmdetails.username>
    <cfset nowhmemail = gethmdetails.userid>
<cfelse>
	<cfset nowhmname = ''>
    <cfset nowhmemail = ''>
</cfif>

<!---remove bankbefname from pbupdated list, [20170803, Alvin]--->
<!---<cfif form.bankbefname neq getempdetails.name>
<cfquery name="insertdiff" datasource="#dts#">
INSERT INTO pbupdated
(
empno,
datafield,
pbdata,
mp4u,
requested_on,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"bankbefname"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempdetails.name#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bankbefname#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
</cfquery>
</cfif>--->
<!---removed bank befname--->

<cfif nowhmname neq form.hmname or nowhmemail neq form.hmemail>
<cfquery name="insertdiff" datasource="#dts#">
INSERT INTO pbupdated
(
empno,
datafield,
pbdata,
mp4u,
requested_on,
uuid
)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"hmname"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#nowhmname#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hmname#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
,
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
,"hmemail"
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#nowhmemail#">
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hmemail#">
,now()
,<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
)
</cfquery>
</cfif>

<cfquery name="checkcontent" datasource="#dts#">
SELECT * FROM pbupdated WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> 
</cfquery>

<cfif checkcontent.recordcount neq 0>
<cfset datadesp = StructNew()>
<cfquery name="getdesp" datasource="#dts#">
SELECT * FROM fieldcontent
</cfquery>
<cfloop query="getdesp">
<cfset StructInsert(datadesp, getdesp.datafield, getdesp.desp)>
</cfloop>

<cfmail to="#tomail#" from="donotreply@manpower.com.my" subject="Updated Eform Data Variances" type="html">
Hi,<br>
<br>
Below candidates has updated Eform and some data need to update into PB.<br>
<br>
Candidate No : #getempno.empno#<br>
Candidate Name : #getempdetails.name#<br>
Job Order No : #form.placementno#<br>
<br>
<table border="1">
<tr>
<th>No.</th>
<th>Field</th>
<th>PB Data</th>
<th>EFORM Data</th>
</tr>
<cfloop query="checkcontent">
<tr>
<td>#checkcontent.currentrow#</td>
<td>#datadesp[checkcontent.datafield]#</td>
<td>#checkcontent.pbdata#</td>
<td>#checkcontent.mp4u#</td>
</tr>
</cfloop>
</table>
<br>
Best Regards,<br>
MP4U
</cfmail>
</cfif>

<cfquery name="getleaveent" datasource="#dts#">
SELECT * FROM (
SELECT * FROM leaveent WHERE 
empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> 
AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#"> ) as a
                LEFT JOIN
                (SELECT costcode,desp FROM #replace(dts,'_p','_i')#.iccostcode) as b
                on a.leavetype = b.costcode
</cfquery>

<cfquery name="getleavelist" datasource="#dts#">
SELECT * FROM (
SELECT * FROM leaveutl WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#"> 
                AND placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.placementno#">
                ORDER BY startdate desc) as a
                LEFT JOIN
                (SELECT costcode,desp FROM #replace(dts,'_p','_i')#.iccostcode) as b
                on a.leavetype = b.costcode
</cfquery>

<cfif getleaveent.recordcount neq 0 and getleavelist.recordcount neq 0>
<cfmail to="#tomail#" from="donotreply@manpower.com.my" subject="Updated Leave Data" type="html">
Hi,<br>
<br>
Below candidates has updated Leave Data<br>
<br>
Candidate No : #getempno.empno#<br>
Candidate Name : #getempdetails.name#<br>
Job Order No : #form.placementno#<br>
<br>
<table width="200px">
<tr>
<th colspan="2">Leave Entitlement</th>
</tr>
<tr>
<th>Leave Type</th>
<th>Days</th>
</tr>
<cfloop query="getleaveent">
<tr>
<td>#getleaveent.desp#</td>
<td>#getleaveent.leavedays#</td>
</tr>
</cfloop>
</table>
<br>
<table width="500px">
<tr>
<th>Leave Type</th>
<th>Start Date</th>
<th>AM/PM</th>
<th>End Date</th>
<th>AM/PM</th>
<th>Days Taken</th>
<th>Remarks</th>
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
</tr>
</cfloop>
</table>
<br>
Best Regards,<br>
MP4U
</cfmail>
</cfif>

<cfquery name="updateform" datasource="#dts#">
UPDATE pdpaupdatelog
SET
eform_updated = "Y"
,eform_updated_on = now()
WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
AND empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getempno.empno#">
</cfquery>

<script type="text/javascript">
alert('Update Success! For some data, the update will only reflected in after 48 hours.');
parent.location.replace("/eleave/");
</script>
</cfoutput>
</cfif>