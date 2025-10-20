<cfsetting showdebugoutput="no">
<cfquery name="getInfo" datasource="payroll_main">
	SELECT info_remark,info_date,info_desp
	FROM info
    where info_system ='ELeave-EMP'
	ORDER BY info_date desc
	LIMIT 5;
</cfquery>

<!---<cfquery name="query_log" datasource="#DSNAME#">
SELECT * FROM EMP_USERS_LOG WHERE USER_ID = "#HUserID#" ORDER BY LOGDT DESC limit 0 , 20
</cfquery>
--->
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
<cfoutput>
<script type="text/javascript">
	var DSNAME='#DSNAME#';
 </script> 
</cfoutput>
<script type="text/javascript" src="/eleave/js/overview.js"></script>
<script type="text/javascript">
    /*setTimeout(function(){
        $.notify({
            // options
            icon: 'glyphicon glyphicon-info-sign',
            title: '<strong>Payslip updates!</strong><br /><br />',
            message: 'As part of our continuous improvement to deliver better services to you, with regards to payslips, we would like to inform you on the following process enhancement:<br /><br />'+
                     '<ol><li>Effective <b>1 Sep 2018</b> (i.e. for all pay-outs made from 1 Sep onwards), ManpowerGroup will <b>no longer be sending ' +
                     'the payslips through email</b>.</li><br />'+
                     '<li>You will be able to view/print your payslips by logging into MP4U and following the steps below: <br>'+
                     'Choose Payslip & EA Form > Print Pay Slip > Choose required Year, Month > Click Go</li><br />'+
                     '<li>The payslips may be viewed and printed from MP4U <b>within 5 working days</b> from their respective scheduled salary pay-out dates.</li>'+
                     '</ol><br />We believe these changes will make the process of getting payslips much more effective for you.'+
                     '<br /><br />Should you have any further questions, please contact HR Helpdesk:<br /><br />'+
                     '<ul><li>Phone: +60 2087 0033</li><li>E-mail: myhrhelpdesk@manpower.com.my</li></ul>',
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
            offset: 100,
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
            template: '<div data-notify="container" class="col-xs-11 col-sm-8 alert alert-{0}" role="alert">' +
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
            title: '<strong>Leave submission updates!</strong><br /><br />',
            message: 'We have implemented earned leave function into the leave management module.' +
                     '<br/>You will now receive a prompt when you apply annual leave more than what you have earned.',
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
            /*offset: {
                x: 550,
                y: 200
            },*/
            offset: 100,
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
            template: '<div data-notify="container" class="col-xs-11 col-sm-8 alert alert-{0}" role="alert">' +
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
</head>
<body>
<cfoutput>
<div class="containerDiv">
	<div class="titleDiv">Welcome #HUserName#</div>
	
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
<!--- 	<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div> --->
    
</cfoutput>
<div class="loggingHistoryDiv">
		<table id="loggingTable" style="width:100%;" >
<!---<cfoutput query="query_log">
<!---<tr>
	<td width="19%" align="center">#query_log.User_ID#</td>
	<td width="33%" align="center">#query_log.LogDT#</td>
	<td width="27%" align="center">#query_log.Log_IP#</td>
</tr>--->
</cfoutput>--->
		</table>
        </div>

</body>
</html>