<cfif isdefined('form.pno')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT * FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfif getempno.empno neq get_comp.empno>
<cfabort>
</cfif>
</cfif>
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<script src="/javascripts/CalendarControl.js" language="javascript"></script>
<script type="text/javascript" src="/javascripts/ajax.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-3.1.1.min.js"></script> 

<script type="text/javascript">

function checkClaim()
{
	<!---added no contract cap bypass, [20170731, Alvin]--->
	if(parseFloat($('#claimamounttxt').val()) > parseFloat($('#pervisitcap').val()))
	{
		return false;	
	}
	<cfif #HCOMID# EQ "manpowertest">
	else
	if($('#contractcap').val() == 0 && $('#contractcap').val() != "")
	{
		return true;	
	}
	</cfif>
	else
	if(parseFloat($('#claimamounttxt').val()) > parseFloat($('#claimbalance').val()))
	{
		return false;
	}
	else
	{
		return true;	
	}
	<!---added no contract cap bypass--->
}


function errorClaim(){
	if(parseFloat($('#claimamounttxt').val()) > parseFloat($('#pervisitcap').val()))
	{
		alert("Claim Amount Cannot Be Greater Than Per Visit Cap");
	}
	else
	if(parseFloat($('#claimamounttxt').val()) > parseFloat($('#claimbalance').val()))
	{
		alert("Insufficient Claim Balance!");		
	}
}

</script>

<html>
<head>
<title>Claim</title>
</head>
<body>
<cfset dts = replace(dsname,'_p','_i')>
    <h2>Submit Claim</h2>
<cfif isdefined("url.type") and url.type eq "mcreate">

    <cfoutput>

    <cfquery name="getposdetail" datasource="#dts#">
  		  select * from icgroup ORDER BY wos_group
    </cfquery>
    <cfquery name="getEnt" datasource="#dts#">
  		  SELECT 1=1 
          <cfloop query="getposdetail">
          #getposdetail.wos_group#payable 
          <cfif getposdetail.currentrow neq getposdetail.recordcount>
          ,
          </cfif>
          </cfloop>
          FROM placement WHERE placementno = '#form.pno#'
    </cfquery>
	
    <cfform action="createlist.cfm?type=create" method="post" enctype="multipart/form-data" >
    <table><tr><td>
    <cfinput type="text" id="pno" name="pno" value="#form.pno#" hidden>
    <cfselect name="postid" id="postid" required="yes" message="Claim is Required">
       <cfloop query="getposdetail">
       <!---  <cfif evaluate("getent['#getposdetail.wos_group#payable'][1]") eq "Y">  --->
            <option value="#getposdetail.wos_group#">#getposdetail.wos_group# - #getposdetail.desp#</option>
        <!--- </cfif> --->
        </cfloop>
    </cfselect>
    <cfinput type="submit" name="submit" id="submit" value="Submit">
    </td></tr></table>
    </cfform>
    </cfoutput>
</cfif>

<cfoutput>
<cfif isdefined("url.type") and url.type eq "create" or url.type eq "edit">

	<cfset claimid = "">
    <cfset id = "">
	<cfset claimdes = "">
    <cfset claimname = "">
	<cfset claimamount = "">
    <cfset remarks = "">
    <cfset receipt_no = "">
    <cfset receipt = "">
    <cfset doc_no = "">
    <cfset claim_date = "">
    <cfset attachreceipt = "">
	<cfset amountperclaim = "">
    <cfset amountperyear = "">
    <cfset totalclaim = "">
    <cfset claimableamount = "">
    <cfset allowance = "">
    <cfset totalclaimed = "">
    <cfset pervisitcap = "">
    <cfset contractcap ="">
    <cfset claimbalance = "">

<cfif isdefined("url.id") >
<cfset id = url.id>
<cfquery name="getjointable" datasource="#dts#">
	SELECT * FROM claimlist a LEFT JOIN icgroup b ON b.wos_group = a.claimtype WHERE b.wos_group = '#id#'
</cfquery>
	<cfset claimid = getjointable.wos_group>
    <cfset claimname = getjointable.claimtype>    
<!---    <cfset claimdes = getjointable.claimdes>--->
<!---    <cfset allowance = getjointable.allowance>--->
    <cfset status = getjointable.status>


<!--- <cfelseif isdefined("url.claimid")> 
	<cfset claimid = url.claimid>--->

<cfelseif isdefined("form.postid")>
	<cfset claimid = form.postid>
<cfquery name="getclaim" datasource="#dts#">
	SELECT * FROM icgroup WHERE wos_group = '#claimid#'
</cfquery>
<!---get totalclaimed amount, [20170316, Alvin]--->
	<cfquery name="getTotalClaim" datasource="#dts#">
    	SELECT sum(claimamount) as totalclaim
        FROM claimlist
        WHERE status = 'Approved'
        AND placementno = '#form.pno#'
        AND claimtype = '#claimid#'
    </cfquery>
