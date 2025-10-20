<cfif Husergrpid eq "user">
	Sorry You have no permission to access this page.
	<cfabort>
</cfif>

<cfset SetLocale("English (UK)")>
<cfif findnocase(cgi.script_name,cgi.path_info)>
    <cfset request.path_info = cgi.path_info>
<cfelse>
    <cfset request.path_info = cgi.script_name & cgi.path_info>
</cfif>
<cfset currentFile=getToken(request.path_info,listlen(request.path_info,"/"),"/")>
<!--- <cfset currentFile="localhost:8300/admin/checkAudit.cfm"> --->
<cfset records_per_page=20>
<cfset page_links_shown=5>
<cfset start_page=1>
<cfset begin_page=1>

<cfquery name="getUser" datasource="#dts_main#">
	select userId from users 
	where 0=0
	<cfif Husergrpid eq "admin"> 
		and (userGrpId='user' or userGrpId='admin')
	</cfif> 
	and userCmpID='#HcomID#' 
	<cfif Husergrpid neq 'Super'>AND USERGRPID!='SUPER'</cfif>
	order by userId
</cfquery>

<html>
<head>
<title>View Audit Trail</title>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="javascript">
function checkValue(){if(document.form1.skeypage.value==''){alert("Please fill with number.");document.form1.skeypage.focus();return false;}return true;}
function del_confirm(){var r=confirm("Press a button");if (r==true){return true;}else{document.write("You pressed Cancel!");}}
function refreshPage(){form1.submit();}

function openWindow(url,w,h,tb,stb,l,mb,sb,rs,x,y){
var t=(document.layers)? ',screenX='+x+',screenY='+y: ',left='+x+',top='+y; //A LITTLE CROSS-BROWSER CODE FOR WINDOW POSITIONING
tb=(tb)?'yes':'no'; stb=(stb)?'yes':'no'; l=(l)?'yes':'no'; mb=(mb)?'yes':'no'; sb=(sb)?'yes':'no'; rs=(rs)?'yes':'no';
var x=window.open(url, 'newWin2'+new Date().getTime(), 'scrollbars='+sb+',width='+w+',height='+h+',toolbar='+tb+',status='+stb+',menubar='+mb+',links='+l+',resizable='+rs+t);
x.focus();
}
</script>
</head>

<body>
<h1>Audit Trail </h1>
<!--- Search Form --->
<cfif isdefined("form.msg")>
	<cfset sDateM=form.date_m>
	<cfset sDateY=form.date_y>
	<cfset sModule=form.module>
	<cfset sUser=form.user>
	<cfset sMsg=form.msg>
<cfelseif isdefined("url.msg")>
	<cfset sDateM=URLDecode(url.date_m)>
	<cfset sDateY=URLDecode(url.date_y)>
	<cfset sModule=URLDecode(url.module)>
	<cfset sUser=URLDecode(url.user)>
	<cfset sMsg=URLDecode(url.msg)>
<cfelse>
	<cfset sDateM=month(now())>
	<cfset sDateY=year(now())>
	<cfset sModule="all">
	<cfset sUser="all">
	<cfset sMsg="">
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
<cfif sDateM eq "" and sDateY eq "">
	
	<cfset condition=" #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (action Like '%#variables.sMsg#%' or pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset condition2=" #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset urlExtension="&module=#variables.sModule#&user=#variables.sUser#&msg=#variables.sMsg#">

<cfelseif sDateY eq ""> 
	
	<cfset condition=" and month(date)=#sDateM# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (action Like '%#variables.sMsg#%' or pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset condition2=" and month(date)=#sDateM# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset urlExtension="&date_m=#variables.sDateM#&module=#variables.sModule#&user=#variables.sUser#&msg=#variables.sMsg#">

<cfelseif sDateM eq "">
	
	<cfset condition=" and year(date)=#sDateY# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (action Like '%#variables.sMsg#%' or pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset condition2=" and year(date)=#sDateY# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset urlExtension="&date_y=#variables.sDateY#&module=#variables.sModule#&user=#variables.sUser#&msg=#variables.sMsg#">
