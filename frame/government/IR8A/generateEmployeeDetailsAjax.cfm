
<cfcontent type="text/html" reset="true"/>
<cfquery name="getgsetup" datasource="payroll_main">
SELECT myear FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>


<cfquery name="getList_qry" datasource="#dts#">
SELECT * FROM pmast AS a LEFT JOIN itaxea AS b ON a.empno=b.empno
WHERE 0=0
	<cfif url.empnoFrom neq ""> AND a.empno >= '#url.empnoFrom#' </cfif>
	<cfif url.empnoTo neq ""> AND a.empno <= '#url.empnoTo#' </cfif>
	order by a.empno
</cfquery>


<cfquery name="getTransAW" datasource="#dts#">
	SELECT AW_COU from awtable where AW_NOTE = "TRANS" AND AW_TAX = 1
</cfquery>

<cfquery name="getEntAW" datasource="#dts#">
	SELECT AW_COU from awtable where AW_NOTE = "ENTNM" AND AW_TAX = 1
</cfquery>

<cfquery name="getCommAW" datasource="#dts#">
	SELECT AW_COU from awtable where AW_NOTE = "COMM" AND AW_TAX = 1
</cfquery>

<cfquery name="getGrossAW" datasource="#dts#">
	SELECT AW_COU from awtable where AW_NOTE = "GROSS" AND AW_TAX = 1
</cfquery>

<cfquery name="getbonusAW" datasource="#dts#">
	SELECT AW_COU from awtable where AW_NOTE = "BONUS" AND AW_TAX = 1
</cfquery>

<cfset transSql = "">
<cfif getTransAW.recordcount neq 0>
<cfloop query="getTransAW">
	<cfset transAtt = 100 + getTransAW.aw_cou>
	<cfset transSql = transSql&"AW"&transAtt>
<cfif gettransaw.currentrow neq gettransaw.recordcount>
<cfset transSQL = transSQL&"+">
</cfif>
</cfloop>
</cfif>

<cfset entSql = "">
<cfif getEntAW.recordcount neq 0>
<cfloop query="getEntAW">
	<cfset entAtt = 100 + getEntAW.aw_cou>
	<cfset entSql = entSql&"AW"&entAtt>
<cfif getEntAW.currentrow neq getEntAW.recordcount>
<cfset entSql = entSql&"+">
</cfif>	
</cfloop>
</cfif>

<cfset commSql = "">
<cfif getCommAW.recordcount neq 0>
<cfloop query="getCommAW">
	<cfset commAtt = 100 + getCommAW.aw_cou>
	<cfset commSql = commSql&"AW"&commAtt>
<cfif getCommAW.currentrow neq getCommAW.recordcount>
<cfset commSql = commSql&"+">
</cfif>	
</cfloop>    
</cfif>

<cfset grossSql = "">
<cfif getGrossAW.recordcount neq 0>
<cfloop query="getGrossAW">
	<cfset grossAtt = 100 + getGrossAW.aw_cou>
	<cfset grossSql = grossSql&"AW"&grossAtt>
<cfif getGrossAW.currentrow neq getGrossAW.recordcount>
<cfset grossSql = grossSql&"+">
</cfif>	
</cfloop>
</cfif>

<cfset bonusSql = "">
<cfif getBonusAW.recordcount neq 0>
<cfloop query="getbonusAW">
	<cfset bonusAtt = 100 + getbonusAW.aw_cou>
	<cfset bonusSql = bonusSql&"AW"&bonusAtt>
<cfif getbonusAW.currentrow neq getbonusAW.recordcount>
<cfset bonusSql = bonusSql&"+">
</cfif>	
</cfloop>
</cfif>

<cfset awSQL = "">
<cfloop from="1" to="17" index="i">
	
		
		<cfquery name="awtax" datasource="#dts#">
			select aw_tax,AW_NOTE from awtable where aw_cou = #i#
		</cfquery>
		<cfif awtax.aw_tax eq 1 and trim(awtax.AW_NOTE) eq "">	
		<cfset awAtt = 100 + i>
		<cfset awSQL = awSQL&"AW"&awAtt&"+">
		</cfif>

