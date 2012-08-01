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

    user_channel.bind("message", (data)->
      $("#dropdown-message").prepend(" 
        <li bgcolor = '#eee'>
          <a href='/messages/'#{data.message_id.to_s}>
            <div class = 'row-fluid'>
              <div class = 'span3'> 
                <img alt='Picture?type=square' src = #{data.image}>
              </div>

              <div class = 'span9'>
                <div>
                  <b>#{data.sender}</b>
                </div>
                <small>#{data.body[0..36] + ' ...'}</small>
              </div>
            </div>
          </a>
        </li>
        <li class = 'divider'>
        </li>
      ")
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
