<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>FWL Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
    
        <script type="text/javascript">
	function updateconfirm()
	{
	var answer = confirm('Are you sure you want to update to latest FWL Rate?');
	if(answer)
	{
	window.location.href="updatefwl.cfm";
	}
	
	}
    </script>
    
</head>

<body>
<cfquery datasource="#dts#" name="fwlt_qry">
SELECT * FROM fwltable
</cfquery>
	<div class="mainTitle">FWL Table Main</div>
	
	<cfform name="fwlForm" action="fwlTableMain_process.cfm" method="post">
		<cfoutput><table class="form" border="0">
		<tr>
			<th width="60px">Levy Table</th>
            <th width="50px">Sector</th>
            <th width="300px">Dependency Ceiling</th>
            <th width="100px">Worker Category</th>
            <th width="50px">Type</th>
			<th width="100px">Fix Per Month</th>
			<th width="100px">By Days Worked</th>
		</tr>
		<cfloop query="fwlt_qry">
		<tr>
			<td>#fwlt_qry.id# <input type="hidden" name="fwl_#fwlt_qry.id#" value="#fwlt_qry.id#"></td>
			<td><input type="text" name="fwl_sector_#fwlt_qry.id#" value="#fwlt_qry.sector#" <cfif fwlt_qry.id lt 23 and dts neq "empty_p">readonly</cfif> size="12" /></td>
			<td><input type="text" name="fwl_DC_#fwlt_qry.id#" value="#fwlt_qry.DC#" size="50"  <cfif fwlt_qry.id lt 23 and dts neq "empty_p">readonly</cfif> /></td>
            <td><input type="text" name="fwl_workercat_#fwlt_qry.id#" value="#fwlt_qry.workercat#" <cfif fwlt_qry.id lt 23 and dts neq "empty_p">readonly</cfif> /></td>
            <td><input type="text" name="fwl_type_#fwlt_qry.id#" value="#fwlt_qry.type#" size="10" <cfif fwlt_qry.id lt 23 and dts neq "empty_p">readonly</cfif> /></td>
            <td><cfinput type="text" name="fwl_monthly_#fwlt_qry.id#" value="#numberformat(fwlt_qry.Monthly,'0')#" align="right" size="12" validate="integer" validateat="onsubmit" message="Monthly rate is invalid"/></td>
            <td><cfinput type="text" name="fwl_daily_#fwlt_qry.id#" value="#numberformat(fwlt_qry.daily,'.__')#" align="right" size="12" validate="float" validateat="onsubmit" message="Monthly rate is invalid"/> <cfif fwlt_qry.id gt 22><a href="fwlTableMain_process.cfm?action=delete&id=#fwlt_qry.id#">Delete</a></cfif> </td>
		</tr>
		</cfloop>
        <tr>
			<td><input type="submit" name="insert" value="INSERT" /></td>
			<td><input type="text" name="fwl_sector" value="" size="12"/></td>
			<td><input type="text" name="fwl_DC" value="" size="50"/></td>
            <td><input type="text" name="fwl_workercat" value="" /></td>
            <td><input type="text" name="fwl_type" value="" size="10" /></td>
            <td><input type="text" name="fwl_monthly" value="" size="12" /></td>
            <td><input type="text" name="fwl_daily" value="" size="12" /></td>
		</tr>
		</table></cfoutput>
		<br />
		<!--- <div>
		Note:<br/><br/>
		#Manufacturing# &nbsp&nbsp&nbsp&nbsp&nbsp #Process#<br/>
		0-40%   [240,8] &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Skilled [50,2]<br/>
		40-50%  [310,11] &nbsp&nbsp&nbsp&nbsp Unskilled[295,10]<br/>
		Skilled [50,2]<br/><br/>
		
		#Construction# &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp #Service#<br/>
		Skilled   [50,2] &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Skilled   [50,2]<br/>
		Unskilled [470,16] &nbsp&nbsp Unskilled [240,8]<br/><br/>
		
		#Marine# &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp #Harbour Craft#<br/>
		Skilled   [50,2] &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Skilled   [50,2]<br/>
		Unskilled [295,10] &nbsp&nbsp Unskilled [240,8]<br/>
		</div> --->
		<cfoutput>
		<center>
			<!--- <input type="reset" name="reset" value="Reset"> --->
			<input type="submit" name="submit" value="OK" />
			<input type="button" name="cancel" value="Cancel" onClick="window.location='/housekeeping/setupList.cfm'">
             <cfif HuserCcode eq 'SG'>
    <input type="button" name="update" value="UPDATE NEW FWL RATE" onClick="updateconfirm()" />
    </cfif>
		</center>
		
		<!--- need these if there's an error with the required fields so they'll be available in the next event --->
		<!--- input type="hidden" name="xe.submit" value="#event.getArg('xe.submit')#" / --->
		<!--- input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" / --->
		</cfoutput>
	</cfform>
</body>
</html>
