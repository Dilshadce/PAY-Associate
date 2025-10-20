<cfsetting showdebugoutput="no">
<!---<cfif husergrpid EQ "super">
	<cfset pin="pin0">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin1">
<cfelseif husergrpid EQ "guser">
	<cfset pin="pin2">
<cfelseif husergrpid EQ "luser">
	<cfset pin="pin3">
<cfelseif husergrpid EQ "muser">
	<cfset pin="pin4">
<cfelseif husergrpid EQ "suser">
	<cfset pin="pin5">
</cfif>--->
<!---
<cfquery name="getGsetup" datasource="payroll_main">
	SELECT dflanguage FROM gsetup
</cfquery>
<cfif getGsetup.dflanguage NEQ "english">
	<cfset menuname=getGsetup.dflanguage>
<cfelse>
	<cfset menuname="menu_name">
</cfif>
--->
<cfquery name="gsetup" datasource="#dts_main#">
	SELECT * FROM gsetup WHERE  comp_id = "#HcomID#"
</cfquery>
<cfset user_pin = "PIN"&val(Hpin) >	
<cfquery name="pin_qry" datasource="#dts#">
	SELECT code, #user_pin# as pin from newuserdefine 
</cfquery>
<cfquery name="getsuper" datasource="#dts_main#">
	select usergrpid from users where entryID="#HEntryID#" and usercmpID="#HcomID#"
</cfquery>

<cfset title_define = StructNew()>

<cfif #getsuper.usergrpid# eq "super">
	<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, "true")>
	</cfloop>
<cfelse>	
	<cfloop query="pin_qry">
	 <cfset StructInsert(title_define, pin_qry.code, pin_qry.pin)>
	</cfloop>
</cfif>

<cfset country_code = "#gsetup.ccode#" >

<cfquery name="getLevel1Menu" datasource="payroll_main">
	SELECT *
	FROM payroll_main.newmenu
	WHERE menu_level='1'
    and ccode=""
    and company_id=""
    <cfif husergrpid NEQ "super">and user_define <> ""</cfif>
    <cfif hcomid EQ 'beps_p'>
   AND menu_name <> 'Project Report'
	</cfif>
<!---     AND (company_id = "beps_p" or company_id = "" or company_id is null)
 --->	<cfif husergrpid NEQ "super">AND menu_name <> "Super Menu"</cfif>
	ORDER BY menu_order;
</cfquery>

<cfquery name="getCurrentActiveMenu" datasource="payroll_main">
	SELECT menu_id
	FROM payroll_main.newmenu
	<!---WHERE menu_url LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.SCRIPT_NAME#%">--->
</cfquery>

<cfset comid = replace(getHQstatus.userdsn,'_p','')>
<cfquery name="getPartner" datasource="payroll_main">
	SELECT companyid 
    FROM invitefriend
    WHERE companyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#comid#">;
</cfquery> 
<!---
<cfif getCurrentActiveMenu.RecordCount GT 0>
	<cfset session.menuid = getCurrentActiveMenu.menu_id>
</cfif>
--->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Payroll Management System</title>
<link rel="stylesheet" href="/css/hoverscroll/jquery.hoverscroll.css" />
<link rel="stylesheet" href="/css/side/side.css" />
<link rel="stylesheet" href="/css/side/sidemenu.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/hoverscroll/jquery.hoverscroll.js"></script>
<script type="text/javascript" src="/js/side/sidemenu.js"></script>
</head>
<body>
<cfoutput>
<div id="logo_div" class="section">
	<cfif getPartner.recordcount eq 0>
    	<a href="http://www.mynetiquette.com/applications/payroll-system/" target="_blank">
        	<img alt="PMS Logo" src="/img/pmslogo.png" />
        </a>
   	<cfelse>
    	<a href="" target="_blank">
        	<img alt="PMS Logo" src="/img/pmslogo.png" />
        </a>
  	</cfif>
</div>
<div class="section">
	<ul id="menu" class="accordion">
		<cfloop query="getLevel1Menu">
        <cfif husergrpid NEQ "super">
        <cfif title_define["#getLevel1Menu.user_define#"] eq "TRUE" and getLevel1Menu.user_define neq "" >
		<li id="item#getLevel1Menu.menu_id#" class="item#getLevel1Menu.menu_id#"><a href="../#getLevel1Menu.menu_url#" target="mainFrame">#getLevel1Menu.menu_name#</a>
			<ul class="sub-menu">
				<cfquery name="getLevel2Menu" datasource="payroll_main">
					SELECT menu_id,menu_name,menu_url,ccode,company_id,user_define
					FROM payroll_main.newmenu
					WHERE menu_parent=#getLevel1Menu.menu_id#
                    and (ccode="" or ccode='#country_code#')
                    and (company_id="" or company_id='#HcomID#')
                    <cfif HcomID EQ 'beps_p'>
   						AND menu_name <> 'Project Report'
					</cfif>
                    AND (company_id = "ksp_p" or company_id = "#hcomid#" or company_id = "" or company_id is null)
		            AND (ccode = "#HuserCcode#" or ccode = "" or ccode is null)
					ORDER BY menu_order;
				</cfquery>
				<cfloop query="getLevel2Menu">
                <cfif title_define["#getLevel2Menu.user_define#"] eq "TRUE">
					<li id="item#getLevel2Menu.menu_id#" class="item#getLevel2Menu.menu_id#"><a href="../#getLevel2Menu.menu_url#" target="mainFrame">#getLevel2Menu.menu_name#</a></li>
                </cfif>
				</cfloop>
			</ul>
		</li>	
        </cfif>	
        <cfelse>
		<li id="item#getLevel1Menu.menu_id#" class="item#getLevel1Menu.menu_id#"><a href="../#getLevel1Menu.menu_url#" target="mainFrame">#getLevel1Menu.menu_name#</a>
			<ul class="sub-menu">
				<cfquery name="getLevel2Menu" datasource="payroll_main">
					SELECT menu_id,menu_name,menu_url,ccode,company_id,user_define
					FROM payroll_main.newmenu
					WHERE menu_parent=#getLevel1Menu.menu_id#
                    and (ccode="" or ccode='#country_code#')
                    and (company_id="" or company_id='#HcomID#')
                    <cfif HcomID EQ 'beps_p'>
   						AND menu_name <> 'Project Report'
					</cfif>
                    AND (company_id = "ksp_p" or company_id = "#hcomid#" or company_id = "" or company_id is null)
		            AND (ccode = "#HuserCcode#" or ccode = "" or ccode is null)
					ORDER BY menu_order;
				</cfquery>
				<cfloop query="getLevel2Menu">
					<li id="item#getLevel2Menu.menu_id#" class="item#getLevel2Menu.menu_id#"><a href="../#getLevel2Menu.menu_url#" target="mainFrame">#getLevel2Menu.menu_name#</a></li>
				</cfloop>
			</ul>
		</li>	
        </cfif>	
		</cfloop>
	</ul>
</div>
<div id="bottomDiv" class="bottomNavigationDiv">
	<span id="searchNavigation"></span>
	<span id="favoriteNavigation"></span>
</div>
</cfoutput>
</body>
</html>