<cfquery name="gs_qry2" datasource="payroll_main">
SELECT epleavecal FROM gsetup2 WHERE comp_id ='#HcomID#'
</cfquery>
<cfif gs_qry2.epleavecal eq "dept">
<link rel="shortcut icon" href="/PMS.ico" />
<cfsilent>
 <cfset userid = 1>
	<!--- Include funcitons. --->
	<cfinclude template="/eleave/leave/leavecalendar/includes/_functions.cfm" />
	
	<!--- Include common config setup. --->
	<cfinclude template="/eleave/leave/leavecalendar/_config.cfm" />
	
		
	<!--- Combine FORM and URL scopes into the attributes scope. --->
	<cfset REQUEST.Attributes = StructCopy( URL ) />
	<cfset StructAppend( REQUEST.Attributes, FORM ) />
	
	
	<!--- Param the URL attributes. --->
	<cfparam
		name="REQUEST.Attributes.action"
		type="string"
		default="week"
		/>
				
	
	<!--- Set the default date for this page request. --->
	<cfset REQUEST.DefaultDate = Fix( Now() ) />
	
</cfsilent>
<!--- Figure out which action to include. --->
<cfswitch expression="#REQUEST.Attributes.action#">
		
	<cfcase value="day">
		<cfinclude template="/eleave/leave/leavecalendar/_day.cfm" />
	</cfcase>
	
	<cfcase value="week">
		<cfinclude template="/eleave/leave/leavecalendar/_week.cfm" />
	</cfcase>
	
	<cfcase value="month">
		<cfinclude template="/eleave/leave/leavecalendar/_month.cfm" />
	</cfcase>
	
	<cfcase value="year">
		<cfinclude template="/eleave/leave/leavecalendar/_year.cfm" />
	</cfcase>
	
	<cfdefaultcase>
		<cfinclude template="/eleave/leave/leavecalendar/_week.cfm" />
	</cfdefaultcase>
	
</cfswitch>
<cfelse>
	<h2>You are not allow to view this function. <br>
		Please inform admin to enable this function if there is mistake.</h2>
</cfif>