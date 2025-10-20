<cfsetting showDebugOutput="True">
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Timesheet Approval</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="/css/bootstrap-3.3.7/bootstrap.min.css">
        <link rel="stylesheet" href="/css/dataTables/dataTables_bootstrap.css">
        <link rel="stylesheet" href="/css/bootstrap-3.3.7/bootstrap.min.css">
        <link rel="stylesheet" href="/css/animate-daniel-eden/Animate.css">
        <link rel="stylesheet" href="/css/jquery-confirm-v3.3.0/jquery-confirm.css">
        
        <script type="text/javascript" src="/js/jquery/jquery-3.1.1.min.js"></script> 
        <script src="/js/bootstrap-3.3.7/bootstrap.min.js"></script>
        <script src="/scripts/ajax.js"></script>
        <script type="text/javascript" src="/js/dataTables/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="/js/dataTables/dataTables_bootstrap.js"></script>
        <script type="text/javascript" src="/approval2/TimesheetApprovalMain.js"></script>
        <script src="/js/bootbox-4.4.0/bootbox.min.js"></script>
        <script type="text/javascript" src="/js/bootstrap-notify/bootstrap-notify.js"></script>
        <script type="text/javascript" src="/js/jquery-confirm-v3.3.0/jquery-confirm.js"></script>

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
                /*left: -5%;*/
                left: 10%;
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
                /*left: -22%;*/
                left: 0px;
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
            
            /*loader*/
            .overlay {
                background-color: #e9e9e9;
                opacity: 0.8;
                position: absolute;
                left: 0px;
                top: 0px;
                z-index: 100;
                height: 100%;
                width: 100%;
                overflow: hidden;
                background-image: url('loader.gif');
                background-position: center;
                background-repeat: no-repeat;
            }

            .btn-no {
                width: 100%;
                color: #fff;
                background-color: #d9534f;
                border-color: #d43f3a;
                margin-left: 5px;
            }

            .btn-no:hover {
                color: #fff;
                background-color: #c9302c;
                border-color: #ac2925;
            }

            .btn-na {
                color: #fff;
                background-color: #f0ad4e;
                border-color: #eea236;
                width: 100%;
                margin: 3px;
            }

            .btn-na:hover {
                color: #fff;
                background-color: #ec971f;
                border-color: #d58512;
            }

            .btn-yes {
                color: #fff;
                background-color: #5bc0de;
                border-color: #46b8da;
                width: 100%;
                margin: 3px;
            }

            .btn-yes:hover {
                color: #fff;
                background-color: #31b0d5;
                border-color: #269abc;
            }
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
            
            function getprompt(message, buttonName, statusUpdate, updateType, updateDetails) 
            {
                var selectedid = "";
                
                if (updateType != "Mass"){
                    selectedid = updateDetails;
                }
                else{
                    $('.checks:checked').each(function () {
                        selectedid += this.value + ",";
                    });
                }
                
                $.confirm({
                    title: message,
                    type: 'orange',
                    theme: 'light',
                    typeAnimated: true,
                    useBootstrap: false,
                    boxWidth: '70%',
                    content: function () {
                        var self = this;
                        return $.ajax({
                            url: 'timesheetcheck.cfm', 
                            type: "POST", 
                            data: 
                            {
                                timesheet: selectedid
                            }
                            
                        }).done(function (response) {
                            self.setContent(response);
                        }).fail(function(){
                            self.setContent('Something went wrong.');
                        });
                    },
                    buttons: {
                        tryAgain: {
                            text: buttonName,
                            btnClass: 'btn-orange',
                            action: function(){
                                
                                if (statusUpdate == "Reject")
                                {
                                    var checkempty = $("input.inputText").filter(function () {
                                        return $.trim($(this).val()).length == 0
                                    }).length == 0;
                                    
                                    var textInput = this.$content.find('input.inputText');
                                    if (checkempty == 0) {
                                        $.alert({
                                            title: "Remarks cannot be blank",
                                            content: "Please enter remarks if you are rejecting.",
                                            type: 'red'
                                        });
                                        return false;
                                    }
                                }
                                
                                var theForm = document.getElementById('timesheetForm');
                                
                                if (updateType == 'Mass')
                                {
                                    $('.checks:checked').each(function () {
                                        var input = document.createElement("input");
                                        input.type = "text";
                                        input.name = "remarks_"+this.value;
                                        input.id = "remarks_"+this.value;
                                        theForm.appendChild(input);
                                        document.getElementById('remarks_'+this.value).value = document.getElementById('mgmtremarks_'+this.value).value;
                                    });
                                    
                                    document.getElementById('tsStatus').value = statusUpdate;
                                    loading();
                                    theForm.submit();
                                }
                                else
                                {                                    
                                    loading();                              
                                    window.open('/approval2/TimesheetApprovalProcess.cfm?statusUpdate='+statusUpdate+'&updateDetails='+updateDetails
                                    +'&mgmtremarks='+document.getElementById('mgmtremarks_'+selectedid).value,'_self');
                                }
                            }
                        },
                        Cancel: function () {
                        }
                    }                    
                });
            }
            

            function leaveapprovalcheck(statusUpdate, updateType, updateDetails)
            {
                var dialog = bootbox.dialog({
                title: 'Leave check before timesheet approval',
                message: "<p>Have you approve all the leave submissions for the selected timesheets?</p>"
                +"<p>Kindly approve all the leave submissions related to the selected timesheets prior to approving the timesheets."
                +" The approved leaves will automatically flow to the respective timesheets.</p>"
                +"<br><p><i>Note: Approved leaves will only be reflected in respective timesheets that are not in SUBMITTED or APPROVED status.</i>",
                size: 'null',
                buttons: {
                    cancel: {
                        label: "No, I have not.",
                        className: 'btn-no',
                        callback: function(){
                            $.notify({
                                title: '<strong>Approve leave applications first!</strong><br /><br />',
                                message: 'Please make sure that you have approved all leave submissions related to selected timesheets prior to' 
                                        +' approving the timesheets.'
                                        +'<br><br>The approved leaves will automatically flow to the respective timesheets.',
                                target: '_blank'
                                },{
                                    // settings
                                    element: 'body',
                                    position: null,
                                    type: "warning",
                                    allow_dismiss: true,
                                    placement: {
                                        from: "top",
                                        align: "center"
                                    },
                                    offset: 200,
                                    spacing: 10,
                                    z_index: 1031,
                                    delay: 0,
                                    timer: 1000,
                                    animate: {
                                        enter: 'animated fadeInUp',
                                        exit: 'animated fadeOutUp'
                                    },
                                    template: '<div data-notify="container" class="col-xs-11 col-sm-6 alert alert-{0}" role="alert">' +
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
                           
                        }
                    },
                    noclose: {
                        label: "Associate does not have any leave for this timesheet.",
                        className: 'btn-na',
                        callback: function(){
                                remarksinput(statusUpdate, updateType, updateDetails);
                            
                            return true;
                        }
                    },
                    ok: {
                        label: "Yes, I have approved all the relevant leave submissions.",
                        className: 'btn-yes',
                        callback: function(){
                                remarksinput(statusUpdate, updateType, updateDetails);
                        }
                    }
                }
                });
            }

            function remarksinput(statusUpdate, updateType, updateDetails)
            {
                var remarks = '';
                var promptmessage = '';
                var promptbutton = '';
                if(statusUpdate == "Approve" || statusUpdate == "Cancel"){
                    promptmessage = 'Enter remarks (if any):';
                    if(statusUpdate == "Approve"){
                        promptbutton = "Approve";
                    }
                    else{
                        promptbutton = "Cancel";
                    }
                }
                else{
                    promptmessage = 'Enter reason of rejecting timesheet:';
                    promptbutton = "Reject";
                }
                
                getprompt(promptmessage, promptbutton, statusUpdate, updateType, updateDetails);
                
                /*if(remarks == '' && (statusUpdate == 'Reject' || statusUpdate == 'RejectCancellation'))       //reject and remarks is blank
                {
                    alert('Reason must not be blank.');
                }
                else if(remarks != null)                            //remarks is blank - approving timesheet
                {
                    if(updateType == 'Mass')                        //submit form to mass update
                    {                       
                        document.getElementById('tsStatus').value = statusUpdate;
                        document.getElementById('mgmtremarks').value = remarks;
                        loading();
                        document.getElementById('timesheetForm').submit();
                        
                    }
                    else                                            //single update
                    {                                               
                        loading();
                        window.open('/approval2/TimesheetApprovalProcess.cfm?statusUpdate='+statusUpdate+'&updateDetails='+updateDetails
                                    +'&mgmtremarks='+remarks,'_self');
                    }
                }*/
            }
            
            function switchStatus(newStatus){
                tstatus = newStatus;
                $(".submitbtn").prop('disabled', true);
                $('##checkAllbtn').val("Checked");
                buttonCheck();
                
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
            
            function loading() {
                document.body.scrollTop = 0; // For Safari
                document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
                $("body").css("overflow","hidden");
                $(".overlay").show();
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
                <div class="overlay"></div>
                <div class="checkbox-orange">
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
                            <div class="alert alert-info">
                                <strong>Note!</strong> <br>
                                Please verify submitted information prior to approving/rejecting.<br>
                                <ul>
                                    <li>
                                        Select Asssociate you would like to <strong>Mass Approve / Mass Reject</strong> by clicking on 
                                        <input type="checkbox"><label style="top: 10px"></label>
                                    </li>
                                    <li>
                                        Selected Associate will be marked with&nbsp;
                                        <input type="checkbox" checked><label style="top: 10px"></label>
                                        and you may choose to <strong><i>Mass Approve / Mass Reject</i></strong> accordingly. 
                                        Alternatively, you may use the <strong><i>Check All</i></strong> button to select all in the list.
                                    </li>
                                    <ul>
                                        <li>
                                            <strong>Approval</strong>: You may approve <strong>with or without</strong> indicating any remarks.
                                        </li>
                                        <li>
                                            <strong>Reject</strong>: You <strong>must</strong> input remarks to reject
                                            (for mass rejection function, you may only indicate one reason for all selected items).
                                        </li>
                                    </ul>
                                    <li>
                                        You may still <strong>approve / reject</strong> individual timesheet submission by clicking on 
                                        <span class="glyphicon glyphicon-ok btn btn-link" title="Approve">Approve</span> 
                                        or <span class="glyphicon glyphicon-remove btn btn-link" title="Reject">Reject</span> 
                                    </li>
                                </ul>
                            </div>
                            <form action="TimesheetApprovalProcess.cfm" id="timesheetForm" method="post" target="_self">
                                <button type="button" id="checkAllbtn" class="submitbtn2" name="submitvalue" onclick="buttonCheck()" value="Unchecked" 
                                        style="width: 148px;">
                                    &nbsp;Check All&nbsp;
                                </button> &nbsp;
                                <button type="button" class="submitbtn" name="submitvalue" id="appBtn" value="Approve" style="width: 205px"
                                        onclick="leaveapprovalcheck(this.value, 'Mass')" disabled>
                                    Mass Approve
                                </button> &nbsp;
                                <button type="button" class="submitbtn" name="submitvalue" id="rejBtn" value="Reject" 
                                        onclick="remarksinput(this.value, 'Mass')" disabled>
                                    Mass Reject
                                </button> <br><br>
                                <input type="hidden" id="mgmtremarks" name="mgmtremarks" value="">
                                <input type="hidden" id="tsStatus" name="tsStatus" value="">

                                <table class="table table-bordered table-hover" id="resultTable" style="width:100%; table-layout: fixed">
                                    <thead></thead>
                                    <tbody></tbody>                            
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>
    </body>
</html>