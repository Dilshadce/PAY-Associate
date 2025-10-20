// JavaScript Document
var porj;
function getuPorj(){
	return porj;
}
function setuPorj(input){
	porj=input;
}
$(document).ready(function(e) {
	setuPorj('P,J');
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'CODE','mData':'source','bSortable':true,'sWidth':'15%'},
				{'aTargets':[1],'sTitle':'DESCRIPTION','mData':'project','bSortable':true,'sWidth':'35%'},
				{
					'aTargets':[2],
					'sTitle':'TYPE',
					'mData':'porj',
					'bSortable':true,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						if(data=='P'){
							return lproject.toUpperCase();
						}else if(data=='J'){
							return ljob.toUpperCase();
						}else{
							return '';
						}
					}
				},
				{
					'aTargets':[3],
					'sTitle':'COMPLETED',
					'mData':'completed',
					'bSortable':true,
					'sWidth':'15%',
					'mRender':function(data,type,row){
						if(data=='Y'){
							return 'YES';
						}else if(data=='N'){
							return 'NO';
						}else{
							return '';
						}
					}
				},
				{
					'aTargets':[4],
					'sTitle':'CONTRACT SUM',
					'mData':'contrsum',
					'bSortable':true,
					'sWidth':'15%',
					'mRender':function(data,type,row){
						return data.toFixed(2);
					}
				},
				{
					'aTargets':[5],
					'sTitle':'ACTION',
					'mData':'source',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/general\/project.cfm?type=edit&getproject='+data+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="window.open(\'\/general\/project.cfm?type=delete&getproject='+data+'\',\'_self\');"></span>';
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
				var uPorj=getuPorj();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"porj","value":''+uPorj+''}
				);
        	},
			'sAjaxSource':'/latest/general/projectprofile.cfc',
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
	
	$('#allButton').on('click',function(e){
		$('li').removeClass('active');
		$('#allNav').addClass('active');
		setuPorj('P,J');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#projectButton').on('click',function(e){
		$('li').removeClass('active');
		$('#projectNav').addClass('active');
		setuPorj('P');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#jobButton').on('click',function(e){
		$('li').removeClass('active');
		$('#jobNav').addClass('active');
		setuPorj('J');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
});