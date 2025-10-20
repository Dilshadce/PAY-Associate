<cfquery name="getComp_qry" datasource="payroll_main">
SELECT * FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>


<cfquery name="getList_qry" datasource="#dts#">
SELECT empno FROM pmast WHERE confid >= #hpin#
	  <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
	  <cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
	  AND a.epfcat = '#form.epfcat#' 
	  group by a.empno
</cfquery>

<cfoutput query="getList_qry">

	<cfquery name="get_bonus" datasource="#dts#">
	SELECT sum(coalesce(epfcc,0)) as epfcc,sum(coalesce(epfccext,0)) as epfccext,sum(coalesce(epfww,0)) as epfww,sum(coalesce(epfwwext,0)) as epfwwext,sum(coalesce(epf_pay,0)) as epf_pay FROM bonu_12m 
	WHERE empno = "#getList_qry.empno#"
	</cfquery>
	
	<cfquery name="get_pay12m" datasource="#dts#">
	SELECT sum(coalesce(epfcc,0)) as epfcc,sum(coalesce(epfccext,0)) as epfccext,sum(coalesce(epfww,0)) as epfww,sum(coalesce(epfwwext,0)) as epfwwext FROM pay_12m 
	WHERE empno = "#getList_qry.empno#"
	</cfquery>
	
	<cfquery name="get_comm12m" datasource="#dts#">
	SELECT sum(coalesce(epfcc,0)) as epfcc,sum(coalesce(epfccext,0)) as epfccext,sum(coalesce(epfww,0)) as epfww,sum(coalesce(epfwwext,0)) as epfwwext,sum(coalesce(epf_pay,0)) as epf_pay FROM comm_12m 
	WHERE empno = "#getList_qry.empno#"
	</cfquery>
	
	<cfquery name="get_extra12m" datasource="#dts#">
	SELECT sum(coalesce(epfcc,0)) as epfcc,sum(coalesce(epfccext,0)) as epfccext,sum(coalesce(epfww,0)) as epfww,sum(coalesce(epfwwext,0)) as epfwwext,sum(coalesce(epf_pay,0)) as epf_pay FROM extr_12m 
	WHERE empno = "#getList_qry.empno#"
	</cfquery>

	<cfset sum2 = val(get_pay12m.epfcc) + val(get_pay12m.epfccext) - (val(get_bonus.epfcc) + val(get_bonus.epfccext) + val(get_comm12m.epfcc) + val(get_comm12m.epfccext) + val(get_extra12m.epfcc) + val(get_extra12m.epfccext))>
	<cfset sum3 = val(get_pay12m.epfww) + val(get_pay12m.epfwwext) - (val(get_bonus.epfww) + val(get_bonus.epfwwext) + val(get_comm12m.epfww) + val(get_comm12m.epfwwext) + val(get_extra12m.epfww) + val(get_extra12m.epfwwext))>
	<cfset sum4 = val(get_bonus.epf_pay) + val(get_comm12m.epf_pay) + val(get_extra12m.epf_pay)>
	<cfset sum5 = val(get_bonus.epfcc) + val(get_bonus.epfccext) + val(get_comm12m.epfcc) + val(get_comm12m.epfccext) + val(get_extra12m.epfcc) + val(get_extra12m.epfccext)>
	<cfset sum6 = val(get_bonus.epfww) + val(get_bonus.epfwwext) + val(get_comm12m.epfww) + val(get_comm12m.epfwwext) + val(get_extra12m.epfww) + val(get_extra12m.epfwwext)>
	
	<cfquery name="update_sum" datasource="#dts#">
	UPDATE itaxea2 SET 
	ea2txt26 = #val(sum2)#,
	ea2txt27 = #val(sum3)#,
	ea2txt28 = #val(sum4)#,
	ea2txt29 = #val(sum5)#,
	ea2txt30 = #val(sum6)#
	WHERE empno = "#getList_qry.empno#"
	</cfquery>
</cfoutput>

<cfquery name="getList_qry" datasource="#dts#">
select a.empno,a.name, a.postcode, a.town, a.state,
a.phone, a.dbirth, a.itaxno, a.nricn, a.nric, a.iccolor,
a.national, a.passport, a.sex, a.mstatus, a.jtitle,
a.dcomm, a.dresign, a.pr_from, a.confid,a.epfcat,
f.com_fileno as add_com_fileno, 
e.ea2dat01, e.ea2dat02, e.ea2dat03, e.ea2dat04, e.ea2dat05,
e.ea2dat06, e.ea2dat07, e.ea2dat08, e.ea2dat09, e.ea2dat10,
e.ea2dat11, e.ea2dat12, e.ea2dat13, e.ea2dat14, e.ea2dat15, e.ea2dat16, 
e.ea2fig01, e.ea2fig02, e.ea2fig03, e.ea2fig04, e.ea2fig05, e.ea2fig06, 
e.ea2fig07, e.ea2fig08, e.ea2fig09, e.ea2fig10, e.ea2fig11, e.ea2fig12, e.ea2fig13, e.ea2fig14, e.ea2fig15,
e.ea2txt01, e.ea2txt02, e.ea2txt26, e.ea2txt27, e.ea2txt28, e.ea2txt29, e.ea2txt30,

