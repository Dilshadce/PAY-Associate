<cfif HUserGrpID neq "super">
<cfabort>
<cfelse>
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

<cfif isdefined("form.results_list")>
	<cfset records_per_page=form.results_list>
<cfelseif isdefined("url.list")>
	<cfset records_per_page = url.list>
<cfelse>
	<cfset records_per_page=20>
</cfif>

<cfif isdefined("form.skeypage")>
	<cfset begin_page = form.skeypage>
	<cfif form.skeypage eq 1>
		<cfset begin_page=1>
	</cfif>
<cfelseif isdefined("url.page")>
	<cfset begin_page=url.page>
<cfelse>
	<cfset url.page=1>
</cfif>

<cfset start_record=begin_page*records_per_page-records_per_page>

<cfquery name="getData" datasource="payroll_main">
	select SQL_CALC_FOUND_ROWS * from
	(
		Select * from info 
		
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="get_count" datasource="payroll_main">
 	SELECT FOUND_ROWS() as records
</cfquery>

<cfset total_pages=ceiling(get_count.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="/stylesheet/app.css"/>
<title>infomation</title>
<script language="javascript" type="text/javascript" src="/scripts/table.js"></script>
</head>

<body>
	<h1>Information Profile</h1>
	<div id="container">
		<cfform name="form1" action="info_view.cfm?list=" method="post" onsubmit="return checkValue();">
			<cfoutput>
				<input type="hidden" name="sType" value="#URLDecode(variables.sType)#">
				<input type="hidden" name="sFor" value="#URLDecode(variables.sFor)#">
			</cfoutput>
			<div>
				<h4><div align="center"><a href="info.cfm?type=create">Create New Code</a></div></h4>
			</div>
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
					<cfif begin_page neq 1><cfoutput>|| <a href="info_view.cfm?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Previous</a> ||</cfoutput></cfif>
					<cfif begin_page neq total_pages><cfoutput><a href="info_view.cfm?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">Next</a> ||</cfoutput></cfif>
				</cfif>
				<cfoutput>Page #begin_page# Of #total_pages#</cfoutput>			
			</div>
			<hr>
			<cfif isdefined("form.status")><div class="pageMessage" align="center"><cfoutput><font color="red">#form.status#</font></cfoutput></div></cfif>
			<table width="90%" align="center" class="data">
				<tr>
					<th width="50px">No.</th>
					<th width="80px">Date</th>
					<th >System</th>
                    <th >Desp</th>
					<th width="80px">Remark</th>
					<th width="80px">Action</th>
				</tr>
				<cfif getData.recordcount>
					<cfoutput query="getData">
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td>#getData.currentrow#</td>
						<td align="left">#dateformat(getData.info_date,"dd/mm/yyyy")#</td>
						<td>#getData.info_system#</td>
                        <td>#getData.info_desp#</td>
						<td >#getData.info_remark#</td>
						<td align="left">
						<a href="info.cfm?type=edit&id=#getData.info_ID#">Edit</a>  ||
						<a href="info.cfm?type=delete&id=#getData.info_id#">Delete</a></td> 
					</tr>
					</cfoutput>
				<cfelse>
					<tr><td align="center" colspan="4">No Record Found.</td></tr>
				</cfif>
			</table>
		</cfform>
		<cfoutput>
			<div class="ttype4" align="center">
				<cfif begin_page EQ 1>
					&nbsp;[Previous]
				<cfelse>
					&nbsp;<a href="info_view.cfm?page=1&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[First Page]</a>
					&nbsp;<a href="info_view.cfm?page=#begin_page-1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Previous]</a>
				</cfif>
		
				<cfif begin_page+int(show_pages/2)-1 GTE total_pages>
					<cfset start_page=total_pages-show_pages+1>
				<cfelseif begin_page+1 GT show_pages>
					<cfset start_page=begin_page-int(show_pages/2)>
				</cfif>
				<cfset end_page=start_page+show_pages-1>
				<cfloop from="#start_page#" to="#end_page#" index="i">
					<cfif begin_page EQ i><font color="##990033">#i#</font><cfelse><a href="info_view.cfm?page=#i#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">#i#</a></cfif>
				</cfloop>
		
				<cfif begin_page*records_per_page LT get_count.records>
					&nbsp;<a href="info_view.cfm?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
					&nbsp;<a href="info_view.cfm?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
				<cfelse>
					&nbsp;[Next]
				</cfif>
			</div>
		</cfoutput>		
	</div>
</body>
</html>
</cfif>