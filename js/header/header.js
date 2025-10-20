// JavaScript Document
$(document).ready(function(e){
	//Notification
	/*var stack_topleft = {"dir1": "down", "dir2": "right", "push": "top"};
	$.pnotify.defaults.styling = "jqueryui";
	$.pnotify({
		addclass: 'notification',
    	text: '<a href="/body/inviteFriend.cfm" target="mainFrame">Click here to invite a friend and earn 25% incentive for their first subscription.</a>',
    	type: 'info',
		hide: false,
		history: false,
    	icon: false,
		sticker: false,
		stack: false,
        before_open: function(pnotify) {
            // Position this notice in the center of the screen.
            pnotify.css({
                "top": 33,
                "left": 0,
            });
		},
	});*/
	/*var initialWidth=60;
	var expandedWidth=initialWidth+$('.item_content').width()+10;
	$('.expandable').animate({width:expandedWidth}, 700);
	$('.item_content').fadeIn(400,function(){
		$('.expandable').find('p').stop(true,true).fadeIn(600);
	})*/;
	//Expandable Company info
	var initialWidth=60;
	var expandedWidth=initialWidth+$('.item_content').width()+10;
	$('.expandable').hover(
		function(){
			$(this)
				.stop().animate({width:expandedWidth}, 700)
				.find('.item_content').fadeIn(400,function(){
					$(this).find('p').stop(true,true).fadeIn(600);
				});	
		},
		function(){
			$(this)
				.stop().animate({width:initialWidth}, 700)
				.find('.item_content').stop(true,true).fadeOut().find('p').stop(true,true).fadeOut();
		}
	);
});