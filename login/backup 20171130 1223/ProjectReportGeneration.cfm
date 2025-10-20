<style type="text/css">
td {font-size: 20px;}
th {font-size: 18px; font-weight: bold;}
h1 {font-size: 16px; font-weight: bold;}
</style>
<link rel="shortcut icon" href="/PMS.ico" />
<cfset order_keyword="pm."&#form.order#>
<cfquery name="selectList" datasource="#dts#">
SELECT p.empno FROM paytran p, pmast pm
WHERE p.empno = pm.empno and p.payyes = "Y" AND pm.paystatus = "A"
and confid >= #hpin#
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
<cfif #form.confid# neq "">
	AND pm.confid = "#form.confid#"
</cfif>
<cfif #form.contract# neq "">
	AND pm.contract = "#form.contract#"
</cfif>
ORDER BY
<cfif #form.order# neq "">
 #order_keyword# desc ,
</cfif>
pm.empno asc
</cfquery>

<cfquery name="company_details" datasource="#dts_main#">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfset date= createdate(yrs,mon,1)>

<cfset Mtitle = ArrayNew(1)>
<cfset Mheader = ArrayNew(1)>
<cfset Mcontent = ArrayNew(1)>
<cfset num_value = ArrayNew(1)>
<cfset ArrayAppend(Mtitle, "PAY SUMMARY")>
<cfset ArrayAppend(Mtitle, "ALLOWANCE REPORT")>
<cfset ArrayAppend(Mtitle, "DEDUCTION REPORT")>
<cfset ArrayAppend(Mtitle, "OVERTIME REPORT")>
<cfset ArrayAppend(Mtitle, "LEAVE REPORT")>
<cfset ArrayAppend(Mtitle, "PIECE DONE REPORT")>
<cfset ArrayAppend(Mtitle, "MORE ALLOWANCE REPORT")>
<cfset ArrayAppend(Mtitle, "MORE DEDUCTION REPORT")>
<cfset ArrayAppend(Mtitle, "PROJECT TOTAL REPORT")>
<cfset ArrayAppend(Mtitle, "ALLOWANCE REPORT")>
<cfset ArrayAppend(Mtitle, "DEDUCTION REPORT")>
<cfset ArrayAppend(Mtitle, "OVERTIME REPORT")>
<cfset ArrayAppend(Mtitle, "LEAVE REPORT")>
<cfset ArrayAppend(Mtitle, "MORE ALLLOWANCE REPORT")>
<cfset ArrayAppend(Mtitle, "MORE DEDUCTION REPORT")>

