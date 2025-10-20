// JavaScript Document
var resultTable='';
var invisibleColumns='';
var method='';
var husergrpid='';
var dts='';
var category='';
var attribute='';
var operator='';
var keyword='';
$(document).ready(function(e) {
	resultTable=top.frames['leftFrame'].initResultTable();
	removeSorting();
		
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
function initResultTable(){
	var resultTable=$('#resultTable')
		.dataTable({
			'scrollX':true,
			'aLengthMenu':[[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']],
			'aoColumnDefs':[
				{'aTargets':[0],'sTitle':'BN','mData':'batchno','bSortable':true,'sWidth':'5%'},
				{'aTargets':[1],'sTitle':'TN','mData':'tranno','bSortable':true,'sWidth':'5%'},
				{'aTargets':[2],'sTitle':'PD','mData':'fperiod','bSortable':true,'sWidth':'5%'},
				{'aTargets':[3],'sTitle':'Date','mData':'date','bSortable':true,'sWidth':'10%'},
				{'aTargets':[4],'sTitle':'Accno','mData':'accno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[5],'sTitle':'Description','mData':'desp','bSortable':true,'sWidth':'25%'},
				{'aTargets':[6],'sTitle':'Reference','mData':'reference','bSortable':true,'sWidth':'10%'},
				{'aTargets':[7],'sTitle':'Reference 2','mData':'refno','bSortable':true},
				{'aTargets':[8],'sTitle':'Job','mData':'job','bSortable':true},
				{'aTargets':[9],'sTitle':'Debit','mData':'debitamt','bSortable':true,'sWidth':'10%'},
				{'aTargets':[10],'sTitle':'Credit','mData':'creditamt','bSortable':true,'sWidth':'10%'},				
				{'aTargets':[11],'sTitle':'Customer','mData':'custno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[12],'sTitle':'Supplier','mData':'custno','bSortable':true,'sWidth':'10%'},
				{'aTargets':[13],'sTitle':'Name','mData':'name','bSortable':true,'sWidth':'10%'},
				{'aTargets':[14],'sTitle':'Address','mData':'address','bSortable':true,'sWidth':'25%'},
				{'aTargets':[15],'sTitle':'Country','mData':'country','bSortable':true},
				{'aTargets':[16],'sTitle':'Postal Code','mData':'postalcode','bSortable':true},
				{'aTargets':[17],'sTitle':'Attention','mData':'attn','bSortable':true,'sWidth':'10%'},
				{'aTargets':[18],'sTitle':'Email','mData':'e_mail','bSortable':true},
				{'aTargets':[19],'sTitle':'Website','mData':'web_site','bSortable':true},
				{'aTargets':[20],'sTitle':'Phone','mData':'phone','bSortable':true,'sWidth':'10%'},
				{'aTargets':[21],'sTitle':'Fax','mData':'fax','bSortable':true,'sWidth':'10%'},
				{'aTargets':[22],'sTitle':'Contact','mData':'contact','bSortable':true},
				{'aTargets':[23],'sTitle':'CR','mData':'currency','bSortable':true,'sWidth':'6%'},
				{'aTargets':[24],'sTitle':'Bank Account No.','mData':'bankaccno','bSortable':true},
				{'aTargets':[25],'sTitle':'Date','mData':'date','bSortable':true,'sWidth':'10%'},
				{'aTargets':[26],'sTitle':'Action','mData':'action','bSortable':false,'sWidth':'9%'},
				{'bVisible':false,'aTargets':invisibleColumns}
        	],
			'bAutoWidth':true,
			'bFilter':false,
			'bDestroy':true,
			'bProcessing':true,
			'bServerSide':true,
			'bStateSave':true,
			'fnServerParams':function(aoData){
				var uMethod=getuMethod();
				var uHusergrpid=getuHusergrpid();
				var uDts=getuDts();
				var uCategory=getuCategory();
				var uAttribute=getuAttribute();
				var uOperator=getuOperator();
				var uKeyword=getuKeyword();
				aoData.push(
					{"name":"method","value":''+uMethod+''},
					{"name":"returnformat","value":"json"},
					{"name":"husergrpid","value":''+uHusergrpid+''},
					{"name":"dts","value":''+uDts+''},
					{"name":"category","value":''+uCategory+''},
					{"name":"attribute","value":''+uAttribute+''},
					{"name":"operator","value":''+uOperator+''},
					{"name":"keyword","value":''+uKeyword+''}
				);
        	},
			'sAjaxSource':'/body/searchresult.cfc',
			'sDom':'<"row"<"col-xs-6"l><"col-xs-6"p>r>t<"row"<"col-xs-6"i><"col-xs-6"p>>',
			'sServerMethod':'POST',
        	'sScrollX':'100%'
		});
	return resultTable;
};
function setuMethod(uMethod){
	method=uMethod;
};
function setuHusergrpid(uHusergrpid){
	husergrpid=uHusergrpid;
};
function setuDts(uDts){
	dts=uDts;
};
function setuCategory(uCategory){
	category=uCategory;
};
function setuAttribute(uAttribute){
	attribute=uAttribute;
};
function setuOperator(uOperator){
	operator=uOperator;
};
function setuKeyword(uKeyword){
	keyword=uKeyword;
};

function getuMethod(){
	return method;
};
function getuHusergrpid(){
	return husergrpid;
};
function getuDts(){
	return dts;
};
function getuCategory(){
	return category;
};
function getuAttribute(){
	return attribute;
};
function getuOperator(){
	return operator;
};
function getuKeyword(){
	return keyword;
};

function setInitialInvisibleColumn(columns){
	invisibleColumns=columns;
};

function showColumn(columns){	
	for (var i=0;i<27;i++){
		resultTable.fnSetColumnVis(i,false,false);
	};
	for (var i=0;i<columns.length;i++){
		resultTable.fnSetColumnVis(columns[i],true,false);
	};
};

function removeSorting(){
	resultTable.fnSort([]);
};

function redrawResultTable(){
	resultTable.fnDraw();
};