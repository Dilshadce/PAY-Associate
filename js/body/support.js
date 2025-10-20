// JavaScript Document
$(document).ready(function(e) {
	$('#attachments').on('change','.attachment',function(e){
		if($(this).hasClass('last')&&$(this)[0].files.length!=0){
			$(this).removeClass('last');
			attachmentsNumber=parseInt($('#attachmentsNumber').val(),10);
			attachmentsNumber=attachmentsNumber+1;
			$('#attachmentsNumber').val(attachmentsNumber);
			$('#attachments').append('<br /><input type="file" class="form-control attachment last" id="attachment'+attachmentsNumber+'" name="attachment'+attachmentsNumber+'" placeholder="Upload attachment" accept="image/jpeg" />');
		}
	});
});
function validate(){
	var errorMsg='';
	if($('#name').val()==''){
		errorMsg=errorMsg+'Please input your name.\n';
	}
	if($('#email').val()==''){
		errorMsg=errorMsg+'Please input your email.\n';
	}
	if(!$('#email').val().match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/g)){
		errorMsg=errorMsg+'Please input valid email.\n';
	}
	if($('#subject').val()==''){
		errorMsg=errorMsg+'Please input your subject.\n';
	}
	if($('#description').val()==''){
		errorMsg=errorMsg+'Please input your description.\n';
	}
	if(errorMsg!=''){
		alert(errorMsg);
		return false;
	}else{
		return true;
	}
}