<cfif HuserCcode eq "MY">
<cfset ArrayAppend(Mheader, "NO,E.NO,NAME,BASIC,OT,AW,GROSS,DED,E.YEE EPF,E.YEE SOCSO,NETT,E.YER EPF,TOTAL EPF,E.YER SOCSO,M.GROSS,TYPE,DW")>
<cfelse>
<cfset ArrayAppend(Mheader, "NO,E.NO,NAME,BASIC,OT,AW,GROSS,DED,E.YEE CPF,NETT,E.YER CPF,TOTAL CPF,M.GROSS,TYPE,DW")>
</cfif>
<cfset ArrayAppend(Mheader, "N0,EMP NO,NAME,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,1,2,3,4,5,6,7,8,9,10,11,12,13,14,CP 38,ADVANCE,TOTAL")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,1.0 TIME,1.5 TIMES,2.0 TIMES,3.0 TIMES,REST DAY, PUB HOL,1.0 TIME,1.5 TIMES,2.0 TIMES,3.0 TIMES,REST DAY, PUB HOL,OT PAY")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL,LS,NPL,AB,ONPL,TOTAL,AL ENT,MC ENT")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfset ArrayAppend(Mheader, "NO,EMP NO,NAME,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfif HuserCcode eq "MY">
<cfset ArrayAppend(Mheader, ",PROJECT,NO OF EMPLOYEE,ADVANCE,BASIC,OVERTIMR,AW,DIRFEE,GROSS,DED,EMPLOYEE EPF,NETT,EMPLOYER EPF,MONTHLY GROSS")>
<cfelse>
<cfset ArrayAppend(Mheader, ",PROJECT,NO OF EMPLOYEE,ADVANCE,BASIC,OVERTIMR,AW,DIRFEE,GROSS,DED,EMPLOYEE CPF,NETT,EMPLOYER CPF,MONTHLY GROSS")>
</cfif>
<cfset ArrayAppend(Mheader, "PROJECT,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfset ArrayAppend(Mheader, "PROJECT,1,2,3,4,5,6,7,8,9,10,11,12,13,14,CP 38,ADVANCE,TOTAL")>
<cfset ArrayAppend(Mheader, "PROJECT, NUMBER OF EMPLOYEE,1.0 TIME,1.5 TIMES,2.0 TIMES,3.0 TIMES,REST DAY, PUB HOL,1.0 TIME,1.5 TIMES,2.0 TIMES,3.0 TIMES,REST DAY, PUB HOL,OT PAY ")>
<cfset ArrayAppend(Mheader, "PROJECT, NUMBER OF EMPLOYEE,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL,LS,NPL,AB,ONPL,TOTAL ")>
<cfset ArrayAppend(Mheader, "PROJECT,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>
<cfset ArrayAppend(Mheader, "PROJECT,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,TOTAL")>


<cfset ArrayAppend(Mcontent, "empno,name,basicpay,otpay,taw,grosspay,tded,epfww,socsoww,netpay,epfcc,epf_pay,socsocc,grosspay,payrtype,dw")>
<cfset ArrayAppend(Mcontent, "empno,name,AW101,AW102,AW103,AW104,AW105,AW106,AW107,AW108,AW109,AW110,AW111,AW112,AW113,AW114,AW115,AW116,AW117,columntotal")>
<cfset ArrayAppend(Mcontent, "empno,name,DED101,DED102,DED103,DED104,DED105,DED106,DED107,DED108,DED109,DED110,DED111,DED112,DED113,DED114,Advance,Advance,columntotal")>
<cfset ArrayAppend(Mcontent, "empno,name,HR1,HR2,HR3,HR4,HR5,HR6,OT1,OT2,OT3,OT4,OT5,OT6,OTPAY")>
<cfset ArrayAppend(Mcontent, "empno,name,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL,LS,NPL,AB,ONPL,columntotal,albf,mcall")>
<cfset ArrayAppend(Mcontent, "empno,name,PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL,LS,NPL,AB,ONPL,PH,AL,columntotal")>
<cfset ArrayAppend(Mcontent, "empno,name,MAW101,MAW102,MAW103,MAW104,MAW105,MAW106,MAW107,MAW108,MAW109,MAW110,MAW111,MAW112,MAW113,MAW114,MAW115,MAW116,MAW117,columntotal")>
<cfset ArrayAppend(Mcontent, "empno,name,MDED101,MDED102,MDED103,MDED104,MDED105,MDED106,MDED107,MDED108,MDED109,MDED110,MDED111,MDED112,MDED113,MDED114,MDED115,MDED116,MDED117,columntotal")>
<cfset ArrayAppend(Mcontent, "RECORDCOUNT,ADVANCE,brate,OTpay,taw,dirfee,grosspay,tded,epfww,netpay,epfcc,grosspay")>
<cfset ArrayAppend(Mcontent, "AW101,AW102,AW103,AW104,AW105,AW106,AW107,AW108,AW109,AW110,AW111,AW112,AW113,AW114,AW115,AW116,AW117,columntotal")>
<cfset ArrayAppend(Mcontent, "DED101,DED102,DED103,DED104,DED105,DED106,DED107,DED108,DED109,DED110,DED111,DED112,DED113,DED114,Advance,Advance,columntotal")>
<cfset ArrayAppend(Mcontent, "HR1,HR2,HR3,HR4,HR5,HR6,OT1,OT2,OT3,OT4,OT5,OT6,OTPAY")>
<cfset ArrayAppend(Mcontent, "PH,AL,MC,MT,MR,CL,HL,EX,PT,AD,OPL,LS,NPL,AB,ONPL,columntotal")>
<cfset ArrayAppend(Mcontent, "MAW101,MAW102,MAW103,MAW104,MAW105,MAW106,MAW107,MAW108,MAW109,MAW110,MAW111,MAW112,MAW113,MAW114,MAW115,MAW116,MAW117,columntotal")>
<cfset ArrayAppend(Mcontent, "MDED101,MDED102,MDED103,MDED104,MDED105,MDED106,MDED107,MDED108,MDED109,MDED110,MDED111,MDED112,MDED113,MDED114,MDED115,MDED116,MDED117,columntotal")>


<cfset ArrayAppend(num_value, 12)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 17)>
<cfset ArrayAppend(num_value, 13)>
<cfset ArrayAppend(num_value, 16)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 11)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 17)>
<cfset ArrayAppend(num_value, 13)>
<cfset ArrayAppend(num_value, 16)>
<cfset ArrayAppend(num_value, 18)>
<cfset ArrayAppend(num_value, 18)>

