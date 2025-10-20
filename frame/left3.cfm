<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<script type="text/javascript">
	<!--
	window.onload=show;
	function show(id){
		var d = document.getElementById(id);
		for(var i = 1; i<=10; i++){
			if(document.getElementById('smenu'+i)){
				document.getElementById('smenu'+i).style.display='none';
			}
		}
		if(d){d.style.display='block';
		}
	}
	//-->
	</script>
	<style type="text/css" media="screen">
	<!-- 
	body {
	margin: 0;
	padding: 0;
	background: white;
	font: 80% verdana, arial, sans-serif;
	}
	dl, dt, dd, ul, li {
	margin: 0;
	padding: 0;
	list-style-type: none;
	}
	#menu {
	position: absolute; /* Menu position that can be changed at will */
	top: 0;
	left: 0;
	}
	#menu {
	width: 15em;
	}
	#menu dt {
	cursor: pointer;
	margin: 2px 0;;
	height: 20px;
	line-height: 20px;
	text-align: center;
	font-weight: bold;
	border: 1px solid gray;
	background: #ccc;
	}
	#menu dd {
	border: 1px solid gray;
	}
	#menu li {
	text-align: center;
	background: #fff;
	}
	#menu li a, #menu dt a {
	color: #000;
	text-decoration: none;
	display: block;
	border: 0 none;
	height: 100%;
	}
	#menu li a:hover, #menu dt a:hover {
	background: #eee;
	}
	-->
	</style>
</head>

<body>
<dl id="menu">
		<dt onclick="javascript:show();"><a href="#">Menu 1</a></dt>
		<dt onclick="javascript:show('smenu2');">Menu 2</dt>
			<dd id="smenu2">
				<ul>
					<li><a href="#">sub-menu 2.1</a></li>
					<li><a href="#">sub-menu 2.2</a></li>
					<li><a href="#">sub-menu 2.3</a></li>
				</ul>
			</dd>	

		<dt onclick="javascript:show('smenu3');">Menu 3</dt>
			<dd id="smenu3">
				<ul>
					<li><a href="#">sub-menu 3.1</a></li>
					<li><a href="#">sub-menu 3.1</a></li>
					<li><a href="#">sub-menu 3.1</a></li>
					<li><a href="#">sub-menu 3.1</a></li>
					<li><a href="#">sub-menu 3.1</a></li>
					<li><a href="#">sub-menu 3.1</a></li>
				</ul>
			</dd>

		<dt onclick="javascript:show('smenu4');">Menu 4</dt>
			<dd id="smenu4">
				<ul>
					<li><a href="#">sub-menu 4.1</a></li>
					<li><a href="#">sub-menu 4.1</a></li>
				</ul>
			</dd>
	
</dl>
</body>
</html>
