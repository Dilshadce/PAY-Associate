<cfcomponent>
<cffunction name="sum_pay" access="public" returntype="Any">
	<cfargument name="empno" required="yes">
	<cfargument name="db" required="yes">
<!---     <cfargument name="db1" required="no">
    <cfargument name="compid" required="no">
    
    <cfquery name="get_now_month" datasource="#db1#">
	        	SELECT balancecpf FROM gsetup WHERE comp_id = "#compid#"
	        </cfquery> --->
	
		<cfquery name="ps" datasource="#db#">
        SELECT * FROM paytran WHERE empno = "#empno#" and payyes = "Y"
        </cfquery>
		
		<cfquery name="ps1" datasource="#db#">
        SELECT * FROM paytra1 WHERE empno = "#empno#" and payyes = "Y"
        </cfquery>
        
        <!--- Select All From Bonus --->
        <cfquery name="bonus_data" datasource="#db#">
        SELECT * FROM bonus WHERE empno = "#empno#"
        </cfquery>
        
        <!--- Select All From Extra --->
        <cfquery name="extra_data" datasource="#db#">
        SELECT * FROM extra WHERE empno = "#empno#" 
        </cfquery>
        
        <!--- Select All From Comm --->
        <cfquery name="comm_data" datasource="#db#">
        SELECT * FROM comm WHERE empno = "#empno#" 
        </cfquery>        
		
		
        <!--- Update Into Pay_tm --->
		<cfquery name="updateintopaytm" datasource="#db#">
        	UPDATE pay_tm SET
		      <!---  HRD_PAY = #val(hrd_pay)# ,--->
			    BONUS = #val(bonus_data.basicpay)#,
		        EXTRA = #val(extra_data.basicpay)#,
		        COMM = #val(comm_data.basicpay)#,
		        BRATE = #val(ps.brate) + val(ps1.brate)#,
		        OOB = #val(ps.oob) + val(ps1.oob)#,
		        WDAY = #val(ps.Wday) + val(ps1.Wday)#,
				DW = #val(ps.DW)+val(ps1.DW)# , 
				PH = #val(ps.PH)+val(ps1.PH)#,
				AL = #val(ps.AL)+val(ps1.AL)#,
				ALHR = #val(ps.ALHR)+val(ps1.ALHR)#,
				MC = #val(ps.MC)+val(ps1.MC)#,
				MT = #val(ps.MT)+val(ps1.MT)#,
		        CC = #val(ps.CC)+val(ps1.CC)#,
				PT = #val(ps.PT)+val(ps1.PT)#,
				MR = #val(ps.MR)+val(ps1.MR)#,
				CL = #val(ps.CL)+val(ps1.CL)#,
				HL = #val(ps.HL)+val(ps1.HL)#,
		        AD = #val(ps.AD)+val(ps1.AD)#,
                OIL = #val(ps.OIL)+val(ps1.OIL)#,
                ECL = #val(ps.AD)+val(ps1.ECL)#,
                RS = #val(ps.RS)+val(ps1.RS)#,
				EX = #val(ps.Ex)+val(ps1.Ex)#,
				LS = #val(ps.LS)+val(ps1.LS)#,
				OPL = #val(ps.OPL)+val(ps1.OPL)#,
				NPL = #val(ps.NPL)+val(ps1.NPL)#,
				AB = #val(ps.AB)+val(ps1.AB)#,
				ONPL = #val(ps.ONPL)+val(ps1.ONPL)#,
				WORKHR = #val(ps.WORKHR)+val(ps1.WORKHR)#,
				LATEHR = #val(ps.LATEHR)+val(ps1.LATEHR)#,
				EARLYHR = #val(ps.EARLYHR)+val(ps1.EARLYHR)#,
		        NOPAYHR = #val(ps.NOPAYHR)+val(ps1.NOPAYHR)#,
		        HR1 = #val(ps.HR1)+val(ps1.HR1)#,
		        HR2 = #val(ps.HR2)+val(ps1.HR2)#,
		        HR3 = #val(ps.HR3)+val(ps1.HR3)#,
		        HR4 = #val(ps.HR4)+val(ps1.HR4)#,
		        HR5 = #val(ps.HR5)+val(ps1.HR5)#,
		        HR6 = #val(ps.HR6)+val(ps1.HR6)#,
		        BASICPAY = #val(ps.BASICPAY)+val(ps1.BASICPAY)#,
				OTPAY = #val(ps.OTPAY)+val(ps1.OTPAY)#,
		        DIRFEE = #val(ps.DIRFEE)+val(ps1.DIRFEE)#,
		        TAW = #val(ps.TAW)+val(ps1.TAW)#,
		        GROSSPAY = #val(ps.GROSSPAY)+val(ps1.GROSSPAY)#,
		        TDEDU = #val(ps.TDEDU)+val(ps1.TDEDU)#,
		        TDED = #val(ps.TDED)+val(ps1.TDED)#,
		        NETPAY = #val(ps.NETPAY)+val(ps1.NETPAY)#,
		        NPLPAY = #val(ps.NPLPAY)+val(ps1.NPLPAY)#,
		        TXAW = #val(ps.TXAW)+val(ps1.TXAW)#,
		        TXDED = #val(ps.TXDED)+val(ps1.TXDED)#,
		        OT1 = #val(ps.OT1)+val(ps1.OT1)#,
		        OT2 = #val(ps.OT2)+val(ps1.OT2)#,
		        OT3 = #val(ps.OT3)+val(ps1.OT3)#,
		        OT4 = #val(ps.OT4)+val(ps1.OT4)#,
		        OT5 = #val(ps.OT5)+val(ps1.OT5)#,
		        OT6 = #val(ps.OT6)+val(ps1.OT6)#,
		        AW101 = #val(ps.AW101)+val(ps1.AW101)#,
		        AW102 = #val(ps.AW102)+val(ps1.AW102)#,
		        AW103 = #val(ps.AW103)+val(ps1.AW103)#,
		        AW104 = #val(ps.AW104)+val(ps1.AW104)#,
		        AW105 = #val(ps.AW105)+val(ps1.AW105)#,
		        AW106 = #val(ps.AW106)+val(ps1.AW106)#,
		        AW107 = #val(ps.AW107)+val(ps1.AW107)#,
		        AW108 = #val(ps.AW108)+val(ps1.AW108)#,
		        AW109 = #val(ps.AW109)+val(ps1.AW109)#,
		        AW110 = #val(ps.AW110)+val(ps1.AW110)#,
		        AW111 = #val(ps.AW111)+val(ps1.AW111)#,
		        AW112 = #val(ps.AW112)+val(ps1.AW112)#,
		        AW113 = #val(ps.AW113)+val(ps1.AW113)#,
		        AW114 = #val(ps.AW114)+val(ps1.AW114)#,
		        AW115 = #val(ps.AW115)+val(ps1.AW115)#,
		        AW116 = #val(ps.AW116)+val(ps1.AW116)#,
		        AW117 = #val(ps.AW117)+val(ps1.AW117)#,
		        DED101 = #val(ps.DED101)+val(ps1.DED101)#,
		        DED102 = #val(ps.DED102)+val(ps1.DED102)#,
		        DED103 = #val(ps.DED103)+val(ps1.DED103)#,
		        DED104 = #val(ps.DED104)+val(ps1.DED104)#,
		        DED105 = #val(ps.DED105)+val(ps1.DED105)#,
		        DED106 = #val(ps.DED106)+val(ps1.DED106)#,
		        DED107 = #val(ps.DED107)+val(ps1.DED107)#,
		        DED108 = #val(ps.DED108)+val(ps1.DED108)#,
		        DED109 = #val(ps.DED109)+val(ps1.DED109)#,
		        DED110 = #val(ps.DED110)+val(ps1.DED110)#,
		        DED111 = #val(ps.DED111)+val(ps1.DED111)#,
		        DED112 = #val(ps.DED112)+val(ps1.DED112)#,
		        DED113 = #val(ps.DED113)+val(ps1.DED113)#,
		        DED114 = #val(ps.DED114)+val(ps1.DED114)#,
		        DED115 = #val(ps.DED115)+val(ps1.DED115)#,
		        ADVANCE = #val(ps.ADVANCE)+val(ps1.ADVANCE)#,
		        ITAXPCB = #val(ps.ITAXPCB)+val(ps1.ITAXPCB)#,
		        ITAXPCBADJ = #val(ps.ITAXPCBADJ)+val(ps1.ITAXPCBADJ)#,
		        EPFWW = #val(ps.EPFWW)+val(ps1.EPFWW)#,
		        EPFCC = #val(ps.EPFCC)+val(ps1.EPFCC)#,
		        EPFWWEXT = #val(ps.EPFWWEXT)+val(ps1.EPFWWEXT)#,
		        EPFCCEXT = #val(ps.EPFCCEXT)+val(ps1.EPFCCEXT)#,
		        EPGCC = #val(ps.EPGCC)+val(ps1.EPGCC)#,
		        SOASOWW = #val(ps.SOASOWW)+val(ps1.SOASOWW)#,
		        SOASOCC = #val(ps.SOASOCC)+val(ps1.SOASOCC)#,
		        SOBSOWW = #val(ps.SOBSOWW)+val(ps1.SOBSOWW)#,
		        SOBSOCC = #val(ps.SOBSOCC)+val(ps1.SOBSOCC)#,
		        SOCSOWW = #val(ps.SOCSOWW)+val(ps1.SOCSOWW)#,
		        SOCSOCC = #val(ps.SOCSOCC)+val(ps1.SOCSOCC)#,
		        SODSOWW = #val(ps.SODSOWW)+val(ps1.SODSOWW)#,
		        SODSOCC = #val(ps.SODSOCC)+val(ps1.SODSOCC)#,
		        SOESOWW = #val(ps.SOESOWW)+val(ps1.SOESOWW)#,
		        SOESOCC = #val(ps.SOESOCC)+val(ps1.SOESOCC)#,
		        CCSTAT1 = #val(ps.CCSTAT1)+val(ps1.CCSTAT1)#,
		        PENCEN = #val(ps.PENCEN)+val(ps1.PENCEN)#,
		        MFUND = #val(ps.MFUND)+val(ps1.MFUND)#,
		        DFUND = #val(ps.DFUND)+val(ps1.DFUND)#,
		        EPF_PAY = #val(ps.EPF_PAY)+val(ps1.EPF_PAY)#,
		        EPF_PAY_A = #val(ps.EPF_PAY_A)+val(ps1.EPF_PAY_A)#,
				cpf_amt = #val(ps.cpf_amt)# + #val(ps1.cpf_amt)#,
				re_cpf_all= #val(ps.EPF_PAY)+val(ps1.EPF_PAY)#+coalesce(B_epfww,0)+coalesce(B_epfcc,0)+coalesce(c_epfww,0)+coalesce(c_epfcc,0),
		        PAYYES = "Y",
                additionalwages=#val(ps.additionalwages)+val(ps1.additionalwages)#
		  	WHERE empno = "#empno#"
        </cfquery>
		
		<cfreturn "update">
	</cffunction>
</cfcomponent>