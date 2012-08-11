Studium.Controllers.MessagesRead =
  reply_message: ->
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

