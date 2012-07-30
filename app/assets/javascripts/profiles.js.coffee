# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  if $("#profile-info").length
    $.ajax({
      type: "GET",
      url: "/stats/show",
      data: {
        user_id: gon.user_id
      },
      success: (data) ->
        $("#statistics").html(data.stats_content)
    })
)
