<cfquery name="getgsetup" datasource="#dts#">
	SELECT date_format(lastAccYear,"%Y%m") AS lastAccYear2,LastAccYear,period
	FROM gsetup
</cfquery>
<cfquery name="getInfo" datasource="#dts#">
	SELECT fperiod,ABS(cal2+lastybal) AS exbal
	FROM
	(
		SELECT accno,SUM(COALESCE(lastybal,0)) AS lastybal,acctype
		FROM gldata 
		WHERE
		<cfif url.type eq "sal"> 
			acctype='H'
		<cfelseif url.type eq "sal2"> 
			acctype="M"
		</cfif>
		GROUP BY LEFT(accno,4)
	) AS a
	LEFT JOIN
	(
		SELECT a.fperiod,b.acctype,b.accno,(SUM(a.debitamt)-SUM(a.creditamt)) AS cal2
		FROM glpost AS a 
		RIGHT JOIN gldata AS b 
		ON a.accno=b.accno
		WHERE
		<cfif url.type eq "sal"> 
			b.acctype='H'
		<cfelseif url.type eq "sal2"> 
			b.acctype="M"
		</cfif> 
		AND fperiod <> '99'
		AND fperiod >= '1' 
		AND fperiod <= '18'
		GROUP BY fperiod
		ORDER BY a.fperiod
	) AS b
	ON LEFT(a.accno,4)=LEFT(b.accno,4)
	WHERE fperiod <> '99'
	ORDER BY fperiod
</cfquery>
<cfset data=ArrayNew(2)>
<cfset lastperiod=getgsetup.period>
<cfset thismonth=DateFormat(now(),"mmm yy")>
<cfloop index="period" from="1" to="18">
	<cfset pccurr=DateAdd('m',period,"#getgsetup.LastAccYear#")>
	<cfset pdmont2=dateformat(pccurr,"mmm yy")>
	<cfif pdmont2 EQ thismonth>
		<cfset lastperiod=period>
	</cfif>
	<cfset data[period][1] = pdmont2>
	<cfset data[period][2] = 0>
	<cfloop query="getinfo">
		<cfif period EQ getInfo.fperiod>
			<cfset data[period][2] = getInfo.exbal>
		</cfif>
	</cfloop>
</cfloop>

    <cfif lastperiod-4 lte 0>
    	<cfset startperiod = 1>
	<cfelse>
    	<cfset startperiod = lastperiod-4>		        
    </cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Chart</title>
</head>
<body style="background:#EBF6F0;">
<cfchart
	backgroundColor="EBF6F0"
	dataBackgroundColor="EBF6F0"
	foregroundColor="708782"
	chartheight="240"
	chartwidth="450"
	xAxisTitle="Month"
	yAxisTitle="Value"
	showborder="no"
	show3d="no"
	>
	<cfchartseries
		type="bar"
        seriesColor="8CC7BD" 
        paintStyle="shade"
        >
		<cfloop index="datum" from="#startperiod#" to="#lastperiod#">
			<cfchartdata item="#data[datum][1]#" value="#data[datum][2]#">
		</cfloop>
	</cfchartseries>
</cfchart>
</body>
</html>