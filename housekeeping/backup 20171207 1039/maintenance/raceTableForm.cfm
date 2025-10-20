<!--- MT <cfscript>
	race = event.getArg('raceData');	
	xe.submit = event.getArg('xe.submit');	
	mode = event.getArg("submitLabel");	
</cfscript>--->
<cfset currentFile="racetableform.cfm">
<!--- <cfset currentFile="http://localhost/housekeeping/maintenance/raceTableForm.cfm"> --->
<cfset records_per_page=20>
<cfset page_links_shown=5>
<cfset start_page=1>
<cfset begin_page=1>
<cfset sType="">
<cfset sFor="">

<cfif isdefined("form.sType") and isdefined("form.sFor")>
	<cfset sType=form.sType><cfset sFor=URLEncodedFormat(form.sFor)>
<cfelseif isdefined("url.st") and isdefined("url.sf")>
	<cfset sType=url.st><cfset sFor=URLEncodedFormat(url.sf)>
</cfif>

<cfif isdefined("form.results_list")><cfset records_per_page=form.results_list>
<cfelseif isdefined("url.list")><cfset records_per_page = url.list>
<cfelse><cfset records_per_page=20>
</cfif>

<cfif isdefined("form.skeypage")><cfset begin_page = form.skeypage><cfif form.skeypage eq 1><cfset begin_page=1></cfif>
<cfelseif isdefined("url.page")><cfset begin_page=url.page>
<cfelse><cfset url.page=1>
</cfif>

<cfset start_record=begin_page*records_per_page-records_per_page>

