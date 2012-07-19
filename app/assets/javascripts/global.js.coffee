$(->
  init = (key) ->
    client = new Pusher(key)
    channel = client.subscribe('presence-app')

    update_online_users = -> 
      channel.members.each((member) ->
        $("#user_"+member.id).addClass("online")
      )

    channel.bind("pusher:subscription_succeeded", update_online_users)

  $.get("/pusher_key", (key)->
    init(key)
  )
)
