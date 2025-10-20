

<cfoutput>



 <cfquery name="try" datasource="gaf_p">
select proj_epfcc,proj_epfww from proj_rcd_12m_1 limit 10

</cfquery> 

 <cfquery name="try2" datasource="gaf_p">
select proj_epfcc,proj_epfww from proj_rcd_12m limit 10

</cfquery> 

  <cfdump var="#try#"> 


<cfdump var="#try2#"> 
</cfoutput>
