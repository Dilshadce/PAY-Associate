<script type="text/javascript">
function getItemNew(divid,itemno,filterby,filteron)
{
	if(trim(document.getElementById(filterby).value) !='')
	{
	var ajaxurl = '/object/act_getitem.cfm?new=1&searchtype='+document.getElementById(filteron).value + '&text=' + escape(encodeURI(document.getElementById(filterby).value));
		 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById(divid).innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Found!'); },		
		onComplete: function(transport){
			try{
			showImage(document.getElementById(itemno).value);
			}
			catch(err)
			{
			}
        }
      })	  
	}
}
</script>
