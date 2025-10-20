<cfset currentURL =  CGI.SERVER_NAME>
<cfif mid(currentURL,'8','1') eq "2">
<cfset serverhost = "localhost">
<cfset servername = "root">
<cfset serverpass = "Nickel266(">
<cfelse>
<cfset serverhost = "192.168.168.106">
<cfset servername = "appserver1">
<cfset serverpass = "Nickel266(">
</cfif>
<!---<cftry> --->
<cfset datetime = now()>
<cfoutput>
<cfset currentDirectory = "C:\NEWSYSTEM\PAY\DATABACKUP\" & dts>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset filename=dts&"_MonthEnd_"&dateformat(now(),'YYYYMMDD')&"_"&timeformat(now(),'HHMMSS')&"_"&GetAuthUser()&".sql">
<cfset currentdirfile=currentDirectory&"\"&filename>
<cfexecute name = "C:\NEWSYSTEM\PAY\mysqldump"
    arguments = "--host=#serverhost# --user=#servername# --password=#serverpass# #dts#" outputfile="#currentdirfile#" timeout="720">
</cfexecute> 

<cfset filesize = GetFileInfo('#currentdirfile#').size >

<cfif filesize lt 200000>
<h1>Backup Failed! Please contact System Administrator!</h1>
<cfabort>
</cfif>

<cfquery name="assign_status" datasource="#dts_main#">
    UPDATE gsetup2 SET mestatus = 'Y', monthend = now() WHERE comp_id = "#HcomID#"
</cfquery>
<!--- 	<cfquery name="month_fig_qry" datasource="#dts#">
		SELECT sum(coalesce(netpay,0))as net from pay_12m where tmonth ="12"
	</cfquery>
	<cfif val(month_fig_qry.net) neq 0>
		<cfset status_msg="Month end not allowed. Please do year end first, year end will change the year to 2011.">
		<cfoutput>	
			<form name="pc"  action="MonthEndMain.cfm" method="post">
				<input type="hidden" name="status" value="#status_msg#" />
			</form>
		</cfoutput>
		<script>
			 pc.submit();
		</script>
		<cfabort>
	</cfif> --->
	

	<cfset date = #dateformat(datetime,'YYYYMMDD')# >
	<cfset time = #timeformat(datetime, 'HHMMSS')# >
	<cfset dbname= date & time >
	
	<cfquery name="company_details" datasource="#dts_main#">
		SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	<cfquery name="gs_qry2" datasource="#dts_main#">
		SELECT emailpayslip FROM gsetup2 WHERE comp_id = "#HcomID#"
	</cfquery>
	<cfset mon = company_details.mmonth>
	<cfset yrs = company_details.myear>
    <cfif left(dts,4) eq "beps">
   <cfquery name="updateassignmentslip" datasource="#replace(dts,'_p','_i')#">
    update assignmentslip set posted ="p" where month(assignmentslipdate) ="#mon#" and year(assignmentslipdate) = "#yrs#" and assignmenttype = "noinvoice"
    </cfquery>
	</cfif>
	<cfset date1= createdate(yrs,mon,1)>
	<cfset nexdate = #dateformat(date1,'MM/DD/YYYY')# >
	<cfset new_date = #DateAdd('m',1,nexdate)# >
	<cfset new_month= #dateformat(new_date,'M')#>
	<cfset new_year =  #dateformat(new_date,'YYYY')#>
	<cfset trans_type = #form.transaction#>
	<cfif mon neq "12">
	<cfquery name="company_date" datasource="#dts_main#">
		UPDATE gsetup SET mmonth = #new_month# , myear = #new_year# WHERE comp_id = "#HcomID#"
	</cfquery>
    <cfelse>
    <cfquery name="company_date" datasource="#dts_main#">
		UPDATE gsetup SET mmonth = 13 WHERE comp_id = "#HcomID#"
	</cfquery>
    </cfif>

