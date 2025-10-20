<link rel="shortcut icon" href="/PMS.ico" />
<link href="/stylesheet/report.css" rel="stylesheet" type="text/css" />
<cfquery name="selectList" datasource="#dsname#">
SELECT p.empno FROM pay_12m p, pmast pm
LEFT JOIN emp_users as ep ON pm.empno = ep.empno
WHERE p.empno = pm.empno 
and pm.paystatus = "A"
AND tmonth = "#form.month1#"
AND ep.username = "#HUserID#"  
</cfquery>

<cfset OTlist = ArrayNew(1)>
<cfset OTtype = ArrayNew(1)>
<cfloop from="1" to="6" index="i">
<cfquery name="getOt_qry" datasource="#dsname#">
SELECT * From Ottable Where OT_COU=#i#
</cfquery>
<cfset ArrayAppend(OTlist, "#getOt_qry.OT_DESP#")>
<cfset ArrayAppend(OTtype, "#getOt_qry.OT_UNIT#")>
</cfloop>

<cfquery name="aw_qry" datasource="#dsname#">
SELECT aw_cou,aw_desp FROM awtable
where aw_cou < 18
</cfquery>

<cfquery name="ded_qry" datasource="#dsname#">
SELECT ded_cou,ded_desp FROM dedtable
</cfquery>

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = #form.month1#>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset iii = 0>
<!---<cfset db_select = "pay_12m" >--->
<!--- <cfif paytype eq "1">
<cfset db_select = "form_" >
<cfelseif paytype eq "2">
<cfset db_select = "pay_12m" >
</cfif> --->
<cfloop query="selectList">
<cfquery name="select_data" datasource="#dsname#">
SELECT * FROM pay_12m AS db LEFT JOIN pmast AS pm ON db.empno = pm.empno WHERE db.empno = "#selectList.empno#" and db.tmonth = #form.month1#
</cfquery>

    <cfif val(select_data.epfwwext) eq 0>
            <cfset select_data.epfww = int(val(select_data.epfww))>
            <cfset select_data.epfcc = round(val(select_data.epfcc))>
	</cfif>

<cfoutput>
<p <cfif iii neq 0 >style="page-break-after:always" <cfelse> <cfset iii = iii + 1 ></cfif> >
<table width="1000px" border="0">
<tr>
<th align="left">#company_details.comp_name#</th>
<th align="center" style="text-transform:uppercase"><cfif form.paytype eq "pay1_12m_fig">1ST<cfelseif form.paytype eq "pay2_12m_fig" >2ND</cfif> HALF PAYROLL-#DATEFORMAT(date,'MMMM YYYY')#</th>
<th align="right">
<cfinvoke component="cfc.data_represent" method="paytype" pay="#select_data.payrtype#" returnvariable="pay_type" />
#pay_type#&nbsp;/&nbsp;
<cfinvoke component="cfc.data_represent" method="paymeth" pay_method="#select_data.paymeth#" returnvariable="pay_meth" />
#pay_meth#
</th>
</tr>
<tr>
  <td align="left">&nbsp;</td>
  <td align="center">&nbsp;</td>
  <td align="right"></td>
</tr>
</table>
<table width="1000px" border="0">
<tr>
<td width="500px" valign="top">
<table width="450px" border="0">
<tr>
<td width="180px">EMPLOYEE / LINE NO</td>
<td width="10px">:</td>
<td width="65px">#select_data.empno#</td>
<td width="195px" align="right">&nbsp;</td>
</tr>
<tr>
  <td>CATEGORY</td>
  <td>:</td>
  <td>#select_data.category#</td>
  <td align="right">&nbsp;</td>
</tr>
<tr >
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td align="right">&nbsp;</td>
</tr>
<tr>
  <td>BASIC RATE</td>
  <td>:</td>
  <td>&nbsp;</td>
  <td align="right">#select_data.brate#</td>
</tr>
<tr>

  <td>WORKING DAYS</td>
  <td>:</td>
  <td>&nbsp;</td>
  <td align="right">#select_data.WDAY#</td>
