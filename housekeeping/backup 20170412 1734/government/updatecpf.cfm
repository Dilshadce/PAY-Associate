<cfquery name="emptyrng" datasource="#dts#">
drop table rngtable
</cfquery>
<cfif HuserCcode eq 'MY'>
<cfquery name="createnew" datasource="#dts#">
create table rngtable like emptym_p.rngtable
</cfquery>
<cfquery name="movenew" datasource="#dts#">
INSERT INTO rngtable SELECT * FROM emptym_p.rngtable
</cfquery>
<cfelse>
<cfquery name="createnew" datasource="#dts#">
create table rngtable like empty_p.rngtable
</cfquery>
<cfquery name="movenew" datasource="#dts#">
INSERT INTO rngtable SELECT * FROM empty_p.rngtable
</cfquery>
</cfif>
<script type="text/javascript">
alert('Update Success!');
window.location.href="cpftablemain.cfm";
</script>