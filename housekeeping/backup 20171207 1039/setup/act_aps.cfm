
<cfquery name="update_aps_data" datasource="#dts#">
UPDATE aps_set 
SET apsbank = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apsbank#" >,
	apsnote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apsnote#" >,
	orbankl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.orbankl#" >,
	orbankj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.orbankj#" >,
	orbranl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.orbranl#" >,
	orbranj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.orbranj#" >,
	oraccnol = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oraccnol#" >,
	oraccnoj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oraccnoj#" >,
	ornamel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ornamel#" >,
	oridl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oridl#" >,
	oridj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oridj#" >,
	btnuml = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.btnuml#" >,
	btcodel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.btcodel#" >,
	btcodej = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.btcodej#" >,
	rcbankl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcbankl#" >,
	rcbankj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcbankj#" >,
	rcbranl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcbranl#" >,
	rcbranj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcbranj#" >,
	rcnamel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcnamel#" >,
	rcnricl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcnricl#" >,
	rcnricj = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcnricj#" >,
	rcamtl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcamtl#" >,
	rciteml = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rciteml#" >,
	rcpaymodel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcpaymodel#">,
	rcpaymodej = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rcpaymodej#">,
	orrec1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.orrec1#">,
	BTREC1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.BTREC1#">,
	RCREC1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCREC1#">,
	RCREC2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCREC2#">,
	RCREC3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCREC3#">,
	FFREC1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FFREC1#">,
	RCHASH1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCHASH1#">,
	RCHASH2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCHASH2#">,
	RCHASH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RCHASH#">,
	APS_SIZE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aps_size#">,
	APS_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.apsfile#">
	where entryno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entryno#" >
</cfquery>

<cflocation url="/housekeeping/setup/APS_data.cfm?id=#form.entryno#">