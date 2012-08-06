# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  current_controller=gon.current_controller
  current_action=gon.current_action
  in_messages_index=current_controller=="messages" and current_action=="index"
  in_messages_read=current_controller=="messages" and current_action=="read"

  user_channel = client.subscribe("user_" + gon.user_id)
  
  user_channel.bind("message", (data) ->
    if in_messages_index
      $(".message-"+data.sender_id).html(data.message_new_chain)
      $(".message-"+data.receiver_id).html(data.message_new_chain)
    if in_messages_read
      $(".conversation_messages").append(data.new_message)
  )
  
  if in_messages_index
    available_names = gon.hash_data
    $("#input-receiver").tokenInput(available_names,
      {
        theme: "facebook"
      })

  if in_messages_read
    $(".reply-message").click ->
      $.ajax({
        type: "POST",
        url: "/messages",
        data: {
          receiver_id: $("#receiver_id").val(),
          "message[body]": $(".reply-body").val()
        },
        success: (data) ->
          $(".conversation_messages").append(data)
          $(".reply-body").val("")
      })
      
      false
)
