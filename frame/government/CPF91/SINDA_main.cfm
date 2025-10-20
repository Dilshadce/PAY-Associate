<html>
<head>
	<title>SINDA Fund</title>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="cpf_qry" datasource="#dts#">
SELECT * FROM address
WHERE org_type in ('CPF')
</cfquery>

<cfquery name="branch_qry" datasource="#dts#">
	select * from branch order by brcode
</cfquery>

<cfquery name="dept_qry" datasource="#dts#">
	select * from dept order by deptcode
</cfquery>

<cfquery name="category_qry" datasource="#dts#">
	select * from category order by category
</cfquery>

<body>

<div class="mainTitle">CPF91 SINDA Fund</div>
<div class="tabber">
<form name="gForm" action="SINDA_rep.cfm" method="post" target="_blank">
<table class="form">
	<tr>
		<th>Report Format</th>
		<td>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">PDF<br/>
		<td>
	</tr>
         <script type="text/javascript">
	function searchSel(fieldid,textid) {
	  var input=document.getElementById(textid).value.toLowerCase();
	  var output=document.getElementById(fieldid).options;
	  for(var i=0;i<output.length;i++) {
		if(output[i].text.toLowerCase().indexOf(input)>=0 && i != 0){
		  output[i].selected=true;
		  break;
		  }
		if(document.getElementById(textid).value==''){
		  output[0].selected=true;
		  }
	  }
	}
    </script>
    <cfquery name="emp_qry" datasource="#dts#">
SELECT empno, name, emp_code
FROM pmast
ORDER BY empno
</cfquery>
<cfoutput>
    <tr>
	<th>Employee No.</th>
	<td>
	<select name="empno" id="empno">
		<option name="" value=""></option>
		<cfloop query="emp_qry">
		<option name="" value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
		</cfloop>
	</select><br/>
    Search Employee : <input type="text" name="searchempnofrom" id="searchempnofrom" onKeyUp="searchSel('empno','searchempnofrom')" />	</td>
	<td>To</td>
	<td>
	<select name="empno1" id="empno1">
		<option name="" value="">zzzzzz</option>
		<cfloop query="emp_qry">
		<option name="" value="#emp_qry.empno#">#emp_qry.empno# | #emp_qry.name#</option>
		</cfloop>
	</select><br/>
    Search Employee : <input type="text" name="searchempnofrom" id="searchempnofrom" onKeyUp="searchSel('empno1','searchempnofrom')" />	</td>
</tr>
</cfoutput>
	<tr>
		<th>Branch From</th>
		<td><select id="branchFrom" name="branchFrom">
			<option value=""></option>
			<cfoutput query="branch_qry">
				<option id="#branch_qry.brcode#" value="#branch_qry.brcode#">#branch_qry.brcode# | #branch_qry.brdesp#</option>
			</cfoutput>
		</select></td>
		<td>To</td>
		<td><select id="branchTo" name="branchTo">
			<option value="">zzzz</option>
			<cfoutput query="branch_qry">
				<option id="#branch_qry.brcode#" value="#branch_qry.brcode#">#branch_qry.brcode# | #branch_qry.brdesp#</option>
			</cfoutput>
		</select></td>
	</tr>
	<tr>
			<th>Department From</th>
			<td><select id="deptFrom" name="deptFrom" />
				<option value=""></option>
			<cfoutput query="dept_qry">
				<option id="#dept_qry.deptcode#" value="#dept_qry.deptcode#">#dept_qry.deptcode# | #dept_qry.deptdesp#</option>
			</cfoutput>
			</select></td>
			<td>To</td>
			<td><select id="deptTo" name="deptTo" />
				<option value="">zzzzzzzzzz</option>
			<cfoutput query="dept_qry">
				<option id="#dept_qry.deptcode#" value="#dept_qry.deptcode#">#dept_qry.deptcode# | #dept_qry.deptdesp#</option>
			</cfoutput>
			</select></td>
		</tr>	
		<tr>
			<th>Category From</th>
			<td><select id="categoryFrom" name="categoryFrom" />
				<option value=""></option>
			<cfoutput query="category_qry">
				<option id="#category_qry.category#" value="#category_qry.category#">#category_qry.category# | #category_qry.desp#</option>
			</cfoutput>
			</select></td>
			<td>To</td>
			<td><select id="categoryTo" name="categoryTo" />
				<option value="">zzzzzzzzzz</option>
			<cfoutput query="category_qry">
				<option id="#category_qry.category#" value="#category_qry.category#">#category_qry.category# | #category_qry.desp#</option>
			</cfoutput>
			</select></td>
		</tr>	
	<tr>
		<td>CPF Category</td>
		<td>
		<select name="cat">
		<cfoutput query="cpf_qry">
			<option value="#cpf_qry.category#">#cpf_qry.category# - #cpf_qry.com_fileno#</option>
		</cfoutput>
		</select>
		</td>
	</tr>
</table>

<center><br />
	<input type="submit" name="submit" value="OK">
	<input type="button" name="exit" value="Exit" onClick="window.location='/government/CPF91/CPF91List.cfm'">
</center>
</form>
</div>

</body>
</html>