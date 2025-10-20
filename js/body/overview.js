// JavaScript Document
$(document).ready(function(e) {	
	var resultTable=$('#loggingTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'User ID','mData':'userlogid','bSortable':true,'sWidth':'20%','sClass':'textAlignCenter'},
				{'aTargets':[1],'sTitle':'Login Time','mData':'userlogtime','bSortable':true,'sWidth':'30%','sClass':'textAlignCenter'},
				{'aTargets':[2],'sTitle':'IP Address','mData':'uipaddress','bSortable':true,'sWidth':'28%','sClass':'textAlignCenter'},
				{'aTargets':[3],'sTitle':'Status','mData':'status','bSortable':true,'sWidth':'20%','sClass':'textAlignCenter'},
        	],
			'bAutoWidth':true,
			'bFilter':true,
			'bDestroy':true,
			'bJQueryUI':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':true,
			'bPaginate':false,
			'bFilter':false,
			'fnServerParams':function(aoData){
				aoData.push(
					{"name":"method","value":"listLoggingHistory"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''}
				);
        	},
			'sAjaxSource':'/body/overview.cfc',
			'sServerMethod':'POST',
			//'sDom':'<"top"<"#titleDiv">f<"clear">lp<"clear">>rt<"bottom"ip<"clear">>',
			'sDom':'<"top"<"#titleDiv">pf<"clear">>rt<"bottom">',
			'sPaginationType':'full_numbers',
			'sScrollY':205,
        	'sScrollX':'100%'
		})
		.fnSort([[1,'desc']]);
		$('#titleDiv').html('User Logging History');
});