<cfcomponent>
<cffunction name="cal_extra_wrking_hour" access="public" returntype="any" >

	
</cffunction>

	<cffunction name="cal_basicpay" access="public" returntype="any" >
		<cfargument name="spaytype" required="yes">
		<cfargument name="wDay" required="no">
		<cfargument name="brate" required="no">	
		<cfargument name="lS" required="no">
		<cfargument name="nPL" required="no">
		<cfargument name="aB" required="no">
		<cfargument name="mT" required="no">
		<cfargument name="oNPL" required="no">	
		<cfargument name="piecepay" required="no">
		<cfargument name="backpay" required="no">
		<cfargument name="workHR" required="no">
		<cfargument name="lateHR" required="no">
		<cfargument name="bp_dedratio" required="no">
		<cfargument name="earlyHR" required="no">
		<cfargument name="noPayHR" required="no">	
		<cfargument name="work_h" required="no">
		<cfargument name="work_d" required="no">
			
			<cfif spaytype eq "D" >
			    
			    
				<!---  rate per hour --->
				<cfset hour_r = val(brate)/ val(work_d) / val(work_h)> 
				
		        <cfset total_work_h = val(workHR) * hour_r>
		     
	        	<!--- Lateness Hours Process --->
		      
		        <cfset total_late_h = val(lateHR) * hour_r * val(bp_dedratio) >
		        <cfset total_earlyD_h = val(earlyHR) * hour_r * val(bp_dedratio)>
		        <cfset total_noP_h = val(noPayHR) * hour_r * val(bp_dedratio)> 
		        
				<cfset total_extra_hour = val(total_work_h) -(val(total_earlyD_h) - val(total_late_h) - val(total_noP_h))>
				
				<cfset dminustemp =  val(lS) +  val(nPL) +  val(aB) +  val(oNPL) >
			    <cfset payday = val(WDay) - dminustemp> 
			   
			    <cfset basicpay = (val(payday) / val(wDay) * val(bRate)) + val(piecepay) - val(backpay)>  
				
				<cfset basicpay = basicpay + total_extra_hour>
				
				
			<cfelseif spaytype eq "M" >       
					 
				<cfset dminustemp =  val(lS) +  val(nPL) +  val(aB) +  val(oNPL)  >
		        <cfset payday = val(WDay) - dminustemp>
		        
		        <cfset basicpay = (val(payday) / val(wDay) * val(bRate)) + val(piecepay) - val(backpay)>
		        
		       <!---  rate per hour --->
		        <cfset hour_r = val(brate)/ val(work_d) / val(work_h)>  
				<cfset total_work_h = val(workHR) * hour_r>
		      	<cfset total_late_h = val(lateHR) * hour_r * val(bp_dedratio) >
		        <cfset total_earlyD_h = val(earlyHR) * hour_r * val(bp_dedratio)>
		        <cfset total_noP_h = val(noPayHR) * hour_r * val(bp_dedratio)> 
		        
				<cfset total_extra_hour = val(total_work_h) - val(total_earlyD_h) - val(total_late_h) - val(total_noP_h)>
				 
				<cfset basicpay = basicpay + total_extra_hour>
		
			<cfelseif spaytype eq "H">
					
				<cfset total_late_h = val(lateHR) * val(bp_dedratio) >
				<cfset total_earlyD_h = val(earlyHR) *  val(bp_dedratio)>
		        <cfset total_noP_h = val(noPayHR) * val(bp_dedratio)>
				<cfset pay_hour = val(brate) - val(total_late_h) - val(total_earlyD_h) - val(total_noP_h)>
					
				<cfset dminustemp =  val(lS) +  val(nPL) +  val(aB) +  val(oNPL)>
				<cfset payday = val(WDay) - dminustemp>
		        <cfset pay_day_rate = val(payday) * val(work_h) * val(brate)>
				
				<cfset basicpay = val(pay_hour)  + val(piecepay) - val(backpay) + val(pay_day_rate)>
	       
			</cfif>
		
		<cfreturn basicpay>
	</cffunction>
	
</cfcomponent>

