<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<title>Print Personal Leave Record</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Personnel Reports</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	<script language="javascript" type="text/javascript" src="/javascripts/ajax.js"></script></head>

<body>
<cfoutput>

        <h3>Print Personal Leave Record </h3>
        <form name="pForm" action="personal_leave_record_process.cfm" method="post" target="_blank">
        <table class="form">
	        <tr>
				<th>Report Format</th>
				<td>
					<input type="radio" name="result" value="HTML" checked>HTML<br/>
					<input type="radio" name="result" value="EXCELDEFAULT">PDF<br/>
				</td>
			<tr>
			<tr>
				<th>Leave Type</th>
		        	<td>
			        	<select id="leaveType" name="leaveType">
				        	<option id="ALL" value="ALL" selected>ALL</option>
							<option id="AL" value="AL">Annual Leave</option>
		                    <option id="MC" value="MC">Medical Leave</option>
							<option id="MT" value="MT">Maternity Leave</option>
		                    <option id="CC" value="CC">ChildCare Leave</option>
							<option id="MR" value="MR">Marriage Leave</option>
							<option id="CL" value="CL">Compassionate Leave</option>
							<option id="HL" value="HL">Hospital Leave</option>
							<option id="EX" value="EX">Examination Leave</option>
							<option id="PT" value="PT">Paternity Leave</option>
							<option id="AD" value="AD">Advance Leave</option>
							<option id="OPL" value="OPL">Other Pay Leave</option>
							<option id="LS" value="LS">Line Shut Down</option>
							<option id="AB" value="AB">Absent</option>
							<option id="NPL" value="NPL">No Pay Leave</option>
							<option id="NCL" value="NCL">Time Off</option>
						</select>
					</td>
			</tr>
        </table>
		<center>
			<input type="submit" name="ok" value="Ok">
		</center>
        </form>
   
</cfoutput>
</body>
</html>
