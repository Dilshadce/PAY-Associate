// JavaScript Document
var mode;
var grandTotalDebit=0;
var grandTotalCredit=0;
function getuMode(){
	return mode;
}
function setuMode(input){
	mode=input;
}
$(document).ready(function(e) {
	setuMode('balance');
	checkBalanceFigureLock();
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'ACCOUNT','mData':'accno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[1],'sTitle':'DESCRIPTION','mData':'desp','bSortable':true,'sWidth':'40%'},
				{
					'aTargets':[2],
					'sTitle':'DEBIT',
					'mData':'amount',
					'bSortable':true,
					'sWidth':'25%',
					'sClass':'text-right',
					'mRender':function(data,type,row){
						if(data>=0){
							return '<div id="'+row.accno+'" class="debitEditable">'+data.toFixed(2)+'</div>';
						}else{
							return '<div id="'+row.accno+'" class="debitEditable">'+'0.00'+'</div>';
						};
					}
				},
				{
					'aTargets':[3],
					'sTitle':'CREDIT',
					'mData':'amount',
					'bSortable':true,
					'sWidth':'25%',
					'sClass':'text-right',
					'mRender':function(data,type,row){
						if(data<0){
							return '<div id="'+row.accno+'" class="creditEditable">'+Math.abs(data).toFixed(2)+'</div>';
						}else{
							return '<div id="'+row.accno+'" class="creditEditable">'+'0.00'+'</div>';
						};
					}
				}
        	],
			'bAutoWidth':true,
			'bFilter':true,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':true,
			'fnDrawCallback':function(oSettings){
				$('.debitEditable').editable('/latest/general/lastyearbalancefigure.cfc',{
					id:$(this).attr('id'),
					name:'amount',
					cancel:'Cancel',
					submit:'OK',
					indicator : 'Updating...',
					tooltip:'Click to update debit amount.',
					type:'text',
					submitdata:{
						method:'updateAmount',
						returnformat:'plain',
						dts:dts,
						authUser:authUser,
						mode:getuMode(),
						type:'debit'
					},
					onsubmit:function(settings,original){
						if(isNaN($(original).find('input').val())){
							alert('Please input valid debit amount.');
							return false;
						}else{
							return confirm('Are you confirm to update this debit amount?');
						}
					},
					callback:function(value,settings){
						resultTable.fnDraw();
					}
				});
				$('.creditEditable').editable('/latest/general/lastyearbalancefigure.cfc',{
					id:$(this).attr('id'),
					name:'amount',
					cancel:'Cancel',
					submit:'OK',
					indicator : 'Updating...',
					tooltip:'Click to update credit amount.',
					type:'text',
					submitdata:{
						method:'updateAmount',
						returnformat:'plain',
						dts:dts,
						authUser:authUser,
						mode:getuMode(),
						type:'credit'
					},
					onsubmit:function(settings,original){
						if(isNaN($(original).find('input').val())){
							alert('Please input valid credit amount.');
							return false;
						}else{
							return confirm('Are you confirm to update this credit amount?');
						}
					},
					callback:function(value,settings){
						resultTable.fnDraw();
					}
				});
				if($('#lock').prop('disabled')){
					$('.debitEditable').editable('disable');
					$('.creditEditable').editable('disable');
				}
			},
			'fnFooterCallback':function(nRow,aaData,iStart,iEnd,aiDisplay){
				var totalDebit=0;
				var totalCredit=0;
				for(var i=0;i<aaData.length;i++){
					if(aaData[i]['amount']>0){
						totalDebit=totalDebit+aaData[i]['amount'];
					}else if(aaData[i]['amount']<0){
						totalCredit=totalCredit+aaData[i]['amount'];
					}
				}
				var nCells=nRow.getElementsByTagName('th');
				nCells[2].innerHTML=totalDebit.toFixed(2)+'<br>'+grandTotalDebit.toFixed(2);
				nCells[3].innerHTML=Math.abs(totalCredit).toFixed(2)+'<br>'+Math.abs(grandTotalCredit).toFixed(2);
				if(grandTotalDebit.toFixed(2)!=Math.abs(grandTotalCredit).toFixed(2)){
					if(mode=='balance'){
						$('#alert h4').html('Opening Balance Grand Total not balance.');
					}else if(mode=='foreignBalance'){
						$('#alert h4').html('Foreign Currency Opening Balance Grand Total not balance.');
					}else if (mode=='figure'){
						$('#alert h4').html('Last Year Figure Grand Total not balance.');
					}
					$('#alert p').html(
						'Grand Total for Debit: '+grandTotalDebit.toFixed(2)+'<br>'+
						'Grand Total for Credit: '+Math.abs(grandTotalCredit).toFixed(2)
					);
					$('#alert').show();					
				}else{
					$('#alert').hide();
				};
			},
			'fnServerData':function(sSource,aoData,fnCallback,oSettings){
				oSettings.jqXHR=$.ajax({
					'dataType':'json',
					'type':'POST',
					'url':sSource,
					'data':aoData,
					'success':function(data,status,jqXHR){
						grandTotalDebit=data.iTotalDebit;
						grandTotalCredit=data.iTotalCredit;
						fnCallback(data);
					}
				});
			},
			'fnServerParams':function(aoData){
				var uMode=getuMode();
				aoData.push(
					{"name":"method","value":"listAccount"},
					{"name":"returnformat","value":"json"},
					{"name":"dts","value":''+dts+''},
					{"name":"ctycode","value":''+ctycode+''},
					{"name":"mode","value":''+uMode+''}
				);
        	},
			'sAjaxSource':'/latest/general/lastyearbalancefigure.cfc',
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
	
	$('#balanceButton').on('click',function(e){
		$('li').removeClass('active');
		$('#balanceNav').addClass('active');
		setuMode('balance');
		checkBalanceFigureLock();
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#foreignBalanceButton').on('click',function(e){
		$('li').removeClass('active');
		$('#foreignBalanceNav').addClass('active');
		setuMode('foreignBalance');
		checkBalanceFigureLock();
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#figureButton').on('click',function(e){
		$('li').removeClass('active');
		$('#figureNav').addClass('active');
		setuMode('figure');
		checkBalanceFigureLock();
		resultTable.fnDraw();
		resultTable.css('display','none').fadeIn();
	});
	
	$('#print').on('click',function(e){
		if(mode=='balance'){
			window.open('/general/openbalprint.cfm','_blank');
		}else if(mode=='foreignBalance'){
			window.open('/general/ffopenbalprint.cfm','_blank');
		}else if(mode=='figure'){
			window.open('/general/lastyfigprint.cfm','_blank');
		}
	});
	
	$('#printWithoutZeroFigure').on('click',function(e){
		if(mode=='balance'){
			window.open('/general/openbalprint2.cfm','_blank');
		}else if(mode=='foreignBalance'){
			window.open('/general/ffopenbalprint2.cfm','_blank');
		}else if(mode=='figure'){
			window.open('/general/lastyfigprint2.cfm','_blank');
		}
	});
	
	$('.alert .close').on('click',function(e){
		$(this).parent().hide();
	});
	
	$('#lock').on('click',function(e){
		$.ajax({
			type:"POST",
			url:"/latest/general/lastyearbalancefigure.cfc",
			data:{
				method:'lockBalanceFigure',
				returnformat:'plain',
				dts:dts
			},
			dataType:"html",
			cache:false,
			success: function(result){
				if(result=='Y'){
					$('#lock').prop('disabled',true);
					$('#lock').html($('#lock').html().replace(' Lock\n',' Locked\n'));
					$('.debitEditable').editable('disable');
					$('.creditEditable').editable('disable');
				}				
			},
			error: function(jqXHR,textStatus,errorThrown){
				alert(errorThrown);
			},
			complete: function(){
			}
		});		
	});
});
function checkBalanceFigureLock(){
	$.ajax({
		type:"POST",
		url:"/latest/general/lastyearbalancefigure.cfc",
		data:{
			method:'checkBalanceFigureLock',
			returnformat:'plain',
			dts:dts
		},
		dataType:"html",
		cache:false,
		success: function(result){
			if(result=='Y'){
				$('#lock').prop('disabled',true);
				$('#lock').html($('#lock').html().replace(' Lock\n',' Locked\n'));
			}else{
				if($('#lock').prop('disabled')){
					$('#lock').prop('disabled',false);
					$('#lock').html($('#lock').html().replace(' Locked\n',' Lock\n'));
				}
			}
		},
		error: function(jqXHR,textStatus,errorThrown){
			alert(errorThrown);
		},
		complete: function(){
		}
	});
}