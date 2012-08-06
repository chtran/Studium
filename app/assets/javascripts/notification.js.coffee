$(->
  if typeof client != 'undefined'
    user_channel = client.subscribe("user_"+gon.user_id)

    # Default settings for notification
    $.pnotify.defaults.styling="bootstrap"
    $.pnotify.defaults.sticker=false
    $.pnotify.defaults.icon=false
    $.pnotify.defaults.insert_brs=false
    $.pnotify.defaults.history=false

    user_channel.bind("notification", (data) ->
      $message=data.message
      $.pnotify({
        title: data.title,
        text: $message,
        type: data.type,
      })
    )
)
