<cfoutput>
<cfsetting showdebugoutput="no">
<cfset datevalue = 1>
<cfif url.datefrom neq "" and url.dateto neq "">
<cfset datefrm = URLDECODE(url.datefrom)>
<cfset datet = URLDECODE(url.dateto)>
<cfset datefrm = createdate(right(datefrm,4),mid(datefrm,4,2),left(datefrm,2))>
<cfset datet = createdate(right(datet,4),mid(datet,4,2),left(datet,2))>

<cfif datefrm lte datet>
<cfset datevalue = datediff('d',datefrm,datet)+1>
</cfif>
</cfif>

<input type="text" id="days_d" name="days" value="#datevalue#" <cfif url.lvlbal neq '1'>onkeyup="validhalf(this.value);controlbalance();"<cfelse>onkeyup="validhalf(this.value);"</cfif>  />
</cfoutput>