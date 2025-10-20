<cfcomponent>
	<cffunction name="toArray" access="public" returntype="array">
		<cfargument name="dts" type="string" required="no">
		<cfargument name="qStr" type="string" required="no" default="">
		<cfargument name="qr" type="query" required="no">
		
		<cfset var getContent="">
		<cfset var field = arraynew(2)>
		<cfset var i = 1>
		<cfif arguments.qStr neq "">
			<cfquery name="getContent" datasource="#arguments.dts#">
				#PreserveSingleQuotes(arguments.qStr)#
			</cfquery>
		<cfelse>
			<cfset getContent=arguments.qr>
		</cfif>		
		<cfloop list="#getContent.columnlist#" index="itm">
			<cfset field [i][1] = itm>
			<cfset field [i][2] = evaluate("getContent.#itm#")>
			<cfset i=i+1>
		</cfloop>

		<cfreturn field>
	</cffunction>
	
	<cffunction name="toList" access="public" returntype="string">
		<cfargument name="dts" type="string" required="no" default="">
		<cfargument name="qStr" type="string" required="no" default="">
		<cfargument name="qr" type="query" required="no" default="">
		
		<cfset var arrData = "">
		<cfset var arr = arrayNew(1)>
		<cfinvoke method="toArray" dts="#arguments.dts#" qStr="#arguments.qStr#" qr="#arguments.qr#" returnvariable="arrData" />
		<cfloop from="1" to="#arrayLen(arrData)#" index="i"><cfset Arrayappend(arr,"#arrData[i][1]#=#arrData[i][2]#")></cfloop>
		
		<cfreturn arraytolist(arr," ||")>
	</cffunction>
	
	<cffunction name="compareArray" access="public" returntype="struct">
		<cfargument name="oldArray" type="array" required="yes">
		<cfargument name="newArray" type="array" required="yes">
		
		<cfset var dataStruct = structNew()>
		<cfset var oldValue = arrayNew(1)>
		<cfset var newValue = arrayNew(1)>
		<cfset var arLen = arrayLen(oldArray)>
		<cfset dataStruct.errors="">
		
		<cfif arLen eq arrayLen(newArray)>
			<cfloop from="1" to="#arLen#" index="i">
				<cfif oldArray[i][2] neq newArray[i][2]>
					<cfset Arrayappend(oldValue,"#oldArray[i][1]#=#oldArray[i][2]#")>
					<cfset Arrayappend(newValue,"#newArray[i][1]#=#newArray[i][2]#")>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset dataStruct.oldValue="#arLen#">
			<cfset dataStruct.newValue="#arrayLen(newArray)#">
			<cfset dataStruct.errors="Array Len is mismatch.">
		</cfif>
		<cfset dataStruct.oldValue=arraytolist(oldValue," ||")>
		<cfset dataStruct.newValue=arraytolist(newValue," ||")>
		<cfreturn dataStruct>
	</cffunction>
	
	<cffunction name="createAuditFrmUpdate" access="public" output="false">
		<cfargument name="dts" type="string" required="yes">
		<cfargument name="act" type="string" required="yes">
		<cfargument name="user" type="string" required="yes">
		<cfargument name="module" type="string" required="yes">
		<cfargument name="pointer" type="string" required="yes">
		<cfargument name="oldArray" type="array" required="yes">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="qStr" type="string" required="no" default="">
		<cfargument name="qr" type="query" required="no">
		<cfargument name="process_id" type="string" required="no" default="">
		
		<cfset var sData = structNew()>
		<cfset var array_nv = "">
		<cfif qStr neq "">
			<cfinvoke method="toArray" dts="#arguments.dts#" qStr="#arguments.qStr#" returnvariable="array_nv"/>
		<cfelse>
			<cfinvoke method="toArray" qr="#arguments.qr#" returnvariable="array_nv"/>
		</cfif>
		<cfinvoke method="compareArray" oldArray="#arguments.oldArray#" newArray="#array_nv#" returnvariable="sData"/>
		<cfif sData.errors neq "" or (sData.oldValue neq "" and sData.newValue neq "")>
			<cfinvoke method="createAudit">
				<cfinvokeargument name="dts" value="#arguments.dts#">
				<cfinvokeargument name="act" value="#arguments.act#">
				<cfinvokeargument name="user" value="#arguments.user#">
				<cfinvokeargument name="module" value="#arguments.module#">
				<cfinvokeargument name="pointer" value="#arguments.pointer#">
				<cfinvokeargument name="oldValue" value="#sData.oldValue#">
				<cfinvokeargument name="newValue" value="#sData.newValue#">
				<cfinvokeargument name="comment" value="#IIF(sData.errors neq "",DE(sData.errors),DE(arguments.comment))#">
				<cfinvokeargument name="process_id" value="#arguments.process_id#">
			</cfinvoke>
		</cfif>
	</cffunction>
	
	<cffunction name="createAuditFrmDelete" access="public" output="false">
		<cfargument name="dts" type="string" required="yes">
		<cfargument name="act" type="string" required="yes">
		<cfargument name="user" type="string" required="yes">
		<cfargument name="module" type="string" required="yes">
		<cfargument name="pointer" type="string" required="yes">
		<cfargument name="newValue" type="string" required="no" default="">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="dataQr" type="query" required="no" default="">
		<cfargument name="process_id" type="string" required="no" default="">
		
		<cfset var listData = "">
				
		<cfinvoke method="toList" dts="#arguments.dts#" qStr="" qr="#arguments.dataQr#" returnvariable="listData" />
		<cfinvoke method="createAudit">
			<cfinvokeargument name="dts" value="#arguments.dts#">
			<cfinvokeargument name="act" value="#arguments.act#">
			<cfinvokeargument name="user" value="#arguments.user#">
			<cfinvokeargument name="module" value="#arguments.module#">
			<cfinvokeargument name="pointer" value="#arguments.pointer#">
			<cfinvokeargument name="oldValue" value="#listData#">
			<cfinvokeargument name="newValue" value="#arguments.newValue#">
			<cfinvokeargument name="comment" value="#arguments.comment#">
			<cfinvokeargument name="process_id" value="#arguments.process_id#">
		</cfinvoke>
	</cffunction>
	
	<cffunction name="createAudit" access="public" output="false">
		<cfargument name="dts" type="string" required="yes">
		<cfargument name="act" type="string" required="yes">
		<cfargument name="user" type="string" required="yes">
		<cfargument name="module" type="string" required="yes">
		<cfargument name="pointer" type="string" required="yes">
		<cfargument name="oldValue" type="string" required="no" default="">
		<cfargument name="newValue" type="string" required="no" default="">
		<cfargument name="comment" type="string" required="no" default="">
		<cfargument name="process_id" type="string" required="no" default="">
		
		<cfset var insertData="">
		<cfquery name="insertData" datasource="#arguments.dts#">
			insert into audit_trail (date,action,user,module,pointer,old_value,new_value,comment,process_id) 
			values 
			(
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.act#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pointer#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldValue#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newValue#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_id#">
			)
		</cfquery>
	</cffunction>
</cfcomponent>