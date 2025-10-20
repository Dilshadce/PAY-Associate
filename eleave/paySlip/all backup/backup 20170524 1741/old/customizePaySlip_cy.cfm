<cfquery name="Clear_temp_cuz_payslip" datasource="#dsname#">
  DELETE FROM temp_cuz_payslip WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>
<cfset month_value = form.month1>
<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="selectList" datasource="#dsname#">
SELECT * FROM pay_12m WHERE TMONTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(month_value)#"> and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
</cfquery>


<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,month_value,1)>
<cfset month1= dateformat(date,'mmmm')>
<cfset year1= dateformat(date,'yyyy')>

	<cfquery name="select_data" datasource="#dsname#">
	SELECT * FROM pay_12m AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#"> and TMONTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(month_value)#">
	</cfquery>
	<cfquery name="select_ytd" datasource="#dsname#">
	SELECT * FROM pay_ytd AS ytd LEFT JOIN pmast AS pm ON ytd.empno = pm.empno WHERE pm.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
	</cfquery>
	<cfquery name="select_pay_12m" datasource="#dsname#">
	SELECT sum(coalesce(al,0)) as sum_al, sum(coalesce(mc,0)) as sum_mc FROM pay_12m  WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#"> and tmonth < <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(month_value)#">
	</cfquery>
	
	<cfset awname = "">
	<cfset awdata = 0>
	<cfset awamt = "">
	<cfset dedname = "">
	<cfset dedamount = "">
	<cfset otdesp = "">
	<cfset otunit = "">
	<cfset othr = "">
	<cfset otamt = "">
	<cfset totawamt = 0>
	<cfset tot_dedamt = 0>
	<cfset tot_otamt = 0>
	<cfset advance1 = val(select_data.advance)>
	<cfset advance = #numberformat(advance1,'.__')#>
	<cfset YTD_AL = val(select_pay_12m.sum_al) + val(select_data.al)>
	<cfset YTD_MC = val(select_pay_12m.sum_mc)+ val(select_data.MC)>
	
	<cfloop from="1" to="17" index="i">
		<cfset awvar = 100 + i>
		<cfset awvar2 = "AW"&awvar>
		<cfset awdata = select_data[awvar2]>
		
		<cfif awdata neq 0>
			<cfquery name="get_aw_name" datasource="#dsname#">
			SELECT aw_desp FROM  awtable where aw_cou="#i#"
			</cfquery>
		
			<cfset awname = awname&get_aw_name.aw_desp&"<br>">
			
			<cfif awdata eq 0>
				<cfset awamt = awamt&"<br>">
			<cfelse>
				<cfset awamt = awamt&awdata&"<br>">
				<cfset totawamt = val(totawamt) + val(awdata)>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfloop from="1" to="15" index="i">
			<cfset dedvar = 100 + i>
			<cfset dedvar2 = "DED"&dedvar>
			<cfset dedname1 = select_data[dedvar2]>
			
			<cfif val(dedname1) neq 0>
				<cfquery name="getdeddesp" datasource="#dsname#">
				SELECT ded_desp from dedtable where ded_cou = "#i#"
				</cfquery>
				
				<cfif advance neq "0">
					<cfset dedname = "ADVANCE"&"<br>"&dedname&getdeddesp.ded_desp&"<br />">
				<cfelse>
					<cfset dedname = dedname&getdeddesp.ded_desp&"<br />">
				</cfif>
				
				<cfif advance neq "0">
					<cfset dedamount = advance&"<br>"&dedamount&dedname1&"<br />">
					<cfset tot_dedamt = tot_dedamt + dedname1>
				<cfelse>
					<cfif dedamount eq "0">
						<cfset dedamount = dedname1&"<br />">
					<cfelse>
						<cfset dedamount = dedamount&dedname1&"<br />">
						<cfset tot_dedamt = tot_dedamt + dedname1>
					</cfif>
				</cfif>	
			</cfif>
	</cfloop>
	
	<cfset tot_dedamt2 = tot_dedamt + val(select_data.advance)>
	
	<cfloop from="1" to="6" index="i">
		<cfset otvar = "OT"&i>
		<cfset otdata = select_data[otvar]>
		<cfset othrvar = "hr"&i>
		<cfset othrdata = select_data[othrvar]>
		
		<cfif otdata neq 0>
			<cfquery name="getOt_qry" datasource="#dsname#">
			SELECT OT_COU,OT_UNIT,OT_DESP FROM Ottable WHERE OT_COU="#i#"
			</cfquery>
			<cfset otdesp = otdesp&getOt_qry.OT_DESP&"<br>">
			<cfset otunit = otunit&getOt_qry.OT_UNIT&"<br>">
		
			<cfif othr eq "0">
				<cfset othr = othrdata&"<br>">
			<cfelse>
				<cfset othr = othr&othrdata&"<br>">
			</cfif>
			
			<cfif otamt eq "0">
				<cfset otamt = otdata&"<br>">
			<cfelse>
				<cfset otamt = otamt&otdata&"<br>">
				<cfset tot_otamt = val(tot_otamt) + val(otdata)>
			</cfif>
		
		</cfif>
	
	</cfloop>
	
	<cfset total_basic = #val(select_data.basicpay)#>
	<cfset totalAL = #val(select_data.alall)#+ val(select_data.aladj) >
	
	<cfquery name="Insert_temp_file" datasource="#dsname#">
		INSERT INTO temp_cuz_payslip
		( 
		  `name` ,  `empl` ,  `cate` ,`basicPay` , `aw_name1` ,  `aw_amt1` ,
		  `ded_name1` ,  `ded_amt1` , `tnetpay` , pbasicpay, `username`  , `tgrosspay` ,  `tepfww` ,  `tepfcc`, 
		   line, nric, wrkday, dw, YTD_AL,YTD_MC, bal_YTD_AL, bal_YTD_MC, otdesp, othr, otunit, otamt,
		   totawamt,tot_dedamt,tot_otamt
		 )
		
		values 
		(
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.name#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.empno#">,
			 <cfqueryparam cfsqltype="cf_sql_char" value="#select_data.category#">,
			 "#val(select_data.BRATE)#", 
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#awname#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#awamt#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dedname#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#dedamount#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.netpay#">,
			 "#val(total_basic)#",
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.grosspay#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.epfww#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.epfcc#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.plineno#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.nricn#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.wday#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.dw#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#YTD_AL#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#YTD_MC#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#totalAL#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.mcall#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otdesp#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#othr#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otunit#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otamt#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#totawamt#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#tot_dedamt2#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#tot_otamt#">
			 
		 )
	
	</cfquery>



<cfquery name="select_temp_file" datasource="#dsname#">
SELECT * FROM temp_cuz_payslip as tp left join pmast as pm on pm.empno = tp.empl where username="#HUserID#"
</cfquery>


<cfreport template="customizepayslip_cy.cfr" format="PDF" query="select_temp_file">
 	<cfreportparam name="compname" value="#company_details.COMP_NAME#">
	<cfreportparam name="month1" value="#month1#">
	<cfreportparam name="year1" value="#year1#">
	<cfreportparam name="psDate" value="#dateformat(now(),'yyyy-mm-dd')#">
</cfreport>



