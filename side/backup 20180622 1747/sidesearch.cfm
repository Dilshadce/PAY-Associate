<cfsetting showdebugoutput="no">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Accounting Management System</title>
<link rel="stylesheet" href="/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
<link rel="stylesheet" href="/css/side/side.css"/>
<link rel="stylesheet" href="/css/side/sidesearch.css" />
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
<cfoutput>
<script type="text/javascript">
	var husergrpid='#husergrpid#';
	var dts='#dts#';
</script>
</cfoutput>
<script type="text/javascript" src="/js/side/sidesearch.js"></script>
</head>
<body>
<cfoutput>
<div id="logo_div" class="section"><img alt="Payroll Logo" src="/img/pmslogo.png" /></div>
<div class="section keywordDiv">
	<input type="text" id="keyword" class="textInput" />
</div>
<div class="criteriaDiv">
	<select id="category" class="selectInput">
		<option value="transaction">Transaction</option>
		<option value="customer">Customer</option>
		<option value="supplier">Supplier</option>
	</select>
	<br />
	<select id="attribute" class="selectInput">
		<option value="accno" class="stringAttribute">Account No.</option>
		<option value="fperiod" class="numberAttribute">Period</option>
		<option value="date" class="dateAttribute">Date</option>
		<option value="batchno" class="numberAttribute">Batch No.</option>
		<option value="tranno" class="numberAttribute">Transaction No.</option>
		<option value="reference" class="stringAttribute">Reference</option>
		<option value="refno" class="stringAttribute">Reference 2</option>
		<option value="desp" class="stringAttribute">Description</option>
		<option value="debitamt" class="numberAttribute">Debit Amount</option>
		<option value="creditamt" class="numberAttribute">Credit Amount</option>
		<option value="job" class="stringAttribute">Job</option>
	</select>
	<br />
	<select id="operator" class="selectInput">
		<option value="contain">Contains</option>
		<option value="notContain">Not Contains</option>
		<option value="equalTo">Equal To</option>
		<option value="notEqualTo">Not Equal To</option>
	</select>
</div>
<div class="bottomNavigationDiv">
	<span id="backNavigation"></span>
</div>
</cfoutput>
</body>
</html>