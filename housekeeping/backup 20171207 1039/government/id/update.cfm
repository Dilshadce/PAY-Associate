 <cfquery name="emptyrng" datasource="#dts#">
drop table rngtable
</cfquery>

<cfquery name="createnew" datasource="#dts#">
create table rngtable like emptyind_p.rngtable
</cfquery>
<cfquery name="movenew" datasource="#dts#">
INSERT INTO rngtable SELECT * FROM emptyind_p.rngtable
</cfquery> 

<script type="text/javascript">
	alert('Update Success!');

<cfif isdefined("url.type") and url.type eq "pph21">
    window.location="pph21tablemain.cfm";
<cfelseif isdefined("url.type") and url.type eq "bpjs">
    window.location="bpjstablemain.cfm";
</cfif> 

</script>
