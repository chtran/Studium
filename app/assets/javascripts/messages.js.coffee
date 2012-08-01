# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  current_controller=gon.current_controller
  current_action=gon.current_action
  in_messages_index=current_controller=="messages" and current_action=="index"

  user_channel = client.subscribe("user_" + gon.user_id)
  
  user_channel.bind("message", (data) ->
    $("#messages_body").prepend(data.message_row) if in_messages_index
    $("#dropdown-message").prepend(data.message_item)
  )
  
  if in_messages_index
    available_names = gon.hash_data
    $("#input-receiver").tokenInput(available_names,
      {
        theme: "facebook"
      })
)
