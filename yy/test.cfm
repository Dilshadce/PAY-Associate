<cfdump var="#getAuthUser()#">
<cfquery datasource="manpower_p" name="getEmp">
	SELECT empno FROM emp_users where userName = '#getAuthUser()#'
</cfquery>

<cfdump var="#getEmp.empno#" >