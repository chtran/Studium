Studium.Controllers.ApplicationMessages=
  check_message_read: ->
    # Send a post request to indicate that all messages have been read
    $.ajax({
      type: "POST",
      url: gon.read_all_mes_url,
      data: {
        user_id: gon.user_id
      },
      success: (data) ->
        # Unhighlight the message icon
        $(".icon-comment").removeClass("message-white")
    })

  update_message_dropdown: (data) ->
    # Update the message drop down (for both receiver and sender)
    $(".dropdown-menu-messages").empty()
    $(".dropdown-menu-messages").prepend(data.message_list)

    # Highlight emssage icon for receiver only
    $(".icon-comment").addClass("message-white") if data.sender_id

