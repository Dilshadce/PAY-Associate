// JavaScript Document
$(document).ready(function(){
    $('#wrapper').css({
		'width':$('#wrapper img').width(),
		'height':$('#wrapper img').height()
    })
                 
    for (i=0; i<$(".pin").length; i++){
		$('.pin').eq(i).css({
			'position':'absolute',
			'left':$(".pin").eq(i).data('x')+'px',
			'top':$(".pin").eq(i).data('y')+'px',
			'display':'block',
			'width':'21px',
			'height':'21px',
			'border-radius':'10px',
			'background':'none',
			'cursor':'pointer'
		});
    }
	
	$('.pin').popover({
		html:true,
		placement:'auto right',
		trigger:'manual',
		content:function(){
			return $(this).html();
		},
		container:$(this).attr('id')
	}).on('mouseenter',function(){
		var _this = this;
		$(this).popover('show');
		$(this).siblings('.popover').on('mouseleave',function(){
			$(_this).popover('hide');
		});
	}).on('mouseleave',function(){
		var _this = this;
		setTimeout(function(){
			if (!$('.popover:hover').length){
				$(_this).popover('hide');
			}
		},100);
	});
});