</tr>
<tr>
  <td colspan="4"><hr /></td>
  </tr>
<tr>
  <td colspan="4">
  <table>
  <tr >
  <cfloop list="DW,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD" index="i">
  <cfset data_list = #evaluate("select_data.#i#")#>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#i#</td>
  </cfoutput>
  </cfif>
  </cfloop>
  <cfset data_list = select_data.OPL>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#select_data.OPL#</td>
  </cfoutput>
  </cfif>
  </tr>
  <tr>
  <cfloop list="DW,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL" index="i">
  <cfset data_list = #evaluate("select_data.#i#")#>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#evaluate("select_data.#i#")#</td>
  </cfoutput>
  </cfif>
  </cfloop>
  </tr>
    <tr>
  <cfloop list="LS,NPL,AB" index="i">
  <cfset data_list = #evaluate("select_data.#i#")#>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#i#</td>
  </cfoutput>
  </cfif>
  </cfloop>
  <cfset data_list = select_data.ONPL>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#select_data.ONPL#</td>
  </cfoutput>
  </cfif>
  </tr>
  <tr>
  <cfloop list="LS,NPL,AB,ONPL" index="i">
  <cfset data_list = #evaluate("select_data.#i#")#>
  <cfif data_list gt 0>
  <cfoutput>
  <td width="37.5Px">#evaluate("select_data.#i#")#</td>
  </cfoutput>
  </cfif>
  </cfloop>
  </tr>
  </table>  </td>
</tr>
<tr>
  <td colspan="4"><hr /></td>
</tr>
<tr>
  <td colspan="4">&nbsp;</td>
</tr>
<tr>
<td width="180px">BASIC PAY</td>
<td width="10px">&nbsp;</td>
<td width="65px" align="right">:</td>
<td width="195px" align="right">#select_data.basicpay#</td>
</tr>
<cfif val(select_data.bonus) neq 0>
<tr>
  <td>BONUS</td>
  <td>&nbsp;</td>
  <td align="right">:</td>
  <td align="right">#numberformat(select_data.bonus,'.__')#</td>
</tr>
</cfif>
<tr>
  <td>DIRECTOR FEE</td>
  <td>&nbsp;</td>
  <td align="right">:</td>
  <td align="right">#select_data.DIRFEE#</td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td align="right">&nbsp;</td>
  <td align="right">&nbsp;</td>
</tr>
<tr>
  <td colspan="4">
 
  </td>
</tr>
</table>
</td>
<td width="500px" valign="top">
<table width="500px" border="0">
<tr>
<td width="100px">NAME</td>
<td width="10px">:</td>
<td>#select_data.name#</td>
</tr>
<tr>
  <td>IC NO.</td>
  <td>:</td>
  <td>#select_data.nricn#</td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
<tr>
  <td colspan="3">
  <table width="500px">
  <tr>
  <td width="150px">ALLOWANCE</td>
  <td width="92px"></td>
  <td width="15px"></td>
  <td width="150px">DEDUCTION</td>
  <td width="93px"></td>
  </tr>
  <tr>
    <td colspan="2"><hr /></td>
    <td></td>
    <td colspan="2"><hr /></td>
  </tr>
  <cfset j=1>
  <cfloop query="aw_qry">
  <cfset aw_data = #select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1]#>
  <cfif #aw_qry.currentrow# lt 16>
  <cfset ded_data = #select_data['ded1#numberformat(aw_qry.currentrow,"00")#'][1]#>
  </cfif>
  
    <tr>
      <cfif aw_data gt 0>
    
        <td>#aw_qry.aw_desp#</td>
        <td align="right">#select_data['aw1#numberformat(aw_qry.currentrow,"00")#'][1]#</td> 
        <cfelse>
        <td></td>
        <td></td>
        </cfif>
        <td></td>
       
       <cfif ded_data gt 0 and aw_qry.currentrow lt 16>
        <td>#ded_qry['ded_desp'][j]#</td>
        <td align="right">#ded_data#</td>
        <cfelse>
        <td></td>
        <td></td>
        </cfif>
    </tr>  
    
  <cfset j = j + 1>
  </cfloop>
  <cfif #select_data.advance# gt 0>
  <tr><td>Advance</td><td>#numberformat(select_data.advance,'.__')# </td></tr>
  </cfif>
  
  
  </table>
  </td>

  
