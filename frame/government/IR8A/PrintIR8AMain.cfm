<html>
<head>
	<title>Print IR8A</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
</head>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type IN ('TAX')
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT *
FROM pmast 
where confid >= #hpin# 
order by empno
</cfquery>

<body>

<div class="mainTitle">IR8A Print IR8A</div>
<form name="iForm" id="iForm" action="PrintIR8A_rep.cfm" method="post" target="_blank">
<table class="form">
	<tr>
		<th>Employee No. From</th>
		<td>
		<select name="empnoFrom" id="empnoFrom" onChange="document.getElementById('empnoTo').selectedIndex=this.selectedIndex;">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>		</td>
	</tr>
	<tr>
		<th>Employee No. To</th>
		<td>
		<select name="empnoTo" id="empnoTo">
			<option value="">zzzzzzz</option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
			</cfoutput>
		</select>		</td>
	</tr>
	<tr>
		<th>TAX Category</th>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category# - #cpf_qry.com_fileno#</option>
		</cfoutput>
		</select>		</td>
	</tr>
	<tr>
		<th>Report Format</th>
		<td>
		<select name="reportformat" id="reportformat">
        <option value="IR8A2014.cfr">2014</option>
			<option value="IR8A2013.cfr">2013</option>
            <option value="IR8A2012.cfr">2012</option>
            
		</select>		</td>
	</tr>
	<tr>
		<th>Credit Date</th>
		<td><input type="text" name="cdate" id="cdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(cdate);"></td>
	</tr>
	<tr>
		<th>Report Date</th>
		<td><input type="text" name="rdate" id="rdate" value="" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(rdate);"></td>
	</tr>
    <cfquery name="confid_qry" datasource="#dts#">
		SELECT confid FROM pmast GROUP BY confid
		</cfquery>
		<tr>
			<th>Confidential</th>
			<td><select id="confidential" name="confidential" value="confidential">
					<option id="default" value="">----Select----</option>
					<cfoutput query="confid_qry">
					<option id="#confid_qry.confid#" value="#confid_qry.confid#">#confid_qry.confid#</option>
					</cfoutput>
				</select></td>
		</tr>
		<tr>
		  <th>Exclude 0 Figure</th>
		  <td><input type="checkbox" name="exclude0" id="exclude0" value="yes" checked /></td>
    </tr>
</table>
<br />
	<center>
		<input type="button" name="generate" value="Generate"  onClick="javascript:ColdFusion.Window.show('generateEmployeeDetails');">
		<input type="button" name="update" value="Update" onClick="window.location.href='PrintIR8AUpdateMain.cfm';">
		<!--- <input type="button" name="spec" value="Interface File Spec" onClick=""> --->
		<input type="submit" name="ok" value="OK">
	</center>

</form>

</body>

</html>


<cfwindow x="200" y="200" width="550" height="200" name="generateEmployeeDetails" refreshOnShow="true"
        title="Generate Employee Details" initshow="false"
        source="/government/IR8A/generateEmployeeDetailsAjax.cfm?empnoFrom={iForm:empnoFrom}&empnoTo={iForm:empnoTo}" />
		