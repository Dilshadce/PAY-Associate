<!--- 
*** Sample ***
fmt_qry = createObject("component", "extensions.utility.formating").row2column(unfmt_qry);
<cfoutput query="fmt_qry">
	#fmt_qry.cHeader# // Column Name
	...
</cfoutput>
 --->
<cfcomponent>
	<cffunction name="row2column" access="public" returntype="query">
		<cfargument name="qry" type="query" required="yes">
		
		<cfscript>
			var x=0; var y=0;
			var headerList = ArrayToList(qry.getColumnList());
			var headerArray = ListToArray(headerList);
			var dataArray = arrayNew(1);
			var temp = "";
			var myQuery = QueryNew("");

			temp = ArrayDeleteAt(headerArray,1);
			
			for(x=1; x LTE qry.RecordCount; x=x+1){
				for(y=2; y LTE ListLen(headerList); y=y+1){
					dataArray[y-1] = evaluate("qry.#listgetat(headerList,y)#[#x#]");
				}
				temp = QueryAddColumn(myQuery, "C#evaluate("qry.#listgetat(headerList,1)#[#x#]")#",dataArray);
	  			temp = ArrayClear(dataArray);
			}
			temp = QueryAddColumn(myQuery, "CHeader", headerArray);
		</cfscript>
		<cfreturn myQuery>
	</cffunction>
</cfcomponent>