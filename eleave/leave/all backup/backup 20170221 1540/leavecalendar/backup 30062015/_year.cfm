
<!--- Kill extra output. --->
<cfsilent>

	<!--- Param the URL attributes. --->
	<cftry>
		<cfparam
			name="REQUEST.Attributes.date"
			type="numeric"
			default="#REQUEST.DefaultDate#"
			/>
			
		<cfcatch>
			<cfset REQUEST.Attributes.date = REQUEST.DefaultDate />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfparam
			name="URL.year"
			type="numeric"
			default="#Year( REQUEST.Attributes.date )#"
			/>
			
		<cfcatch>
			<cfset URL.year = Year( REQUEST.Attributes.date ) />
		</cfcatch>
	</cftry>

	
	<!---
		Based on the year, let's get the first day of this 
		year. In case the year is not valid, put this in a 
		try / catch.
	--->
	<cftry>
		<cfset dtThisYear = CreateDate( 
			URL.year, 
			1, 
			1 
			) />
		
		<cfcatch>
		
			<!--- 
				If there was an error, just default the year 
				view to be the current month.
			--->
			<cfset dtThisYear = CreateDate(
				Year( REQUEST.DefaultDate ),
				1,
				1
				) />
				
		</cfcatch>
	</cftry>
	
	
	<!--- Get the next and previous year. --->
	<cfset dtPrevYear = DateAdd( "yyyy", -1, dtThisYear ) />
	<cfset dtNextYear = DateAdd( "yyyy", 1, dtThisYear ) />
	
	
	<!--- Get the last day of the year. --->
	<cfset dtLastDayOfYear = (dtNextYear - 1) />
	
	<!--- 
		Now that we have the first day of the year, let's get
		the first day of the calendar year - this is the first
		graphical day of the calendar page, which may be in the
		previous year (date-wise).
	--->
	<cfset dtFirstDay = (
		dtThisYear - 
		DayOfWeek( dtThisYear ) + 
		1
		) />
		
	<!--- 
		Get the last day of the calendar year. This is the last
		graphical day of the calendar page, which may be in the 
		next year (date-wise).
	--->
	<cfset dtLastDay = (
		dtLastDayOfYear + 
		7 - 
		DayOfWeek( dtLastDayOfYear )
		) />
		
	
	<!--- Get the events for this time span. --->
	<cfset objEvents = GetEvents(
		dtFirstDay,
		dtLastDay
		) />
		
		
	<!--- 
		Set the default date to be this year but only if the 
		current year does NOT contain the current date.
	--->
	<cfif (Year( dtThisYear ) NEQ Year( REQUEST.DefaultDate ))>
	
		<!--- This we be used when building the navigation. --->
		<cfset REQUEST.DefaultDate = Fix( dtThisYear ) />
				
	</cfif>
	
</cfsilent>

<cfinclude template="/eleave/leave/leavecalendar/includes/_header.cfm">

<cfoutput>
		
	<h2>
		#Year( dtThisYear )#
	</h2>

	<p id="calendarcontrols">
		&laquo;
		<a href="/eleave/leave/leavecalendar/index.cfm?action=year&amp;date=#Fix( dtPrevYear )#">#DateFormat( dtPrevYear, "yyyy" )#</a> &nbsp;|&nbsp;
		<a href="/eleave/leave/leavecalendar/index.cfm?action=year&amp;date=#Fix( dtNextYear )#">#DateFormat( dtNextYear, "yyyy" )#</a>
		&raquo;
	</p>
	
	<form id="calendarform" action="#CGI.script_name#" method="get">
	
		<input type="hidden" name="action" value="year" />
        
		
		<select name="year">
			<cfloop 
				index="intYear" 
				from="#(Year( dtThisYear ) - 5)#" 
				to="#(Year( dtThisYear ) + 5)#"
				step="1">
				
				<option value="#intYear#"
					<cfif (Year( dtThisYear ) EQ intYear)>selected="true"</cfif>
					>#intYear#</option>
					
			</cfloop>		
		</select>
		
		<input type="submit" value="Go" />
		
	</form>
	
	
	<table id="calendar" width="100%" cellspacing="1" cellpadding="0" border="0">
	<colgroup>
		<col />
		<col width="10%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="16%" />
		<col width="10%" />
	</colgroup>
	<tr class="header">
		<td>
			<br />
		</td>
		<td>
			Sunday
		</td>
		<td>
			Monday
		</td>
		<td>
			Tuesday
		</td>
		<td>
			Wednesday
		</td>
		<td>
			Thursday
		</td>
		<td>
			Friday
		</td>
		<td>
			Saturday
		</td>
	</tr>
	
	<!--- Loop over all the days. --->
	<cfloop 
		index="dtDay"
		from="#dtFirstDay#"
		to="#dtLastDay#"
		step="1">
	
		<!--- 
			If we are on the first day of the week, then 
			start the current table fow.
		--->
		<cfif ((DayOfWeek( dtDay ) MOD 7) EQ 1)>
			<tr class="days">
				<td class="header">
					<a href="/eleave/leave/leavecalendar/index.cfm?action=week&amp;date=#dtDay#">&raquo;</a>
				</td>
		</cfif>
		
		<td 
			<cfif (dtDay EQ Fix( Now() ))>
				class="today"
			<cfelseif NOT (Month( dtDay ) MOD 2)>
				class="other"
			</cfif>
			>
			<!--- <a 
				href="/projectcalendar/index.cfm?action=edit&amp;viewas=#dtDay#" 
				title="#DateFormat( dtDay, "mmmm d, yyyy" )#" 
				class="daynumber<cfif (Day( dtDay ) EQ 1)>full</cfif>"
				> ---><cfif (Day( dtDay ) EQ 1)>#MonthAsString( Month( dtDay ) )#&nbsp;</cfif>#Day( dtDay )#<br /><!--- </a> --->
							
			<!--- 
				Since query of queries are expensive, we 
				only want to get events on days that we 
				KNOW have events. Check to see if there 
				are any events on this day. 
			--->
                <cfquery datasource="#dsname#" name="leavelist">
                	select * FROM pleave as a 
                    LEFT JOIN (select empno, name from pmast) as b
                    on a.empno = b.empno
                    where lve_date <= '#dateformat(dtDay,'YYYY-MM-DD')#' 
                    AND lve_date_to >= '#dateformat(dtDay,'YYYY-MM-DD')#'
                </cfquery>
                
				<!--- Loop over events. --->
                <table>
				<cfloop query="leavelist">
				<tr>
						<cfif currentRow mod 2 eq 0>
                            <td class="bg" style="background-color:##F9F">
                        <cfelse>
                            <td class="bg" style="background-color:##6FC">
                        </cfif>
						#leavelist.name# is on #leavelist.lve_type#
						<!--- Check for repeat type. --->
                        </td>
                    </td>
				</cfloop>
                </table>
		</td>				
		
		<!--- 
			If we are on the last day, then close the 
			current table row. 
		--->
		<cfif NOT (DayOfWeek( dtDay ) MOD 7)>
			</td>
		</cfif>
		
	</cfloop>
	
	<tr class="footer">
		<td colspan="8">
			<br />
		</td>
	</tr>
	</table>
		
</cfoutput>

<cfinclude template="/eleave/leave/leavecalendar/includes/_footer.cfm" />
