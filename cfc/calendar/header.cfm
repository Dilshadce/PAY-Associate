
<script type="text/javascript" src="/projectcalendar/linked/global.js"></script>
	<link rel="stylesheet" type="text/css" href="/projectcalendar/linked/content.css"></link>
		<link rel="stylesheet" type="text/css" href="/projectcalendar/linked/meta_content.css"></link>
		<link rel="stylesheet" type="text/css" href="/projectcalendar/linked/structure.css"></link>
        <link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<!--- <h3 style="margin-left:10px">#getAuthUser()#'s Time Schedule<br />
 
		<cfif save.recordcount neq 0> <cfloop query="save">#SAVE.otherContact# Time Schedule<br />
</cfloop></cfif> </h3> --->
        
		<!-- BEGIN: Site Header. -->
		<div id="siteheader" <!--- <cfif dts eq 'coolnlite_c' or dts eq 'imperial1_c'>style="margin-left:-45px;"</cfif> --->>
			
			
			<ul id="primarynav">
                <!---user control--->
				<li class="nav1">
					<a href="dutyCalendar.cfm" <cfif (cgi.SCRIPT_NAME EQ "/calendar/dutyCalendar.cfm")>class="on"</cfif> >Duty Roster Calendar Report</a>
				</li>
       
				<li class="nav2">
					<a href="assignDuty.cfm" <cfif (cgi.SCRIPT_NAME EQ "/calendar/assignDuty.cfm")>class="on"</cfif>>Roster Duty Assignation</a>
				</li>
                   <li class="nav3">
					<a href="Tasklist.cfm" <cfif (cgi.SCRIPT_NAME EQ "/calendar/tasklist.cfm")>class="on"</cfif>>Duty Type</a>
				</li>   
                
       
                   <li class="nav4">
					<a href="summaryreport.cfm" <cfif (cgi.SCRIPT_NAME EQ "/calendar/tasklist.cfm")>class="on"</cfif>>Summary Report</a>
				</li>        
               
			</ul>
		
		</div>