<cfquery name="emptyrng" datasource="#dts#">
drop table fwltable
</cfquery>
<cfquery name="createnew" datasource="#dts#">
create table fwltable like empty_p.fwltable
</cfquery>
<cfquery name="movenew" datasource="#dts#">
INSERT INTO fwltable SELECT * FROM empty_p.fwltable
</cfquery>
<script type="text/javascript">
alert('Update Success!');
window.location.href="fwltablemain.cfm";
</script>