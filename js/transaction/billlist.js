// JavaScript Document
var mode;
function getuMode(){
	return mode;
}
function setuMode(input){
	mode=input;
}
$(document).ready(function(e) {
	setuMode('active');
	$('#restore').css('display','none');
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{
					'aTargets':[0],
					'sTitle':'<input type="checkbox" id="checkAll" />',
					'mData':'refno',
					'bSortable':false,
					'sWidth':'5%',
					'mRender':function(data,type,row){
						return '<input type="checkbox" class="TransactionCheckbox" name="checkedTransaction" value="'+data+'" />';						
					}
				},
				{
					'aTargets':[1],
					'sTitle':pageTitle,
					'mData':'refno',
					'bSortable':true,
					'sWidth':'10%',
					'mRender':function(data,ftype,row){
						return '<a href="/transaction/SimpleTransaction/printSendTransaction.cfm?action=print&type='+type+'&title='+pageTitle+'&target='+targetTitle+'&targetTable='+targetTable+'&transactionList='+data+'&reportFormat=PDF&download=no" target="_blank">'+data+'</a>';
					}
				},
				{'aTargets':[2],'sTitle':'PO NO.','mData':'pono','bSortable':true,'sWidth':'10%'},
				{'aTargets':[3],'sTitle':'CUSTNO','mData':'custno','bSortable':false,'bVisible':false},
				{
					'aTargets':[4],
					'sTitle':targetTitle,
					'mData':'name',
					'bSortable':true,
					'sWidth':'40%',
					'mRender':function(data,type,row){
						return row.custno+' - '+data;
					}
				},
				{'aTargets':[5],'sTitle':'ITEM CODE','mData':'itemno','bSortable':false,'bVisible':false},
				{'aTargets':[6],'sTitle':'ITEM DESCRIPTION','mData':'desp','bSortable':false,'bVisible':false},
				{'aTargets':[7],'sTitle':'NOTE','mData':'rem11','bSortable':false,'bVisible':false},
				{'aTargets':[8],'sTitle':'DATE','mData':'wos_date','bSortable':true,'sWidth':'10%'},
				{
					'aTargets':[9],
					'sTitle':'TOTAL',
					'mData':'grand_bil',
					'bSortable':true,
					'sWidth':'15%',
					'mRender':function(data,type,row){
						return '<div style="position:relative"><b>'+row.currcode+'</b> <span style="position:absolute;right:0;">'+data.toFixed(2)+'</span></div>';
					}
				},
				{'aTargets':[10],'sTitle':'CURRENCY','mData':'currcode','bSortable':false,'bVisible':false},
				{
					'aTargets':[11],
					'sTitle':'ACTION',
					'mData':'refno',
					'bSortable':false,
					'sWidth':'10%',
					'mRender':function(data,ftype,row){
						return 	'<span class="glyphicon glyphicon-pencil btn btn-link" '+
								'onclick="window.open(\'\/transaction\/SimpleTransaction\/Transaction.cfm?action=update&selectedRefno='+data+'&type='+type+'\',\'_self\');"></span>'+
								'<span class="glyphicon glyphicon-file btn btn-link" '+
								'onclick="window.open(\'\/transaction\/SimpleTransaction\/Transaction.cfm?action=copy&selectedRefno='+data+'&type='+type+'\',\'_self\');"></span>';
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
				var uMode=getuMode();
				aoData.push(
					{"name":"method","value":"listBill"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"type","value":''+type+''},
					{"name":"targetTable","value":''+targetTable+''},
					{"name":"mode","value":''+uMode+''},
					{"name":"targetLedgerTable","value":''+targetLedgerTable+''}
				);
        	},
			'sAjaxSource':'/latest/transaction/billlist.cfc',
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
		$('#delete').css('display','inline-block');
		$('#restore').css('display','inline-block');
		$('li').removeClass('active');
		$('#allNav').addClass('active');
		setuMode('all');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#activeButton').on('click',function(e){
		$('#delete').css('display','inline-block');
		$('#restore').css('display','none');
		$('li').removeClass('active');
		$('#activeNav').addClass('active');
		setuMode('active');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#deletedButton').on('click',function(e){
		$('#delete').css('display','none');
		$('#restore').css('display','inline-block');
		$('li').removeClass('active');
		$('#deletedNav').addClass('active');
		setuMode('deleted');
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#checkAll').on('change',function(){
		$('.TransactionCheckbox').prop('checked',this.checked);
	});
	
	$('#delete').on('click',function(){
		var checkedTransaction=resultTable.$('.TransactionCheckbox').serializeArray();
		var checkedTransactionList='';
		jQuery.each( checkedTransaction, function( i, field ){
			if(checkedTransactionList==''){
				checkedTransactionList=field.value;
			}else{
				checkedTransactionList=checkedTransactionList+","+field.value;
			};
		});
		if(checkedTransactionList!=''){
			var dataString='action=deleteTransaction&';
			dataString=dataString+'type='+type+'&';
			dataString=dataString+'transactionList='+checkedTransactionList+'&';
			dataString=dataString+'targetLedgerTable='+targetLedgerTable;
			$.ajax({
				type:'POST',
				url:'/transaction/SimpleTransaction/TransactionAjax.cfm',
				data:dataString,
				dataType:'html',
				cache:false,
				success: function(result){
					alert(result);
				},
				error: function(jqXHR,textStatus,errorThrown){
					alert(errorThrown);
				},
				complete: function(){					
					resultTable.fnDraw();
				}
			});			
		};
	});
	
	$('#restore').on('click',function(){
		var checkedTransaction=resultTable.$('.TransactionCheckbox').serializeArray();
		var checkedTransactionList='';
		jQuery.each( checkedTransaction, function( i, field ){
			if(checkedTransactionList==''){
				checkedTransactionList=field.value;
			}else{
				checkedTransactionList=checkedTransactionList+","+field.value;
			};
		});
		if(checkedTransactionList!=''){
			var dataString='action=undeleteTransaction&';
			dataString=dataString+'type='+type+'&';
			dataString=dataString+'transactionList='+checkedTransactionList+'&';
			dataString=dataString+'targetTable='+targetTable+'&';
			dataString=dataString+'targetLedgerTable='+targetLedgerTable;
			$.ajax({
				type:'POST',
				url:'/transaction/SimpleTransaction/TransactionAjax.cfm',
				data:dataString,
				dataType:'html',
				cache:false,
				success: function(result){
					alert(result);
				},
				error: function(jqXHR,textStatus,errorThrown){
					alert(errorThrown);
				},
				complete: function(){					
					resultTable.fnDraw();
				}
			});			
		};
	});	
	
	$('#print').on('click',function(){
		var checkedTransaction=resultTable.$('.TransactionCheckbox').serializeArray();
		var checkedTransactionList='';
		jQuery.each( checkedTransaction, function( i, field ){
			if(checkedTransactionList==''){
				checkedTransactionList=field.value;
			}else{
				checkedTransactionList=checkedTransactionList+","+field.value;
			};
		});
		if(checkedTransactionList!=''){
			window.open(
				'/transaction/SimpleTransaction/printSendTransaction.cfm?action=print&type='+type+
				'&title='+pageTitle+'&target='+targetTitle+'&targetTable='+targetTable+'&transactionList='+checkedTransactionList+
				'&reportFormat=PDF&download=yes','_blank'
			);
		};
	});	
	
	$('#send').on('click',function(){
		var checkedTransaction=resultTable.$('.TransactionCheckbox').serializeArray();
		var checkedTransactionList='';
		jQuery.each( checkedTransaction, function( i, field ){
			if(checkedTransactionList==''){
				checkedTransactionList=field.value;
			}else{
				checkedTransactionList=checkedTransactionList+","+field.value;
			};
		});
		if(checkedTransactionList!=''){
			$.ajax({
				type:'GET',
				url:'/transaction/SimpleTransaction/printSendTransaction.cfm',
				data:{
					action:'send',
					type:type,
					title:pageTitle,
					target:targetTitle,
					targetTable:targetTable,
					transactionList:checkedTransactionList,
					reportFormat:'PDF',
				},
				dataType:'html',
				cache:false,
				success: function(result){
					alert(result);
				},
				error: function(jqXHR,textStatus,errorThrown){
					alert(errorThrown);
				},
				complete: function(){					
				}
			});	
		};
	});
		
});