<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Support</title>
<link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/css/body/support.css" />
<!--[if lt IE 9]>
	<script type="text/javascript" src="/js/html5shiv/html5shiv.js"></script>
	<script type="text/javascript" src="/js/respond/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript" src="/js/body/support.js"></script>
</head>
<body>
	<div class="container">
		<div class="page-header">
			<h1>How Can We Help?</h1>
			<span class="lead text-muted">Need some personal assistance? You just need to ask:</span>
		</div>
		<div class="row">
			<form role="form" class="container" action="/body/sendSupportEmail.cfm" method="post" enctype="multipart/form-data" onsubmit="return validate();">
				<input type="hidden" id="companyid" name="companyid" value="<cfoutput>#listgetat(DSNAME,'1','_')#</cfoutput>" />
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="subject">Subject</label>
						<input type="text" class="form-control" id="subject" name="subject" placeholder="Enter subject" required="required" />
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="description">Description</label>
						<textarea class="form-control" id="description" name="description" rows="5" placeholder="Enter description" style="resize:none;" required="required"></textarea>
					</div>
				</div>
				<div class="form-group row">
					<div id="attachments" class="col-sm-12">
						<label>Attachments <em class="text-muted">(screenshots and highlights)</em></label>
						<input type="hidden" id="attachmentsNumber" name="attachmentsNumber" value="0" />
						<input type="file" class="form-control attachment last" id="attachment0" name="attachment0" placeholder="Upload attachment" accept="image/jpeg" />						
					</div>
				</div>
				<hr />
				<button type="submit" class="btn btn-default pull-right">Submit</button>				
			</form>
		</div><br /><br />
		<div class="row">
			<div class="col-sm-4">
				<img class="center-block" alt="Support Line Icon" src="/img/body/Support_Line_Icon.png" width="80px" height="80px" />
				<h4 class="text-muted text-center btmSubTitle">Support Line</h4><br />
				<div class="row">
					<div class="col-sm-2"></div>
					<h4 class="text-muted col-sm-4 btmSubContent">Singapore</h4>
					<h4 class="text-muted col-sm-4 btmSubContent">+65 62231157</h4>
					<div class="col-sm-2"></div>
				</div>
				<div class="row">
					<div class="col-sm-2"></div>
					<h4 class="text-muted col-sm-4 btmSubContent">Malaysia</h4>
					<h4 class="text-muted col-sm-4 btmSubContent">+603 79843018</h4>
					<div class="col-sm-2"></div>
				</div>
				<div class="row">
					<div class="col-sm-2"></div>
					<h4 class="text-muted col-sm-4 btmSubContent">Hong Kong</h4>
					<h4 class="text-muted col-sm-4 btmSubContent">+852 22426111</h4>
					<div class="col-sm-2"></div>
				</div>
				<div class="row">
					<div class="col-sm-2"></div>
					<h4 class="text-muted col-sm-4 btmSubContent">Thailand</h4>
					<h4 class="text-muted col-sm-4 btmSubContent">083 137 8880</h4>
					<div class="col-sm-2"></div>
				</div>			
			</div>
			<div class="col-sm-4" id="remoteAssistanceDiv">
				<img class="center-block" alt="Remote Assistance Icon" src="/img/body/Remote_Assistance_Icon.png" width="80px" height="80px;" />
				<h4 class="text-muted text-center btmSubTitle">Remote Assistence</h4><br />
				<a href="https://www.teamviewer.com/link/?url=505374&id=625664214" target="_self"><h4 class="text-muted text-center btmSubContent">Team Viewer >></h4></a><br />
				<a href="https://showmypc.com/ShowMyPC3150.exe" target="_self"><h4 class="text-muted text-center btmSubContent">ShowMyPc >></h4></a><br />
			</div>
			<div class="col-sm-4">
				<img class="center-block" alt="Help Centre Icon" src="/img/body/Help_Centre_Icon.png" width="80px" height="80px" />
				<h4 class="text-muted text-center btmSubTitle">Help Centre</h4><br />
				<a href="/ext/docs/index.cfm" target="_self"><h4 class="text-muted text-center btmSubContent">Find out more >></h4></a><br />
			</div>
		</div>
	</div>
</body>
</html>