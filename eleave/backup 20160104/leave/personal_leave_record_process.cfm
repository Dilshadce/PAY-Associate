<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<cfquery name="gsetup_qry" datasource="payroll_main">
			SELECT COMP_NAME,c_ale FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
		</cfquery>
		<cfquery name="emp_data" datasource="#DSNAME#" >
			SELECT pm.empno,name,nricn,albf,alall,aladj,alcla, mcall,ccall
			FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
		</cfquery>
		<cfquery name="leave_data" datasource="#DSNAME#" >
			SELECT * FROM emp_users as pm LEFT JOIN pleave as pl ON pm.empno = pl.empno WHERE pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
			<cfif form.leaveType neq "ALL">
				AND LVE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.leaveType#"> 	
			</cfif>
				order by lve_date
		</cfquery>
		<!--- calculate balance of leave --->
		<cfset tLVE_DAY_a = 0>
		<cfset tLVE_DAY_MC_a = 0>
		<cfset tLVE_DAY_CC_a = 0>
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "AL">  
				<cfset tLVE_DAY_a= tLVE_DAY_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>
		
			<cfset x = val(emp_data.alall)+val(emp_data.albf)+val(emp_data.aladj)>
		
			
		<cfset bal_AL = x - #val(tLVE_DAY_a)# >
		
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "MC"> 
				<cfset tLVE_DAY_MC_a = tLVE_DAY_MC_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>
		
		<cfset bal_MC = val(emp_data.mcall) - #val(tLVE_DAY_MC_a)#>
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "CC"> 
				<cfset tLVE_DAY_CC_a = tLVE_DAY_CC_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>
		
		<cfset bal_CC = val(emp_data.ccall) - #val(tLVE_DAY_CC_a)#>
		<!--- end calculate balance of leave --->
		<cfoutput>
			<table width="1000px" border="0">
				<tr><th align="center" width="1000px">#gsetup_qry.comp_name#</th></tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<td>
						<table border="0" >
							<tr>
								<td>Employee Number</td>
								<td>:</td>
								<td>#emp_data.empno#</td>
							</tr>
							<tr>
								<td>Name</td>
								<td>:</td>
								<td>#emp_data.name#</td>
							</tr>
							<tr>
								<td>IC</td>
								<td>:</td>
								<td>#emp_data.nricn#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<td>
						<table>
							<tr>
								<cfif form.leaveType eq "ALL" or form.leaveType eq "AL">
								<td>
									<table width="300" border="0">
									 	<tr><th colspan="3">ANNUAL LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(x,'.__')#</td>
											<td >#numberformat(tLVE_DAY_a,'.__')#</td>
											<td >#numberformat(bal_AL,'.__')#</td>
										</tr>
									</table>
								</td>
								</cfif>		
								<cfif form.leaveType eq "ALL" or form.leaveType eq "MC">
									<td>
									<table width="300" border="0">
									 	<tr><th colspan="3">MEDICAL LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(emp_data.mcall,'.__')#</td>
											<td >#numberformat(tLVE_DAY_MC_a,'.__')#</td>
											<td >#numberformat(bal_MC,'.__')#</td>
										</tr>
									</table>
									</td>
								</cfif>
								<cfif form.leaveType eq "ALL" or form.leaveType eq "CC">
									<td><table width="300" border="0">
									 	<tr><th colspan="3">CHILD CARE LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(emp_data.ccall,'.__')#</td>
											<td >#numberformat(tLVE_DAY_cC_a,'.__')#</td>
											<td >#numberformat(bal_cC,'.__')#</td>
										</tr>
									</table></td>
								</cfif>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<table border="0" width="1000px">
						<tr valign="top">
							<td valign="top">
								<table width="1000" border="0" valign="top">
									<tr>
										<td>LEAVE TYPE</td>
										<td>DATE FROM</td>
										<td>DATE TO</td>
										<td>DAY OF LEAVE</td>
										<td>DAY/TIME LEAVE</td>
										<td>TIME LEAVE (FROM)</td>
										<td>TIME LEAVE (TO)</td>
                                        <td>REMARKS</td>
									</tr>
									<tr><td colspan="8"><hr></td></tr>
									
									<cfloop query="leave_data">
										<tr>
											<td>#leave_data.LVE_TYPE#</td>
											<cfinvoke component="cfc.dateformat" method="AppDateFormat" inputDate="#leave_data.LVE_DATE#" returnvariable="cfc_date" />
											<td>#cfc_date#</td>
											<cfinvoke component="cfc.dateformat" method="AppDateFormat" inputDate="#leave_data.LVE_DATE_to#" returnvariable="cfc_date" />
											<td>#cfc_date#</td>
											<td>#leave_data.LVE_DAY#</td>
											<td>#leave_data.LEAVE_OPTION#</td>
											<td align="center">#timeformat(leave_data.timeFr,'HH:MM')#</td>
											<td align="center">#timeformat(leave_data.timeTo,'HH:MM')#</td>
                                            <td>#leave_data.remark#</td>
										</tr>
									</cfloop>
								</table>
							</td>
						</tr>
					</table>
			</tr>
			<tr><td width="100%"><hr></td></tr>
		</table>
	</cfoutput>
	</cfcase>
