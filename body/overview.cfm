<cfsetting showdebugoutput="no">
<cfquery name="getInfo" datasource="payroll_main">
	SELECT info_remark,info_date,info_desp
	FROM info
    WHERE INFO_SYSTEM = "Eleave-HM"
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
<link rel="stylesheet" href="/css/animate-daniel-eden/Animate.css">
<link rel="stylesheet" href="/css/bootstrap-3.3.7/bootstrap.min.css">
    
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/js/bootstrap-notify/bootstrap-notify.js"></script>

<script type="text/javascript">
    /*setTimeout(function(){
        $.notify({
            // options
            icon: 'glyphicon glyphicon-info-sign',
            title: '<strong>Approval Management Updates!</strong><br /><br />',
            message: 'We are pleased to inform that we have updated the functions on the management of approvals!'+
                     ' You may now <strong>mass approve/mass reject</strong> leave applications and timesheet submissions. '+
                     'Please click on <strong><i>Approval</i></strong> page for more information.',
            url: '#',
            target: '_blank'
        },{
            // settings
            element: 'body',
            position: null,
            type: "info",
            allow_dismiss: true,
            newest_on_top: false,
            showProgressbar: false,
            placement: {
				from: "top",
				align: "center"
			},
            //offset: {
            //    x: 550,
            //    y: 200
            //},
            offset: 200,
            spacing: 10,
            z_index: 1031,
            delay: 0,
            timer: 1000,
            url_target: '_blank',
            mouse_over: null,
            animate: {
                enter: 'animated fadeInDown',
                exit: 'animated fadeOutUp'
            },
            onShow: null,
            onShown: null,
            onClose: null,
            onClosed: null,
            icon_type: 'class',
            template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
                '<button type="button" aria-hidden="true" class="close" style="font-size: 15px;" data-notify="dismiss">Close{&times;}</button>' +
                '<span data-notify="icon"></span> ' +
                '<span data-notify="title">{1}</span> ' +
                '<span data-notify="message">{2}</span>' +
                '<div class="progress" data-notify="progressbar">' +
                    '<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
                '</div>' +
                '<a href="{3}" target="{4}" data-notify="url"></a>' +
            '</div>' 
        });
    }, 100);*/
    
    setTimeout(function(){
        $.notify({
            // options
            icon: 'glyphicon glyphicon-info-sign',
            title: '<strong>Leave approval updates!</strong><br /><br />',
            message: 'We are pleased to inform that we have implemented earned leave function into the leave management module.'+
                     '<br/><br/>You will be prompted when you are approving advance leave. Approval is subject to your kind judgement.'+
                     '<br/><br/>If you do not need earned leave prompt, we may turn it off anytime upon request.',
            url: '#',
            target: '_blank'
        },{
            // settings
            element: 'body',
            position: null,
            type: "info",
            allow_dismiss: true,
            newest_on_top: false,
            showProgressbar: false,
            placement: {
				from: "top",
				align: "center"
			},
            //offset: {
            //    x: 550,
            //    y: 200
            //},
            offset: 200,
            spacing: 10,
            z_index: 1031,
            delay: 0,
            timer: 1000,
            url_target: '_blank',
            mouse_over: null,
            animate: {
                enter: 'animated fadeInDown',
                exit: 'animated fadeOutUp'
            },
            onShow: null,
            onShown: null,
            onClose: null,
            onClosed: null,
            icon_type: 'class',
            template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
                '<button type="button" aria-hidden="true" class="close" style="font-size: 15px;" data-notify="dismiss">Close{&times;}</button>' +
                '<span data-notify="icon"></span> ' +
                '<span data-notify="title">{1}</span> ' +
                '<span data-notify="message">{2}</span>' +
                '<div class="progress" data-notify="progressbar">' +
                    '<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
                '</div>' +
                '<a href="{3}" target="{4}" data-notify="url"></a>' +
            '</div>' 
        });
    }, 100);
</script>
    
<style>
    [data-notify="container"] {
        text-align: justify;
    }
    
    .titleDiv{
        float:left;
        margin-top:16px;
        clear:both;
        font-family:Verdana, Geneva, sans-serif;
        font-size:28px;
        color:#454E59;
    }
    .infoBoardDiv{
        float:left;	
        width:100%;
        min-width:460px;
        max-width:1025px;
        clear:both;
        margin-top:28px;
        margin-right:25px;
        margin-bottom:25px;
        padding-left:20px;
        padding-right:20px;
        border:1px solid #CCCCCC;
        -moz-border-radius:5px 5px 5px 5px;
        -webkit-border-radius:5px 5px 5px 5px;
        border-radius:5px 5px 5px 5px;
        behavior: url(/css/pie/PIE.htc);
    }

    .infoBoardTitleDiv{
        float:left;
        width:100%;
        padding-top:16px;
        padding-bottom:13px;
        font-family:"Franklin Gothic Demi";
        font-size:15px;
        word-spacing:0.05em;
        color:#4D4D4D;
    }
    .infoBoardContentDiv{
        float:left;
        width:100%;
    }
    .infoDiv{
        display:inline-block;
        width:100%;
        margin-bottom:16px;
        border-top:2px solid #CCCCCC;
    }
    .infoTitleDiv{
        position:relative;
        float:left;
        width:100%;
        height:17px;
        padding-top:5px;
        padding-bottom:22px;
        font-family:"Franklin Gothic Medium";
        font-size:13px;
        word-spacing:0.025em;
        color:#666666;	
    }
    .infoDateDiv{
        position:absolute;
        top:8px;
        right:-2px;
        font-style:italic;
        color:#808080;
    }
    .infoContentDiv{
        float:left;
        width:100%;
        padding-top:8px;
        border-top:1px solid #CCCCCC;
        font-family:"Franklin Gothic Book";
        font-size:12px;
        color:#808080;
    }
</style> 
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