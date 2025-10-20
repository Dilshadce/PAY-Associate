<cfsetting showdebugoutput="false"><cfsilent>
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 
<cfset text = URLDECODE(url.text)>
<cfif text neq "">
<cfif lcase(HcomID) eq "kjcpl_i" or lcase(HcomID) eq "mlpl_i" or lcase(HcomID) eq "viva_i" or lcase(HcomID) eq "maven_i" or lcase(HcomID) eq "uniq_i">
	<cfquery name="getitem" datasource="#dts#">
		select itemno, concat(desp,' ',despa) as desp
		from icitem 
		where (nonstkitem<>'T' or nonstkitem is null) 
		<cfif searchtype neq "" and text neq "">
			<cfif searchtype eq "itemno">
				and upper(itemno) like '%#ucase(text)#%'
			<cfelseif searchtype eq "desp">
                <cfloop list="#text#" index="i" delimiters=" ">
                and (upper(desp) like '%#ucase(i)#%' or upper(despa) LIKE '%#ucase(i)#%')
                </cfloop>
			<cfelseif searchtype eq "category">
				and upper(category) like '%#ucase(text)#%'
                <cfelseif searchtype eq "aitemno">
				and upper(aitemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "wos_group">
				and upper(wos_group) like '%#ucase(text)#%'
			<cfelseif searchtype eq "brand">
				and upper(brand) like '%#ucase(text)#%'
			</cfif>
		</cfif>
        <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
		order by itemno
	</cfquery>
<cfelseif lcase(hcomid) eq "vsolutionspteltd_i" or lcase(hcomid) eq "vsyspteltd_i">
<cfquery name="getitem" datasource="#dts#">
		select itemno, concat(aitemno,' - ',desp) as desp
		from icitem 
		where (nonstkitem<>'T' or nonstkitem is null) 
		<cfif searchtype neq "" and text neq "">
			<cfif searchtype eq "itemno">
				and upper(itemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "desp">
				and (upper(desp) like '#ucase(text)#%' or upper(despa) LIKE '%#ucase(text)#%')
			<cfelseif searchtype eq "category">
				and upper(category) like '#ucase(text)#%'
            <cfelseif searchtype eq "aitemno">
				and upper(aitemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "wos_group">
				and upper(wos_group) like '#ucase(text)#%'
			<cfelseif searchtype eq "brand">
				and upper(brand) like '#ucase(text)#%'
			</cfif>
		</cfif>
        <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
		order by itemno
	</cfquery>
<cfelseif lcase(hcomid) eq "sdc_i">
<cfquery name="getitem" datasource="#dts#">
		select itemno, concat(desp,' - ',fcurrcode) as desp
		from icitem 
		where (nonstkitem<>'T' or nonstkitem is null) 
		<cfif searchtype neq "" and text neq "">
			<cfif searchtype eq "itemno">
				and upper(itemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "desp">
				and (upper(desp) like '#ucase(text)#%' or upper(despa) LIKE '%#ucase(text)#%')
			<cfelseif searchtype eq "category">
				and upper(category) like '#ucase(text)#%'
                <cfelseif searchtype eq "aitemno">
				and upper(aitemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "wos_group">
				and upper(wos_group) like '#ucase(text)#%'
			<cfelseif searchtype eq "brand">
				and upper(brand) like '#ucase(text)#%'
			</cfif>
		</cfif>
        <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
		order by itemno
	</cfquery>
<cfelse>
<cfquery name="getitem" datasource="#dts#">
		select itemno, desp 
		from icitem 
		where (nonstkitem<>'T' or nonstkitem is null) 
		<cfif searchtype neq "" and text neq "">
			<cfif searchtype eq "itemno">
				and upper(itemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "desp">
				and (upper(desp) like '#ucase(text)#%' or upper(despa) LIKE '%#ucase(text)#%')
                <cfelseif searchtype eq "aitemno">
				and upper(aitemno) like '#ucase(text)#%'
			<cfelseif searchtype eq "category">
				and upper(category) like '#ucase(text)#%'
			<cfelseif searchtype eq "wos_group">
				and upper(wos_group) like '#ucase(text)#%'
			<cfelseif searchtype eq "brand">
				and upper(brand) like '#ucase(text)#%'
			</cfif>
		</cfif>
        <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
		order by itemno
	</cfquery>


</cfif>
	<cfif getitem.recordcount neq 0>
		<cfset itemnolist = valuelist(getitem.itemno,";;")>
		<cfset itemdesclist = valuelist(getitem.desp,";;")>
	<cfelse>
		<cfset itemnolist = "-1">
		<cfset itemdesclist = "No Record Found">
	</cfif>
<cfelse>
	<cfset itemnolist = "-1">
	<cfset itemdesclist = "Please Filter The Item">
</cfif>

<cfset header = "count|error|msg|itemnolist|itemdesclist">
<cfset value = "1|0|0|#URLEncodedFormat(itemnolist)#|#URLEncodedFormat(itemdesclist)##tabchr#">	
</cfsilent><cfif isdefined('url.new') eq false><cfoutput>#header##tabchr##value#</cfoutput><cfelse><cfsetting showdebugoutput="no"><cfoutput>
<select id="#url.itemno#" name='#url.itemno#' onChange="showImage(this.value);">
<cfif itemnolist eq "-1">
<option value="-1">#itemdesclist#</option>
<cfelse>
<cfloop query="getitem">
<option value="#getitem.itemno#">#getitem.itemno# - #getitem.desp#</option>
</cfloop>
</cfif>
</select>
</cfoutput></cfif>