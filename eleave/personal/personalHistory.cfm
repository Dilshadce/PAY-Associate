<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Personal Particular</title>
<script src="../../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<link href="../../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
</head>

<body>
<cfset datenow = #dateformat(now(), 'yyyymmdd')# >

 <cfquery name="leave_his" datasource="#DSNAME#">
        SELECT * FROM LEAVE_APL as la LEFT JOIN emp_users as ep ON la.empno = ep.empno
        where DateEnd <= #datenow# 
        and STATUS <> "ON PROGRESS"
        and ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
        </cfquery>
        
<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>Leave History</h3>
           
        <table class="form" border="1" width="1000px">
        <tr>
        <th>No.</th>
        <th>Leave ID</th>
        <th>Date Start</th>
        <th>Date End</th>
        <th>Days</th>
        <th width="10">Leave Type</th>
        <th width="10">Leave Option</th>
        <th width="70">Time From</th>
        <th width="70">Time To</th>
        <th>Status</th>
        <th>Apply Date</th>
        <th>Remarks</th>
        <th>Management Remarks</th>
        </tr>
        <cfset  i=1>
        <cfloop query="leave_his">
        <tr>
        <td>#i#</td>
        <td>#leave_his.LeaveID#</td>
        <td>#dateformat(leave_his.DateStart,'yyyy-mm-dd')#</td>
        <td>#dateformat(leave_his.DateEnd,'yyyy-mm-dd')#</td>
        <td>#leave_his.Days#</td>
        <td>#leave_his.Leave_type#</td>
        <td>#leave_his.leave_option#</td>
        <td>#timeformat(leave_his.timeFr)#</td>
        <td>#timeformat(leave_his.timeTo)#</td>
        <td>#leave_his.status#</td>
        <td>#leave_his.ApplyDate#</td>
        <td>#leave_his.Applicant_remarks#</td>
        <td>#leave_his.Management_remarks#</td>
        </tr>
        <cfset i = i+1>
        </cfloop>
      <!---   <cfform name="eForm" action="" method="post">
        <input type="button" name="searchbutton" value="Search Day" 
        onclick="javascript:ColdFusion.Window.show('searchHistory')">
        </cfform> --->
        <br />
        </table> 
   
        </div>
</div>
</cfoutput>
<script type="text/javascript">
<!--
var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1", "email", {validateOn:["blur"]});
//-->
</script>
 <cfwindow x="210" y="100" width="400" height="400" name="searchHistory"
        title="Search Employee History" initshow="false"
        source="searchHistory.cfm"  modal="true"/>
</body>
</html>