</tr>

</table>
</td>
</tr>
<tr>
<td width="450px" valign="top">
<table width="450px" border="0">
<tr>
<td width="180px">OVERTIME</td>
<td width="100px">RATE</td>
<td width="70px">HRS/DAYS</td>
<td width="100px" align="right">AMOUNT</td>
</tr>
<tr>
  <td colspan="4"><hr /></td>
</tr>
<cfloop from="1" to="6" index="i">
<cfset ot_amt = #evaluate("select_data.Ot#i#")# >
<cfif ot_amt gt 0>
<tr>
<td width="180px">#OTLIST[i]#</td>
<td width="100px">#evaluate("select_data.rate#i#")#</td>
<td width="70px">#evaluate("select_data.hr#i#")#&nbsp;#OTTYPE[i]#</td>
<td width="100px" align="right">#evaluate("select_data.Ot#i#")#</td>
</tr>
</cfif>
</cfloop>
</table>
</td>
<td width="500px" valign="top">
<table width="500px" border="0">
<tr>
  <td width="170px">&nbsp;</td>
  <td width="82px">&nbsp;</td>
  <td width="15px">&nbsp;</td>
  <td width="150px">&nbsp;</td>
  <td width="93px">&nbsp;</td>
</tr>
<tr>
<td colspan="2"><hr /></td>
<td></td>
<td colspan="2"><hr /></td>
</tr>
<tr>
  <td width="170px">MONTHLY GROSS</td>
  <td width="82px">#select_data.GROSSPAY#</td>
  <td colspan="3">&nbsp;</td>
</tr>
<tr>
  <cfif company_details.ccode eq "MY">
  <td>EPF' YER</td>
  <cfelse>
  <td>CPF' YER</td>
  </cfif>
  <td>#numberformat(select_data.epfcc,'.__')#</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
<tr>
  <td><cfif company_details.ccode eq 'MY'>SOCSO' YER</cfif></td>
  <td><cfif company_details.ccode eq 'MY'>#numberformat(select_data.socsocc,'.__')#</cfif></td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>YTD AL</td>
  <td>#numberformat(0,'.__')#</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>YTD MC</td>
  <td>#numberformat(0,'.__')#</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
<tr>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
</tr>
</table>

</td>
</tr>
<tr>
<td colspan="3">
<table>
<tr>
<td width="90px">BASIC PAY</td>
<td width="130px">DIRECTOR FEE</td>
<td width="90px">OVERTIME</td>
<td width="90px">ALLOWANCE</td>
<td width="90px">GROSS PAY</td>
<cfif val(select_data.bonus) neq 0>
<td width="90px">BONUS</td>
</cfif> 
<td width="90px">DEDUCTION</td>
<cfif company_details.ccode eq "MY">
<td width="50px">EPF</td>
<cfelse>
<td width="50px">CPF</td>
</cfif>
<td width="90px"><cfif company_details.ccode eq 'MY'>SOCSO</cfif></td>
<td width="90px">NETT</td>
<td width="10px"></td>
<td width="180px">&nbsp;</td>
</tr>
<tr>
  <td colspan="10"><hr /></td>
  <td></td>
  <td><hr /></td>

