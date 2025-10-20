document.onmouseover = shrinkAll; //handles abandoned selections (no change)

	function resize(id){
		var elem = document.getElementById(id); //get the element in question
		var holder = eval("hold"+id);//dynamically init/assign the holder variable
		if (!holder){//if select not being held open
			if(elem.style.width == 'auto') elem.style.width = id.split("_")[1];
			else elem.style.width = 'auto';
		}else{
			elem.style.width = 'auto';
		}
	}
	function hold(id){
		eval("hold" + id + " = !hold" + id); //swap the hold value, dynamic of course
		resize(id); //change size if necessary
	}
	function shrink(id){//get element to shrink
		var elem = document.getElementById(id);
		elem.style.width = id.split("_")[1]; //set width to small
		//unhold
		eval("hold" + id + " = false");
	}
	function shrinkAll(e){
		if (!e) var e = window.event;
		var target = (window.event) ? e.srcElement : e.target;
		var selects = document.getElementsByTagName('select'); //shrink em all except that one that was the source (possibly)
		var prefix = 's';   //prefix used on all select box IDs
		for(i=0; i<selects.length; i++){
			if(selects[i].id.substring(0,prefix.length) == prefix){//shrink if it wasn't the source (make sure the src isn't parent for <option> in mozilla)
				if(selects[i].id != target.id && selects[i].id != target.parentNode.id ){
					shrink(selects[i].id);
				}
			}
		}
	}