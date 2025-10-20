<html>
<head>
	<title>Generate IR8A Spec</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	
	<script>
		function findselected()
		{ 
			var generate = document.getElementById('generate'); 
			var toa = document.getElementById('toa'); 
			var tob = document.getElementById('tob'); 
			(generate.value == "GenerateIR8A_rep.cfm" || generate.value == "all")? toa.disabled=false : toa.disabled=true ;
			(generate.value == "GenerateIR8S_rep.cfm" || generate.value == "all")? tob.disabled=false : tob.disabled=true
		} 
	</script> 
	
	<script language="javascript">
	function  validateform()
	{
		var batch_date = document.getElementById('bdate').value.split('/');
		var date_now = document.getElementById('datenow').value.split('/');
		var generate = document.getElementById('generate').value;
		msg = "";
		if(generate == "")
		{
			msg = msg + "Please select generate file.\n";
		}
		
		if(batch_date == "")
		{
		msg = msg+ "The batch date can not be empty.\n"
		}
		
		if(parseFloat(date_now[0])+parseFloat(date_now[1])+parseFloat(date_now[2]) < parseFloat(batch_date[0])+parseFloat(batch_date[1])+parseFloat(batch_date[2]) )
		{
		msg = msg + "The batch number can not be future date.\n";
		}
		if (msg!= "")
		{
			alert(msg);
			return false;
		}
		<!---var get_file_name = document.getElementById('generate').value;
		 if(get_file_name == "all")
		{
			return document.gForm.action = "GenerateIR8A_rep.cfm";
			return document.gForm.action = "GenerateIR8S_rep.cfm"";
		} --->
		else
		{
			return document.gForm.action = document.getElementById('generate').value;
		}
	}
	
	</script>
	
</head>

<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset curdate = Createdate(getComp_qry.myear,'12', '31')>


<cfquery name="emp_qry" datasource="#dts#">
SELECT empno,name FROM pmast where year(dresign) = "#getComp_qry.myear#" or dresign is null or dresign ="0000-00-00" order by empno 
</cfquery>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type IN ('TAX')
</cfquery>

<body>

<div class="mainTitle">Generate IR8A Spec</div>

<cfform name="gForm" action="" method="post" target="_blank" >
<div class="tabber">
<table class="form">
	<tr>
		<th>Generate</th>
		<td><select name="generate" id="generate" onChange="findselected()"> 
				<option value=""></option> 
				<option value="GenerateIR8A_rep.cfm">IR8A</option> 
				<option value="GenerateIR8S_rep.cfm">IR8S</option> 
                <option value="crimsonIR8A.cfm">CRIMSON LOGIC IR8A</option> 
                <option value="crimsonIR8S.cfm">CRIMSON LOGIC IR8S</option> 
                <option value="GenerateAPXA_rep.cfm">APPENDIX 8A</option> 
                <option value="GenerateAPXA_rep.cfm">APPENDIX 8B</option> 
			</select> 
</td>
	</tr>
	<tr>
		<th>Employee No. From</th>
		<td><select name="empnoFrom" id="empnoFrom" onChange="document.getElementById('empnoTo').selectedIndex=this.selectedIndex;">
			<option value=""></option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#" name="empnoFrom">#emp_qry.empno# - #emp_qry.name#</option>
			</cfoutput>
		</select></td>
	</tr>
	<tr>
		<th>Employee No. To</th>
		<td><select name="empnoTo" id="empnoTo">
			<option value="">zzzzzz</option>
			<cfoutput query="emp_qry">
			<option value="#emp_qry.empno#" name="empnoTo">#emp_qry.empno# - #emp_qry.name#</option>
			</cfoutput>
		</select> </td>
	</tr>
	<tr>
		<th>TAX Category</th>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#" >#cpf_qry.category#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
	<cfoutput>
	<tr>
		<th>Batch Date</th>
		
			<cfset datenow = #dateformat(now(),'dd/mm/yyyy')#>
		<input type="hidden" id="datenow" name="datenow" value="#datenow#" >
		
		<td><input type="text" name="bdate" id="bdate" value="#datenow#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('bdate'));">**File Creation Date</td>
	</tr>
	</cfoutput>
	<tr>
		<th>Report Date</th>
		<td><input type="text" name="rdate" id="rdate" value="<cfoutput>#dateformat(curdate,'dd/mm/yyyy')#</cfoutput>" size="10" >
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('rdate'));"></td>
	</tr>
    <tr>
		  <th>Exclude 0 Figure</th>
		  <td><input type="checkbox" name="exclude0" id="exclude0" value="yes" checked /></td>
    </tr>
     <tr>
		  <th>Amendment</th>
		  <td><input type="checkbox" name="amendment" id="amendment" value="yes" /></td>
    </tr>
	<tr>
		<th>To File (IR8A)</th>
		<td><input type="text" size="40" id="toa" name="toa" value="IR8A" disabled> </td>
	</tr>
	<tr>	
		<th>To File (IR8S)</th>
		<td>
			<input type="text" size="40" id="tob" name="tob" value="IR8S" disabled>
		</td>
	</tr>
</table>

<br />
<center>
	<input type="submit" name="save" value="Save" onClick="javascript:return validateform();">
	<input type="button" name="exit" value="Exit" onClick="window.location='/government/IR8A/IR8AList.cfm'">
</center>
</div>
</cfform>
</body>

</html>