# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  current_controller=gon.current_controller
  current_action=gon.current_action
  current_user_id = gon.user_id
  if current_controller=="profiles" and current_action=="show"
    if $("#profile-info").length
#      $.ajax({
#        type: "GET",
#        url: "/stats/show",
#        data: {
#          user_id: gon.user_id
#        },
#        success: (data) ->
#          $("#statistics").html(data.stats_content)
#      })
      $('#change-status').click ->
        $.ajax({
          type: "POST",
          url: "/users/#{current_user_id}/profile/update_status",
          data:{
            status: $('.status-content textarea').val()
          }
          success: (data) ->
            $('p#status').text(data.status)
            $('.status-content textarea').val('')
        })

      $('.status-content textarea').click ->
        $('.status-content textarea').attr('rows', 3)
        event.stopPropagation()
      $(document).click  ->
        $('.status-content textarea').attr('rows', 2)

      $("#add-me").live("click", ->
        $.ajax({
          type: "POST",
          url: "/friendships/add",
          data: {
            friend_id: gon.viewed_user_id
          },
          success: (data)->
            $("#add-me").hide()
        })
      )
      update_info = "
        <input type= 'text' class = 'input-large update-info'>
        <div class = 'btn btn-primary'>Save</div> 
      "

      
)