<cfelse>
	
	<cfset condition=" and month(date)=#sDateM# and year(date)=#sDateY# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (action Like '%#variables.sMsg#%' or pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset condition2=" and month(date)=#sDateM# and year(date)=#sDateY# #IIF(sModule neq 'all',DE(" and module='#sModule#'"),DE(""))# 
		#IIF(sUser neq 'all',DE(" and user='#sUser#'"),DE(" and user in ('#valuelist(getUser.userId,"','")#')"))#
		#IIF(sMsg neq '',DE(" and (pointer Like '%#variables.sMsg#%' or comment Like '%#variables.sMsg#%')"),DE(""))#">
	<cfset urlExtension="&date_m=#variables.sDateM#&date_y=#variables.sDateY#&module=#variables.sModule#&user=#variables.sUser#&msg=#variables.sMsg#">

</cfif>



<cfquery name="getData" datasource="#dts#">
	select SQL_CALC_FOUND_ROWS *, 
	CASE r.module 
		WHEN 'PYM' THEN 'PAYMENT'
		ELSE 'UNKNOWN'
	END as module_name
	from
	(
		Select entryno,DATE_FORMAT(date,'%d/%m/%Y %r') as date,date as date2,user,module,action,
		if(SUBSTRING_INDEX(pointer,'[',1)!='file',
			concat(SUBSTRING_INDEX(pointer,'[',1),' - ',action,' - ID {',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''),'}'),
			concat(action,' file ',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''))
		) as msg
		from audit_trail where comment is null or comment='' #PreserveSingleQuotes(condition)#
		union all
		Select entryno,DATE_FORMAT(date,'%d/%m/%Y %r') as date,date as date2,user,module,action,
		if(SUBSTRING_INDEX(pointer,'[',1)!='file',
			concat(comment,' - ',action,' - ',SUBSTRING_INDEX(pointer,'[',1),' - ID {',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''),'}'),
			concat(action,' file ',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''))
		) as msg
		from audit_trail where comment not like '% - Step %' and comment is not null and comment!='' #PreserveSingleQuotes(condition)#
		union all
		Select entryno,DATE_FORMAT(date,'%d/%m/%Y %r') as date,date as date2,user,module,action,
		if(SUBSTRING_INDEX(pointer,'[',1)!='file',
			concat(SUBSTRING_INDEX(comment,'-',1),'- ID {',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''),'}'),
			concat(action,' file ',Replace(SUBSTRING_INDEX(pointer,'[',-1),']',''))
		) as msg
		from audit_trail where comment like '% - Step 1/%' #PreserveSingleQuotes(condition2)#
	) as r
	order by r.date2 desc,r.entryno
	<!--- LIMIT #start_record#, #records_per_page# --->
</cfquery>
<cfquery name="get_count" datasource="#dts#">
 	SELECT FOUND_ROWS() as records;
</cfquery>

<cfset total_pages=ceiling(get_count.records/records_per_page)>
<cfset show_pages=min(page_links_shown,total_pages)>
<cfoutput>
<form action="#currentFile#?list=#variables.records_per_page#" method="post">
	<fieldset style="border:1px ridge ##ff00ff; padding: 0.5em;">
		<legend style="color: ##ff0000;">View Condition</legend>
			Date : 
			<select name="date_m">
			<option value="">All</option>
			<cfloop from="1" to="12" index="m">
			<option value="#m#" #iif(m eq variables.sDateM,DE("selected"),DE(""))#>#dateformat(createdate("2001",m,"01"),"mmm")#</option>
			</cfloop>
			</select>month&nbsp;
			<select name="date_y">
			<option value="">All</option>	
			<cfloop from="#year(now())-3#" to="#year(now())#" index="y">
			<option value="#y#" #iif(y eq variables.sDateY,DE("selected"),DE(""))#>#y#</option>
			</cfloop>
			</select>year&nbsp;|&nbsp;
			Module : 
			<select name="module">
				<option value="all">All</option>
				<option value="PYM" #iif('PYM' eq variables.sModule,DE("selected"),DE(""))#>PAYMENT</option>
			</select>&nbsp;|&nbsp;
			User : 
			<select name="user">
				<option value="all">All</option>
				<cfloop query="getUser"><option value="#getUser.userId#" #IIf(getUser.userId eq variables.sUser,DE("selected"),DE(""))#>#getUser.userId#</option></cfloop>
			</select>&nbsp;|&nbsp;
			Search Log Msg :
			<input type="text" name="msg" value="#variables.sMsg#">&nbsp;
			<input type="submit" name="Submit" value="Submit">
	</fieldset>
