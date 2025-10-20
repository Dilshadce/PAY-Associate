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
			background-image:url(/error/error%20background.png);
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
			color:#f0606d;
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
            <p>Go back to the <a href="/index.cfm" target="_top">Homepage</a> or visit the <a href="/contactus.cfm" target="_self">Help&amp;Support</a>.</p>
        </div>
    </div>
</body>
</html>

<!--- <cfif HcomID NEQ 'supporttest_i'>
    <cfquery name="checkExistError" datasource="payroll_main">
        SELECT * 
        FROM autoErrorEmail
        WHERE companyID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dts)#">
        AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">
        AND errorType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.rootcause.type)#">
        AND occuredAt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.template)#">
        AND diagnostic = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.diagnostics)#">;
    </cfquery>
    
    <cfif checkExistError.recordcount EQ 0>
            
        <cfquery name="insertError" datasource="payroll_main">
            INSERT INTO autoErrorEmail (companyID, userID, errorType, occuredAt, diagnostic, timeOfError)
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dts)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAuthUser()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.rootcause.type)#">,      
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.template)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(error.diagnostics)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#dateTimeFormat(NOW(),'yyyy-mm-dd HH:nn')#">
            )
        </cfquery>
        
        <cfset emailList = 'shicai@mynetiquette.com'>
        <cfmail from="donotreply@manpower.com.my" to="#emailList#" subject="MP4U Portal Error" type="html">
            <table width="500px">
                <tr>
                    <td>Dear Master,</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr>
                    <td>User ID: #HuserID# || User Level: #HuserGrpID# || User Email: #HuserEmail#</td>
                </tr>
                <tr>      
                    <td>Company ID: #HcomID#</td>
                </tr>   
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr>
                    <td>I've encountered the following error:</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr>    
                    <td><strong>Error Type:</strong> #error.rootcause.type#</td>   
                </tr>
                <tr>
                    <td><strong>Occured At:</strong> #error.template#</td>
                </tr>
                <tr>
                    <td><strong>Diagnostics:</strong></td>
                </tr>
                <tr>
                    <td align="justify">#error.diagnostics#</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr>
                    <td><strong>Query String:</strong> #CGI.QUERY_STRING#</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr>
                    <td>Please solved it as soon as possible. Thank you!</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>    
                <tr>
                    <td>Best Regards,</td>
                </tr>
                <tr>
                    <td>IMS server :)</td>
                </tr>
            </table>   
        </cfmail>       
    </cfif>
</cfif> --->