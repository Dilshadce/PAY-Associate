
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
	
	
	<!--- Based on the date, let's get the first day of this week. --->
	<cftry>
		<cfset dtThisWeek = (
			REQUEST.Attributes.date - 
			DayOfWeek( REQUEST.Attributes.date ) +
			1 
			) />
		
		<cfcatch>
		
			<!--- 
				If there was an error, just default the week 
				view to be the current week.
			--->
			<cfset dtThisWeek = (
				REQUEST.DefaultDate -
				DayOfWeek( REQUEST.DefaultDate ) +
				1
				) />
				
		</cfcatch>
	</cftry>
	
	
	<!--- Get the next and previous weeks. --->
	<cfset dtPrevWeek = DateAdd( "ww", -1, dtThisWeek ) />
	<cfset dtNextWeek = DateAdd( "ww", 1, dtThisWeek ) />
	
	
	<!--- Get the last day of the week. --->
	<cfset dtLastDayOfWeek = (dtNextWeek - 1) />
	
	<!--- 
		Now that we have the first day of the week, let's get
		the first day of the calendar month - this is the first
		graphical day of the calendar page, which may be in the
		previous month (date-wise).
	--->
	<cfset dtFirstDay = dtThisWeek />
	<cfset dtLastDay = dtLastDayOfWeek />
		
	
	<!--- Get the events for this time span. --->
	<cfset objEvents = GetEvents(
		dtFirstDay,
		dtLastDay
		) />
		
		
	<!--- 
		Check to see if this week contains the default date. 
		If not, then set the default date to be this week.
	--->
	<cfif (
		(Year( dtThisWeek ) NEQ Year( REQUEST.DefaultDate )) OR
		(Month( dtThisWeek ) NEQ Month( REQUEST.DefaultDate )) OR
		(Week( dtThisWeek ) NEQ Week( REQUEST.DefaultDate ))
		)>
	
		<!--- This we be used when building the navigation. --->
		<cfset REQUEST.DefaultDate = Fix( dtThisWeek ) />
		
	</cfif>
		
</cfsilent>

<cfinclude template="/eleave/leave/leavecalendar/includes/_header.cfm">

<cfoutput>
		
	<h2>
		Week Of #DateFormat( dtThisWeek, "mmmm d, yyyy" )#
	</h2>

	<p id="calendarcontrols">
		&laquo;
		<a href="/eleave/leave/leavecalendar/index.cfm?action=week&amp;date=#Fix( dtPrevWeek )#">#DateFormat( dtPrevWeek, "mmmm d, yyyy" )#</a> &nbsp;|&nbsp;
		<a href="/eleave/leave/leavecalendar/index.cfm?action=week&amp;date=#Fix( dtNextWeek )#">#DateFormat( dtNextWeek, "mmmm d, yyyy" )#</a>
		&raquo;
	</p>
	
	<form id="calendarform" action="#CGI.script_name#" method="get">
		
		<input type="hidden" name="action" value="week" />
		
		<select name="date">
			<cfloop 
				index="intOffset" 
				from="-20" 
				to="20"
				step="1">
				
				<option value="#Fix( DateAdd( "ww", intOffset, dtThisWeek ) )#"
					<cfif (Fix( DateAdd( "ww", intOffset, dtThisWeek ) ) EQ dtThisWeek)>selected="true"</cfif>
					>#DateFormat( DateAdd( "ww", intOffset, dtThisWeek ), "mmm d, yyyy" )#</option>
					
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
					<a href="/eleave/leave/leavecalendar/index.cfm?action=month&amp;date=#dtDay#">&raquo;</a>
				</td>
		</cfif>
		
		<td 
			<cfif (
				(Month( dtDay ) NEQ Month( dtThisWeek )) OR
				(Year( dtDay ) NEQ Year( dtThisWeek ))
				)>
				class="other"
			<cfelseif (dtDay EQ Fix( Now() ))>
				class="today"
			</cfif>
			>
			<cfif (Day( dtDay ) EQ 1)>#MonthAsString( Month( dtDay ) )#&nbsp;</cfif>#Day( dtDay )# <br />
							
			<!--- 
				Since query of queries are expensive, we 
				only want to get events on days that we 
				KNOW have events. Check to see if there 
				are any events on this day. 
			--->
			
				
				<!--- Query for events for the day. --->
				<cfquery datasource="#dsname#" name="leavelist">
                	SELECT name,lve_type FROM pleave as a 
                    LEFT JOIN (select empno, name,deptcode from pmast) as b
                    on a.empno = b.empno
                    WHERE lve_date <= '#dateformat(dtDay,'YYYY-MM-DD')#' 
                    AND lve_date_to >= '#dateformat(dtDay,'YYYY-MM-DD')#'
                    AND deptcode = (
                    SELECT deptcode FROM pmast a LEFT JOIN emp_users b on a.empno = b.empno 
                    WHERE username='#GetAuthUser()#'
                    )
 					UNION ALL
					SELECT "holiday" as entryno,hol_desp FROM holtable 
                    WHERE hol_date <= '#dateformat(dtDay,'YYYY-MM-DD')#' 
                    AND hol_date  >= '#dateformat(dtDay,'YYYY-MM-DD')#' 
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
                        <cfif leavelist.name eq "holiday">
                        #leavelist.lve_type#
                        <cfelse>
						#leavelist.name# is on #leavelist.lve_type#
                        </cfif>
                        <!--- Check for repeat type. --->
                    	</td>
                    </tr>
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
