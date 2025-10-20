
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
	
	
	<!--- Just get a pointer to the given date. --->
	<cfset dtThisDay = REQUEST.Attributes.date />
		
	
	<!--- Get the next and previous days. --->
	<cfset dtPrevDay = (dtThisDay - 1) />
	<cfset dtNextDay = (dtThisDay + 1) />
	
	
	<!--- Get the events for this time span. --->
	<cfset objEvents = GetEvents(
		dtThisDay,
		dtThisDay,
		true
		) />
		
		
	<!--- 
		Check to see if this is the default date. If 
		not, then set the default date to be this day.
	--->
	<cfif (dtThisDay NEQ REQUEST.DefaultDate)>
	
		<!--- This we be used when building the navigation. --->
		<cfset REQUEST.DefaultDate = Fix( dtThisDay ) />
		
	</cfif>
		
</cfsilent>

<cfinclude template="includes/_header.cfm">

<cfoutput>
		
	<h2>
		#DateFormat( dtThisDay, "mmmm d, yyyy" )#
	</h2>

	<p id="calendarcontrols">
		&laquo;
		<a href="index.cfm?action=day&amp;date=#Fix( dtPrevDay )#">#DateFormat( dtPrevDay, "mmmm d, yyyy" )#</a> &nbsp;|&nbsp;
		<a href="index.cfm?action=day&amp;date=#Fix( dtNextDay )#">#DateFormat( dtNextDay, "mmmm d, yyyy" )#</a>
		&raquo;
	</p>
	
	<form id="calendarform" action="#CGI.script_name#" method="get">
		
		<input type="hidden" name="action" value="day" />
      
	
		<select name="date">
			<cfloop 
				index="intOffset" 
				from="-20" 
				to="20"
				step="1">
				
				<option value="#Fix(dtThisDay + intOffset)#"
					<cfif (Fix( (dtThisDay + intOffset) ) EQ dtThisDay)>selected="true"</cfif>
					>#DateFormat( Fix(dtThisDay + intOffset), "mmm d, yyyy" )#</option>
					
			</cfloop>
		</select>
		
		<input type="submit" value="Go" />
		
	</form>
	
	
	<table id="calendar" width="100%" cellspacing="1" cellpadding="0" border="0">
	<colgroup>
		<col />
		<col width="100%" />
	</colgroup>
	<tr class="header">
		<td>
			<br />
		</td>
		<td>
			#DateFormat( dtThisDay, "dddd, mmmm d, yyyy" )#
		</td>
	</tr>
	
	
	<!--- 
		Since so much our code depends on the "dtDay" variable,
		and I did copy and paste most of this, just set a pointer
		using the current date.
	--->
	<cfset dtDay = dtThisDay />
				
	
	<tr class="days">
		<td class="header">
			<a href="index.cfm?action=week&amp;date=#dtDay#">&raquo;</a>
		</td>
		<td 
			<cfif (dtDay EQ Fix( Now() ))>
				class="today"
			</cfif>
			>
			
			<!--- <a 
				href="../newcalendar/index.cfm?action=edit&amp;viewas=#dtDay#" 
				title="#DateFormat( dtDay, "mmmm d, yyyy" )#" 
				class="daynumber"
				> --->#Day( dtDay )#<!--- </a> --->
							
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
	</tr>
	<tr class="footer">
		<td colspan="2">
			<br />
		</td>
	</tr>
	</table>
		
</cfoutput>

<cfinclude template="includes/_footer.cfm" />
