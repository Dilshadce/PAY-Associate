<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=printPaySlip.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
        <cfinclude template="printpayslipprocess.cfm">
<cfoutput>
<cfdocumentitem type="footer">
	<font size="2">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</font>
</cfdocumentitem>
</cfoutput>
</body>
</html>
</cfdocument>


<!---<cfheader name="Content-Type" value="pdf">
<cfheader name="Content-Disposition" value="attachment; filename=printPaySlip.pdf">

<cfdocument format="pdf" backgroundvisible="no" pagetype="A4" scale="100">
<html>
<body>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Pay Slip</title>
<link href="/stylesheet/report.css" rel="stylesheet" type="text/css" />
</head>
<body>
<cfset month_value = form.month1>
<cfquery name="emp_data" datasource="#DSNAME#" >
SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="selectList" datasource="#DSNAME#">
SELECT * FROM pay_12m WHERE TMONTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#month_value#"> and empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_data.empno#">
</cfquery>

<cfset OTlist = ArrayNew(1)>
<cfset OTtype = ArrayNew(1)>
<cfloop from="1" to="6" index="i">
<cfquery name="getOt_qry" datasource="#DSNAME#">
SELECT * From Ottable Where OT_COU=#i#
</cfquery>
<cfset ArrayAppend(OTlist, "#getOt_qry.OT_DESP#")>
<cfset ArrayAppend(OTtype, "#getOt_qry.OT_UNIT#")>
</cfloop>

<cfquery name="aw_qry" datasource="#DSNAME#">
SELECT aw_cou,aw_desp FROM awtable
where aw_cou < 18
</cfquery>

<cfquery name="ded_qry" datasource="#DSNAME#">
SELECT ded_cou,ded_desp FROM dedtable
</cfquery>

<cfquery name="company_details" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,month_value,1)>
<cfset days = daysinmonth(date)>
<cfset date1= createdate(yrs,month_value,days)>
<cfset iii = 0> 
<cfloop query="selectList">
<!--- <cfquery name="select_data" datasource="#DSNAME#">
SELECT * FROM paytra1 AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = #selectList.empno#
</cfquery> --->
<cfquery name="select_data" datasource="#DSNAME#">
		SELECT * FROM pay_12m AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE TMONTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.month1#"> and pt.empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#selectList.empno#">
		</cfquery>
<cfoutput>
<p <cfif iii neq 0 >style="page-break-after:always" <cfelse> <cfset iii = iii + 1 ></cfif> >
<table width="1000px" border="0">
<tr>
<th align="left">#company_details.comp_name#</th>
<th align="center">2nd HALF PAYROLL-#DATEFORMAT(date,'MMMM YYYY')#</th>
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
  <td align="right">#dateformat(date1,'dd/mm/yyyy')#</td>
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
  <td width="37.5Px">#select_data.OPLD#</td>
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
  <td width="37.5Px">#select_data.ONPLD#</td>
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
  <cfif aw_data gt 0>
  <tr>
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
  <td width="170px">MONTHLY GROOSS</td>
  <td width="82px">#select_data.GROSSPAY#</td>
  <td colspan="3">&nbsp;</td>
</tr>
<tr>
  <td><cfif company_details.ccode eq 'MY'>E<cfelse>C</cfif>PF' YER</td>
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
<cfif company_details.t21 eq "1"><td width="130px">DIR.FEE</td></cfif>
<td width="90px">OVERTIME</td>
<td width="90px">ALLOWANCE</td>
<td width="90px">GROSS PAY</td>
<td width="90px">DEDUCTION</td>
<td width="50px"><cfif company_details.ccode eq 'MY'>E<cfelse>C</cfif>PF</td>
<td width="90px"><cfif company_details.ccode eq 'MY'>SOCSO</cfif></td>
<td width="90px">NETT</td>
<td width="10px"></td>
<td width="180px">&nbsp;</td>
</tr>
<tr>
  <td colspan="9"><hr /></td>
  <td></td>
  <td><hr /></td>

</tr>
<tr>
<td width="90px">#numberformat(select_data.basicpay,'.__')#</td>
<cfif company_details.t21 eq "1"><td width="130px">#numberformat(select_data.dirfee,'.__')#</td></cfif>
<td width="90px">#numberformat(select_data.otpay,'.__')#</td>
<td width="90px">#numberformat(select_data.taw,'.__')#</td>
<td width="90px">#numberformat(select_data.grosspay,'.__')#</td>
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
</body>
</html>


<cfoutput>
<cfdocumentitem type="footer">
	<font size="2">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</font>
</cfdocumentitem>
</cfoutput>
</body>
</html>
</cfdocument>
--->