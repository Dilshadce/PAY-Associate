<cfquery name="getSms" datasource="#dts#">
	SELECT id, category, auto
    FROM smsemail
    WHERE category = "SMS" AND type = "Birthday"
</cfquery>

<cfif getSms.RecordCount EQ 0>
	<cfquery name="insertBODSms" datasource="#dts#">
    	INSERT INTO smsemail (created_on, created_by, type, content, schedule, category, auto, title)
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateTimeFormat(Now(), 'yyyy-mm-dd HH:nn:ss')#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Birthday">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Happy Birthday! Thank you for your support throughout the year! You have receive a voucher to enjoy discount when shop at our shop. Your voucher code is &vouchercode&. Spend more than RM &minamount& and get to enjoy RM &value& discount. Please use the voucher before &expireddate&.">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="2015-06-10 00:00:00">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="SMS">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Happy Birthday">
        )
    </cfquery>
    
    <cfquery name="getSms" datasource="#dts#">
        SELECT id, category, auto
        FROM smsemail
        WHERE category = "SMS" AND type = "Birthday"
	</cfquery>
</cfif>

<cfquery name="getSetting" datasource="#dts#">
	SELECT setting1, setting2, setting3, setting4, setting5, setting6
    FROM marketingsetting
    WHERE type = "SMS"
</cfquery>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>SMS</title>
<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/latest/css/maintenance/profile.css" />
<link rel="stylesheet" type="text/css" href="/latest/css/dataTables/dataTables_bootstrap.css" />
<link rel="stylesheet" type="text/css" href="https://gitcdn.github.io/bootstrap-toggle/2.2.0/css/bootstrap-toggle.min.css" rel="stylesheet">
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript" src="/latest/js/dataTables/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/latest/js/dataTables/dataTables_bootstrap.js"></script>
<script type="text/javascript" src="smsMaintenance.js"></script>
<script type="text/javascript" src="https://gitcdn.github.io/bootstrap-toggle/2.2.0/js/bootstrap-toggle.min.js"></script>
<script type="text/javascript" src="../../../../scripts/ajax.js"></script>
<cfoutput>
<script type="text/javascript">
	var dts = "#dts#";
	var targetTable = "smsemail";
</script>
</cfoutput>
</head>

<cfoutput>
<body>
<div class="container">
	<div class="page-header">
    	<h2>SMS
        	<span class="glyphicon glyphicon-question-sign btn-link"></span> 
            <span class="glyphicon glyphicon-facetime-video btn-link"></span>
        	<div class="pull-right">
            	<button type="button" class="btn btn-default" onClick="window.open('smsDetail.cfm?action=create','_self');"> 
                	<span class="glyphicon glyphicon-plus"></span> Add New SMS
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="##myModal"> 
                	<span class="glyphicon glyphicon-cog"></span> SMS Setup
                </button>               
                <span style="font-size:18px">
                    Birthday SMS 
            	</span>
                <input type="checkbox" id="bodSms" name="bodSms" data-toggle="toggle" onChange="onBodSms()" <cfif #getSms.auto# EQ 'Y'>checked</cfif>>
            </div>
        </h2>
    </div>
    <div class="container">
        <table class="table table-bordered table-hover" id="smsTable" style="table-layout:fixed">
        	<thead>
          	</thead>
          	<tbody>
          	</tbody>
        </table>
    </div>
</div>
<div id="myModal" class="modal fade" role="dialog">
	<div class="modal-dialog"> 
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">SMS Setup</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                    	<form class="form-horizontal" id="smsSetting" name="smsSetting" method="post" action="../memberMaintenance/settingProcess.cfm?type=SMS<cfif #getSetting.RecordCount# EQ 0>&action=create<cfelse>&action=update</cfif>">
                            <div class="form-group">
                            	<label for="apiUserName" class="col-sm-4 control-label">API Username</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="apiUserName" name="apiUserName" placeholder="API Username"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting1#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="apiPassword" class="col-sm-4 control-label">API Password</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="apiPassword" name="apiPassword" placeholder="API Password"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting2#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="senderId" class="col-sm-4 control-label">Sender ID</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="senderId" name="senderId" placeholder="Sender ID"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting3#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="senderId" class="col-sm-4 control-label">Http Url</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control input-sm" id="httpUrl" name="httpUrl" placeholder="Http Url"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting4#"</cfif> />
                                </div>                
                            </div>
                        </form>                                                             
                    </div>
                 </div>           
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" onClick="document.getElementById('smsSetting').submit();">Update</button>
            </div>
      	</div>
    </div>
</div>
</body>
</cfoutput>
<cfoutput>
<script>
  $(function() {
    $('##toggle-two').bootstrapToggle({
      on: 'Enabled',
      off: 'Disabled'
    });
  })
  function onBodSms(){
	if(document.getElementById("bodSms").checked){
		window.open("updateBodAutoSend.cfm?checked=1&cate=#getSms.category#&id=#getSms.id#", "_self");
	}
	else{
		window.open("updateBodAutoSend.cfm?checked=0&cate=#getSms.category#&id=#getSms.id#", "_self");
	}  
  }
</script>
</cfoutput>
</html>