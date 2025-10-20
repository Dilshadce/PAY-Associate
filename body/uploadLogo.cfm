<cfif IsDefined("url.action")>
	<cftry>
			<cfset thisImage = ExpandPath("/upload/#LCASE(dts)#/companyLogo.jpg")>            
			<cffile 
            		action = "delete" 
                    file = "#thisImage#">
    <cfcatch type="any">
    </cfcatch>	
	</cftry>
<cfelseif IsDefined("form.submitBtn")>
    <cftry>
        <cfset thisPath = ExpandPath("/upload/#LCASE(dts)#/*.*")>
        <cfset thisDirectory = GetDirectoryFromPath(thisPath)>
     
            <cfdirectory 
                    action = "create" 
                    directory = "#thisDirectory#" >
    <cfcatch>
    </cfcatch>
    </cftry>    
    <cftry>
        <cffile 
            action="upload" 
            destination="#ExpandPath( "/" )#upload\#dts#\companyLogo.jpg" 
            filefield="logo" 
            accept="image/jpeg" 
            strict="true"
            nameconflict="overwrite">
            
            <script type="text/javascript">
				top.frames['topFrame'].document.location.reload(true);
				alert('Company logo was uploaded succeassfully.');
                location.href="/body/overview.cfm";
			</script>
    <cfcatch>
        <script>
            alert("Incorrect file type! Only JPEG image format is allowed!");
        </script>
    </cfcatch>
    </cftry>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!---<meta name="viewport" content="width=device-width, initial-scale=1.0" />--->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Upload Company Logo</title>
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
            if($('#logo')[0].files.length==0){
                errorMsg=errorMsg+'Please upload your Company Logo.';
            }else{
                if($('#logo')[0].files[0].type!='image/jpeg'){
                    errorMsg=errorMsg+'Only JPEG image format is allowed.\n';
                }
                if($('#logo')[0].files[0].size>500*1024){
                    errorMsg=errorMsg+'Only file with file size less than 500KB is allowed.\n';
                }
            }
            if(errorMsg!=''){
                alert(errorMsg);
                return false;
            }else{
                return true;
            }
        }
        
        function confirmDelete(){
            if(confirm("Are you sure want to delete the company logo?")){
                document.getElementById('form').action = "/body/uploadLogo.cfm?action=delete";
                document.form.submit();
            }
        }	
	</script>
	<style>
        .companyLogoImage img{
			height:120px;
			width:130px;
		}
    </style>
</head>
<body>
<cfoutput>
	<cfset thisImage = ExpandPath("/upload/#LCASE(dts)#/companyLogo.jpg")>
    
    <form role="form" id="form" name="form" action="/body/uploadLogo.cfm" method="post" enctype="multipart/form-data" onSubmit="return validate();">
        <div class="container">
            <div class="page-header">
            	<div class="row">
                    <div class="col-sm-8">
                        <h1>Upload Company Logo</h1>
                        <span class="lead text-muted">Only JPEG image file with file size less than 500KB is allowed.</span>
                    </div>
                    <div class="col-sm-4">
                    	<div class="companyLogoImage">
                        	<cfif FileExists(thisImage)>
                    			<img src="/upload/#dts#/companyLogo.jpg" alt="Company Logo" onDblClick="confirmDelete();"/>
                            </cfif>
                        </div>
                    </div>      
                </div>
				<!---
                     <button type="button" id="deleteBtn" name="deleteBtn" class="btn btn-danger pull-right deleteBtn" onClick="confirmDelete();">Delete</button>
                <cfelse>
                     <button type="button" id="deleteBtn" name="deleteBtn" class="btn btn-danger pull-right deleteBtn" style="visibility:hidden;">Delete</button>
                </cfif>	--->
            </div>
            <div class="row">
                <div class="form-group row container">
                    <div class="col-sm-12">
                        <label for="logo">Upload Company Logo</label>
                        <input type="file" class="form-control" id="logo" name="logo" placeholder="Upload your company logo" accept="image/jpeg" required />
                    </div>
                </div>
                <hr />
                <button type="submit" id="submitBtn" name="submitBtn" class="btn btn-default pull-right">Submit</button>
            </div>
        </div>
    </form>
</cfoutput>
</body>
</html>