<cfif IsDefined("form.submit")>
	<cfquery name="getgsetup" datasource="payroll_main">
		SELECT comp_name FROM gsetup
	</cfquery>
	<cfoutput>
		<cfmail to="#form.email#" from="noreply@mynetiquette.com" subject="#form.subject#" type="html">
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
					<html xmlns="http://www.w3.org/1999/xhtml">
					<head>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
					<title>#form.subject#</title>
					</head>
					<body style="margin: 0; padding: 0; background-color: ##fff;">
					<div style="background-color: ##fff !important;"> <br />
						<table width="600" align="center" cellpadding="0" cellspacing="0" style="background-color: ##fff;">
							<tr>
								<td>
									<table width="600" cellpadding="0" cellspacing="0">
										<tr>
											<td width="4"><img src="http://PAY/img/header/inviteFriend/border-top-left.gif" width="4" height="5" alt="" style="display: block;" /></td>
											<td width="592" valign="top"><div style="border-top: 1px solid ##ccc; font-size: 1px; line-height: 1px;">&nbsp;</div></td>
											<td width="4"><img src="http://PAY/img/header/inviteFriend/border-top-right.gif" width="4" height="5" alt="" style="display: block;" /></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td style="border-left: 1px solid ##ccc; border-right: 1px solid ##ccc;">
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td style="padding-top: 10px; padding-left: 20px; padding-bottom: 10px; padding-right: 20px;">
												<table width="100%" cellpadding="0" cellspacing="0">
													<tr>
														<td  valign="bottom"><h2 style="font-family: Arial, Helvetica, sans-serif; font-size: 22px; color: ##000 !important; margin: 0; padding: 0px;padding-top: 20px;">#getgsetup.comp_name# think you should try Netiquette Accounting Management System</h2></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<table width="100%" cellpadding="0" cellspacing="0" style="background-color: ##9FDB22;">
										<tr>
											<td height="5" style="font-size: 1px; line-height: 1px;">&nbsp;</td>
										</tr>
									</table>
									<br />
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td style="padding-left: 20px; padding-right: 20px; font-family: Arial, Helvetica, sans-serif; font-size: 14px; color: ##000; line-height: 20px;"> 
												#form.content#<br />
												Try <a style="height:35px; width:50px; dispay:block; color:##36F;" href="http://www.mynetiquette.com">Netiquette</a> at <a style="height:35px; width:50px; dispay:block; color:##36F;" href="http://crm.netiquette.com.sg/signupnew/signup.cfm">http://crm.netiquette.com.sg/signupnew/signup.cfm</a>											
												<br /><br /><br />
												Best regards,<br />
												#getgsetup.comp_name#
											</td>
										</tr>
									</table>
									<table width="100%" cellpadding="0" cellspacing="0" style="border-top: 1px solid ##ccc;">
										<tr>
											<td valign="bottom" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; line-height: 14px; color: ##888; padding-left: 20px; padding-top: 10px;">
												Sent using Netiquette, <br />
												Cloud Accounting Solution Designed for Small Business Owners. <br />
												<a href="http://trial.mynetiquette.com" style="color: ##00f;">Get your free account</a>.
											</td>
											<td align="right" valign="bottom" style="padding-top: 10px; padding-right: 20px;">
												<a href="http://www.netiquette.com.sg">
												<img src="http://PAY/img/header/inviteFriend/logo.jpg" width="56" height="23" alt="Netiquette" border="0" style="display: block;" />
												</a>
											</td>
										</tr>
									</table>
									&nbsp;<br />
								</td>
							</tr>
							<tr>
								<td>
									<table width="600" cellpadding="0" cellspacing="0">
										<tr>
											<td width="4"><img src="http://PAY/img/header/inviteFriend/border-bl.gif" alt="" width="4" height="4" style="display: block;" /></td>
											<td width="592" style="border-bottom: 1px solid ##ccc; font-size: 1px; line-height: 1px;">&nbsp;</td>
											<td width="4"><img src="http://PAY/img/header/inviteFriend/border-br.gif" alt="" width="4" height="4" style="display: block;" /></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td><img src="http://PAY/img/header/inviteFriend/border-shadow.gif" width="600" height="15" alt="" style="display: block;" /></td>
							</tr>
						</table>
					</div>
					</body>
					</html>
		</cfmail>
	</cfoutput>
	<script type="text/javascript">
		alert('Thank you. Your invitation has been send to your friend.');
	</script>
</cfif> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Invite Friend</title>
<link rel="stylesheet" type="text/css" href="/css/bootstrap/bootstrap.min.css" />
<!--[if lt IE 9]>
	<script type="text/javascript" src="/js/html5shiv/html5shiv.js"></script>
	<script type="text/javascript" src="/js/respond/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript">
function validate(){
	var errorMsg='';
	if($('#email').val()==''){
		errorMsg=errorMsg+'Please input your email.\n';
	}
	if(!$('#email').val().match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/g)){
		errorMsg=errorMsg+'Please input valid email.\n';
	}
	if($('#subject').val()==''){
		errorMsg=errorMsg+'Please input your subject.\n';
	}
	if($('#description').val()==''){
		errorMsg=errorMsg+'Please input your description.\n';
	}
	if(errorMsg!=''){
		alert(errorMsg);
		return false;
	}else{
		return true;
	}
}
</script>
</head>
<body>
	<div class="container">
		<div class="page-header">
			<h1>Tell Your Friends About Netiquette Payroll Management System</h1>
			<span class="lead text-muted">Invite a friend and earn 25% incentive for their first subscription</span>
		</div>
		<div class="row">
			<form role="form" class="container" action="/body/inviteFriend.cfm" method="post" onsubmit="return validate();">
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="email">Friend's Email</label>
						<input type="email" class="form-control" id="email" name="email" placeholder="Enter your friend's email address." required="required" />
					</div>
				</div>				
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="subject">Subject</label>
						<input type="text" class="form-control" id="subject" name="subject" placeholder="Enter subject for invitation email." value="Lets Try Netiquette Payroll Management System" required="required" />
					</div>
				</div>				
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="content">Content</label>
						<textarea class="form-control" id="content" name="content" rows="5" placeholder="Enter content for invitation email." style="resize:none;" required="required">Thought you might be interested in this. I've been using it for a few weeks now and it's pretty awesome.</textarea>
					</div>
				</div>
				<hr />
				<button type="submit" id="submit" name="submit" value="submit" class="btn btn-default pull-right">Submit</button>
			</form>
		</div>
	</div>
</body>
</html>