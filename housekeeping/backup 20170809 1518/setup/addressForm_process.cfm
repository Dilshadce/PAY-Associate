<cfoutput>

<cfquery name="addUpdate_qry" datasource="#dts#">
UPDATE address 
			SET	  	
			<cfif org_type eq "bank">
					org_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_name#" >,
					org_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_code#" >,
					bran_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_name#" >,
					bran_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_code#" >,
					addr1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr1#" >,
					addr2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr2#" >,
					addr3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr3#" >,
					addr4 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr4#" >,
					addr5 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr5#" >,
					
					encryptdir 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.encryptdir#" >,
					com_accno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_accno#" >,
					com_stcode 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_stcode#" >,
					com_name_f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name_f#" >,
					com_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name#" >,
					com_id 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_id#" >,
					com2_id 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com2_id#" >,
					
					<!---com_fileno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_fileno#" >,
					epf_bcode	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_bcode#" >,
					epf_baccno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_baccno#" >,--->
					
					aps_num 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.aps_num#" >,
					aps_file 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aps_file#" >,
					rc_figf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_figf#" >,
					rc_fig2f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig2f#" >,
					rc_fig3f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig3f#" >,
					rc_fig4f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig4f#" >,
					
					pm_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_name#" >,
					pm_nric 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_nric#" >,
					pm_post 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_post#" >,
					pm_tel 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_tel#" >,
					pm_fax 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_fax#" >,
					pm_email 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_email#" >
			
			<cfelseif org_type eq "EPF" or org_type eq "CPF">
					org_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_name#" >,
					org_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_code#" >,
					bran_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_name#" >,
					bran_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_code#" >,
					addr1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr1#" >,
					addr2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr2#" >,
					addr3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr3#" >,
					addr4 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr4#" >,
					addr5 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr5#" >,
					
					encryptdir 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.encryptdir#" >,
					<!---com_accno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_accno#" >,--->
					com_stcode 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_stcode#" >,
					com_name_f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name_f#" >,
					com_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name#" >,
					com_id 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_id#" >,
					com2_id 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com2_id#" >,
					
					com_fileno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_fileno#" >,
					epf_bcode	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_bcode#" >,
					epf_baccno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_baccno#" >,
					
					aps_num 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.aps_num#" >,
					aps_file 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aps_file#" >,
					rc_figf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_figf#" >,
					rc_fig2f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig2f#" >,
					rc_fig3f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig3f#" >,
					rc_fig4f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig4f#" >,
					
					pm_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_name#" >,
					pm_nric 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_nric#" >,
					pm_post 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_post#" >,
					pm_tel 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_tel#" >,
					pm_fax 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_fax#" >,
					pm_email 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_email#" >
					
			<cfelseif org_type eq "TAX">	
					org_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_name#" >,
					org_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_code#" >,
					bran_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_name#" >,
					bran_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_code#" >,
					addr1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr1#" >,
					addr2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr2#" >,
					addr3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr3#" >,
					addr4 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr4#" >,
					addr5 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr5#" >,
					
					encryptdir 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.encryptdir#" >,
					com_accno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_accno#" >,
					com_stcode 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_stcode#" >,
					com_name_f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name_f#" >,
					com_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name#" >,
					com_id 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_id#" >,
					com2_id 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com2_id#" >,
					
					com_fileno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_fileno#" >,
					epf_bcode	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_bcode#" >,
					epf_baccno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_baccno#" >,
					
					aps_num 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.aps_num#" >,
					aps_file 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aps_file#" >,
					rc_figf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_figf#" >,
					rc_fig2f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig2f#" >,
					rc_fig3f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig3f#" >,
					rc_fig4f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig4f#" >,
					
					pm_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_name#" >,
					pm_nric 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_nric#" >,
					pm_post 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_post#" >,
					pm_tel 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_tel#" >,
					pm_fax 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_fax#" >,
					pm_email 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_email#" >
					
			<cfelse>
					org_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_name#" >,
					org_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_code#" >,
					bran_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_name#" >,
					bran_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bran_code#" >,
					addr1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr1#" >,
					addr2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr2#" >,
					addr3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr3#" >,
					addr4 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr4#" >,
					addr5 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.addr5#" >,
					
					encryptdir 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.encryptdir#" >,
					<!---com_accno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_accno#" >,
					com_stcode 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_stcode#" >,--->
					com_name_f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name_f#" >,
					com_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_name#" >,
					com_id 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_id#" >,
					com2_id 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com2_id#" >,
					
					<!---com_fileno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.com_fileno#" >,
					epf_bcode	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_bcode#" >,
					epf_baccno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.epf_baccno#" >,--->
					
					aps_num 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.aps_num#" >,
					aps_file 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.aps_file#" >,
					rc_figf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_figf#" >,
					rc_fig2f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig2f#" >,
					rc_fig3f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig3f#" >,
					rc_fig4f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rc_fig4f#" >,
					
					pm_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_name#" >,
					pm_nric 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_nric#" >,
					pm_post 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_post#" >,
					pm_tel 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_tel#" >,
					pm_fax 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_fax#" >,
					pm_email 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pm_email#" >
			
			</cfif>
								
			WHERE  	refno 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.refno#" >
			AND		org_type 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.org_type#" >
			AND		category 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.category#" >

	
	
	
</cfquery>
<!---<cflocation url="/housekeeping/setup/addressMain.cfm">
---></cfoutput>

<!---cfquery name="addressUpdate" datasource="#getDSN()#" >
			UPDATE address
			SET	  	org_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.org_name#" >,
					org_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.org_code#" >,
					bran_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.bran_name#" >,
					bran_code 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.bran_code#" >,
					addr1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.addr1#" >,
					addr2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.addr2#" >,
					addr3 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.addr3#" >,
					addr4 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.addr4#" >,
					addr5 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.addr5#" >,
					
					encryptdir 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.encryptdir#" >,
					com_accno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_accno#" >,
					com_stcode 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_stcode#" >,
					com_name_f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_name_f#" >,
					com_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_name#" >,
					com_id 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_id#" >,
					com2_id 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com2_id#" >,
					com_fileno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.com_fileno#" >,
					epf_bcode	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.epf_bcode#" >,
					epf_baccno	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.epf_baccno#" >,
					aps_num 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.addressData.aps_num#" >,
					aps_file 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.aps_file#" >,
					rc_figf 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.rc_figf#" >,
					rc_fig2f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.rc_fig2f#" >,
					rc_fig3f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.rc_fig3f#" >,
					rc_fig4f 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.rc_fig4f#" >,

					pm_name 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_name#" >,
					pm_nric 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_nric#" >,
					pm_post 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_post#" >,
					pm_tel 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_tel#" >,
					pm_fax 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_fax#" >,
					pm_email 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.pm_email#" >
					
			WHERE  	refno 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.addressData.refno#" >
			AND		org_type 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.org_type#" >
			AND		category 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressData.category#" >
</cfquery---> 		 