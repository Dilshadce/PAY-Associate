<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<script src="/javascripts/CalendarControl.js" language="javascript"></script>
<script type="text/javascript" src="/javascripts/ajax.js"></script>

<html>
<head>
<title>Claim</title>
</head>
<body>


<cfif isdefined("url.type") and url.type eq "mcreate">

    <cfoutput>
    <h1>Submit Claim</h1>
    <cfquery name="getposdetail" datasource="#dsname#">
  		  select * from claim 
    </cfquery>
	
    <cfform action="createlist.cfm?type=create" method="post" enctype="multipart/form-data" >
    <table><tr><td>
    <cfselect name="postid" id="postid" required="yes" message="Claim is Required">
        <cfloop query="getposdetail">
        <option value="#getposdetail.claimid#">#getposdetail.claimname# - #getposdetail.claimdes#</option>
    </cfloop>
    </cfselect>
    <cfinput type="submit" name="submit" id="submit" value="Submit Claim">
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

<cfif isdefined("url.id") >
<cfset id = url.id>
<cfquery name="getjointable" datasource="#dsname#">
	SELECT * FROM claimlist a LEFT JOIN claim b ON a.claimid = b.claimid WHERE a.id = '#id#'
</cfquery>
	<cfset claimid = getjointable.claimid>
    <cfset claimname = getjointable.claimname>    
    <cfset claimdes = getjointable.claimdes>
    <cfset allowance = getjointable.allowance>
    <cfset status = getjointable.status>


<!--- <cfelseif isdefined("url.claimid")> 
	<cfset claimid = url.claimid>--->

<cfelseif isdefined("form.postid")>
	<cfset claimid = form.postid>
<cfquery name="getclaim" datasource="#dsname#">
	SELECT * FROM claim WHERE claimid = '#claimid#'
</cfquery>
 	<cfset claimname = getclaim.claimname>    
    <cfset claimdes = getclaim.claimdes>
    <cfset allowance = getclaim.allowance>
    
</cfif>

  	<cfset firstday = dateformat(createdate(dateformat(now(),"yyyy"),1,1),"yyyy-mm-dd")>
    <cfset lastday = dateformat(createdate(dateformat(now(),"yyyy"),12,31),"yyyy-mm-dd")>
    <cfset inform="">

<cfquery name="firstyear" datasource="#dsname#">
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
</cfquery>

<cfquery name="checkdefault" datasource="#dsname#">
    SELECT 
        amountperclaim, amountperyear, attachreceipt
    FROM
        claim 
    WHERE 
        claimid = #claimid#
</cfquery>

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
    </cfif>
        <cfelse>
            <cfset maxclaim = 10000000>
    </cfif>
    
	<cfset msg = "Claim amount is required / Max per claim amount exceed : #maxclaim# / Reach maximum claim of the year">

<cfif isdefined("url.type")>
<cfif url.type eq "edit">
<a href="index.cfm"><strong>< Back</strong></a>
<cfelse>
<a href="createlist.cfm?type=mcreate"><strong>< Back</strong></a>
</cfif>
<cfform action="process.cfm?type=#url.type#&id=#id#" method="post" enctype="multipart/form-data" >
    <input type="hidden" name="claimpriid" id="claimpriid" value="#claimid#">
    <input type="hidden" name="claimname" id="claimname" value="#claimname#">
    <input type="hidden" name="claimdes" id="claimdes" value="#claimdes#">
    <input type="hidden" name="allowance" id="allowance" value="#allowance#">
    <cfif isdefined('url.id')>
    <input type="hidden" name="claimtranid" id="claimtranid" value="#id#">
    </cfif>
<table>
    <tr>	
        <th width="200px">Claim Type </th>
      		<td width="300px">#claimname#</td>
    </tr>
	<tr>
        <th>Claim Description</th>
        	<td>#claimdes#</td>
    </tr>
	
    <tr>
        <th>Claim Amount</th>
        <td><cfinput type="text" name="claimamounttxt" size="10" required="yes" validate="range" validateat="onsubmit" maxlength="10" message="#msg#" value="#claimamount#" range="0.01,#maxclaim#">
			<cfif checkdefault.amountperclaim gt 0>
            	Max Per Claim : #amountperclaim# 
            </cfif>
            <cfif checkdefault.amountperyear  gt 0 >
            	Year Remaining Balance : #claimableamount#
            </cfif>
        </td>
    </tr>
    
    <tr>
		<th>Date</th>
        	<td>
            	<cfinput type="text" name="dateFrom" id="dateFrom" value="#claim_date#" required="yes" message="Invalid Date / Date cannot be empty">
				<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateFrom'));">
            </td>
	</tr>
    
    <tr>
        <th>Remarks</th>
       		<td >
            	<cfinput type="text" name="remarksinput" id="remarksinput" value="#remarks#"  size="38%" maxlength="50">
            </td>
    </tr>	
   
    <tr>
		<th>Receipt No</th>
			<cfif attachreceipt eq "Yes">
            	<td><cfinput type="text" name="receipt_no" id="receipt_no" value="#receipt_no#" required="yes" message="Must enter receipt number">
                </td>
        	<cfelse>
            	<td><cfinput type="text" name="receipt_no" id="receipt_no" value="#receipt_no#"></td>
        	</cfif>
   	</tr>
    </tr>
        <th>Receipt</th>
            <td>
				<cfif receipt neq "">
                    <div id="ajaxField">	
                    <a href="/upload/#dsname#/#receipt#" target="_blank">#receipt#</a>
                    <input type="button" name="delete_btn" id="delete_btn" value="Delete" 
                onClick="ajaxFunction(document.getElementById('ajaxField'),'deletefile.cfm?filename=#receipt#');" >
               		</div>
                <tr>
                    <th>Document No</th>
                        <td>#doc_no#</td>
                </tr>
				
      			<cfelseif attachreceipt eq "Yes">	
       				<cfinput type="file" name="uploadfilefield" id="uploadfilefield" required="yes" message="Must attach receipt">
                <cfelse>
		         	<cfinput type="file" name="uploadfilefield" id="uploadfilefield">       
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