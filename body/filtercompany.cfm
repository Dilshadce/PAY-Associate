<cfoutput>
	<script type="text/javascript">
		var dts='#dts#';
		var limit=10;
	</script>
</cfoutput>

<script type="text/javascript">

	function formatResult99(result){
		return result.companyID;  
	};
	
	function formatSelection99(result){
		return result.companyID;   
	};
	
	$(document).ready(function(e) {
		$('.companyFilter').select2({
			ajax:{
				type: 'POST',
				url:'/body/filterCompany.cfc',
				dataType:'json',
				data:function(term,page){
					return{
						method:'listAccount',
						returnformat:'json',
						dts:dts,
						term:term,
						limit:limit,
						page:page-1,
					};
				},
				results:function(data,page){
					var more=((page-1)*limit)<data.total;
					return{
						results:data.result,
						more:more
					};
				}
			},
			initSelection: function(element, callback) {
				var value=$(element).val();
				if(value!=''){
					$.ajax({
						type:'POST',
						url:'/body/filterCompany.cfc',
						dataType:'json',
						data:{
							method:'getSelectedAccount',
							returnformat:'json',
							dts:dts,
							value:value,
						},
					}).done(function(data){callback(data);});
				};
			},
			formatResult:formatResult99,
			formatSelection:formatSelection99,
			minimumInputLength:0,
			width:'off',
			dropdownCssClass:'bigdrop',
			dropdownAutoWidth:true,
		});
	});
</script>
