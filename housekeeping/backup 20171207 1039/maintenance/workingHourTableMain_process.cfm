<cfoutput>
	
<cfset arraya = ListToArray(form.ot_cou)>
<cfset arrayb = ListToArray(form.xpaymthpy)>
<cfset arrayc = ListToArray(form.xdaypmth)>
<cfset arrayd = ListToArray(form.xdaypmthab)>
<cfset arraye = ListToArray(form.xhrpday_m)>
<cfset arrayf = ListToArray(form.xhrpyear)>
<cfset arrayg = ListToArray(form.xhrpday_d)>
<cfset arrayh = ListToArray(form.xdaypmtha)>
<cfset arrayi = ListToArray(form.xdaypmthb)>
<cfset arrayj = ListToArray(form.xhrpday_h)>
<cfset arrayk = ListToArray(form.daysperweek)>

<cfloop from="1" to="#ArrayLen(arraya)#" index="i">
	
<cfquery name="woUpdate_qry" datasource="#dts#">
UPDATE ottable 
SET 
	XPAYMTHPY = <cfqueryparam value="#arrayb[i]#" cfsqltype="CF_SQL_varchar">,
	XDAYPMTH = <cfqueryparam value="#arrayc[i]#" cfsqltype="CF_SQL_varchar">,
	XDAYPMTHAB = <cfqueryparam value="#arrayd[i]#" cfsqltype="CF_SQL_varchar">,
	XHRPDAY_M = <cfqueryparam value="#arraye[i]#" cfsqltype="CF_SQL_varchar">,
	XHRPYEAR = <cfqueryparam value="#arrayf[i]#" cfsqltype="CF_SQL_varchar">,
	XHRPDAY_D = <cfqueryparam value="#arrayg[i]#" cfsqltype="CF_SQL_varchar">,
	XDAYPMTHA = <cfqueryparam value="#arrayh[i]#" cfsqltype="CF_SQL_varchar">,
	XDAYPMTHB = <cfqueryparam value="#arrayi[i]#" cfsqltype="CF_SQL_varchar">,
	XHRPDAY_H = <cfqueryparam value="#arrayj[i]#" cfsqltype="CF_SQL_varchar">,
    daysperweek = <cfqueryparam value="#arrayk[i]#" cfsqltype="CF_SQL_varchar">
WHERE OT_COU = <cfqueryparam value="#arraya[i]#" cfsqltype="CF_SQL_varchar">
</cfquery>

</cfloop>

<cflocation url ="/housekeeping/maintenance/workingHourTableMain.cfm">
</cfoutput>

	<!---UPDATE 	ottable 
			SET
				XPAYMTHPY = <cfqueryparam value="#arguments.XPAYMTHPY#" cfsqltype="CF_SQL_varchar">,
				XDAYPMTH = <cfqueryparam value="#arguments.XDAYPMTH#" cfsqltype="CF_SQL_varchar">,
				XDAYPMTHAB = <cfqueryparam value="#arguments.XDAYPMTHAB#" cfsqltype="CF_SQL_varchar">,
				XHRPDAY_M = <cfqueryparam value="#arguments.XHRPDAY_M#" cfsqltype="CF_SQL_varchar">,
				XHRPYEAR = <cfqueryparam value="#arguments.XHRPYEAR#" cfsqltype="CF_SQL_varchar">,
				XHRPDAY_D = <cfqueryparam value="#arguments.XHRPDAY_D#" cfsqltype="CF_SQL_varchar">,
				XDAYPMTHA = <cfqueryparam value="#arguments.XDAYPMTHA#" cfsqltype="CF_SQL_varchar">,
				XDAYPMTHB = <cfqueryparam value="#arguments.XDAYPMTHB#" cfsqltype="CF_SQL_varchar">,
				XHRPDAY_H = <cfqueryparam value="#arguments.XHRPDAY_H#" cfsqltype="CF_SQL_varchar">
			WHERE OT_COU = <cfqueryparam value="#arguments.OT_COU#" cfsqltype="cf_sql_varchar">--->