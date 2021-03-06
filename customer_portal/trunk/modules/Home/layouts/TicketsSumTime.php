<?php
/*+***********************************************************************************************************************************
 * The contents of this file are subject to the YetiForce Public License Version 1.1 (the "License"); you may not use this file except
 * in compliance with the License.
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is YetiForce.
 * The Initial Developer of the Original Code is YetiForce. Portions created by YetiForce are Copyright (C) www.yetiforce.com. 
 * All Rights Reserved.
 *************************************************************************************************************************************/
?>
<div class="col-lg-6 TicketsSumTime">
	<input class="widgetData" type="hidden" value='<?php echo json_encode($data); ?>' />
	<div class="panel panel-default">
		<div class="panel-heading"><?php echo Language::translate("LBL_WIDGET_TICKETSSUMTIME"); ?></div>
		<div class="panel-body" style="height: 380px;">
			<div id="TicketsSumTime" style="height: 350px;"></div>
		</div>
	</div>
</div>
<script>
$(document).ready(function(){
	var widgetsTicketsSumTime = $("#TicketsSumTime");
	var ticketsSumTimeData = JSON.parse($(".TicketsSumTime .widgetData").val());
	var ticketsSumTimeChartData = [];
	var ticketsSumTimeURLs = [];
	for(var index in ticketsSumTimeData) {
		var row = ticketsSumTimeData[index];
		var rowData = [row.name, parseFloat(row.count), row.id];
		ticketsSumTimeChartData.push(rowData);
		//ticketsSumTimeURLs.push(row.id: rowData);
	}
	jQuery.jqplot.config.enablePlugins = true;
	plot7 = widgetsTicketsSumTime.jqplot(
		[ticketsSumTimeChartData], {
			seriesDefaults: {
				shadow: true, 
				renderer: jQuery.jqplot.PieRenderer, 
				rendererOptions: { 
					showDataLabels: true,
					dataLabels: 'value'
				} 
			}, 
			grid: {
				drawBorder: false, 
				drawGridlines: false,
				background: '#ffffff',
				shadow:false
			},
			legend: { 
				show:true, 
				location:'w',
			}
		}
	);
	widgetsTicketsSumTime.on("jqplotDataClick", function(evt, seriesIndex, pointIndex, neighbor) {
		//var linkUrl = thisInstance.data['links'][pointIndex];
		//if(linkUrl) window.location.href = linkUrl;
		//console.log(pointIndex);
	});
});
</script>