<!--- 	<cfif trans_type eq "MFT">
		<cfquery name="select_data" datasource="#dts#">
			SELECT * FROM paytran , pmast WHERE paytran.empno = pmast.empno and paystatus="A"
		</cfquery>
		
	<cfelseif trans_type eq "RT">
		<cfquery name="select_data" datasource="#dts#">
			SELECT * FROM paytran , pmast WHERE paytran.empno = pmast.empno 
		</cfquery>
	</cfif> --->
	
	<cfquery name="select_data" datasource="#dts#">
		SELECT * FROM paytran , pmast WHERE paytran.empno = pmast.empno and paystatus="A"
	</cfquery>
	
	
	<cfloop query="select_data">
		
		<!--- Process Increment salary--->
		<cfset inc_amount = select_data.inc_amt >
        <cfset inc_date = select_data.inc_date >
        <cfset daysmonth = daysinmonth(new_date) >
        <cfset enddate = createdate(new_year,new_month,daysmonth) >
        <cfif inc_date neq "">
	        <cfif inc_date lte enddate and inc_date gte new_date > 
		        <cfquery name="select_brate" datasource="#dts#">
		        	SELECT brate from pmast where empno = "#select_data.empno#"
		        </cfquery>
	        	
	        	<cfset new_brate = select_brate.brate + inc_amount >
		        
		        <cfquery name="update_brate" datasource="#dts#">
		        	UPDATE pmast SET brate = #new_brate#, inc_amt = 0.00, inc_date ="0000-00-00" 
		        	where empno = "#select_data.empno#"
		        </cfquery>
				<!--- Insert Basic Rate Increment Record Into brateincrement Start [23/9/2013] [tchpeng] --->
				<cfquery name="insert_brate_increment_record" datasource="#dts#">
					INSERT INTO brateincrement
					(empno,initialbrate,incrementamount,updatedbrate,implementdate,created_by,created_on,updated_by,updated_on)
					VALUES
					(<cfqueryparam value="#select_data.empno#" cfsqltype="cf_sql_varchar" maxlength="45">,<cfqueryparam value="#select_brate.brate#" cfsqltype="cf_sql_double">,<cfqueryparam value="#inc_amount#" cfsqltype="cf_sql_double">,<cfqueryparam value="#new_brate#" cfsqltype="cf_sql_double">,CURDATE(),<cfqueryparam value="#getAuthUser()#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,NOW(),<cfqueryparam value="#getAuthUser()#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,NOW())
				</cfquery>
				<!--- Insert Basic Rate Increment Record Into brateincrement End [23/9/2013] [tchpeng] --->
				<!--- Insert Basic Rate Increment Record Into emphist Start [24/9/2013] [tchpeng] --->
				<cfquery name="insert_brate_increment_record_into_emphist" datasource="#dts#">
					INSERT INTO emphist
					(empno,TYEAR,TMONTH,MSTATUS,MSTATUSOD,EDU,EXP,NUM_CHILD,WPERMIT,CONTRACT,CATEGORY,PLINENO,DEPTCODE,BRCODE,EMP_CODE,JTITLE,BRATE1,BRATE2,PAYRTYPE,PAYMETH,PAYSTATUS,INC_DATE,INC_AMT,DCOMM,DCONFIRM,DPROMOTE,DRESIGN,OTHBNF_D01,OTHBNF_D02,OTHBNF_D03,OTHBNF_D04,OTHBNF_D05,OTHBNF_D06,OTHBNF_D07,OTHBNF_D08,OTHBNF_D09,OTHBNF_D10,OTHBNF_A01,OTHBNF_A02,OTHBNF_A03,OTHBNF_A04,OTHBNF_A05,OTHBNF_A06,OTHBNF_A07,OTHBNF_A08,OTHBNF_A09,OTHBNF_A10,contract_f,contract_t,date_created)
					VALUES
					(<cfqueryparam value="#select_data.empno#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,<cfqueryparam value="#company_details.myear#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#company_details.mmonth#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#select_data.mstatus#" cfsqltype="CF_SQL_CHAR" maxlength="1">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="15">,<cfqueryparam value="#select_data.edu#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,<cfqueryparam value="#select_data.exp#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,<cfqueryparam value="#select_data.numchild#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#select_data.wpermit#" cfsqltype="CF_SQL_VARCHAR" maxlength="20">,<cfqueryparam value="#select_data.contract#" cfsqltype="CF_SQL_CHAR" maxlength="1">,<cfqueryparam value="#select_data.category#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,<cfqueryparam value="#select_data.plineno#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,<cfqueryparam value="#select_data.deptcode#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,<cfqueryparam value="#select_data.brcode#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,<cfqueryparam value="#select_data.emp_code#" cfsqltype="CF_SQL_VARCHAR" maxlength="12">,<cfqueryparam value="#select_data.jtitle#" cfsqltype="CF_SQL_VARCHAR" maxlength="40">,<cfqueryparam value="#select_brate.brate#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#new_brate#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#select_data.payrtype#" cfsqltype="CF_SQL_CHAR" maxlength="1">,<cfqueryparam value="#select_data.paymeth#" cfsqltype="CF_SQL_CHAR" maxlength="1">,<cfqueryparam value="#select_data.paystatus#" cfsqltype="CF_SQL_CHAR" maxlength="1">,CURDATE(),<cfqueryparam value="#inc_amount#" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#select_data.dcomm#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="#select_data.dconfirm#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="#select_data.dpromote#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="#select_data.dresign#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,<cfqueryparam value="#select_data.contract_f#" cfsqltype="CF_SQL_DATE">,<cfqueryparam value="#select_data.contract_t#" cfsqltype="CF_SQL_DATE">,NOW())
				</cfquery>
				<!--- Insert Basic Rate Increment Record Into emphist End [24/9/2013] [tchpeng] --->
	        </cfif>
		</cfif>
		
        <!--- enhancement for mid month increment, [08/12/2015 by Max Tan]--->
        <cfif val(select_data.brate_lm) gt 0>
            <cfquery name="update_brate_lm" datasource="#dts#">
                UPDATE pmast SET brate = brate_lm,
                brate_lm = 0
                where empno = "#select_data.empno#"
            </cfquery>
        </cfif>
        
		<cfset m_inc_amount = select_data.m_inc_amt >
        <cfset m_inc_date = select_data.m_inc_date >
        <cfset daysmonth = daysinmonth(new_date) >
        <cfset enddate = createdate(new_year,new_month,daysmonth) >
        
        <cfif m_inc_date neq "">
	        <cfif m_inc_date lte enddate and m_inc_date gte new_date > 
		        <cfquery name="select_brate" datasource="#dts#">
		        	SELECT brate from pmast where empno = "#select_data.empno#"
		        </cfquery>
	        	
	        	<cfset new_m_brate = select_brate.brate + numberformat((m_inc_amount*(daysmonth-dateformat(m_inc_date,'d')+1)/daysmonth), '.__')>
	        	<cfset new_brate = select_brate.brate + m_inc_amount>
                
		        <cfquery name="update_brate" datasource="#dts#">
		        	UPDATE pmast SET brate = #new_m_brate#, brate_lm = #new_brate#, m_inc_amt = 0.00, m_inc_date ="0000-00-00"
		        	where empno = "#select_data.empno#"
		        </cfquery>

				<cfquery name="insert_brate_increment_record" datasource="#dts#">
					INSERT INTO brateincrement
					(empno,initialbrate,incrementamount,updatedbrate,implementdate,created_by,created_on,updated_by,updated_on)
					VALUES
					(<cfqueryparam value="#select_data.empno#" cfsqltype="cf_sql_varchar" maxlength="45">,
                    <cfqueryparam value="#select_brate.brate#" cfsqltype="cf_sql_double">,
                    <cfqueryparam value="#m_inc_amount#" cfsqltype="cf_sql_double">,
                    <cfqueryparam value="#new_brate#" cfsqltype="cf_sql_double">,
                    CURDATE(),
                    <cfqueryparam value="#getAuthUser()#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,
                    NOW(),
                    <cfqueryparam value="#getAuthUser()#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,
                    NOW())
				</cfquery>

				<cfquery name="insert_brate_increment_record_into_emphist" datasource="#dts#">
					INSERT INTO emphist
					(empno,TYEAR,TMONTH,MSTATUS,MSTATUSOD,EDU,EXP,NUM_CHILD,WPERMIT,CONTRACT,CATEGORY,PLINENO,DEPTCODE,BRCODE,EMP_CODE,JTITLE,BRATE1,BRATE2,PAYRTYPE,PAYMETH,PAYSTATUS,INC_DATE,INC_AMT,DCOMM,DCONFIRM,DPROMOTE,DRESIGN,OTHBNF_D01,OTHBNF_D02,OTHBNF_D03,OTHBNF_D04,OTHBNF_D05,OTHBNF_D06,OTHBNF_D07,OTHBNF_D08,OTHBNF_D09,OTHBNF_D10,OTHBNF_A01,OTHBNF_A02,OTHBNF_A03,OTHBNF_A04,OTHBNF_A05,OTHBNF_A06,OTHBNF_A07,OTHBNF_A08,OTHBNF_A09,OTHBNF_A10,contract_f,contract_t,date_created)
					VALUES
					(<cfqueryparam value="#select_data.empno#" cfsqltype="CF_SQL_VARCHAR" maxlength="45">,
                    <cfqueryparam value="#company_details.myear#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#company_details.mmonth#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#select_data.mstatus#" cfsqltype="CF_SQL_CHAR" maxlength="1">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="15">,
                    <cfqueryparam value="#select_data.edu#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
                    <cfqueryparam value="#select_data.exp#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">,
                    <cfqueryparam value="#select_data.numchild#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#select_data.wpermit#" cfsqltype="CF_SQL_VARCHAR" maxlength="20">,
                    <cfqueryparam value="#select_data.contract#" cfsqltype="CF_SQL_CHAR" maxlength="1">,
                    <cfqueryparam value="#select_data.category#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,
                    <cfqueryparam value="#select_data.plineno#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,
                    <cfqueryparam value="#select_data.deptcode#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,
                    <cfqueryparam value="#select_data.brcode#" cfsqltype="CF_SQL_VARCHAR" maxlength="10">,
                    <cfqueryparam value="#select_data.emp_code#" cfsqltype="CF_SQL_VARCHAR" maxlength="12">,
                    <cfqueryparam value="#select_data.jtitle#" cfsqltype="CF_SQL_VARCHAR" maxlength="40">,
                    <cfqueryparam value="#select_brate.brate#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#new_brate#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#select_data.payrtype#" cfsqltype="CF_SQL_CHAR" maxlength="1">,
                    <cfqueryparam value="#select_data.paymeth#" cfsqltype="CF_SQL_CHAR" maxlength="1">,
                    <cfqueryparam value="#select_data.paystatus#" cfsqltype="CF_SQL_CHAR" maxlength="1">,
                    CURDATE(),<cfqueryparam value="#m_inc_amount#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#select_data.dcomm#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="#select_data.dconfirm#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="#select_data.dpromote#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="#select_data.dresign#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="" cfsqltype="CF_SQL_VARCHAR" maxlength="30">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="0.00" cfsqltype="CF_SQL_DECIMAL">,
                    <cfqueryparam value="#select_data.contract_f#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="#select_data.contract_t#" cfsqltype="CF_SQL_DATE">,NOW())
				</cfquery>
	        </cfif>
		</cfif>
		
		<!--- Select All From Bonus --->
        <cfquery name="bonus_data" datasource="#dts#">
        	SELECT * FROM bonus WHERE empno = "#select_data.empno#"
        </cfquery>
        
        <!--- Select All From Extra --->
        <cfquery name="extra_data" datasource="#dts#">
        	SELECT * FROM extra WHERE empno = "#select_data.empno#" 
        </cfquery>
        
        <!--- Select All From Comm --->
        <cfquery name="comm_data" datasource="#dts#">
        	SELECT * FROM comm WHERE empno = "#select_data.empno#" 
        </cfquery> 
        
		<cfquery name="selectdata" datasource="#dts#">
			SELECT * FROM paytran WHERE empno = "#select_data.empno#" and payyes = "Y"
		</cfquery>
		<cfset date1 = #dateformat(nexdate,'MM')# >
	
		<CFSET SetLocale("English (UK)")> 
		<cfset currentdatetime = '#lsdateformat(now(), "YYYY-MM-DD")# #timeformat(now(), "HH:MM:SS")#'>
		
		<cfquery name="update_data" datasource="#dts#">
			UPDATE pay2_12m_fig SET 
            <cfif selectdata.payyes eq "Y">
			Brate = #val(selectdata.Brate)#,
            <cfelse>
            Brate = 0,
            </cfif> 
			OOB = #val(selectdata.OOB)#, 
			Wday = #val(selectdata.WDAY)#, 
			DW = #val(selectdata.DW)# , 
			PH = #val(selectdata.PH)#,
			AL = #val(selectdata.AL)#,
			ALHR = #val(selectdata.ALHR)#,
			MC = #val(selectdata.MC)#,
			MT = #val(selectdata.MT)#,
			CC = #val(selectdata.CC)#,
			PT = #val(selectdata.PT)#,
			MR = #val(selectdata.MR)#,
			CL = #val(selectdata.CL)#,
			HL = #val(selectdata.HL)#,
			AD = #val(selectdata.AD)#,
            ECL = #val(selectdata.ECL)#,
            OIL = #val(selectdata.OIL)#,
            RS = #val(selectdata.RS)#,
			EX = #val(selectdata.Ex)#,
			toff = #val(selectdata.toff)#,
			LS = #val(selectdata.LS)#,
			OPL = #val(selectdata.OPL)#,
			NPL = #val(selectdata.NPL)#,
			AB = #val(selectdata.AB)#,
			ONPL = #val(selectdata.ONPL)#,
			NS = #val(selectdata.NS)#,
			WORKHR = #val(selectdata.WORKHR)#,
			LATEHR = #val(selectdata.LATEHR)#,
			EARLYHR = #val(selectdata.EARLYHR)#,
			NOPAYHR = #val(selectdata.NOPAYHR)#,
			HR1 = #val(selectdata.HR1)#,
			HR2 = #val(selectdata.HR2)#,
			HR3 = #val(selectdata.HR3)#,
			HR4 = #val(selectdata.HR4)#,
			HR5 = #val(selectdata.HR5)#,
			HR6 = #val(selectdata.HR6)#,
			BASICPAY = #val(selectdata.BASICPAY)#,
			OTPAY = #val(selectdata.OTPAY)#,
			DIRFEE = #val(selectdata.DIRFEE)#,
			TAW = #val(selectdata.TAW)#,
			GROSSPAY = #val(selectdata.GROSSPAY)#,
			TDEDU = #val(selectdata.TDEDU)#,
			TDED = #val(selectdata.TDED)#,
			NETPAY = #val(selectdata.NETPAY)#,
			NPLPAY = #val(selectdata.NPLPAY)#,
			TXAW = #val(selectdata.TXAW)#,
			TXDED = #val(selectdata.TXDED)#,
			OT1 = #val(selectdata.OT1)#,
			OT2 = #val(selectdata.OT2)#,
			OT3 = #val(selectdata.OT3)#,
			OT4 = #val(selectdata.OT4)#,
			OT5 = #val(selectdata.OT5)#,
			OT6 = #val(selectdata.OT6)#,
			AW101 = #val(selectdata.AW101)#,
			AW102 = #val(selectdata.AW102)#,
			AW103 = #val(selectdata.AW103)#,
			AW104 = #val(selectdata.AW104)#,
			AW105 = #val(selectdata.AW105)#,
			AW106 = #val(selectdata.AW106)#,
			AW107 = #val(selectdata.AW107)#,
			AW108 = #val(selectdata.AW108)#,
			AW109 = #val(selectdata.AW109)#,
			AW110 = #val(selectdata.AW110)#,
			AW111 = #val(selectdata.AW111)#,
			AW112 = #val(selectdata.AW112)#,
			AW113 = #val(selectdata.AW113)#,
			AW114 = #val(selectdata.AW114)#,
			AW115 = #val(selectdata.AW115)#,
			AW116 = #val(selectdata.AW116)#,
			AW117 = #val(selectdata.AW117)#,
			DED101 = #val(selectdata.DED101)#,
			DED102 = #val(selectdata.DED102)#,
			DED103 = #val(selectdata.DED103)#,
			DED104 = #val(selectdata.DED104)#,
			DED105 = #val(selectdata.DED105)#,
			DED106 = #val(selectdata.DED106)#,
			DED107 = #val(selectdata.DED107)#,
			DED108 = #val(selectdata.DED108)#,
			DED109 = #val(selectdata.DED109)#,
			DED110 = #val(selectdata.DED110)#,
			DED111 = #val(selectdata.DED111)#,
			DED112 = #val(selectdata.DED112)#,
			DED113 = #val(selectdata.DED113)#,
			DED114 = #val(selectdata.DED114)#,
			DED115 = #val(selectdata.DED115)#,
			ADVANCE = #val(selectdata.ADVANCE)#,
			ITAXPCB = #val(selectdata.ITAXPCB)#,
			ITAXPCBADJ = #val(selectdata.ITAXPCBADJ)#,
			EPFWW = #val(selectdata.EPFWW)+val(bonus_data.epfww)+val(comm_data.epfww)#,
			EPFCC = #val(selectdata.EPFCC)+val(bonus_data.epfcc)+val(comm_data.epfcc)#,
			EPFWWEXT = #val(selectdata.EPFWWEXT)+val(bonus_data.EPFWWEXT)+val(comm_data.EPFWWEXT)#,
			EPFCCEXT = #val(selectdata.EPFCCEXT)+val(bonus_data.EPFCCEXT)+val(comm_data.EPFCCEXT)#,
			EPGCC = #val(selectdata.EPGCC)+val(bonus_data.EPGCC)+val(comm_data.EPGCC)#,
			SOASOWW = #val(selectdata.SOASOWW)+val(bonus_data.SOASOWW)+val(comm_data.SOASOWW)#,
			SOASOCC = #val(selectdata.SOASOCC)+val(bonus_data.SOASOCC)+val(comm_data.SOASOCC)#,
			SOBSOWW = #val(selectdata.SOBSOWW)+val(bonus_data.SOBSOWW)+val(comm_data.SOBSOWW)#,
			SOBSOCC = #val(selectdata.SOBSOCC)+val(bonus_data.SOBSOCC)+val(comm_data.SOBSOCC)#,
			SOCSOWW = #val(selectdata.SOCSOWW)+val(bonus_data.SOCSOWW)+val(comm_data.SOCSOWW)#,
			SOCSOCC = #val(selectdata.SOCSOCC)+val(bonus_data.SOCSOCC)+val(comm_data.SOCSOCC)#,
			SODSOWW = #val(selectdata.SODSOWW)+val(bonus_data.SODSOWW)+val(comm_data.SODSOWW)#,
			SODSOCC = #val(selectdata.SODSOCC)+val(bonus_data.SODSOCC)+val(comm_data.SODSOCC)#,
			SOESOWW = #val(selectdata.SOESOWW)+val(bonus_data.SOESOWW)+val(comm_data.SOESOWW)#,
			SOESOCC = #val(selectdata.SOESOCC)+val(bonus_data.SOESOCC)+val(comm_data.SOESOCC)#,
			CCSTAT1 = #val(selectdata.CCSTAT1)+val(bonus_data.CCSTAT1)+val(comm_data.CCSTAT1)#,
			PENCEN = #val(selectdata.PENCEN)#,
			MFUND = #val(selectdata.MFUND)#,
			DFUND = #val(selectdata.DFUND)#,
			EPF_PAY = #val(selectdata.EPF_PAY)#+#val(bonus_data.EPF_PAY)#+#val(comm_data.EPF_PAY)#,
			EPF_PAY_A = #val(selectdata.EPF_PAY_A)#,
			RATE1 = #val(selectdata.RATE1)#,
			RATE2 = #val(selectdata.RATE2)#,
			RATE3 = #val(selectdata.RATE3)#,
			RATE4 = #val(selectdata.RATE4)#,
			RATE5 = #val(selectdata.RATE5)#,
			RATE6 = #val(selectdata.RATE6)#,
		<cfif bonus_data.payyes eq "Y">
			bonus = #val(bonus_data.basicpay)#,
		</cfif>
			comm = #val(comm_data.basicpay)#,
			monthend_by = "#HUserName#",
			monthend_on = "#currentdatetime#",
			additionalwages = #val(selectdata.additionalwages)#
            , cheque_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata.cheque_no#">
            , cheqno_updated_on = "#selectdata.cheqno_updated_on#"
            , cheqno_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata.cheqno_updated_by#">
            , mess= <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata.mess#">
            , mess1= <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata.mess1#">
            <!---enhanced for sdl and fwl to update monthly on 2nd half, [by Max Tan, 15122015]--->
            , levy_sd = #val(comm_data.levy_sd)#
            , levy_fw_w = #val(comm_data.levy_fw_w)#
			WHERE TMONTH = #date1# AND EMPNO = "#select_data.empno#"
		</cfquery>
	
		<cfquery name="selectdata1" datasource="#dts#">
			SELECT * FROM paytra1 WHERE empno = "#select_data.empno#" and payyes = "Y"
		</cfquery>
	
		<cfquery name="update_data1" datasource="#dts#">
			UPDATE pay1_12m_fig SET 
            <cfif selectdata1.payyes eq "Y">
			Brate = #val(selectdata1.Brate)#, 
            <cfelse>
            Brate = 0,
            </cfif>
			OOB = #val(selectdata1.OOB)#, 
			Wday = #val(selectdata1.WDAY)#, 
			DW = #val(selectdata1.DW)# , 
			PH = #val(selectdata1.PH)#,
			AL = #val(selectdata1.AL)#,
			ALHR = #val(selectdata1.ALHR)#,
			MC = #val(selectdata1.MC)#,
			MT = #val(selectdata1.MT)#,
			CC = #val(selectdata1.CC)#,
			PT = #val(selectdata1.PT)#,
			MR = #val(selectdata1.MR)#,
			CL = #val(selectdata1.CL)#,
			HL = #val(selectdata1.HL)#,
			AD = #val(selectdata1.AD)#,
            ECL = #val(selectdata1.ECL)#,
            OIL = #val(selectdata1.OIL)#,
            RS = #val(selectdata1.RS)#,
            toff = #val(selectdata1.toff)#,
			EX = #val(selectdata1.Ex)#,
			LS = #val(selectdata1.LS)#,
			OPL = #val(selectdata1.OPL)#,
			NPL = #val(selectdata1.NPL)#,
			AB = #val(selectdata1.AB)#,
			ONPL = #val(selectdata1.ONPL)#,
			NS = #val(selectdata1.NS)#,
			WORKHR = #val(selectdata1.WORKHR)#,
			LATEHR = #val(selectdata1.LATEHR)#,
			EARLYHR = #val(selectdata1.EARLYHR)#,
			NOPAYHR = #val(selectdata1.NOPAYHR)#,
			HR1 = #val(selectdata1.HR1)#,
			HR2 = #val(selectdata1.HR2)#,
			HR3 = #val(selectdata1.HR3)#,
			HR4 = #val(selectdata1.HR4)#,
			HR5 = #val(selectdata1.HR5)#,
			HR6 = #val(selectdata1.HR6)#,
			BASICPAY = #val(selectdata1.BASICPAY)#,
			OTPAY = #val(selectdata1.OTPAY)#,
			DIRFEE = #val(selectdata1.DIRFEE)#,
			TAW = #val(selectdata1.TAW)#,
			GROSSPAY = #val(selectdata1.GROSSPAY)#,
			TDEDU = #val(selectdata1.TDEDU)#,
			TDED = #val(selectdata1.TDED)#,
			NETPAY = #val(selectdata1.NETPAY)#,
			NPLPAY = #val(selectdata1.NPLPAY)#,
			TXAW = #val(selectdata1.TXAW)#,
			TXDED = #val(selectdata1.TXDED)#,
			OT1 = #val(selectdata1.OT1)#,
			OT2 = #val(selectdata1.OT2)#,
			OT3 = #val(selectdata1.OT3)#,
			OT4 = #val(selectdata1.OT4)#,
			OT5 = #val(selectdata1.OT5)#,
			OT6 = #val(selectdata1.OT6)#,
			AW101 = #val(selectdata1.AW101)#,
			AW102 = #val(selectdata1.AW102)#,
			AW103 = #val(selectdata1.AW103)#,
			AW104 = #val(selectdata1.AW104)#,
			AW105 = #val(selectdata1.AW105)#,
			AW106 = #val(selectdata1.AW106)#,
			AW107 = #val(selectdata1.AW107)#,
			AW108 = #val(selectdata1.AW108)#,
			AW109 = #val(selectdata1.AW109)#,
			AW110 = #val(selectdata1.AW110)#,
			AW111 = #val(selectdata1.AW111)#,
			AW112 = #val(selectdata1.AW112)#,
			AW113 = #val(selectdata1.AW113)#,
			AW114 = #val(selectdata1.AW114)#,
			AW115 = #val(selectdata1.AW115)#,
			AW116 = #val(selectdata1.AW116)#,
			AW117 = #val(selectdata1.AW117)#,
			DED101 = #val(selectdata1.DED101)#,
			DED102 = #val(selectdata1.DED102)#,
			DED103 = #val(selectdata1.DED103)#,
			DED104 = #val(selectdata1.DED104)#,
			DED105 = #val(selectdata1.DED105)#,
			DED106 = #val(selectdata1.DED106)#,
			DED107 = #val(selectdata1.DED107)#,
			DED108 = #val(selectdata1.DED108)#,
			DED109 = #val(selectdata1.DED109)#,
			DED110 = #val(selectdata1.DED110)#,
			DED111 = #val(selectdata1.DED111)#,
			DED112 = #val(selectdata1.DED112)#,
			DED113 = #val(selectdata1.DED113)#,
			DED114 = #val(selectdata1.DED114)#,
			DED115 = #val(selectdata1.DED115)#,
			ADVANCE = #val(selectdata1.ADVANCE)#,
			ITAXPCB = #val(selectdata1.ITAXPCB)#,
			ITAXPCBADJ = #val(selectdata1.ITAXPCBADJ)#,
			EPFWW = #val(selectdata1.EPFWW)#,
			EPFCC = #val(selectdata1.EPFCC)#,
			EPFWWEXT = #val(selectdata1.EPFWWEXT)#,
			EPFCCEXT = #val(selectdata1.EPFCCEXT)#,
			EPGCC = #val(selectdata1.EPGCC)#,
			SOASOWW = #val(selectdata1.SOASOWW)#,
			SOASOCC = #val(selectdata1.SOASOCC)#,
			SOBSOWW = #val(selectdata1.SOBSOWW)#,
			SOBSOCC = #val(selectdata1.SOBSOCC)#,
			SOCSOWW = #val(selectdata1.SOCSOWW)#,
			SOCSOCC = #val(selectdata1.SOCSOCC)#,
			SODSOWW = #val(selectdata1.SODSOWW)#,
			SODSOCC = #val(selectdata1.SODSOCC)#,
			SOESOWW = #val(selectdata1.SOESOWW)#,
			SOESOCC = #val(selectdata1.SOESOCC)#,
			CCSTAT1 = #val(selectdata1.CCSTAT1)#,
			PENCEN = #val(selectdata1.PENCEN)#,
			MFUND = #val(selectdata1.MFUND)#,
			DFUND = #val(selectdata1.DFUND)#,
			EPF_PAY = #val(selectdata1.EPF_PAY)#,
			EPF_PAY_A = #val(selectdata1.EPF_PAY_A)#,
			RATE1 = #val(selectdata1.RATE1)#,
			RATE2 = #val(selectdata1.RATE2)#,
			RATE3 = #val(selectdata1.RATE3)#,
			RATE4 = #val(selectdata1.RATE4)#,
			RATE5 = #val(selectdata1.RATE5)#,
			RATE6 = #val(selectdata1.RATE6)#,
			monthend_by = "#HUserName#",
			monthend_on = "#currentdatetime#",
			additionalwages = #val(selectdata1.additionalwages)#
            ,cheque_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata1.cheque_no#">
            ,cheqno_updated_on = "#selectdata1.cheqno_updated_on#"
            ,cheqno_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata1.cheqno_updated_by#">
            , mess= <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata1.mess#">
            , mess1= <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectdata1.mess1#">
			WHERE TMONTH = #date1# AND EMPNO = "#select_data.empno#"
		</cfquery>
		
		<!--- Bonus Calculation --->
		
		<cfquery name="insert_bonus12m" datasource="#dts#">
			INSERT INTO BONU_12m 
			(EMPNO,BONUSP,SALESAMT,SALESAMT2,BASICPAY,EPFWW,EPFCC,EPFWWEXT,EPFCCEXT,EPGWW,EPGCC,SOASOWW,SOASOCC,
			SOBSOWW,SOBSOCC,SOCSOWW,SOCSOCC,SODSOWW,SODSOCC,SOESOWW,SOESOCC,UNIONWW,UNIONCC,CCSTAT1,ITAXPCB,ITAXPCBADJ,
			GROSSPAY,NETPAY,EPF_PAY,CHEQUE_NO,BANKCHARGE,PM_CODE,TMONTH,COMM1,COMM2,EXTRA1,EXTRA2,EXTRA3,LEVY_FW_W,
			LEVY_FW_C,LEVY_SD,NUMOFMTH,ESTBRATE,PAYYES, FIXOESP)
			VALUES
			(
			"#bonus_data.EMPNO#",
			#val(bonus_data.BONUSP)#,
			#val(bonus_data.SALESAMT)#,
			#val(bonus_data.SALESAMT2)#,
			#val(bonus_data.BASICPAY)#,
			#val(bonus_data.EPFWW)#,
			#val(bonus_data.EPFCC)#,
			#val(bonus_data.EPFWWEXT)#,
			#val(bonus_data.EPFCCEXT)#,
			#val(bonus_data.EPGWW)#,
			#val(bonus_data.EPGCC)#,
			#val(bonus_data.SOASOWW)#,
			#val(bonus_data.SOASOCC)#,
			#val(bonus_data.SOBSOWW)#,
			#val(bonus_data.SOBSOCC)#,
			#val(bonus_data.SOCSOWW)#,
			#val(bonus_data.SOCSOCC)#,
			#val(bonus_data.SODSOWW)#,
			#val(bonus_data.SODSOCC)#,
			#val(bonus_data.SOESOWW)#,
			#val(bonus_data.SOESOCC)#,
			#val(bonus_data.UNIONWW)#,
			#val(bonus_data.UNIONCC)#,
			#val(bonus_data.CCSTAT1)#,
			#val(bonus_data.ITAXPCB)#,
			#val(bonus_data.ITAXPCBADJ)#,
			#val(bonus_data.GROSSPAY)#,
			#val(bonus_data.NETPAY)#,
			#val(bonus_data.EPF_PAY)#,
			#val(bonus_data.CHEQUE_NO)#,
			#val(bonus_data.BANKCHARGE)#,
			#val(bonus_data.PM_CODE)#,
			#date1#,
			#val(bonus_data.COMM1)#,
			#val(bonus_data.COMM2)#,
			#val(bonus_data.EXTRA1)#,
			#val(bonus_data.EXTRA2)#,
			#val(bonus_data.EXTRA3)#,
			#val(bonus_data.LEVY_FW_W)#,
			#val(bonus_data.LEVY_FW_C)#,
			#val(bonus_data.LEVY_SD)#,
			#val(bonus_data.NUMOFMTH)#,
			#val(bonus_data.ESTBRATE)#,
			"#bonus_data.PAYYES#",
			#val(bonus_data.FIXOESP)#)
		</cfquery>
		

		<!--- Commision Calculation --->
        <!---enhance for 12m update fwl and sdl, [15122015, by Max Tan]--->
        <cfquery name="checkentry" datasource="#dts#">
            SELECT empno from comm_12m WHERE empno = '#comm_data.empno#' AND tmonth = '#date1#'
        </cfquery>
        <cfif checkentry.recordcount eq 0>
		<cfquery name="insert_comm12m" datasource="#dts#">
			INSERT INTO comm_12m 
			(EMPNO,BONUSP,SALESAMT,SALESAMT2,BASICPAY,EPFWW,EPFCC,EPFWWEXT,EPFCCEXT,EPGWW,EPGCC,SOASOWW,SOASOCC,SOBSOWW,SOBSOCC,SOCSOWW,SOCSOCC,SODSOWW,SODSOCC,SOESOWW,SOESOCC,UNIONWW,UNIONCC,CCSTAT1,ITAXPCB,ITAXPCBADJ,GROSSPAY,NETPAY,EPF_PAY,CHEQUE_NO,BANKCHARGE,PM_CODE,TMONTH,COMM1,COMM2,EXTRA1,EXTRA2,EXTRA3,LEVY_FW_W,LEVY_FW_C,LEVY_SD,NUMOFMTH,ESTBRATE,PAYYES, FIXOESP)
			VALUES
			(
			"#comm_data.EMPNO#",
			#val(comm_data.BONUSP)#,
			#val(comm_data.SALESAMT)#,
			#val(comm_data.SALESAMT2)#,
			#val(comm_data.BASICPAY)#,
			#val(comm_data.EPFWW)#,
			#val(comm_data.EPFCC)#,
			#val(comm_data.EPFWWEXT)#,
			#val(comm_data.EPFCCEXT)#,
			#val(comm_data.EPGWW)#,
			#val(comm_data.EPGCC)#,
			#val(comm_data.SOASOWW)#,
			#val(comm_data.SOASOCC)#,
			#val(comm_data.SOBSOWW)#,
			#val(comm_data.SOBSOCC)#,
			#val(comm_data.SOCSOWW)#,
			#val(comm_data.SOCSOCC)#,
			#val(comm_data.SODSOWW)#,
			#val(comm_data.SODSOCC)#,
			#val(comm_data.SOESOWW)#,
			#val(comm_data.SOESOCC)#,
			#val(comm_data.UNIONWW)#,
			#val(comm_data.UNIONCC)#,
			#val(comm_data.CCSTAT1)#,
			#val(comm_data.ITAXPCB)#,
			#val(comm_data.ITAXPCBADJ)#,
			#val(comm_data.GROSSPAY)#,
			#val(comm_data.NETPAY)#,
			#val(comm_data.EPF_PAY)#,
			#val(comm_data.CHEQUE_NO)#,
			#val(comm_data.BANKCHARGE)#,
			#val(comm_data.PM_CODE)#,
			#date1#,
			#val(comm_data.COMM1)#,
			#val(comm_data.COMM2)#,
			#val(comm_data.EXTRA1)#,
			#val(comm_data.EXTRA2)#,
			#val(comm_data.EXTRA3)#,
			#val(comm_data.LEVY_FW_W)#,
			#val(comm_data.LEVY_FW_C)#,
			#val(comm_data.LEVY_SD)#,
			#val(comm_data.NUMOFMTH)#,
			#val(comm_data.ESTBRATE)#,
			"#comm_data.PAYYES#",
			#val(comm_data.FIXOESP)#)
		</cfquery>
        <cfelse>
		<cfquery name="insert_comm12m" datasource="#dts#">
            UPDATE comm_12m SET
            BONUSP = #val(comm_data.BONUSP)#,
            SALESAMT = #val(comm_data.BONUSP)#,
            SALESAMT2 = #val(comm_data.BONUSP)#,
            BASICPAY = #val(comm_data.BONUSP)#,
            EPFWW = #val(comm_data.BONUSP)#,
            EPFCC = #val(comm_data.BONUSP)#,
            EPFWWEXT = #val(comm_data.BONUSP)#,
            EPFCCEXT = #val(comm_data.BONUSP)#,
            EPGWW = #val(comm_data.BONUSP)#,
            EPGCC = #val(comm_data.BONUSP)#,
            SOASOWW = #val(comm_data.BONUSP)#,
            SOASOCC = #val(comm_data.BONUSP)#,
            SOBSOWW = #val(comm_data.BONUSP)#,
            SOBSOCC = #val(comm_data.BONUSP)#,
            SOCSOWW = #val(comm_data.BONUSP)#,
            SOCSOCC = #val(comm_data.BONUSP)#,
            SODSOWW = #val(comm_data.BONUSP)#,
            SODSOCC = #val(comm_data.BONUSP)#,
            SOESOWW = #val(comm_data.BONUSP)#,
            SOESOCC = #val(comm_data.BONUSP)#,
            UNIONWW = #val(comm_data.BONUSP)#,
            UNIONCC = #val(comm_data.BONUSP)#,
            CCSTAT1 = #val(comm_data.BONUSP)#,
            ITAXPCB = #val(comm_data.BONUSP)#,
            ITAXPCBADJ = #val(comm_data.BONUSP)#,
            GROSSPAY = #val(comm_data.BONUSP)#,
            NETPAY = #val(comm_data.BONUSP)#,
            EPF_PAY = #val(comm_data.BONUSP)#,
            CHEQUE_NO = #val(comm_data.BONUSP)#,
            BANKCHARGE = #val(comm_data.BONUSP)#,
            PM_CODE = #val(comm_data.BONUSP)#,
            COMM1 = #val(comm_data.BONUSP)#,
            COMM2 = #val(comm_data.BONUSP)#,
            EXTRA1 = #val(comm_data.BONUSP)#,
            EXTRA2 = #val(comm_data.BONUSP)#,
            EXTRA3 = #val(comm_data.BONUSP)#,
            LEVY_FW_W = #val(comm_data.BONUSP)#,
            LEVY_FW_C = #val(comm_data.BONUSP)#,
            LEVY_SD = #val(comm_data.BONUSP)#,
            NUMOFMTH = #val(comm_data.BONUSP)#,
            ESTBRATE = #val(comm_data.BONUSP)#,
            PAYYES = '#comm_data.payyes#',
            FIXOESP = #val(comm_data.BONUSP)#
            WHERE empno = "#comm_data.EMPNO#" and tmonth = '#date1#'
        </cfquery>
        </cfif>
	
		<!--- EXTRA Calculation --->
		
		<cfquery name="insert_extra12m" datasource="#dts#">
			INSERT INTO extr_12m 
			(EMPNO,BONUSP,SALESAMT,SALESAMT2,BASICPAY,EPFWW,EPFCC,EPFWWEXT,EPFCCEXT,EPGWW,EPGCC,SOASOWW,SOASOCC,SOBSOWW,SOBSOCC,SOCSOWW,SOCSOCC,SODSOWW,SODSOCC,SOESOWW,SOESOCC,UNIONWW,UNIONCC,CCSTAT1,ITAXPCB,ITAXPCBADJ,GROSSPAY,NETPAY,EPF_PAY,CHEQUE_NO,BANKCHARGE,PM_CODE,TMONTH,COMM1,COMM2,EXTRA1,EXTRA2,EXTRA3,LEVY_FW_W,LEVY_FW_C,LEVY_SD,NUMOFMTH,ESTBRATE,PAYYES, FIXOESP)
			VALUES
			(
			"#extra_data.EMPNO#",
			#val(extra_data.BONUSP)#,
			#val(extra_data.SALESAMT)#,
			#val(extra_data.SALESAMT2)#,
			#val(extra_data.BASICPAY)#,
			#val(extra_data.EPFWW)#,
			#val(extra_data.EPFCC)#,
			#val(extra_data.EPFWWEXT)#,
			#val(extra_data.EPFCCEXT)#,
			#val(extra_data.EPGWW)#,
			#val(extra_data.EPGCC)#,
			#val(extra_data.SOASOWW)#,
			#val(extra_data.SOASOCC)#,
			#val(extra_data.SOBSOWW)#,
			#val(extra_data.SOBSOCC)#,
			#val(extra_data.SOCSOWW)#,
			#val(extra_data.SOCSOCC)#,
			#val(extra_data.SODSOWW)#,
			#val(extra_data.SODSOCC)#,
			#val(extra_data.SOESOWW)#,
			#val(extra_data.SOESOCC)#,
			#val(extra_data.UNIONWW)#,
			#val(extra_data.UNIONCC)#,
			#val(extra_data.CCSTAT1)#,
			#val(extra_data.ITAXPCB)#,
			#val(extra_data.ITAXPCBADJ)#,
			#val(extra_data.GROSSPAY)#,
			#val(extra_data.NETPAY)#,
			#val(extra_data.EPF_PAY)#,
			#val(extra_data.CHEQUE_NO)#,
			#val(extra_data.BANKCHARGE)#,
			#val(extra_data.PM_CODE)#,
			#date1#,
			#val(extra_data.COMM1)#,
			#val(extra_data.COMM2)#,
			#val(extra_data.EXTRA1)#,
			#val(extra_data.EXTRA2)#,
			#val(extra_data.EXTRA3)#,
			#val(extra_data.LEVY_FW_W)#,
			#val(extra_data.LEVY_FW_C)#,
			#val(extra_data.LEVY_SD)#,
			#val(extra_data.NUMOFMTH)#,
			#val(extra_data.ESTBRATE)#,
			"#extra_data.PAYYES#",
			#val(extra_data.FIXOESP)#)
		</cfquery>
		
		<!--- HBCE calculation --->
		<cfquery name="HBCE_data" datasource="#dts#">
			SELECT * FROM hbce where empno = "#select_data.empno#"
		</cfquery>
		
		<cfquery name="insert_HBCE12m" datasource="#dts#">
			INSERT INTO hbce_12m (empno, cheque_no, tmonth) 
			VALUES("#HBCE_data.empno#", #val(HBCE_data.cheque_no)#,#date1#)
		</cfquery>
		
		
		
		<!--- update into pay_ytd --->
		<cfquery name="select_pay_ytd" datasource="#dts#">
			SELECT * FROM pay_ytd WHERE empno = "#select_data.empno#"
		</cfquery>
		
		<cfquery name="SELECT_payTM" datasource="#dts#">
			SELECT * FROM pay_tm 
			where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.empno#">
		</cfquery>
		
		<cfquery name="update_pay_ytd" datasource="#dts#">
			UPDATE pay_ytd SET 
			BRATE = #val(select_pay_ytd.BRATE) + val(SELECT_payTM.Brate)#,
			OOB = #val(select_pay_ytd.OOB) + val(SELECT_payTM.OOB)#,
			WDAY = #val(select_pay_ytd.WDAY) + val(SELECT_payTM.WDAY)#,
			DW = #val(select_pay_ytd.DW) + val(SELECT_payTM.DW)#,
			PH = #val(select_pay_ytd.PH) + val(SELECT_payTM.PH)#,
			AL = #val(select_pay_ytd.AL) + val(SELECT_payTM.AL)#,
			ALHR = #val(select_pay_ytd.ALHR) + val(SELECT_payTM.ALHR)#,
			MC = #val(select_pay_ytd.MC) + val(SELECT_payTM.MC)#,
			MT = #val(select_pay_ytd.MT) + val(SELECT_payTM.MT)#,
			CC = #val(select_pay_ytd.CC) + val(SELECT_payTM.CC)#,
			MR = #val(select_pay_ytd.MR) + val(SELECT_payTM.MR)#,
			CL = #val(select_pay_ytd.CL) + val(SELECT_payTM.CL)#,
			HL = #val(select_pay_ytd.HL) + val(SELECT_payTM.HL)#,
			AD = #val(select_pay_ytd.AD) + val(SELECT_payTM.AD)#,
            PT = #val(select_pay_ytd.PT) + val(SELECT_payTM.PT)#,
            ECL = #val(select_pay_ytd.ECL) + val(SELECT_payTM.ECL)#,
            OIL = #val(select_pay_ytd.OIL) + val(SELECT_payTM.OIL)#,
            RS = #val(select_pay_ytd.RS) + val(SELECT_payTM.RS)#,
            toff = #val(select_pay_ytd.toff) + val(SELECT_payTM.toff)#,
			EX = #val(select_pay_ytd.EX) + val(SELECT_payTM.EX)#,
			LS = #val(select_pay_ytd.LS) + val(SELECT_payTM.LS)#,
			OPL = #val(select_pay_ytd.OPL) + val(SELECT_payTM.OPL)#,
			NPL = #val(select_pay_ytd.NPL) + val(SELECT_payTM.NPL)#,
			AB = #val(select_pay_ytd.AB) + val(SELECT_payTM.AB)#,
			ONPL = #val(select_pay_ytd.ONPL) + val(SELECT_payTM.ONPL)#,
			NS = #val(select_pay_ytd.NS) + val(SELECT_payTM.NS)#,
			WORKHR = #val(select_pay_ytd.WORKHR) + val(SELECT_payTM.WORKHR)#,
			LATEHR = #val(select_pay_ytd.LATEHR) + val(SELECT_payTM.LATEHR)#,
			EARLYHR = #val(select_pay_ytd.EARLYHR) + val(SELECT_payTM.EARLYHR)#,
			NOPAYHR = #val(select_pay_ytd.NOPAYHR) + val(SELECT_payTM.NOPAYHR)#,
			HR1 = #val(select_pay_ytd.HR1) + val(SELECT_payTM.HR1)#,
			HR2 = #val(select_pay_ytd.HR2) + val(SELECT_payTM.HR2)#,
			HR3 = #val(select_pay_ytd.HR3) + val(SELECT_payTM.HR3)#,
			HR4 = #val(select_pay_ytd.HR4) + val(SELECT_payTM.HR4)#,
			HR5 = #val(select_pay_ytd.HR5) + val(SELECT_payTM.HR5)#,
			HR6 = #val(select_pay_ytd.HR6) + val(SELECT_payTM.HR6)#,
			BASICPAY = #val(select_pay_ytd.BASICPAY) + val(SELECT_payTM.BASICPAY)#,
			OTPAY = #val(select_pay_ytd.OTPAY) + val(SELECT_payTM.OTPAY)#,
			DIRFEE = #val(select_pay_ytd.DIRFEE) + val(SELECT_payTM.DIRFEE)#,
			TAW = #val(select_pay_ytd.TAW) + val(SELECT_payTM.TAW)#,
			GROSSPAY = #val(select_pay_ytd.GROSSPAY) + val(SELECT_payTM.GROSSPAY)#,
			TDEDU = #val(select_pay_ytd.TDEDU) + val(SELECT_payTM.TDEDU)#,
			TDED = #val(select_pay_ytd.TDED) + val(SELECT_payTM.TDED)#,
			NETPAY = #val(select_pay_ytd.NETPAY) + val(SELECT_payTM.NETPAY)#,
			BONUS = #val(select_pay_ytd.BONUS) + val(SELECT_payTM.BONUS)#,
			EXTRA = #val(select_pay_ytd.EXTRA) + val(SELECT_payTM.EXTRA)#,
			COMM = #val(select_pay_ytd.COMM) + val(SELECT_payTM.COMM)#,
			<!--- TXOT --->
			TXAW = #val(select_pay_ytd.TXAW) + val(SELECT_payTM.TXAW)#,
			TXDED = #val(select_pay_ytd.TXDED) + val(SELECT_payTM.TXDED)#,
			OT1 = #val(select_pay_ytd.OT1) + val(SELECT_payTM.OT1)#,
			OT2 = #val(select_pay_ytd.OT2) + val(SELECT_payTM.OT2)#,
			OT3 = #val(select_pay_ytd.OT3) + val(SELECT_payTM.OT3)#,
			OT4 = #val(select_pay_ytd.OT4) + val(SELECT_payTM.OT4)#,
			OT5 = #val(select_pay_ytd.OT5) + val(SELECT_payTM.OT5)#,
			OT6 = #val(select_pay_ytd.OT6) + val(SELECT_payTM.OT6)#,
			AW101 = #val(select_pay_ytd.AW101) + val(SELECT_payTM.AW101)#,
			AW102 = #val(select_pay_ytd.AW102) + val(SELECT_payTM.AW102)#,
			AW103 = #val(select_pay_ytd.AW103) + val(SELECT_payTM.AW103)#,
			AW104 = #val(select_pay_ytd.AW104) + val(SELECT_payTM.AW104)#,
			AW105 = #val(select_pay_ytd.AW105) + val(SELECT_payTM.AW105)#,
			AW106 = #val(select_pay_ytd.AW106) + val(SELECT_payTM.AW106)#,
			AW107 = #val(select_pay_ytd.AW107) + val(SELECT_payTM.AW107)#,
			AW108 = #val(select_pay_ytd.AW108) + val(SELECT_payTM.AW108)#,
			AW109 = #val(select_pay_ytd.AW109) + val(SELECT_payTM.AW109)#,
			AW110 = #val(select_pay_ytd.AW110) + val(SELECT_payTM.AW110)#,
			AW111 = #val(select_pay_ytd.AW111) + val(SELECT_payTM.AW111)#,
			AW112 = #val(select_pay_ytd.AW112) + val(SELECT_payTM.AW112)#,
			AW113 = #val(select_pay_ytd.AW113) + val(SELECT_payTM.AW113)#,
			AW114 = #val(select_pay_ytd.AW114) + val(SELECT_payTM.AW114)#,
			AW115 = #val(select_pay_ytd.AW115) + val(SELECT_payTM.AW115)#,
			AW116 = #val(select_pay_ytd.AW116) + val(SELECT_payTM.AW116)#,
			AW117 = #val(select_pay_ytd.AW117) + val(SELECT_payTM.AW117)#,
			DED101 = #val(select_pay_ytd.DED101) + val(SELECT_payTM.DED101)#,
			DED102 = #val(select_pay_ytd.DED102) + val(SELECT_payTM.DED102)#,
			DED103 = #val(select_pay_ytd.DED103) + val(SELECT_payTM.DED103)#,
			DED104 = #val(select_pay_ytd.DED104) + val(SELECT_payTM.DED104)#,
			DED105 = #val(select_pay_ytd.DED105) + val(SELECT_payTM.DED105)#,
			DED106 = #val(select_pay_ytd.DED106) + val(SELECT_payTM.DED106)#,
			DED107 = #val(select_pay_ytd.DED107) + val(SELECT_payTM.DED107)#,
			DED108 = #val(select_pay_ytd.DED108) + val(SELECT_payTM.DED108)#,
			DED109 = #val(select_pay_ytd.DED109) + val(SELECT_payTM.DED109)#,
			DED110 = #val(select_pay_ytd.DED110) + val(SELECT_payTM.DED110)#,
			DED111 = #val(select_pay_ytd.DED111) + val(SELECT_payTM.DED111)#,
			DED112 = #val(select_pay_ytd.DED112) + val(SELECT_payTM.DED112)#,
			DED113 = #val(select_pay_ytd.DED113) + val(SELECT_payTM.DED113)#,
			DED114 = #val(select_pay_ytd.DED114) + val(SELECT_payTM.DED114)#,
			DED115 = #val(select_pay_ytd.DED115) + val(SELECT_payTM.DED115)#,
			ADVANCE = #val(select_pay_ytd.ADVANCE) + val(SELECT_payTM.ADVANCE)#,
			ITAXPCB = #val(select_pay_ytd.ITAXPCB) + val(SELECT_payTM.ITAXPCB)#,
			ITAXPCBADJ = #val(select_pay_ytd.ITAXPCBADJ) + val(SELECT_payTM.ITAXPCBADJ)#,
			EPFWW = #val(select_pay_ytd.EPFWW) + val(SELECT_payTM.EPFWW) + val(SELECT_payTM.B_EPFWW)+ val(SELECT_payTM.C_EPFWW)#,
			EPFCC = #val(select_pay_ytd.EPFCC) + val(SELECT_payTM.EPFCC) + val(SELECT_payTM.B_EPFCC)+ val(SELECT_payTM.C_EPFCC)#,
			EPFWWEXT = #val(select_pay_ytd.EPFWWEXT) + val(SELECT_payTM.EPFWWEXT)#,
			EPFCCEXT = #val(select_pay_ytd.EPFCCEXT) + val(SELECT_payTM.EPFCCEXT)#,
			SOASOWW = #val(select_pay_ytd.SOASOWW) + val(SELECT_payTM.SOASOWW)#,
			SOASOCC = #val(select_pay_ytd.SOASOCC) + val(SELECT_payTM.SOASOCC)#,
			SOBSOWW = #val(select_pay_ytd.SOBSOWW) + val(SELECT_payTM.SOBSOWW)#,
			SOBSOCC = #val(select_pay_ytd.SOBSOCC) + val(SELECT_payTM.SOBSOCC)#,
			SOCSOWW = #val(select_pay_ytd.SOCSOWW) + val(SELECT_payTM.SOCSOWW)#,
			SOCSOCC = #val(select_pay_ytd.SOCSOCC) + val(SELECT_payTM.SOCSOCC)#,
			SODSOWW = #val(select_pay_ytd.SODSOWW) + val(SELECT_payTM.SODSOWW)#,
			SODSOCC = #val(select_pay_ytd.SODSOCC) + val(SELECT_payTM.SODSOCC)#,
			SOESOWW = #val(select_pay_ytd.SOESOWW) + val(SELECT_payTM.SOESOWW)#,
			SOESOCC = #val(select_pay_ytd.SOESOCC) + val(SELECT_payTM.SOESOCC)#,
			UNIONWW = #val(select_pay_ytd.UNIONWW) + val(SELECT_payTM.UNIONWW)#,
			UNIONCC = #val(select_pay_ytd.UNIONCC) + val(SELECT_payTM.UNIONCC)#,
			CCSTAT1 = #val(select_pay_ytd.CCSTAT1) + val(SELECT_payTM.CCSTAT1)#,
			PENCEN = #val(select_pay_ytd.PENCEN) + val(SELECT_payTM.PENCEN)#,
			MFUND = #val(select_pay_ytd.MFUND) + val(SELECT_payTM.MFUND)#,
			DFUND = #val(select_pay_ytd.DFUND) + val(SELECT_payTM.DFUND)#,
			EPF_PAY = #val(select_pay_ytd.EPF_PAY) + val(SELECT_payTM.EPF_PAY)#,
			EPF_PAY_A = #val(select_pay_ytd.EPF_PAY_A) + val(SELECT_payTM.EPF_PAY_A)#,
			EPF_PAY_B = #val(select_pay_ytd.EPF_PAY_B) + val(SELECT_payTM.EPF_PAY_B)#,
			EPF_PAY_C = #val(select_pay_ytd.EPF_PAY_C) + val(SELECT_payTM.EPF_PAY_C)#,
			ACTIV_MTH =#val(select_pay_ytd.ACTIV_MTH) + 1#,
			ADDITIONALWAGES = #val(select_pay_ytd.additionalwages) + val(SELECT_payTM.additionalwages)#
			
			
			WHERE empno = "#select_data.empno#"
		</cfquery>
</cfloop>
<!--- project update --->
		<cfquery name="proj_pay_qry" datasource="#dts#">
			INSERT into proj_pay_12m (
			Select * , "#company_details.mmonth#" as tmonth from proj_pay
			)
		</cfquery>
		
		<cfquery name="truncate_proj_pay" datasource="#dts#">
			Truncate proj_pay
		</cfquery>
		
		<!--- combine 1st half and 2nd half month figure update ---> 

<cfquery name="truncate_pay_12m" datasource="#dts#">
	truncate pay_12m ;
</cfquery>	
		
		<cfquery name="sum_all" datasource="#dts#">
			Insert into pay_12m
			(SELECT EMPNO, TMONTH, sum(BRATE) as brate, sum(oob) as OOB, sum(wday) as WDAY, sum(DW) as dw, sum(PH) as ph, sum(AL) as al, ALHR,
				   sum(mc) as MC, sum(mt)as MT, sum(cc) as CC, sum(pt) as PT, sum(mr) as MR, sum(cl) as CL, sum(hl) as HL,
				   sum(ad) as AD, sum(ex) as EX, sum(ls) as LS, sum(OPL) as opl, sum(npl) as NPL, sum(ab) as AB, sum(onpl) as ONPL,
				   sum(workhr) as WORKHR, sum(latehr) as LATEHR, sum(EARLYHR) as EARLYHR, sum(NOPAYHR) as NOPAYHR,
				   sum(hr1) as HR1, sum(hr2) as HR2, sum(hr3) as HR3, sum(hr4) as HR4, sum(hr5) as HR5,sum(hr6) as HR6,
				  sum(basicpay) as BASICPAY, sum(OTPAY) as OTPAY, sum(DIRFEE) as DIRFEE, sum(taw) as TAW, sum(grosspay) as GROSSPAY, sum(tdedu) as TDEDU, 
				  sum(tded) as TDED,
				  sum(netpay) as NETPAY, sum(netpayadj) as NETPAYADJ,
				  sum(nplpay), sum(bonus),sum(comm)as COMM,sum(extra) as EXTRA,
				  sum(TXOT) as TXOT, sum(txaw) as TXAW, sum(txded) as TXDED,
				  sum(ot1) as OT1, sum(ot2) as OT2, sum(ot3) as OT3,sum(ot4) as OT4,sum(ot5) as OT5,sum(ot6) as OT6,
				  sum(aw101) as AW101,sum(aw102)as AW102, sum(aw103)as AW103,sum(aw104) as AW104, sum(aw105) as AW105,
				  sum(aw106)as AW106, sum(aw107) as AW107, sum(aw108) as AW108, sum(aw109) as AW109, sum(aw110) as AW110,
				  sum(aw111) as AW111, sum(aw112) as AW112,sum(aw113)as AW113, sum(aw114) as AW114, sum(aw115) as AW115,
				  sum(aw116) as AW116, sum(aw117) as AW117,
				  sum(ded101) as DED101, sum(ded102) as DED102,sum(ded103) as DED103, sum(ded104) as DED104, sum(ded105) as DED105,
		      	  sum(ded106) as DED106, sum(ded107) as DED107,sum(ded108) as DED108,
				  sum(ded109) as DED109, sum(ded110) as DED110,sum(ded111) as DED111, sum(ded112)as DED112, 
				  sum(ded113) as DED113, sum(ded114) as DED114, sum(ded115) as DED115, sum(advance) as ADVANCE,
				  sum(ITAXPCB) as ITAXPCB, sum(ITAXPCBADJ) as ITAXPCBADJ, sum(EPFWW) as EPFWW, sum(EPFCC) as EPFCC, 
				  sum(EPFWWEXT)as EPFWWEXT, sum(EPFCCEXT) as EPFCCEXT, sum(EPGWW)as EPGWW ,sum(EPGCC) as EPGCC, 
				  sum(SOASOWW) as SOASOWW, sum(SOASOCC) as SOASOCC, sum(SOBSOWW) as SOBSOWW, sum(SOBSOCC)as SOBSOCC,
				  sum(SOCSOWW) as SOCSOWW, sum(SOCSOCC) as SOCSOCC, sum(SODSOWW) as SODSOWW, sum(SODSOCC) as SODSOCC, 
				  sum(SOESOWW) as SOESOWW, sum(SOESOCC) as SOESOCC, sum(UNIONWW) as UNIONWW, sum(UNIONCC) as UNIONCC, 
				  sum(CCSTAT1) as CCSTAT1, sum(PENCEN)as PENCEN, sum(BINK) as BINK ,sum(MFUND) as MFUND, sum(DFUND) as DFUND,
				  sum(EPF_PAY), sum(EPF_PAY_A),sum(EPF_PAY_B), sum(EPF_PAY_C), sum(TAWCPF), sum(TAWCPFWW),sum(TAWCPFCC),
				  sum(HRD_PAY), ACTIV_MTH, AR_ACC1, AR_ACC2, AR_ACC3, AR_ACC4, AR_ACC5, PAYYES,
				  sum(RATE1)/2 as rate1, sum(rate2)/2 as RATE2,sum(rate3)/2 as RATE3, sum(RATE4)/2 as rate4, sum(rate5)/2 as RATE5,
				  sum(rate6)/2 as RATE6, "#HUserName#" as update_by, "#dateformat(now(),'yyyymmdd')#" as update_on,  sum(ns) as NS, sum(ADDITIONALWAGES) as ADDITIONALWAGES,trim(GROUP_CONCAT(CHEQUE_NO SEPARATOR ' ')) as CHEQUE_NO,sum(ecl) as ECL,sum(oil) as OIL,sum(rs) as RS, sum(toff) as toff 
					
			from (select EMPNO, TMONTH, BRATE, OOB, WDAY, DW, PH, AL, ALHR, MC, MT,
				  CC, PT, MR, CL, HL, AD, EX, LS, OPL, NPL, AB, ONPL, WORKHR, LATEHR, EARLYHR, NOPAYHR,
				  HR1, HR2, HR3, HR4, HR5, HR6, BASICPAY, OTPAY, DIRFEE, TAW, GROSSPAY, TDEDU, TDED, NETPAY, NETPAYADJ,
				  NPLPAY, BONUS, COMM, EXTRA, TXOT, TXAW, TXDED, OT1, OT2, OT3, OT4, OT5, OT6, AW101, AW102, AW103, AW104, AW105, AW106,
				  AW107, AW108, AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117, DED101, DED102, DED103, DED104,
				  DED105, DED106, DED107, DED108, DED109, DED110, DED111, DED112, DED113, DED114, DED115, ADVANCE,
				  ITAXPCB, ITAXPCBADJ, EPFWW, EPFCC, EPFWWEXT, EPFCCEXT, EPGWW ,EPGCC, SOASOWW, SOASOCC, SOBSOWW, SOBSOCC,
				  SOCSOWW, SOCSOCC, SODSOWW, SODSOCC, SOESOWW, SOESOCC, UNIONWW, UNIONCC, CCSTAT1, PENCEN, BINK ,MFUND, DFUND,
				  EPF_PAY, EPF_PAY_A, EPF_PAY_B, EPF_PAY_C, TAWCPF, TAWCPFWW, TAWCPFCC, HRD_PAY, ACTIV_MTH, AR_ACC1, AR_ACC2,
				  AR_ACC3, AR_ACC4, AR_ACC5, PAYYES, RATE1, RATE2, RATE3, RATE4, RATE5, RATE6, update_by,update_on,NS,ADDITIONALWAGES,CHEQUE_NO,ECL,OIL,RS,toff  FROM PAY1_12M_FIG AS A
			UNION ALL SELECT EMPNO, TMONTH, BRATE, OOB, WDAY, DW, PH, AL, ALHR, MC, MT,
				  CC, PT, MR, CL, HL, AD, EX, LS, OPL, NPL, AB, ONPL, WORKHR, LATEHR, EARLYHR, NOPAYHR,
				  HR1, HR2, HR3, HR4, HR5, HR6, BASICPAY, OTPAY, DIRFEE, TAW, GROSSPAY, TDEDU, TDED, NETPAY, NETPAYADJ,
				  NPLPAY, BONUS, COMM, EXTRA, TXOT, TXAW, TXDED, OT1, OT2, OT3, OT4, OT5, OT6, AW101, AW102, AW103, AW104, AW105, AW106,
				  AW107, AW108, AW109, AW110, AW111, AW112, AW113, AW114, AW115, AW116, AW117, DED101, DED102, DED103, DED104,
				  DED105, DED106, DED107, DED108, DED109, DED110, DED111, DED112, DED113, DED114, DED115, ADVANCE,
				  ITAXPCB, ITAXPCBADJ, EPFWW, EPFCC, EPFWWEXT, EPFCCEXT, EPGWW ,EPGCC, SOASOWW, SOASOCC, SOBSOWW, SOBSOCC,
				  SOCSOWW, SOCSOCC, SODSOWW, SODSOCC, SOESOWW, SOESOCC, UNIONWW, UNIONCC, CCSTAT1, PENCEN, BINK ,MFUND, DFUND,
				  EPF_PAY, EPF_PAY_A, EPF_PAY_B, EPF_PAY_C, TAWCPF, TAWCPFWW, TAWCPFCC, HRD_PAY, ACTIV_MTH, AR_ACC1, AR_ACC2,
				  AR_ACC3, AR_ACC4, AR_ACC5, PAYYES, RATE1, RATE2, RATE3, RATE4, RATE5, RATE6, update_by, update_on, NS, ADDITIONALWAGES,CHEQUE_NO,ECL,OIL,RS,toff 
			FROM PAY2_12M_FIG AS B) AS C
			GROUP BY EMPNO,TMONTH)
		</cfquery>
        
 <!--- 	month end project --->
		
<cfquery name="proj_rcd_qry_1" datasource="#dts#">
    INSERT into proj_rcd_12m 
    (empno, project_code, date_p, dw_p, mc_p,al_p,ph_p, npl_p, ot1_p, ot2_p, ot3_p, ot4_p, ot5_p, ot6_p, 
    netpay, userid, jobcosting, tmonth, UPDATE_BY, UPDATE_ON,proj_epfcc,proj_epfww,proj_gross,proj_fwl,proj_post_aw,
    proj_post_ded,proj_post_basic,proj_post_totalepf)
    Select empno, project_code, date_p, dw_p, mc_p,al_p,ph_p, npl_p, ot1_p, ot2_p, ot3_p, ot4_p, ot5_p, ot6_p, 
    netpay, userid, jobcosting, "#company_details.mmonth#" as tmonth, "#HUserName#" AS UPDATE_BY, 
    "#dateformat(now(),'yyyymmdd')#",proj_epfcc,proj_epfww,proj_gross,proj_fwl,proj_post_aw,
    proj_post_ded,proj_post_basic,proj_post_totalepf AS UPDATE_ON from proj_rcd
</cfquery>

<cfquery name="truncate_proj_pay_1" datasource="#dts#">
    Truncate proj_rcd
</cfquery>


<cfquery name="proj_pay_qry_2" datasource="#dts#">
    INSERT into proj_rcd_12m_1 
    (empno, project_code, date_p, dw_p, mc_p,al_p,ph_p, npl_p, ot1_p, ot2_p, ot3_p, ot4_p, ot5_p, ot6_p, 
    netpay, userid, jobcosting, tmonth, UPDATE_BY, UPDATE_ON,proj_epfcc,proj_epfww,proj_gross,proj_fwl,proj_post_aw,
    proj_post_ded,proj_post_basic,proj_post_totalepf)
    Select empno, project_code, date_p, dw_p, mc_p,al_p,ph_p, npl_p, ot1_p, ot2_p, ot3_p, ot4_p, ot5_p, ot6_p, 
    netpay, userid, jobcosting, "#company_details.mmonth#" as tmonth, "#HUserName#" AS UPDATE_BY, 
    "#dateformat(now(),'yyyymmdd')#",proj_epfcc,proj_epfww,proj_gross,proj_fwl,proj_post_aw,
    proj_post_ded,proj_post_basic,proj_post_totalepf AS UPDATE_ON
    from proj_rcd_1
</cfquery>

<cfquery name="truncate_proj_pay_2" datasource="#dts#">
    Truncate proj_rcd_1
</cfquery>


        
<cfif trans_type eq "MFT">	
	<cfquery name="select_emp_pay_non_a" datasource="#dts#">
		select empno from pmast where paystatus <>"A"
	</cfquery>
	<cfloop query="select_emp_pay_non_a">
		<cfquery name="update_payTran" datasource="#dts#">
			update paytran 
			set 
			BRATE = null,
			BRATE2 = null, 
			BACKPAY = null,
			OOB = null,
			WDAY = null,
			WDAY2 = null,
			DW = null,
			DW2 = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			MR = null,
			PT = null,
            OIL = null,
            ECL = null,
            RS = null,
            toff = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null,
			LS = null,
			OPLD = null,
			OPL = null,
			NPL = null,
			NPL2 = null,
			AB = null,
            NS = null,
			ONPLD = null,
			ONPL = null,
			ALTAWDAY = null,
			ALTAWRATE = null,
			ALTAWAMT = null,
			DWAWADJ = null,
			ALBFTMP = null,
			MCBFTMP = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			RATE1 = null,
			RATE2 = null,
			RATE3 = null,
			RATE4 = null,
			RATE5 = null,
			RATE6 = null,
			HR1 = null,
			HR2 = null,
			HR3 = null, 
			HR4 = null,
			HR5 = null,
			HR6 = null,
			DIRFEE = null,
			AW101= null,
			AW102 = null,
			AW103 = null,
			AW104= null,
			AW105 = null,
			AW106 = null,
			AW107 = null, 
			AW108= null,
			AW109= null,
			AW110 = null,
			AW111= null,
			AW112 = null,
			AW113 = null,
			AW114 = null,
			AW115 = null,
			AW116 = null,
			AW117 = null,
			DED101 = null,
			DED102 = null,
			DED103 = null,
			DED104 = null,
			DED105 = null,
			DED106 = null,
			DED107 = null,
			DED108 = null,
			DED109 = null,
			DED110 = null,
			DED111= null,
			DED112= null,
			DED113 = null,
			DED114 = null,
			DED115 = null,
			MESS = null,
			MESS1 = null,
			FIXOESP = null,
			SHIFTA = null,
			SHIFTB = null,
			SHIFTC = null,
			SHIFTD = null,
			SHIFTE = null,
			SHIFTF = null,
			SHIFTG = null,
			SHIFTH = null,
			SHIFTI = null,
			SHIFTJ = null,
			SHIFTK= null,
			SHIFTL= null,
			SHIFTM= null,
			SHIFTN= null,
			SHIFTO= null,
			SHIFTP= null,
			SHIFTQ= null,
			SHIFTR= null,
			SHIFTS= null,
			SHIFTT= null,
			TIPPOINT= null,
			CLTIPOINT= null,
			TIPRATE= null,
			MFUND= null,
			DFUND= null,
			ZAKAT_BF= null,
			ZAKAT_BFN= null,
			PIECEPAY= null,
			BASICPAY= null,
			FULLPAY= null,
			NPLPAY= null,
			OT1= null,
			OT2= null,
			OT3= null,
			OT4= null,
			OT5= null,
			OT6= null,
			OTPAY= null,
			EPFWW= null,
			EPFCC= null,
			EPFWWEXT= null,
			EPFCCEXT= null,
			EPGWW= null,
			EPGCC= null,
			SOASOWW= null,
			SOASOCC= null,
			SOBSOWW= null,
			SOBSOCC= null,
			SOCSOWW= null,
			SOCSOCC= null,
			SODSOWW= null,
			SODSOCC= null,
			SOESOWW= null,
			SOESOCC= null,
			UNIONWW= null,
			UNIONCC= null,
			ADVANCE= null,
			ADVPAY= null,
			TIPAMT= null,
			ITAXPCB= null,
			ITAXPCBADJ= null,
			TAW= null,
			TXOTPAY= null,
			TXAW= null,
			TXDED= null,
			TDED= null,
			TDEDU= null,
			GROSSPAY= null,
			NETPAY= null,
			EPF_PAY= null,
			EPF_PAY_A= null,
			CCSTAT1= null,
			CCSTAT2= null,
			CCSTAT3= null,
			PENCEN= null,
			PROJECT= null,
			CHEQUE_NO= null,
			BANKCHARGE= null,
			ADVDAY= null,
			PM_CODE= null,
			TMONTH= null,
			UDRATE1= null,
			UDRATE2= null,
			UDRATE3= null,
			UDRATE4= null,
			UDRATE5= null,
			UDRATE6= null,
			UDRATE7= null,
			UDRATE8= null,
			UDRATE9= null,
			UDRATE10= null,
			UDRATE11= null,
			UDRATE12= null,
			UDRATE13= null,
			UDRATE14= null,
			UDRATE15= null,
			UDRATE16= null,
			UDRATE17= null,
			UDRATE18= null,
			UDRATE19= null,
			UDRATE20= null,
			UDRATE21= null,
			UDRATE22= null,
			UDRATE23= null,
			UDRATE24= null,
			UDRATE25= null,
			UDRATE26= null,
			UDRATE27= null,
			UDRATE28= null,
			UDRATE29= null,
			UDRATE30= null,
			PAYYES= null
			where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_emp_pay_non_a.empno#">
		</cfquery>
		<cfquery name="update_payTra1" datasource="#dts#">
			update paytra1 
			set 
			BRATE = null,
			BRATE2 = null, 
			BACKPAY = null,
			OOB = null,
			WDAY = null,
			WDAY2 = null,
			DW = null,
			DW2 = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			MR = null,
			PT = null,
            OIL = null,
            ECL = null,
            RS = null,
            toff = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null,
			LS = null,
			OPLD = null,
			OPL = null,
			NPL = null,
			NPL2 = null,
			AB = null,
			ONPLD = null,
			NS = null,
			ONPL = null,
			ALTAWDAY = null,
			ALTAWRATE = null,
			ALTAWAMT = null,
			DWAWADJ = null,
			ALBFTMP = null,
			MCBFTMP = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			RATE1 = null,
			RATE2 = null,
			RATE3 = null,
			RATE4 = null,
			RATE5 = null,
			RATE6 = null,
			HR1 = null,
			HR2 = null,
			HR3 = null, 
			HR4 = null,
			HR5 = null,
			HR6 = null,
			DIRFEE = null,
			AW101= null,
			AW102 = null,
			AW103 = null,
			AW104= null,
			AW105 = null,
			AW106 = null,
			AW107 = null, 
			AW108= null,
			AW109= null,
			AW110 = null,
			AW111= null,
			AW112 = null,
			AW113 = null,
			AW114 = null,
			AW115 = null,
			AW116 = null,
			AW117 = null,
			DED101 = null,
			DED102 = null,
			DED103 = null,
			DED104 = null,
			DED105 = null,
			DED106 = null,
			DED107 = null,
			DED108 = null,
			DED109 = null,
			DED110 = null,
			DED111= null,
			DED112= null,
			DED113 = null,
			DED114 = null,
			DED115 = null,
			MESS = null,
			MESS1 = null,
			FIXOESP = null,
			SHIFTA = null,
			SHIFTB = null,
			SHIFTC = null,
			SHIFTD = null,
			SHIFTE = null,
			SHIFTF = null,
			SHIFTG = null,
			SHIFTH = null,
			SHIFTI = null,
			SHIFTJ = null,
			SHIFTK= null,
			SHIFTL= null,
			SHIFTM= null,
			SHIFTN= null,
			SHIFTO= null,
			SHIFTP= null,
			SHIFTQ= null,
			SHIFTR= null,
			SHIFTS= null,
			SHIFTT= null,
			TIPPOINT= null,
			CLTIPOINT= null,
			TIPRATE= null,
			MFUND= null,
			DFUND= null,
			ZAKAT_BF= null,
			ZAKAT_BFN= null,
			PIECEPAY= null,
			BASICPAY= null,
			FULLPAY= null,
			NPLPAY= null,
			OT1= null,
			OT2= null,
			OT3= null,
			OT4= null,
			OT5= null,
			OT6= null,
			OTPAY= null,
			EPFWW= null,
			EPFCC= null,
			EPFWWEXT= null,
			EPFCCEXT= null,
			EPGWW= null,
			EPGCC= null,
			SOASOWW= null,
			SOASOCC= null,
			SOBSOWW= null,
			SOBSOCC= null,
			SOCSOWW= null,
			SOCSOCC= null,
			SODSOWW= null,
			SODSOCC= null,
			SOESOWW= null,
			SOESOCC= null,
			UNIONWW= null,
			UNIONCC= null,
			ADVANCE= null,
			ADVPAY= null,
			TIPAMT= null,
			ITAXPCB= null,
			ITAXPCBADJ= null,
			TAW= null,
			TXOTPAY= null,
			TXAW= null,
			TXDED= null,
			TDED= null,
			TDEDU= null,
			GROSSPAY= null,
			NETPAY= null,
			EPF_PAY= null,
			EPF_PAY_A= null,
			CCSTAT1= null,
			CCSTAT2= null,
			CCSTAT3= null,
			PENCEN= null,
			PROJECT= null,
			CHEQUE_NO= null,
			BANKCHARGE= null,
			ADVDAY= null,
			PM_CODE= null,
			TMONTH= null,
			UDRATE1= null,
			UDRATE2= null,
			UDRATE3= null,
			UDRATE4= null,
			UDRATE5= null,
			UDRATE6= null,
			UDRATE7= null,
			UDRATE8= null,
			UDRATE9= null,
			UDRATE10= null,
			UDRATE11= null,
			UDRATE12= null,
			UDRATE13= null,
			UDRATE14= null,
			UDRATE15= null,
			UDRATE16= null,
			UDRATE17= null,
			UDRATE18= null,
			UDRATE19= null,
			UDRATE20= null,
			UDRATE21= null,
			UDRATE22= null,
			UDRATE23= null,
			UDRATE24= null,
			UDRATE25= null,
			UDRATE26= null,
			UDRATE27= null,
			UDRATE28= null,
			UDRATE29= null,
			UDRATE30= null,
			PAYYES= null
			where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_emp_pay_non_a.empno#">
		</cfquery>
		
		<cfquery name="update_pay_tm_NONa" datasource="#dts#">
			update pay_tm 
			set BRATE = null,
				OOB= null,
				WDAY = null,
				DW= null,
				PH= null,
				AL= null,
				ALHR= null,
				MC= null,
				MT= null,
				CC= null,
				PT= null,
                OIL = null,
                ECL = null,
                RS = null,
                toff = null,
				MR= null,
				CL= null,
				HL= null,
				AD= null,
				EX= null,
				LS= null,
				OPL= null,
				NPL= null,
				AB= null,
				ONPL= null,
				NS = null,
				WORKHR= null,
				LATEHR= null,
				EARLYHR= null,
				NOPAYHR= null,
				HR1= null,
				HR2= null,
				HR3= null,
				HR4= null,
				HR5= null,
				HR6= null,
				BASICPAY= null,
				OTPAY= null,
				DIRFEE= null,
				TAW= null,
				GROSSPAY= null,
				TDEDU= null,
				TDED = null,
				NETPAY = null,
				NETPAYADJ = null,
				NPLPAY = null,
				BONUS = null,
				COMM = null,
				EXTRA= null,
				TXOT = null,
				TXAW = null,
				TXDED = null,
				OT1 = null,
				OT2 = null,
				OT3 = null,
				OT4 = null,
				OT5 =  null,
				OT6 = null,
				AW101 = null,
				AW102 = null,
				AW103 = null,
				AW104 = null,
				AW105 = null,
				AW106 = null,
				AW107 = null,
				AW108 = null,
				AW109 = null,
				AW110 = null,
				AW111 = null,
				AW112 = null,
				AW113 = null,
				AW114 =  null,
				AW115 = null,
				AW116 = null,
				AW117 = null,
				DED101 = null,
				DED102 = null,
				DED103 = null,
				DED104 = null,
				DED105 = null,
				DED106 =  null,
				DED107 = null,
				DED108 = null,
				DED109 = null,
				DED110 = null,
				DED111 = null,
				DED112 = null,
				DED113 = null,
				DED114 = null,
				DED115 = null,
				ADVANCE = null,
				ITAXPCB = null,
				ITAXPCBADJ = null,
				EPFWW = null,
				EPFCC = null,
				EPFWWEXT = null,
				EPFCCEXT = null,
				EPGWW = null,
				EPGCC = null,
				SOASOWW = null,
				SOASOCC = null,
				SOBSOWW = null,
				SOBSOCC = null,
				SOCSOWW = null,
				SOCSOCC = null,
				SODSOWW = null,
				SODSOCC = null,
				SOESOWW = null,
				SOESOCC = null,
				UNIONWW = null,
				UNIONCC = null,
				CCSTAT1 = null,
				PENCEN = null,
				BINK = null,
				MFUND = null,
				DFUND = null,
				EPF_PAY = null,
				EPF_PAY_A = null,
				EPF_PAY_B = null,
				EPF_PAY_C = null,
				TAWCPF = null,
				TAWCPFWW = null,
				TAWCPFCC = null, 
				HRD_PAY = null,
				ACTIV_MTH = null,
				AR_ACC1 = null,
				AR_ACC2 = null,
				AR_ACC3 = null,
				AR_ACC4 = null,
				AR_ACC5 = null,
				PAYYES = null,
				B_EPFWW = null,
				B_EPFCC = null,
				CPF_AMT = null,
				c_epfww = null,
				c_epfcc = null,
				p_epfww = null,
				p_epfcc = null,
				re_cpf_all = null
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_emp_pay_non_a.empno#">
			</cfquery>
	</cfloop>
</cfif>	
	
<cfif trans_type eq "RT">
<cfquery name="BPO_qry1" datasource="#dts#">
UPDATE paytran
SET
			BRATE = null,
			BRATE2 = null, 
			BACKPAY = null,
			OOB = null,
			WDAY = null,
			WDAY2 = null,
			DW = null,
			DW2 = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			MR = null,
			PT = null,
            OIL = null,
            ECL = null,
            RS = null,
            toff = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null,
			LS = null,
			OPLD = null,
			OPL = null,
			NPL = null,
			NPL2 = null,
			AB = null,
			ONPLD = null,
			ONPL = null,
			NS = null,
			ALTAWDAY = null,
			ALTAWRATE = null,
			ALTAWAMT = null,
			DWAWADJ = null,
			ALBFTMP = null,
			MCBFTMP = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			RATE1 = null,
			RATE2 = null,
			RATE3 = null,
			RATE4 = null,
			RATE5 = null,
			RATE6 = null,
			HR1 = null,
			HR2 = null,
			HR3 = null, 
			HR4 = null,
			HR5 = null,
			HR6 = null,
			DIRFEE = null,
			AW101= null,
			AW102 = null,
			AW103 = null,
			AW104= null,
			AW105 = null,
			AW106 = null,
			AW107 = null, 
			AW108= null,
			AW109= null,
			AW110 = null,
			AW111= null,
			AW112 = null,
			AW113 = null,
			AW114 = null,
			AW115 = null,
			AW116 = null,
			AW117 = null,
			DED101 = null,
			DED102 = null,
			DED103 = null,
			DED104 = null,
			DED105 = null,
			DED106 = null,
			DED107 = null,
			DED108 = null,
			DED109 = null,
			DED110 = null,
			DED111= null,
			DED112= null,
			DED113 = null,
			DED114 = null,
			DED115 = null,
			MESS = null,
			MESS1 = null,
			FIXOESP = null,
			SHIFTA = null,
			SHIFTB = null,
			SHIFTC = null,
			SHIFTD = null,
			SHIFTE = null,
			SHIFTF = null,
			SHIFTG = null,
			SHIFTH = null,
			SHIFTI = null,
			SHIFTJ = null,
			SHIFTK= null,
			SHIFTL= null,
			SHIFTM= null,
			SHIFTN= null,
			SHIFTO= null,
			SHIFTP= null,
			SHIFTQ= null,
			SHIFTR= null,
			SHIFTS= null,
			SHIFTT= null,
			TIPPOINT= null,
			CLTIPOINT= null,
			TIPRATE= null,
			MFUND= null,
			DFUND= null,
			ZAKAT_BF= null,
			ZAKAT_BFN= null,
			PIECEPAY= null,
			BASICPAY= null,
			FULLPAY= null,
			NPLPAY= null,
			OT1= null,
			OT2= null,
			OT3= null,
			OT4= null,
			OT5= null,
			OT6= null,
			OTPAY= null,
			EPFWW= null,
			EPFCC= null,
			EPFWWEXT= null,
			EPFCCEXT= null,
			EPGWW= null,
			EPGCC= null,
			SOASOWW= null,
			SOASOCC= null,
			SOBSOWW= null,
			SOBSOCC= null,
			SOCSOWW= null,
			SOCSOCC= null,
			SODSOWW= null,
			SODSOCC= null,
			SOESOWW= null,
			SOESOCC= null,
			UNIONWW= null,
			UNIONCC= null,
			ADVANCE= null,
			ADVPAY= null,
			TIPAMT= null,
			ITAXPCB= null,
			ITAXPCBADJ= null,
			TAW= null,
			TXOTPAY= null,
			TXAW= null,
			TXDED= null,
			TDED= null,
			TDEDU= null,
			GROSSPAY= null,
			NETPAY= null,
			EPF_PAY= null,
			EPF_PAY_A= null,
			CCSTAT1= null,
			CCSTAT2= null,
			CCSTAT3= null,
			PENCEN= null,
			PROJECT= null,
			CHEQUE_NO= null,
			BANKCHARGE= null,
			ADVDAY= null,
			PM_CODE= null,
			TMONTH= null,
			UDRATE1= null,
			UDRATE2= null,
			UDRATE3= null,
			UDRATE4= null,
			UDRATE5= null,
			UDRATE6= null,
			UDRATE7= null,
			UDRATE8= null,
			UDRATE9= null,
			UDRATE10= null,
			UDRATE11= null,
			UDRATE12= null,
			UDRATE13= null,
			UDRATE14= null,
			UDRATE15= null,
			UDRATE16= null,
			UDRATE17= null,
			UDRATE18= null,
			UDRATE19= null,
			UDRATE20= null,
			UDRATE21= null,
			UDRATE22= null,
			UDRATE23= null,
			UDRATE24= null,
			UDRATE25= null,
			UDRATE26= null,
			UDRATE27= null,
			UDRATE28= null,
			UDRATE29= null,
			UDRATE30= null,
            PAYYES = "N",
            cpf_amt=null,
            hourrate=null,
            total_late_h=null,
            total_earlyD_h=null,
            total_noP_h=null,
            total_work_h=null,
            YEAR=null,
            additionalwages=null,
            cheqno_updated_on = null,
            cheqno_updated_by = null
</cfquery>


<cfquery name="BPO_qry1" datasource="#dts#">
	update paytra1 
			set 
			BRATE = null,
			BRATE2 = null, 
			BACKPAY = null,
			OOB = null,
			WDAY = null,
			WDAY2 = null,
			DW = null,
			DW2 = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			MR = null,
			PT = null,
            OIL = null,
            ECL = null,
            RS = null,
            toff = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null,
			LS = null,
			OPLD = null,
			OPL = null,
			NPL = null,
			NPL2 = null,
			AB = null,
			ONPLD = null,
			ONPL = null,
			NS = null,
			ALTAWDAY = null,
			ALTAWRATE = null,
			ALTAWAMT = null,
			DWAWADJ = null,
			ALBFTMP = null,
			MCBFTMP = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			RATE1 = null,
			RATE2 = null,
			RATE3 = null,
			RATE4 = null,
			RATE5 = null,
			RATE6 = null,
			HR1 = null,
			HR2 = null,
			HR3 = null, 
			HR4 = null,
			HR5 = null,
			HR6 = null,
			DIRFEE = null,
			AW101= null,
			AW102 = null,
			AW103 = null,
			AW104= null,
			AW105 = null,
			AW106 = null,
			AW107 = null, 
			AW108= null,
			AW109= null,
			AW110 = null,
			AW111= null,
			AW112 = null,
			AW113 = null,
			AW114 = null,
			AW115 = null,
			AW116 = null,
			AW117 = null,
			DED101 = null,
			DED102 = null,
			DED103 = null,
			DED104 = null,
			DED105 = null,
			DED106 = null,
			DED107 = null,
			DED108 = null,
			DED109 = null,
			DED110 = null,
			DED111= null,
			DED112= null,
			DED113 = null,
			DED114 = null,
			DED115 = null,
			MESS = null,
			MESS1 = null,
			FIXOESP = null,
			SHIFTA = null,
			SHIFTB = null,
			SHIFTC = null,
			SHIFTD = null,
			SHIFTE = null,
			SHIFTF = null,
			SHIFTG = null,
			SHIFTH = null,
			SHIFTI = null,
			SHIFTJ = null,
			SHIFTK= null,
			SHIFTL= null,
			SHIFTM= null,
			SHIFTN= null,
			SHIFTO= null,
			SHIFTP= null,
			SHIFTQ= null,
			SHIFTR= null,
			SHIFTS= null,
			SHIFTT= null,
			TIPPOINT= null,
			CLTIPOINT= null,
			TIPRATE= null,
			MFUND= null,
			DFUND= null,
			ZAKAT_BF= null,
			ZAKAT_BFN= null,
			PIECEPAY= null,
			BASICPAY= null,
			FULLPAY= null,
			NPLPAY= null,
			OT1= null,
			OT2= null,
			OT3= null,
			OT4= null,
			OT5= null,
			OT6= null,
			OTPAY= null,
			EPFWW= null,
			EPFCC= null,
			EPFWWEXT= null,
			EPFCCEXT= null,
			EPGWW= null,
			EPGCC= null,
			SOASOWW= null,
			SOASOCC= null,
			SOBSOWW= null,
			SOBSOCC= null,
			SOCSOWW= null,
			SOCSOCC= null,
			SODSOWW= null,
			SODSOCC= null,
			SOESOWW= null,
			SOESOCC= null,
			UNIONWW= null,
			UNIONCC= null,
			ADVANCE= null,
			ADVPAY= null,
			TIPAMT= null,
			ITAXPCB= null,
			ITAXPCBADJ= null,
			TAW= null,
			TXOTPAY= null,
			TXAW= null,
			TXDED= null,
			TDED= null,
			TDEDU= null,
			GROSSPAY= null,
			NETPAY= null,
			EPF_PAY= null,
			EPF_PAY_A= null,
			CCSTAT1= null,
			CCSTAT2= null,
			CCSTAT3= null,
			PENCEN= null,
			PROJECT= null,
			CHEQUE_NO= null,
			BANKCHARGE= null,
			ADVDAY= null,
			PM_CODE= null,
			TMONTH= null,
			UDRATE1= null,
			UDRATE2= null,
			UDRATE3= null,
			UDRATE4= null,
			UDRATE5= null,
			UDRATE6= null,
			UDRATE7= null,
			UDRATE8= null,
			UDRATE9= null,
			UDRATE10= null,
			UDRATE11= null,
			UDRATE12= null,
			UDRATE13= null,
			UDRATE14= null,
			UDRATE15= null,
			UDRATE16= null,
			UDRATE17= null,
			UDRATE18= null,
			UDRATE19= null,
			UDRATE20= null,
			UDRATE21= null,
			UDRATE22= null,
			UDRATE23= null,
			UDRATE24= null,
			UDRATE25= null,
			UDRATE26= null,
			UDRATE27= null,
			UDRATE28= null,
			UDRATE29= null,
			UDRATE30= null,
			PAYYES= 'N',
            cpf_amt=null,
            hourrate=null,
            total_late_h=null,
            total_earlyD_h=null,
            total_noP_h=null,
            total_work_h=null,
            additionalwages=null,
            PAYIN=null,
            cheqno_updated_on = null,
            cheqno_updated_by = null
</cfquery>
<cfif isdefined('form.remainweekpay') eq false>
<cfloop from="1" to="6" index="i">
	<cfset table_var = "payweek"&#i# > 
	<cfinvoke component="cfc.monthEnd" method="monthEnd" db="#dts#" db1="#dts_main#" tablename="#table_var#" returnvariable="name" />
</cfloop>
</cfif>

</cfif>

	<cfquery name="bonus_empty" datasource="#dts#">
		UPDATE bonus SET
		BONUSP= null,
		SALESAMT= null,
		SALESAMT2= null,
		BASICPAY= null,
		EPFWW= null,
		EPFCC= null,
		EPFWWEXT= null,
		EPFCCEXT= null,
		EPGWW= null,
		EPGCC= null,
		SOASOWW= null,
		SOASOCC= null,
		SOBSOWW= null,
		SOBSOCC= null,
		SOCSOWW= null,
		SOCSOCC= null,
		SODSOWW= null,
		SODSOCC= null,
		SOESOWW= null,
		SOESOCC= null,
		UNIONWW= null,
		UNIONCC= null,
		CCSTAT1= null,
		ITAXPCB= null,
		ITAXPCBADJ= null,
		GROSSPAY= null,
		NETPAY= null,
		EPF_PAY= null,
		CHEQUE_NO= null,
		BANKCHARGE= null,
		PM_CODE= null,
		TMONTH= null,
		COMM1= null,
		COMM2= null,
		EXTRA1= null,
		EXTRA2= null,
		EXTRA3= null,
		LEVY_FW_W= null,
		LEVY_FW_C= null,
		LEVY_SD= null,
		NUMOFMTH= null,
		ESTBRATE= null,
		PAYYES= null, 
		FIXOESP = null
	</cfquery>

	<cfquery name="comm_empty" datasource="#dts#">
	UPDATE comm SET
	BONUSP= null,
	SALESAMT= null,
	SALESAMT2= null,
	BASICPAY= null,
	EPFWW= null,
	EPFCC= null,
	EPFWWEXT= null,
	EPFCCEXT= null,
	EPGWW= null,
	EPGCC= null,
	SOASOWW= null,
	SOASOCC= null,
	SOBSOWW= null,
	SOBSOCC= null,
	SOCSOWW= null,
	SOCSOCC= null,
	SODSOWW= null,
	SODSOCC= null,
	SOESOWW= null,
	SOESOCC= null,
	UNIONWW= null,
	UNIONCC= null,
	CCSTAT1= null,
	ITAXPCB= null,
	ITAXPCBADJ= null,
	GROSSPAY= null,
	NETPAY= null,
	EPF_PAY= null,
	CHEQUE_NO= null,
	BANKCHARGE= null,
	PM_CODE= null,
	TMONTH= null,
	COMM1= null,
	COMM2= null,
	EXTRA1= null,
	EXTRA2= null,
	EXTRA3= null,
	LEVY_FW_W= null,
	LEVY_FW_C= null,
	LEVY_SD= null,
	NUMOFMTH= null,
	ESTBRATE= null,
	PAYYES= null, 
	FIXOESP = null
	</cfquery>
	
	<cfquery name="extra_empty" datasource="#dts#">
	UPDATE extra SET
	BONUSP= null,
	SALESAMT= null,
	SALESAMT2= null,
	BASICPAY= null,
	EPFWW= null,
	EPFCC= null,
	EPFWWEXT= null,
	EPFCCEXT= null,
	EPGWW= null,
	EPGCC= null,
	SOASOWW= null,
	SOASOCC= null,
	SOBSOWW= null,
	SOBSOCC= null,
	SOCSOWW= null,
	SOCSOCC= null,
	SODSOWW= null,
	SODSOCC= null,
	SOESOWW= null,
	SOESOCC= null,
	UNIONWW= null,
	UNIONCC= null,
	CCSTAT1= null,
	ITAXPCB= null,
	ITAXPCBADJ= null,
	GROSSPAY= null,
	NETPAY= null,
	EPF_PAY= null,
	CHEQUE_NO= null,
	BANKCHARGE= null,
	PM_CODE= null,
	TMONTH= null,
	COMM1= null,
	COMM2= null,
	EXTRA1= null,
	EXTRA2= null,
	EXTRA3= null,
	LEVY_FW_W= null,
	LEVY_FW_C= null,
	LEVY_SD= null,
	NUMOFMTH= null,
	ESTBRATE= null,
	PAYYES= null, 
	FIXOESP = null
	</cfquery>
	
	<cfquery name="HBCE_empty" datasource="#dts#">
		UPDATE hbce SET
		cheque_no = null
	</cfquery>
	<cfif trans_type eq "RT">
	<cfquery name="pay_tm_empty" datasource="#dts#">
		UPDATE pay_tm SET
		 	BRATE = null,
            OOB= null,
            WDAY = null,
            DW= null,
            PH= null,
            AL= null,
            ALHR= null,
            MC= null,
            MT= null,
            CC= null,
            PT= null,
            MR= null,
            OIL = null,
            ECL = null,
            RS = null,
            toff = null,
            CL= null,
            HL= null,
            AD= null,
            EX= null,
            LS= null,
            OPL= null,
            NPL= null,
            AB= null,
            ONPL= null,
            NS= null,
            WORKHR= null,
            LATEHR= null,
            EARLYHR= null,
            NOPAYHR= null,
            HR1= null,
            HR2= null,
            HR3= null,
            HR4= null,
            HR5= null,
            HR6= null,
            BASICPAY= null,
            OTPAY= null,
            DIRFEE= null,
            TAW= null,
            GROSSPAY= null,
            TDEDU= null,
            TDED = null,
            NETPAY = null,
            NETPAYADJ = null,
            NPLPAY = null,
            BONUS = null,
            COMM = null,
            EXTRA= null,
            TXOT = null,
            TXAW = null,
            TXDED = null,
            OT1 = null,
            OT2 = null,
            OT3 = null,
            OT4 = null,
            OT5 =  null,
            OT6 = null,
            AW101 = null,
            AW102 = null,
            AW103 = null,
            AW104 = null,
            AW105 = null,
            AW106 = null,
            AW107 = null,
            AW108 = null,
            AW109 = null,
            AW110 = null,
            AW111 = null,
            AW112 = null,
            AW113 = null,
            AW114 =  null,
            AW115 = null,
            AW116 = null,
            AW117 = null,
            DED101 = null,
            DED102 = null,
            DED103 = null,
            DED104 = null,
            DED105 = null,
            DED106 =  null,
            DED107 = null,
            DED108 = null,
            DED109 = null,
            DED110 = null,
            DED111 = null,
            DED112 = null,
            DED113 = null,
            DED114 = null,
            DED115 = null,
            ADVANCE = null,
            ITAXPCB = null,
            ITAXPCBADJ = null,
            EPFWW = null,
            EPFCC = null,
            EPFWWEXT = null,
            EPFCCEXT = null,
            EPGWW = null,
            EPGCC = null,
            SOASOWW = null,
            SOASOCC = null,
            SOBSOWW = null,
            SOBSOCC = null,
            SOCSOWW = null,
            SOCSOCC = null,
            SODSOWW = null,
            SODSOCC = null,
            SOESOWW = null,
            SOESOCC = null,
            UNIONWW = null,
            UNIONCC = null,
            CCSTAT1 = null,
            PENCEN = null,
            BINK = null,
            MFUND = null,
            DFUND = null,
            EPF_PAY = null,
            EPF_PAY_A = null,
            EPF_PAY_B = null,
            EPF_PAY_C = null,
            TAWCPF = null,
            TAWCPFWW = null,
            TAWCPFCC = null, 
            HRD_PAY = null,
            ACTIV_MTH = null,
            AR_ACC1 = null,
            AR_ACC2 = null,
            AR_ACC3 = null,
            AR_ACC4 = null,
            AR_ACC5 = null,
            PAYYES = null,
            B_EPFWW = null,
            B_EPFCC = null,
            CPF_AMT = null,
            c_epfww = null,
            c_epfcc = null,
            p_epfww = null,
            p_epfcc = null,
		re_cpf_all = null,
        additionalwages=null,
		payyes = "N"
	</cfquery>
	</cfif>
	
	<!--- <cfquery name="more_qry" datasource="#dts#">
	UPDATE moretra
	SET PAYYES = "Y"
	WHERE empno = "#form.empno#"
	</cfquery> --->
    
    <cfif form.uwd eq "figures">
		<cfset fwd = val(form.fwd) >
		<cfset swd = val(form.swd) >
        <cfset new2wd = val(form.new2wd)>
        
        <cfquery name="update_WD1" datasource="#dts#">
            UPDATE paytra1 as a,pmast as b ,payroll_main.gsetup as c SET a.WDAY = 
                if(b.nppm != 0, 
                if(b.nppm = 2,"#fwd#","0"), 
                if(c.bp_payment = 2,"#fwd#","0"))
            WHERE a.empno = b.empno
            and c.comp_id = "#HcomID#"
            and b.payrtype <> "H"
        </cfquery>

        <cfquery name="update_WD2" datasource="#dts#">
            UPDATE paytran as a,pmast as b ,payroll_main.gsetup as c SET a.WDAY = 
                if(b.nppm != 0, 
                if(b.nppm = 2,"#swd#","#new2wd#"), 
                if(c.bp_payment = 2,"#swd#","#new2wd#")),
                a.dw = a.wday-a.al-a.mc-a.cc-a.mt-a.mr-a.cl-a.hl-a.ex-a.pt-a.ad-a.ecl-a.oil-a.opl-a.ls-a.npl-a.ab-a.onpl-a.ns-a.rs
            WHERE a.empno = b.empno
            and c.comp_id = "#HcomID#"
            and b.payrtype <> "H"
        </cfquery>
	</cfif>
	
	<cfquery name="monthEndUpdate" datasource="#dts#">
		SELECT * from awtable where aw_cou = 1
	</cfquery>
	
	<cfif #monthEndUpdate.MEUD_BRATE# eq "Y">
		<cfquery name="get_masterBR_qry" datasource="#dts#">
		UPDATE paytra1 , pmast SET paytra1.brate = pmast.brate WHERE paytra1.empno = pmast.empno
		</cfquery>
		<cfquery name="get_masterBR_qry" datasource="#dts#">
		UPDATE paytran , pmast SET paytran.brate = pmast.brate WHERE paytran.empno = pmast.empno
		</cfquery>
	</cfif>
    
    <cfif monthEndUpdate.MEUD_BRATEFLEX neq "N">
    <cfquery name="upatebrateflex" datasource="#dts#">
        UPDATE paytra1 as a,pmast as b ,payroll_main.gsetup as c SET a.brate = if(b.nppm != 0, coalesce(b.brate,0)/coalesce(b.nppm,1), coalesce(b.brate,0)/coalesce(c.bp_payment,1))
    WHERE a.empno = b.empno
    and c.comp_id = "#HcomID#"
     and b.payrtype = "M"
    </cfquery>
    
    <cfquery name="upatebrateflex" datasource="#dts#">
        UPDATE paytran as a,pmast as b ,payroll_main.gsetup as c SET a.brate = if(b.nppm != 0, coalesce(b.brate,0)/coalesce(b.nppm,1), coalesce(b.brate,0)/coalesce(c.bp_payment,1))
    WHERE a.empno = b.empno
    and c.comp_id = "#HcomID#"
     and b.payrtype = "M"
    </cfquery>
    
	</cfif>
    
	<!--- update leave into payroll --->
	<cfif #monthEndUpdate.MEUD_LEAVE# eq "Y">
		<cfquery name="getdate" datasource="#dts_main#">
		SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
		</cfquery>
		
		<cfset mon = #numberformat(getdate.mmonth,'00')#>
		<cfset yrs = getdate.myear>
        
        <!---update paytran leave to 0, [2016-01-06 by Max Tan]--->
        <cfquery name="emp_pay_a" datasource="#dts#">
            SELECT empno FROM pmast WHERE paystatus = "A"
        </cfquery>
        
        <cfset leavelist = "AL,MC,CC,MT,MR,CL,HL,EX,PT,AD,ECL,OIL,OPL,LS,NPL,AB,ONPL,NS,RS">
        <cfif emp_pay_a.recordcount neq 0>
            <cfquery name="emptyleave" datasource="#dts#">
                UPDATE paytran SET 
                <cfloop list="#leavelist#" index="i">#i# = 0<cfif i neq "RS">,</cfif></cfloop>
                WHERE empno in (
                <cfloop query="emp_pay_a">
                '#emp_pay_a.empno#' <cfif emp_pay_a.recordcount neq emp_pay_a.currentrow>,</cfif>
                </cfloop>
                )
            </cfquery>
        </cfif>
        <!---end--->		
        
		<cfquery name="num_leave" datasource="#dts#">
			SELECT * FROM pleave WHERE substr(lve_date,1,4)='#yrs#' and substr(lve_date,6,2)='#mon#'
            AND LVE_TYPE NOT IN("ALADJ")
            <cfif hcomid eq "acpte" or hcomid eq "cecpl" or hcomid eq "iptazpl" or hcomid eq "dapte" or hcomid eq "alpte">
            AND LVE_TYPE NOT IN ("NPL","NS","NPL2","AB","ONPL")
            </cfif>
		</cfquery>
		
		
		<cfloop query="num_leave">
		
			<cfquery name="sum_leave" datasource="#dts#">
				SELECT sum(lve_day) as sumlve FROM pleave WHERE LVE_TYPE = "#num_leave.LVE_TYPE#" and empno = "#num_leave.empno#" and substr(lve_date,1,4)='#yrs#' and substr(lve_date,6,2)='#mon#'
			</cfquery>
			
            <cfif num_leave.LVE_TYPE eq "TO">
				<cfset num_leave.LVE_TYPE = "toff">
            </cfif>

			<cfquery name="Update_l" datasource="#dts#">
				UPDATE paytran SET #num_leave.LVE_TYPE# = #sum_leave.sumlve# WHERE empno = "#num_leave.empno#"
			</cfquery>
           
		</cfloop>
        
        <cfif mon neq 13>
            <cfif hcomid eq "acpte" or hcomid eq "cecpl" or hcomid eq "iptazpl" or hcomid eq "dapte" or hcomid eq "alpte">
            <cfset enddate = createdate('#yrs#','#mon#','16')>
            <cfset lastmonth = dateadd('m',-1,enddate)>
            <cfset startdate = createdate(year(lastmonth),month(lastmonth),'17')>

            <cfquery name="num_leave" datasource="#dts#">
            SELECT * FROM pleave WHERE lve_date >= "#dateformat(startdate,'yyyy-mm-dd')#" AND lve_date <= "#dateformat(enddate,'yyyy-mm-dd')#"
            AND LVE_TYPE IN ("NPL","NS","NPL2","AB","ONPL")
            </cfquery>

            <cfloop query="num_leave">
            
            <cfquery name="sum_leave" datasource="#dts#">
            SELECT sum(lve_day) as sumlve FROM pleave WHERE 
            LVE_TYPE = "#num_leave.LVE_TYPE#" 
            and empno = "#num_leave.empno#" 
            and lve_date >= "#dateformat(startdate,'yyyy-mm-dd')#" 
            AND lve_date <= "#dateformat(enddate,'yyyy-mm-dd')#"
            </cfquery>
            
            <cfif num_leave.LVE_TYPE eq "TO">
                <cfset num_leave.LVE_TYPE = "toff">
            </cfif>
            
            <cfquery name="Update_l" datasource="#dts#">
            UPDATE paytran SET #num_leave.LVE_TYPE# = #sum_leave.sumlve# WHERE empno = "#num_leave.empno#"
            </cfquery>
            
            </cfloop>
            </cfif>
        </cfif>
	</cfif>
	<!--- Update RD/PH Work Into Payroll --->
	<cfif #monthEndUpdate.MEUD_RDPH# eq "Y">
		<cfquery name="getdate" datasource="#dts_main#">
		SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
		</cfquery>
		
		<cfset mon = #numberformat(getdate.mmonth,'00')# >
		<cfset yrs = getdate.myear>
		
		<cfquery name="num_rdhlworked" datasource="#dts#">
			SELECT * FROM pwork WHERE substr(work_date,1,4)='#yrs#' and substr(work_date,6,2)='#mon#'
		</cfquery>
		
		<cfloop query="num_rdhlworked">
			<cfquery name="Update_l" datasource="#dts#">
				UPDATE paytran, pwork SET paytran.#num_rdhlworked.WORK_TYPE# = #num_rdhlworked.WORK_DAY# WHERE paytran.empno = pwork.empno
			</cfquery>
		</cfloop>
	</cfif>
	<!-- Update Loan Deduction Into Payroll -->
    
	<cfif #monthEndUpdate.MEUD_LOAN# eq "Y">
		<cfquery name="getdate" datasource="#dts_main#">
			SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
		</cfquery>
		
		<cfset mon = #numberformat(getdate.mmonth,'00')# >
		<cfset yrs = getdate.myear>
        <cfif mon eq 13>
        <cfset mon = 1>
        <cfset yrs = yrs + 1>
		</cfif>
		<cfset datestart = CreateDate(#yrs#, #mon#, 1) >
		<cfset dateend = CreateDate(#yrs#, #mon#, #DaysInMonth(datestart)#)>
		
		
		<cfquery name="num_loan" datasource="#dts#">
			SELECT * FROM loanmst WHERE DATES1 < #datestart# and DATEE1 > #dateend#
		</cfquery>
	
		<cfloop query="num_loan">
			<cfset ded_basic = 0>
			<cfquery name="select_basic_deduction" datasource="#dts#">
				SELECT SUM(loanret1) as totalLoan FROM loanmst WHERE empno = "#num_loan.empno#" and DEDNUM = #num_loan.DEDNUM#
			</cfquery>
			
			<cfoutput>
			<cfif num_loan.dednum lt 10>
				<cfset dednum1 = "ded10"&#num_loan.DEDNUM#>
			<cfelse>
				<cfset dednum1 = "ded1"&#num_loan.DEDNUM#>
			</cfif>
			</cfoutput>
			<cfset new_ded = select_basic_deduction.totalLoan >
			<cfquery name="update_ded" datasource="#dts#">
			UPDATE paytran SET #dednum1# = #new_ded# WHERE empno = "#num_loan.empno#"
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfif #monthEndUpdate.MEUD_HOL# eq "Y">
		<cfquery name="getdate" datasource="#dts_main#">
			SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
		</cfquery>
		<cfif getdate.mmonth eq 13>
		<cfset mon = 1>
        <cfset yrs = getdate.myear + 1>
		<cfelse>
		<cfset mon = #numberformat(getdate.mmonth,'00')# >
		<cfset yrs = getdate.myear>
        </cfif>
		
		
		<cfquery name="getHol" datasource="#dts#">
			SELECT * FROM holtable WHERE substr(hol_date,1,4)='#yrs#' and substr(hol_date,6,2)='#mon#'
		</cfquery>
		
		<cfquery name="update" datasource="#dts#">
			UPDATE paytran 
			SET	PH = "#gethol.recordcount#"
		</cfquery>
	</cfif>
	
	<cfif <!---trans_type eq "RT" and---> form.uwd eq "table">
    <cfset nowmonth = dateformat(new_date,'mmm')>
    <cfif UCASE(nowmonth) eq "APR">
    <cfset nowmonth = "APRIL">
    <cfelseif UCASE(nowmonth) eq "JUL">
    <cfset nowmonth = "JULY">
    <cfelseif UCASE(nowmonth) eq "SEP">
    <cfset nowmonth = "SEPT">
    <cfelseif UCASE(nowmonth) eq "DEC">
    <cfset nowmonth = "DECB">
	</cfif>
    <cfquery name="update_WD1" datasource="#dts#">
            UPDATE paytra1 as a,pmast as b ,wdgroup as c,payroll_main.gsetup as d SET a.WDAY = 
                if(b.wrking_grp != "", 
                    if(b.nppm != 0, 
                        if(b.nppm = 2,coalesce(c.#nowmonth#,0)/coalesce(b.nppm,1), '0'),
                        if(b.nppm = 2,coalesce(c.#nowmonth#,0)/coalesce(d.bp_payment,1), '0')
                       ), 
                "0"),
                a.dw = a.wday-a.al-a.mc-a.cc-a.mt-a.mr-a.cl-a.hl-a.ex-a.pt-a.ad-a.ecl-a.oil-a.opl-a.ls-a.npl-a.ab-a.onpl-a.ns-a.rs
            WHERE a.empno = b.empno
            and c.groupwp = b.wrking_grp
            and b.payrtype <> "H"
        </cfquery>

        
        <cfquery name="update_WD2" datasource="#dts#">
            UPDATE paytran as a,pmast as b ,wdgroup as c,payroll_main.gsetup as d SET a.WDAY = 
                if(b.wrking_grp != "", 
                    if(b.nppm != 0, 
                        if(b.nppm = 2,coalesce(c.#nowmonth#,0)/coalesce(b.nppm,1), coalesce(c.#nowmonth#,0)),
                        if(b.nppm = 2,coalesce(c.#nowmonth#,0)/coalesce(d.bp_payment,1), coalesce(c.#nowmonth#,0))
                       ), 
                "0")
            WHERE a.empno = b.empno
            and c.groupwp = b.wrking_grp
            and b.payrtype <> "H"
        </cfquery>
	</cfif>
    
    <!---enhance assign working days, [2016-01-15, by Max Tan] --->
    <cfquery name="uptdw1" datasource="#dts#">
        UPDATE paytra1 SET 
        dw = coalesce(wday,0)-coalesce(al,0)-coalesce(ph,0)-coalesce(mc,0)-coalesce(cc,0)-coalesce(mt,0)-coalesce(mr,0)-
            coalesce(cl,0)-coalesce(hl,0)-coalesce(ex,0)-coalesce(pt,0)-coalesce(ad,0)-coalesce(ecl,0)-coalesce(oil,0)-coalesce(opl,0)-
            coalesce(ls,0)-coalesce(npl,0)-coalesce(ab,0)-coalesce(onpl,0)-coalesce(ns,0)-coalesce(rs,0)
    </cfquery>
    <cfquery name="uptdw2" datasource="#dts#">
        UPDATE paytran SET 
        dw = coalesce(wday,0)-coalesce(al,0)-coalesce(ph,0)-coalesce(mc,0)-coalesce(cc,0)-coalesce(mt,0)-coalesce(mr,0)-
            coalesce(cl,0)-coalesce(hl,0)-coalesce(ex,0)-coalesce(pt,0)-coalesce(ad,0)-coalesce(ecl,0)-coalesce(oil,0)-coalesce(opl,0)-
            coalesce(ls,0)-coalesce(npl,0)-coalesce(ab,0)-coalesce(onpl,0)-coalesce(ns,0)-coalesce(rs,0)
    </cfquery>
    <!---end--->
    
    
<!---     <!---ot1&ot2--->
    <cfif left(dts,10) eq "imiqgroup">
    <cfquery name="gettotalot" datasource="#dts#">
    SELECT sum(ot1)as totalot1,sum(ot2)as totalot2,empno FROM emptimesheet where month='#mon#' and year='#yrs#' GROUP BY empno
    </cfquery>
    
    <cfloop query="gettotalot">
    <cfquery name="updatetotalot" datasource="#dts#">
    UPDATE paytra1 SET hr2='#gettotalot.totalot1#',hr3='#gettotalot.totalot2#' 
    WHERE empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#gettotalot.empno#">
    </cfquery>
    </cfloop>
    </cfif>
    <!---ot1&ot2---> --->  
<cfquery name="update_pay_tm_NONa" datasource="#dts#">
			update pay_tm 
			set BRATE = null,
				OOB= null,
				WDAY = null,
				DW= null,
				PH= null,
				AL= null,
				ALHR= null,
				MC= null,
				MT= null,
				CC= null,
				PT= null,
                OIL = null,
                ECL = null,
                RS = null,
                toff = null,
				MR= null,
				CL= null,
				HL= null,
				AD= null,
				EX= null,
				LS= null,
				OPL= null,
				NPL= null,
				AB= null,
				ONPL= null,
				NS = null,
				WORKHR= null,
				LATEHR= null,
				EARLYHR= null,
				NOPAYHR= null,
				HR1= null,
				HR2= null,
				HR3= null,
				HR4= null,
				HR5= null,
				HR6= null,
				BASICPAY= null,
				OTPAY= null,
				DIRFEE= null,
				TAW= null,
				GROSSPAY= null,
				TDEDU= null,
				TDED = null,
				NETPAY = null,
				NETPAYADJ = null,
				NPLPAY = null,
				BONUS = null,
				COMM = null,
				EXTRA= null,
				TXOT = null,
				TXAW = null,
				TXDED = null,
				OT1 = null,
				OT2 = null,
				OT3 = null,
				OT4 = null,
				OT5 =  null,
				OT6 = null,
				AW101 = null,
				AW102 = null,
				AW103 = null,
				AW104 = null,
				AW105 = null,
				AW106 = null,
				AW107 = null,
				AW108 = null,
				AW109 = null,
				AW110 = null,
				AW111 = null,
				AW112 = null,
				AW113 = null,
				AW114 =  null,
				AW115 = null,
				AW116 = null,
				AW117 = null,
				DED101 = null,
				DED102 = null,
				DED103 = null,
				DED104 = null,
				DED105 = null,
				DED106 =  null,
				DED107 = null,
				DED108 = null,
				DED109 = null,
				DED110 = null,
				DED111 = null,
				DED112 = null,
				DED113 = null,
				DED114 = null,
				DED115 = null,
				ADVANCE = null,
				ITAXPCB = null,
				ITAXPCBADJ = null,
				EPFWW = null,
				EPFCC = null,
				EPFWWEXT = null,
				EPFCCEXT = null,
				EPGWW = null,
				EPGCC = null,
				SOASOWW = null,
				SOASOCC = null,
				SOBSOWW = null,
				SOBSOCC = null,
				SOCSOWW = null,
				SOCSOCC = null,
				SODSOWW = null,
				SODSOCC = null,
				SOESOWW = null,
				SOESOCC = null,
				UNIONWW = null,
				UNIONCC = null,
				CCSTAT1 = null,
				PENCEN = null,
				BINK = null,
				MFUND = null,
				DFUND = null,
				EPF_PAY = null,
				EPF_PAY_A = null,
				EPF_PAY_B = null,
				EPF_PAY_C = null,
				TAWCPF = null,
				TAWCPFWW = null,
				TAWCPFCC = null, 
				HRD_PAY = null,
				ACTIV_MTH = null,
				AR_ACC1 = null,
				AR_ACC2 = null,
				AR_ACC3 = null,
				AR_ACC4 = null,
				AR_ACC5 = null,
				PAYYES = null,
				B_EPFWW = null,
				B_EPFCC = null,
				CPF_AMT = null,
				c_epfww = null,
				c_epfcc = null,
				p_epfww = null,
				p_epfcc = null,
				re_cpf_all = null
			</cfquery>
            
	<cfinclude template="claimpayroll.cfm" />
    <cfif isdefined("form.updateepf")>
    	<cfinclude template="monthEndUpdateEPF.cfm" />
    </cfif>
    
	<cfquery name="assign_status2" datasource="#dts_main#">
		UPDATE gsetup2 SET mestatus = 'N', pilotstage = 0
        WHERE comp_id = "#HcomID#"
	</cfquery>
    
<!---    <cfif gs_qry2.emailpayslip eq "Y" and HComID eq '123123213gaf'>
    	<cfinclude template="monthEndEmailPayslip.cfm" />
    </cfif>--->
</cfoutput>

<cfset status_msg="Month End Success!"> 
<cfif isdefined("form.updateepf")>
    <cfset status_msg="Month End Success! Please change EPF settings in personnel for those who affected.">
</cfif>
<!---<cfcatch type="any">
	<cfset status_msg="Fail To Month End. Error Message for #dts# : #cfcatch.Detail#">
    <cfset page="#GetCurrentTemplatePath()#">
    <cfinclude template="/emailnetiquette.cfm" />
</cfcatch>
</cftry>---> 

<cfoutput><form name="pc"  action="/housekeeping/monthEndMain.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
<cfoutput></form></cfoutput>
 <script>
	 pc.submit();
</script>