c.epf_pay_a as pay_epf_pay_a, c.epfcc as pay_epfcc , c.epfccext as pay_epfccext , c.epfww as pay_epfww  , c.epfwwext as pay_epfwwext, concat("2010-",c.tmonth,"-01") as tmonth,

d.epfcc as bonus_epfcc, d.epfccext as bonus_epfccext, d.epfww as bonus_epfww, d.epfwwext as bonus_epfwwext, d.epf_pay as bonus_epf_pay,

g.epfcc as comm_epfcc, g.epfccext as comm_epfccext, g.epfww as comm_epfww, g.epfwwext as comm_epfwwext, g.epf_pay as comm_epf_pay,

h.epfcc as extra_epfcc, h.epfccext as extra_epfccext, h.epfww as extra_epfww, h.epfwwext as extra_epfwwext, h.epf_pay as extra_epf_pay,

b.ea_epfcext as itaxea_ea_epfcext, b.ea_epfwext as itaxea_ea_epfwext, b.ea_epfcext as ea_epfcext

from (SELECT empno,name, postcode, town, state,
phone, dbirth, itaxno, nricn, nric, iccolor,
national, passport, sex, mstatus, jtitle,
dcomm, dresign, pr_from, confid,epfcat,bankcat FROM pmast) as a
left join (SELECT ea_epfcext ea_epfwext,ea_epfcext,empno FROM itaxea) as b on a.empno = b.empno
left join (SELECT ea2dat01, ea2dat02, ea2dat03, ea2dat04, ea2dat05,
ea2dat06, ea2dat07, ea2dat08, ea2dat09, ea2dat10,
ea2dat11, ea2dat12, ea2dat13, ea2dat14, ea2dat15, ea2dat16, 
ea2fig01, ea2fig02, ea2fig03, ea2fig04, ea2fig05, ea2fig06, 
ea2fig07, ea2fig08, ea2fig09, ea2fig10, ea2fig11, ea2fig12, ea2fig13, ea2fig14, ea2fig15,
ea2txt01, ea2txt02, ea2txt26, ea2txt27, ea2txt28, ea2txt29, ea2txt30,empno from itaxea2) as e on a.empno = e.empno
left join (SELECT category,com_fileno FROM ADDRESS WHERE ORG_TYPE = "BANK") as f on a.bankcat = f.category
left join (SELECT empno,epf_pay_a, epfcc , epfccext , epfww , epfwwext, tmonth FROM pay_12m) as c on a.empno = c.empno
left join (SELECT epfcc,epfccext,epfww,epfwwext,epf_pay,empno,tmonth FROM comm_12m) as g on g.empno = a.empno and g.tmonth = c.tmonth
left join (SELECT epfcc,epfccext,epfww,epfwwext,epf_pay,empno,tmonth FROM bonu_12m) as d on d.empno = a.empno and d.tmonth = c.tmonth
left join (SELECT epfcc,epfccext,epfww,epfwwext,epf_pay,empno,tmonth FROM extr_12m) as h on h.empno = a.empno and h.tmonth = c.tmonth
where a.confid >= #hpin#
	  <cfif empno_frm neq ""> AND a.empno >= '#form.empno_frm#' </cfif>
	  <cfif empno_to neq ""> AND a.empno <= '#form.empno_to#' </cfif>
	  AND a.epfcat = '#form.epfcat#' 
</cfquery>

<cfreport template="IR8S.cfr" format="PDF" query="getList_qry" >

<cfreportparam name="compName" value="#getComp_qry.comp_name#">
<cfreportparam name="compCode" value="#getComp_qry.comp_roc#">
<cfreportparam name="add1" value="#getComp_qry.comp_add1#">
<cfreportparam name="add2" value="#getComp_qry.comp_add2#">
<cfreportparam name="add3" value="#getComp_qry.comp_add3#">
<cfreportparam name="pmName" value="#getComp_qry.pm_name#">
<cfreportparam name="pmPost" value="#getComp_qry.pm_position#">
<cfreportparam name="pmTel" value="#getComp_qry.pm_tel#">

</cfreport>

