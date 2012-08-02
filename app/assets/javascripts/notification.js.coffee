$(->
  user_channel = client.subscribe("user_"+gon.user_id)

  user_channel.bind("notification", (data) ->
  )
)