</tr>
<tr>
<td width="90px">#numberformat(select_data.basicpay,'.__')#</td>
<td width="130px">#numberformat(select_data.dirfee,'.__')#</td>
<td width="90px">#numberformat(select_data.otpay,'.__')#</td>
<td width="90px">#numberformat(select_data.taw,'.__')#</td>
<td width="90px">#numberformat(select_data.grosspay,'.__')#</td>
<cfif val(select_data.bonus) neq 0>
<td width="90px">#numberformat(val(select_data.bonus),'.__')#</td>
<cfquery name="getbonus" datasource="#dsname#">
SELECT netpay FROM bonu_12m WHERE empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#select_data.empno#"> and tmonth = "#form.month1#" 
</cfquery>
<cfset select_data.netpay = val(select_data.netpay) + val(getbonus.netpay)>
</cfif> 
<td width="90px">#numberformat(select_data.tded,'.__')#</td>
<td width="50px">#numberformat(select_data.epfww,'.__')#</td>
<td width="90px"><cfif company_details.ccode eq 'MY'>#numberformat(select_data.socsoww,'.__')#</cfif></td>
<td width="90px">#numberformat(select_data.netpay,'.__')#</td>
<td width="10px"></td>
<td width="180px">EMPLOYEE's SIGNATURE</td>
</tr>
</table>
</td >
</tr>
</table>
</p>
<br />
<br />
<br />
</cfoutput>
</cfloop>

<!---<cfquery name="selectList" datasource="#dsname#">
SELECT p.empno FROM pay_12m p, pmast pm
LEFT JOIN emp_users as ep ON pm.empno = ep.empno
WHERE p.empno = pm.empno 
and pm.paystatus = "A"
AND tmonth = "#form.month1#"
AND ep.username = "#HUserID#"  
</cfquery>


