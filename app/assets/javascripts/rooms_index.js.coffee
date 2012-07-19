$(->
  init = (key) ->
    client = new Pusher(key)
    channel = client.subscribe('rooms')
    update_room_list = ->
      $.ajax({
        type: "POST",
        url: "/rooms/room_list.html"
        success: (data) ->
          $("#room_list").html(data)
      })

    # Subscribe to the "rooms/create" channel
    channel.bind("create", (data) ->
      update_room_list()
    )

    update_room_list()

  if $("#rooms_index").length
    $.get("/pusher_key", (key)->
      init(key)
    )
)