<!--- start pdf --->
	<cfcase value="EXCELDEFAULT">
		<cfheader name="Content-Type" value="pdf">
		<cfheader name="Content-Disposition" value="attachment; filename=LeaveGivenTaken.pdf">
		<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
			<cfquery name="gsetup_qry" datasource="payroll_main">
			SELECT COMP_NAME,c_ale FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
		</cfquery>
		<cfquery name="emp_data" datasource="#DSNAME#" >
			SELECT pm.empno,name,nricn,albf,alall,aladj,alcla, mcall,ccall
			FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
		</cfquery>
		<cfquery name="leave_data" datasource="#DSNAME#" >
			SELECT * FROM emp_users as pm LEFT JOIN pleave as pl ON pm.empno = pl.empno WHERE pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
			<cfif form.leaveType neq "ALL">
				AND LVE_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.leaveType#"> 	
			</cfif>
				order by lve_date
		</cfquery>
		<!--- calculate balance of leave --->
		<cfset tLVE_DAY_a = 0>
		<cfset tLVE_DAY_MC_a = 0>
		<cfset tLVE_DAY_CC_a = 0>
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "AL">  
				<cfset tLVE_DAY_a= tLVE_DAY_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>

			<cfset x = val(emp_data.albf) + val(emp_data.alall) + val(emp_data.aladj)>
			
		<cfset bal_AL = x - #val(tLVE_DAY_a)# >
		
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "MC"> 
				<cfset tLVE_DAY_MC_a = tLVE_DAY_MC_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>
		
		<cfset bal_MC = val(emp_data.mcall) - #val(tLVE_DAY_MC_a)#>
		
		<cfloop query="leave_data">
			<cfif leave_data.LVE_TYPE eq "CC"> 
				<cfset tLVE_DAY_CC_a = tLVE_DAY_CC_a + val(leave_data.LVE_DAY)>
			</cfif>
		</cfloop>
		
		<cfset bal_CC = val(emp_data.ccall) - #val(tLVE_DAY_CC_a)#>
		<!--- end calculate balance of leave --->
		<cfoutput>
			<table width="1000px" border="0">
				<tr><th align="center" width="1000px">#gsetup_qry.comp_name#</th></tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<td>
						<table border="0" >
							<tr>
								<td>Employee Number</td>
								<td>:</td>
								<td>#emp_data.empno#</td>
							</tr>
							<tr>
								<td>Name</td>
								<td>:</td>
								<td>#emp_data.name#</td>
							</tr>
							<tr>
								<td>IC</td>
								<td>:</td>
								<td>#emp_data.nricn#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<td>
						<table>
							<tr>
								<cfif form.leaveType eq "ALL" or form.leaveType eq "AL">
								<td>
									<table width="300" border="0">
									 	<tr><th colspan="3">ANNUAL LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(x,'.__')#</td>
											<td >#numberformat(tLVE_DAY_a,'.__')#</td>
											<td >#numberformat(bal_AL,'.__')#</td>
										</tr>
									</table>
								</td>
								</cfif>		
								<cfif form.leaveType eq "ALL" or form.leaveType eq "MC">
									<td>
									<table width="300" border="0">
									 	<tr><th colspan="3">MEDICAL LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(emp_data.mcall,'.__')#</td>
											<td >#numberformat(tLVE_DAY_MC_a,'.__')#</td>
											<td >#numberformat(bal_MC,'.__')#</td>
										</tr>
									</table>
									</td>
								</cfif>
								<cfif form.leaveType eq "ALL" or form.leaveType eq "CC">
									<td><table width="300" border="0">
									 	<tr><th colspan="3">CHILD CARE LEAVE<th></tr>	
										<tr>
											<td>GIVEN</td>
											<td>TAKEN</td>
											<td>BALANCE</td>
										</tr>
										<tr>
											<td >#numberformat(emp_data.ccall,'.__')#</td>
											<td >#numberformat(tLVE_DAY_cC_a,'.__')#</td>
											<td >#numberformat(bal_cC,'.__')#</td>
										</tr>
									</table></td>
								</cfif>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td width="100%"><hr></td></tr>
				<tr>
					<table border="0" width="1000px">
						<tr valign="top">
							<td valign="top">
								<table width="1000" border="0" valign="top">
									<tr>
										<td>LEAVE TYPE</td>
										<td>DATE FROM</td>
										<td>DATE TO</td>
										<td>DAY OF LEAVE</td>
										<td>DAY/TIME LEAVE</td>
										<td>TIME LEAVE (FROM)</td>
										<td>TIME LEAVE (TO)</td>
                                        <td>REMARK</td>
									</tr>
									<tr><td colspan="8"><hr></td></tr>
									
									<cfloop query="leave_data">
										<tr>
											<td>#leave_data.LVE_TYPE#</td>
											<cfinvoke component="cfc.dateformat" method="AppDateFormat" inputDate="#leave_data.LVE_DATE#" returnvariable="cfc_date" />
											<td>#cfc_date#</td>
											<cfinvoke component="cfc.dateformat" method="AppDateFormat" inputDate="#leave_data.LVE_DATE_to#" returnvariable="cfc_date" />
											<td>#cfc_date#</td>
											<td>#leave_data.LVE_DAY#</td>
											<td>#leave_data.LEAVE_OPTION#</td>
											<td align="center">#timeformat(leave_data.timeFr,'HH:MM')#</td>
											<td align="center">#timeformat(leave_data.timeTo,'HH:MM')#</td>
                                            <td>#leave_data.remark#</td>
										</tr>
									</cfloop>
								</table>
							</td>
						</tr>
					</table>
			</tr>
			<tr><td width="100%"><hr></td></tr>
		</table>
	</cfoutput>
	<cfoutput>
		<cfdocumentitem type="footer">
			<font size="2">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</font>
		</cfdocumentitem>
		</cfoutput>
		</body>
		</html>
 </cfdocument>
</cfcase>
	
</cfswitch>
