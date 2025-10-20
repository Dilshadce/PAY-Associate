<cfquery name="getEmail" datasource="#dts#">
	SELECT id, category, auto
    FROM smsemail
    WHERE category = "EMAIL" AND type = "Birthday"
</cfquery>

<cfif getEmail.RecordCount EQ 0>
	<cfquery name="insertBODEmail" datasource="#dts#">
    	INSERT INTO smsemail (created_on, created_by, type, content, schedule, category, auto, title)
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateTimeFormat(Now(), 'yyyy-mm-dd HH:nn:ss')#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Birthday">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="<p>Happy Birthday! Thank you for your support throughout the year! You have receive a voucher to enjoy discount when shop at our shop. Your voucher code is <strong>&amp;vouchercode&amp;</strong>. Spend more than RM <strong>&amp;minamount&amp;</strong> and get to enjoy RM <strong>&amp;value&amp;</strong> discount. Please use the voucher before <strong>&amp;expireddate&amp;.</strong></p>">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="2015-06-10 00:00:00">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="EMAIL">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Happy Birthday">
        )
    </cfquery>
    
    <cfquery name="getEmail" datasource="#dts#">
        SELECT id, category, auto
        FROM smsemail
        WHERE category = "EMAIL" AND type = "Birthday"
	</cfquery>
</cfif>

<cfquery name="getSetting" datasource="#dts#">
	SELECT setting1, setting2, setting3, setting4, setting5
    FROM marketingsetting
    WHERE type = "Email"
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
<script type="text/javascript" src="emailMaintenance.js"></script>
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
    	<h2>Email
        	<span class="glyphicon glyphicon-question-sign btn-link"></span> 
            <span class="glyphicon glyphicon-facetime-video btn-link"></span>
        	<div class="pull-right">
            	<button type="button" class="btn btn-default" onClick="window.open('emailDetail.cfm?action=create','_self');"> 
                	<span class="glyphicon glyphicon-plus"></span> Add New Email
                </button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="##myModal">
                	<span class="glyphicon glyphicon-cog"></span> Mail Setup
                </button>        
                <span style="font-size:18px">
                    Birthday Email 
            	</span>
                <input type="checkbox" id="bodEmail" name="bodEmail" data-toggle="toggle" onChange="onBodEmail()" <cfif #getEmail.auto# EQ 'Y'>checked</cfif>>
            </div>
        </h2>
    </div>
    <div class="container">
        <table class="table table-bordered table-hover" id="emailTable" style="table-layout:fixed">
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
                <h4 class="modal-title">Mail Setup</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                    	<form class="form-horizontal" id="emailSetting" name="emailSetting" method="post" action="../memberMaintenance/settingProcess.cfm?type=Email<cfif #getSetting.RecordCount# EQ 0>&action=create<cfelse>&action=update</cfif>">
                            <div class="form-group">
                            	<label for="emailAdd" class="col-sm-4 control-label">Email Address</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="emailAdd" name="emailAdd" placeholder="Email Address"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting1#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="password" class="col-sm-4 control-label">Password</label>
                                <div class="col-sm-5">
                                    <input type="password" class="form-control input-sm" id="password" name="password" placeholder="Password"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting2#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="mailServer" class="col-sm-4 control-label">Mail Server</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="mailServer" name="mailServer" placeholder="Mail Server"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting3#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="mailServer" class="col-sm-4 control-label">Port No</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="portNo" name="portNo" placeholder="Port No"<cfif #getSetting.RecordCount# EQ 0><cfelse>value="#getSetting.setting4#"</cfif> />
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                            <div class="form-group">
                            	<label for="mailServer" class="col-sm-4 control-label">Security Type</label>
                                <div class="col-sm-5">
                                	<select class="form-control input-sm" id="securityType" name="securityType">
                      					<option value="None" <cfif #getSetting.RecordCount# EQ 0 OR #getSetting.setting5# EQ "None">selected</cfif>>None</option>
                                        <option value="SSL" <cfif #getSetting.RecordCount# GT 0 AND #getSetting.setting5# EQ "SSL">selected</cfif>>SSL</option>
                                        <option value="TLS" <cfif #getSetting.RecordCount# GT 0 AND #getSetting.setting5# EQ "TLS">selected</cfif>>TLS</option>
              						</select> 
                                </div>
                                <div class="col-sm-3">
                                </div>                    
                            </div>
                        </form>                                                             
                    </div>
                 </div>           
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" onClick="document.getElementById('emailSetting').submit();">Update</button>
            </div>
      	</div>
    </div>
</div>
</body>
<script>
  $(function() {
    $('##toggle-two').bootstrapToggle({
      on: 'Enabled',
      off: 'Disabled'
    });
  })
  function onBodEmail(){
	if(document.getElementById("bodEmail").checked){
		window.open("updateBodAutoSend.cfm?checked=1&cate=#getEmail.category#&id=#getEmail.id#", "_self");
	}
	else{
		window.open("updateBodAutoSend.cfm?checked=0&cate=#getEmail.category#&id=#getEmail.id#", "_self");
	}  
  }
</script>
</cfoutput>
</html>