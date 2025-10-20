// JavaScript Document
function datatableEngage() {
	
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
            'aaSorting':[[2, 'asc'],[5, 'desc'], [6, 'desc']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'','mData':'placementno','bSortable':false,'sWidth':'6%',
                    'mRender':function(data,type,full){
                            if(tstatus == 'Submitted For Approval' || tstatus == 'Submitted For Cancellation'){
                                return '<input class="checks" name="checkerlist" type="checkbox" id="'+full.id+'" value="'+full.id+'" onclick="checkTheBox();">'
                                +'<label for="'+full.id+'"></label>';   
                            }else{
                                return '';
                            }  
					}                
                },	
                {'aTargets':[1],'sTitle':'NO'.toUpperCase(),'mData':'placementno','bSortable':false,'sWidth':'5%',
                'mRender':function(data,type,object){
						return ''+object.CurrentRow+'';
					}
                },
				{'aTargets':[2],'sTitle':'NAME','mData':'empname','bSortable':true,'sWidth':'15%'},				
				{'aTargets':[3],'sTitle':'PLACEMENT NO.','mData':'placementno','bSortable':true,'sWidth':'15%'},
				{'aTargets':[4],'sTitle':'DATE START','mData':'startdate','bSortable':true,'sWidth':'13%'},
				{'aTargets':[5],'sTitle':'DATE END','mData':'enddate','bSortable':true,'sWidth':'13%'},
				{'aTargets':[6],'sTitle':'DAYS','mData':'days','bSortable':true,'sWidth':'10%'},
				{'aTargets':[7],'sTitle':'TYPE','mData':'leavetype','bSortable':true,'sWidth':'10%'},
				{'aTargets':[8],'sTitle':'TIME FROM','mData':'startampm','bSortable':true,'sWidth':'11%'},
				{'aTargets':[9],'sTitle':'TIME TO','mData':'endampm','bSortable':true,'sWidth':'8%'},
				{'aTargets':[10],'sTitle':'LEAVE BALANCE','mData':'placementno','bSortable':false,'sWidth':'12%',
                    'mRender': function(data,type,full){
						if(tstatus == 'Submitted For Approval') {
                            return ''+full.balance+'';
                        }
                        else{
                            return '';
                        }
					}
                },
				{'aTargets':[11],'sTitle':'ATTACHMENT','mData':'placementno','bSortable':false,'sWidth':'16%',
				'mRender':function(data,type,full){
						if(full.signdoc != ''){
                            return '<a href="'+full.signdoc+'" target="_blank"><span class="glyphicon glyphicon-search btn btn-link" title="VIEW"> View</span>';
                        }else{
                            return '';
                        }
                        
					}
				},
				{'aTargets':[12],'sTitle':'REMARKS (ASSOCIATE)','mData':'remarks','bSortable':false,'sWidth':'15%'},
				{'aTargets':[13],'sTitle':'ACTION','mData':'placementno','bSortable':false,'bVisible':true,'sWidth':'16%',				
					'mRender': function(data,type,full){
						if(tstatus == 'Submitted For Approval') {
                            return '<span class="glyphicon glyphicon-ok btn btn-link" title="Approve" '+
									'onclick="remarksinput(\'Approve\', \'Single\', \''+full.id+'\')">&nbsp;'+approveword+'</span>'
                                    
									+'<span class="glyphicon glyphicon-remove btn btn-link" title="Reject" '+
									'onclick="remarksinput(\'Reject\', \'Single\', \''+full.id+'\')">&nbsp;Reject</span>';
                        }
                        else if(tstatus == 'Submitted For Cancellation') {
                            return '<span class="glyphicon glyphicon-ok btn btn-link" title="Approve" '+
									'onclick="remarksinput(\'Cancel\', \'Single\', \''+full.id+'\')">&nbsp;Cancel</span>'
                                    
									+'<span class="glyphicon glyphicon-remove btn btn-link" title="Reject" '+
									'onclick="remarksinput(\'RejectCancellation\', \'Single\', \''+full.id+'\')">&nbsp;Reject</span>';    
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
			'sAjaxSource':'/approval2/LeaveApprovalMain.cfc',
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