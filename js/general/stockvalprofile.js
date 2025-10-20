// JavaScript Document
$(document).ready(function(e) {
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'CODE','mData':'stkcode','bSortable':true,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':'PROJECT','mData':'stkcode2','bSortable':true,'sWidth':'20%'},
				{
					'aTargets':[2],
					'sTitle':'JOB',
					'mData':'stkcode3',
					'bSortable':true,
					'sWidth':'20%'/*,
					'mRender':function(data,type,row){
						return data.toFixed(5);
					}*/
				},
				{
					'aTargets':[3],
					'sTitle':'BS ACCOUNT',
					'mData':'bsaccno',
					'bSortable':true,
					'sWidth':'25%'/*,
					'mRender':function(data,type,row){
						return data+'<br />'+row.email;
					}*/
				},
				{'aTargets':[4],'sTitle':'OS ACCOUNT','mData':'osaccno','bSortable':true,'sWidth':'25%'},
				{'aTargets':[5],'sTitle':'CS ACCOUNT','mData':'csaccno','bSortable':true,'sWidth':'25%'},
		
				{
					'aTargets':[6],
					'sTitle':'ACTION',
					'mData':'stkcode',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/latest\/general\/stockval.cfm?action=update&stkcode='+data+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="if(confirm(\'Are you sure you wish to delete this stock value?\')){window.open(\'\/latest\/general\/stockvalprocess.cfm?action=delete&stkcode='+data+'\',\'_self\');}"></span>';
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
					{"name":"dts","value":''+dts+''}
				);
        	},
			'sAjaxSource':'/latest/general/stockvalprofile.cfc',
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
});