<!---get total claim--->
 	<cfset claimname = getclaim.wos_group>    
    <cfset claimdes = getclaim.desp>
<!---    <cfset allowance = getclaim.allowance>
--->    
</cfif>

  	<cfset firstday = dateformat(createdate(dateformat(now(),"yyyy"),1,1),"yyyy-mm-dd")>
    <cfset lastday = dateformat(createdate(dateformat(now(),"yyyy"),12,31),"yyyy-mm-dd")>
    <cfset inform="">

<!---<cfquery name="firstyear" datasource="#dsname#">
    SELECT dcomm
    FROM pmast
    WHERE empno = '#get_comp.empno#'
</cfquery>
    
	<cfset date= now()>
    <cfset average = 1>
    
	<cfif DateDiff("m", firstyear.dcomm, date) lt 12>
  		<cfset average =  numberformat(DateDiff("m", firstyear.dcomm, date)/12,'.__') >
    </cfif> 
   
<cfquery name="checkBal" datasource="#dsname#">
	SELECT SUM(claimamount) AS totalclaim FROM claimlist 
    WHERE claimid = '#claimid#' AND empno = '#get_comp.empno#'
    AND claim_date >= '#firstday#' and claim_date <= '#lastday#' 
    AND status != 'Rejected' 
	 <cfif url.type eq "edit" and status eq "Pending Submission">
    AND id != '#id#'
    </cfif> 
</cfquery>--->

<!---<cfquery name="checkdefault" datasource="#dsname#">
    SELECT 
        amountperclaim, amountperyear, attachreceipt
    FROM
        claim 
    WHERE 
        claimid = #claimid#
</cfquery>--->

<!---<cfif average gt 0>
<cfif isdefined("url.id")>
	<cfset claimamount = numberformat(val(getjointable.claimamount),'.__')>
    <cfset remarks = getjointable.remarks>
    <cfset receipt_no = getjointable.receipt_no>
    <cfset receipt = getjointable.receipt>
    <cfset doc_no = getjointable.doc_no>
    <cfset claim_date = dateformat(getjointable.claim_date,"dd/mm/yyyy")>
</cfif>
<!--- <cfif isdefined("url.claimid") or isdefined("url.id")> --->
<cfif isdefined("form.postid") or isdefined("url.id")>
	<cfset attachreceipt = checkdefault.attachreceipt>
	<cfset amountperclaim = numberformat(val(checkdefault.amountperclaim),'.__')>
	<cfset amountperyear = numberformat(val(checkdefault.amountperyear)*average,'.__')>
	<cfset totalclaim = numberformat(val(checkbal.totalclaim),'.__')>
	<cfset claimableamount = amountperyear-totalclaim>
	<cfset maxclaim = 10000000>
</cfif>

	<cfif url.type eq "edit" or url.type eq "create">
    <cfif amountperclaim gt 0 >
        <cfif amountperyear neq 0 and claimableamount lt amountperclaim>
        <cfif claimableamount lte 0>
            <cfset maxclaim = 0>
            <cfset amountperclaim = 0>
            <cfelse>
            <cfset maxclaim =  claimableamount>
            <cfset amountperclaim = claimableamount>
        </cfif>
        <cfelse>
            <cfset maxclaim = amountperclaim>
        </cfif>
    <cfelse>
        <cfif amountperyear gt 0>
        <cfif claimableamount lte 0>
        <cfset maxclaim = 0>
        <cfelse>
        <cfset maxclaim =  claimableamount>
        </cfif>
        </cfif>
  
<!---         <cfelse>
            <cfset maxclaim = 10000000> --->
    </cfif>
    </cfif>
    
	<cfset msg = "Claim amount is required / Max per claim amount exceed : #maxclaim# / Reach maximum claim of the year">
<cfelse>
	<cfset amountperclaim = 0>
	<cfset claimtamount = 0>
    <cfset claimableamount = 0>
    <cfset maxclaim = 0>
	<cfset msg = "You are not allow to submit claim, date of commencement - " & #dateformat(firstyear.dcomm,'dd/mm/yyyy')#>
</cfif>--->

<cfif isdefined("url.type")>
<!---<cfif url.type eq "edit">
<a href="index.cfm"><strong>< Back</strong></a>
<cfelse>
<a href="createlist.cfm?type=mcreate"><strong>< Back</strong></a>
</cfif>--->
    <cfset totalclaimed = "#numberformat(getTotalClaim.totalclaim, '.__')#">
    <cfset pervisitcap = "#evaluate('getempno.per#form.postid#claimcap')#">
    <cfset contractcap = "#evaluate('getempno.total#form.postid#claimable')#">
    <cfset claimbalance = #numberformat(contractcap, '.__')# - #numberformat(totalclaimed, '.__')#>
    <cfif #contractcap# EQ 0>
    	<cfset claimbalance = 0>
	</cfif>
