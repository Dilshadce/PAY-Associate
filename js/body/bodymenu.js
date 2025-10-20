// JavaScript Document
$(document).ready(function(e) {
	$('.desp').editable('/body/bodymenu.cfc',{
		id:$(this).attr('id'),
		name:'desp',
		cancel:'Cancel',		
		submit:'OK',
		indicator : 'Updating...',
		placeholder:'<b>Click to add description.</b>',
		tooltip:'Click to update description.',
		type:'textarea',
		submitdata:{
			method:'updateDesp',
			returnformat:'plain',
			dts:dts,
			authUser:authUser,
		},
		data: function(value, settings) {
			var retval = value.replace(/<br[\s\/]?>/gi, '\n');
			return retval;
    	},
		onsubmit:function(){
			return confirm('Are you confirm to update this menu description?');
		},
	});
});