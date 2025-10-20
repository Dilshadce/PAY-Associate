<html>
<head>
	<title>Update CPF Refund</title>
	<link href="/stylesheet/app.css" rel="stylesheet" type="text/css">
	<link href="/stylesheet/tabber.css" rel="stylesheet" TYPE="text/css" MEDIA="screen">
</head>

<body>

<div class="tabber">

<form name="" action="" method="post">
<table>
	<tr>
		<th width="120px">Employee Number</th>
		<td><input type="text" name="empno" value=""></td>
	</tr>
	<tr>
		<th width="100px">Name</th>
		<td colspan="5"><input type="text" name="name" value="" size="50"></td>
	</tr>
	<tr>
		<th width="100px">CPF No.</th>
		<td><input type="text" name="epfno" value=""></td>
	</tr>
	<tr><td colspan="6">&nbsp</td></tr>
	<tr><td colspan="6">&nbsp</td></tr>
	<tr>
		<th width="100px">Month</th>
		<th width="120px">A.Wages[Paid]</th>
		<th width="120px">A.Wages[Ceiling]</th>
		<th width="120px">Payable[YEE]</th>
		<th width="120px">Payable[YER]</th>
		<th width="120px">Payable[Total]</th>
	</tr>
	
	<tr style="width:100%; height:300px; overflow:auto;">
		<td><input type="text" name="mth" value=""></td>
		<td><input type="text" name="paid" value=""></td>
		<td><input type="text" name="ceiling" value=""></td>
		<td><input type="text" name="yee" value=""></td>
		<td><input type="text" name="yer" value=""></td>
		<td><input type="text" name="total" value=""></td>
	</tr>
</table>
<br />

<center>
	<input type="reset" name="reset" value="Reset">
	<input type="submit" name="save" value="Save">
	<input type="button" name="exit" value="Exit" onclick="window.close();">
</center>

</form> 

</div>
</body>
</html>