<cfset rowtotal=arraynew(1)>
<cfset columntotal = arraynew(1)>

<cfif #form.line_no# eq "P1">
<cfset i = 1>
<cfelseif #form.line_no# eq "G2">
<cfset i = 2>
<cfelseif #form.line_no# eq "G3">
<cfset i = 3>
<cfelseif #form.line_no# eq "G4">
<cfset i = 4>
<cfelseif #form.line_no# eq "G5">
<cfset i = 5>
<cfelseif #form.line_no# eq "G6">
<cfset i = 90>
<cfelseif #form.line_no# eq "G7">
<cfset i = 10>
<cfelseif #form.line_no# eq "G8">
<cfset i = 11>
<cfelseif #form.line_no# eq "P2">
<cfset i = 9>
<cfelseif #form.line_no# eq "G10">
<cfset i = 13>
</cfif>
<cfset tblname1 = "tlineno" >
<cfset tblname2 = "branch">
<cfset tblname3 = "dept">
<cfset tblname4 = "category">

<cfset desp1 = "desp">
<cfset desp2 = "brdesp">
<cfset desp3 = "deptdesp">
<cfset desp4 = "desp">


<cfset forma_1 = form.lineno>
<cfset form1_1 = form.lineno1>
<cfset forma_2 = form.brcode>
<cfset form1_2 = form.brcode1>
<cfset forma_3 = form.deptcode>
<cfset form1_3 = form.deptcode1>
<cfset forma_4 = form.category>
<cfset form1_4 = form.category1>

<cfset code1 = "lineno">
<cfset code2 = "brcode">
<cfset code3 = "deptcode">
<cfset code4 = "category">

<cfset title1 = "LINE NO">
<cfset title2 = "BRANCH">
<cfset title3 = "DEPARTMENT">
<cfset title4 = "CATEGORY">


<title>Report</title>
<cfoutput>
<table width="100%" >
<tr>
<th align="center" colspan="3">2ND HALF PAYROLL -#Mtitle[i]# <br />PRINTED BY #HUserName#</th>
</tr>
<tr>
  <th align="left">#company_details.comp_name#</th>
  <th align="center">&nbsp;</th>
  <th align="right">#form.reportdate#</th>
</tr>
<cfloop from="1" to="4" index="v">
	<cfset tblname = "tblname"&v>
	<cfset result = evaluate("#tblname#")>
	<cfset desp = "desp"&v>
	<cfset result_desp = evaluate("#desp#")>
	<cfset form_a = "forma_"&v>
	<cfset result_form = evaluate("#form_a#")>
	<cfset form1 = "form1_"&v>
	<cfset result_form1 = evaluate("#form1#")>
	<cfset code = "code"&v>
    <cfset result_code = evaluate("#code#")>
	<cfset title = "title"&v>
	<cfset result_title = evaluate("#title#")>
	
	
	<cfif result_form neq "" or result_form1 neq "" >
	<tr>
		<td>
			<table>
				<tr>
					<td>#result_title#</td>
					<cfquery name="lineNo" datasource="#dts#">
						SELECT #result_desp# as desp FROM #result# 
						where 0=0
						<cfif #result_form# neq "">
							AND #result_code#  >= "#result_form#"
						</cfif>
						<cfif #result_form1# neq "">
							AND #result_code# <= "#result_form1#"
						</cfif>
						
					</cfquery>	
					
					<cfloop query="lineNo">
						<td>#lineno.desp#</td><td width="5px"><td>
					</cfloop>
				</tr>
			</table>
		</td>
	</tr>
</cfif>
</cfloop>
<tr>
  <td colspan="3"><hr /></td>
</tr>
<tr>

  <td colspan="3">

