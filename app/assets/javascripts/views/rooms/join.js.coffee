class Studium.Views.RoomsJoin extends Trunk.Views
  controller: "rooms"
  action: "join"
  channels:
    room_list: Studium.Client.subscribe("presence-rooms")
    user: Studium.Client.subscribe("user_#{gon.user_id}")
    room: Studium.Client.subscribe("presence-room_#{gon.room_id}")

  render: ->
    f = this.functions
    if !gon.observing
      f.change_question(gon.question_id)
    else
      $("#observing").modal({
        keyboard: false,
        backdrop: 'static',
        show: true
      })

    # Update the user list the first time
    f.update_users()
    disable_choice = (choice_id) ->
      console.log("disable #{choice_id}")
      $("#close-#{choice_id}").fadeTo("fast",0.2)
      $("#choice-#{choice_id}").removeClass("each_choice").addClass("disabled").removeClass("btn-primary")

    enable_choice = (choice_id) ->
      console.log("enable #{choice_id}")
      $("#close-#{choice_id}").fadeTo("fast",0.4)
      $("#choice-#{choice_id}").addClass("each_choice").removeClass("disabled")

    $(".disable").live("click", ->
      choice_id = $(this).data("choiceId")
      if $("#choice-#{choice_id}").hasClass("each_choice")
        disable_choice(choice_id)
      else
        enable_choice(choice_id)
    )

    # User clicking on a choice
    # Add class "btn-primary" to the chosen choice
    $(".question_active .each_choice").live("click", f.choose_answer)

    # User confirming the answer
    $("#confirm").live("click", ->
      # Get the choice_id by finding the "btn-primary" class
      choice_id = $(".question_active .each_choice.btn-primary").data("choiceId")
      # Remove the confirm button
      f.confirm_answer(choice_id)
      true
    )
    # User clicking "ready"
    $("#ready").live("click", f.ready)

    # Invite modal
    $("#invite_button").live("click", f.show_invite_modal)
    
    # When user invites some other user
    $(".invite_link").live("click", f.send_invite)

    # Send the message if it's not nil
    $("#chat .chat_send").live("click", f.send_chat)

    # stats about users popover when users' div are hovered in users_list
#    $("a[rel=popover]").popover()
#    $('.hover-data').popover({
#      placement: 'left'
#    })
    
    # When unload
    warning=true
    window.onbeforeunload= ->
      if warning
        return "Are you sure you want to leave the room?"

    $(window).unload(f.leave_room)

    # show modal asking whether the user wants to go after quitting the room
    $("#quit").live("click", ->
      $("#quit_modal").modal("show")
    )


  listen: ->
    f = this.functions
    this.channels.room.bind("update_histories", f.update_histories)
    this.channels.room.bind("update_news", f.update_news)
    this.channels.room.bind("users_change", f.update_users)
    this.channels.room.bind("chat_message", f.update_chat)
    this.channels.room.bind("show_explanation", f.show_explanation)
    this.channels.room.bind("next_question", (data)->
      $("#observing").modal("hide")
      gon.observing=false if gon.observing
      f.change_question(data.question_id)
    )
