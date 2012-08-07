$(->
  init = ->
    # Subscribe use to the required channels
    channel = client.subscribe("presence-rooms")
    user_channel = client.subscribe("user_"+gon.user_id)

    # Function that updates the room list by sending a post request 
    update_room_list = ->
      $.ajax({
        type: "POST",
        url: "/rooms/room_list.html"
        success: (data) ->
          $("#room_list").html(data)
      })

    # Subscribe to the "rooms_change" event (Update the room list)
    channel.bind("rooms_change", (data) ->
      update_room_list()
    )

    # Subscribe to the update recent activities event
    channel.bind("update_recent_activities", (data) ->
      $("#recent_activities #activities_list").prepend(
        '<li>
          <a> '+ data.message + ' 
        </li>')
    )

    # Subscribe to invite event (user might be invited by someone inside the room)
    user_channel.bind("invite", (data) ->
      $("#invitation .modal-footer #accept").attr("href","/rooms/join/"+data.room_id)
      $("#invitation .modal-body p").text("You are invited by "+data.user_name+" to his room!")
      $("#invitation").modal("show")
    )

    # Update the room list initially (when page first loads)
    update_room_list()

    formatItem=(row,position,length) ->
      alert row
      return "Kien Hoang"

    # Autocompletion for friend-search
    $(".search-friend").autocomplete(
      $(".search-friend").data("friend-suggestion"), 
      {
        formatItem: formatItem
      })

  # Only run the above code if user is in room's index page
  current_controller=gon.current_controller
  current_action=gon.current_action
  if  current_controller=="rooms" and current_action=="index"
    init()
)
