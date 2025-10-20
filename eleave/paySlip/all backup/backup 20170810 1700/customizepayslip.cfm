<cfif HMyear neq form.year1>
    <cfset MPyear = right(form.year1,2)>
    <cfset dsname = mid(dsname,1,len(dsname)-2) & MPyear&"_p">
</cfif>
<cftry>
<cfquery name="trydata" datasource="#dsname#">
SELECT name FROM pmast 
</cfquery>
<cfcatch type="any">
<script type="text/javascript">
alert('Pay slip not available!');
window.close();
</script>
<cfabort>
</cfcatch>
</cftry>

<cfif isdefined('url.eleave')>
<cfset dsname = dsname>
<cfset payroll_main = "payroll_main">
<cfset form.month = form.month1>
<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT pm.empno FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = "#HUserID#"  
</cfquery>
<cfset empno = emp_data.empno>
<cfset husername = HUserID>
<cfset hpin = 0>
</cfif>
<cfquery name="Clear_temp_cuz_payslip" datasource="#dsname#">
  DELETE FROM temp_cuz_payslip WHERE username="#HUserName#"	
</cfquery>
<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfif mon eq 13>
<cfset mon = 12>
</cfif>
<cfset date= createdate(yrs,mon,1)>
<cfset month1= dateformat(date,'mmmm')>
<cfset year1= dateformat(date,'yyyy')>
<cfif type eq "pay12m">
<cfset paytable = form.paytype>
<cfset monthpay = form.month>
<cfset date= createdate(yrs,monthpay,1)>
<cfset month1 = dateformat(date,'mmmm')>
<cfelse>
<cfset paytable = url.type>
</cfif>
<cfquery name="selectList" datasource="#dsname#">
SELECT py.bonus,py.netpay as pnetpay, py.grosspay as pgrosspay, py.epfcc as pepfcc, py.epfww as pepfww, py.socsocc as psocsocc, py.socsoww as psocsoww, py.ded115 as pded115,
py.netpay as pbasicpay,py.tded as ptded, pc.empno,
 pc.name, pc.category, pc.deptcode, pc.basicpay, pc.epfww,
