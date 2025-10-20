// JavaScript Document
var acctype;
function getuAcctype(){
	return acctype;
}
function setuAcctype(input){
	acctype=input;
}
$(document).ready(function(e) {
	setuAcctype('');
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'ACCOUNT','mData':'accno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':'DESCRIPTION','mData':'desp','bSortable':true,'sWidth':'35%'},
				{
					'aTargets':[2],
					'sTitle':'A/C TYPE',
					'mData':'acctype',
					'bSortable':true,
					'sWidth':'20%',
					'mRender':function(data,type,row){
						if(data=='A'){
							return 'CAPITAL/RETAINED EARNINGS';
						}else if(data=='B'){
							return 'LONG TERM LIABILITIES';
						}else if(data=='C'){
							return 'OTHER LIABILITIES';
						}else if(data=='D'){
							return 'FIXED ASSETS';
						}else if(data=='E'){
							return 'OTHER ASSETS';
						}else if(data=='F'){
							return 'CURRENT ASSETS';
						}else if(data=='G'){
							return 'CURRENT LIABILITIES';
						}else if(data=='H'){
							return 'SALES';
						}else if(data=='I'){
							return 'SALES ADJUSTMENTS';
						}else if(data=='J'){
							return 'COST OF GOODS SOLD';
						}else if(data=='L'){
							return 'OTHER INCOMES';
						}else if(data=='M'){
							return 'EXPENSES';
						}else if(data=='P'){
							return 'TAXATION';
						}else if(data=='S'){
							return 'EXTRA-ORDINARY INCOME/ (EXP.)';
						}else if(data=='T'){
							return 'APPROPRIATION ACCOUNT';
						}else{
							return '';
						}
					}
				},
				{'aTargets':[3],'sTitle':'GROUP','mData':'groupto','bSortable':true,'sWidth':'10%'},
				{'aTargets':[4],'sTitle':'SPECIAL A/C','mData':'sa','bSortable':true,'sWidth':'15%'},
				{
					'aTargets':[5],
					'sTitle':'ACTION',
					'mData':'accno',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,type,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/general\/LedgerAcc.cfm?type=Edit&accno='+data+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-remove btn btn-link" '+
								'onclick="window.open(\'\/general\/LedgerAcc.cfm?type=Delete&accno='+data+'\',\'_self\');"></span>';
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
				var uAcctype=getuAcctype();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"acctype","value":''+uAcctype+''}
				);
        	},
			'sAjaxSource':'/latest/general/chartofaccount.cfc',
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
		setuAcctype('');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#assetButton').on('click',function(e){
		$('li').removeClass('active');
		$('#assetNav').addClass('active');
		setuAcctype('D,E,F');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#liabilityButton').on('click',function(e){
		$('li').removeClass('active');
		$('#liabilityNav').addClass('active');
		setuAcctype('B,C,G');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#expenseButton').on('click',function(e){
		$('li').removeClass('active');
		$('#expenseNav').addClass('active');
		setuAcctype('M');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#revenueButton').on('click',function(e){
		$('li').removeClass('active');
		$('#revenueNav').addClass('active');
		setuAcctype('H,I,L');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#purchaseButton').on('click',function(e){
		$('li').removeClass('active');
		$('#purchaseNav').addClass('active');
		setuAcctype('J');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#capitalButton').on('click',function(e){
		$('li').removeClass('active');
		$('#capitalNav').addClass('active');
		setuAcctype('A');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#otherButton').on('click',function(e){
		$('li').removeClass('active');
		$('#otherNav').addClass('active');
		setuAcctype('P,S,T');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
});