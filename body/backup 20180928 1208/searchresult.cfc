<cfcomponent>
<cfsetting showdebugoutput="no">
<cffunction name="listSearchResult" access="remote" returntype="struct">
	<cfset husergrpid=form.husergrpid>
	<cfset dts=form.dts>
	<cfset category=form.category>
	<cfset attribute=form.attribute>
	<cfset operator=form.operator>
	<cfset keyword=form.keyword>
	
	<cfif category EQ "transaction">
		<cfset table="glpost">
		<cfset index="entry">
		<cfset columns="entry,batchno,tranno,fperiod,date,accno,CONCAT(desp,' ',despa,' ',despb,' ',despc,' ',despd,' ',despe) AS desp,reference,refno,job,debitamt,creditamt">
        <cfset conditions="AND fperiod<>99">
	<cfelseif category EQ "customer">
		<cfset table="arcust">
		<cfset index="custno">
		<cfset columns="custno,CONCAT(name,' ',name2) AS name,add1,add2,add3,add4,CONCAT(add1,' ',add2,' ',add3,' ',add4) AS address,country,postalcode,attn,e_mail,web_site,CONCAT(phone,' ',phonea,' ',dphone) AS phone,phone AS phone1,phonea,dphone,CONCAT(fax,' ',dfax) AS fax,fax AS fax1,dfax,contact,currcode AS currency,bankaccno,date">
        <cfset conditions="">
	<cfelseif category EQ "supplier">
		<cfset table="apvend">
		<cfset index="custno">
		<cfset columns="custno,CONCAT(name,' ',name2) AS name,add1,add2,add3,add4,CONCAT(add1,' ',add2,' ',add3,' ',add4) AS address,country,postalcode,attn,e_mail,web_site,CONCAT(phone,' ',phonea,' ',dphone) AS phone,phone AS phone1,phonea,dphone,CONCAT(fax,' ',dfax) AS fax,fax AS fax1,dfax,contact,currcode AS currency,bankaccno,date">
        <cfset conditions="">
	</cfif>
	
	<cfif attribute EQ "date">
		<cfset dd=DateFormat(keyword,"DD")>  
  		<cfif dd GT '12'>
   			<cfset keyword=DateFormat(keyword,"YYYY-MM-DD")>
  		<cfelse>
   			<cfset keyword=DateFormat(keyword,"YYYY-DD-MM")>
 		 </cfif>
	</cfif>
	<cfif attribute EQ "desp">
		<cfset attribute="CONCAT(desp,' ',despa,' ',despb,' ',despc,' ',despd,' ',despe)">
	</cfif>
	<cfif attribute EQ "name">
		<cfset attribute="CONCAT(name,' ',name2)">
	</cfif>
	<cfif attribute EQ "address">
		<cfset attribute="CONCAT(add1,' ',add2,' ',add3,' ',add4)">
	</cfif>
	<cfif attribute EQ "phone">
		<cfset attribute="CONCAT(phone,' ',phonea,' ',dphone)">
	</cfif>
	<cfif attribute EQ "fax">
		<cfset attribute="CONCAT(fax,' ',dfax)">
	</cfif>
	
	<cfif operator EQ "contain">
		<cfset operator="LIKE">
		<cfset keyword="%"&keyword&"%">
	<cfelseif operator EQ "notContain">
		<cfset operator="NOT LIKE">		
		<cfset keyword="%"&keyword&"%">
	<cfelseif operator EQ "equalTo">
		<cfset operator="=">
	<cfelseif operator EQ "notEqualTo">
		<cfset operator="!=">
	<cfelseif operator EQ "greaterThan" OR operator EQ "after">
		<cfset operator=">">
	<cfelseif operator EQ "lessThan" OR operator EQ "before">
		<cfset operator="<">
	<cfelseif operator EQ "greaterEqual" OR operator EQ "afterEqual">
		<cfset operator=">=">
	<cfelseif operator EQ "lessEqual" OR operator EQ "beforeEqual">
		<cfset operator="<=">
	</cfif>
		
	<cfset sLimit="">
	<cfif IsDefined("form.iDisplayStart") AND form.iDisplayLength NEQ "-1">
		<cfset sLimit="LIMIT "&form.iDisplayStart&","&form.iDisplayLength>
	</cfif>		
	
	<cfset sOrder="">
	<cfif IsDefined("form.iSortCol_0")>
		<cfset sOrder="ORDER BY ">
		<cfloop from="0" to="#form.iSortingCols-1#" index="i" step="1">
			<cfif Evaluate('form.bSortable_'&Evaluate('form.iSortCol_'&i)) EQ "true">
				<cfset sOrder=sOrder&Evaluate('form.mDataProp_'&Evaluate('form.iSortCol_'&i))>
				<cfif Evaluate('form.sSortDir_'&i) EQ "asc">
					<cfset sOrder=sOrder&" ASC,">
				<cfelse>
					<cfset sOrder=sOrder&" DESC,">
				</cfif>
			</cfif>
		</cfloop>
		<cfset sOrder=Left(sOrder,Len(sOrder)-1)>
		<cfif sOrder EQ "ORDER BY">
			<cfset sOrder="">
		</cfif>		
	</cfif>
	
	<cfquery name="getFilteredDataSet" datasource="#dts#">
		SELECT SQL_CALC_FOUND_ROWS #columns#
		FROM #table#
		WHERE #attribute# #operator# <cfqueryparam cfsqltype="cf_sql_varchar" value="#keyword#">
        #conditions#
		#sOrder#
		#sLimit#
	</cfquery>
	<cfquery name="getFilteredDataSetLength" datasource="#dts#">
		SELECT FOUND_ROWS() AS iFilteredTotal
	</cfquery>
	<cfquery name="getTotalDataSetLength" datasource="#dts#">
		SELECT COUNT(#index#) AS iTotal
		FROM #table#
	</cfquery>
	
	<cfset aaData=ArrayNew(1)>
	<cfloop query="getFilteredDataSet">	
		<cfset data=StructNew()>
		<cfif category EQ "transaction">
			<cfset data["batchno"]=batchno>
			<cfset data["tranno"]=tranno>
			<cfset data["fperiod"]=fperiod>
			<cfset data["date"]=DateFormat(date,"DD/MM/YYYY")>
			<cfset data["accno"]=accno>			
			<cfset data["desp"]='<span title="'&desp&'">'&desp&'</span>'>
			<cfset data["reference"]='
				<span title="Reference: '&reference&'
Reference 2: '&refno&'">'&reference&'</span>
			'>
			<cfset data["refno"]=refno>
			<cfset data["job"]=job>
			<cfset data["debitamt"]=debitamt>
			<cfset data["creditamt"]=creditamt>
			<cfset data["custno"]="">
			<cfset data["name"]="">
			<cfset data["address"]="">
			<cfset data["country"]="">
			<cfset data["postalcode"]="">
			<cfset data["attn"]="">
			<cfset data["e_mail"]="">
			<cfset data["web_site"]="">
			<cfset data["phone"]="">
			<cfset data["fax"]="">
			<cfset data["contact"]="">	
			<cfset data["currency"]="">
			<cfset data["bankaccno"]="">
			<cfquery name="getlock" datasource="#dts#">
				SELECT lokstatus 
				FROM glbatch 
				WHERE recno="#batchno#"
			</cfquery>
			<cfset disable=''>
			<cfset title=''>
			<cfif getlock.lokstatus EQ "0">
				<cfset disable='disabled="disabled"'>
				<cfset title='title="This transaction''s batch is locked."'>
			<cfelse>				
				<cfquery name="checkarpay" datasource="#dts#">
        			SELECT pay_id 
					FROM arpay 
					WHERE kperiod <> '99' 
					AND (
						billno="#reference#" 
						OR refno="#reference#"
					)
    			</cfquery>
    			<cfquery name="checkappay" datasource="#dts#">
        			SELECT pay_id 
					FROM appay 
					WHERE kperiod <> '99' 
					AND (
						billno="#reference#" 
						OR refno="#reference#"
					)
    			</cfquery>
				<cfif checkarpay.recordcount NEQ 0 OR checkappay.recordcount NEQ 0>				
						<cfset disable='disabled="disabled"'>
						<cfset title='title="This transaction has been knock off."'>
				</cfif>											
			</cfif>
			<cfif husergrpid EQ "super">
				<cfset data["action"]='
					<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(''/transaction/transaction-edit1.cfm?from=GlobalSearch&type=Edit&entry='&URLEncodedFormat(entry)&''',''_self'');" '&disable&' '&title&' ></span>
					<span class="glyphicon glyphicon-remove btn btn-link" onclick="window.open(''/transaction/transaction-delete.cfm?from=GlobalSearch&entry='&URLEncodedFormat(entry)&''',''_self'');" '&disable&' '&title&' ></span>
				'>				
			<cfelse>
				<cfset data["action"]='
					<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(''/transaction/transaction-edit1.cfm?from=GlobalSearch&type=Edit&entry='&URLEncodedFormat(entry)&''',''_self'');" '&disable&' '&title&' ></span>
				'>				
			</cfif>
		<cfelseif category EQ "customer">
			<cfset data["batchno"]="">
			<cfset data["tranno"]="">
			<cfset data["fperiod"]="">
			<cfset data["accno"]="">
			<cfset data["desp"]="">
			<cfset data["reference"]="">
			<cfset data["refno"]="">
			<cfset data["job"]="">
			<cfset data["debitamt"]="">
			<cfset data["creditamt"]="">
			<cfset data["custno"]=custno>
			<cfset data["name"]='
				<a title="'&name&'" href="/Maintenance/statement.cfm?reportType=pdf&custno='&URLEncodedFormat(custno)&'" target="_self">'&name&'</a>
			'>
			<cfset data["address"]='
				<span title="Address:
'&add1&'
'&add2&'
'&add3&'
'&add4&'

Postal Code:
'&postalcode&'

Country:
'&country&'">'&address&'</span>
			'>
			<cfset data["country"]=country>
			<cfset data["postalcode"]=postalcode>
			<cfset data["attn"]=attn>
			<cfset data["e_mail"]=e_mail>
			<cfset data["web_site"]=web_site>
			<cfset data["phone"]='
				<span title="Phone:
'&phone1&'

Phone 2:
'&phonea&'

Delivery Phone:
'&dphone&'">'&phone1&'</span>
			'>
			<cfset data["fax"]='
				<span title="Fax:
'&fax1&'

Delivery Fax:
'&dfax&'">'&fax1&'</span>
			'>
			<cfset data["contact"]=contact>	
			<cfset data["currency"]=currency>
			<cfset data["bankaccno"]=bankaccno>
			<cfset data["date"]=DateFormat(date,"DD/MM/YYYY")>	
			<cfset data["action"]='
				<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(''/maintenance/Customer.cfm?type=Edit&custno='&URLEncodedFormat(custno)&''',''_self'');" ></span>
				<span class="glyphicon glyphicon-remove btn btn-link" onclick="window.open(''/maintenance/Customer.cfm?type=Delete&custno='&URLEncodedFormat(custno)&''',''_self'');" ></span>
			'>		
		<cfelseif category EQ "supplier">
			<cfset data["batchno"]="">
			<cfset data["tranno"]="">
			<cfset data["fperiod"]="">
			<cfset data["accno"]="">
			<cfset data["desp"]="">
			<cfset data["reference"]="">
			<cfset data["refno"]="">
			<cfset data["job"]="">
			<cfset data["debitamt"]="">
			<cfset data["creditamt"]="">
			<cfset data["custno"]=custno>
			<cfset data["name"]='
				<a title="'&name&'" href="/Maintenance/statement.cfm?reportType=pdf&custno='&URLEncodedFormat(custno)&'" target="_self">'&name&'</a>
			'>
			<cfset data["address"]='
				<span title="Address:
'&add1&'
'&add2&'
'&add3&'
'&add4&'

Postal Code:
'&postalcode&'

Country:
'&country&'">'&address&'</span>
			'>
			<cfset data["country"]=country>
			<cfset data["postalcode"]=postalcode>
			<cfset data["attn"]=attn>
			<cfset data["e_mail"]=e_mail>
			<cfset data["web_site"]=web_site>
			<cfset data["phone"]='
				<span title="Phone:
'&phone1&'

Phone 2:
'&phonea&'

Delivery Phone:
'&dphone&'">'&phone1&'</span>
			'>
			<cfset data["fax"]='
				<span title="Fax:
'&fax1&'

Delivery Fax:
'&dfax&'">'&fax1&'</span>
			'>
			<cfset data["contact"]=contact>	
			<cfset data["currency"]=currency>
			<cfset data["bankaccno"]=bankaccno>
			<cfset data["date"]=DateFormat(date,"DD/MM/YYYY")>	
			<cfset data["action"]='
				<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(''/maintenance/Supplier.cfm?type=Edit&custno='&URLEncodedFormat(custno)&''',''_self'');" ></span>
				<span class="glyphicon glyphicon-remove btn btn-link" onclick="window.open(''/maintenance/Supplier.cfm?type=Delete&custno='&URLEncodedFormat(custno)&''',''_self'');" ></span>
			'>
		</cfif>
		<cfset ArrayAppend(aaData,data)>
	</cfloop>
	<cfset output=StructNew()>
	<cfset output["sEcho"]=form.sEcho>
	<cfset output["iTotalRecords"]=getTotalDataSetLength.iTotal>
	<cfset output["iTotalDisplayRecords"]=getFilteredDataSetLength.iFilteredTotal>
	<cfset output["aaData"]=aaData>
	<cfreturn output>
</cffunction>
</cfcomponent>