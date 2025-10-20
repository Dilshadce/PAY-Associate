// JavaScript Document
function datatableEngage() {
	
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
            'aaSorting':[[2, 'asc'],[5, 'desc'], [6, 'desc']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'','mData':'empno','bSortable':false,'sWidth':'5%',
                    'mRender':function(data,type,full){
                            if(tstatus == 'Submitted For Approval' || tstatus == 'Submitted For Cancellation'){
                                return '<input class="checks" name="checkerlist" type="checkbox" id="'+full.placementno+'-'+full.tmonth1+'-'+full.tyear
                                +'" value="'+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'" onclick="checkTheBox();">'
                                +'<label for="'+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'"></label>';   
                            }else{
                                return '';
                            }
                                
					}                
                },	
                {'aTargets':[1],'sTitle':'NO'.toUpperCase(),'mData':'empno','bSortable':false,'sWidth':'5%',
                'mRender':function(data,type,object){
						return ''+object.CurrentRow+'';
					}
                },
				{'aTargets':[2],'sTitle':'NAME','mData':'empname','bSortable':true,'sWidth':'20%'},				
				{'aTargets':[3],'sTitle':'PLACEMENT NO.','mData':'placementno','bSortable':true,'sWidth':'12%'},
				{'aTargets':[4],'sTitle':'SUBMIT DATE','mData':'created_on','bSortable':true,'sWidth':'11%'},
				{'aTargets':[5],'sTitle':'MONTH','mData':'tmonth','bSortable':true,'sWidth':'10%'},
				{'aTargets':[6],'sTitle':'DATE START','mData':'start','bSortable':true,'sWidth':'11%'},
				{'aTargets':[7],'sTitle':'DATE END','mData':'end','bSortable':true,'sWidth':'11%'},
				{'aTargets':[8],'sTitle':'TIMESHEET','mData':'empno','bSortable':false,'sWidth':'12%',
				'mRender':function(data,type,full){
						return '<span class="glyphicon glyphicon-search btn btn-link" title="VIEW" '+ 
									'onclick="window.open(\'\/approval2\/TimesheetView.cfm?placementno='+escape(encodeURIComponent(full.placementno))
                                    +'&monthselected='+escape(encodeURIComponent(full.tmonth1))
                                    +'&yearselected='+escape(encodeURIComponent(full.tyear))+'\',\'_blank\');"> View</span>';
					}
				
				},
				{'aTargets':[9],'sTitle':'HM REMARKS','mData':'MGMTREMARKS','bSortable':false,'sWidth':'15%'},
				{'aTargets':[10],'sTitle':'ACTION','mData':'empno','bSortable':false,'bVisible':true,'sWidth':'26%',				
					'mRender': function(data,type,full){
						if(tstatus == 'Submitted For Approval') {
                            return '<span class="glyphicon glyphicon-ok btn btn-link" title="Approve" '+
									'onclick="remarksinput(\'Approve\', \'Single\', \''+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'\')">&nbsp;Approve</span>'
                                    
									+'<span class="glyphicon glyphicon-remove btn btn-link" title="Reject" '+
									'onclick="remarksinput(\'Reject\', \'Single\', \''+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'\')">&nbsp;Reject</span>';
                        }
                        else if(tstatus == 'Submitted For Cancellation') {
                            return '<span class="glyphicon glyphicon-ok btn btn-link" title="Cancel" '+
									'onclick="remarksinput(\'Cancel\', \'Single\', \''+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'\')">&nbsp;Cancel</span>'
                                    
									+'<span class="glyphicon glyphicon-remove btn btn-link" title="Reject" '+
									'onclick="remarksinput(\'RejectCancellation\', \'Single\', \''+full.placementno+'-'+full.tmonth1+'-'+full.tyear+'\')">&nbsp;Reject</span>';
                        }
                        else{
                            return '';
                        }
					}
				}
                
        	],
			'bAutoWidth':false,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':false,
			'fnServerParams':function(aoData){
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":dts},
					{"name":"tstatus","value":tstatus},
					{"name":"targetTable","value":targetTable},
					{"name":"huserid","value":huserid}
				);
        	},
			'sAjaxSource':'/approval2/TimesheetApprovalMain.cfc',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		})
		.fadeIn();
		
		var datatable = $('.dataTable');
        // SEARCH - Add the placeholder for Search and Turn this into in-line formcontrol
        var search_input = datatable.closest('.dataTables_wrapper').find('div[id$=_filter] input');
        search_input.attr('placeholder', 'SEARCH')
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
}

$(document).ready(function() {
    datatableEngage()
});