pc.aw101,pc.aw102,pc.aw103,pc.aw104,pc.aw105,pc.aw106,pc.aw107,pc.aw108,pc.aw109,pc.aw110,pc.aw111,pc.aw112
,pc.aw113,pc.aw114,pc.aw115,pc.aw116,pc.aw117,pc.ded101,pc.ded102,pc.ded103,pc.ded104,pc.ded105,pc.ded106,
pc.ded107,pc.ded108,pc.ded109,pc.ded110,pc.ded111,pc.ded112,pc.ded113,pc.ded114,pc.ded115,pc.bankcode,
pc.brancode,pc.bankaccno,tnetpay, tgrosspay,tepfww, tepfcc, tsocsoww, tsocsocc, AL,MC,CC,pc.ptmc,pc.ptal,pc.pmalbf,pc.pmalall,pc.pmmcall,pc.pmaladj,pc.ptcpfamt,py.epfcc as cpf_amt,pc.nplpay,pc.latehr,pc.earlyhr,pc.nopayhr,pc.total_late_h,pc.total_earlyD_h,pc.total_nop_h,pc.hourrate,pc.brate,pc.ot1,pc.ot2,pc.ot3,pc.ot4,pc.ot5,pc.ot6,pc.hr1,pc.hr2,pc.hr3,pc.hr4,pc.hr5,pc.hr6,pc.rate1,pc.rate2,pc.rate3,pc.rate4,pc.rate5,pc.rate6,pc.otpay,pc.ptcc,pc.pmccall,py.ded114 as ytd_cdac,py.mfund as mfund_ytd,pc.mfund,pc.mfundall,pc.dresign,pc.dcomm
FROM pay_ytd AS py LEFT JOIN
(SELECT pt.empno, pm.name, pm.category, pm.deptcode, pt.basicpay, pt.epfww,
pt.aw101,pt.aw102,pt.aw103,pt.aw104,pt.aw105,pt.aw106,pt.aw107,pt.aw108,pt.aw109,pt.aw110,pt.aw111,pt.aw112
,pt.aw113,pt.aw114,pt.aw115,pt.aw116,pt.aw117,pt.ded101,pt.ded102,pt.ded103,pt.ded104,pt.ded105,pt.ded106,pt.ded107,pt.ded108
,pt.ded109,pt.ded110,pt.ded111,pt.ded112,pt.ded113,pt.ded114,pt.ded115,pm.bankcode,pm.brancode,pm.bankaccno,pt.netpay as tnetpay,pt.grosspay as tgrosspay,
pt.epfww as tepfww, pt.epfcc as tepfcc, pt.socsoww as tsocsoww, pt.socsocc as tsocsocc, pt.AL as ptal,pt.MC as ptmc,pm.albf as pmalbf, pm.alall as pmalall,pm.aladj as pmaladj ,pm.mcall as pmmcall,<cfif type neq "pay12m">pt.cpf_amt<cfelse>pt.grosspay</cfif> as ptcpfamt,pt.nplpay,pt.latehr,pt.earlyhr,pt.nopayhr,
<cfif type neq "pay12m">
pt.total_late_h,pt.total_earlyD_h,pt.total_nop_h,pt.hourrate
<cfelse>
"0" as total_late_h,"0" as total_earlyD_h,"0" as total_nop_h, "0" as hourrate
</cfif>,pt.brate,pt.ot1,pt.ot2,pt.ot3,pt.ot4,pt.ot5,pt.ot6,pt.hr1,pt.hr2,pt.hr3,pt.hr4,pt.hr5,pt.hr6,pt.rate1,pt.rate2,pt.rate3,pt.rate4,pt.rate5,pt.rate6,pt.otpay,pt.cc as ptcc,pm.ccall as pmccall,pm.mfundall,pt.mfund,pm.dresign,pm.dcomm
FROM #paytable#
 AS pt 
LEFT JOIN 
pmast AS pm 
ON pt.empno=pm.empno
where 
<cfif type neq "pay12m">
payyes="Y" 
AND
<cfelse>
tmonth = "#monthpay#" AND
</cfif>

 pm.paystatus ="A" 
and confid >= #hpin#)AS pc
On 
pc.empno= py.empno 
where 
pc.empno is not null 
<cfif isdefined('url.eleave')>
and py.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#empno#">
</cfif>
order by pc.empno;

</cfquery>


<cfset dedname = "">
<cfset dedamount = 0>
<cfset awname = "">	
<cfset awamount = 0>
<cfloop query="selectList">

<cfquery name="getpaydesp" datasource="#dsname#">
            SELECT * FROM paynote WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
            </cfquery>

<cfif type eq "pay12m">
<cfquery name="getsumaltaken" datasource="#dsname#">
SELECT sum(coalesce(AL,0)) as al,sum(coalesce(CC,0)) as cc,sum(coalesce(mc,0)) as mc,
sum(coalesce(netpay,0)) as netpay,sum(coalesce(grosspay,0)) as grosspay,
sum(coalesce(epfww,0)) as epfww,sum(coalesce(epfcc,0)) as epfcc,
sum(coalesce(socsoww,0)) as socsoww,sum(coalesce(socsocc,0)) as socsocc,
sum(coalesce(ded115,0)) as ded115,
sum(coalesce(bonus,0)) as bonus FROM pay_12m WHERE empno =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#"> and tmonth < #val(form.month)#
</cfquery>
<cfset selectlist.cc = val(getsumaltaken.cc)>
<cfset selectlist.mc = val(getsumaltaken.mc)>
<cfset selectlist.al = val(getsumaltaken.al)>
<cfset selectlist.pnetpay = val(getsumaltaken.netpay)>
<cfset selectlist.pgrosspay = val(getsumaltaken.grosspay)>
<cfset selectlist.pepfww = val(getsumaltaken.epfww)>
<cfset selectlist.pepfcc = val(getsumaltaken.epfcc)>
<cfset selectlist.psocsoww = val(getsumaltaken.socsoww)>
<cfset selectlist.psocsocc = val(getsumaltaken.socsocc)>
<cfset selectlist.ded115 = val(getsumaltaken.ded115)>
<cfset selectlist.bonus = val(getsumaltaken.bonus)>
</cfif>
<cfif type neq "pay12m">
<cfquery name="getallbonus" datasource="#dsname#">
SELECT basicpay,epfcc,epfww FROM bonus WHERE  empno =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
</cfquery>
<cfset selectlist.bonus = val(selectlist.bonus) + val(getallbonus.basicpay)>
<cfset currentmonthbonus = val(getallbonus.basicpay)>
<cfset currentmonthbonusepfcc = val(getallbonus.epfcc)>
<cfset currentmonthbonusepfww = val(getallbonus.epfww)>
<cfelse>
<cfquery name="getallbonus" datasource="#dsname#">
SELECT basicpay,epfcc,epfww FROM bonu_12m WHERE  empno =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#"> and tmonth = #val(form.month)#
</cfquery>
<cfset currentmonthbonus = val(getallbonus.basicpay)>
<cfset currentmonthbonusepfcc = val(getallbonus.epfcc)>
<cfset currentmonthbonusepfww = val(getallbonus.epfww)>
</cfif>
<cfquery name="select_data" datasource="#dsname#">
	SELECT * FROM #paytable# AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = "#selectList.empno#" <cfif url.type eq "pay12m">
and pt.tmonth = "#monthpay#"	</cfif>
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
<cfset albal = val(selectList.pmalall) + val(selectList.pmalbf)+ val(selectList.pmaladj) - val(selectList.al) - val(selectList.ptal)>
<cfset mcbal = val(selectList.pmmcall)-val(selectList.mc)-val(selectList.ptmc)>
<cfset ccbal = val(selectList.pmccall)-val(selectList.cc)-val(selectList.ptcc)>

<cfif paytable eq "paytran">
<cfquery name="get1sthalf" datasource="#dsname#">
SELECT * FROM paytra1 WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
</cfquery>
<cfset albal = val(albal)- val(get1sthalf.al)>
<cfset mcbal = val(mcbal)-val(get1sthalf.mc)>
<cfset ccbal = val(ccbal)-val(get1sthalf.cc)>
<cfset selectlist.pnetpay =val(selectlist.pnetpay)+ val(get1sthalf.netpay)>
<cfset selectlist.pgrosspay = val(selectlist.pgrosspay)+ val(get1sthalf.grosspay)>
</cfif>

<cfif paytable eq "pay2_12m_fig">
<cfquery name="get1sthalf" datasource="#dsname#">
SELECT * FROM pay1_12m_fig WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#"> and tmonth = "#monthpay#"
</cfquery>
<cfset albal = val(albal)- val(get1sthalf.al)>
<cfset mcbal = val(mcbal)-val(get1sthalf.mc)>
<cfset ccbal = val(ccbal)-val(get1sthalf.cc)>
<cfset selectlist.pnetpay += val(get1sthalf.netpay)>
<cfset selectlist.pgrosspay += val(get1sthalf.grosspay)>
</cfif>

        <cfset awname = "Normal Pay" & chr(13)>
        
        <cfif (selectlist.dresign neq "" and month(selectlist.dresign) eq mon and year(selectlist.dresign) eq yrs) or (selectlist.dcomm neq "" and month(selectlist.dcomm) eq mon and year(selectlist.dcomm) eq yrs)>
        <cfset awamt = numberformat(vaL(selectlist.basicpay),'.__') & chr(13)>
        <cfelse>
        <cfset awamt = numberformat(vaL(selectlist.basicpay)+val(selectlist.nplpay),'.__') & chr(13)>
        </cfif>
        
		<cfloop from="1" to="17" index="i">
		<cfset awvar = 100 + i>
		<cfset awvar2 = "AW"&awvar>
		<cfset awdata = select_data[awvar2]>
		
		<cfif awdata neq 0>
			<cfquery name="get_aw_name" datasource="#dsname#">
			SELECT aw_desp FROM  awtable where aw_cou="#i#"
			</cfquery>
            <cfquery name="getawdesp" datasource="#dsname#">
            SELECT AW#awvar# as aw_desp FROM paynote WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
            </cfquery>
            
            <cfif getawdesp.aw_desp neq "">
            <cfset get_aw_name.aw_desp = get_aw_name.aw_desp&" "&getawdesp.aw_desp>
			</cfif>
		
			<cfset awname = awname&get_aw_name.aw_desp&chr(13)>
			
			<cfif awdata eq 0>
				<cfset awamt = awamt&chr(13)>
			<cfelse>
				<cfset awamt = awamt&awdata&chr(13)>
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
					<cfset dedname = "ADVANCE"&chr(13)&dedname&getdeddesp.ded_desp&chr(13)>
				<cfelse>
					<cfset dedname = dedname&getdeddesp.ded_desp&chr(13)>
				</cfif>
				
				<cfif advance neq "0">
					<cfset dedamount = advance&chr(13)&dedamount&dedname1&chr(13)>
					<cfset tot_dedamt = tot_dedamt + dedname1>
				<cfelse>
					<cfif dedamount eq "0">
						<cfset dedamount = dedname1&chr(13)>
					<cfelse>
						<cfset dedamount = dedamount&dedname1&chr(13)>
						<cfset tot_dedamt = tot_dedamt + dedname1>
					</cfif>
				</cfif>	
			</cfif>
	</cfloop>
	
	<cfset tot_dedamt2 = tot_dedamt + val(select_data.advance)>
    <cfif selectlist.tepfww gt 0 >
        <cfset dedname = dedname & "Employee EPF" & chr(13)>
        <cfset dedamount = dedamount & selectlist.tepfww & chr(13)>    
    </cfif>
    <cfif selectlist.tsocsoww gt 0 >
        <cfset dedname = dedname & "Employee Socso" & chr(13)>
        <cfset dedamount = dedamount & selectlist.tsocsoww & chr(13)>    
    </cfif>
    <cfif selectlist.nplpay gt 0 >
     <cfif (selectlist.dresign neq "" and month(selectlist.dresign) eq mon and year(selectlist.dresign) eq yrs) or (selectlist.dcomm neq "" and month(selectlist.dcomm) eq mon and year(selectlist.dcomm) eq yrs)>
     <cfelse>
        <cfset dedname = dedname & "NPL Pay" & chr(13)>
        <cfset dedamount = dedamount & selectlist.nplpay & chr(13)>    
        </cfif>
    </cfif>
<!---    <cfif selectlist.ded115 gt 0 >
        <cfset dedname = dedname & "Employee Tax" & chr(13)>
        <cfset dedamount = dedamount & selectlist.ded115 & chr(13)>    
    </cfif>--->
    
        <cfset nplist = "">
        <cfset nphramount = 0>
        
        <cfif val(selectList.latehr) gt 0>
        <cfset nphramount = nphramount + val(selectlist.total_late_h)>
        <cfset nplist = nplist&"Lateness -"&numberformat(val(selectList.latehr),'.__')&"@   "&numberformat(val(selectList.hourrate),'.__')&" = "&numberformat(val(selectList.total_late_h),'.__')&chr(13)>
        </cfif>
        
        <cfif val(selectList.earlyhr) gt 0>
        <cfset nphramount = nphramount + val(selectlist.total_earlyD_h)>
        <cfset nplist = nplist&"Early Depart -"&numberformat(val(selectList.earlyhr),'.__')&"@   "&numberformat(val(selectList.hourrate),'.__')&" = "&numberformat(val(selectList.total_earlyD_h),'.__')&chr(13)>
        </cfif>
        
         <cfif val(selectList.nopayhr) gt 0>
        <cfset nphramount = nphramount + val(selectlist.total_nop_h)>
        <cfset nplist = nplist&"No Pay -"&numberformat(val(selectList.nopayhr),'.__')&"@   "&numberformat(val(selectList.hourrate),'.__')&" = "&numberformat(val(selectList.total_nop_h),'.__')&chr(13)>
        </cfif>
        
        <cfloop from="1" to="6" index="i">
        
        
            
		<cfset otvar = "OT"&i>
		<cfset otdata = select_data[otvar]>
		<cfset othrvar = "hr"&i>
		<cfset othrdata = select_data[othrvar]>
		<cfset otnotedesp = getpaydesp[othrvar]>
		<cfif otdata neq 0>
			<cfquery name="getOt_qry" datasource="#dsname#">
			SELECT OT_COU,OT_UNIT,OT_DESP FROM Ottable WHERE OT_COU="#i#"
			</cfquery>
			<cfset otdesp = otdesp&getOt_qry.OT_DESP&" "&otnotedesp&chr(13)>
			<cfset otunit = otunit&getOt_qry.OT_UNIT&chr(13)>
		
			<cfif othr eq "0">
				<cfset othr = othrdata&chr(13)>
			<cfelse>
				<cfset othr = othr&othrdata&chr(13)>
			</cfif>
			
			<cfif otamt eq "0">
				<cfset otamt = otdata&chr(13)>
			<cfelse>
				<cfset otamt = otamt&otdata&chr(13)>
				<cfset tot_otamt = val(tot_otamt) + val(otdata)>
			</cfif>
		
		</cfif>
	
	</cfloop>
    <cfif type eq "pay12m">
     <cfset total_basic = #val(select_data.basicpay)#>
	<cfelse>
     <cfset total_basic = #val(select_data.basicpay)#-#val(select_data.backpay)#>
	</cfif>
            <!--- <cfset total_basic = #val(select_data.basicpay)#-#val(select_data.backpay)#> --->
            
        <cfquery name="getdeptdesp" datasource="#dsname#">
        SELECT deptdesp FROM dept WHERE deptcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.deptcode#">
        </cfquery>
        
        <cfif (selectlist.dresign neq "" and month(selectlist.dresign) eq mon and year(selectlist.dresign) eq yrs) or (selectlist.dcomm neq "" and month(selectlist.dcomm) eq mon and year(selectlist.dcomm) eq yrs)><cfelse>
		<cfset selectlist.tgrosspay = val(selectlist.tgrosspay) + val(selectlist.nplpay)>
        <cfset tot_dedamt2 = val(tot_dedamt2) +  val(selectlist.nplpay)>
		</cfif>
        
		<cfquery name="insertTempTable" datasource="#dsname#">
		INSERT INTO temp_cuz_payslip(  `name` ,  `empl` ,  `cate` ,  `dept` ,  `basicPay` ,  `emp_cpf` ,  `aw_name1` ,  `aw_amt1` ,
		  `ded_name1` ,  `ded_amt1` ,   `tnetpay` ,
		  `pgrosspay` ,  `pbasicpay` ,  `pepfcc` ,  `pepfww` , `psocsocc`, `psocsoww`, `username`  , `bankcode` ,  `brancode` ,  `bankaccno` ,
		  `pnetpay` ,  `tgrosspay` ,  `tepfww` ,  `tepfcc`, `tsocsoww`, `tsocsocc`, 
          ytd_al,ytd_mc,bal_ytd_al,bal_ytd_mc,AL,MC,cpf_amt,ytd_cpf_amt,nplpay,nplhr,npllist,basicrate,othr,otpay,CC,ytd_cc,bal_ytd_cc,nric, wrkday, dw,otdesp, otunit, otamt,
		   totawamt,tot_dedamt,tot_otamt,ytd_ded,ytd_cdac,mfund,mfund_ytd,mfund_bal,bratedesp,bonus,currentbonus,bonus_epfww,bonus_epfcc,pded115,ded115 )
		values 
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.name#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#selectList.category#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#getdeptdesp.deptdesp#">,
		"#val(selectList.basicpay)#",
		"#val(selectList.epfww)#",
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#awname#'>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#awamt#'>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#dedname#'>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value='#dedamount#'>,
		"#val(selectList.tnetpay)#","#val(selectList.pgrosspay)#",
		"#val(selectList.pbasicpay)#","#val(selectList.pepfcc)#",
		"#val(selectList.pepfww)#","#val(selectList.psocsocc)#",
		"#val(selectList.psocsoww)#",         
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserName#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.bankcode#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.brancode#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.bankaccno#">,
		"#val(selectList.pnetpay)#","#val(selectList.tgrosspay)#",
		"#val(selectList.tepfww)#","#val(selectList.tepfcc)#",
		"#val(selectList.tsocsoww)#","#val(selectList.tsocsocc)#",
        <cfqueryparam cfsqltype="cf_sql_double" value="#val(selectList.AL)#">,
        <cfqueryparam cfsqltype="cf_sql_double" value="#val(selectList.MC)#">,
        <cfqueryparam cfsqltype="cf_sql_double" value="#val(albal)#">,
        <cfqueryparam cfsqltype="cf_sql_double" value="#val(mcbal)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.PTAL)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.PTMC)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.ptcpfamt)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.cpf_amt)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.nplpay)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(nphramount)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#nplist#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.brate)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#othr#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.otpay)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.PTCC)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.CC)#">,
        <cfqueryparam cfsqltype="cf_sql_double" value="#val(ccbal)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.nricn#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.wday#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.dw#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otdesp#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otunit#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#otamt#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#totawamt#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#tot_dedamt2#">,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#tot_otamt#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.ptded)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.ytd_cdac)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.mfund)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.mfund_ytd)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.mfundall)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpaydesp.brate#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectList.bonus)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(currentmonthbonus)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(currentmonthbonusepfww)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(currentmonthbonusepfcc)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectlist.pded115)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(selectlist.ded115)#">
		)
		</cfquery>
		
