Studium.Controllers.RoomsJoin =
  # Input: none
  # Effect: update the user list to div#top_nav
  update_users: ->
    $.ajax({
      type: "POST",
      url: "/rooms/user_list",
      success: (data) ->
        $("#user_list").html(data)
        true
    })
    true

  # Input: question_id
  # Effect: changes HTML content of #current_question to show the new question
  change_question: (question_id) ->
    return false if gon.observing
    $.ajax({
      type: "POST",
      url: "/rooms/show_question",
      data: {
        question_id: question_id
      },
      success: (data) ->
        if data.message
          alert(data.message)
          window.onbeforeunload=null
          window.location.replace("/rooms")
        else
          if data.question_image_url!=""
            $image_url=$("<img src=\""+data.question_image_url+"\"></img>")
            $(".question_image").html($image_url)
          else
            $(".question_image").html("")
          $("#prompt").html(data.question_prompt)
          $("#choices").html(data.question_choices)
          if data.paragraph != ""
            if !$("#paragraph").length
              $("#current_question").append("<div class='span6 prettyprint pre-scrollable linenums' id='paragraph'></div>")
            $("#paragraph").html(data.paragraph).show()
          else
            $("#paragraph").remove()
          $("#current_question").addClass("question_active")
          Studium.Controllers.RoomsJoin.setup_timer(120,Studium.Controllers.RoomsJoin.confirm_answer)

          # Reload MathJax
          MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    })
    true

  # Input: question_id and choice_id
  # Effect: render the explanation for the given question
  show_explanation: ->
    return false if gon.observing
    $.ajax({
      type: "POST",
      url: "/rooms/show_explanation",
      success: (data) ->
        $("#choices").html(data)
        Studium.Controllers.RoomsJoin.setup_timer(120, Studium.Controllers.RoomsJoin.ready)

        $("#history .hide").removeClass("hide").effect("highlight",2000)
        # Reload MathJax
        MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    })
    # Show the ready button
    $("#ready").show()

  choose_answer: ->
    $(this).siblings().removeClass("btn-primary")
    $(this).addClass("btn-primary")

    # For vocab reading questions
    # There can be multiple blanks -> get the array of all the blanks
    contents = $(this).find(".choice_content").text().split("..")
    count = 1
    for content in contents
      $("#blank_"+count).val(content)
      count++

    $("#confirm").show()
    true

  confirm_answer: (choice_id) ->
    return false if gon.observing
    $("#confirm").hide()
    $("#timer").countdown("destroy")
    # Send a POST request to "/rooms/choose" (rooms#choose)
    $.ajax({
      type: "POST",
      url: "/rooms/confirm/",
      data: {
        choice_id: choice_id
      }
    })
    # Remove question_active class so that the choices are not clickable
    $("#current_question").removeClass("question_active")
    # Disable the button for each choice
    $(".each_choice").addClass("disabled")
  
  # Input: none
  # Effect: send a POST request to ready
  ready: ->
    return false if gon.observing
    $("#timer").countdown("destroy")
    $("#ready").hide()
    $.ajax({
      type: "POST",
      url: "/rooms/ready",
    })
    true

  # Update the latest history
  update_histories: (data)->
    history_id = data.history_id
    return false if gon.observing
    $.ajax({
      type: "POST",
      url: "/histories/show_history",
      data: {
        history_id: history_id
      },
      success: (data) ->
        $("#history").append(data)
        #$("#history").animate({
        #  scrollTop: $("#history p:last").position().top
        #},1000)
    })
    true

  update_news: (data) ->
    $news="<p>"+data.news+"</p>"
    $("#history").append($news)
    $("#history p:last").effect("highlight",2000)

  update_chat: (data) ->
    $(".chat-content").append(data.message)
    $(".chat-content p:last-child").effect("highlight",{},2000)

  # Input: time(seconds), callback(function)
  # Effect: Setup the timer with the specified time and callback
  setup_timer: (time, callback) ->
    $("#timer").countdown({
      until: time,
      compact: true,
      format: 'S',
      description: '',
      onExpiry: callback
    })

  show_invite_modal: ->
    user_list = $("#invite .modal-body p")
    user_list.text("")
    rooms_channel = Studium.Client.subscribe("presence-rooms")
    current_user=rooms_channel.members.me
    data="Active Users: <br />"
    rooms_channel.members.each((member) ->
      if member.id-current_user.id!=0
        data = "<div><a href='#' class='invite_link' data-user-id="+member.id+">"+member.info.name+"</a></div>"

      user_list.append(data)
    )
    $("#invite.modal").modal("show")

  send_invite: ->
    $.ajax({
      type: "POST",
      url: "/rooms/invite",
      data: {
        user_id: $(this).data("userId")
      }
      success: ->
        alert("Invited "+$(this).text())
    })

  send_chat: ->
    message = $("#chat .chat_message").val()
    if message!=""
      $.ajax({
        type: "POST",
        url: "/rooms/chat_message",
        data: {
          message: message
        }
      })
      $("#chat .chat_message").val("")

  leave_room: ->
    $.ajax({
      type: "GET",
      url: "/rooms/leave_room",
      async: false,
    })
