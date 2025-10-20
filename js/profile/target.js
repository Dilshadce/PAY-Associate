// JavaScript Document
$(document).ready(function(e) {
	if(action=='Create'){
		$('#custno').parent().parent().parent().children('.help-block').html(targetTitle+' Numbers is required.').show();
		$('#custno').parent().parent().parent().parent().removeClass('has-success').addClass('has-error');
		$('#name2').parent().children('.help-block').html(targetTitle+' Name is required to be filled in Line 1.').show();
		$('#name').parent().parent().removeClass('has-success').addClass('has-error');
		$('#name2').parent().parent().removeClass('has-success').addClass('has-error');
		$('#submit').attr('disabled',true);
	}
		
	$('#custno').on('keyup',function(e){
		var codepatern = new RegExp(/[\w]{4,4}[/][\w]{3,3}/g);
		if($(this).val()==''){
			$(this).parent().parent().parent().children('.help-block').html(targetTitle+' Numbers is required.').show();
			$(this).parent().parent().parent().parent().removeClass('has-success').addClass('has-error');
		}else if(!$(this).val().match(codepatern)){
			$(this).parent().parent().parent().children('.help-block').html(targetTitle+' Numbers is required in format of XXXX/XXX.').show();
			$(this).parent().parent().parent().parent().removeClass('has-success').addClass('has-error');
		}else if($(this).val().split(/[/]/g)[1]=='000'){
			$(this).parent().parent().parent().children('.help-block').html(targetTitle+' Numbers surfix cannot be 000.').show();
			$(this).parent().parent().parent().parent().removeClass('has-success').addClass('has-error');
		}else if(!custnoInRange()){
			$(this).parent().parent().parent().children('.help-block').html(targetTitle+' Numbers is out of range from '+codefr+' to '+codeto+' .').show();
			$(this).parent().parent().parent().parent().removeClass('has-success').addClass('has-error');			
		}else{
			$(this).parent().parent().parent().children('.help-block').hide();
			$(this).parent().parent().parent().parent().removeClass('has-error').addClass('has-success');
			custnoExist();
		}
		if($(document).find('.has-error').length>0){
			$('#submit').attr('disabled',true);
		}else{
			$('#submit').removeAttr('disabled');
		}
	});
	
	$('#name').on('keyup',function(e){
		if($(this).val()==''){
			$('#name2').parent().children('.help-block').html(targetTitle+' Name is required to be filled in Line 1.').show();
			$('#name').parent().parent().removeClass('has-success').addClass('has-error');
			$('#name2').parent().parent().removeClass('has-success').addClass('has-error');
		}else{
			$('#name2').parent().children('.help-block').hide();
			$('#name').parent().parent().removeClass('has-error').addClass('has-success');
			$('#name2').parent().parent().removeClass('has-error').addClass('has-success');
			nameExist();
		}		
		if($(document).find('.has-error').length>0){
			$('#submit').attr('disabled',true);
		}else{
			$('#submit').removeAttr('disabled');
		}
	});
	
	$('#name2').on('keyup',function(e){
		$('#name2').parent().children('.help-block').hide();
		$('#name').parent().parent().removeClass('has-error').addClass('has-success');
		$('#name2').parent().parent().removeClass('has-error').addClass('has-success');
		nameExist();		
		if($(document).find('.has-error').length>0){
			$('#submit').attr('disabled',true);
		}else{
			$('#submit').removeAttr('disabled');
		}
	});
	
	$('.input-group.date').datepicker({
		format: "dd/mm/yyyy",
		todayBtn: "linked",
		autoclose: true,
		todayHighlight: true
	});
	
	$('.btn-toggle').on('click',function(e){
		$(this).find('.btn').toggleClass('active');
		if ($(this).find('.btn-primary').size()>0) {
			$(this).find('.btn').toggleClass('btn-primary');
		}
		$(this).find('.btn').toggleClass('btn-default');
	});
	
	$('.ngst').on('click',function(e){
		if($('#ngst_cust').attr('disabled')){
			$('#ngst_cust').removeAttr('disabled');
		}else{
			$('#ngst_cust').attr('disabled',true);
		}
	});
	
	$('.termExceed').on('click',function(e){
		if($('#termExceed').attr('disabled')){
			$('#termExceed').removeAttr('disabled');
		}else{
			$('#termExceed').attr('disabled',true);
		}
	});
	
	$('.lc_ex').on('click',function(e){
		if($('#lc_ex').val()==0){
			$('#lc_ex').val(1);
		}else{
			$('#lc_ex').val(0);
		}
	});
	
	$('#currcode').on('change',function(e){
		var selected=$(this).find('option:selected');
		$('#currency').val(selected.data('symbol'));
		$('#currency1').val(selected.data('description'));
	});
});

function custnoInRange(){
	var check = new Boolean(true);
	for(var start = 0; start <= codefr.length; start++){
		if(($('#custno').val().split(/[/]/g)[0].charAt(start) >= codefr.charAt(start)) && ($('#custno').val().split(/[/]/g)[0].charAt(start) <= codeto.charAt(start))){
			return true;
		}else{
			return false;
		}
	}
}

function custnoExist(){
	$.ajax({
		'dataType':'json',
		'type':'POST',
		'url':'/latest/maintenance/target.cfc',
		'data':{
			method:'checkCustNoExist',
			returnformat:'json',
			dts:dts,
			targetTable:targetTable,
			custno:$('#custno').val()
		},
		'success':function(data,status,jqXHR){
			if(data.recordTotal>=1){
				$('#custno').parent().parent().parent().children('.help-block').html($('#custno').val()+' has been assigned to other '+targetTitle+'. Please try other '+targetTitle+' Numbers.').show();
				$('#custno').parent().parent().parent().parent().removeClass('has-success').addClass('has-error');
			}
		}
	});
}

function nameExist(){
	$.ajax({
		'dataType':'json',
		'type':'POST',
		'url':'/latest/maintenance/target.cfc',
		'data':{
			method:'checkNameExist',
			returnformat:'json',
			dts:dts,
			targetTable:targetTable,
			name:$('#name').val(),
			name2:$('#name2').val()
		},
		'success':function(data,status,jqXHR){
			if(data.recordTotal>=1){
				$('#name2').parent().children('.help-block').html($('#name').val()+' '+$('#name2').val()+' has been used by other '+targetTitle+'. Please try other name.').show();
				$('#name').parent().parent().removeClass('has-success').addClass('has-error');
				$('#name2').parent().parent().removeClass('has-success').addClass('has-error');
			}
		}
	});
}