</cfloop>

<cfif isdefined('form.order')>
<cfset order_keyword="pm."&#form.order#>
<cfelse>
<cfset order_keyword="pm.empno">
</cfif>
<cfquery name="select_temp_file" datasource="#dsname#">
select * FROM (SELECT t.*,pm.brate as brate1,pm.payrtype as payrtype1,pm.dbirth,pm.paymeth as paymeth1,pm.epfno,pm.itaxno,pm.socsono,pm.passport FROM temp_cuz_payslip as t left join pmast as pm on t.empl=pm.empno where username="#HUserName#"
	<cfif isdefined('url.eleave')>
<cfelse>
<cfif #form.empno# neq "">
	AND pm.empno >= "#form.empno#"
</cfif>
<cfif #form.empno1# neq "">
	AND pm.empno <= "#form.empno1#"
</cfif>
<cfif #form.lineno# neq "">
	AND pm.plineno >= "#form.lineno#"
</cfif>
<cfif #form.lineno1# neq "">
	AND pm.plineno <= "#form.lineno1#"
</cfif>
<cfif #form.brcode# neq "">
	AND pm.brcode >= "#form.brcode#"
</cfif>
<cfif #form.brcode1# neq "">
	AND pm.brcode <= "#form.brcode1#"
</cfif>
<cfif #form.deptcode# neq "">
	AND pm.deptcode >= "#form.deptcode#"
</cfif>
<cfif #form.deptcode1# neq "">
	AND pm.deptcode <= "#form.deptcode1#"
</cfif>
<cfif #form.category# neq "">
	AND pm.category >= "#form.category#"
</cfif>
<cfif #form.category1# neq "">
	AND pm.category <= "#form.category1#"
</cfif>
<cfif #form.emp_code# neq "">
	AND pm.emp_code >= "#form.emp_code#"
</cfif>
<cfif #form.emp_code1# neq "">
	AND pm.emp_code <= "#form.emp_code1#"
</cfif>
<cfif isdefined('form.confid')>
<cfif #form.confid# neq "">
	AND pm.confid = "#form.confid#"
</cfif>
<cfelse>
	AND pm.confid >= #hpin#
</cfif>
<cfif isdefined('form.payrtype')>
<cfif #form.payrtype# neq "">
	AND pm.payrtype = "#form.payrtype#"
</cfif>
</cfif>
<cfif isdefined('form.paymeth')>
<cfif #form.paymeth# neq "">
	AND pm.paymeth <= "#form.paymeth#"
</cfif>
</cfif>
<cfif isdefined('form.exclude0')>
	AND basicpay > 0
</cfif>
</cfif>

<cfif isdefined('form.order')>
<cfif #form.order# neq "">
	ORDER BY #order_keyword# asc
<cfelse>
	ORDER BY pm.empno
</cfif> 
<cfelse>
	ORDER BY pm.empno
</cfif>
) as aa left join (select empno as empno1,brate as brate1,NPL,nplpay as nplpay1,latehr,<cfif type eq "pay12m">"0" as </cfif>total_late_h,earlyhr,nopayhr,<cfif type eq "pay12m">"0" as </cfif>total_earlyD_h,<cfif type eq "pay12m">"0" as </cfif>total_nop_h,basicpay as newbasicpay, ph as phday,ded114,MT,CC as ccday,MR,PT,CL,HL,AD,EX,LS,<cfif type eq "pay12m">"" as </cfif>OPLD,OPL,NS,AB,<cfif type eq "pay12m">"" as </cfif>ONPLD,ONPL FROM #paytable# <cfif url.type eq "pay12m">
WHERE tmonth = "#monthpay#"	</cfif> ) as bb
  on aa.empl = bb.empno1
</cfquery>
<cfif isdefined('form.remark')>
<cfset remark = form.remark>
<cfelse>
<cfset remark = "">
</cfif>
<cfif type eq "pay12m">
<cfset form.psDate = dateformat(now(),'dd/mm/yyyy')>
</cfif>

<!---<cfoutput>
#selectlist.ded115#<br>
#selectlist.pded115#<br>
<cfabort></cfoutput>--->

<cfreport template="customizepayslip_cy.cfr" format="PDF" query="select_temp_file">
 	<cfreportparam name="compname" value="#company_details.COMP_NAME#">
	<cfreportparam name="month1" value="#month1#">
	<cfreportparam name="year1" value="#year1#">
	<cfreportparam name="psDate" value="#date#">
    <cfreportparam name="tabletype" value="#paytable#">
</cfreport>
