<cfset status="">
<cfif isdefined("url.type")>
	<cfif url.type eq "empno"> <!--- For Update Employee Number --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select empno from pmast
			where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">;
		</cfquery>
		<cfif check_exist_qry.recordcount>
			<cfset status=false>
			<cfset status_msg="This Employee Number (#form.nempno#) Existed in System. Please try use other employee number again.">
		<cfelse>
		 <cftry> <!------>
			<cfquery name="change_empno_qry" datasource="#dts#">
				update pmast
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
            
            <cfquery name="changeap8a" datasource="#dts#">
            	Update ap8a
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
             <cfquery name="changeap8b" datasource="#dts#">
            	Update ap8b
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
            
            
			<cfquery name="change_empno_adv_h1_qry" datasource="#dts#">
				update adv_h1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_adv_h2_qry" datasource="#dts#">
				update adv_h2
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_bonu_12m_qry" datasource="#dts#">
				update bonu_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_bonus_qry" datasource="#dts#">
				update bonus
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_comm_qry" datasource="#dts#">
				update comm
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_comm_12m_qry" datasource="#dts#">
				update comm_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			
			<cfquery name="change_empno_emp_users_qry" datasource="#dts#">
				update emp_users
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_emphist_qry" datasource="#dts#">
				update emphist
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
		<!--- 	<cfquery name="change_empno_emp_users_log_qry" datasource="#dts#">
				update emp_users_log
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery> --->
			<cfquery name="change_empno_extr_12m_qry" datasource="#dts#">
				update extr_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_extra_qry" datasource="#dts#">
				update extra
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_hbce_qry" datasource="#dts#">
				update hbce
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_hbce_12m_qry" datasource="#dts#">
				update hbce_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_itaxea_qry" datasource="#dts#">
				update itaxea
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_itaxea2_qry" datasource="#dts#">
				update itaxea2
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_leave_apl_qry" datasource="#dts#">
				update leave_apl
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_loanmst_qry" datasource="#dts#">
				update loanmst
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			
			
			<cfquery name="change_empno_moretr1_qry" datasource="#dts#">
				update moretr1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_moretra_qry" datasource="#dts#">
				update moretra
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<!--- <cfquery name="change_empno_new1_qry" datasource="#dts#">
				update new1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery> --->
			<cfquery name="change_empno_ot_record_qry" datasource="#dts#">
				update ot_record
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay_12m_qry" datasource="#dts#">
				update pay_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay_tm_qry" datasource="#dts#">
				update pay_tm
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay_ytd_qry" datasource="#dts#">
				update pay_ytd
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay1_12m_qry" datasource="#dts#">
				update pay1_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay1_12m_fig_qry" datasource="#dts#">
				update pay1_12m_fig
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pay1_12m_fig_qry" datasource="#dts#">
				update pay2_12m_fig
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_paynot1_qry" datasource="#dts#">
				update paynot1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_paynote_qry" datasource="#dts#">
				update paynote
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_paytra1_qry" datasource="#dts#">
				update paytra1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_paytran_qry" datasource="#dts#">
				update paytran
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek1_qry" datasource="#dts#">
				update payweek1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek2_qry" datasource="#dts#">
				update payweek2
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek3_qry" datasource="#dts#">
				update payweek3
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek4_qry" datasource="#dts#">
				update payweek4
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek5_qry" datasource="#dts#">
				update payweek5
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_payweek6_qry" datasource="#dts#">
				update payweek6
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pleave_qry" datasource="#dts#">
				update pleave
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_pay_qry" datasource="#dts#">
				update proj_pay
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_pay_12m_qry" datasource="#dts#">
				update proj_pay_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_rcd_qry" datasource="#dts#">
				update proj_rcd
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_rcd_1_qry" datasource="#dts#">
				update proj_rcd_1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_rcd_12m_qry" datasource="#dts#">
				update proj_rcd_12m
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_proj_rcd_12m_1_qry" datasource="#dts#">
				update proj_rcd_12m_1
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_pwork_qry" datasource="#dts#">
				update pwork
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_temp_cuz_payslip_qry" datasource="#dts#">
				update temp_cuz_payslip
				set empl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empl=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
			<cfquery name="change_empno_wdtable_qry" datasource="#dts#">
				update wdtable
				set empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
			</cfquery>
            
             <cfquery name="changeap8b" datasource="#dts#">
            	Update pcb_12m
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
             <cfquery name="changeap8b" datasource="#dts#">
            	Update pcb2table
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
            <cfquery name="changeap8b" datasource="#dts#">
            	Update cp22a
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
             <cfquery name="changeap8b" datasource="#dts#">
            	Update eatable
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
            <cfquery name="changeap8b" datasource="#dts#">
            	Update ectable
                SET
                empno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nempno#">
				where empno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oempno#">
            </cfquery>
            
            
            
			
			<cfset status_msg="Successfully Change Employee Number (#form.nempno#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Employee Number (#form.nempno#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>
	</cfif>
	
	<cfif url.type eq "category"><!--- For Change Category --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select category from category
			where category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ncategory#">;
		</cfquery>
		
		<cfif check_exist_qry.recordcount>
		<cfset status=false>
		<cfset status_msg="This Category (#form.ncategory#) Existed in System. Please try use other category again.">
		<cfelse>
		<cftry>
			<cfquery name="change_category_qry" datasource="#dts#">
				update category
				set category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ncategory#">
				where category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ocategory#">
			</cfquery>
			<cfquery name="change_category_pmast_qry" datasource="#dts#">
				update pmast
				set category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ncategory#">
				where category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ocategory#">
			</cfquery>
			<cfset status_msg="Successfully Change Category (#form.ncategory#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Category (#form.category#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>

	</cfif>
	
		<cfif url.type eq "deptcode"><!--- For Change deptcode --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select deptcode from dept
			where deptcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ndeptcode#">;
		</cfquery>
		
		<cfif check_exist_qry.recordcount>
		<cfset status=false>
		<cfset status_msg="This Department (#form.ndeptcode#) Existed in System. Please try use other department again.">
		<cfelse>
		<cftry>
			<cfquery name="change_deptcode_qry" datasource="#dts#">
				update dept
				set deptcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ndeptcode#">
				where deptcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.odeptcode#">
			</cfquery>
			<cfquery name="change_deptcode_pmast_qry" datasource="#dts#">
				update pmast
				set deptcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ndeptcode#">
				where deptcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.odeptcode#">
			</cfquery>
	
			<cfset status_msg="Successfully Change Department (#form.ndeptcode#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Department (#form.odeptcode#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>

	</cfif>
	
	<cfif url.type eq "lineno"><!--- For Change lineno --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select lineno from tlineno
			where lineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nlineno#">;
		</cfquery>
		
		<cfif check_exist_qry.recordcount>
		<cfset status=false>
		<cfset status_msg="This Line No (#form.nlineno#) Existed in System. Please try use other line no again.">
		<cfelse>
		<cftry>
			<cfquery name="change_lineno_qry" datasource="#dts#">
				update tlineno
				set lineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nlineno#">
				where lineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.olineno#">
			</cfquery>
			<cfquery name="change_lineno_pmast_qry" datasource="#dts#">
				update pmast
				set plineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nlineno#">
				where plineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.olineno#">
			</cfquery>
			
			<cfset status_msg="Successfully Change Line No (#form.nlineno#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Line No (#form.olineno#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>

	</cfif>
	
	<cfif url.type eq "brcode"><!--- For Change brcode --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select brcode from branch
			where brcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nbrcode#">;
		</cfquery>
		
		<cfif check_exist_qry.recordcount>
		<cfset status=false>
		<cfset status_msg="This Branch (#form.nbrcode#) Existed in System. Please try use other branch again.">
		<cfelse>
		<cftry>
			<cfquery name="change_brcode_qry" datasource="#dts#">
				update branch
				set brcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nbrcode#">
				where brcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.obrcode#">
			</cfquery>
			<cfquery name="change_brcode_pmast_qry" datasource="#dts#">
				update pmast
				set brcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nbrcode#">
				where brcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.obrcode#">
			</cfquery>
			<cfset status_msg="Successfully Change Branch (#form.nbrcode#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Branch (#form.obrcode#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>

	</cfif>
	
		<cfif url.type eq "project"><!--- For Change project --->
		<cfquery name="check_exist_qry" datasource="#dts#">
			select project from project
			where project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">;
		</cfquery>
		
		<cfif check_exist_qry.recordcount>
		<cfset status=false>
		<cfset status_msg="This Branch (#form.nproject#) Existed in System. Please try use other project id again.">
		<cfelse>
		<cftry>
			<cfquery name="change_project_qry" datasource="#dts#">
				update project
				set project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_pmast_qry" datasource="#dts#">
				update pmast
				set source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_pay_qry" datasource="#dts#">
				update proj_pay
				set project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_pay_12m_qry" datasource="#dts#">
				update proj_pay_12m
				set project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_rcd_qry" datasource="#dts#">
				update proj_rcd
				set project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_rcd_1_qry" datasource="#dts#">
				update proj_rcd_1
				set project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_rcd_12m_qry" datasource="#dts#">
				update proj_rcd_12m
				set project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			<cfquery name="change_project_proj_rcd_12m_1_qry" datasource="#dts#">
				update proj_rcd_12m_1
				set project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nproject#">
				where project_code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.oproject#">
			</cfquery>
			
			<cfset status_msg="Successfully Change Project ID (#form.nproject#)">
			<cfcatch type="database">
			<cfset status=false>
					<cfset status_msg="Fail to Change Project ID (#form.oproject#). Error Message : #cfcatch.Detail#">
			</cfcatch>
		</cftry>
		</cfif>

	</cfif>


		<cfoutput><form name="pc" action="/housekeeping/fileReOrganisation/change#url.type#Main.cfm" method="post"></cfoutput>
		<cfoutput><input type="hidden" name="status" value="#status_msg#" /></cfoutput>
		<cfoutput></form></cfoutput>
		<script>
			pc.submit();
		</script>

	
</cfif>