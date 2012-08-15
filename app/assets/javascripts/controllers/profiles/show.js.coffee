Studium.Controllers.ProfilesShow=
  change_status: (current_user_id) ->
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

  add_me: ->
    $.ajax({
      type: "POST",
      url: "/friendships/add",
      data: {
        friend_id: gon.viewed_user_id
      },
      success: (data)->
        $("#add-me").hide()
    })
