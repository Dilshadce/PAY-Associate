<cfsetting showDebugOutput="True">
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Timesheet Approval</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/css/bootstrap-3.3.7/bootstrap.min.css">
        <link rel="stylesheet" href="/css/dataTables/dataTables_bootstrap.css">
        
        <script type="text/javascript" src="/js/jquery/jquery-3.1.1.min.js"></script> 
        <script src="/js/bootstrap-3.3.7/bootstrap.min.js"></script>
        <script src="/scripts/ajax.js"></script>
        <script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="/js/dataTables/dataTables_bootstrap.js"></script>
        <script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
        <script type="text/javascript" src="/approval2/TimesheetApprovalMain.js"></script>

        <style>
            .nav-tabs > li.active > a,
            .nav-tabs > li.active > a:hover,
            .nav-tabs > li.active > a:focus {
                background-color: #FF8800;
                color: white;
            }
            
            .glyphicon,
            .glyphicon:hover {
                color: #e77e22;
            }
            
            .table-hover > tbody > tr:hover {
                background-color: #f3bd90;
            }

            a {
                color: black;
            }
            
            .overlay {
                background: #e9e9e9;  
                display: none;        
                position: absolute;   
                top: 0;                  
                right: 0;                
                bottom: 0;
                left: 0;
                opacity: 0.5;
            }
            
            /* checkbox styling*/
            .checkbox-orange [type=checkbox] {
                position: absolute;
                left: -9999px;
                visibility: hidden
            }

            .checkbox-orange [type=checkbox] + label{
                position: relative;
                padding-left: 35px;
                cursor: pointer;
                display: inline-block;
                height: 25px;
                line-height: 25px;
                font-size: 1rem
            }

            .checkbox-orange [type=checkbox] + label:before {
                content: "";
                position: absolute;
                top: 0;
                left: 15%;
                width: 17px;
                height: 17px;
                z-index: 0;
                border: 1.5px solid #8a8a8a;
                -webkit-border-radius: 1px;
                border-radius: 1px;
                margin-top: 2px;
                -webkit-transition: .2s;
                -o-transition: .2s;
                transition: .2s
            }

            .checkbox-orange [type=checkbox]:checked + label:before {
                top: -4px;
                left: 3%;
                width: 12px;
                height: 22px;
                border-style: solid;
                border-width: 2px;
                border-color: transparent #FF8800 #FF8800 transparent;
                -webkit-transform: rotate(40deg);
                -ms-transform: rotate(40deg);
                transform: rotate(40deg);
                -webkit-transform-origin: 100% 100%;
                -ms-transform-origin: 100% 100%;
                transform-origin: 100% 100%
            }
            /* checkbox styling*/
            
            /*button styling*/
            .submitbtn, .submitbtn2 {
                outline: none;
                border: none;
                display: inline-block;
                position: relative;
                cursor: pointer;
                background-color: #FF8800;
                font-size: 16px;
                font-weight: 300px;
                color: white;
                text-transform: capitalize;
                letter-spacing: 2px;
                padding: 6px 20px;
                border-radius: 20px;
                -webkit-box-shadow: 0 4px #f2870d;
                        box-shadow: 0 4px #f2870d;
            }
            
            .submitbtn:hover,
            .submitbtn2:hover {
                -webkit-box-shadow: 0 2px #f2870d;
                        box-shadow: 0 2px #f2870d;
                top: 3px;
            }
            
            .submitbtn:active,
            .submitbtn2:active {
                -webkit-box-shadow: none;
                        box-shadow: none;
                top: 5px;
            }
            
            .submitbtn:disabled:hover,
            .submitbtn2:disabled:hover {
                cursor: not-allowed;
            }
            
            .submitbtn:disabled,
            .submitbtn2:disabled {
                background-color: #A9A9A9;
                -webkit-box-shadow: 0 3px #989898;
                        box-shadow: 0 3px #989898;
            }
            /*button styling*/
        </style>
        
        <cfoutput>
        <script type="text/javascript">
            var dts='#dts#';
            var targetTable='timesheet';
            var huserid = '#getHQstatus.entryid#';
            var tstatus = 'Submitted For Approval';
            
            function checkTheBox() {
                if($('.checks:checked').val() == undefined){
                    $(".submitbtn").prop('disabled', true);
                }
                else{
                    $(".submitbtn").prop('disabled', false);    
                }
            }
            
            function remarksinput(statusUpdate, updateType, updateDetails)
            {
                var remarks = '';
                var promptmessage = '';
                if(statusUpdate == "Approve" || statusUpdate == "Cancel"){
                    promptmessage = 'Enter remarks (if any):';
                }
                else{
                    promptmessage = 'Enter reason of rejecting timesheet:';
                }
                
                remarks = prompt(promptmessage);
                
                if(remarks == '' && (statusUpdate == 'Reject' || statusUpdate == 'RejectCancellation'))       //reject and remarks is blank
                {
                    alert('Reason must not be blank.');
                }
                else if(remarks != null)                            //remarks is blank - approving timesheet
                {
                    if(updateType == 'Mass')                        //submit form to mass update
                    {                       
                        document.getElementById('tsStatus').value = statusUpdate;
                        document.getElementById('mgmtremarks').value = remarks;
                        document.getElementById('timesheetForm').submit();
                    }
                    else                                            //single update
                    {                                               
                        window.open('/approval2/TimesheetApprovalProcess.cfm?statusUpdate='+statusUpdate+'&updateDetails='+updateDetails
                                    +'&mgmtremarks='+remarks,'_self');
                    }
                }
            }
            
            function switchStatus(newStatus){
                tstatus = newStatus;
                $(".submitbtn").prop('disabled', true);
                
                if(newStatus != "Submitted For Approval" && newStatus != "Submitted For Cancellation"){
                    $(".submitbtn2").prop('disabled', true);
                }
                else{
                    $(".submitbtn2").prop('disabled', false);
                }
                
                if(newStatus == "Submitted For Cancellation")
                {
                    $("##appBtn").html('Mass Cancellation');
                    $("##appBtn").prop('value', 'Cancel');
                    $("##rejBtn").prop('value', 'RejectCancellation');
                }
                else{
                    $("##appBtn").html('Mass Approve');
                    $("##appBtn").prop('value', 'Approve');
                    $("##rejBtn").prop('value', 'Reject');
                }
                
                datatableEngage();
            }
            
            function buttonCheck(){
                
                if($('##checkAllbtn').val() == 'Unchecked')
                {
                    $(".checks").prop("checked", true);
                    $("##checkAllbtn").html('Uncheck All');
                    $("##checkAllbtn").prop('value', 'Checked');
                    checkTheBox();
                }
                else
                {
                    $(".checks").prop("checked", false);
                    $("##checkAllbtn").html('Check All');
                    $("##checkAllbtn").prop('value', 'Unchecked');
                    checkTheBox();
                }
            }
        </script>
        </cfoutput>
    </head>

    <body>
        <cfoutput>
            <cfset approvedName = "Approved">
            <cfset rejectedName = "Rejected">
            <cfset cancelledName = "Cancelled">
            <cfset pendingName = "Submitted For Approval">
            <cfset cancelName = "Submitted For Cancellation">
                
            <div class="container">
                <br />
                <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" onclick="switchStatus('#pendingName#');">#pendingName#</a></li>
                    <li><a data-toggle="tab" onclick="switchStatus('#cancelName#');">#cancelName#</a></li>
                    <li><a data-toggle="tab" onclick="switchStatus('#approvedName#');">#approvedName#</a></li>
                    <li><a data-toggle="tab" onclick="switchStatus('#rejectedName#');">#rejectedName#</a></li>
                    <li><a data-toggle="tab" onclick="switchStatus('#cancelledName#');">#cancelledName#</a></li>
                </ul>

                <div class="tab-content">
                    <div id="home" class="tab-pane fade in active">
                        <br />
                        <form action="TimesheetApprovalProcess.cfm" id="timesheetForm" method="post" target="_self">
                            <button type="button" id="checkAllbtn" class="submitbtn2" name="submitvalue" onclick="buttonCheck()" value="Unchecked" 
                                    style="width: 148px;">
                                &nbsp;Check All&nbsp;
                            </button> &nbsp;
                            <button type="button" class="submitbtn" name="submitvalue" id="appBtn" value="Approve" style="width: 205px"
                                    onclick="remarksinput(this.value, 'Mass')" disabled>
                                Mass Approve
                            </button> &nbsp;
                            <button type="button" class="submitbtn" name="submitvalue" id="rejBtn" value="Reject" 
                                    onclick="remarksinput(this.value, 'Mass')" disabled>
                                Mass Reject
                            </button> <br><br>
                            <input type="hidden" id="mgmtremarks" name="mgmtremarks" value="">
                            <input type="hidden" id="tsStatus" name="tsStatus" value="">
                            
                            <div class="checkbox-orange">
                                <table class="table table-bordered table-hover" id="resultTable" style="width:100%; table-layout: fixed">
                                    <thead></thead>
                                    <tbody></tbody>                            
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>