<table with="100%">
  <tr align="left" >
  <cfset count=0>
  <cfloop list=#Mheader[i]# index="j">
    <td align="center"><h1>#j#</h1></td>
  <cfset count=count + 1>
  </cfloop>
  </tr>
    <tr>
  <td colspan="#count#"><hr /></td>
  </tr>
  <cfset x = 1>
  <cfloop query="selectlist">
  
  	<cfif i lt 7 and i gt 0>
  
  	<cfquery name="select_data" datasource="#dts#">
	SELECT * FROM paytran AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = "#selectList.empno#"
	</cfquery>
	
    <cfelseif i lt 9 and i gt 6>
    <cfquery name="select_data" datasource="#dts#">
	SELECT * FROM moretra AS mr LEFT JOIN pmast as pm ON mr.empno = pm.empno WHERE mr.empno = "#selectList.empno#"
	</cfquery>
    
    <cfelseif i gt 8 and i lt 14>
    <cfquery name="select_data" datasource="#dts#">
	SELECT * FROM paytran AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = "#selectList.empno#"
	</cfquery>
    
    <cfelseif i gt 13 and i lt 16>
      <cfquery name="select_data" datasource="#dts#">
	SELECT * FROM moretra AS mr LEFT JOIN pmast as pm ON mr.empno = pm.empno WHERE mr.empno = "#selectList.empno#"
	</cfquery>
    
    <cfelseif i eq 16>
	<cfquery name="select_data" datasource="#dts#">
	SELECT * FROM paytran AS pt LEFT JOIN pmast AS pm ON pt.empno = pm.empno WHERE pt.empno = "#selectList.empno#"
	</cfquery>
	</cfif>
    <cfif i lt 9 or i eq 16>
	<tr >
    <tr onMouseOver="javascript:this.style.backgroundColor='99FF00';" onMouseOut="javascript:this.style.backgroundColor='';">
    <td >#x#</td></cfif>
    <cfset y = 1>
    <cfset columntotal[x] = 0>
	<cfloop list="#Mcontent[i]#" index="k">
    <cfif #k# neq "columntotal" > 
    <cfset value= #evaluate("select_data.#k#")#>
    <cfelse>
    <cfset value= #evaluate("columntotal[#x#]")#>
	</cfif>
    <cfif value eq "">
    <cfset value = #val(value)#>
    </cfif>
	<cfif x eq 1>
	<cfset rowtotal[y]= 0>
    </cfif>
    
    <cfif isnumeric(value) and #k# neq "empno" and #k# neq "recordcount">
    <cfif isnumeric(value) and #k# eq "dw">
		<cfset value = #round(val(value))#>
	<cfelse>	
	<cfset value = #value# >
	</cfif>
    <cfset columntotal[x] += value >
    <cfset rowtotal[y] += value>
	<cfset y = y + 1>
	</cfif>
    
    <cfif isnumeric(value) and value eq 0>
	<cfset value = "-" >
	</cfif> 
    
    <cfif i lt 9 or i eq 16>
				<cfif #k# neq "name" AND #k# neq "empno" AND #k# neq "recordcount" >
			<td align ="center">#value#</td> 
		<cfelse>
		<td align="center">#value#</td>
		</cfif>
    </cfif>
    
    </cfloop>
    <cfif i lt 9 or i eq 16>
    </tr>
    </cfif>
    
    <cfset x = x + 1>
  </cfloop>
  <cfif i lt 9 or i eq 16>
  		<tr>
  		<td colspan="3">&nbsp;</td>
        <cfset count = count - 3>
  		<td colspan="#count#">
  		<hr />
        </td>
        </tr>
        </cfif>
        <tr>
        <cfif i lt 9 or i eq 16>
  		<th colspan="3">&nbsp;</th>
         <cfelseif i eq 9>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <cfelseif i eq 10>
        <th>&nbsp;</th>
        <cfelseif i eq 11 or i eq 14>
        <th>&nbsp;</th>
        <cfelseif i eq 12>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <cfelseif i eq 13>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        <cfelseif i eq 15>
        <th>&nbsp;</th>
        </cfif>
        <cfif selectlist.recordcount neq 0>
        <cfloop from="1" to="#num_value[i]#" index="z">
        <td align="center">#numberformat(rowtotal[z],'.__')#</td>
        </cfloop>
        </cfif>
		</tr>
        
        <tr>
        <cfset count = count + 3>
  		<td colspan="#count#">
  		<hr />
        </td>
        </tr>
        
         <tr>
        <cfset x = x - 1 >
        <cfif i lt 9 or i eq 16>
  		<th colspan="3">&nbsp;</th>
        <cfelseif i eq 9>
        <th>&nbsp;</th>
        <th>TOTAL: #x#</th>
        <cfelseif i eq 10>
        <th>TOTAL: #x#</th>
        <cfelseif i eq 11 or i eq 14>
        <th>TOTAL: #x#</th>
        <cfelseif i eq 12>
        <th>TOTAL: </th>
        <th>#x#</th>
        <cfelseif i eq 13>
        <th>TOTAL: </th>
        <th>#x#</th>
        <cfelseif i eq 15>
        <th>TOTAL: #x#</th>
        </cfif>
       <cfif selectlist.recordcount neq 0>
			<cfloop from="1" to="#num_value[i]#" index="z">
	        <td align="center">#numberformat(rowtotal[z],'.__')#</td>
	        </cfloop>
        </cfif>
        </tr>
    
        </table>
        </td>
        </tr>
        </table>
        
</cfoutput>