// JavaScript Document
$(document).ready(function(e) {
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'CODE','mData':'currcode','bSortable':true,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':'NAME','mData':'currency','bSortable':true,'sWidth':'10%'},
				{'aTargets':[2],'sTitle':'DESCRIPTION','mData':'currency1','bSortable':true,'sWidth':'50%'},
				{
					'aTargets':[3],
					'sTitle':'RATE',
					'mData':'currrate',
					'bSortable':true,
					'sWidth':'20%',
					'mRender':function(data,type,row){
						return data.toFixed(5);
					}
				},
				{
					'aTargets':[4],
					'sTitle':'ACTION',
					'mData':'currcode',
					'bSortable':true,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/currency\/createCurrency.cfm?type=Edit&currcode='+data+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="return dispConfirm(\'\/currency\/rateD.cfm?currcode='+data+'\',\''+data+'\');"></span>';
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
			'sAjaxSource':'/latest/general/currencyprofile.cfc',
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
function dispConfirm(add,curr){
		var msg='Are you sure to delete Currency code :' +curr;
		if (confirm(msg)){
			if(add!=''){window.location=add;}
			return true;
			
		}
		return false;
}