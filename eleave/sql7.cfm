

<cfquery name="update_MenuURL" datasource="payroll_main">
   UPDATE menu_emp SET link_url ='../../Employee/index.cfm' 
   WHERE user_define ='410000'
</cfquery>

