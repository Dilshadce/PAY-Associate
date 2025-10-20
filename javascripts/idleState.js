var idleTime	= 600000;
var timeOut		= '';
var t = "";
function init() {
	
	Event.observe(document.body, 'mousemove', resetIdle, true);
	
	setIdle();
	
}

function onIdleFunction(){
	
	var answer = confirm('Your session left 30 seconds. Do you still want to keep log on? Press OK to continue and CANCEL to log out');
	
	if(answer)
	{
	window.clearTimeout( timeOut );
	setIdle();
	}
	else
	{
	 onOverTime();	
	}
	
}

function resetIdle(){
	
	window.clearTimeout( timeOut );
	window.clearTimeout( t );
	setIdle();
	
}

function setIdle(){
	
	timeOut = window.setTimeout( "onOverTime()", idleTime );
	t = window.setTimeout( "onIdleFunction()", idleTime - 30000 );
}

function onOverTime()
{
	window.location.href="/logout.cfm";
}

Event.observe(window, 'load', init, false);