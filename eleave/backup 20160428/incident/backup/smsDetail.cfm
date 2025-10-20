<cfif #url.action# EQ "create">
	<cfset title = "New SMS">
    <cfset action = "smsMaintenanceProcess.cfm?action=create">
<cfelseif #url.action# EQ "edit">
	<cfset title = "Edit SMS Details">
    <cfset action = "smsMaintenanceProcess.cfm?action=edit&id=#url.id#">
    <cfquery name="getSms" datasource="#dts#">
    	SELECT type, title, content, LEFT(schedule, 10) AS scheduledate, MID(schedule, 12, 8) AS scheduletime, race
        FROM smsemail
        WHERE id = "#url.id#" AND category = "SMS" AND is_deleted <> "DELETED"
    </cfquery>
</cfif>

<cfoutput>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>#title#</title>
<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
<!--- <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
<link rel="stylesheet" href="https://raw.githubusercontent.com/Eonasdan/bootstrap-datetimepicker/master/build/css/bootstrap-datetimepicker.min.css"> --->
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript" src="/latest/js/maintenance/target.js"></script>
<!--- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<script src="https://raw.githubusercontent.com/moment/moment/develop/moment.js"></script>
<script src="https://raw.githubusercontent.com/moment/moment/master/locale/id.js"></script>
<script src="https://raw.githubusercontent.com/Eonasdan/bootstrap-datetimepicker/master/build/js/bootstrap-datetimepicker.min.js"></script> --->
</head>

<body>
<div class="container">
	<div class="page-header">
    	<h3>#title#</h3>
    </div>
    <cfform class="form-horizontal" role="form" method="post" action="#action#" enctype="multipart/form-data" onsubmit="
        if(document.getElementById('scheduleDate').value != '' && document.getElementById('scheduleTime').value != ''){
			return true;
		}
        else if(document.getElementById('scheduleDate').value == '' && document.getElementById('scheduleTime').value == ''){
        	return true;
        }
		else if(document.getElementById('scheduleDate').value != '' && document.getElementById('scheduleTime').value == ''){
			alert('Please enter the schedule time.');
			return false;
        }
        else if(document.getElementById('scheduleDate').value == '' && document.getElementById('scheduleTime').value != ''){
			alert('Please enter the schedule date.');
			return false;
		}">
    	<div class="panel">
        	<div class="panel panel-default">
            	<div class="panel-heading" data-toggle="collapse" href="##smsDetail">
          			<h4 class="panel-title accordion-toggle">SMS Details</h4>
        		</div>                
                <div class="panel-collapse collapse in" id="smsDetail" >
          			<div class="panel-body">
                    	<div class="row">
                        	<div class="col-sm-6">
                            	<div class="form-group">
                                	<label class="col-sm-4 control-label" for="desp">Title</label>
                                    <div class="col-sm-8">
                                    	<input type="text" class="form-control" id="title" name="title" placeholder="Title" <cfif #url.action# EQ "edit">value="#getSms.title#"</cfif>>
                                    </div>
                                </div>
                                <div class="form-group">
                                	<label class="col-sm-4 control-label" for="desp">Content</label>
                                    <div class="col-sm-8">
                                    	<textarea id="content" name="content" class="form-control" rows="12" cols="4" placeholder="Content" required><cfif #url.action# EQ "edit">#getSms.content#</cfif></textarea>
                                    </div>
                                </div>
                                <div class="form-group">
                                	<label class="col-sm-4 control-label" for="desp">Schedule</label>
                                    <div class="col-sm-8">
                                    	<cfif #url.action# EQ "create" OR (#url.action# EQ "edit" AND #getSms.type# NEQ "Birthday")>
                                    		<input type="date" class="form-control" id="scheduleDate" name="scheduleDate" <cfif #url.action# EQ "create">value="#DateFormat(Now(), 'yyyy-mm-dd')#"<cfelseif #url.action# EQ "edit">value="#getSms.scheduledate#"</cfif>>
                                        </cfif>
                                        <input type="time"  class="form-control" id="scheduleTime" name="scheduleTime" <cfif #url.action# EQ "create">value=
"#TimeFormat(Now(), 'HH:mm')#"<cfelseif #getSms.type# EQ "Birthday" OR (#url.action# EQ "edit" AND #getSms.scheduletime# NEQ "00:00:00")>value="#TimeFormat(getSms.scheduletime, 'HH:mm')#"</cfif>>
                                    </div>
                                </div>
                                <div class="form-group">
                                	<label class="col-sm-4 control-label" for="race">Race</label>
                                 	<div class="col-sm-8">
                                    	<select class="form-control input-sm" id="race" name="race">
                      						<option value="">Please choose a race</option>
                                            <option value="malay" <cfif #url.action# EQ "edit" AND #getSms.race# EQ "malay">selected</cfif>>Malay</option>
                                            <option value="chinese" <cfif #url.action# EQ "edit" AND #getSms.race# EQ "chinese">selected</cfif>>Chinese</option>
                                            <option value="indian" <cfif #url.action# EQ "edit" AND #getSms.race# EQ "indian">selected</cfif>>Indian</option>
                                            <option value="others" <cfif #url.action# EQ "edit" AND #getSms.race# EQ "others">selected</cfif>>Others</option>
              						    </select>
                                    </div>
                                </div>                                                              
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="pull-right">
			<button type="submit" class="btn btn-primary" id="submit"><cfif #url.action# EQ "create">Create<cfelse>Update</cfif></button>
    		<button type="button" class="btn btn-default" onClick="window.open('smsMaintenance.cfm', '_self')">Cancel</button>
		</div>
    </cfform>
</div>
</body>
</html>
</cfoutput>