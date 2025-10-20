<html>
<head>
	<title>Print Tax Letter</title>
    <link rel="shortcut icon" href="/PMS.ico" />
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfoutput>
<div class="mainTitle">Print Tax Letter</div>
<div class="tabber">
<form name="gForm" id="gForm" action="printTaxLetterRep.cfm" method="post" target="_blank" <cfif get_comp.empno neq "test">onsubmit="alert('Not Available At The Moment');return false;"</cfif>>

</cfoutput>

<br />
	<input type="submit" name="submit" value="Print">
</form>
</div>

</body>
</html>

