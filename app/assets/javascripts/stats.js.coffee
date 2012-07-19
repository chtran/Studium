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
                categories: data['key_interval']
            },
            yAxis: {
                title: {
                    text: 'percent'
                },
                labels: {
#                  formatter: ->
#                    console.log(this)
#                    return this['value'] +'%'
                }
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
                name: 'Percent Of Correct Answers'
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
        url: "/stats/pull_stacked/"+id.toString(),
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
                  categories: data['key_interval']
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
  recent = (interval)->
    $.ajax({
        type: "GET",
        url: "stats/pull_pro_bar/"+interval.toString(),
        success: (subject_data)->
            for s in subject_data
              bar_id = "bar-"+s['name'];
              percent_id = "percent_" + s['name'];
              total_answers_id = "total_answers_" + s['name'];
              correct_answers_id = "correct_answers_" + s['name']
              percent = s["data"]["percent"]
              document.getElementById(bar_id).style.width = percent.toString()+'%';
              document.getElementById(percent_id).innerHTML = s['data']['percent']+'%';
              document.getElementById(total_answers_id).innerHTML = s['data']['total_answers'];
              document.getElementById(correct_answers_id).innerHTML = s['data']['correct_answers'];
        })
  
  if $("#interval_btn").length then recent(1);

  $("#today").click ->
    recent(1);

  $("#last_week").click ->
    recent(7);

  $("#last_month").click ->
    recent(30);


  number_of_categories = document.getElementById('dropdown-subjects').getElementsByTagName('li').length;
  range = [1..number_of_categories];
  for id in range
    $("#"+id.toString()+"_graph").click -> 
      graph(this);
    $("#"+id.toString()+"_column").click -> 
      graph(this);

  graph = (subject)->
    offset = subject.id.split("_")[1];
    id = parseInt(subject.id.split("_")[0]);
    if offset == "graph" then init(id);
    if offset == "column" then c_stacked(id);
    

  if $("#graph").length
    init(0);

  if $("#column_stacked").length
    c_stacked(0);
 )

