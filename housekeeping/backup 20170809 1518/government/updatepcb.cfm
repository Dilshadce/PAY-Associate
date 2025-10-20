<cfquery name="emptyrng" datasource="#dts#">
drop table pcbtable
</cfquery>

<cfquery name="createnew" datasource="#dts#">
create table pcbtable like emptym_p.pcbtable
</cfquery>

<cfquery name="movenew" datasource="#dts#">
INSERT INTO pcbtable SELECT * FROM emptym_p.pcbtable
</cfquery>

<script type="text/javascript">
alert('Update Success!');
window.location.href="LHDNtablemain.cfm";
</script>