<cfsetting showdebugoutput="no">
<cfquery name="getInfo" datasource="payroll_main">
	SELECT info_remark,info_date,info_desp
	FROM info
	ORDER BY info_date desc
	LIMIT 5;
</cfquery>

<cfquery name="query_log" datasource="payroll_main">
SELECT * FROM USERLOG ul, hmUSERS u
WHERE ul.userLogID = u.userID
AND u.entryID = "#HEntryID#" ORDER BY ul.userlogtime DESC limit 0 , 20
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Overview</title>
<link rel="stylesheet" href="/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/css/dataTables/dataTables_fullPagination.css" />
<link rel="stylesheet" href="/css/body/overview.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
<cfoutput>
<script type="text/javascript">
	var dts='#dts#';
</script>
</cfoutput>
<script type="text/javascript" src="/js/body/overview.js"></script>
</head>
<body>
<cfoutput>

<div class="containerDiv">
	<div class="titleDiv">Overview</div>
	
	<div class="infoBoardDiv">
		<div class="infoBoardTitleDiv">Information Board</div>
		<div class="infoBoardContentDiv">
			<cfloop query="getInfo">
			<div class="infoDiv">
				<div class="infoTitleDiv">#info_remark#
					<div class="infoDateDiv">#DateFormat(info_date,"dd/mm/yyyy")#</div>
				</div>
				<div class="infoContentDiv">#info_desp#</div>	
			</div>
			</cfloop>	
		</div>
	</div>
</cfoutput>

<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;" >
<cfoutput query="query_log">
<tr>
	<td width="19%" align="center">#query_log.userlogid#</td>
	<td width="33%" align="center">#query_log.userlogtime#</td>
	<td width="27%" align="center">#query_log.uipaddress#</td>
	<td width="21%" align="center">#query_log.status#</td>
</tr>
</cfoutput>
		</table>
        </div>

</div>
<div id="ajaxfield"></div>

<!--- Check wp validity --->
<cfquery name="checkwp" datasource="payroll_main">
	SELECT wpexpdays,wpemail FROM gsetup where comp_id = "#HComID#"
</cfquery>

<cfif checkwp.wpemail eq "Y">

<cfset dateget = dateadd('d',checkwp.wpexpdays,now())>

<cfquery name="getwp" datasource="#dts#">
    SELECT wp_to,empno,name FROM pmast WHERE wp_to <> "" and wp_to <> "0000-00-00" 
    and wp_to <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(dateget,'yyyy-mm-dd')#"> and paystatus = "A"		 	order by wp_to
</cfquery>
<cfset wplist = "">

<cfif getwp.recordcount gt 0>
<cfloop query="getwp">
		<cfif wplist eq "">
			<cfset wplist = wplist & getwp.empno &" (" & dateformat(getwp.wp_to,"dd/mm/yyyy") & ")">
        <cfelse>
			<cfset wplist = wplist & ", "& getwp.empno &" (" & dateformat(getwp.wp_to,"dd/mm/yyyy") & ")">
        </cfif>
</cfloop>
		<cfoutput>
        <script type="text/javascript">
			alert("Work permit(s) expiring in #checkwp.wpexpdays# days for employee no:\n\n#wplist#");
        </script>
        </cfoutput>
</cfif>
</cfif>
<!--- end of Check wp validity --->

<!--- Check eportal new changes--->
<cfquery name="gs_qry2" datasource="#dts_main#">
SELECT eportapp FROM gsetup2 WHERE comp_id = '#HcomID#'
</cfquery>

<cfif gs_qry2.eportapp eq "Y">
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<script type="text/javascript">
		function updatepmast(empno){
			ajaxFunction(document.getElementById('ajaxfield'),'overviewajax.cfm?empno='+empno);
		}
		function change(empno){
			ajaxFunction(document.getElementById('ajaxfield'),'overviewajax.cfm?cempno='+empno);
		}
</script>

    <cfquery name="checkep" datasource="#dts#">
        SELECT p.empno,name,p.add1,p.add2,p.phone,p.edu,p.email,
        e.empno as empno,e.add1 as eadd1,e.add2 as eadd2, e.phone as ephone,e.edu as eedu,e.email as eemail 
        FROM emp_users e 
        LEFT JOIN (
        SELECT empno,name,add1,add2,phone,edu,email FROM pmast) p
        ON e.empno = p.empno
        WHERE changes = "Y" AND (p.add1 != e.add1 OR p.add2 != e.add2 OR p.phone != e.phone OR p.edu != e.edu)
    </cfquery>
<cfdump  var = "#checkep#" output="d:\test.txt">
    <cfset eplist1 = "" >
    <cfset eplist2 = "" >
    <cfif checkep.recordcount gt 0>

	<cfloop query="checkep">
		<cfset eplist1 = "Add1: "&checkep.add1&"\nAdd2: "&checkep.add2&
						"\nPhone: "&checkep.phone&"\nEducation: "&checkep.edu&"\nEmail: "&checkep.email>
		<cfset eplist2 = "Add1: "&checkep.eadd1&"\nAdd2: "&checkep.eadd2&
						"\nPhone: "&checkep.ephone&"\nEducation: "&checkep.eedu&"\nEmail: "&checkep.eemail>
    <cfoutput>
    <script type="text/javascript">

		if(confirm("#checkep.name# (#checkep.empno#) information has changed as below, \nPlease click ok to update, cancel to reject.\nFrom:\n#eplist1#\n\nTo:\n#eplist2#")){
			updatepmast('#checkep.empno#');
		}
		else{
			change('#checkep.empno#');		
		}
	</script>    
    </cfoutput>
    </cfloop>
    
    </cfif>
</cfif>


</body>
</html>