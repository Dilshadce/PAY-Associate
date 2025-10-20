<cfoutput>
<cfquery name="denomUpdate_qry" datasource="#dts#">
UPDATE denomtab 
SET denom_a='#form.avalue#',
	denom_b='#form.bvalue#',
	denom_c='#form.cvalue#',
	denom_d='#form.dvalue#',
	denom_e='#form.evalue#',
	denom_f='#form.fvalue#',
	denom_g='#form.gvalue#',
	denom_h='#form.hvalue#',
	denom_i='#form.ivalue#',
	denom_j='#form.jvalue#',
	denom_fac='#form.factor#'
</cfquery>
<cflocation url="/housekeeping/maintenance/denominationTableMain.cfm">
</cfoutput>
