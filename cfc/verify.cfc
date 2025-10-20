<cfcomponent>
	<CFFUNCTION NAME="VerifyDSN" RETURNTYPE="boolean">
<CFARGUMENT NAME="dsn" TYPE="string" REQUIRED="yes">

<CFSET var dsService="">
<CFSET var result="true">

<CFTRY>
<CFOBJECT ACTION="CREATE"
TYPE="JAVA"
CLASS="coldfusion.server.ServiceFactory"
NAME="factory">
<CFSET dsService=factory.getDataSourceService()>
<CFSET result=dsService.verifyDatasource(dsn)>
     <CFCATCH TYPE="any">
     <CFSET result="false">
     </CFCATCH>
</CFTRY>

<CFRETURN result>
</CFFUNCTION>

</cfcomponent>