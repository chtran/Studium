# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  current_controller=gon.current_controller
  current_action=gon.current_action
  in_messages = current_controller=="messages"
  in_messages_index=current_controller=="messages" and current_action=="index"
  in_messages_read=current_controller=="messages" and current_action=="read"

  if in_messages
    user_channel = client.subscribe("user_" + gon.user_id)
  
    user_channel.bind("message", (data) ->
      $(".dropdown-menu-messages").empty()
      $(".dropdown-menu-messages").prepend(data.message_list)
      $(".icon-comment").css({"color": "#fff"})

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

      $(".new-message").click ->
        $.ajax({
          type: "POST",
          url: "/messages",
          data: {
            receiver_id: $(".new-message-receivers").val(),
            "message[body]": $(".new-message-body").val()
          },
          success: (data) ->
            $(".token-input-token-facebook").remove()
            $(".new-message-body").val("")
            $("#new_message").modal("hide")
        })
        
        false

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
