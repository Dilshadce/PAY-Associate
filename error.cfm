<cflog file="application" text="#error.rootcause.type# Error happend at #error.template# : #error.diagnostics#">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Sorry, something went wrong!</title>
    <style>
		.container{
			margin:0;
			padding:0;
			background:#E5E5E5;	
		}
		.main{
			height:70%;
			min-height:530px;
			width:100%;
			min-width:1148px;
			background-image:url(/latest/img/error/error%20background.png);
			background-repeat:no-repeat;
			background-size:100% 100%;
		}
		.message{
			position:absolute;
			top:100px;
			left:30px;
			font-family:"Franklin Gothic Book";
		}
		.message h1{
			margin:0;
			font-weight:normal;
			font-size:100px;
			word-spacing:0.01em;
			color:#333333;
		}
		.message h3{
			margin:0;
			font-weight:normal;
			font-size:30px;
			color:#666666;
		}
		.message p{
			font-weight:normal;
			font-size:20px;
			color:#808080;
		}
		.message a{
			text-decoration:none;
			font-family:"Franklin Gothic Medium";
			color:#4FAF7A;
		}
    </style>
</head>
<body class="container">
    <div class="main">
        <div class="message">
            <h1>OOPS!</h1>
            <h3>
                Something went wrong!<br />
                Sorry. We've let our engineers know.
            </h3>
            <p>Go back to the <a href="/index.cfm" target="_top">Homepage</a> or visit the <a href="/latest/body/support.cfm" target="_self">Help&amp;Support</a>.</p>
        </div>
    </div>
</body>
</html>

