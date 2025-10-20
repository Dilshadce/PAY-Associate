<html>
<head>
	<title>Update IR8S Figures</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
	<script src="/javascripts/CalendarControl.js" language="javascript"></script>
	
<script type="text/javascript">

function validate_form(thisform)
{
		var CYear = document.form2.CompanyYear.value;	
		var Date_From = document.form2.sec_83a.value;
		var Date_To = document.form2.sec_83b.value;
			
			 var CYear1 = CYear.substring(0,4) * 1;
			 var datefday = Date_From.substring(0,2) * 1;
			 var datetday = Date_To.substring(0,2) * 1;
			 var datefmonth = Date_From.substring(3,5) * 1;
			 var datetmonth = Date_To.substring(3,5) * 1;
			 var datefyear = Date_From.substring(6,10) * 1;
			 var datetyear = Date_To.substring(6,10) * 1;
		
	  if(Date_From !="" && Date_To !="" || Date_From !="" || Date_To !="")	
	  {
		 if(datefyear > datetyear)
			 {
				 alert("Date to must be equal or earlier than Date From");
				 return false;
			 }
			 else if( datefmonth > datetmonth && datefyear == datetyear)
			 {
				 alert("Date to must be equal or earlier than Date From");
				 return false;
			 }
			 else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
			 {
				 alert("Date to must be equal or earlier than Date From");
				 return false;
			 }
			 else if (datefyear != CYear1 || datetyear != CYear1)
			 {
				 alert("Period of Overseas posting Date must be within basis year");
				 return false;
			 }	
	}
	
	
		var Date_From_02 = document.form2.EA2DAT02.value;
		var Date_To_03 = document.form2.EA2DAT03.value;
		var Date_From_07 = document.form2.EA2DAT07.value;
		var Date_To_08 = document.form2.EA2DAT08.value;
		var Date_From_12 = document.form2.EA2DAT12.value;
		var Date_To_13 = document.form2.EA2DAT13.value;
			
		var datefyear02 = Date_From_02.substring(6,10) * 1;
		var datetyear03 = Date_To_03.substring(6,10) * 1;
		var datefyear07 = Date_From_07.substring(6,10) * 1;
		var datetyear08 = Date_To_08.substring(6,10) * 1;
		var datefyear12 = Date_From_12.substring(6,10) * 1;
		var datetyear13 = Date_To_13.substring(6,10) * 1;
			 
	     if (Date_From_02 != "" && Date_To_03 != "" || Date_From_02 != "" || Date_To_03 != "") {
		 	if (datefyear02 != CYear1 || datetyear03 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
		 if (Date_From_07 != "" && Date_To_08 != "" || Date_From_07 != "" || Date_To_08 != "") {
		 	if (datefyear07 != CYear1 || datetyear08 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
		 if (Date_From_12 != "" && Date_To_13 != "" || Date_From_12 != "" || Date_To_13 != "") {
		 	if (datefyear12 != CYear1 || datetyear13 != CYear1) {
		 		alert("ORDINARY/ADDITIONAL WAGES period must be within basis year")
		 		return false;
		 	}
		 }
	
}


</script>




<script language="javascript">
function calctotal(){

document.forms[0].EA_AW.value = 
 parseFloat(document.forms[0].EA_AW_T.value) +
 parseFloat(document.forms[0].EA_AW_E.value) +
 parseFloat(document.forms[0].EA_AW_O.value);
}


function isNumberKey(evt)
{
  var charCode = (evt.which) ? evt.which : event.keyCode
  if (charCode > 31 && (charCode < 48 || charCode > 57))
  return false;

  return true;
}

  function isNumberPoint(evt)
  {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode != 46 && charCode > 31 
    && (charCode < 48 || charCode > 57))
    return false;

    return true;
       }





</script>	
	
</head>

<body>
<cfoutput>	
<cfquery name="getComp_qry" datasource="payroll_main">
	SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>

<cfquery name="emp_qry" datasource="#dts#">
SELECT *
FROM pmast
WHERE empno="#url.empno#"
</cfquery>

<cfquery name="itaxea2" datasource="#dts#">
SELECT *
FROM itaxea2
WHERE empno="#url.empno#"
</cfquery>

<!-----------------------12 month queryof pay_12m----------------------------->
<cfquery name="pay_12m_1m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="1"
</cfquery>
<cfquery name="pay_12m_2m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="2"
</cfquery>
<cfquery name="pay_12m_3m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="3"
</cfquery>
<cfquery name="pay_12m_4m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="4"
</cfquery>
<cfquery name="pay_12m_5m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="5"
</cfquery>
<cfquery name="pay_12m_6m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="6"
</cfquery>
<cfquery name="pay_12m_7m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="7"
</cfquery>
<cfquery name="pay_12m_8m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="8"
</cfquery>
<cfquery name="pay_12m_9m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="9"
</cfquery>
<cfquery name="pay_12m_10m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="10"
</cfquery>
<cfquery name="pay_12m_11m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="11"
</cfquery>
<cfquery name="pay_12m_12m" datasource="#dts#">
				SELECT epf_pay_a,epfww,epfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#" and tmonth="12"
</cfquery>

<cfquery name="sum_pay_12m" datasource="#dts#">
				SELECT sum(coalesce(epf_pay_a,0)) as Tepf_pay_a,sum(coalesce(floor(epfww),0)) as Tepfww, sum(coalesce(round(epfcc),0)) as Tepfcc FROM pmast AS a LEFT JOIN pay_12m AS b ON a.empno=b.empno
				WHERE a.empno="#url.empno#"
			</cfquery>			
			
<!-------------------------------------------------End-------------------------------->
<!----------------------------------comm,extra,bonus query--------------------------------------->
<cfset tol_add_epf_pay = 0>
<cfset tol_add_epfcc = 0>
<cfset tol_add_epfww = 0>

<cfset add_epf_pay = ArrayNew(1)>
<cfset add_epfcc = ArrayNew(1)>
<cfset add_epfww = ArrayNew(1)>

<cfloop from="1" to="12" index="i">

<cfquery name="get_bonu_12m" datasource="#dts#">
	select epf_pay,epfww,epfcc from bonu_12m WHERE empno="#url.empno#" and tmonth="#i#"
</cfquery>
<cfquery name="get_comm_12m" datasource="#dts#">
	select epf_pay,epfww,epfcc from comm_12m WHERE empno="#url.empno#" and tmonth="#i#"
</cfquery>
<cfquery name="get_extr_12m" datasource="#dts#">
	select epf_pay,epfww,epfcc from extr_12m WHERE empno="#url.empno#" and tmonth="#i#"
</cfquery>


<cfset bonus_epf_pay = get_bonu_12m.epf_pay>
<cfset comm_epf_pay = get_comm_12m.epf_pay>
<cfset extr_epf_pay = get_extr_12m.epf_pay>
<cfset bonus_epfcc = get_bonu_12m.epfcc>
<cfset comm_epfcc = get_comm_12m.epfcc>
<cfset extr_epfcc = get_extr_12m.epfcc>
<cfset bonus_epfww = get_bonu_12m.epfww>
<cfset comm_epfww = get_comm_12m.epfww>
<cfset extr_epfww = get_extr_12m.epfww>

<cfset ArrayAppend(add_epf_pay, "#numberformat(val(bonus_epf_pay)+val(comm_epf_pay)+val(extr_epf_pay),'.__')#")>
<cfset ArrayAppend(add_epfcc, "#numberformat(val(bonus_epfcc)+val(comm_epfcc)+val(extr_epfcc),'.__')#")>
<cfset ArrayAppend(add_epfww, "#numberformat(val(bonus_epfww)+val(comm_epfww)+val(extr_epfww),'.__')#")>


<cfset tol_add_epf_pay = val(tol_add_epf_pay)+ add_epf_pay[i]>
<cfset tol_add_epfcc = val(tol_add_epfcc) +add_epfcc[i]>
<cfset tol_add_epfww = val(tol_add_epfww) +add_epfww[i]>


</cfloop>


<cfif #itaxea2.EA2FIG01# eq "">
	<cfset EA2FIG01 = "0">
	<cfelse>
	<cfset EA2FIG01 = itaxea2.EA2FIG01>
</cfif>
<cfif #itaxea2.EA2FIG02# eq "">
	<cfset EA2FIG02 = "0">
	<cfelse>
	<cfset EA2FIG02 = itaxea2.EA2FIG02>
</cfif>
<cfif #itaxea2.EA2FIG03# eq "">
	<cfset EA2FIG03 = "0">
	<cfelse>
	<cfset EA2FIG03 = itaxea2.EA2FIG03>
</cfif>
<cfif #itaxea2.EA2FIG04# eq "">
	<cfset EA2FIG04 = "0">
	<cfelse>
	<cfset EA2FIG04 = itaxea2.EA2FIG04>
</cfif>
<cfif #itaxea2.EA2FIG05# eq "">
	<cfset EA2FIG05 = "0">
	<cfelse>
	<cfset EA2FIG05 = itaxea2.EA2FIG05>
</cfif>
<cfif #itaxea2.EA2FIG06# eq "">
	<cfset EA2FIG06 = "0">
	<cfelse>
	<cfset EA2FIG06 = itaxea2.EA2FIG06>
</cfif>
<cfif #itaxea2.EA2FIG07# eq "">
	<cfset EA2FIG07 = "0">
	<cfelse>
	<cfset EA2FIG07 = itaxea2.EA2FIG07>
</cfif>
<cfif #itaxea2.EA2FIG08# eq "">
	<cfset EA2FIG08 = "0">
	<cfelse>
	<cfset EA2FIG08 = itaxea2.EA2FIG08>
</cfif>
<cfif #itaxea2.EA2FIG09# eq "">
	<cfset EA2FIG09 = "0">
	<cfelse>
	<cfset EA2FIG09 = itaxea2.EA2FIG09>
</cfif>
<cfif #itaxea2.EA2FIG10# eq "">
	<cfset EA2FIG10 = "0">
	<cfelse>
	<cfset EA2FIG10 = itaxea2.EA2FIG10>
</cfif>
<cfif #itaxea2.EA2FIG11# eq "">
	<cfset EA2FIG11 = "0">
	<cfelse>
	<cfset EA2FIG11 = itaxea2.EA2FIG11>
</cfif>
<cfif #itaxea2.EA2FIG12# eq "">
	<cfset EA2FIG12 = "0">
	<cfelse>
	<cfset EA2FIG12 = itaxea2.EA2FIG12>
</cfif>
<cfif #itaxea2.EA2FIG13# eq "">
	<cfset EA2FIG13 = "0">
	<cfelse>
	<cfset EA2FIG13 = itaxea2.EA2FIG13>
</cfif>
<cfif #itaxea2.EA2FIG14# eq "">
	<cfset EA2FIG14 = "0">
	<cfelse>
	<cfset EA2FIG14 = itaxea2.EA2FIG14>
</cfif>
<cfif #itaxea2.EA2FIG15# eq "">
	<cfset EA2FIG15 = "0">
	<cfelse>
	<cfset EA2FIG15 = itaxea2.EA2FIG15>
</cfif>


<form name="form2" action="/government/IR8A/PrintIR8S_act.cfm?type=update" method="post" onSubmit="return validate_form(this)">
<table class="form" border="0">
	
	<input type="hidden" name="CompanyYear" id="CompanyYear" value="#getComp_qry.myear#">
	
	<tr>
		<td colspan="8">Employee No.
			<input type="text" name="empno" value="#emp_qry.empno#" size="5" >
			<input type="text" name="name" value="#emp_qry.name#" size="40" ></td>
	</tr>
	<tr>
		<td colspan="5">Date of Renouncement of Singapore PR</td>
		<td><input type="text" name="EA2DAT01" id="EA2DAT01" value="#DateFormat(itaxea2.EA2DAT01, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT01);"></td>
	</tr>
	<tr>
		<td colspan="4"><strong>Section A - </strong>Details of monthly wages and CPF contributions</td>
	</tr>
	
	<tr>
		<th rowspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Month&nbsp;&nbsp;&nbsp;</th>
		<th rowspan="2">Ordinary Wages<br> (S$)</th>
		<th colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CPF Contribution</th>
		<th rowspan="2">Additional Wages<br> (S$)</th>
		<th colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CPF Contribution</th>
	</tr>
	
	<tr>
		<th>Employer (S$)</th>
		<th>Employee (S$)</th>
		<th>Employer (S$)</th>
		<th>Employee (S$)</th>
	</tr>
	
	<tr>
		<td>January</td>
		<td><input type="text" name="sec_5" id="sec_5" value="#numberformat(pay_12m_1m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_6" id="sec_6" value="#numberformat(round(val(pay_12m_1m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_7" id="sec_7" value="#numberformat(int(val(pay_12m_1m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_8" id="sec_8" value="#add_epf_pay[1]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_9" id="sec_9" value="#add_epfcc[1]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_10" id="sec_10" value="#add_epfww[1]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>February</td>
		<td><input type="text" name="sec_11" id="sec_11" value="#numberformat(pay_12m_2m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_12" id="sec_12" value="#numberformat(round(val(pay_12m_2m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_13" id="sec_13" value="#numberformat(int(val(pay_12m_2m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_14" id="sec_14" value="#add_epf_pay[2]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_15" id="sec_15" value="#add_epfcc[2]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_16" id="sec_16" value="#add_epfww[2]#" size="15" maxlength="10" ></td>
	</tr>

	<tr>
		<td>March</td>
		<td><input type="text" name="sec_17" id="sec_17" value="#numberformat(pay_12m_3m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_18" id="sec_18" value="#numberformat(round(val(pay_12m_3m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_19" id="sec_19" value="#numberformat(int(val(pay_12m_3m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_20" id="sec_20" value="#add_epf_pay[3]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_21" id="sec_21" value="#add_epfcc[3]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_22" id="sec_22" value="#add_epfww[3]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>April</td>
		<td><input type="text" name="sec_23" id="sec_23" value="#numberformat(pay_12m_4m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_24" id="sec_24" value="#numberformat(round(val(pay_12m_4m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_25" id="sec_25" value="#numberformat(int(val(pay_12m_4m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_26" id="sec_26" value="#add_epf_pay[4]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_27" id="sec_27" value="#add_epfcc[4]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_28" id="sec_28" value="#add_epfww[4]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>May</td>
		<td><input type="text" name="sec_29" id="sec_29" value="#numberformat(pay_12m_5m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_30" id="sec_30" value="#numberformat(round(val(pay_12m_5m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_31" id="sec_31" value="#numberformat(int(val(pay_12m_5m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_32" id="sec_32" value="#add_epf_pay[5]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_33" id="sec_33" value="#add_epfcc[5]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_34" id="sec_34" value="#add_epfww[5]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>June</td>
		<td><input type="text" name="sec_35" id="sec_35" value="#numberformat(pay_12m_6m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_36" id="sec_36" value="#numberformat(round(val(pay_12m_6m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_37" id="sec_37" value="#numberformat(int(val(pay_12m_6m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_38" id="sec_38" value="#add_epf_pay[6]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_39" id="sec_39" value="#add_epfcc[6]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_40" id="sec_40" value="#add_epfww[6]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>July</td>
		<td><input type="text" name="sec_41" id="sec_41" value="#numberformat(pay_12m_7m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_42" id="sec_42" value="#numberformat(round(val(pay_12m_7m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_43" id="sec_43" value="#numberformat(int(val(pay_12m_7m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_44" id="sec_44" value="#add_epf_pay[7]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_45" id="sec_45" value="#add_epfcc[7]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_46" id="sec_46" value="#add_epfww[7]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>August</td>
		<td><input type="text" name="sec_47" id="sec_47" value="#numberformat(pay_12m_8m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_48" id="sec_48" value="#numberformat(round(val(pay_12m_8m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_49" id="sec_49" value="#numberformat(int(val(pay_12m_8m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_50" id="sec_50" value="#add_epf_pay[8]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_51" id="sec_51" value="#add_epfcc[8]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_52" id="sec_52" value="#add_epfww[8]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>September</td>
		<td><input type="text" name="sec_53" id="sec_53" value="#numberformat(pay_12m_9m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_54" id="sec_54" value="#numberformat(round(val(pay_12m_9m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_55" id="sec_55" value="#numberformat(int(val(pay_12m_9m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_56" id="sec_56" value="#add_epf_pay[9]#" alue=""size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_57" id="sec_57" value="#add_epfcc[9]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_58" id="sec_58" value="#add_epfww[9]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>October</td>
		<td><input type="text" name="sec_59" id="sec_59" value="#numberformat(pay_12m_10m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_60" id="sec_60" value="#numberformat(round(val(pay_12m_10m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_61" id="sec_61" value="#numberformat(int(val(pay_12m_10m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_62" id="sec_62" value="#add_epf_pay[10]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_63" id="sec_63" value="#add_epfcc[10]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_64" id="sec_64" value="#add_epfww[10]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>November</td>
		<td><input type="text" name="sec_65" id="sec_65" value="#numberformat(pay_12m_11m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_66" id="sec_66" value="#numberformat(round(val(pay_12m_11m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_67" id="sec_67" value="#numberformat(int(val(pay_12m_11m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_68" id="sec_68" value="#add_epf_pay[11]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_69" id="sec_69" value="#add_epfcc[11]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_70" id="sec_70" value="#add_epfww[11]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<td>December</td>
		<td><input type="text" name="sec_71" id="sec_71" value="#numberformat(pay_12m_12m.epf_pay_a,'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_72" id="sec_72" value="#numberformat(round(val(pay_12m_12m.epfcc)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_73" id="sec_73" value="#numberformat(int(val(pay_12m_12m.epfww)),'.__')#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_74" id="sec_74" value="#add_epf_pay[12]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_75" id="sec_75" value="#add_epfcc[12]#" size="15" maxlength="10" ></td>
		<td><input type="text" name="sec_76" id="sec_76" value="#add_epfww[12]#" size="15" maxlength="10" ></td>
	</tr>
	
	<tr>
		<th>Total</th>
		<th><input type="text" name="sec_77" id="sec_77" value="#int(sum_pay_12m.Tepf_pay_a)#" size="10" >.00</th>
		<th><input type="text" name="sec_78" id="sec_78" value="#int(sum_pay_12m.Tepfcc)#" size="10" >.00</th>
		<th><input type="text" name="sec_79" id="sec_79" value="#ceiling(sum_pay_12m.Tepfww)#" size="10" >.00</th>
		<th><input type="text" name="sec_80" id="sec_80" value="#int(tol_add_epf_pay)#" size="10" >.00</th>
		<th><input type="text" name="sec_81" id="sec_81" value="#int(tol_add_epfcc)#" size="10" >.00</th>
		<th><input type="text" name="sec_82" id="sec_82" value="#ceiling(tol_add_epfww)#" size="10" >.00 </th>
	</tr>
	
	<tr>
		<td colspan="3">Period of Overseas posting </td>
		<td colspan="4" align="right">From <input type="text" name="sec_83a" id="sec_83a" size="10" value="#DateFormat(itaxea2.sec_83a, "dd/mm/yyyy")#"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(sec_83a);">
		To <input type="text" name="sec_83b" id="sec_83b" size="10" value="#DateFormat(itaxea2.sec_83b, "dd/mm/yyyy")#"><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(sec_83b);"></td></td>
	</tr>
	
	<tr>
		<td colspan="5">CPF contribution in respect of overseas posting are obligatory by contract of employment indicator</td>
		<td colspan="2" align="right"><input type="radio" name="sec_84" id="sec_84" value="Y" <cfif itaxea2.sec_84 eq "Y"> checked</cfif>>Yes
		<input type="radio" name="sec_84" id="sec_84" value="N" <cfif itaxea2.sec_84 eq "N"> checked</cfif>>No</td>
	</tr>
	<tr>
		<td colspan="5">Singapore Permanent Resident status is approved on or after 01.01.2010</td>
		<td colspan="2" align="right"><input type="radio" name="sec_86" id="sec_86" value="Y" <cfif itaxea2.sec_86 eq "Y"> checked</cfif>>Yes
		<input type="radio" name="sec_86" id="sec_86" value="N" <cfif itaxea2.sec_86 eq "N"> checked</cfif>>No</td>
	</tr>
	<tr>
		<td colspan="6">Has approval been given by CPF Board to make full contributions(for SPR status granted on / after 1 Jan 2005)</td>
		<td colspan="1" align="right"><input type="radio" name="EA2TXT02" id="EA2TXT02" value="Y" <cfif itaxea2.EA2TXT02 eq "Y" or emp_qry.r_statu eq "PR" > checked</cfif>>Yes
		<input type="radio" name="EA2TXT02" id="EA2TXT02" value="N" <cfif itaxea2.EA2TXT02 eq "N" > checked</cfif>>No</td>
	</tr>
	<tr>	
		<td colspan="5">CPF Capping applied</td>
		<td colspan="2" align="right"><input type="radio" name="sec_85" id="sec_85" value="Y" <cfif itaxea2.sec_85 eq "Y" > checked</cfif>>Yes
		<input type="radio" name="sec_85" id="sec_85" value="N" <cfif itaxea2.sec_85 eq "N" > checked</cfif>>No</td>	
	</tr>
	
	
	<tr><td><br></td></tr>
	
	<tr>
		<td colspan="3"><strong>Section B : </strong>Excess / Voluntary Contribution to CPF</td>
	</tr>
	
	<tr>
		<td colspan="2">Employer's Contribution  :  S$</td><td><input type="text" name="sec_88" id="sec_88" value="#int(val(itaxea2.sec_88))#" size="10" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
	</tr>
	
	<tr>
		<td colspan="2">Employee's Contribution  :  S$</td><td><input type="text" name="sec_89" id="sec_89" value="#int(val(itaxea2.sec_89))#" size="10" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
	</tr>
	
	<tr><td><br></td></tr>
	
	<tr>
		<td colspan="3"><strong>Section C : </strong>Details of Refund claimed / to be claimed</td>
	</tr>
	<tr>
		<th colspan="4" width="270px" align="center">ORDINARY/ADDITIONAL WAGES</th>
		<th colspan="6" width="600px" align="center">AMOUNT OF REFUND</th>
	</tr>
	<tr>
		<th width="70px">AMOUNT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th colspan="2" width="200px" align="center">PERIOD</th>
		<th width="100px">DATE PAID</th>
		<th colspan="3" align="center">EMPLOYER</th>
		<th colspan="3" align="center">EMPLOYEE</th>
	</tr>
	<tr>
		<th width="70px">$</th>
		<th width="100px">FROM</th>
		<th width="100px">TO</th>
		<th width="100px">&nbsp;</th>
		<th width="100px">CONTRIBUTION $</th>
		<th width="100px">INTEREST $</th>
		<th width="100px">@ DATE</th>
		<th width="100px">CONTRIBUTION $</th>
		<th width="100px">INTEREST $</th>
		<th width="120px">@ DATE</th>
	</tr>
	<tr>
		<td width="70px"><input type="text" name="EA2FIG01" id="EA2FIG01" value="#int(EA2FIG01)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT02" id="EA2DAT02" value="#DateFormat(itaxea2.EA2DAT02, "dd/mm/yyyy")#" size="10" >
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT02);"></td>
		<td width="100px"><input type="text" name="EA2DAT03" id="EA2DAT03" value="#DateFormat(itaxea2.EA2DAT03, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT03);"></td>
		<td width="100px"><input type="text" name="EA2DAT04" id="EA2DAT04" value="#DateFormat(itaxea2.EA2DAT04, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT04);"></td>
		<td width="100px"><input type="text" name="EA2FIG02" id="EA2FIG02" value="#int(EA2FIG02)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG03" id="EA2FIG03" value="#int(EA2FIG03)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT05" id="EA2DAT05" value="#DateFormat(itaxea2.EA2DAT05, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT05);"></td>
		<td width="100px"><input type="text" name="EA2FIG04" id="EA2FIG04" value="#int(EA2FIG04)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG05" id="EA2FIG05" value="#int(EA2FIG05)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT06" id="EA2DAT06" value="#DateFormat(itaxea2.EA2DAT06, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT06);"></td>
	</tr>
	<tr>
		<td width="70px"><input type="text" name="EA2FIG06" id="EA2FIG06" value="#int(EA2FIG06)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT07" id="EA2DAT07" value="#DateFormat(itaxea2.EA2DAT07, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT07);"></td>
		<td width="100px"><input type="text" name="EA2DAT08" id="EA2DAT08" value="#DateFormat(itaxea2.EA2DAT08, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT08);"></td>
		<td width="100px"><input type="text" name="EA2DAT09" id="EA2DAT09" value="#DateFormat(itaxea2.EA2DAT09, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT09);"></td>
		<td width="100px"><input type="text" name="EA2FIG07" id="EA2FIG07" value="#int(EA2FIG07)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG08" id="EA2FIG08" value="#int(EA2FIG08)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT10" id="EA2DAT10" value="#DateFormat(itaxea2.EA2DAT10, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT10);"></td>
		<td width="100px"><input type="text" name="EA2FIG09" id="EA2FIG09" value="#int(EA2FIG09)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG10" id="EA2FIG10" value="#int(EA2FIG10)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT11" id="EA2DAT11" value="#DateFormat(itaxea2.EA2DAT11, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT11);"></td>
	</tr>
	<tr>
		<td width="70px"><input type="text" name="EA2FIG11" id="EA2FIG11" value="#int(EA2FIG11)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT12" id="EA2DAT12" value="#DateFormat(itaxea2.EA2DAT12, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT12);"></td>
		<td width="100px"><input type="text" name="EA2DAT13" id="EA2DAT13" value="#DateFormat(itaxea2.EA2DAT13, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT13);"></td>
		<td width="100px"><input type="text" name="EA2DAT14" id="EA2DAT14" value="#DateFormat(itaxea2.EA2DAT14, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT14);"></td>
		<td width="100px"><input type="text" name="EA2FIG12" id="EA2FIG12" value="#int(EA2FIG12)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG13" id="EA2FIG13" value="#int(EA2FIG13)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT15" id="EA2DAT15" value="#DateFormat(itaxea2.EA2DAT15, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT15);"></td>
		<td width="100px"><input type="text" name="EA2FIG14" id="EA2FIG14" value="#int(EA2FIG14)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2FIG15" id="EA2FIG15" value="#int(EA2FIG15)#" size="7" maxlength="7" onKeyPress="return isNumberKey(event)">.00</td>
		<td width="100px"><input type="text" name="EA2DAT16" id="EA2DAT16" value="#DateFormat(itaxea2.EA2DAT16, "dd/mm/yyyy")#" size="10">
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(EA2DAT16);"></td>
	</tr>
	<tr>
		<td width="70px">Remarks:</td>
		<td colspan="9"><input type="text" name="EA2TXT01" value="#itaxea2.EA2TXT01#" size="160" maxlength="100"></td>
	</tr>

</table>
<br />

<center>
	<input type="button" name="exit" value="Exit" onClick="window.close();">
	<input type="submit" name="submit" value="Save">
</center>

</form>
</cfoutput>
</body>

</html>