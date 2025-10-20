<cfsetting showdebugoutput="True" requesttimeout="0">
<html>

    <head>
        <title>Leave Entitlement</title>
        <link rel="stylesheet" href="/css/bootstrap-3.3.7/bootstrap.min.css">
        <script type="text/javascript" src="/js/jquery/jquery-3.1.1.min.js"></script>
        
        <style>
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
            
            .submitbtn:active
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
            
            #myBtn {
                display: none; /* Hidden by default */
                position: fixed; /* Fixed/sticky position */
                bottom: 20px; /* Place the button at the bottom of the page */
                right: 30px; /* Place the button 30px from the right */
                z-index: 99; /* Make sure it does not overlap */
                border: none; /* Remove borders */
                outline: none; /* Remove outline */
                background-color: red; /* Set a background color */
                color: white; /* Text color */
                cursor: pointer; /* Add a mouse pointer on hover */
                padding: 15px; /* Some padding */
                border-radius: 10px; /* Rounded corners */
                font-size: 18px; /* Increase font size */
            }

            #myBtn:hover {
                background-color: ##555; /* Add a dark-grey background on hover */
            }
            
            th {
                text-align: center;
            }
            
            .not-selected {
                cursor: not-allowed;
            }
            
            .initialinput[type=checkbox] + label:before {
                cursor: not-allowed;
            } 
            
            .initialinput[type=checkbox] + label {
                cursor: not-allowed;
            }
            
            .overlay {
                background-color: #e9e9e9;
                opacity: 0.8;
                position: absolute;
                left: 0px;
                top: 0px;
                z-index: 100%;
                height: 100%;
                width: 100%;
                overflow: hidden;
                background-image: url('loader.gif');
                background-position: center;
                background-repeat: no-repeat;
            }
        </style>
        
        <script>
            $(document).ready(function(){
                $('.inputselect').prop('disabled', true);
            });
            
            // When the user scrolls down 20px from the top of the document, show the button
            window.onscroll = function() {scrollFunction()};

            function scrollFunction() {
                if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                    document.getElementById("myBtn").style.display = "block";
                } else {
                    document.getElementById("myBtn").style.display = "none";
                }
            }

            // When the user clicks on the button, scroll to the top of the document
            function topFunction() {
                document.body.scrollTop = 0; // For Safari
                document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
            }
            
            function checkAll(){
                if($('#checkall').prop("checked") == true){
                    $(".selectcheck").prop("checked", true);
                    $('tr:has(td)').addClass('warning');
                    $('.inputselect').removeClass('initialinput');
                    $('.inputselect').prop('disabled', false);
                    $('.active').removeClass('not-selected');
                }
                else{
                    $(".selectcheck").prop("checked", false);
                    $('tr:has(td)').removeClass('warning');
                    $('.inputselect').addClass('initialinput');
                    $('.inputselect').prop('disabled', true);
                    $('.active').addClass('not-selected');
                }
                checkTheBox();
            }
            
            function rowselect(rrow, pno){
                document.getElementById('tabble').rows[rrow].classList.toggle('warning');
                document.getElementById('tabble').rows[rrow].classList.toggle('not-selected');
                $('#entitle_'+pno).toggleClass('initialinput');
                $('#entitle_'+pno).prop('disabled', !$('#entitle_'+pno).prop('disabled'));
                $('#days_'+pno).toggleClass('initialinput');
                $('#days_'+pno).prop('disabled', !$('#days_'+pno).prop('disabled'));
                checkTheBox();
            }
            
            function checkTheBox() {
                if($('.selectcheck:checked').val() == undefined){
                    $(".submitbtn").prop('disabled', true);
                }
                else{
                    $(".submitbtn").prop('disabled', false);    
                }
            }
            
            function loading() {
                document.body.scrollTop = 0; // For Safari
                document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
                $("body").css("overflow","hidden");
                $(".overlay").show();
            }
        </script>
    </head>
    <body>
        <cfoutput>
            <cfquery name="getJO" datasource="#Replace(dts, '_p', '_i')#">
                SELECT placementno, empno, empname, startdate, completedate, rlentitle, 
                CASE WHEN IFNULL(rldays, 0) = '' THEN 0 ELSE IFNULL(rldays, 0) END AS rldays 
                FROM placement WHERE hrmgr = "#getHQstatus.entryid#"
                AND jobstatus = "2"
                ORDER BY empname, startdate DESC
            </cfquery>

            <h3>Replacement Leave Entitlement</h3> <hr/>
            <div class="container">
                <div class="overlay" style="display: none;"></div>
                <div class="checkbox-orange">
                    <div class="alert alert-info">
                        <strong>Note!</strong> <br>
                        <ul>
                            <li>
                                Select asssociate that you would like to update the replacement leave entitlement by clicking on 
                                <input type="checkbox"><label style="top: 10px"></label>
                            </li>
                            <li>
                                Selected associate will be marked with&nbsp;
                                <input type="checkbox" checked><label style="top: 10px"></label>
                                Then edit his/her <strong>replacement leave entitled</strong> and <strong>replacement leave days.</strong>
                            </li>
                            <li>
                                Replacement leave entitled <input type="checkbox" checked><label style="top: 10px"></label>: 
                                Associate will <strong>be able</strong> to see/use/apply replacement leave.
                            </li>
                            <li>
                                Replacement leave entitled <input type="checkbox"><label style="top: 10px"></label>: 
                                Associate will <strong>not be able</strong> to see/use/apply replacement leave.
                            </li>
                            <li>
                                Replacement leave Days: This is the <strong>total number of days</strong> associate is entitled to.
                            </li>
                        </ul>
                    </div>
                    <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
                    <form action="leaveentitlementprocess.cfm" target="_self" method="post">
                        <button type="submit" class="submitbtn" name="submitvalue" id="update" value="Update" style="width: 205px" disabled onclick="loading();">
                            Update
                        </button><br><br>

                        <table id='tabble' class="table table-bordered table-responsive">
                            <tr>
                                <th><input type="checkbox" id="checkall" value="checkall" onclick="checkAll()"><label for="checkall"></label></th>
                                <th>No</th>
                                <th>Placement</th>
                                <th>Empno</th>
                                <th>Name</th>
                                <th>Contract Start Date</th>
                                <th>Contract End Date</th>
                                <th>Replacement Leave Entitled</th>
                                <th>Replacement Leave Days</th>
                            </tr>
                            <cfloop query="getJO">
                                <tr class="active not-selected">
                                    <td>
                                        <input class="selectcheck" type="checkbox" id="Row_#getJO.currentrow#" value="#getJO.placementno#" name="checkerlist"
                                               onclick="rowselect('#getJO.currentrow#', '#getJO.placementno#')">
                                        <label for="Row_#getJO.currentrow#"></label>
                                    </td>
                                    <td>#getJO.currentrow#</td>
                                    <td>#getJO.placementno#</td>
                                    <td>#getJO.empno#</td>
                                    <td>#getJO.empname#</td>
                                    <td>#DateFormat(getJO.startdate, 'yyyy-mm-dd')#</td>
                                    <td>#DateFormat(getJO.completedate, 'yyyy-mm-dd')#</td>
                                    <td style="text-align: center;">
                                        <input name="entitle_#getJO.placementno#" class="inputselect initialinput" type="checkbox" 
                                               id="entitle_#getJO.placementno#" <cfif "#getJO.rlentitle#" EQ "Y">checked</cfif>>
                                        <label for="entitle_#getJO.placementno#"></label>
                                    </td>
                                    <td>
                                        <input name="days_#getJO.placementno#" type="number" class="form-control center-block text-center inputselect initialinput" 
                                               value="#getJO.rldays#" step=".5" style="width: 70px;" id="days_#getJO.placementno#" min=0>
                                    </td>
                                </tr>
                            </cfloop>
                        </table>
                    </form>
                </div>
            </div>
        </cfoutput>
    </body>
</html>