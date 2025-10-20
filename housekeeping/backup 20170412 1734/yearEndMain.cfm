<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">	
	<title>Year End Process Main</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<!--- <script type="text/javascript" >
		function confirmgen()
		{
			var answer = confirm("Confirm Process Year End? Please make sure you have backup the data before year end.")
			if (answer)
			{
				window.location = "year_end_process.cfm";"
			}
			else
			{
			}
		}
	</script> --->
	<script language="javascript">
		function confirmgen(time) {
            var msg = '';
            var time =  new Date(time);
            var date = Date.now();
            var datediff = (date-time)/3600/1000;

            if(datediff < 24){
                var msg = msg + 'You Have Done Year End Earlier At \n' + time + '\n\n' ;
            } 
            
			var msg = msg + "Confirm Process Year End?\n";
			
			if(document.getElementById('bfleave').checked == true)
			{
				msg=msg+"\nConfirm Brought Forward Annual Leave?\n";
			}
			
			if(document.getElementById('updateleave').checked == true)
			{
				msg=msg+"\nConfirm Update AL Brought Forward Based On Eleave?\n";
			}
			
			if(document.getElementById('SaveNoActive').checked == true)
			{
				msg=msg+"\nConfirm Preserve Non Active Employee?\n";
			}
			
			msg = msg+"\nConfirm Your Email Address is "+document.getElementById('emailfield').value+" ?";
			
			
			var answer = confirm(msg)
			if (answer){
				ColdFusion.Window.show('processing');
				return true;
						}
			else{
				return false;
				}
			}
	</script>
	
</head>
<body><cfoutput>
<cfquery name="company_details" datasource="#dts_main#">
	SELECT mmonth,myear FROM gsetup WHERE comp_id = "#HcomID#"
</cfquery>
<cfquery name="gs_qry2" datasource="#dts_main#">
	SELECT yearend,yestatus FROM gsetup2 WHERE comp_id = "#HcomID#"
</cfquery>

<form action="year_end_process.cfm" method="post" onsubmit="return confirmgen('#gs_qry2.yearend#');">

<cfset mon = company_details.mmonth>
<cfset yrs = company_details.myear>
<cfif mon neq "13">
<cfset date= createdate(yrs,mon,1)>
</cfif>

		<font color="red" size="2.5"><cfif isdefined("form.status")><cfoutput>#form.status#</cfoutput></cfif></font>
		<div class="mainTitle" style="text-transform:uppercase">YEAR END PROCESSING FOR <cfif mon neq "13">#dateformat(date,'YYYY')#<cfelse>#yrs#</cfif></div>
		<table class="form" width="50%">
			<tr>
				<td colspan="2"><strong>Year End Processing Will</strong></td>
			</tr>
			<tr>
				<td width="30px" align="right">1.</td>
				<td>Delete all employees with pay status = 'N'</td>
			</tr>
			<tr>
				<td align="right">2.</td>
				<td>Set yearly reports figures to 0</td>
			</tr>
			<tr>
				<td align="right">3.</td>
				<cfset yrs = yrs + 1>
				<td>Increase year to #yrs#</td>
			</tr>
            <tr>
            <th colspan="2">Do You Want To ?</th>
            </tr>
            <tr>
            <td><input type="checkbox" name="bfleave" id="bfleave" value="1" /></td>
            <td>Brought Forward Annual Leave</td>
            </tr>
            <tr>
            <td></td>
            <td><input type="checkbox" name="updateleave" id="updateleave" value="1" />
            &nbsp;&nbsp;Update AL Brought Forward Based On ePortal (Tick for ePortal, Untick for Year To Date)</td>
            </tr>
            
              <tr>
            <td><input type="checkbox" name="SaveNoActive" id="SaveNoActive" value="1" /></td>
            <td>Preserve Non Active Employee (pay status = 'N')</td>
            </tr>
            <tr>
           <th colspan="2">
           <br />
    If you face any difficulty doing year end closing, please kindly contact our helpdesk at support@mynetiquette.com
           </th>
           </tr>
            
            <cfquery name="getemail" datasource="#dts#">
            SELECT userEmail FROM payroll_main.users WHERE
            userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
            </cfquery>
            <cfif isvalid('email',getemail.useremail)>
            <input type="hidden" id="emailfield" name="emailfield" value="#trim(getemail.useremail)#" />
            <tr>
             <th colspan="2">
             Year #yrs# Data Login information will be send to <b>#getemail.useremail#</b>. If you found that the email stated is incorrect, please kindly admend it at HOUSEKEEPING > User Administration > Choose Your Company ID > Edit Your User name > Email.
            </th>
            </tr>
           </cfif>
           
           <cfif isvalid('email',getemail.useremail) eq false><tr>
           <td colspan="2"><font style="color:##F00;font-size:15px"><b>Email is required for year end in order for system to send year #yrs# data login information. Please kindly Fill in at HOUSEKEEPING > User Administration > Choose Your Company ID > Edit Your User name > Email.</b></font></td>
           </tr>
           </cfif>
           
           <cfif mon neq "13" >
           <tr>
           <td colspan="2"><font style="color:##F00; font-size:15px"><b>Payroll Month December has not month end yet! Please kindly proceed to close month Decemeber</b></font></td>
           </tr>
		   </cfif>
           
      <tr>
      <td colspan="2"><cfif isvalid('email',getemail.useremail) and mon eq "13" >
        <center><br /><br />
            <input type="submit" id="process" name="process" value="Proceed Year End"
             <cfif mon neq 13 or gs_qry2.yestatus eq 'Y'> style="display:none" disabled="disabled"  </cfif>>
            <cfif gs_qry2.yestatus eq "Y"><h2>Someone Is Processing Year End <br />
            Or<br />
            Previous Year End Has Encountered Error. Please Report To Our Support Team.</h3></cfif>
        </center>
    </cfif></td>
      </tr>
           
            
            
		</table>

    
	</form>
    <cfwindow name="processing" width="300" height="300" initshow="false" center="true" closable="false" draggable="false" title="Processing....Please Wait" modal="true" resizable="false" >
<h1>Processing....Please Wait</h1>
<img src="/images/loading.gif" align="middle" />
</cfwindow>
</cfoutput>
</body>
</html>