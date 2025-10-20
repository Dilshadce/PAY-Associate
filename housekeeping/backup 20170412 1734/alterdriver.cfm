<html>
<head></head>
<body>
<!--- <cfquery name="getcompany" datasource="payroll_main">
	SELECT * FROM payroll_dscontrol 
</cfquery>

 <cfloop query="getcompany"> 
	<cfset dts=getcompany.ds_name>--->
	<cftry>
    
	<cfquery name="update" datasource="payroll_main">
        ALTER TABLE `gsetup` 
        ADD COLUMN `claimapproval` VARCHAR(45) NOT NULL DEFAULT 'everyone' AFTER `leavereceived`,
        ADD COLUMN `claimreceived` VARCHAR(45) NOT NULL DEFAULT 'everyone' AFTER `claimapproval`,        
        ADD COLUMN `eclaimapp` VARCHAR(45) NOT NULL DEFAULT 'adminonly' AFTER `eleaveapp`
    </cfquery> 

    
    
	<cfcatch type="any">
    <cfoutput>
    #dts#
    </cfoutput>
	</cfcatch>
	</cftry>
<!--- </cfloop> --->
Finish.
</body>
</html>