<cfif isdefined("url.empno")>
<cfquery name="updatepmast" datasource="#dts#">
UPDATE pmast SET
add1 = (SELECT add1 FROM emp_users WHERE empno='#url.empno#'),
add2 = (SELECT add2 FROM emp_users WHERE empno='#url.empno#'),
phone = (SELECT phone FROM emp_users WHERE empno='#url.empno#'),
edu = (SELECT edu FROM emp_users WHERE empno='#url.empno#')
WHERE empno='#url.empno#'
</cfquery>

<cfquery name="updateemp" datasource="#dts#">
UPDATE emp_users SET
changes = 'N'
WHERE
empno = '#url.empno#'
</cfquery>

<cfelseif isdefined("url.cempno")>
<cfquery name="updateemp" datasource="#dts#">
UPDATE emp_users SET
changes = 'N'
WHERE
empno = '#url.cempno#'
</cfquery>
</cfif>
