// JavaScript Document
$(document).ready(function(e) {
	$('#menu_id').select2({
		width:'208px',
		//134,173
	});
	/*$('#back').on('click',function(e){
		window.open('/side/sidemenu.cfm','_self');
	});*/
	$('#backNavigation').on('click',function(e){
		window.open('/side/sidemenu.cfm','_self');
	});
	//$('#add').on('click',function(e){
	$('#menu_id').on('change',function(e){
		var menu_id=$('#menu_id').val();
		var newFavorite='';
		$.ajax({
			type:'POST',
			url:'/side/sidefavorite.cfc',
			dataType:'json',
			data:{
				method:'addFavorite',
				returnformat:'json',
				dts:dts,
				menu_id:menu_id,
				menuname:menuname,
			},
			cache:false,
			success: function(result){
				newFavorite=result;				
			},
			error: function(jqXHR,textStatus,errorThrown){
				alert(errorThrown);
			},
			complete: function(){
				$('.favoriteList ul').append(
					'<li>'+
					'<a href="../'+newFavorite.menu_url+'" target="mainFrame">'+newFavorite.menu_name+'</a>'+
					'<span class="remove"><input class="favorite_id" type="hidden" value="'+newFavorite.favorite_id+'" /></span>'+
					'</li>'
				);
				$('#menu_id').select2('val','');					
			}
		});
	});
	$('.favoriteList').on('click','.remove',function(e){
		var currentSelector=$(this);
		var favorite_id=$(this).children('.favorite_id').val();
		$.ajax({
			type:'POST',
			url:'/side/sidefavorite.cfc',
			dataType:'json',
			data:{
				method:'removeFavorite',
				returnformat:'json',
				dts:dts,
				favorite_id:favorite_id,
			},
			cache:false,
			success: function(result){
			},
			error: function(jqXHR,textStatus,errorThrown){
				alert(errorThrown);
			},
			complete: function(){
				currentSelector.parent('li').remove();
			}
		});
	});
});