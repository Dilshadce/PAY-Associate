<cfset currentFile="shiftAllowanceForm.cfm"> 
<!--- <cfset currentFile="http://localhost/housekeeping/maintenance/shiftAllowanceForm.cfm"> --->
<cfset records_per_page=10>
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

<cfquery name="getsa_qry" datasource="#dts#">
	select SQL_CALC_FOUND_ROWS * from
	(
		SELECT * FROM shftable
		WHERE 0=0 <cfif sFor neq "">and (#variables.sType# like '%#URLDecode(variables.sFor)#' 
					OR #variables.sType# like '#URLDecode(variables.sFor)#%' OR #variables.sType# like '%#URLDecode(variables.sFor)#%' )</cfif>
		ORDER BY SHF_DESP
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="sacount_qry" datasource="#dts#">
 	SELECT FOUND_ROWS() as records;
</cfquery>

<cfset total_pages=ceiling(sacount_qry.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Shift Allowance Table</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>


<body>
	<div class="mainTitle">Shift Allowance Table</div>
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
					<th width="2%" align="center">#</th>
					<th width="50%">Description</th>
					<th width="10%">Action</th>
				</tr>
				<cfif getsa_qry.recordcount>
					<cfoutput query="getsa_qry">
					<tr>
						<td width="30px" align="center">
							#getsa_qry.currentrow#
						</td>
						<td>
							#getsa_qry.SHF_DESP#
						</td>
	           			<td width="">
		           			<a href="shiftAllowanceForm_edit.cfm?SHF_COU=#getsa_qry.SHF_COU#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
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
			
				<cfif begin_page*records_per_page LT sacount_qry.records>
					&nbsp;<a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
					&nbsp;<a href="#currentFile#?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
				<cfelse>
					&nbsp;[Next]
				</cfif>
			</div>
			</cfif>
		</cfoutput>
		
		<div><a href="/housekeeping/setupList.cfm"><strong>< Back</strong></a></div>
</body>
</html>