</form>
<cfif isdefined("url.status")><h3>#url.status#</h3></cfif>
</cfoutput>

<cfform name="form1" action="#currentFile#?list=" method="post" onsubmit="return checkValue();">
	<cfoutput>
		<input type="hidden" name="sDateM" value="#variables.sDateM#">
		<input type="hidden" name="sDateY" value="#variables.sDateY#">
		<input type="hidden" name="sModule" value="#variables.sModule#">
		<input type="hidden" name="sUser" value="#variables.sUser#">
	</cfoutput>
	
	<div align="right">
		<strong id='Display_sel' style="visibility:hidden">Display 
			<select name="results_list">
			<option value="20">20</option>
			<option value="50" <cfif records_per_page eq '50'>selected</cfif>>50</option>
			<option value="100" <cfif records_per_page eq '100'>selected</cfif>>100</option>
			</select> results per page.
			<input type="submit" name="submit" value="Submit">
		</strong>
		Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field." onChange="document.getElementById('Display_sel').style.visibility='visible'">
	<cfif begin_page neq 1><cfoutput>|| <a href="#currentFile#?page=#begin_page-1#&list=#records_per_page##urlExtension#">Previous</a> ||</cfoutput></cfif>
	<cfif begin_page neq total_pages><cfoutput><a href="#currentFile#?page=#begin_page+1#&list=#records_per_page##urlExtension#">Next</a> ||</cfoutput></cfif>
	<cfoutput>Page #begin_page# Of #total_pages#</cfoutput>
	</div>
<hr>
<table width="900px" align="center" cellpadding="3" cellspacing="1" class="data">
	<tr>
		<!--- <td colspan="5"><font color="red">Note: only Reverse Bill is keep track into new Audit Trail</font></td> --->
	</tr><tr>
		<th width="17%">Date Time</th>
		<th width="13%">Module</th>
		<th width="8%">Editor</th>
		<th>Log Message</th>
		<th width="7%">Detail</th>
	</tr>
	<cfoutput query="getData">
	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<td>#getData.date#</td>
		<td>#getData.module_name#</td>
		<td>#getData.user#</td>
		<td>#getData.msg#</td>
		<td align="center"><cfif getData.action eq "create" or getData.action eq "delete">no detail<cfelse><a href="javascript:openWindow('checkAuditDetail.cfm?entryno=#getData.entryno#', 500, 420 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 )">detail</a></cfif></td>
	</tr>
	</cfoutput>
</table>
</cfform>
<cfoutput>
		<div align="center">
		<cfif begin_page EQ 1>&nbsp;[Previous]
		<cfelse>
			&nbsp;<a href="#currentFile#?page=1&list=#records_per_page##urlExtension#">[First Page]</a>
			&nbsp;<a href="#currentFile#?page=#begin_page-1#&list=#records_per_page##urlExtension#">[Previous]</a>
		</cfif>
	
		<cfif begin_page+int(show_pages/2)-1 GTE total_pages>
			<cfset start_page=total_pages-show_pages+1>
		<cfelseif begin_page+1 GT show_pages>
			<cfset start_page=begin_page-int(show_pages/2)>
		</cfif>
		<cfset end_page=start_page+show_pages-1>
		<cfloop from="#start_page#" to="#end_page#" index="i">
			<cfif begin_page EQ i><font color="##990033">#i#</font><cfelse><a href="#currentFile#?page=#i#&list=#records_per_page##urlExtension#">#i#</a></cfif>
		</cfloop>
	
		<cfif begin_page*records_per_page LT get_count.records>
			&nbsp;<a href="#currentFile#?page=#begin_page+1#&list=#records_per_page##urlExtension#">[Next]</a>
			&nbsp;<a href="#currentFile#?tran=INV&page=#total_pages#&list=#records_per_page##urlExtension#">[Last Page]</a>
		<cfelse>
			&nbsp;[Next]
		</cfif>
		</div>
</cfoutput>
<!--- <font color="#FF0000">* use % for pattern matching.</font> --->
</body>
</html>

















