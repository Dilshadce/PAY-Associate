// JavaScript Document
$(document).ready(function(e) {
	/*
		leftFrame
		topFrame
		mainFrame
		top.frames['mainFrame'].function();
	*/
	if(top.frames['mainFrame'].document.title!='Search Result'){
		var resultFrame=window.open('/body/searchresult.cfm','mainFrame');
	};
	$('#backNavigation').on('click',function(e){
		window.open('/body/overview.cfm','mainFrame');
		window.open('/side/sidemenu.cfm','_self');
	});
	$('#keyword').on('change',function(e){
		if(top.frames['mainFrame'].document.title!='Search Result'){
			var resultFrame=window.open('/body/searchresult.cfm','mainFrame');
		};
		top.frames['mainFrame'].setuKeyword($('#keyword').val());
		top.frames['mainFrame'].redrawResultTable();
	});
	$('#category').on('change',function(e){
		if(top.frames['mainFrame'].document.title!='Search Result'){
			var resultFrame=window.open('/body/searchresult.cfm','mainFrame');
		};
		var category=$(this).val();
		var attributeOptions='';
		if(category=='transaction'){
			attributeOptions=	'<option value="accno" class="stringAttribute">Account No.</option>'+
								'<option value="fperiod" class="numberAttribute">Period</option>'+
								'<option value="date" class="dateAttribute">Date</option>'+
								'<option value="batchno" class="numberAttribute">Batch No.</option>'+
								'<option value="tranno" class="numberAttribute">Transaction No.</option>'+
								'<option value="reference" class="stringAttribute">Reference</option>'+
								'<option value="refno" class="stringAttribute">Reference 2</option>'+
								'<option value="desp" class="stringAttribute">Description</option>'+
								'<option value="debitamt" class="numberAttribute">Debit Amount</option>'+
								'<option value="creditamt" class="numberAttribute">Credit Amount</option>'+
								'<option value="job" class="stringAttribute">Job</option>';
			//top.frames['mainFrame'].showColumn([0,1,2,3,4,5,6,7,8,9,10,26]);
			top.frames['mainFrame'].showColumn([0,1,2,3,4,5,6,9,10,26]);
			top.frames['mainFrame'].removeSorting();
		}else if(category=='customer'){
			attributeOptions=	'<option value="custno" class="stringAttribute">Customer No.</option>'+
								'<option value="name" class="stringAttribute">Name</option>'+
								'<option value="address" class="stringAttribute">Address</option>'+
								'<option value="country" class="stringAttribute">Country</option>'+
								'<option value="postalcode" class="stringAttribute">Postal Code</option>'+
								'<option value="attn" class="stringAttribute">Attention</option>'+
								'<option value="e_mail" class="stringAttribute">Email</option>'+
								'<option value="web_site" class="stringAttribute">Website</option>'+
								'<option value="phone" class="stringAttribute">Phone</option>'+
								'<option value="fax" class="stringAttribute">Fax</option>'+
								'<option value="contact" class="stringAttribute">Contact</option>'+
								'<option value="currency" class="stringAttribute">Currency</option>'+
								'<option value="bankaccno" class="stringAttribute">Bank Account No.</option>'+
								'<option value="date" class="dateAttribute">Date</option>';
			//top.frames['mainFrame'].showColumn([11,13,14,15,16,17,18,19,20,21,22,23,24,25,26]);
			top.frames['mainFrame'].showColumn([11,13,14,17,20,21,23,25,26]);			
			top.frames['mainFrame'].removeSorting();
		}else if(category=='supplier'){
			attributeOptions=	'<option value="custno" class="stringAttribute">Supplier No.</option>'+
								'<option value="name" class="stringAttribute">Name</option>'+
								'<option value="address" class="stringAttribute">Address</option>'+
								'<option value="country" class="stringAttribute">Country</option>'+
								'<option value="postalcode" class="stringAttribute">Postal Code</option>'+
								'<option value="attn" class="stringAttribute">Attention</option>'+
								'<option value="e_mail" class="stringAttribute">Email</option>'+
								'<option value="web_site" class="stringAttribute">Website</option>'+
								'<option value="phone" class="stringAttribute">Phone</option>'+
								'<option value="fax" class="stringAttribute">Fax</option>'+
								'<option value="contact" class="stringAttribute">Contact</option>'+
								'<option value="currency" class="stringAttribute">Currency</option>'+
								'<option value="bankaccno" class="stringAttribute">Bank Account No.</option>'+
								'<option value="date" class="dateAttribute">Date</option>';
			//top.frames['mainFrame'].showColumn([12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]);
			top.frames['mainFrame'].showColumn([12,13,14,17,20,21,23,25,26]);	
			top.frames['mainFrame'].removeSorting();
		};				
		top.frames['mainFrame'].setuCategory(category);
		$('#attribute').empty().append(attributeOptions);
		$('#attribute').trigger('change');		
	});
	$('#attribute').on('change',function(e){
		if(top.frames['mainFrame'].document.title!='Search Result'){
			var resultFrame=window.open('/body/searchresult.cfm','mainFrame');
		};
		$('#keyword').datepicker('destroy');
		var attributeType=$(this).children(':selected').attr('class');
		var operatorOptions='';
		if(attributeType=='stringAttribute'){
			operatorOptions=	'<option value="contain">Contains</option>'+
								'<option value="notContain">Not Contains</option>'+
								'<option value="equalTo">Equal To</option>'+
								'<option value="notEqualTo">Not Equal To</option>';
		}else if(attributeType=='numberAttribute'){
			operatorOptions=	'<option value="equalTo">Equal To</option>'+
								'<option value="notEqualTo">Not Equal To</option>'+
								'<option value="lessThan">Less Than</option>'+
								'<option value="greaterThan">Greater Than</option>'+
								'<option value="lessEqual">Less Than Or Equal To</option>'+
								'<option value="greaterEqual">Greater Than Or Equal To</option>'+
								'<option value="contain">Contains</option>'+
								'<option value="notContain">Not Contains</option>';
		}else if(attributeType=='dateAttribute'){
			operatorOptions=	'<option value="equalTo">Equal To</option>'+
								'<option value="notEqualTo">Not Equal To</option>'+
								'<option value="before">Before</option>'+
								'<option value="after">After</option>'+
								'<option value="beforeEqual">Before Or Equal To</option>'+
								'<option value="afterEqual">After Or Equal To</option>';
			$('#keyword').datepicker({
				dateFormat: "dd/mm/yy",
				changeMonth: true,
				changeYear: true,
			});
		};
		top.frames['mainFrame'].setuAttribute($('#attribute').val());
		$('#operator').empty().append(operatorOptions);
		$('#operator').trigger('change');
	});
	$('#operator').on('change',function(e){
		if(top.frames['mainFrame'].document.title!='Search Result'){
			var resultFrame=window.open('/body/searchresult.cfm','mainFrame');
		};
		top.frames['mainFrame'].setuOperator($('#operator').val());
		top.frames['mainFrame'].redrawResultTable();
	});
});
function initResultTable(){
	var category=$('#category').val();
	var invisibleColumns='';
	if(category=='transaction'){
		//invisibleColumns=[11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
		invisibleColumns=[7,8,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25];
	}else if(category=='customer'){
		//invisibleColumns=[0,1,2,3,4,5,6,7,8,9,10,12];
		invisibleColumns=[0,1,2,3,4,5,6,7,8,9,10,12,15,16,18,19,22,24];		
	}else if(category=='supplier'){
		//invisibleColumns=[0,1,2,3,4,5,6,7,8,9,10,11];
		invisibleColumns=[0,1,2,3,4,5,6,7,8,9,10,11,15,16,18,19,22,24];
	};
	top.frames['mainFrame'].setuMethod('listSearchResult');
	top.frames['mainFrame'].setuHusergrpid(husergrpid);
	top.frames['mainFrame'].setuDts(dts);
	top.frames['mainFrame'].setuCategory(category);
	top.frames['mainFrame'].setuAttribute($('#attribute').val());
	top.frames['mainFrame'].setuOperator($('#operator').val());
	top.frames['mainFrame'].setuKeyword($('#keyword').val());
	top.frames['mainFrame'].setInitialInvisibleColumn(invisibleColumns);
	return top.frames['mainFrame'].initResultTable();
};