$(->
  init = ->
    channel = client.subscribe("presence-rooms")
    user_channel = client.subscribe("user_"+gon.user_id)
    update_room_list = ->
      $.ajax({
        type: "POST",
        url: "/rooms/room_list.html"
        success: (data) ->
          $("#room_list").html(data)
      })

    # Subscribe to the "rooms_change" event
    channel.bind("rooms_change", (data) ->
      update_room_list()
    )

    channel.bind("update_recent_activities", (data) ->
      $("#recent_activities #activities_list").prepend(
        '<li>
          <a> '+ data.message + ' 
        </li>') 
    )

    user_channel.bind("invite", (data) ->
      $("#invitation .modal-footer #accept").attr("href","/rooms/join/"+data.room_id)
      $("#invitation .modal-body p").text("You are invited by "+data.user_name+" to his room!") 
      $("#invitation").modal("show")
    )


    update_room_list()


  if $("#rooms_index").length
    init()
)