<cfform action="process.cfm?type=#url.type#&id=#id#" method="post" enctype="multipart/form-data" >
    <input type="hidden" name="claimpriid" id="claimpriid" value="#form.pno#">
    <input type="hidden" name="claimname" id="claimname" value="#claimname#">
    <input type="hidden" name="claimdes" id="claimdes" value="#claimdes#">
    <input type="hidden" name="allowance" id="allowance" value="#allowance#">
    <input type="hidden" name="contractcap" id="contractcap" value="#contractcap#">
    <input type="hidden" name="pervisitcap" id="pervisitcap" value="#pervisitcap#">
    <input type="hidden" name="claimbalance" id="claimbalance" value="#claimbalance#">
    <cfif isdefined('url.id')>
    <input type="hidden" name="claimtranid" id="claimtranid" value="#id#">
    </cfif>
<table>
    <tr>	
        <th width="200px">Job Order</th>
      		<td width="300px">#form.pno#</td>
    </tr>
    <tr>	
        <th width="200px">Claim Type </th>
      		<td width="300px">#claimname#</td>
    </tr>
	<tr>
        <th>Claim Description</th>
        	<td>#claimdes#</td>
    </tr>
    <tr>
        <th>Contract Cap</th>
        	<td>#contractcap#</td>
    </tr>
    <tr>
        <th>Per Visit Cap</th>
        	<td>#pervisitcap#</td>
    </tr>
    <tr>
        <th>Claim Balance</th>
        	<td>#claimbalance#</td>
    </tr>
	
    <tr>
        <th>Claim Amount</th>
        <td><cfinput type="number" step="0.01" id="claimamounttxt" 
        name="claimamounttxt" size="10" required="yes"  
        onvalidate="checkClaim" validate="float" 
        validateat="onsubmit" maxlength="10" 
        onError="errorClaim" >
<!---			<cfif checkdefault.amountperclaim gt 0>
            	Max Per Claim : #amountperclaim# 
            </cfif>
            <cfif checkdefault.amountperyear  gt 0 >
            	Year Remaining Balance : #claimableamount#
            </cfif>--->
        </td>
    </tr>
    
    <tr>
		<th>Date</th>
        	<td>
            	<cfinput type="text" name="dateFrom" id="dateFrom" value="#claim_date#" required="yes" message="Date is Invalid / Required!" validate="eurodate" validateat="onsubmit" readonly="true" size="10">
				<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateFrom'));">
            </td>
	</tr>
    
    <tr>
        <th>Remarks</th>
       		<td >
            	<cfinput type="text" name="remarksinput" id="remarksinput" value="#remarks#"  size="50" maxlength="50" required="yes" message="Remarks is Required!">
            </td>
    </tr>	
   
    <tr>
		<th>Receipt No</th>
			<!---<cfif attachreceipt eq "Yes">--->
       <!---     	<td><cfinput type="text" name="receipt_no" id="receipt_no" value="#receipt_no#" required="yes" message="Must enter receipt number">
                </td>--->
        	<!---<cfelse>--->
            	<td><cfinput type="text" name="receipt_no" id="receipt_no" value="#receipt_no#"></td>
        <!---	</cfif>--->
   	</tr>
    <tr>
        <th>Receipt File</th>
            <td>
				<cfif receipt neq "">
                    <div id="ajaxField">	
                    <a href="/upload/#dsname#/#receipt#" target="_blank">#receipt#</a>
                    <input type="button" name="delete_btn" id="delete_btn" value="Delete" 
                onClick="ajaxFunction(document.getElementById('ajaxField'),'deletefile.cfm?filename=#receipt#');" >
               		</div>
				
      			<cfelse>	
       				<cfinput type="file" name="uploadfilefield" id="uploadfilefield" required="yes" message="Receipt File is Required!"><br>
(Upload allow for Picture, PDF, WORD &amp; Excel document only. Maximum 10 MB only.)
<!---                <cfelse>
		         	<cfinput type="file" name="uploadfilefield" id="uploadfilefield">  --->     
        		</cfif>
        </td>
        
	<tr>
	    <td align="center" colspan="2"><input type="submit" name="sub_but" id="sub_but" value="#ucase(url.type)#"></td>
    </tr>
</table>

</cfform>
</cfif>

<!--- <cfelseif isdefined("url.type") and isdefined("url.id") and url.type eq "viewreceipt">
    <cfquery name="getreceipt" datasource="#dsname#">
        SELECT receipt FROM claimlist WHERE id = '#url.id#'
    </cfquery>
       
    <img src="/upload/#dsname#/#getreceipt.receipt#" alt="Receipt"> 
	<cfabort> --->

</cfif>



</cfoutput>
</body>
</html>