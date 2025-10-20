function ajaxFunction(field,file)
{
var xmlHttp;
try
  {
  // Firefox, Opera 8.0+, Safari
  xmlHttp=new XMLHttpRequest();

  }
catch (e)
  {
  // Internet Explorer
  try
    {
    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
  catch (e)
    {
    try
      {
      xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
      }
    catch (e)
      {
      alert("Your browser does not support AJAX!");
      return false;
      }
    }
  }
  xmlHttp.onreadystatechange=function()
    {
    if(xmlHttp.readyState==4)
      {
	
		  	field.innerHTML=xmlHttp.responseText;
		  //document.getElementById("time").innerHTML =xmlHttp.responseText;
      }
    }
  xmlHttp.open("GET",file,true);
  xmlHttp.send(null);
  
}

function ajaxFunction1(field,file)
{

var xmlHttp;
try
  {
  // Firefox, Opera 8.0+, Safari
  xmlHttp=new XMLHttpRequest();

  }
catch (e)
  {
  // Internet Explorer
  try
    {
    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
  catch (e)
    {
    try
      {
      xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
      }
    catch (e)
      {
      alert("Your browser does not support AJAX!");
      return false;
      }
    }
  }
  xmlHttp.onreadystatechange=function()
    {
    if(xmlHttp.readyState==4)
      {
	  		
		  	field.innerHTML=xmlHttp.responseText;
			document.getElementById('loading').style.visibility='hidden';
		  //document.getElementById("time").innerHTML =xmlHttp.responseText;
      }
    }
  xmlHttp.open("GET",file,true);
  xmlHttp.send(null);
  
}