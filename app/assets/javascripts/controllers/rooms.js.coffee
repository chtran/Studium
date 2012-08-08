class @RoomsController
  @index:
    update_room_list: ->
      $.ajax({
        type: "POST",
        url: "/rooms/room_list.html"
        success: (data) ->
          $("#room_list").html(data)
      })

    update_recent_activities: (data) ->
      $("#recent_activities #activities_list").prepend(
        '<li>
          <a> '+ data.message + ' 
        </li>')

    show_invite: (data) ->
      $("#invitation .modal-footer #accept").attr("href","/rooms/join/"+data.room_id)
      $("#invitation .modal-body p").text("You are invited by "+data.user_name+" to his room!")
      $("#invitation").modal("show")
