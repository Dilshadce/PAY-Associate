// JavaScript Document
$(document).ready(function() {
	$('#menu').hoverscroll({
		vertical:true,
		width:'100%',
		height:$('#bottomDiv').position().top-$('#menu').position().top,
		arrows:false
	});
	
	//Navigation
	$('#searchNavigation').on('click',function(e){
		window.open('/side/sidesearch.cfm','_self');
	});
	$('#favoriteNavigation').on('click',function(e){
		window.open('/side/sidefavorite.cfm','_self');
	});
	
	// Store variables
	var accordion_head = $('.accordion > li > a');
	var accordion_body = $('.accordion li > .sub-menu');
	
	// Open the first tab on load
	//accordion_head.first().addClass('active').next().slideDown('normal');
	
	// Click function
	accordion_head.on('click', function(event) {
		
		// Disable header links
		event.preventDefault();
		
		// Show and hide the tabs on click
		if ($(this).attr('class') != 'active'){
			accordion_body.slideUp('normal');
			$(this).next().stop(true,true).slideToggle('normal');
			accordion_head.removeClass('active');
			$(this).addClass('active');
		}else{			
			accordion_body.slideUp('normal');
			accordion_head.removeClass('active');
		};
	});
	
	//Store varaiables
	var submenu_item = $('.sub-menu > li > a');
	
	//Show and hide the direction icon on the submenu
	submenu_item.on('click', function(e){
		if($(this).attr('class')!='active'){
			submenu_item.removeClass('active');
			$(this).addClass('active');
		};
	});
});