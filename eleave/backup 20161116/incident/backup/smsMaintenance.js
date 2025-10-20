// JavaScript Document
$(document).ready(function(e) {
	var resultTable = $('#smsTable').dataTable({
		'scrollX':true,
		'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
		'aoColumnDefs':[
			{'aTargets':[0],'sTitle':("type").toUpperCase(),'mData':'type','bSortable':true,'sWidth':'10%'},
			{'aTargets':[1],'sTitle':("title").toUpperCase(),'mData':'title','bSortable':true,'sWidth':'20%'},
			{'aTargets':[2],'sTitle':("content").toUpperCase(),'mData':'content','bSortable':true,'sWidth':'35%'},
			{'aTargets':[3],'sTitle':("schedule").toUpperCase(),'mData':'schedule','bSortable':true,'sWidth':'15%'},
			{'aTargets':[4],'sTitle':("status").toUpperCase(),'mData':'status','bSortable':true,'sWidth':'10%'},
			{'aTargets':[5],'sTitle':("action").toUpperCase(),'mData':'id','bSortable':false,'bVisible':true,'sWidth':'10%',
			                         'mRender':function(data,type,row){
										 if(row.type != "Birthday"){
											 if(row.status != "SENT"){
												 if(row.schedule != ""){
								   	 	 			return '<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(\'smsDetail.cfm?action=edit&id='+escape(encodeURIComponent(data))+'\',\'_self\');"></span>'+
										'<span class="glyphicon glyphicon-remove btn btn-link" onclick="if(confirm(\'Are you sure you wish to delete this?\')){window.open(\'smsMaintenanceProcess.cfm?action=delete&id='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>';							
												  }
												  else{
													 return '<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(\'smsDetail.cfm?action=edit&id='+escape(encodeURIComponent(data))+'\',\'_self\');"></span>'+
										'<span class="glyphicon glyphicon-remove btn btn-link" onclick="if(confirm(\'Are you sure you wish to delete this?\')){window.open(\'smsMaintenanceProcess.cfm?action=delete&id='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>'+										
											'<span class="glyphicon glyphicon-send btn btn-link" onclick="if(confirm(\'Are you sure want to send this?\')){window.open(\'selfSend.cfm?id='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>';
												  
												  }
											}
											else{
												return '<span class="glyphicon glyphicon-remove btn btn-link" onclick="if(confirm(\'Are you sure you wish to delete this?\')){window.open(\'smsMaintenanceProcess.cfm?action=delete&id='+escape(encodeURIComponent(data))+'\',\'_self\');}"></span>';
											}
										 }
										 else{
										 	return '<span class="glyphicon glyphicon-pencil btn btn-link" onclick="window.open(\'smsDetail.cfm?action=edit&id='+escape(encodeURIComponent(data))+'\',\'_self\');"></span>';	 
									     }
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
				{"name":"dts","value":dts},
				{"name":"targetTable","value":targetTable}
			);
        },
		'sAjaxSource':'smsMaintenance.cfc',
		'sServerMethod':'POST',
        'sScrollX':'100%'
	})
	.fadeIn();
		
	var datatable = $('.dataTable');
    // SEARCH - Add the placeholder for Search and Turn this into in-line formcontrol
    var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
    search_input.attr('placeholder', "SEARCH")
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
});