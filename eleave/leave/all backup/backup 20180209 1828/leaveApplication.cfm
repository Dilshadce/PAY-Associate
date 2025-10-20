<cfif isdefined('form.pno')>
<cfquery name="getempno" datasource="#replace(DSNAME,'_p','_i')#">
SELECT empno FROM placement WHERE placementno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pno#">
</cfquery>
<cfif getempno.empno neq get_comp.empno>
<cfabort>
</cfif>
</cfif>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen" >
<link href="/stylesheet/app.css" rel="stylesheet" type="text/css" >
<link href="/stylesheet/CalendarControl.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="/PMS.ico" />

<script src="/javascripts/CalendarControl<cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>el<cfelse>leave</cfif>.js" language="javascript"></script>
<script src="../../SpryAssets/SpryValidationTextField.js" type="text/javascript"></script>
<script src="/javascripts/ajax.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/jquery/jquery-3.1.1.min.js"></script> 

<title>Leave Application</title>
<link href="../../SpryAssets/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
<cfquery name="aLeave_qry" datasource="payroll_main">
	SELECT comp_id,comp_name,c_ale,c_leavebalance,earnleave,myear,mmonth,remarkmust FROM gsetup WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>
<cfquery name="comp_details" datasource="payroll_main">
	SELECT mon,tue,wed,thu,fri,sat,sun,ncltoal,leavedays,daysinadvance,leaveattach,leaveattachlist FROM gsetup2  
    WHERE comp_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HcomID#">
</cfquery>

<script language="javascript">

$(document).ready(function(){
	getLeaveBalance(document.getElementById('leaveType').value);
    showMCAttachment(document.getElementById('leaveType').value);
});

<!---added ajax function to get leave balance, [20170210, Alvin]--->
function getLeaveBalance(leaveType)
{
	$.ajax({
		url: "/eleave/leave/leaveBalance.cfc"
	  , type: "POST"
	  , dataType:"JSON"
	  , data: {
		  method: "getBalance"
		, pno: <cfoutput>"#form.pno#"
		, dts: "#replace(DSNAME,'_p','_i')#"
		, leave: leaveType </cfoutput>
	  }
	  , success: function (data){
		$("#leavebalance").val(data["balance"]);
	  }
	  , error: function (xhr, textStatus, errorThrown){
		alert(errorThrown);
	  }
	});
}
<!---ajax--->
    
function showMCAttachment(leaveType)
{
    if(leaveType == 'MC' || leaveType == 'EL' || leaveType == 'HL')
    {
        document.getElementById('attach').style.display = "table-row";
        $('#attachfield').prop('required', true);
    }
    else
    {
        document.getElementById('attach').style.display = "None";
        $('#attachfield').prop('required', false);
    }
}