<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>
<cfset psdate = dateformat(createdate(yrs,#form.month1#,daysinmonth(createdate(yrs,#form.month1#,1))),'DD/MM/YYYY')>
<title>Bonus Pay Slip</title><cfoutput>
<cfloop query="selectList">
	<cfquery name="select_data" datasource="#dsname#">
	SELECT * FROM extr_12m AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = "#selectList.empno#" 
    AND tmonth = '#form.month1#'
	</cfquery>
	
	<cfquery name="select_netpay" datasource="#dsname#">
	SELECT * FROM pay_12m WHERE empno = "#selectList.empno#" AND tmonth = '#form.month1#'
	</cfquery>
	
	<cfquery name="select_bonus" datasource="#dsname#">
	SELECT * FROM bonu_12m WHERE empno = "#selectList.empno#" AND tmonth = '#form.month1#'
	</cfquery>
	
	<cfquery name="select_comm" datasource="#dsname#">
	SELECT * FROM comm_12m WHERE empno = "#selectList.empno#" AND tmonth = '#form.month1#'
	</cfquery>
	
	<cfquery name="select_cheque_no" datasource="#dsname#">
	select cheque_no from hbce_12m WHERE empno = "#selectList.empno#" AND tmonth = '#form.month1#'
	</cfquery>
	
	<cfset totalpay = #val(select_netpay.netpay)# + #val(select_data.basicpay)# + #val(select_bonus.netpay)# + #val(select_comm.netpay)#>
	
	<cfif totalpay gt 0>
	<p style="page-break-after:always">
	<table width="800px">
		<tr>
		<th width="400px" align="left">#company_details.comp_name#</th>
		<th width="400px" align="left">Bonus Pay Slip [#DATEFORMAT(psdate,'MMMM YYYY')#]</th>
		
		</tr>
		<tr>
			<td></td>
			<td></td>
		</tr>
		<tr>
		<td valign="top">
			<table width="400px">
				<tr>
				<td width="100px">NAME</td>
				<td width="10px">:</td>
				<td width="200px">#select_data.name#</td>
				</tr>
				<tr><td colspan="3"></td></tr>
				<tr>
				<td width="200px">PAY RATE TYPE</td>
				<td width="10px">:</td>
				<td width="200px"><cfinvoke component="cfc.data_represent" method="paytype" pay="#select_data.payrtype#" returnvariable="pay_type" />
				#pay_type#</td>
				</tr>
				<tr>
				<td width="200px">PAY METHOD</td>
				<td width="10px">:</td>
				<td width="200px"><cfinvoke component="cfc.data_represent" method="paymeth" pay_method="#select_data.paymeth#" returnvariable="pay_meth" />
				#pay_meth#</td>
				</tr>
				
				
				
				<cfif #select_data.paymeth# eq "Q">
				<tr>
				  <td>CHEQUE NUMBER</td>
				  <td>:</td>
				  <td>#select_cheque_no.CHEQUE_NO#</td>
				</tr>
				</cfif>
				
				<cfif isdefined("form.commence")>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				</tr>
				<tr>
				  <td>DATE COMMENCE</td>
				  <td>:</td>
				  <td>#dateformat(select_data.dcomm,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
				  <td>DATE CONFIRM</td>
				  <td>:</td>
				  <td>#dateformat(select_data.dconfirm,'dd/mm/yyyy')#</td>
				</tr>
				</cfif>
				<tr>
					<td colspan="3">&nbsp</td></tr>
				<tr>
					<td colspan="3">&nbsp</td></tr>
				<tr>
					<td align=""><cfif company_details.ccode eq 'SG'>C<cfelse>E</cfif>PF EMPLOYER</td>
					<td>:</td>
					<cfset totalcpf_yer =#val(select_netpay.epfcc)#+#val(select_data.epfcc)#+#val(select_bonus.epfcc)#+#val(select_comm.epfcc)#>
					<td >#numberformat(totalcpf_yer,'.__')#</td>
				</tr>
				<tr>
					<td align=""><cfif company_details.ccode eq 'SG'>C<cfelse>E</cfif>PF EMPLOYEE</td>
					<td>:</td>
					<cfset totalcpf = #val(select_netpay.epfww)#+#val(select_data.epfww)#+#val(select_bonus.epfww)#+#val(select_comm.epfww)#>
					<td >#numberformat(totalcpf,'.__')#</td>
				</tr>
			</table>
		</td>
		<td align="right">
			<table width="400px" align="right">
				<tr>
					<td width="200px">PAY SLIP DATE</td>
					<td width="10px">:</td>
					<td width="100px">#psdate#</td>
				</tr>
				<tr>
					<td colspan="3"></td></tr>
				<tr>
					<td width="200px">EMPLOYEE NO.</td>
					<td width="10px">:</td>
					<td width="100px">#select_data.empno#</td>
				</tr>
				<tr>
					<td width="200px">LINE NO.</td>
					<td width="10px">:</td>
					<td width="100px">#select_data.plineno#</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp</td>
				</tr>
				<tr>
					<td width="200px">NET PAY</td>
					<td width="10px">:</td>
					<td align="right">#numberformat(select_netpay.netpay,'.__')#</td>
				</tr>
				
				<!--- <td width="200px">CPF EMPLOYEE</td>
				<td width="10px">:</td>
				<td width="100px"></td>
				<td>#numberformat(select_netpay.epfww,'.__')#</td>
				</tr> ---> 
				<tr>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td>EXTRA</td>
					<td>:</td>
					<td align="right">#numberformat(select_data.basicpay,'.__')#</td>
				</tr>
				<tr>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td>BONUS</td>
					<td>:</td>
					<td align="right">#numberformat(select_bonus.netpay,'.__')#</td>
				</tr>
				
				<tr>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td>COMMISSION</td>
					<td>:</td>
					<td align="right">#numberformat(select_comm.netpay,'.__')#</td>
				</tr>
				
				<tr>
					<td colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td><hr /></td>
				</tr>
				<tr>
					<td>Total</td>
					<td>:</td>
					<cfset totalpay = #val(select_netpay.netpay)# + #val(select_data.basicpay)# + #val(select_bonus.netpay)# + #val(select_comm.netpay)#>
					<td align="right">#numberformat(totalpay,'.__')#</td>					
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td><hr/></td>
				</tr>	
							
			</table>
	</td>
	
	</tr>
	
	<tr>
		
		<td width="400px" align="center">
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		

		</td>
		<td align="right">
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		_______________________<br />
			EMPLOYEE'S SIGNATURE
		</td>
	</tr>
	
	</table>
	</p>
	</cfif>
	<br />
	<br />
	<br />
	<br />
	<br />
</cfloop>
</cfoutput>--->