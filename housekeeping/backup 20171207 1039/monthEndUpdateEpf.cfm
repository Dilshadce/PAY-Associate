<cfif HuserCcode eq 'MY'> 
    <cfquery name="emptyrng" datasource="#dts#">
        DROP TABLE IF EXISTS rngtable
    </cfquery>
    <cfquery name="createnew" datasource="#dts#">
        CREATE TABLE rngtable LIKE emptym_p.rngtable
    </cfquery>
    <cfquery name="movenew" datasource="#dts#">
        INSERT INTO rngtable SELECT * FROM emptym_p.rngtable
    </cfquery>
</cfif>

<!---<cfelse>
<cfquery name="createnew" datasource="#dts#">
    CREATE TABLE rngtable LIKE empty_p.rngtable
</cfquery>
<cfquery name="movenew" datasource="#dts#">
    INSERT INTO rngtable SELECT * FROM empty_p.rngtable
</cfquery>
</cfif>--->
