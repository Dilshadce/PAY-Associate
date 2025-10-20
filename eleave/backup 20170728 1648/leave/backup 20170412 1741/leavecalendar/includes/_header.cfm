<cfoutput>

	<!--- Reset buffer and set content type. --->
<!--- 	<cfcontent
		type="text/html"
		reset="true"
		/> --->
	
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html>
	<head>
	
		
		<!-- Linked files. -->
		<script type="text/javascript" src="/eleave/leave/leavecalendar/linked/global.js"></script>
	<link rel="stylesheet" type="text/css" href="/eleave/leave/leavecalendar/linked/content.css"></link>
    <link rel="stylesheet" type="text/css" href="/eleave/leave/leavecalendar/linked/meta_content.css"></link>
    <link rel="stylesheet" type="text/css" href="/eleave/leave/leavecalendar/linked/structure.css"></link>
    <script src="/javascripts/CalendarControl.js" language="javascript"></script>
    <link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<h3 style="margin-left:10px">Leave Calendar</h3>
		<!-- BEGIN: Site Header. -->
		<div id="siteheader">
			
			
			<ul id="primarynav">
				<li class="nav1">
					<a href="/eleave/leave/leavecalendar/index.cfm?action=year&amp;date=#REQUEST.DefaultDate#" <cfif (REQUEST.Attributes.action EQ "year")>class="on"</cfif>>Year View</a>
				</li>
				<li class="nav2">
					<a href="/eleave/leave/leavecalendar/index.cfm?action=month&amp;date=#REQUEST.DefaultDate#" <cfif (REQUEST.Attributes.action EQ "month")>class="on"</cfif>>Month View</a>
				</li>
				<li class="nav3">
					<a href="/eleave/leave/leavecalendar/index.cfm?action=week&amp;date=#REQUEST.DefaultDate#" <cfif (REQUEST.Attributes.action EQ "week")>class="on"</cfif>>Week View</a>
				</li>
				<li class="nav4">
					<a href="/eleave/leave/leavecalendar/index.cfm?action=day&amp;date=#REQUEST.DefaultDate#" <cfif (REQUEST.Attributes.action EQ "day")>class="on"</cfif>>Day View</a>
				</li>
<!--- 				<li class="nav5">
					<a href="/newcalendar/index.cfm?action=edit&amp;date=#REQUEST.DefaultDate#" <cfif (REQUEST.Attributes.action EQ "edit")>class="on"</cfif>>Add New Event</a>
				</li> --->
			</ul>
		
		</div>
		<!-- END: Site Header. -->
	
		
		<!-- BEGIN: Site Content. -->
		<div id="sitecontent">
			<div class="buffer">

</cfoutput>