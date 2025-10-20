// JavaScript Document
$(document).ready(function(e) {
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'ACCOUNT','mData':'accno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':targetTitle.toUpperCase(),'mData':'desp','bSortable':true,'sWidth':'60%'},
				{
					'aTargets':[2],
					'sTitle':'OPENING BALANCE',
					'mData':'lastybal',
					'bSortable':true,
					'sWidth':'20%',
					'sClass':'text-right',
					'mRender':function(data,type,row){
						return data.toFixed(2);
					}
				},
				{
					'aTargets':[3],
					'sTitle':'ACTION',
					'mData':'accno',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="openFormModal(\''+data+'\',\''+row.desp+'\',\''+row.lastybal.toFixed(2)+'\');"></span>';
					}
				}
        	],
			'bAutoWidth':true,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':true,
			'fnServerParams':function(aoData){
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"target","value":''+target+''}
				);
        	},
			'sAjaxSource':'/latest/maintenance/lastyearaging.cfc',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		})
		.fadeIn();
		
		var datatable = $('.dataTable');
        // SEARCH - Add the placeholder for Search and Turn this into in-line formcontrol
        var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
        search_input.attr('placeholder', 'Search')
        search_input.addClass('form-control input-small')
        search_input.css('width', '250px')
 
        // SEARCH CLEAR - Use an Icon
        var clear_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] a');
        clear_input.html('<i class="icon-remove-circle icon-large"></i>')
        clear_input.css('margin-left', '5px')
 
        // LENGTH - Inline-Form control
        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_length] select');
        length_sel.addClass('form-control input-small')
        length_sel.css('width', '75px')
 
        // LENGTH - Info adjust location
        var length_sel = datatable.closest('.dataTables_wrapper').find('div[id$=_info]');
        length_sel.css('margin-top', '18px')
		
		$('#formModal').modal({
			keyboard:true,
			show:false
		});
		
		$('.closeFormModal').on('click',function(e){
			$('#formModal').modal('hide');
		});
		
		$('.period').on('change',function(e){
			if(isNaN($(this).val())||$(this).val()==''){
				alert('Please enter valid amount.');
				$(this).val('0.00');
				$(this).focus();
			}
			$(this).val(parseFloat($(this).val()).toFixed(2));
			$('#period12').val((parseFloat($('#lastybal').html())-$('#period2').val()-$('#period3').val()-$('#period4').val()-$('#period5').val()-$('#period6').val()-$('#period7').val()-$('#period8').val()-$('#period9').val()-$('#period10').val()-$('#period11').val()).toFixed(2));
		});
		
		$('#submit').on('click',function(e){
			$.ajax({
				'dataType':'json',
				'type':'POST',
				'url':'/latest/maintenance/lastyearaging.cfc',
				'data':{
					method:'updateAging',
					returnformat:'json',
					dts:dts,
					authUser:authUser,
					accno:$('#accno').html(),
					period2:$('#period2').val(),
					period3:$('#period3').val(),
					period4:$('#period4').val(),
					period5:$('#period5').val(),
					period6:$('#period6').val(),
					period7:$('#period7').val(),
					period8:$('#period8').val(),
					period9:$('#period9').val(),
					period10:$('#period10').val(),
					period11:$('#period11').val(),
					period12:$('#period12').val()
				},
				'success':function(data,status,jqXHR){
					if(data.toString()=='true'){
						$('#alertBox').addClass('alert-success');
						$('#alertBox p').html('Update Last Year Aging for '+$('#accno').html()+' '+$('#desp').html()+' Successfully.');
						$('#alertBox')
						.fadeIn('fast')
						.delay(5000).fadeOut('fast');
					}else{
						$('#alertBox').addClass('alert-danger');
						$('#alertBox p').html('Fail to update Last Year Aging for '+$('#accno').html()+' '+$('#desp').html()+'.');
						$('#alertBox')
						.fadeIn('fast')
						.delay(5000).fadeOut('fast');
					}
				},
				'complete':function(jqXHR,status){
					$('#formModal').modal('hide');
				}
			});
		});
		
		$('.closeAlertBox').on('click',function(e){
			$('#alertBox').hide();
		});
});

function openFormModal(accno,desp,lastybal){
	$('#formModalTitle').html('Distribute '+targetTitle+' Last Year Aging');
	$('#accno').html(accno);
	$('#targetLabel').html(targetTitle);
	$('#desp').html(desp);
	$('#lastybal').html(lastybal);
	$.ajax({
		'dataType':'json',
		'type':'POST',
		'url':'/latest/maintenance/lastyearaging.cfc',
		'data':{
			method:'getAging',
			returnformat:'json',
			dts:dts,
			accno:accno
		},
		'success':function(data,status,jqXHR){
			$('#period2').val(data.period2.toFixed(2));
			$('#period3').val(data.period3.toFixed(2));
			$('#period4').val(data.period4.toFixed(2));
			$('#period5').val(data.period5.toFixed(2));
			$('#period6').val(data.period6.toFixed(2));
			$('#period7').val(data.period7.toFixed(2));
			$('#period8').val(data.period8.toFixed(2));
			$('#period9').val(data.period9.toFixed(2));
			$('#period10').val(data.period10.toFixed(2));
			$('#period11').val(data.period11.toFixed(2));
			$('#period12').val(data.period12.toFixed(2));
			$('#period12').prop('readonly',true);
		},
		'complete':function(jqXHR,status){
			$('#formModal').modal('show');
		}
	});
}