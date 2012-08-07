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
 
    # Message Event Binding
    user_channel.bind("message", (data) ->
      # Update the message drop down (for both receiver and sender)
      $(".dropdown-menu-messages").empty()
      $(".dropdown-menu-messages").prepend(data.message_list)

      # Highlight emssage icon for receiver only
      $(".icon-comment").css({"color": "#fff"}) if data.sender_id

      # Update messages in index page for both sender and receiver
      if in_messages_index
        $(".message-"+data.sender_id).html(data.message_new_chain)
        $(".message-"+data.receiver_id).html(data.message_new_chain)

      # Update new message in read for receiver (sender will be updated when he/she clicks reply)
      if in_messages_read 
        # Append the new message to the conversation
        new_message=data.new_message
        $(".conversation_messages").append($(new_message).hide().fadeIn(1500))

        # Scroll the conversation box to show the latest message
        $(".conversation_messages").scrollTo($(".conversation_messages > div:last"))
    )
    
    if in_messages_index
      available_names = gon.hash_data
      $("#input-receiver").tokenInput(available_names,
        {
          theme: "facebook"
        })

      # Handles when user clicks new message => Send a post request to messages#create to create a new message and dismiss the new message modal when done
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

    # Handles when a user replies to messages in messages#read
    # Append the data returned by the ajax request (which is the new message) to the conversation
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