</cfloop>

<cfset lengthaw = len(awSQL)>
<cfset awSQL = left(awSQL,lengthaw - 1)>

<cfset dedSQL = "">
<cfloop from="9" to="15" index="i">
	<cfset dedAtt = 100 + i>
	<cfif dedAtt neq 111 and dedAtt neq 112 >
		<cfset dedSQL = dedSQL&"DED"&dedAtt&"+">
	</cfif>
</cfloop>

<cfquery name="getded" datasource="#dts#">
SELECT ded_COU from dedtable where ded_TAX = 1 and ded_cou < 9
</cfquery>
<cfset dedtax = "">
<cfif getded.recordcount neq 0>
<cfloop query="getded">
<cfset dedtaxvar = 100 + getded.ded_cou>
	<cfset dedtax = dedtax&"ded"&dedtaxvar>
<cfif getded.currentrow neq getded.recordcount>
<cfset dedtax = dedtax&"+">
</cfif>	
</cfloop>
</cfif>

<cfset lengthded = len(dedSQL)>
<cfset dedSQL = left(dedSQL,lengthded - 1)>
<cfset v = 0>	
<cfloop query="getList_qry">
	
		<cfquery name="sum_all" datasource="#dts#">
			 SELECT (sum(grosspay)-sum(taw)-sum(dirfee)<cfif dedtax neq "">-sum(#dedtax#)</cfif>) as basicpay,
				<cfif getTransAW.aw_cou neq ""> sum(#transSql#) as transsql,</cfif>
				<cfif getEntAW.aw_cou neq "">sum(#entSql#) as entsql,</cfif>
				<cfif getCommAW.aw_cou neq "">sum(#commSql#) as commsql,</cfif>
				<cfif getGrossAW.aw_cou neq "">sum(#grossSql#) as grossSql,</cfif>
                <cfif getbonusAW.aw_cou neq "">sum(#bonusSql#) as bonusSql,</cfif>
				sum(#awSQL#) as sumOtherAW, sum(#dedSQL#) as sumOtherDED,
				sum(ded111) as sumMBFB,
				sum(dirfee) as dirfee,sum(bonus) as bonus, sum(comm) as comm , 
				sum(taw) as taw , sum(floor(EPFWW)+floor(epfwwext)) as EPFWW, sum(coalesce(OTpay,0)) as otpay
			from pay_12m where empno = "#getList_qry.empno#"
		</cfquery>
		
		<cfset sumallw = 0 >
		
		<cfif getEntAW.aw_cou neq "">
		<cfset sumallw = val(sumallw) + #val(sum_all.entSql)#>
		</cfif>
		
		<cfif getTransAW.aw_cou neq "">
		<cfset sumallw = val(sumallw) + #val(sum_all.transSql)#>
		</cfif>
		
		<cfif HcomID neq "cstct11"> 
		 <cfset sumallw = val(sumallw) + #val(sum_all.sumOtherAW)# >
		</cfif>
		
		<cfif getCommAW.aw_cou neq "">
			<cfset sum_commaw = #val(sum_all.commSql)#>
		<cfelse>
			<cfset sum_commaw = 0>
		</cfif>
		
		<cfif getGrossAW.aw_cou neq "">
			<cfset sum_grossaw = #val(sum_all.grossSql)#>
		<cfelse>
			<cfset sum_grossaw = 0>
		</cfif>
        
        <cfif getbonusAW.aw_cou neq "">
			<cfset sum_bonusaw = #val(sum_all.bonusSql)#>
		<cfelse>
			<cfset sum_bonusaw = 0>
		</cfif>
        
        <cfif (numberformat(val(sum_all.comm) + val(sum_commaw),'.__')) gt 0>
        <cfif getList_qry.EATXT5 eq "">
        <cfset commstartdate = createdate(getgsetup.myear,'1','1')>
        <cfelse>
        <cfset commstartdate = getList_qry.EATXT5>
        </cfif>
        <cfif getList_qry.EATXT6 eq "">
        <cfset commenddate = createdate(getgsetup.myear,'12','31')>
        <cfelse>
        <cfset commenddate = getList_qry.EATXT6>
        </cfif>
			<cfif getList_qry.dcomm neq "">
				<cfif dateformat(getList_qry.dcomm,'YYYY') gte dateformat(commstartdate,'YYYY')>
                <cfset commstartdate = getList_qry.dcomm>
                </cfif>
            </cfif>
            <cfif getList_qry.dresign neq "">
            	<cfif dateformat(getList_qry.dresign,'YYYY') eq dateformat(commenddate,'yyyy')>
                <cfset commenddate = getList_qry.dresign>
                </cfif>
			</cfif>
        </cfif>
		
        <cfset total4 = val(getList_qry.ecfig05) + val(getList_qry.ecfig07)  + val(getList_qry.ecfig08) + val(getList_qry.ecfig09)>
        
		<cfquery name="employeeUpdate" datasource="#dts#" >
			UPDATE itaxea
			SET	
            	eafig04 = "#numberformat(total4,'.__')#",
				ea_basic = #numberformat(val(sum_all.basicpay) + val(sum_grossaw),'.__')#,
				EA_OT = #numberformat(sum_all.otpay,'.__')#,
				ea_bonus = #numberformat(val(sum_all.bonus)+val(sum_bonusaw),'.__')#,
				ea_comm = #numberformat(val(sum_all.comm) + val(sum_commaw),'.__')#,
				ea_dirf = #numberformat(sum_all.dirfee,'.__')#,
				<cfif getTransAW.aw_cou neq "">
					ea_aw_t = #numberformat(sum_all.transSql,'.__')#,
				<cfelse>
					ea_aw_t = 0.00,
				</cfif>
				
				<cfif getEntAW.aw_cou neq "">
					ea_aw_e = #numberformat(sum_all.entSql,'.__')#,
				<cfelse>
					ea_aw_e = 0.00,
				</cfif>
				
				<cfif HcomID neq "cstct11">
				ea_aw_o = #numberformat(sum_all.sumOtherAW,'.__')#,
				<cfelse>
				ea_aw_o = 0.00,	
				</cfif>	
				ea_aw = #numberformat(sumallw,'.__')#,
	<!----		ea_aw = #numberformat(sum_all.tAW,'.__')#, ----------->
				ea_ded = #numberformat(sum_all.sumOtherDED,'.__')#,
				ea_epf = #numberformat(sum_all.EPFWW,'.__')#,
				EAFIG15 = #numberformat(sum_all.sumMBFB,'.__')#,
				EATXT9 = "CENTRAL PROVIDENT FUND BOARD",
				EX_70 =	"CENTRAL PROVIDENT FUND BOARD"
                <cfif (numberformat(val(sum_all.comm) + val(sum_commaw),'.__')) gt 0>
                ,EATXT5 = "#dateformat(commstartdate,'YYYY-MM-DD')#"
                ,EATXT6 = "#dateformat(commenddate,'YYYY-MM-DD')#"
                ,PBAYARAN = "B"
				</cfif>				
			WHERE
				empno = "#getList_qry.empno#"
		</cfquery>
	<cfset v = v + 1>
    
    <cfif left(dts,4) eq "beps">
    <cfquery name="getlatestplacement" datasource="#replace(dts,'_p','_i')#">
    SELECT position FROM placement WHERE empno = "#getList_qry.empno#"
    </cfquery>
    
    <cfif getlatestplacement.recordcount neq 0>
    <cfif getlatestplacement.position neq "">
    <cfquery name="updatejobtitle" datasource="#dts#">
    UPDATE pmast SET jtitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getlatestplacement.position#"> WHERE empno = "#getList_qry.empno#"
    </cfquery>
    </cfif>
    </cfif>
    
	</cfif>
</cfloop>
<!---  ---><cfoutput>
<table id="tbl" align="center">
<tr><td align="center"> #v# employees Details have been Generated.</td></tr>

<tr><td><br  /><br  /></td></tr>
<tr><td align="center"><input type="button" onclick="javascript:ColdFusion.Window.hide('generateEmployeeDetails');" value="Close" /></td></tr>
</table>

</cfoutput>
