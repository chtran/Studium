Studium.Controllers.RoomsIndex =
  update_room_list: ->
    $.ajax({
      type: "POST",
      url: "/rooms/room_list.html"
      success: (data) ->
        $("#room_list").html(data)
    })

  update_recent_activities: (data) ->
    
    $("#recent_activities #activities_list").prepend(
      '<div class = "activity row-fluid">
        <div class = "span2">
          <img alt="Picture?type=square" class="profile-pic" src='+data.user_image+'>
        </div>
        <div class = "span9">
          <div class = "row-fluid">
            <strong>'+data.user_name+' </strong>
          </div>
          <div class = "row-fluid spacing activity-messages">
            <p>'+data.message+'</p>
          </div>
        </div>
      </div>')

  show_invite: (data) ->
    $("#invitation .modal-footer #accept").click(->
      window.location.replace("/rooms/join/"+data.room_id)
    )
    $("#invitation .modal-body p").text("You are invited by "+data.user_name+" to his room!")
    $("#invitation").modal("show")


  show_online_users: ->
    
    rooms_channel = Studium.Client.subscribe("presence-rooms")
    rooms_channel.bind('pusher:subscription_succeeded', ->
      online_users = $(".online-users-body .online-users-container")
      rooms_channel.members.each((member)->
        $.ajax({
            type: "POST",
            url: "/users/get_info"
            data:{
              email: member.info.email
            },
            success: (user_info) ->
              data = '<img alt="Picture?type=square" class="profile-pic" src='+user_info.image+'>'
              online_users.append(data)
          })
      )
    
    )

    
