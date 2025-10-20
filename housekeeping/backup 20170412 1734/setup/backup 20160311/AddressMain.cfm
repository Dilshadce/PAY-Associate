<!--- <cfif type eq "pay_12m" or type eq "pay2_12m_fig" or type eq "pay1_12m_fig">
	<cfset formAction="/housekeeping/AddressMain.cfm?type=#type#">
</cfif> --->

<cfset pageTitle="Addresses & Account No.">
<cfset targetTitle="Addresses & Account No.">
<cfset targetTable="address">
<!--- <cfset displayEditDelete=getUserPin2.H10201_3b>
 ---> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="shortcut icon" href="/PMS.ico" />
    <link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/css/profile/profile.css" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/js/respond/respond.min.js"></script>
    <![endif]-->
 
    <script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/js/dataTables/dataTables_bootstrap.js"></script>

    <cfoutput>
    <script type="text/javascript">
        var dts='#dts#';
<!--- 		var display='#displayEditDelete#';
 --->   var targetTitle='#targetTitle#';
        var targetTable='#targetTable#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/js/housekeeping/addressProfile.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>
			#pageTitle#
			<span class="glyphicon glyphicon-question-sign btn-link"></span>
			<span class="glyphicon glyphicon-facetime-video btn-link"></span>
            
			<div class="pull-right">
           		<!--- <button type="button" class="btn btn-default" onclick="window.open('/housekeeping/normalPay/normalPayForm.cfm','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add #targetTitle#
               	</button> --->
            
               	<button type="button" class="btn btn-default" onclick="window.open('/housekeeping/setup/addressProcess.cfm?action=print','_blank');">
                        <span class="glyphicon glyphicon-print"></span> Print
               	</button>
				<!--- <cfif getUserPin2.H10201_3a EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('/housekeeping/normalPay.cfm?action=create','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add #targetTitle#
                    </button>
                </cfif> 
       			    <cfif getUserPin2.H10201_3a EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('/housekeeping/normalPayProcess.cfm?action=print','_blank');">
                        <span class="glyphicon glyphicon-print"></span> Print
                    </button>
                </cfif>  --->
			</div>
		</h2>
	</div>
	<div class="container">
		<table class="table table-bordered table-hover" id="resultTable" style="table-layout:fixed">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
</cfoutput>
</body>
</html>
