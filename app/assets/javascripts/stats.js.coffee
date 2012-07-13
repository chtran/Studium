# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(->
  init = ->
    $.ajax({
      type: "GET",
      url: "/stats/pull",
      success: (data)->
        
##
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'graph',
                type: 'spline'
            },
            title: {
                text: 'Monthly Average Temperature'
            },
            subtitle: {
                text: 'Source: WorldClimate.com'
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            yAxis: {
                title: {
                    text: 'Temperature'
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
                data: [{
                    y: 0   
                }, 0.0, 0.9, 0.5, 0.5, 0.2, 0.5, 0.2, 0.3, 0.3, 0.9, 0.6]
    
            }, {
                name: 'London',
                marker: {
                    symbol: 'diamond'
                },
                data: [{
                    y: 0,
                   
                }, 0.2, 0.7, 0.5, 0.9, 0.2, 0.0, 0.6, 0.2, 0.3, 0.6, 0.8]
            }]
        });
##
    });
  x = 1
  getx = -> 
    return x
  if $("#graph").length
    init(); 
 );
 x = 1 
 alert(x)

