<!--- cfwindows for management claim approve--->

<html>
<head>
<title>Claim</title>
</head>
<body>
<cfoutput>

<!--- create claim --->
<cfif isdefined("url.type") and url.type eq "edit" or url.type eq "create">
	
	<cfset posrowid = "">
    <cfset claimdes = "">
    <cfset claimname = "">
    <cfset allowance = "">
    <cfset amountperclaim = "">
    <cfset amountperyear= "">
    <cfset id = "">

    <cfif url.type eq "edit">
    <cfquery name="getposdetail" datasource="#dts#">
    SELECT claimid, claimdes,claimname,allowance,amountperclaim, amountperyear,attachreceipt FROM claim WHERE claimid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
    </cfquery>
    <cfset posrowid = getposdetail.claimid>
    <cfset claimdes = getposdetail.claimdes>
    <cfset claimname = getposdetail.claimname>
    <cfset allowance = getposdetail.allowance>
    <cfset amountperclaim = getposdetail.amountperclaim>
    <cfset amountperyear= getposdetail.amountperyear>
    <cfset id = url.id>
    </cfif>

    <cfform action="/payments/claim/createclaim/process.cfm?type=#url.type#&claimid=id" method="post">


    
     
    <cfinput type="hidden" name="posrowid" id="posrowid" value="#posrowid#">
    <table align="center">
    <tr><br></tr>
    <tr>
    <th>Claim Name</th>
    <td><cfinput type="Text" name="claimname" size="30" required="yes" maxlength="30" message="Claim name is required" value="#claimname#"></td>
    </tr>
    <tr>
    <th>Claim Description</th>
    <td><cfinput type="Text" name="claimdes" size="50" required="yes" maxlength="50" message="Claim description is required" value="#claimdes#"></td>
    </tr>
    <tr>
    <th>Allowance</th>
    <td>
    <cfquery name="getawdetail" datasource="#dts#"	>
        SELECT "" as aw_cou, "Choose an Allowance" as aw_desp
        union all
        SELECT aw_cou,concat(aw_cou," - ",aw_desp) as aw_desp FROM awtable WHERE aw_cou <= 17
    </cfquery>
    <cfselect name="allowance" id="allowance" query="getawdetail" value="aw_cou" display="aw_desp" selected="#allowance#" required="true" message="Allowance is required"></cfselect>
    </td>
    <tr>
    <th>Cap Amount Per Claim</th>
    
    
    <cfif url.type eq "create">
        <cfset amountperclaim = 0>
        <cfset amountperyear = 0>
    </cfif>
    
    <td><cfinput type="Text" name="amountperclaim" size="20" required="yes" validate="range" validateat="onsubmit"  maxlength="12" message="Amount cap per claim is required / Must be within 0 - 99999" value="#amountperclaim#" range="0,100000">Put 0 as unlimited
    </tr> 
    <tr>
    <th>Cap Amount Per Year</th>
    <td><cfinput type="Text" name="amountperyear" size="20" required="yes" validate="range" validateat="onsubmit"  maxlength="12" message="Amount cap per year is required / Must be within 0 - 99999" value="#amountperyear#" range="0,100000">Put 0 as unlimited
    </tr>
    <tr><td /><td>
    <cfif url.type eq "edit" and getposdetail.attachreceipt eq "Yes">
    <input type="checkbox" name="receiptbox" id="receiptbox" checked="Yes">Receipt is compulsory
    
    <cfelse>
    <input type="checkbox" name="receiptbox" id="receiptbox">Receipt is compulsory
    
    </cfif>
    </td></tr>
    
    
    <tr><td /><td><cfinput type="submit" name="sub_btn" id="sub_btn" value="#UCASE(url.type)#" ></td></tr>
     </table>
    </cfform>
      </cfif>






</cfoutput>
</body>
</html>

