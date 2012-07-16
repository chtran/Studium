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
                text: 'Your percentage of correct answers progress'
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            yAxis: {
                title: {
                    text: 'percent'
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
  c_stacked = (id)->
      $.ajax({
        type: "GET",
        url: "stats/pull_stacked/"+id.toString(),
        success: (data)->
          chart_column = new Highcharts.Chart({
              chart: {
                  renderTo: 'column_stacked',
                  type: 'column'
              },
              title: {
                  text: 'Stacked column chart'
              },
              xAxis: {
                  categories: ['Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas']
              },
              yAxis: {
                  min: 0,
                  title: {
                      text: 'Total fruit consumption'
                  },
                  stackLabels: {
                      enabled: true,
                      style: {
                          fontWeight: 'bold',
                          color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                      }
                  }
              },
              legend: {
                  align: 'right',
                  x: -100,
                  verticalAlign: 'top',
                  y: 20,
                  floating: true,
                  backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
                  borderColor: '#CCC',
                  borderWidth: 1,
                  shadow: false
              },
              tooltip: {
#                formatter: -> {
#                    return '<b>'+ this.x +'</b><br/>'+
#                        this.series.name +': '+ this.y +'<br/>'+
#                        'Total: '+ this.point.stackTotal;
#                }
              },
              plotOptions: {
                  column: {
                      stacking: 'normal',
                      dataLabels: {
                          enabled: true,
                          color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                      },

                  }
              },
              series: [{
                  name: 'Correct',
                  data: data['correct_data']
              }, {
                  name: 'Incorrect',
                  data: data['incorrect_data']
              }]
            });
        });
  recent = ->
    $.ajax({
        type: "GET",
        url: "stats/test_ajax"
        success: (data)->
          document.getElementById('bar-math').style.width = data['math'].toString()+'%';
        })
  
  if $("#progress-bar-math").length
    recent();


  $("#math_graph").click ->
    init(1);

  $("#CR_graph").click ->
    init(2);
    
  $("#writing_graph").click ->
    init(3);

  $("#math_column").click ->
    c_stacked(1);

  $("#CR_column").click ->
    c_stacked(2);
    
  $("#writing_column").click ->
    c_stacked(3);


  if $("#graph").length
    init(0);

  if $("#column_stacked").length
    c_stacked(0);
 )

