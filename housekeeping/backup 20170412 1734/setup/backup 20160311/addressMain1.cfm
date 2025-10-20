<!---cfimport prefix="ctag" taglib="/extensions/customtags/">
<cfset ses = event.getArg("sessionUser")>

<cfsavecontent variable="actionLink">
	<a href="../index.cfm?event=housekeeping.setup.addressEdit&refno=#refno#&#variables.linkInfo#"><img height="18px" width="18px" src="../images/edit.ICO" alt="Edit" border="0">Edit</a>
</cfsavecontent--->

<cfif findnocase(cgi.script_name,cgi.path_info)>
    <cfset request.path_info = cgi.path_info>
<cfelse>
    <cfset request.path_info = cgi.script_name & cgi.path_info>
</cfif>

<cfset currentFile=getToken(request.path_info,listlen(request.path_info,"/"),"/")>
<!--- <cfset currentFile="http://localhost/housekeeping/setup/addressMain.cfm"> --->
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

<cfquery name="getadd_qry" datasource="#dts#">
	select SQL_CALC_FOUND_ROWS * from
	(
		SELECT * FROM address
		WHERE 0=0 <cfif sFor neq "">and (#variables.sType# like '%#URLDecode(variables.sFor)#' 
					OR #variables.sType# like '#URLDecode(variables.sFor)#%' OR #variables.sType# like '%#URLDecode(variables.sFor)#%' )</cfif>
		ORDER BY org_type
	) as r
	LIMIT #start_record#, #records_per_page#
</cfquery>

<cfquery name="addcount_qry" datasource="#dts#">
 	SELECT FOUND_ROWS() as records;
</cfquery>

<cfset total_pages=ceiling(addcount_qry.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Addresses & Account No.</title>
	<script src="/javascripts/tabber.js" type="text/javascript"></script>
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<script language="javascript">
	</script>
</head>
<body>
<div class="mainTitle">Addresses & Account No.</div>

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
					<th width="2%">NO</th>
					<th width="10%">TYPE</th>
					<th width="20%">CATEGORY</th>
                    <th width="25%">FILE NO.</th>
                    <th width="25%">ACCOUNT NO.</th>
					<th width="18%">ACTION</th>
				</tr>
				<cfif getadd_qry.recordcount>
					<cfoutput query="getadd_qry">
					<tr onMouseOver="javascript:this.style.backgroundColor='99FF00';" onMouseOut="javascript:this.style.backgroundColor='';">
						<td width="30px">
							#getadd_qry.currentrow#
						</td>
						<td>
							#getadd_qry.org_type#
						</td>
						<td>
							#getadd_qry.category#
						</td>
                        <td>
                        #getadd_qry.com_fileno#
                        </td>
                        <td>
                        #getadd_qry.com_accno#
                        </td>
	           			<td >
							<a href="addressForm.cfm?org_type=#getadd_qry.org_type#&CATEGORY=#getadd_qry.category#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
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
			
				<cfif begin_page*records_per_page LT addcount_qry.records>
					&nbsp;<a href="#currentFile#?page=#begin_page+1#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Next]</a>
					&nbsp;<a href="#currentFile#?tran=INV&page=#total_pages#&list=#records_per_page#&st=#variables.sType#&sf=#variables.sFor#">[Last Page]</a>
				<cfelse>
					&nbsp;[Next]
				</cfif>
			</div>
			</cfif>
		</cfoutput>
	
		<div><br /><a href="/housekeeping/setupList.cfm"><strong>< Back</strong></a></div>
	
	<!---cfif event.isArgDefined("message")><p style="color:red;"><cfoutput>#event.getArg("message")#</cfoutput></p></cfif--->

	<!---ctag:table
		useComponent="extensions.model.address.addressService"
		useMethod="getAddressInGroup"
        TableFieldList="refno!!hidden||org_type!!Org Type!!15%||category!!Category!!60%||"
		orderBy="org_type,(category+0)"
		Path="../index.cfm?event=housekeeping.setup.showAddressMain"
		ActionButton="#actionLink#"
		SearchType=""
		Dsn="#ses.userDsn#"--->
</body>
</html>