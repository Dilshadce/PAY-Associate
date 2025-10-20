<cftry>
<cfif isdefined('form.clear') >
<cfset clear_type = form.clear >
</cfif>

<cfif clear_type eq "clear1">
<cfquery name="BPO_qry" datasource="#dts#">
UPDATE paytran
SET ALHR = null,
    BASICPAY = null,
    OTPAY = null,
    DIRFEE = null,
    TAW = null,
    GROSSPAY = null,
    TDEDU = null,
    TDED = null,
    NETPAY = null,
    NPLPAY = null,
    OT1 = null,
    OT2 = null,
    OT3 = null,
    OT4 = null,
    OT5 = null,
    OT6 = null,
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
    MFUND = null,
    DFUND = null,
    EPF_PAY = null,
    EPF_PAY_A = null,
    RATE1 = null,
    RATE2 = null,
    RATE3 = null,
    RATE4 = null,
    RATE5 = null,
    RATE6 = null,
	DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry" datasource="#dts#">
UPDATE paytran
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry" datasource="#dts#">
UPDATE paytran
SET AW#i# = null,
	DWAWADJ = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry" datasource="#dts#">
UPDATE paytran
SET DED#i# = null,
	MESS = null,
	MESS1 = null
</cfquery>
</cfloop>

<cfquery name="OTH_qry" datasource="#dts#">
UPDATE paytran
SET SHIFTA = null,
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
	SHIFTT = null
</cfquery>

<cfloop from=1 to=30 index="i">
<cfquery name="UDRate_qry" datasource="#dts#">
UPDATE paytran
SET 
	UDRATE#i# = null
</cfquery>
</cfloop>


<cfquery name="BPO_qry1" datasource="#dts#">
UPDATE paytra1
SET ALHR = null,
    BASICPAY = null,
    OTPAY = null,
    DIRFEE = null,
    TAW = null,
    GROSSPAY = null,
    TDEDU = null,
    TDED = null,
    NETPAY = null,
    NPLPAY = null,
    OT1 = null,
    OT2 = null,
    OT3 = null,
    OT4 = null,
    OT5 = null,
    OT6 = null,
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
    MFUND = null,
    DFUND = null,
    EPF_PAY = null,
    EPF_PAY_A = null,
    RATE1 = null,
    RATE2 = null,
    RATE3 = null,
    RATE4 = null,
    RATE5 = null,
    RATE6 = null,
    DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry1" datasource="#dts#">
UPDATE paytra1
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry1" datasource="#dts#">
UPDATE paytra1
SET AW#i# = null,
	DWAWADJ = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry1" datasource="#dts#">
UPDATE paytra1
SET DED#i# = null,
	MESS = null,
	MESS1 = null
</cfquery>
</cfloop>

<cfquery name="OTH_qry1" datasource="#dts#">
UPDATE paytra1
SET SHIFTA = null,
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
	SHIFTT = null
</cfquery>

<cfloop from=1 to=30 index="i">
<cfquery name="UDRate_qry1" datasource="#dts#">
UPDATE paytra1
SET 
	UDRATE#i# = null
</cfquery>
</cfloop>


<cfloop from="1" to="6" index="i">
<cfset table_var = "payweek"&#i# > 
<cfinvoke component="cfc.monthEnd" method="monthEnd" db="#dts#" db1="#dts_main#" tablename="#table_var#" returnvariable="name" />
</cfloop>

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

<cfquery name="BPO_qry2" datasource="#dts#">
UPDATE pay_tm
SET TMONTH = null,
	BRATE = null,
    WDAY = null,
    ALHR = null,
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
	DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry2" datasource="#dts#">
UPDATE pay_tm
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry2" datasource="#dts#">
UPDATE pay_tm
SET AW#i# = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry2" datasource="#dts#">
UPDATE pay_tm
SET DED#i# = null
</cfquery>
</cfloop>

<cfquery name="BPO_qry2" datasource="#dts#">
UPDATE pay_12m
SET TMONTH = null,
	BRATE = null,
    WDAY = null,
    ALHR = null,
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
    RATE1 = null,
    RATE2 = null,
    RATE3 = null,
    RATE4 = null,
    RATE5 = null,
    RATE6 = null,
	DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry2" datasource="#dts#">
UPDATE pay_12m
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry2" datasource="#dts#">
UPDATE pay_12m
SET AW#i# = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry2" datasource="#dts#">
UPDATE pay_12m
SET DED#i# = null
</cfquery>
</cfloop>


<cfquery name="BPO_qry2" datasource="#dts#">
UPDATE pay1_12m
SET TMONTH = null,
	BRATE = null,
    WDAY = null,
    ALHR = null,
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
    RATE1 = null,
    RATE2 = null,
    RATE3 = null,
    RATE4 = null,
    RATE5 = null,
    RATE6 = null,
	DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry2" datasource="#dts#">
UPDATE pay1_12m
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry2" datasource="#dts#">
UPDATE pay1_12m
SET AW#i# = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry2" datasource="#dts#">
UPDATE pay1_12m
SET DED#i# = null
</cfquery>
</cfloop>

<cfquery name="BPO_qry2" datasource="#dts#">
UPDATE pay_ytd
SET TMONTH = null,
	BRATE = null,
    WDAY = null,
    ALHR = null,
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
	DW = null,
	PH = null,
	AL = null,
	MC = null,
	MT = null,
	MR = null,
	CL = null,
	HL = null,
	EX = null,
	PT = null,
	AD = null,
	OPL = null,
	LS = null,
	NPL = null,
	AB = null,
	ONPL = null,
	OOB = null,
	WORKHR = null,
	LATEHR = null,
	EARLYHR = null,
	NOPAYHR = null,
	PAYYES = "N"
</cfquery>

<cfloop from=1 to=6 index="i">
<cfquery name="hr_qry2" datasource="#dts#">
UPDATE pay_ytd
SET HR#i# = null
</cfquery>
</cfloop>

<cfloop from=101 to=117 index="i">
<cfquery name="AW_qry2" datasource="#dts#">
UPDATE pay_ytd
SET AW#i# = null
</cfquery>
</cfloop>
 
<cfloop from=101 to=115 index="i">
<cfquery name="DED_qry2" datasource="#dts#">
UPDATE pay_ytd
SET DED#i# = null
</cfquery>
</cfloop>

<cfelseif clear_type eq "clear2">

<cfset db_list = "adv_h1,adv_h2,bonu_12m,bonus,branch,category,comm,comm_12m,dept,emp_users,emp_users_log,extr_12m,extra,itaxea,itaxea2,jobdone,leave_apl,loanmst,moretr1,moretra,pay_12m,pay_tm,pay_ytd,pay1_12m,paynot1,paynote,paytra1,paytran,payweek1,payweek2,payweek3,payweek4,payweek5,payweek6,pcwork,pleave,pmast,project,tlineno" >

<cfloop list="#db_list#" index="i">
<cfquery name="truncate_db" datasource="#dts#">
truncate #i#
</cfquery>
</cfloop>

</cfif>

<cfset status_msg="Success Clear All Data">
<cfcatch type="database">
<cfset status_msg="Fail To Clear All Data. Error Message : #cfcatch.Detail#">
</cfcatch>
</cftry>

<cfoutput><form name="pc" action="/housekeeping/fileReOrganisation/clearTransactionMasterMain.cfm" method="post"></cfoutput>
<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
<cfoutput></form></cfoutput>
<script>
	pc.submit();
</script>