function caldays()
{
	var day_s=1000*60*60*24;
	var datefrom = document.getElementById('dateFrom').value;
	var newdatefrom = new Date(datefrom.substring(6,10),datefrom.substring(3,5)-1,datefrom.substring(0,2));
	var dateto = document.getElementById('dateTo').value;
	var newdateto = new Date(dateto.substring(6,10),dateto.substring(3,5)-1,dateto.substring(0,2));
	var ndate = newdatefrom.getDay();
	var leaves = 0;
	var mon = 7, tue = 7, wed = 7, thu = 7, fri = 7, sat = 7, sun = 7;
	var hmon = 7, htue = 7, hwed = 7,hthu = 7,hfri = 7,hsat = 7,hsun = 7;
	
	 <!--- 0=SUN,1=MON......,SAT=6 --->
	if(document.getElementById('mon').value == 1){ 
		var mon = 1;
	}else if(document.getElementById('mon').value == 0.5){
		var hmon = 1;		
	}
	if(document.getElementById('tue').value == 1){
		var tue = 2;
	}else if(document.getElementById('tue').value == 0.5){
		var htue = 2;		
	}
	if(document.getElementById('wed').value == 1){
		var wed = 3;
	}else if(document.getElementById('wed').value == 0.5){
		var hwed = 3;		
	}
	if(document.getElementById('thu').value == 1){
		var thu = 4;		
	}else if(document.getElementById('thu').value == 0.5){
		var hthu = 4;		
	}
	if(document.getElementById('fri').value == 1){
		var fri = 5;	
	}else if(document.getElementById('fri').value == 0.5){
		var hfri = 5;	
	}
	if(document.getElementById('sat').value == 1){
		var sat = 6;
	}else if(document.getElementById('sat').value == 0.5){
		var hsat = 6;		
	}
	if(document.getElementById('sun').value == 1){
		var sun = 0;
	}else if(document.getElementById('sun').value == 0.5){
		var hsun = 0;		
	}

for(var x = 0; x <= (newdateto- newdatefrom)/day_s ; x ++) {
	if((ndate+x)%7==mon
	||(ndate+x)%7==tue
	||(ndate+x)%7==wed
	||(ndate+x)%7==thu
	||(ndate+x)%7==fri
	||(ndate+x)%7==sat
	||(ndate+x)%7==sun)
	{
		leaves += 1;
	}
	if((ndate+x)%7==hmon
	||(ndate+x)%7==htue
	||(ndate+x)%7==hwed
	||(ndate+x)%7==hthu
	||(ndate+x)%7==hfri
	||(ndate+x)%7==hsat
	||(ndate+x)%7==hsun)
	{
		leaves += 0.5;	
	}
}
	if(document.getElementById('halfdayonly').checked == true && leaves >= 1)
    {
        if(leaves > 1)
        {
           alert('Half day leave is applicable for 1 day leave only. Kindly check your date From and Date To'); 
           document.getElementById('halfdayonly').checked = false;
           document.getElementById('halfdaydiv').style.display = "none";
           document.getElementById('days_d').value = leaves;
           document.getElementById('timeFr_d').value = '00:00';
           document.getElementById('timeTo_d').value = '00:00';
        }
        else
        {
           document.getElementById('days_d').value = 0.5; 
        }
    }
    else
    {
        document.getElementById('days_d').value = leaves;
    }
    
	return; 
}

function changeTozero()
{
	document.getElementById('days_d').value = 0;
}

	
function controlbalance()
{
	if(document.getElementById("leaveType").value == 'AL')
	{
		if(document.getElementById("days_d").value * 1 > document.getElementById("bal_a<cfif aLeave_qry.earnleave eq 1>v</cfif>l").value * 1)
		{
			alert('Days is more than Annual Leave <cfif aLeave_qry.earnleave eq 1>Available<cfelse>balance</cfif>');
			<!--- <cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>
			<cfelse> --->
			document.getElementById("days_d").value=0;
			<!--- </cfif> --->
			return false;
		}
	}
	else if(document.getElementById("leaveType").value == 'MC')
	{
		if(document.getElementById("days_d").value * 1 > document.getElementById("bal_mc").value * 1)
		{
			alert('Days is more than Medical leave balance');
			<!--- <cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>
			<cfelse> --->
			document.getElementById("days_d").value=0;
			<!--- </cfif> --->
			return false;
		}
	}
	/*else if(document.getElementById("leaveType").value == 'CC')
	{
		if(document.getElementById("days_d").value * 1 > document.getElementById("ccbal").value * 1)
		{
			alert('Days is more than Childcare leave balance');			
			<!--- <cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>
			<cfelse> --->
			document.getElementById("days_d").value=0;
			<!--- </cfif> --->
			return false;
		}
	}*/
	return true;
	

}	
function validhalf(daycount)
{
	<cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>
	<cfelse>
if(daycount.substring(daycount.length-2) == '.5')
{
document.getElementById("halfdaydiv").style.display = 'block';
}
else
{
document.getElementById("halfdaydiv").style.display = 'none';
</cfif>
}
}

