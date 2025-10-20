<cfsetting showdebugoutput="no">
<cfif IsDefined("url.id")>

<!---<cfif husergrpid EQ "super">
	<cfset pin="pin0">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin1">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin2">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin3">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin4">
<cfelseif husergrpid EQ "admin">
	<cfset pin="pin5">
</cfif>--->

<cfquery name="getGsetup" datasource="payroll_main">
	SELECT ccode FROM gsetup WHERE comp_id = "#hcomid#"
</cfquery>
<cfset user_pin = "PIN"&val(Hpin) >	
<cfquery name="pin_qry" datasource="#dts#">
	SELECT code, #user_pin# as pin from newuserdefine 
</cfquery>
<cfquery name="getsuper" datasource="#dts_main#">
	select usergrpid from users where entryID="#HEntryID#" and usercmpID="#HcomID#"
</cfquery>

	<cfset menuname="menu_name">
	<cfset titledesp="titledesp">

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

<cfquery name="getMenu" datasource="payroll_main">
	SELECT m.menu_id, m.menu_name ,m.menu_url, user_define
	FROM newmenu AS m
WHERE m.menu_parent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#"> 
	    AND (company_id = "#dts#" or company_id = "" or company_id is null)
        AND (ccode = "" or ccode is null or ccode = "#getgsetup.ccode#")
ORDER BY m.menu_order
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Payroll Management System</title>

<cfif husergrpid EQ "super">
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/jeditable/jquery.jeditable.mini.js"></script>
<cfoutput>
<script type="text/javascript">
	var dts='#dts#';
	var authUser='#getAuthUser()#';
</script>
</cfoutput>
<script type="text/javascript" src="/js/body/bodymenu.js"></script>
</cfif>

<style>
body{
	margin:0;
}
.content{
	margin:0;
	padding:0;
}
.content_body{
	margin:0;
	padding:0;
	width:100%;
}
.menulist ul{
	max-width:905px;
	padding:0;
	margin:25px;
}
.menulist li{
	display:inline-block;
	text-decoration:none;
	list-style-type:none;
	font-family:Segoe UI;
	margin-left:25px;
	margin-top:25px;
	border-left:8px solid #C67FD8;
	box-shadow: 0px 0px 10px #CCCCCC;
	background-color:#FFFFFF;
	cursor:pointer;
	behavior: url(/css/pie/PIE.htc);
}
.menulist li:hover,.menulist li:active{
	color:#1D2835;
	border-left:8px solid #1D2835;
	background-color:#C67FD8;
}
.menulist a{
	text-decoration:none;
}
.submenu{
	margin:10px 24px 10px 16px;
	width:367px;
}
.title{
	vertical-align:top;
	font-family:"Franklin Gothic Book";
	font-size:22px;
	font-weight:bold;
	letter-spacing:0.025em;
	color:#1D2835;
	border-bottom:1px solid #666666;
	overflow:hidden;
	word-wrap:break-word;
	min-height:35px;
}
.desp{
	margin-top:7px;
	font-family:"Segoe UI";
	font-size:12px;
	font-style:italic;
	color:#666666;
	min-height:35px;
	overflow:hidden;
	word-wrap:break-word;
}
.menulist li:hover .title,.menulist li:active .title{
	color:#1D2835;
	border-bottom:1px solid #1D2835;
}
.menulist li:hover .desp,.menulist li:active .desp{
	color:#1D2835;
}
</style>

</head>
<cfoutput>
<body>
<div class="content">
    <div class="content_body">
    	<div class="menulist">
        	<ul>
            	<cfloop query="getMenu">
                <cfif title_define["#getMenu.user_define#"] eq "TRUE">
					<cfif getGsetup.ccode eq "MYR" AND getMenu.menu_id eq "149">
                        <cfset getMenu.menu_name = replace(getMenu.menu_name,"IRAS","GAF")>
                    </cfif>                
            	<li>
					<cfif husergrpid NEQ "super">
					<a href="#getMenu.menu_url#">
					</cfif>
                	<div class="submenu">
						<cfif husergrpid EQ "super">
						<a href="#getMenu.menu_url#">
						</cfif>
						<div class="title">#getMenu.menu_name#</div>
						<cfif husergrpid EQ "super">
						</a>
						</cfif>
<!--- 						<div id="#getMenu.menu_id#" class="desp">#getMenu.titledesp#</div>
 --->                    </div>
					<cfif husergrpid NEQ "super">
					</a>
					</cfif>
                </li>
                </cfif>
                </cfloop>                
            </ul>
        </div>
    </div>
</div>
</body>
</cfoutput>
</html>
</cfif>