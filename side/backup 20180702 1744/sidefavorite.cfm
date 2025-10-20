<cfsetting showdebugoutput="no">
<cfif husergrpid EQ "super">
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
</cfif>
<!---

<cfquery name="getGsetup" datasource="#dts#">
	SELECT dflanguage FROM gsetup
</cfquery>
<cfif getGsetup.dflanguage NEQ "english">
	<cfset menu_name=getGsetup.dflanguage>
<cfelse>
	<cfset menu_name="menu_name">
</cfif>
--->

<cfquery name="getMyFavorite" datasource="#dts#">
	SELECT mf.favorite_id AS favorite_id, m.#menu_name# AS menu_name, m.menu_url AS menu_url
	FROM myfavorite AS mf
	LEFT JOIN payroll_main.menu AS m
	ON mf.menu_id=m.menu_id
	ORDER BY mf.favorite_id
</cfquery>
<cfquery name="getLevel2And3Menu" datasource="#dts#">
	SELECT m.menu_id AS menu_id,m.#menu_name# AS menu_name,m.menu_url AS menu_url
	FROM payroll_main.menu AS m
	LEFT JOIN userpin AS u
	ON m.menu_id=u.menu_id
	WHERE m.menu_level=2
	OR m.menu_level=3
<!--- 	AND u.#pin#="T"
 --->	ORDER BY m.#menu_name#
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Accounting Management System</title>
<link rel="stylesheet" href="/css/select2/select2.css" />
<link rel="stylesheet" href="/css/side/side.css" />
<link rel="stylesheet" href="/css/side/sidefavorite.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/select2/select2.min.js"></script>
<cfoutput>
<script type="text/javascript">
	var dts='#dts#';
	var menu_name='#menu_name#';
</script>
</cfoutput>
<script type="text/javascript" src="/js/side/sidefavorite.js"></script>
</head>
<body>
<cfoutput>
<div id="logo_div" class="section"><img alt="Payroll Logo" src="/img/pmslogo.png" /></div>
<div class="section addFavorite">
	<!--- <button id="back">Back</button> --->
	<select id="menu_id">
		<option value="">Add your favourite</option>
		<cfloop query="getLevel2And3Menu">
		<option value="#getLevel2And3Menu.menu_id#">#getLevel2And3Menu.menu_name#</option>
		</cfloop>		
	</select>
	<!--- <button id="add">Add</button> --->
</div>
<div class="section favoriteList">
	<ul>
		<cfloop query="getMyFavorite">
		<li>
			<a href="../#getMyFavorite.menu_url#" target="mainFrame">#getMyFavorite.menu_name#</a>
			<span class="remove"><input class="favorite_id" type="hidden" value="#getMyFavorite.favorite_id#" /></span>
		</li>
		</cfloop>
	</ul>
</div>
<div class="bottomNavigationDiv">
	<span id="backNavigation"></span>
</div>
</cfoutput>
</body>
</html>