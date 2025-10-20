<!---New page for resetting password by associate, [20170927, Alvin]--->
<cfsetting showDebugOutput = 'no'>
<cfoutput> 
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
            <link rel="shortcut icon" href="/images/mp.ico" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>MP4U Forgot Password</title>
            <link rel="stylesheet" type="text/css" href="/css/login/style.css" />
            <link rel="stylesheet" type="text/css" href="/css/login/lessframework4.css" />
            <body>
                <div class="main fix">
                    <div class="header_area fix">
                        <div class="header structure fix">
                            <img src="/img/login/head_text.png" alt="MP4U Logo"  width="330" />
                        </div>
                    </div>
                    <div class="main_body_area fix">
                        <div class="main_body structure fix">
                            <nobr><h2>Reset Success</h2></nobr>
                            <div class="form_heading fix" style="text-align:center">
                                <br/><h1>MP4U</h1><br/>
                            </div>
                            <div class="input fix">
                                <p style="font-size: 15px">A password reset request for <b>#form.username#</b> has been sent. If <b>#form.username#</b> is associated with MP4U, you should receive an email containing instruction to login. Kindly login and change the password.</p>
                                <br />
                                <p style="font-size: 15px">If you did not receive an email from us, kindly check the spam or junk folder for email coming from donotreply@manpower.com.my</p>
                                <br />
                                <p style="font-size: 15px">Alternatively, you may contact myhrhelpdesk@manpower.com.my (Hotline: +6 03 2087 0033) for further assistance.</p>
                            </div>
                        </div>
                        <br /><center><p><a class="reset" href="https://www.mp4u.com.my" style="color: blue">Return to sign in</a></p></center>
                    </div>
                </div>
            </body>
        </head>
    </html> 
</cfoutput>