function show_row(valtype)
{
	if (valtype!='time')
	{
		document.getElementById("dayoption").style.display = 'inline';
		document.getElementById("timeoption").style.display = 'none';
		document.getElementById("leave_option").value = "Days";
		document.getElementById("timeoption").disabled = true;
		document.getElementById("dayoption").disabled = false;
	}
	else
	{
		document.getElementById("timeoption").disabled = false;
		document.getElementById("dayoption").disabled = true;
		document.getElementById("leave_option").value = "Time";
		document.getElementById("dayoption").style.display = 'none';
		document.getElementById("timeoption").style.display = 'inline';
	}
}

function show_attach(valtype)
{
	if (valtype=='yes')
	{
		document.getElementById("attach").style.display = '';
		document.getElementById("attachfield").disabled = '';
	}
	else
	{
		document.getElementById("attach").style.display = 'none';
		document.getElementById("attachfield").disabled = 'True';
	}
}
	
function addLoadEvent()
{
	/* This function adds tabberAutomatic to the window.onload event,
	so it will run after the document has finished loading.*/
	var oldOnLoad;
	/* Taken from: http://simon.incutio.com/archive/2004/05/26/addLoadEvent */
	oldOnLoad = window.onload;
	if (typeof window.onload != 'function')
	{
		window.onload = function()
		{
		show_row(document.getElementById("leave_option"));
		};
	}
	else
	{
		window.onload = function()
		{
			oldOnLoad();
			show_row(document.getElementById("leave_option"));
		};
	}
}
addLoadEvent();
</script>
<script type="text/javascript">
var dFilterStep

function dFilterStrip (dFilterTemp, dFilterMask)
{
    dFilterMask = replace(dFilterMask,'#','');
    for (dFilterStep = 0; dFilterStep < dFilterMask.length++; dFilterStep++)
		{
		    dFilterTemp = replace(dFilterTemp,dFilterMask.substring(dFilterStep,dFilterStep+1),'');
		}
		return dFilterTemp;
}

function dFilterMax (dFilterMask)
{
 		dFilterTemp = dFilterMask;
    for (dFilterStep = 0; dFilterStep < (dFilterMask.length+1); dFilterStep++)
		{
		 		if (dFilterMask.charAt(dFilterStep)!='#')
				{
		        dFilterTemp = replace(dFilterTemp,dFilterMask.charAt(dFilterStep),'');
				}
		}
		return dFilterTemp.length;
}

function dFilter (key, textbox, dFilterMask)
{
		dFilterNum = dFilterStrip(textbox.value, dFilterMask);
		
		if (key==9)
		{
		    return true;
		}
		else if (key==8&&dFilterNum.length!=0)
		{
		 	 	dFilterNum = dFilterNum.substring(0,dFilterNum.length-1);
		}
 	  else if ( ((key>47&&key<58)||(key>95&&key<106)) && dFilterNum.length<dFilterMax(dFilterMask) )
		{
        dFilterNum=dFilterNum+String.fromCharCode(key);
		}

		var dFilterFinal='';
    for (dFilterStep = 0; dFilterStep < dFilterMask.length; dFilterStep++)
		{
        if (dFilterMask.charAt(dFilterStep)=='#')
				{
					  if (dFilterNum.length!=0)
					  {
				        dFilterFinal = dFilterFinal + dFilterNum.charAt(0);
					      dFilterNum = dFilterNum.substring(1,dFilterNum.length);
					  }
				    else
				    {
				        dFilterFinal = dFilterFinal + "";
				    }
				}
		 		else if (dFilterMask.charAt(dFilterStep)!='#')
				{
				    dFilterFinal = dFilterFinal + dFilterMask.charAt(dFilterStep); 			
				}
//		    dFilterTemp = replace(dFilterTemp,dFilterMask.substring(dFilterStep,dFilterStep+1),'');
		}


		textbox.value = dFilterFinal;
    return false;
}

function replace(fullString,text,by) {
// Replaces text with by in string
    var strLength = fullString.length, txtLength = text.length;
    if ((strLength == 0) || (txtLength == 0)) return fullString;

    var i = fullString.indexOf(text);
    if ((!i) && (text != fullString.substring(0,txtLength))) return fullString;
    if (i == -1) return fullString;

    var newstr = fullString.substring(0,i) + by;

    if (i+txtLength < strLength)
        newstr += replace(fullString.substring(i+txtLength,strLength),text,by);

    return newstr;
}