<cfquery name="getrace_qry" datasource="#dts#">
	select SQL_CALC_FOUND_ROWS * from
	(
		SELECT * FROM race
		WHERE 0=0 <cfif sFor neq "">and (#variables.sType# like '%#URLDecode(variables.sFor)#' 
					OR #variables.sType# like '#URLDecode(variables.sFor)#%' OR #variables.sType# like '%#URLDecode(variables.sFor)#%' )</cfif>
		ORDER BY racedesp
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="racecount_qry" datasource="#dts#">
 	SELECT FOUND_ROWS() as records;
</cfquery>

<cfset total_pages=ceiling(racecount_qry.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Race</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">

<script language="javascript">
function confirmDelete(racecode,type) {
	var answer = confirm("Confirm Delete?")
	if (answer){
		window.location = "/housekeeping/maintenance/raceTableForm_process.cfm?type="+type+ "&racecode="+racecode;
	}
	else{
		
	}
}
</script>

</head>

<!--- MT <body onLoad="document.rform.racecode.focus()">--->

<body>

<!--- MT <div class="mainTitle"><cfoutput>#event.getArg('submitLabel')#</cfoutput></div>--->
<!---cfquery name="race_qry" datasource="payroll">
SELECT * FROM race
</cfquery--->

<cfinclude template="raceTableMain.cfm">

		<div class="ttype3">
			<cfoutput>
			<form action="#currentFile#?list=#variables.records_per_page#" method="post">
			<span class="ttype">Search By :
				<select name="sType">
			      <option value="RACECODE">ID</option>
			      <option value="RACEDESP">Race Despcription</option>	
			    </select>
				Search for : 
				<input type="text" name="sFor" value="#URLDecode(variables.sFor)#">
			</span>
			</form>
			</cfoutput>
		</div> 

		<cfform name="form1" action="#currentFile#?list=" method="post" onsubmit="return checkValue();">
			<cfoutput>
				<input type="hidden" name="sType" value="#URLDecode(variables.sType)#">
				<input type="hidden" name="sFor" value="#URLDecode(variables.sFor)#">
			</cfoutput>
	
			<div class="ttype4" align="right">
				<strong id='Display_sel' style="visibility:hidden">Display 
					<select name="results_list">
					<option value="20">20</option>
					<option value="50" <cfif records_per_page eq '50'>selected</cfif>>50</option>
					<option value="100" <cfif records_per_page eq '100'>selected</cfif>>100</option>
					</select> results per page.
					<input type="submit" name="submit" value="Submit">
				</strong>
				<cfif total_pages gt 1>
					Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field." onChange="document.getElementById('Display_sel').style.visibility='visible'">
					<cfif begin_page neq 1><cfoutput>|| <a href="#currentFile#?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Previous</a> ||</cfoutput></cfif>
					<cfif begin_page neq total_pages><cfoutput><a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Next</a> ||</cfoutput></cfif>
					<cfoutput>Page #begin_page# Of #total_pages#</cfoutput>
				</cfif>
			</div>
		
			<hr>
			<cfif isdefined("form.status")><div class="pageMessage"><cfoutput>#form.status#</cfoutput></div></cfif>
			<table width="" class="data">
				<tr>
					<th>#</th>
					<th width="15%">Race Code</th>
					<th width="60%">Race Description</th>
					<th>Action</th>
				</tr>
				<cfif getrace_qry.recordcount>
					<cfoutput query="getrace_qry">
					<tr>
						<td width="30px">
							#getrace_qry.currentrow#
						</td>
						<td>
							#getrace_qry.racecode#
						</td>
						<td>
							#getrace_qry.racedesp#
						</td>
	           			<td width="">
		           			<a href="raceTableForm_process.cfm?type=edit&RACECODE=#getrace_qry.RACECODE#"><img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> || 
							<a href="##" onclick="confirmDelete('#getrace_qry.RACECODE#','delete')"><img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
				<tr><td align="center" colspan="9">No Record Found.</td></tr>
			</cfif>
			</table>
		</cfform>
		
		<cfoutput>
			<cfif total_pages gt 1>
			<div class="" align="center">
				<cfif begin_page EQ 1>&nbsp;[Previous]
				<cfelse>
					&nbsp;<a href="#currentFile#?page=1&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[First Page]</a>
					&nbsp;<a href="#currentFile#?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Previous]</a>
				</cfif>
			
				<cfif begin_page+int(show_pages/2)-1 GTE total_pages>
					<cfset start_page=total_pages-show_pages+1>
				<cfelseif begin_page+1 GT show_pages>
					<cfset start_page=begin_page-int(show_pages/2)>
				</cfif>
				<cfset end_page=start_page+show_pages-1>
				<cfloop from="#start_page#" to="#end_page#" index="i">
					<cfif begin_page EQ i><font color="##990033">#i#</font><cfelse><a href="#currentFile#?page=#i#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">#i#</a></cfif>
				</cfloop>
			
				<cfif begin_page*records_per_page LT racecount_qry.records>
					&nbsp;<a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
					&nbsp;<a href="#currentFile#?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
				<cfelse>
					&nbsp;[Next]
				</cfif>
			</div>
			</cfif>
		</cfoutput>
		
		<div><a href="/housekeeping/setupList.cfm"><strong>< Back</strong></a></div>
		
<!--- MT <Message
<cfif structCount(race.Errors) > 		
	<div style="color: red;">
	<cfset formErrors = race.Errors >
	<cfloop collection="#formerrors#" item="errorKey">#formErrors[errorKey]#<br/></cfloop>
	</div>	
	<br>	
</cfif> --->
		
<!--- <form name="rform" action="" method="">
<div class="tabletab">
	<table width="100%" border="0">
		<tr>
			<td width="17%">Search By : <select id="search_race" name="search_race">
				<option value="RACECODE">ID</option>
				<option value="RACEDESP">Race Despcription</option>
				</select><td>
			<td width="17%">Search for : <input type="text" id="racedesp" name="racedesp"></td>
			<td width="9%">Result <input type="button" name="similar" value="Similar"></td>
			<td width="5%"><input type="button" name="exact" value="Exact"></td>
			<td width="50%"><input type="button" name="all" value="All"></td>
		</tr>
		</table>
	<br/>--->
		
			<!--- MT <td>
			<cfif FindNoCase("Add",variables.mode)>
				<cfinput type="text" size="2" name="racecode" value="#race.racecode#" required="yes" maxlength="1">
			<cfelse>
				<cfinput type="text" size="2" name="racecode" value="#race.racecode#" readonly>
			</cfif>
			</td>--->
						
	<!--- <table width="100%" border="0" class="insert">
		<tr>
			<th>No</th>
			<th>Race Code</th>
			<th>Race Description</th>
			<th>Action</th>
		</tr>
		<tr>
		<cfset i=1>
		<cfloop query="race_qry">
			<td>#i#</td>
			<td>#race_qry.RACECODE# <input type="hidden" name="racecode" value="#race_qry.RACECODE#"></td>
			<td>#race_qry.RACEDESP#</td>
			<td>
				<a href="raceTableForm_process.cfm?type=edit&RACECODE=#race_qry.RACECODE#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a> || 
				<a href="raceTableForm_process.cfm?type=delete&RACECODE=#race_qry.RACECODE#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
			</td>
		</tr>
		<cfset i=i+1>
		</cfloop>
	</table><br/>
</div>--->	

		<!---div align="center">
		<a href="">Previous</a> 
		<a href="">[1]</a>  
		<a href="">Next</a></div>	
		</div--->
	
		<!--- MT <tr>
			<td>Description:</td>
			<td><cfinput type="text" size="40" name="racedesp" required="no" maxlength="15" value="#race.racedesp#"></td>
		</tr>--->
		
	<!--- MT <center><cfinput name="submit" type="submit" value="pp"></center>
	<input type="hidden" name="submitEvent" value="#event.getArg('submitEvent')#" />
	<input type="hidden" name="submitLabel" value="#event.getArg('submitLabel')#" />--->


</body>
</html>