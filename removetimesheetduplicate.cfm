<!---this cfm is used to remove duplicated record in manpowertest_p.timesheet, [20170316, Alvin]--->

<cfoutput>

	<cfquery name="getDuplicate" datasource="manpowertest_p">
    	SELECT a.*, count(*) AS count FROM
        (SELECT empno, placementno, pdate, updated_on FROM manpowertest_p.timesheet
        ORDER BY updated_on desc
        )AS a group by pdate, empno, placementno
        HAVING count(*) > 1
    </cfquery>
    
    <cfloop query="getDuplicate">
    	<cfquery name="deleteDuplicate" datasource="manpowertest_p">
        	DELETE FROM timesheet
            WHERE pdate = "#dateformat(getDuplicate.pdate, 'yyyy-mm-dd')#"
            AND placementno = "#getDuplicate.placementno#"
            AND empno = "#getDuplicate.empno#"
            AND updated_on < "#getDuplicate.updated_on#"
        </cfquery>
    </cfloop>
    
        <cfloop query="getDuplicate">
            <cfset limit1 = #val(getDuplicate.count)# - 1>
            <cfquery name="deleteEqualDuplicate" datasource="manpowertest_p">
                DELETE FROM timesheet
                WHERE pdate = "#dateformat(getDuplicate.pdate, 'yyyy-mm-dd')#"
                AND placementno = "#getDuplicate.placementno#"
                AND empno = "#getDuplicate.empno#"
                AND updated_on = "#getDuplicate.updated_on#"
                LIMIT #limit1#
            </cfquery>
        </cfloop>    

</cfoutput>