function validate_required(field,alerttxt)
		{
		with (field)
		{
		if (value==null||value=="")
		  {alert(alerttxt);return false;}
		else {return true}
		}
		}
		
function validate_form(thisform)
		{
		with (thisform)
		{
			if (validate_required(dateFrom,"Date From must be filled out!")==false
				|| validate_required(dateTo,"Date To must be filled out!")==false)
			  {dateFrom || dateTO.focus();return false;}
			 var datef = document.eForm.dateFrom.value;
			 var datet = document.eForm.dateTo.value;
			 var datefday = datef.substring(0,2) * 1;
			 var datetday = datet.substring(0,2) * 1;
			 var datefmonth = datef.substring(3,5) * 1;
			 var datetmonth = datet.substring(3,5) * 1;
			 var datefyear = datef.substring(6,10) * 1;
			 var datetyear = datet.substring(6,10) * 1;
			 
			 if(datefyear > datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
			 else if( datefmonth > datetmonth && datefyear == datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
			 else if(datefday > datetday &&  datefmonth == datetmonth && datefyear == datetyear)
			 {
				 alert("Date to should be bigger than Date From");
				 return false;
			 }
             else if (document.getElementById('days_d').value <= 0)
             {
                 alert("Days applied cannot be 0");
                 return false;
             }
		 
		}
		
		<cfif aLeave_qry.c_leavebalance neq '1'>
		if( controlbalance() == false)
		{
			return false;
		}
		</cfif>
		
		var datef1 = document.eForm.dateFrom.value;
		var datet1 = document.eForm.dateTo.value;
		
	<!--- 	var days = document.eForm.days.value;
		var timeFr = document.eForm.timeFr.value;
		var timeTo = document.eForm.timeTo.value; --->
		var leaveType1 = document.eForm.leaveType.value;
		var national = document.eForm.national.value;
		var sex = document.eForm.sex.value;
		var mstatus = document.eForm.mstatus.value;
		var paystatus = document.getElementById('STATUS').value;
		var leave_option =  document.getElementById('leave_option').value;
		var timefr_t = document.getElementById('timeFr_d').value;
		var timeto_t = document.getElementById('timeTo_d').value;
		var totday = document.getElementById('days_d').value * 1;
		/*var ccbal = document.getElementById('ccbal').value * 1;
		
		 if(leaveType1 == "CC")
		 {
		  	if (ccbal >= totday)
			 {
		 		
			 }
		 else{
			 alert("You are not qualify to apply Child Care Leave");
			 return false;
		 	}
		  
		 }*/
		
		if (paystatus!="A")
		{
		 alert("You are not qualify to apply Leave");
		 return false;	
		}
		
		totday = totday * 1;
		if (totday == "" && document.getElementById("leaveType").value != 'NCL'  && document.getElementById("leaveType").value != 'TOff')
		{
		 alert("Days Should Not Be Empty");
		 return false;
		}
		
         <cfif aLeave_qry.remarkmust eq "Y">
         if(trim(document.getElementById('applicant_remarks').value) == '')
         {
             alert("Remarks is Required!");
         return false;
         }
         </cfif>
         
        <!---enhanced for days in advance for al/npl, [2016/01/16, by Max Tan]--->
    	if(leaveType.value == "AL" || leaveType.value == "NPL"){
    	var datefrom = document.getElementById('dateFrom').value;
    	var leavedate = new Date(datefrom.substring(6,10),datefrom.substring(3,5)-1,datefrom.substring(0,2));
        var datenow = new Date();
        var day_s=1000*60*60*24;
        var result = (leavedate-datenow)/day_s;
        var advance = document.getElementById('daysinadvance').value;
        
        <cfif comp_details.leavedays eq "Y">
        if (result < advance-1 && result > -1){
			 alert(advance+" days in advance is needed to apply for AL / NPL");
             return false;
        }
        </cfif>
        }

        if(document.getElementById('attachfield').value == ''&&document.getElementById("attach").style.display == ''){
            alert("You Must Attach Document For The Leave");
            return false;            
        }
        <!---end--->
		 
		if(leave_option=="Days")
		{
			var msg_txt = "Are you sure want to apply "+ leaveType1 +" leave from "+ datef1 +" to " + datet1 +" total "+totday+" days?" ;
		}
		else
		{
			var msg_txt = "Are you sure want to apply "+ leaveType1 +" leave from "+ timefr_t +" to " + timeto_t +"?";
		}
        
		answer = confirm(msg_txt);
		if (answer){
		return true;
		}
		else{
		return false;
		}
}
		
function trim(strval)
{
return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
    
</script>

</head>

<body>
<cfquery name="emp_data" datasource="#DSNAME#" >
	SELECT * FROM pmast as pm LEFT JOIN emp_users as ep ON pm.empno = ep.empno 
	LEFT JOIN wdgroup w ON pm.wrking_grp = w.groupwp
    WHERE ep.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">  
</cfquery>
<cfquery name="leave_data" datasource="#DSNAME#">
	SELECT * FROM emp_users as pm LEFT JOIN pay_ytd as p ON pm.empno = p.empno WHERE pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>
<cfquery name="leave_data2" datasource="#DSNAME#">
	SELECT * FROM emp_users as pm LEFT JOIN pleave as p ON pm.empno = p.empno WHERE pm.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">	
</cfquery>

<cfquery name="getaltaw" datasource="#DSNAME#">
	SELECT altawday from paytran as a
    LEFT JOIN emp_users as b
    on a.empno = b.empno
    where b.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">
</cfquery>

<cfset tLVE_DAY_a = 0>
<cfset tLVE_DAY_MC_a = 0>
<cfset tLVE_DAY_CC_a = 0>
<cfset tLVE_DAY_PH_a = 0>
<cfloop query="leave_data2">
	<cfif leave_data2.LVE_TYPE eq "AL">  
		<cfset tLVE_DAY_a= tLVE_DAY_a + val(leave_data2.LVE_DAY)>
	</cfif>
</cfloop>

<cfset x = val(emp_data.alall)+val(emp_data.albf)+val(emp_data.aladj) >
		
<cfset bal_AL = x - (#val(tLVE_DAY_a)# + #val(getaltaw.altawday)#) >
<cfif aLeave_qry.earnleave eq 1>
	<cfif aLeave_qry.myear neq year(now())>
        <cfset monthnow = aLeave_qry.mmonth >
    <cfelse>
        <cfset monthnow = month(now())>
    </cfif>
    <cfset totalmonth = 12>
    
    <cfif year(emp_data.dcomm) eq year(now()) and aLeave_qry.myear eq year(now())>
		<cfset monthnow = month(now()) - month(emp_data.dcomm)>
    </cfif>
    <cfset xav = int((val(emp_data.alall) * monthnow/totalmonth)+0.0001) +val(emp_data.albf)+val(emp_data.aladj) >
    <cfset bal_AVL = xav - (#val(tLVE_DAY_a)# + #val(getaltaw.altawday)#) >
</cfif>

<cfloop query="leave_data2">
	<cfif leave_data2.LVE_TYPE eq "MC"> 
		<cfset tLVE_DAY_MC_a = tLVE_DAY_MC_a + val(leave_data2.LVE_DAY)>
	</cfif>
</cfloop>

<cfset bal_MC = val(emp_data.mcall) - #val(tLVE_DAY_MC_a)#>

<cfloop query="leave_data2">
	<cfif leave_data2.LVE_TYPE eq "CC"> 
		<cfset tLVE_DAY_CC_a = tLVE_DAY_CC_a + val(leave_data2.LVE_DAY)>
	</cfif>
</cfloop>

<cfset bal_CC = val(emp_data.ccall) - #val(tLVE_DAY_CC_a)#>

<cfloop query="leave_data2">
	<cfif leave_data2.LVE_TYPE eq "PH">
		<cfset tLVE_DAY_PH_a = tLVE_DAY_PH_a + val(leave_data2.LVE_DAY)>
	</cfif>
</cfloop>

<cfset bal_PH = 0 - #val(tLVE_DAY_PH_a)#>

<cfset dts = replace(dsname,'_p','_i')>

<cfquery name="getleavelist" datasource="#dts#">
    SELECT * from iccostcode a <!---LEFT JOIN ---> 
    ORDER BY costcode
    <!---SELECT * FROM icgroup ORDER BY wos_group;--->
</cfquery>
<cfoutput>
<cfquery name="getlist" datasource="#dts#">
    SELECT 
    <cfloop from="1" to="#getleavelist.recordcount#" index="i">
    #getleavelist["costcode"][i]#entitle 
    <cfif i neq getleavelist.recordcount>
    ,
    </cfif>
    </cfloop> 
    FROM placement WHERE placementno = '#form.pno#'
</cfquery>
</cfoutput>

<!---<cfabort>--->

<cfoutput>
<div class="tabber">
		<div class="tabbertab">
        <h3>
        Leave Application
        </h3>
        <form action="/eleave/leave/leaveApplicationProcess.cfm" method="post" name="eForm" id="eform" onSubmit="
        return validate_form(this);" enctype="multipart/form-data"> 
        <input type="hidden" name="email" id="email" value="#emp_data.email#"  />
        <input type="hidden" name="createdBY" id="createdBY" value="#emp_data.createdBY#"  />
        <input type="hidden" name="daysinadvance" id="daysinadvance" value="#comp_details.daysinadvance#"  />
        
        <table class="form" width="800px">
        <tr>
        <th>Job Order No</th>
        <td>:</td>
        <td><input readonly type="text" id="pno" name="pno" value="#form.pno#" size="40"></td>
        </tr>
        <tr>
        <th width="100px">Employee No.</th>
        <td width="5px">:</td>
        <td><input type="text" name="empno" id="empno" value="#emp_data.empno#" readonly size="40"/></td>
		<td></td>
        <cfif aLeave_qry.earnleave eq 1>
        <th>Annual Leave Available</th>
        <td>:</td>
        <td><input type="text" name="bal_avl" id="bal_avl" value="#bal_avl#" readonly /></td>
        <cfelse>
        <td></td>
        </cfif>
		
        </tr><input type="hidden" name="national" id="hidden" value="#emp_data.national#"  />
        <input type="hidden" name="sex" id="sex" value="#emp_data.sex#" />
        <input type="hidden" name="mstatus" id="mstatus" value="#emp_data.mstatus#" />
        <tr>
          <th>Name</th>
          <td>:</td>
          <td><input type="text" name="name" value="#emp_data.name#" id="name" readonly size="40"/></td>
		<td></td>
		<!---<th>Annual Leave Balance</th>
		<td>:</td>
		<td><input type="text" name="bal_al" id="bal_al" value="#bal_al#" readonly /></td>--->
        </tr>
        <tr>
          <th>Leave Type</th>
          <td>:</td>
          <td><select id="leaveType" name="leaveType" Onclick="changeTozero()" onChange="getLeaveBalance(this.value);showMCAttachment(this.value);">
                    <cfloop query="getleavelist">
                        <cfif evaluate("getlist['#getleavelist.costcode#entitle'][1]") eq "Y"> 
	    				<option id="#getleavelist.costcode#" value="#getleavelist.costcode#">#getleavelist.costcode# - #getleavelist.desp#</option>
                         </cfif>                        
                    </cfloop>
				</select></td>
				<td></td>
		<!---<th>Medical Leave Balance</th>
		<td>:</td>
		<td><input type="text" name="bal_mc" id="bal_mc" value="#bal_MC#" readonly /></td>
        </tr>--->
        
        <th>Leave Balance</th> 
		<td>:</td>
        <td > <input type="text" readonly name="leavebalance" id="leavebalance" value="0"> </td>
        </tr>
        <tr>
          <th>Date From</th>
          <td>:</td>
         <td><input type="text" size="15" name="dateFrom" id="dateFrom" value="" readonly="readonly"/>
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateFrom'));" >
            (dd/mm/yyyy) </td>
        <td></td>
		<!---<th>ChildCare Leave Balance</th>
		<td>:</td>
		<td><input type="text" id="ccbal" name="ccbal" value="#bal_CC#"  readonly="readonly"/></td>--->
        </tr>
             <tr>
          <th>Date To</th>
          <td>:</td>
          <td><input type="text" size="15" name="dateTo" id="dateTo" value="" readonly />
			<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('dateTo'));">
              (dd/mm/yyyy)</td>
        <cfif emp_data.wrking_grp neq "">     
            <input type="hidden" name="mon" id="mon" value="#emp_data.mon#">
            <input type="hidden" name="tue" id="tue" value="#emp_data.tue#">
            <input type="hidden" name="wed" id="wed" value="#emp_data.wed#">
            <input type="hidden" name="thu" id="thu" value="#emp_data.thu#">
            <input type="hidden" name="fri" id="fri" value="#emp_data.fri#">
            <input type="hidden" name="sat" id="sat" value="#emp_data.sat#">
            <input type="hidden" name="sun" id="sun" value="#emp_data.sun#">
		<cfelse>
            <input type="hidden" name="mon" id="mon" value="#comp_details.mon#">
            <input type="hidden" name="tue" id="tue" value="#comp_details.tue#">
            <input type="hidden" name="wed" id="wed" value="#comp_details.wed#">
            <input type="hidden" name="thu" id="thu" value="#comp_details.thu#">
            <input type="hidden" name="fri" id="fri" value="#comp_details.fri#">
            <input type="hidden" name="sat" id="sat" value="#comp_details.sat#">
            <input type="hidden" name="sun" id="sun" value="#comp_details.sun#">
        </cfif>
			<td></td>
		<!---<th>Public Holiday Leave Balance</th>
		<td>:</td>
		<td><input type="text" id="phbal" name="phbal" value="#bal_PH#"  readonly="readonly"/></td>--->
        </tr>
        <tr>
		<th>Leave Option</th>
        <td>:</td>
		<td>
        <input type="text" name="leave_option" id="leave_option" value="Day" readonly />
			<!--- <select name="leave_option" id="leave_option" onChange="show_row(this);">
   				<option value="Days">Day Off</option> 
				<option value="Time">Time Off</option> 
			</select> --->  
		</td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		</tr>
     <tr id="dayoption">
          <th width="20%">Days</th>
          <td width="8%">:</td>
          <td><input type="hidden" name="c_leavebalance" id="c_leavebalance" value="#aLeave_qry.c_leavebalance#" />
          <div id="ajaxdate">
        	<input type="text" readonly id="days_d" name="days_d" value="1" <cfif aLeave_qry.c_leavebalance neq '1'>onkeyup="validhalf(this.value);controlbalance();"<cfelse>onkeyup="validhalf(this.value);"</cfif> /><!--- <cfif DSNAME eq 'uniq_p' or DSNAME eq 'maven_p' or DSNAME eq 'kjcpl_p' or DSNAME eq 'viva_p' or DSNAME eq 'mlpl_p'>readonly</cfif> --->
            </div>
	    <cfif DSNAME eq 'netsource_p'>
	    <input type="checkbox" name="halfdayonly" id="halfdayonly" onclick="if(this.checked == true){document.getElementById('days_d').value=0.5;validhalf(document.getElementById('days_d').value);document.getElementById('timeFr_d').value='09:00';document.getElementById('timeTo_d').value='13:00';}else{document.getElementById('days_d').value=1;validhalf(document.getElementById('days_d').value);document.getElementById('timeFr_d').value='';document.getElementById('timeTo_d').value='';}caldays();"  />(Half Day)
	    <cfelse>
            <input type="checkbox" name="halfdayonly" id="halfdayonly" onclick="if(this.checked == true){document.getElementById('days_d').value=0.5;validhalf(document.getElementById('days_d').value);document.getElementById('timeFr_d').value='08:00';document.getElementById('timeTo_d').value='12:00';}else{document.getElementById('days_d').value=1;validhalf(document.getElementById('days_d').value);document.getElementById('timeFr_d').value='';document.getElementById('timeTo_d').value='';}caldays();" />(Half Day)
	    </cfif>
            <div id="halfdaydiv" style="display:none">
            <br/>
	    <cfif DSNAME eq 'netsource_p'>
            AM<input type="radio" name="halfday" id="halfday" value="am" checked="checked" onclick="if(this.checked){document.getElementById('timeFr_d').value='09:00';document.getElementById('timeTo_d').value='13:00';}" />
            &nbsp;&nbsp;&nbsp;PM<input type="radio" name="halfday" id="halfday" value="pm" onclick="if(this.checked){document.getElementById('timeFr_d').value='14:00';document.getElementById('timeTo_d').value='18:00';}" />
	    <cfelse>
            AM<input type="radio" name="halfday" id="halfday" value="am" checked="checked" onclick="if(this.checked){document.getElementById('timeFr_d').value='08:00';document.getElementById('timeTo_d').value='12:00';}" />
            &nbsp;&nbsp;&nbsp;PM<input type="radio" name="halfday" id="halfday" value="pm" onclick="if(this.checked){document.getElementById('timeFr_d').value='13:00';document.getElementById('timeTo_d').value='17:00';}" />
	    </cfif>
            <br />
			Time From : <input name="timeFr" type="text" id="timeFr_d" value=""/><br/>
            Time To : <input name="timeTo" type="text" id="timeTo_d" value=""/></div>
          </td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
    </tr>
        
  	<tr id="timeoption">
	   <th  width="20%" >Time Off</th>
	   <td width="8%" >:</td>
	   <td>
		  <!--- From :
		   <input type="text" id="timeFr_t" name="timeFr" maxLength="5" <!--- onKeyDown="javascript:return dFilter (event.keyCode, this, '####:####');" style="font-family:verdana;font-size:10pt;width:110px;" --->>
		   To :
		   <input type="text" id="timeTo_t" name="timeTo" maxlength="5" <!--- onKeyDown="javascript:return dFilter (event.keyCode, this, '####:####');" style="font-family:verdana;font-size:10pt;width:110px;" --->>(hh:mm) i.e 14:00 
		   <input type="hidden" id="days_t" name="days_t" value="1"/>--->
	   </td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
 	</tr>
<!---  <tr>
   <th>Attach File</th>
   <td>:</td>
  
  <td><!--- with labels --->
<input type="text" name="picture" id="picture" value="picture"/>
<a href="uploadImages/index.cfm" target="_blank" >Upload Images </a>

</tr> --->
 	<tr>
        <th>Remarks</th>
        <td>:</td>
        <td><textarea id="applicant_remarks" name="applicant_remarks" cols="40" rows="5"></textarea></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
    </tr>
    
        <tr id="attach">
            <th >Attachment</th>
            <td >:</td>
            <td >
                <input type="file" name="attachfield" id="attachfield" /> <br />
                (Upload allow for Picture, PDF, WORD &amp; Excel document only. Maximum 10 MB only.)
            </td>
    <!---		<td></td>
            <td></td>
            <td></td>
            <td></td>--->
        </tr>

    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
		<input type="hidden" name="STATUS" ID="STATUS" value="#emp_data.paystatus#">
        <td><input type="submit" value="Submit"  /><!---onClick="leaveControl()"--->
          <input type="reset" value="Reset" /></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
        
        </table>
        </form>
    </div>
</div>

</cfoutput> 
<script type="text/javascript">

var sprytextfield1 = new Spry.Widget.ValidationTextField("sprytextfield1", "currency", {useCharacterMasking:true});

</script>
</body>
</html> 
