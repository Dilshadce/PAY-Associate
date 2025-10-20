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
<cfset currentDirectory = "C:\NEWSYSTEM\PAY\DATABACKUP\"&dts>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset remark = "YEAREND">
<cfset filename=dts&"_"&dateformat(now(),'YYYYMMDD')&"_"&timeformat(now(),'HHMMSS')&"_"&GetAuthUser()&"_"&trim(#remark#)&".sql">
<cfset currentdirfile=currentDirectory&"\"&filename>

<cfexecute name = "C:\inetpub\wwwroot\payroll\mysqldump"
    arguments = "--host=#serverhost# --user=#servername# --password=#serverpass# #dts#" outputfile="#currentdirfile#" timeout="720">
</cfexecute>

<cfset filesize = GetFileInfo('#currentdirfile#').size >

<cfif filesize lt 200000>
<h1>Year End Failed! Please contact help desk at support@mynetiquette.com </h1>
<cfabort>
<cfelse>
</cfif>

<cfquery name="getyear" datasource="#dts_main#">
SELECT myear FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cftry>

<cfquery name="update_al_bf" datasource="#dts_main#">
	UPDATE gsetup
	set al_bf = <cfif isdefined("form.bfleave")>'1'<cfelse>'0'</cfif>
    WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="clearleave" datasource="#dts#">
	UPDATE pay_tm SET al = 0,mc=0
</cfquery>

	<cfquery name="pmast_qry" datasource="#dts#">
		SELECT * FROM pmast 
	</cfquery>	
	
	<!--- delete empno if pay status is "N" --->
    
	<cfquery name="pmastqry_qry_2" datasource="#dts#">
		SELECT empno FROM pmast where paystatus = "N"
	</cfquery>
	<cfif isdefined('form.SaveNoActive') eq false>
	<cfloop query="pmastqry_qry_2">
		<cfquery name="del_adv_h1" datasource="#dts#">
			delete from adv_h1 
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_adv_h1" datasource="#dts#">
			delete from adv_h2 
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_bonu_12m" datasource="#dts#">
			delete from bonu_12m 
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_bonus" datasource="#dts#">
			delete from bonus 
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_comm" datasource="#dts#">
			delete from comm 
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_comm_12m" datasource="#dts#">
			delete from comm_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_comm_12m" datasource="#dts#">
			delete from comm_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_emp_users" datasource="#dts#">
			delete from emp_users
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_emphist" datasource="#dts#">
			delete from emphist
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_extr_12m" datasource="#dts#">
			delete from extr_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_extra" datasource="#dts#">
			delete from extra
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_hbce" datasource="#dts#">
			delete from hbce
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_hbce_12m" datasource="#dts#">
			delete from hbce_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_hbce_12m" datasource="#dts#">
			delete from hbce_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_itaxea" datasource="#dts#">
			delete from itaxea
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_itaxea2" datasource="#dts#">
			delete from itaxea2
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_jobdone" datasource="#dts#">
			delete from jobdone
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_moretr1" datasource="#dts#">
			delete from moretr1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_moretra" datasource="#dts#">
			delete from moretra
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_moretra" datasource="#dts#">
			delete from moretra
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay_12m" datasource="#dts#">
			delete from pay_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay_tm" datasource="#dts#">
			delete from pay_tm
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay_ytd" datasource="#dts#">
			delete from pay_ytd
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay1_12m" datasource="#dts#">
			delete from pay1_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay1_12m_fig" datasource="#dts#">
			delete from pay1_12m_fig
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pay2_12m_fig" datasource="#dts#">
			delete from pay2_12m_fig
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_paynot1" datasource="#dts#">
			delete from paynot1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_paynote" datasource="#dts#">
			delete from paynote
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_paytra1" datasource="#dts#">
			delete from paytra1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_paytran" datasource="#dts#">
			delete from paytran
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek1" datasource="#dts#">
			delete from payweek1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek2" datasource="#dts#">
			delete from payweek2
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek3" datasource="#dts#">
			delete from payweek3
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek4" datasource="#dts#">
			delete from payweek4
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek5" datasource="#dts#">
			delete from payweek5
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_payweek6" datasource="#dts#">
			delete from payweek6
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pleave" datasource="#dts#">
			delete from pleave
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_pmast" datasource="#dts#">
			delete from pmast
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_pay" datasource="#dts#">
			delete from proj_pay
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_pay_12m" datasource="#dts#">
			delete from proj_pay_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_rcd" datasource="#dts#">
			delete from proj_rcd
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_rcd_1" datasource="#dts#">
			delete from proj_rcd_1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_rcd_12m" datasource="#dts#">
			delete from proj_rcd_12m
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_rcd_12m_1" datasource="#dts#">
			delete from proj_rcd_12m_1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		<cfquery name="del_proj_rcd_12m_1" datasource="#dts#">
			delete from proj_rcd_12m_1
			where empno= <cfqueryparam  cfsqltype="cf_sql_varchar" value="#pmastqry_qry_2.empno#">
		</cfquery>
		
		
	</cfloop>
	</cfif>
	
	<!-- update leave brought forward -->
	<cfquery name="determine_al_bf" datasource="#dts_main#">
		SELECT al_bf,leavebf from gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	
	<cfquery name="select_qry_ytd" datasource='#dts#'>
		SELECT empno,al FROM pay_ytd
	</cfquery>
	<cfquery name="gsteup_qry" datasource="#dts_main#">
		SELECT mmonth,myear FROM gsetup WHERE comp_id = "#HcomID#"
	</cfquery>
	<cfset yrs = gsteup_qry.myear + 1>
    <cfset datenew = createdate('#yrs#',1,1)>
	
    <cfloop query="select_qry_ytd">
		<cfif determine_al_bf.al_bf eq "1">
        <cfquery name="pmastqry_qry" datasource="#dts#">
				SELECT empno,albf,alall,aladj FROM pmast where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_qry_ytd.empno#">
		</cfquery>
		<cfset Tot_AL_given=val(pmastqry_qry.albf) + val(pmastqry_qry.alall) +val(pmastqry_qry.aladj)>
        
        <cfif isdefined('form.updateleave')>
        <cfquery name="getleavetaken" datasource="#dts#">
        SELECT empno,sum(lve_day) as sday 
        FROM pleave 
        where lve_type = "AL" 
        and lve_date < "#dateformat(datenew,'yyyy-mm-dd')#" 
        and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_qry_ytd.empno#">
        </cfquery>
        <cfif getleavetaken.recordcount neq 0>
        <cfset d_al_bf = val(getleavetaken.sday)>
        <cfelse>
        <cfset d_al_bf = 0>
		</cfif>
		<cfelse>	
		<cfset d_al_bf = val(select_qry_ytd.al)>
        </cfif>
        
		 <cfset al_leave_bal = val(Tot_AL_given) - d_al_bf>
		<cfelse>
			<cfset al_leave_bal = 0>
		</cfif>
        <cfif val(al_leave_bal) gt val(determine_al_bf.leavebf)>
        <cfset al_leave_bal = val(determine_al_bf.leavebf)>
        </cfif>
		<cfquery name="update_pmst_qry" datasource="#dts#">
			Update pmast 
			set albf = #val(al_leave_bal)#,
				aladj = 0 
			where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#select_qry_ytd.empno#">  
		</cfquery>
		
	</cfloop>
	
	<!-- Clear all data -->
	
	<cfquery name="year_end_adv_h1" datasource="#dts#">
		update adv_h1 
		set adv_date = null,
			advance = null
	</cfquery>
	
	<cfquery name="year_end_adv_h2" datasource="#dts#">
		update adv_h2 
		set adv_date = null,
			advance = null
	</cfquery>
	
	<cfquery name="year_end_bonu" datasource="#dts#">
		truncate bonu_12m
	</cfquery>
	
	<cfquery name="year_end_bonus" datasource="#dts#">
	update bonus 
	set	BONUSP = null,
		SALESAMT = null,
		SALESAMT2 = null,
		BASICPAY = null,
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
		ITAXPCB = null,
		ITAXPCBADJ = null,
		GROSSPAY = null,
		NETPAY = null,
		EPF_PAY = null,
		CHEQUE_NO = null,
		BANKCHARGE = null,
		PM_CODE = null,
		TMONTH = null,
		COMM1 = null,
		COMM2 = null,
		EXTRA1 = null,
		EXTRA2 = null,
		EXTRA3 = null,
		LEVY_FW_W = null,
		LEVY_FW_C = null,
		LEVY_SD = null,
		NUMOFMTH = null,
		ESTBRATE = null,
		PAYYES = null,
		FIXOESP = null
	</cfquery>
	
	<cfquery name="year_end_comm" datasource="#dts#">
		update comm
		set BONUSP = null,
			SALESAMT = null,
			SALESAMT2 = null,
			BASICPAY = null,
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
			ITAXPCB = null,
			ITAXPCBADJ = null,
			GROSSPAY = null,
			NETPAY = null,
			EPF_PAY = null,
			CHEQUE_NO = null,
			BANKCHARGE = null,
			PM_CODE = null,
			TMONTH = null,
			COMM1 = null,
			COMM2 = null,
			EXTRA1 = null,
			EXTRA2 = null, 
			EXTRA3 = null,
			LEVY_FW_W = null,
			LEVY_FW_C = null,
			LEVY_SD = null,
			NUMOFMTH = null,
			ESTBRATE = null,
			PAYYES = null,
			FIXOESP = null
	</cfquery> 
	
	<cfquery name="year_end_comm_12m" datasource="#dts#">
		truncate comm_12m
	</cfquery> 
	
	<cfquery name="year_end_extr_12m" datasource="#dts#">
		truncate extr_12m
	</cfquery> 
	
	<cfquery name="year_end_extra" datasource="#dts#">
		update extra
		set BONUSP = null,
			SALESAMT = null,
			SALESAMT2 = null,
			BASICPAY = null,
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
			ITAXPCB = null,
			ITAXPCBADJ = null,
			GROSSPAY = null,
			NETPAY = null,
			EPF_PAY = null,
			CHEQUE_NO = null,
			BANKCHARGE = null,
			PM_CODE = null,
			TMONTH = null,
			COMM1 = null,
			COMM2 = null, 
			EXTRA1 = null,
			EXTRA2 = null,
			EXTRA3 = null,
			LEVY_FW_W = null,
			LEVY_FW_C = null,
			LEVY_SD = null,
			NUMOFMTH = null,
			ESTBRATE = null,
			PAYYES = null,
			FIXOESP = null
	</cfquery> 
	
	<cfquery name="year_end_hbce" datasource="#dts#">
		update hbce
		set cheque_no = null
	</cfquery> 
	
	<cfquery name="year_end_hbce_12m" datasource="#dts#">
		truncate hbce_12m
	</cfquery> 
	
	<cfquery name="year_end_holtable" datasource="#dts#">
		truncate holtable
	</cfquery> 
	
	<cfquery name="year_end_itaxea" datasource="#dts#">
		update itaxea
	 	set EA_SN = null,
			EA_FILE_NO = null,
			EA_ADDR1 = null,
			EA_ADDR2 = null,
			EA_ADDR3 = null,
			EA_ADDR45 = null,
			PRN_ANYPAY = null,
			BONUSDATE1 = null,
			BONUSDATE2 = null, 
			EXTRADATE1 = null,
			EXTRADATE2 = null,
			PBAYARAN = null,
			TPERUNTUK = null,
			JENIS = null,
			TAHUN = null,
			MODEL = null,
			EA_BASIC = null,
			EA_OT = null,
			EA_DED = null,
			EA_ZAKAT = null,
			EA_AW = null,
			EA_AW_T = null,
			EA_AW_E = null,
			EA_AW_O = null,
			EA_PCB = null,
			EA_BONUS = null,
			EA_COMM = null,
			EA_DIRF = null,
			EA_EXTRA = null,
			BAS_OT_DED = null,
			BO_CO_E_DI = null,
			BA_OT_A_DD = null,
			EAFIG01 = null,
			EAFIG02 = null, 
			EAFIG03 = null,
			EAFIG04 = null,
			EAFIG05 = null,
			EAFIG06 = null,
			EAFIG07 = null,
			EAFIG08 = null,
			EAFIG09 = null,
			EAFIG10 = null,
			EAFIG11 = null,
			EAFIG12 = null,
			EAFIG13 = null,
			EAFIG14 = null,
			EAFIG15 = null,
			EAFIG16 = null,
			EAFIG17 = null,
			ECFIG01 = null,
			ECFIG02 = null,
			ECFIG03 = null,
			ECFIG04 = null,
			ECFIG05 = null,
			ECFIG06 = null,
			ECFIG07 = null,
			ECFIG08 = null,
			ECFIG09 = null,
			ECFIG10  = null,
			TAX_01 = null,
			TAX_02 = null,  
			TAX_03 = null,
			TAX_04 = null,
			TAX_05 = null,
			TAX_06 = null,
			TAX_07 = null,
			TAX_08 = null,
			TAX_09 = null,
			TAX_10 = null,
			TAX_11 = null,
			TAX_12 = null,
			TAX_13 = null,
			TAX_14 = null,
			TAX_15 = null,
			EA_TT_TAX = null,
			EA_NUM_MTH = null,
			EA_EPF = null,
			EA_EPFWEXT = null,
			EA_EPFCEXT = null,
			EATXT1 = null,
			EATXT2 = null,
			EATXT3 = null,
			EATXT4 = null,
			EATXT5 = null,
			EATXT6 = null,
			EATXT7 = null,
			EATXT8 = null, 
			EATXT9 = null,
			EATXT10 = null,
			COM_ADD = null,
			LYB_BONUS  = null,
			LYB_EPF = null,
			LYB_PCB = null
	</cfquery>
	
	<cfquery name="year_end_itaxea2" datasource="#dts#">
		update itaxea2
		set EA2TXT01 = null,
			EA2TXT02 = null,
			EA2TXT03 = null,
			EA2TXT04 = null,
			EA2TXT05 = null,
			EA2TXT06 = null,
			EA2TXT07 = null,
			EA2TXT08 = null,
			EA2TXT09 = null,
			EA2TXT10 = null,
			EA2TXT11 = null,
			EA2TXT12 = null,
			EA2TXT13 = null,
			EA2TXT14 = null,
			EA2TXT15 = null,
			EA2TXT16 = null,
			EA2TXT17 = null,
			EA2TXT18 = null,
			EA2TXT19 = null,
			EA2TXT20 = null,
			EA2TXT21 = null,
			EA2TXT22 = null,
			EA2TXT23 = null,
			EA2TXT24 = null,
			EA2TXT25 = null,
			EA2TXT26 = null,
			EA2TXT27 = null,
			EA2TXT28 = null,
			EA2TXT29 = null,
			EA2TXT30 = null,
			EA2FIG01 = null,
			EA2FIG02 = null,
			EA2FIG03 = null,
			EA2FIG04 = null,
			EA2FIG05 = null,
			EA2FIG06 = null,
			EA2FIG07 = null,
			EA2FIG08 = null,
			EA2FIG09 = null,
			EA2FIG10 = null,
			EA2FIG11 = null,
			EA2FIG12 = null,
			EA2FIG13 = null,
			EA2FIG14 = null,
			EA2FIG15 = null,
			EA2FIG16 = null,
			EA2FIG17 = null,
			EA2FIG18 = null,
			EA2FIG19 = null,
			EA2FIG20 = null,
			EA2FIG21 = null,
			EA2FIG22 = null,
			EA2FIG23 = null,
			EA2FIG24 = null,
			EA2FIG25 = null,
			EA2FIG26 = null,
			EA2FIG27 = null,
			EA2FIG28 = null,
			EA2FIG29 = null,
			EA2FIG30 = null,
			EA2DAT01 = null,
			EA2DAT02 = null,
			EA2DAT03 = null,
			EA2DAT04 = null,
			EA2DAT05 = null,
			EA2DAT06 = null,
			EA2DAT07 = null,
			EA2DAT08 = null,
			EA2DAT09 = null,
			EA2DAT10 = null,
			EA2DAT11 = null,
			EA2DAT12 = null,
			EA2DAT13 = null,
			EA2DAT14 = null,
			EA2DAT15 = null,
			EA2DAT16 = null,
			EA2DAT17 = null,
			EA2DAT18 = null,
			EA2DAT19 = null,
			EA2DAT20 = null,
			EA2DAT21 = null,
			EA2DAT22 = null,
			EA2DAT23 = null,
			EA2DAT24 = null,
			EA2DAT25 = null,
			EA2DAT26 = null,
			EA2DAT27 = null,
			EA2DAT28 = null,
			EA2DAT29 = null,
			EA2DAT30 = null
	</cfquery>	
	
	<cfquery name="year_end_jobdone" datasource="#dts#">
		truncate jobdone
	</cfquery>		
	
	<cfquery name="year_end_leave_apl" datasource="#dts#">
		DELETE FROM pleave WHERE lve_date < "#dateformat(datenew,'yyyy-mm-dd')#" 
	</cfquery>	
	
	<cfquery name="year_end_moretr1" datasource="#dts#">
		update moretr1
		set MAW101 = null,
			MAW102 = null,
			MAW103 = null,
			MAW104 = null,
			MAW105 = null,
			MAW106 = null,
			MAW107 = null,
			MAW108 = null,
			MAW109 = null,
			MAW110 = null,
			MAW111 = null,
			MAW112 = null,
			MAW113 = null,
			MAW114 = null,
			MAW115 = null,
			MAW116 = null,
			MAW117 = null,
			MDED101 = null,
			MDED102 = null,
			MDED103 = null,
			MDED104 = null,
			MDED105 = null,
			MDED106 = null,
			MDED107 = null,
			MDED108 = null,
			MDED109 = null,
			MDED110 = null,
			MDED111 = null,
			MDED112 = null,
			MDED113 = null,
			MDED114 = null,
			MDED115 = null,
			MDED116 = null,
			MDED117 = null,
			PROJECT = null,
			PAYYES = null
	</cfquery> 
	
	<cfquery name="year_end_moretra" datasource="#dts#">
		update moretra
		set MAW101 = null,
			MAW102 = null,
			MAW103 = null,
			MAW104 = null,
			MAW105 = null,
			MAW106 = null,
			MAW107 = null,
			MAW108 = null,
			MAW109 = null,
			MAW110 = null,
			MAW111 = null,
			MAW112 = null,
			MAW113 = null,
			MAW114 = null,
			MAW115 = null,
			MAW116 = null,
			MAW117 = null,
			MDED101 = null,
			MDED102 = null,
			MDED103 = null, 
			MDED104 = null,
			MDED105 = null,
			MDED106 = null,
			MDED107 = null,
			MDED108 = null,
			MDED109 = null,
			MDED110 = null,
			MDED111 = null,
			MDED112 = null, 
			MDED113 = null,
			MDED114 = null,
			MDED115 = null,
			MDED116 = null,
			MDED117 = null, 
			PROJECT = null,
			PAYYES = null
	</cfquery>
	
	<cfquery name="year_end_ot_record" datasource="#dts#">
		truncate ot_record 
	</cfquery>
	
	
	<cfquery name="year_end_pay_12m" datasource="#dts#">
		Update pay_12m 
		set BRATE = null,
			OOB = null,
			WDAY = null,
			DW = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			PT = null,
			MR = null,
            OIL = null,
            ECL = null,
            RS = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null,
			LS = null,
			OPL = null,
			NPL = null,
			AB = null,
			ONPL = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			HR1 = null,
			HR2 = null,
			HR3 = null,
			HR4 = null,
			HR5 = null,
			HR6 = null,
			BASICPAY = null,
			OTPAY = null,
			DIRFEE = null,
			TAW = null,
			GROSSPAY = null,
			TDEDU = null,
			TDED = null,
			NETPAY = null,
			NETPAYADJ = null,
			NPLPAY = null, 
			BONUS = null,
			COMM = null,
			EXTRA = null,
			TXOT = null,
			TXAW = null, 
			TXDED = null,
			OT1 = null,
			OT2 = null,
			OT3 = null,
			OT4 = null,
			OT5 = null,
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
			PAYYES = null,
			RATE1 = null,
			RATE2 = null, 
			RATE3 = null,
			RATE4 = null,
			RATE5 = null,
			RATE6 = null,
			update_by = null,
			update_on = null,
            ADDITIONALWAGES = null
	</cfquery>
	
	
	
	
	
	<cfquery name="year_end_pay_tm" datasource="#dts#">
		Update pay_tm 
		set BRATE = null,
			OOB = null,
			WDAY = null,
			DW = null,
			PH = null,
			AL = null,
			ALHR = null,
			MC = null,
			MT = null,
			CC = null,
			PT = null,
			MR = null,
            OIL = null,
            ECL = null,
            RS = null,
			CL = null,
			HL = null,
			AD = null,
			EX = null, 
			LS = null,
			OPL = null,
			NPL = null,
			AB = null,
			ONPL = null,
			WORKHR = null,
			LATEHR = null,
			EARLYHR = null,
			NOPAYHR = null,
			HR1 = null,
			HR2 = null,
			HR3 = null,
			HR4 = null,
			HR5 = null,
			HR6 = null,
			BASICPAY = null,
			OTPAY = null,
			DIRFEE = null, 
			TAW = null,
			GROSSPAY = null,
			TDEDU = null,
			TDED = null,
			NETPAY= null,
			NETPAYADJ = null,
			NPLPAY = null,
			BONUS = null,
			COMM = null,
			EXTRA = null,
			TXOT = null,
			TXAW = null,
			TXDED = null,
			OT1 = null,
			OT2 = null,
			OT3 = null,
			OT4 = null,
			OT5 = null,
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
			PAYYES = null,
			B_EPFWW = null,
			B_EPFCC = null,
			CPF_AMT = null,
			c_epfww = null,
			c_epfcc = null
	</cfquery> 
	
	<cfquery name="year_end_Pay_ytd" datasource="#dts#">
	update pay_ytd 
	set BRATE  = null,
		OOB = null,
		WDAY = null,
		DW = null,
		PH = null,
		AL = null,
		ALHR = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		AB = null,
		ONPL = null,
		WORKHR = null,
		LATEHR = null,
		EARLYHR = null,
		NOPAYHR = null,
		HR1 = null,
		HR2 = null,
		HR3 = null,
		HR4 = null,
		HR5 = null,
		HR6 = null,
		BASICPAY = null,
		OTPAY = null,
		DIRFEE = null,
		TAW = null,
		GROSSPAY = null,
		TDEDU = null,
		TDED = null,
		NETPAY = null,
		NETPAYADJ = null,
		NPLPAY = null,
		BONUS = null,
		COMM = null,
		EXTRA = null,
		TXOT = null,
		TXAW = null,
		TXDED = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
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
		PAYYES = null,
        ADDITIONALWAGES = null
	</cfquery>
	<cfquery name="year_end_pay1_12m" datasource="#dts#">
	update pay1_12m 
	set BRATE = null,
		OOB = null,
		WDAY = null,
		DW = null,
		PH = null,
		AL = null,
		ALHR = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		AB = null,
		ONPL = null,
		WORKHR = null,
		LATEHR = null,
		EARLYHR = null,
		NOPAYHR = null,
		HR1 = null,
		HR2 = null,
		HR3 = null,
		HR4 = null,
		HR5 = null,
		HR6 = null,
		BASICPAY = null,
		OTPAY = null,
		DIRFEE = null,
		TAW = null,
		GROSSPAY = null,
		TDEDU = null,
		TDED = null,
		NETPAY = null,
		NETPAYADJ = null,
		NPLPAY = null,
		BONUS = null,
		COMM = null,
		EXTRA = null,
		TXOT = null,
		TXAW = null,
		TXDED = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
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
		PAYYES = null,
		RATE1 = null,
		RATE2 = null,
		RATE3 = null,
		RATE4 = null,
		RATE5 = null,
		RATE6 = null
	</cfquery>
	
	<cfquery name="year_end_pay1_12m_fig" datasource="#dts#">
	update pay1_12m_fig 
	set BRATE = null,
		OOB = null,
		WDAY = null,
		DW = null,
		PH = null,
		AL = null,
		ALHR = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		AB = null,
		ONPL = null,
		WORKHR = null,
		LATEHR = null,
		EARLYHR = null,
		NOPAYHR = null,
		HR1 = null,
		HR2 = null,
		HR3 = null,
		HR4 = null,
		HR5 = null,
		HR6 = null,
		BASICPAY = null,
		OTPAY = null,
		DIRFEE = null,
		TAW = null,
		GROSSPAY = null,
		TDEDU = null,
		TDED = null,
		NETPAY = null,
		NETPAYADJ = null,
		NPLPAY = null,
		BONUS = null,
		COMM = null,
		EXTRA = null,
		TXOT = null,
		TXAW = null,
		TXDED = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
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
		PAYYES = null,
		RATE1 = null,
		RATE2 = null,
		RATE3 = null,
		RATE4 = null,
		RATE5 = null,
		RATE6 = null,
        ADDITIONALWAGES = null
	</cfquery>
	
	<cfquery name="year_end_pay2_12m_fig" datasource="#dts#">
	update pay2_12m_fig 
	set BRATE = null,
		OOB = null,
		WDAY = null,
		DW = null,
		PH = null,
		AL = null,
		ALHR = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		AB = null,
		ONPL = null,
		WORKHR = null,
		LATEHR = null,
		EARLYHR = null,
		NOPAYHR = null,
		HR1 = null,
		HR2 = null,
		HR3 = null,
		HR4 = null,
		HR5 = null,
		HR6 = null,
		BASICPAY = null,
		OTPAY = null,
		DIRFEE = null,
		TAW = null,
		GROSSPAY = null,
		TDEDU = null,
		TDED = null,
		NETPAY = null,
		NETPAYADJ = null,
		NPLPAY = null,
		BONUS = null,
		COMM = null,
		EXTRA = null,
		TXOT = null,
		TXAW = null,
		TXDED = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
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
		PAYYES = null,
		RATE1 = null,
		RATE2 = null,
		RATE3 = null,
		RATE4 = null,
		RATE5 = null,
		RATE6 = null,
		update_by = null,
		update_on = null,
        ADDITIONALWAGES = null
	</cfquery>
	
	<cfquery name="year_end_paynot1" datasource="#dts#">
	update paynot1
	set BACKPAY = null,
		OOB = null,
		WDAY = null,
		WDAY2 = null,
		DW = null,
		DW2 = null,
		PH = null,
		AL = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		NPL2 = null,
		AB = null,
		ONPL = null,
		DWAWADJ = null,
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
		DED111 = null,
		DED112 = null,
		DED113 = null,
		DED114 = null,
		DED115 = null,
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
		SHIFTK = null,
		SHIFTL = null,
		SHIFTM = null,
		SHIFTN = null,
		SHIFTO = null,
		SHIFTP = null,
		SHIFTQ = null,
		SHIFTR = null,
		SHIFTS = null,
		SHIFTT = null,
		TIPPOINT = null,
		TIPRATE = null,
		MFUND = null,
		DFUND = null,
		PIECEPAY = null,
		BASICPAY = null,
		FULLPAY = null,
		NPLPAY = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
		OT6 = null,
		OTPAY = null,
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
		ADVANCE = null,
		TIPAMT = null,
		ITAXPCB = null,
		TAW = null,
		TDED = null,
		TDEDU = null,
		GROSSPAY = null,
		NETPAY = null,
		CCSTAT1 = null,
		CCSTAT2 = null,
		CCSTAT3 = null,
		PENCEN = null,
		UDRATE1 = null,
		UDRATE2 = null,
		UDRATE3 = null,
		UDRATE4 = null,
		UDRATE5 = null,
		UDRATE6 = null,
		UDRATE7 = null,
		UDRATE8 = null,
		UDRATE9 = null,
		UDRATE10 = null,
		UDRATE11 = null,
		UDRATE12 = null,
		UDRATE13 = null,
		UDRATE14 = null,
		UDRATE15 = null,
		UDRATE16 = null,
		UDRATE17 = null,
		UDRATE18 = null,
		UDRATE19 = null,
		UDRATE20 = null,
		UDRATE21 = null,
		UDRATE22 = null,
		UDRATE23 = null,
		UDRATE24 = null,
		UDRATE25 = null,
		UDRATE26 = null,
		UDRATE27 = null,
		UDRATE28 = null,
		UDRATE29 = null,
		UDRATE30 = null
	</cfquery>
	
	<cfquery name="year_end_paynote" datasource="#dts#">
	update paynote
	set BACKPAY = null,
		OOB = null,
		WDAY = null,
		WDAY2 = null,
		DW = null,
		DW2 = null,
		PH = null,
		AL = null,
		MC = null,
		MT = null,
		CC = null,
		PT = null,
		MR = null,
        OIL = null,
            ECL = null,
            RS = null,
		CL = null,
		HL = null,
		AD = null,
		EX = null,
		LS = null,
		OPL = null,
		NPL = null,
		NPL2 = null,
		AB = null,
		ONPL = null,
		DWAWADJ = null,
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
		DED111 = null,
		DED112 = null,
		DED113 = null,
		DED114 = null,
		DED115 = null,
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
		SHIFTK = null,
		SHIFTL = null,
		SHIFTM = null,
		SHIFTN = null,
		SHIFTO = null,
		SHIFTP = null,
		SHIFTQ = null,
		SHIFTR = null,
		SHIFTS = null,
		SHIFTT = null,
		TIPPOINT = null,
		TIPRATE = null,
		MFUND = null,
		DFUND = null,
		PIECEPAY = null,
		BASICPAY = null,
		FULLPAY = null,
		NPLPAY = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
		OT6 = null,
		OTPAY = null,
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
		ADVANCE = null,
		TIPAMT = null,
		ITAXPCB = null,
		TAW = null,
		TDED = null,
		TDEDU = null,
		GROSSPAY = null,
		NETPAY = null,
		CCSTAT1 = null,
		CCSTAT2 = null,
		CCSTAT3 = null,
		PENCEN = null,
		UDRATE1 = null,
		UDRATE2 = null,
		UDRATE3 = null,
		UDRATE4 = null,
		UDRATE5 = null,
		UDRATE6 = null,
		UDRATE7 = null,
		UDRATE8 = null,
		UDRATE9 = null,
		UDRATE10 = null,
		UDRATE11 = null,
		UDRATE12 = null,
		UDRATE13 = null,
		UDRATE14 = null,
		UDRATE15 = null,
		UDRATE16 = null,
		UDRATE17 = null,
		UDRATE18 = null,
		UDRATE19 = null,
		UDRATE20 = null,
		UDRATE21 = null,
		UDRATE22 = null,
		UDRATE23 = null,
		UDRATE24 = null,
		UDRATE25 = null,
		UDRATE26 = null,
		UDRATE27 = null,
		UDRATE28 = null,
		UDRATE29 = null,
		UDRATE30 = null
	</cfquery>
	
	<cfquery name="year_end_paytra1" datasource="#dts#">
	update paytra1
	set BACKPAY = null,
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
		DED111 = null,
		DED112 = null,
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
		SHIFTK = null,
		SHIFTL = null,
		SHIFTM = null,
		SHIFTN = null,
		SHIFTO = null,
		SHIFTP = null,
		SHIFTQ = null,
		SHIFTR = null,
		SHIFTS = null,
		SHIFTT = null,
		TIPPOINT = null,
		CLTIPOINT = null,
		TIPRATE = null,
		MFUND = null,
		DFUND = null,
		ZAKAT_BF = null,
		ZAKAT_BFN = null,
		PIECEPAY = null,
		BASICPAY = null,
		FULLPAY = null,
		NPLPAY = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
		OT6 = null,
		OTPAY = null,
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
		ADVANCE = null,
		ADVPAY = null,
		TIPAMT = null,
		ITAXPCB = null,
		ITAXPCBADJ = null,
		TAW = null,
		TXOTPAY = null,
		TXAW = null,
		TXDED = null,
		TDED = null,
		TDEDU = null,
		GROSSPAY = null,
		NETPAY = null,
		EPF_PAY = null,
		EPF_PAY_A = null,
		CCSTAT1 = null,
		CCSTAT2 = null,
		CCSTAT3 = null,
		PENCEN = null,
		PROJECT = null,
		CHEQUE_NO = null,
		BANKCHARGE = null,
		ADVDAY = null,
		PM_CODE = null,
		TMONTH = null,
		UDRATE1 = null,
		UDRATE2 = null,
		UDRATE3 = null,
		UDRATE4 = null,
		UDRATE5 = null,
		UDRATE6 = null,
		UDRATE7 = null,
		UDRATE8 = null,
		UDRATE9 = null,
		UDRATE10 = null,
		UDRATE11 = null,
		UDRATE12 = null,
		UDRATE13 = null,
		UDRATE14 = null,
		UDRATE15 = null,
		UDRATE16 = null,
		UDRATE17 = null,
		UDRATE18 = null,
		UDRATE19 = null,
		UDRATE20 = null,
		UDRATE21 = null,
		UDRATE22 = null,
		UDRATE23 = null,
		UDRATE24 = null,
		UDRATE25 = null,
		UDRATE26 = null,
		UDRATE27 = null,
		UDRATE28 = null,
		UDRATE29 = null,
		UDRATE30 = null,
		PAYYES = null,
		cpf_amt = null,
		PAYIN = null
	</cfquery>
	
	<cfquery name="year_end_paytran" datasource="#dts#">
	update paytran
	set BACKPAY = null,
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
		DED111 = null,
		DED112 = null,
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
		SHIFTK = null,
		SHIFTL = null,
		SHIFTM = null,
		SHIFTN = null,
		SHIFTO = null,
		SHIFTP = null,
		SHIFTQ = null,
		SHIFTR = null,
		SHIFTS = null,
		SHIFTT = null,
		TIPPOINT = null,
		CLTIPOINT = null,
		TIPRATE = null,
		MFUND = null,
		DFUND = null,
		ZAKAT_BF = null,
		ZAKAT_BFN = null,
		PIECEPAY = null,
		BASICPAY = null,
		FULLPAY = null,
		NPLPAY = null,
		OT1 = null,
		OT2 = null,
		OT3 = null,
		OT4 = null,
		OT5 = null,
		OT6 = null,
		OTPAY = null,
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
		ADVANCE = null,
		ADVPAY = null,
		TIPAMT = null,
		ITAXPCB = null,
		ITAXPCBADJ = null,
		TAW = null,
		TXOTPAY = null,
		TXAW = null,
		TXDED = null,
		TDED = null,
		TDEDU = null,
		GROSSPAY = null,
		NETPAY = null,
		EPF_PAY = null,
		EPF_PAY_A = null,
		CCSTAT1 = null,
		CCSTAT2 = null,
		CCSTAT3 = null,
		PENCEN = null,
		PROJECT = null,
		CHEQUE_NO = null,
		BANKCHARGE = null,
		ADVDAY = null,
		PM_CODE = null,
		TMONTH = null,
		UDRATE1 = null,
		UDRATE2 = null,
		UDRATE3 = null,
		UDRATE4 = null,
		UDRATE5 = null,
		UDRATE6 = null,
		UDRATE7 = null,
		UDRATE8 = null,
		UDRATE9 = null,
		UDRATE10 = null,
		UDRATE11 = null,
		UDRATE12 = null,
		UDRATE13 = null,
		UDRATE14 = null,
		UDRATE15 = null,
		UDRATE16 = null,
		UDRATE17 = null,
		UDRATE18 = null,
		UDRATE19 = null,
		UDRATE20 = null,
		UDRATE21 = null,
		UDRATE22 = null,
		UDRATE23 = null,
		UDRATE24 = null,
		UDRATE25 = null,
		UDRATE26 = null,
		UDRATE27 = null,
		UDRATE28 = null,
		UDRATE29 = null,
		UDRATE30 = null,
		PAYYES = null,
		cpf_amt = null
	</cfquery>
	
	<cfloop from=1 to=6 index='i'>
		<cfset qry_var="payweek"&#i# >	
		<!---<cfoutput>#qry_var#</cfoutput> --->
		 <cfquery name="year_end_payweek1" datasource="#dts#">
			update #qry_var#
			set BACKPAY = null,
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
				MR = null,
				PT = null,
                OIL = null,
            ECL = null,
            RS = null,
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
				DED111 = null,
				DED112 = null,
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
				SHIFTK = null,
				SHIFTL = null,
				SHIFTM = null,
				SHIFTN = null,
				SHIFTO = null,
				SHIFTP = null,
				SHIFTQ = null,
				SHIFTR = null,
				SHIFTS = null,
				SHIFTT = null,
				TIPPOINT = null,
				CLTIPOINT = null,
				TIPRATE = null,
				MFUND = null,
				DFUND = null,
				ZAKAT_BF = null,
				ZAKAT_BFN = null,
				PIECEPAY = null,
				BASICPAY = null,
				FULLPAY = null,
				NPLPAY = null,
				OT1 = null,
				OT2 = null,
				OT3 = null,
				OT4 = null,
				OT5 = null,
				OT6 = null,
				OTPAY = null,
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
				ADVANCE = null,
				ADVPAY = null,
				TIPAMT = null,
				ITAXPCB = null,
				ITAXPCBADJ = null,
				TAW = null,
				TXOTPAY = null,
				TXAW = null,
				TXDED = null,
				TDED = null,
				TDEDU = null,
				GROSSPAY = null,
				NETPAY = null,
				EPF_PAY = null,
				EPF_PAY_A = null,
				CCSTAT1 = null,
				CCSTAT2 = null,
				CCSTAT3 = null,
				PENCEN = null,
				PROJECT = null,
				CHEQUE_NO = null,
				BANKCHARGE = null,
				ADVDAY = null,
				PM_CODE = null,
				TMONTH = null,
				UDRATE1 = null,
				UDRATE2 = null,
				UDRATE3 = null,
				UDRATE4 = null,
				UDRATE5 = null,
				UDRATE6 = null,
				UDRATE7 = null,
				UDRATE8 = null,
				UDRATE9 = null,
				UDRATE10 = null,
				UDRATE11 = null,
				UDRATE12 = null,
				UDRATE13 = null,
				UDRATE14 = null,
				UDRATE15 = null,
				UDRATE16 = null,
				UDRATE17 = null,
				UDRATE18 = null,
				UDRATE19 = null,
				UDRATE20 = null,
				UDRATE21 = null,
				UDRATE22 = null,
				UDRATE23 = null,
				UDRATE24 = null,
				UDRATE25 = null,
				UDRATE26 = null,
				UDRATE27 = null,
				UDRATE28 = null,
				UDRATE29 = null,
				UDRATE30 = null,
				PAYYES = null
			</cfquery>
	</cfloop>
	
	<cfquery name="year_end_proj_pay" datasource="#dts#">
		truncate proj_pay
	</cfquery>
	
	<cfquery name="year_end_proj_pay_12m" datasource="#dts#">
		truncate proj_pay_12m
	</cfquery>
	
	<cfquery name="year_end_proj_rcd" datasource="#dts#">
		truncate proj_rcd
	</cfquery>
	
	<cfquery name="year_end_proj_rcd_1" datasource="#dts#">
		truncate proj_rcd_1
	</cfquery>
	
	<cfquery name="year_end_proj_rcd_12m" datasource="#dts#">
		truncate proj_rcd_12m
	</cfquery>
	
	<cfquery name="year_end_proj_rcd_12m_1" datasource="#dts#">
		truncate proj_rcd_12m_1
	</cfquery>
	
	<cfquery name="year_end_pwork" datasource="#dts#">
		truncate pwork
	</cfquery>
	
<!-- 	adding the system year  -->

	<cfquery name="add_year_gsteup_qry" datasource="#dts_main#">
		update gsetup 
		set myear = #yrs#, 
		mmonth="1" WHERE comp_id = "#HcomID#"
	</cfquery>
    
   <cfquery name="year_end_pleave" datasource="#dts#">
		DELETE FROM pleave WHERE lve_date < "#dateformat(datenew,'YYYY-MM-DD')#"
	</cfquery>
	
	<cfset status_msg="Year End Success!">
	<cfcatch type="database">
		<cfset status_msg="Fail To Year End. Error Message : #cfcatch.Detail#">
	</cfcatch>
</cftry>


<cfif status_msg eq "Year End Success!">
 <cfquery name="getemail" datasource="#dts#">
            SELECT userEmail FROM payroll_main.users WHERE
            userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
            </cfquery>

<cfset yearnow = numberformat(right(getyear.myear,2),'00')>

<cfset newdts =replace(dts,'_p','')&val(yearnow)&"_p">

<cfset companyidnew = replace(newdts,'_p','')>
<cfset username = "admin"&companyidnew>
<cfinclude template="generatepass.cfm">
<cfset password = strPassword >
<cfset customer = "system" >
<cfset email = getemail.useremail >
<cfset dsn = dts>

<cfquery name="insert_record" datasource="net_c">
INSERT INTO userSystemAccount (system,username,password,companyid,comID,dateCreated,createdBy)
VALUES ("PAYROLL","#username#","#password#","#companyidnew#","#customer#",now(),"system")
</cfquery>

<cfinvoke component="com.payroll" method="createnew" userid="#username#" passwordnew="#password#" companyid = "#companyidnew#" dsn="#DSN#" db="#dts#" email = "#email#"  maindb="empty" serverside="sg" returnvariable="myResult" />

<cfif trim(myresult) eq "Sucess!">
<cfset currentdirfilenew = currentdirfile>
<cfset currentURL =  CGI.SERVER_NAME>

<cfset currentDirectory = "C:\NEWSYSTEM\PAY\DATABACKUP\"& newdts>
<cfif DirectoryExists(currentDirectory) eq false>
<cfdirectory action = "create" directory = "#currentDirectory#" >
</cfif>
<cfset filename=newdts&"_"&dateformat(now(),'YYYYMMDD')&"_"&timeformat(now(),'HHMMSS')&"_"&GetAuthUser()&"_RESBACK.sql">
<cfset currentdirfile=currentDirectory&"\"&filename>
<cfexecute name = "C:\inetpub\wwwroot\payroll\mysqldump"
    arguments = "--host=#serverhost# --user=#servername# --password=#serverpass# #newdts#" outputfile="#currentdirfile#" timeout="720">
</cfexecute>

<cfset filesize = GetFileInfo('#currentdirfile#').size >

<cfif filesize lt 200000>
<h1>Year End Completed But Create Previous Year Database failed!Please contact System Administrator!</h1>
<cfabort>
</cfif>




<cfset currentDirectory = "C:\NEWSYSTEM\PAY\DATABACKUP\"& newdts>
<cfset runfile = currentDirectory&"\"&newdts&".bat">
<cfset filename=currentdirfilenew>
<cfset filecontent = "C:\NEWSYSTEM\PAY\DATABACKUP\mysql.exe "&" --host=#serverhost# --user=#servername# --password=#serverpass# "&newdts&" < "&filename>

<cffile action="Write" 
            file="#runfile#" 
            output="#filecontent#" nameconflict="overwrite"> 

<cfexecute name = "#runfile#" timeout="720">
</cfexecute>

<cfquery name="getcolumns" datasource="#dts_main#">
SHOW COLUMNS FROM payroll_main.gsetup where field not in ("myear","mmonth")
</cfquery>

<cfquery name="deleteoldcolumn" datasource="#dts_main#">
DELETE FROM gsetup WHERE comp_id = "#companyidnew#"
</cfquery>

<cfquery name="insertfrom" datasource="#dts_main#">
INSERT INTO gsetup
(
mmonth,
myear,
<cfloop query="getcolumns">
<cfif getcolumns.field neq "entry">
#getcolumns.field#<cfif getcolumns.recordcount neq getcolumns.currentrow>,</cfif>
</cfif>
</cfloop>
)
SELECT
"13",
"#getyear.myear#",
"#companyidnew#",
<cfloop query="getcolumns">
<cfif getcolumns.field neq "comp_id" and getcolumns.field neq "entry">
#getcolumns.field#<cfif getcolumns.recordcount neq getcolumns.currentrow>,</cfif>
</cfif>
</cfloop>
FROM gsetup WHERE comp_id = "#hcomid#"
</cfquery>


<cfoutput>
<cfmail to="#email#" from="noreply@mynetiquette.com" subject="Netiquette Payroll Year End for #dts# has completed" bcc="noreply@mynetiquette.com;shicai@mynetiquette.com" type="html">
Hi,<br />
<br />
Netiquette PAYROLL Year End for #dts# has completed<br />
<br />
Please refer below for old database information:<br>
<br>
Company ID: #companyidnew#<br>
Username : #username#<br>
Password : #password#<br>
<br>
Best Regards,<br />
Netiquette<br />
</cfmail>
</cfoutput>

<cfelse>
<h1>Year End Completed But Create Previous Year Database failed!Please contact System Administrator!</h1>
<cfabort>
</cfif>


</cfif>

<cfoutput><form name="pc" id="pc"  action="yearEndMain.cfm" method="post">
<input type="hidden" name="status" value="#status_msg#" />
</form></cfoutput>
<script type="text/javascript">
alert('Year End Completed!');
window.parent.frames("topFrame").location.reload();
document.getElementById('pc').submit();
</script>