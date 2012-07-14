# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(->
  init = (id)->
    $.ajax({
      type: "GET",
      url: "/stats/pull/"+id.toString(),
      success: (data)->
##
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'graph',
                type: 'spline'
            },
            title: {
                text: 'Your performance statistics'
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            yAxis: {
                title: {
                    text: 'percent answer correct'
                },
#labels: {
#                   formatter: ->
#                       return this.value +'°'
#               }
            },
            tooltip: {
                crosshairs: true,
                shared: true
            },
            plotOptions: {
                spline: {
                    marker: {
                        radius: 4,
                        lineColor: '#666666',
                        lineWidth: 1
                    }
                }
            },
            series: [{
                name: 'Tokyo',
                marker: {
                    symbol: 'square'
                },
                data: data['correct_interval']
            }]
        });
##

    });
  $("#math").click ->
    init(1);

  $("#CR").click ->
    init(2);
    
  $("#writing").click ->
    init(3);

  if $("#graph").length
    init(0);
 );

