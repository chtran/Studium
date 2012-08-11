Studium.Controllers.MessagesIndex = 
  update_message_index: (data) ->
    $(".message-"+data.sender_id).html(data.message_new_chain)
    $(".message-"+data.receiver_id).html(data.message_new_chain)

  new_message: ->
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
