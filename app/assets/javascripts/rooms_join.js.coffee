# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(->
  # Define the whole code as the function init. Only execute init when the page is #rooms_join (see the end of the file for this execution)
  init = ->
    # Get room_id from gon
    room_id = gon.room_id

    channel = client.subscribe("presence-room_"+room_id);
    rooms_channel = client.subscribe("presence-rooms")
    # Listen to the "pusher:member_removed" event which keep tracks of user leaving the room
    channel.bind('pusher:member_removed', (member) ->
      # Send a POST request to rooms#kick, which kick the user from the room
      # Performance might be not ideal because everyone in the room will kick this member at the same time (we need only one)
      $.ajax({
        type: "POST",
        url : "/rooms/kick",
        data: {
          user_id: member.id
        },
        success: (data) ->
          update_users();
      });
    );
    # Update the histories
    channel.bind("update_histories", (data) ->
      update_histories(data.history_id);
      true;
    );
    # Listen to the "users_change" event which keeps track of users joining/leaving the room
    channel.bind("users_change", (data) ->
      update_users();
      true;
    );

    channel.bind("chat_message", (data) ->
      # Add the chat message to the chat content	
      $(".chat-content").append("<p>"+data.message+"</p>");
      $(".chat-content p:last-child").effect("highlight",{},2000);
      true;
    );

    # Listen to the "show_explanation" event which keeps track of whether to show explanation or not
    channel.bind("show_explanation", (data) ->
      # Get the choice_id by finding the "btn-primary" class
      choice_id = $("#current_question .each_choice.btn-primary").attr("id");
      show_explanation(data.question_id, choice_id);
      true;
    );

    # Listen to the "next_question" event which keeps track of whether to show next question
    channel.bind("next_question", (data) ->
      $("#observing").modal("hide")
      change_question(data.question_id)
      true;
    );


    # Input: none
    # Effect: update the user list to div#top_nav
    update_users = ->
      $.ajax({
        type: "POST",
        url: "/rooms/user_list",
        success: (data) ->
          $("#top_nav").html(data);
          true;
      });
      true;

    # Input: question_id
    # Effect: changes HTML content of #current_question to show the new question
    change_question = (question_id) ->
      $.ajax({
        type: "POST",
        url: "/rooms/show_question",
        data: {
          question_id: question_id
        },
        success: (data) ->
          if data.message
            alert(data.message)
            window.location.replace("/rooms")
          else
            $("#prompt").html(data.question_prompt);
            $("#choices").html(data.question_choices);
            if data.paragraph != ""
              $("#paragraph").html(data.paragraph).show()
            else
              $("#paragraph").hide()
            $("#ready").hide();
            $("#current_question").addClass("question_active");
            setup_timer(60,confirm_answer);
      });
      true;

    # Input: question_id and choice_id
    # Effect: render the explanation for the given question
    show_explanation = (question_id,choice_id) ->
      $.ajax({
        type: "POST",
        url: "/rooms/show_explanation",
        data: {
          choice_id: choice_id
        },
        success: (data) ->
          $("#choices").html(data);
          setup_timer(60, ready);
      });
      # Show the ready button
      $("#ready").show();
      # Remove the confirm button
      $("#confirm").hide();

    confirm_answer = (choice_id) ->
      $("#timer").countdown("destroy");
      # Send a POST request to "/rooms/choose" (rooms#choose)
      $.ajax({
        type: "POST",
        url: "/rooms/choose/",
        data: {
          choice_id: choice_id
        }
      });
      # Remove question_active class so that the choices are not clickable
      $("#current_question").removeClass("question_active");
      # Disable the button for each choice
      $(".each_choice").addClass("disabled");
    
    # Input: none
    # Effect: send a POST request to ready
    ready = ->
      $("#timer").countdown("destroy");
      $.ajax({
        type: "POST",
        url: "/rooms/ready",
      });
      true;


    update_histories=(history_id)->
      $.ajax({
        type: "POST",
        url: "/histories/show_history",
        data: {
          history_id: history_id
        },
        success: (data) ->
          $("#history").append(data);
          $("#history p:last").effect("highlight",2000);
          #$("#history").animate({
          #  scrollTop: $("#history p:last").position().top
          #},1000);
      });
      true;

    # Show all the previous histories
    update_previous_histories= ->
      $.ajax({
        type: "POST",
        url: "/rooms/show_histories",
        data: {
          room_id: room_id
        },
        success: (data) ->
          $("#history").html(data);
      });
      true;


    # Input: time(seconds), callback(function)
    # Effect: Setup the timer with the specified time and callback
    setup_timer = (time, callback) ->
      $("#timer").countdown({
        until: time,
        compact: true,
        format: 'S',
        description: '',
        onExpiry: callback
      });
      # Set question the first time
    
    if $("#observing").attr("reload") == "true"
      current_question_id = $("#question_container").attr("question_id");
      change_question(current_question_id);
    else
      $("#observing").modal({
        keyboard: false,
        backdrop: 'static',
        show: true
      })


    # Update the user list the first time
    update_users();

    # User clicking on a choice
    # Add class "btn-primary" to the chosen choice
    $(".question_active#current_question #choices .each_choice").live("click", ->
      $(this).siblings().removeClass("btn-primary");
      $(this).addClass("btn-primary");
      contents = $(this).find(".choice_content").text().split("..")
      count = 1
      for content in contents
        $("#blank_"+count).val(content)
        count++
      $("#confirm").show();
      true;
    );

    # User confirming the answer
    $(".question_active#current_question #confirm").live("click", ->
      # Get the choice_id by finding the "btn-primary" class
      choice_id = $(".question_active#current_question .each_choice.btn-primary").attr("id");
      confirm_answer(choice_id);
      true;
    );
    # User clicking "ready"
    $("#ready").live("click", ready);
    
    $("#invite_button").live("click", -> 
      user_list = $("#invite .modal-body p")
      user_list.text("")
      rooms_channel.members.each((member) ->
        console.log(member)
        data = "<div><a href='#' class='invite_link' user_id="+member.id+">"+member.info.name+"</a></div>"
        user_list.append(data)
      )
      $("#invite.modal").modal("show")
    )
    
    $(".invite_link").live("click", ->
      $.ajax({
        type: "POST",
        url: "/rooms/invite",
        data: {
          user_id: $(this).attr("user_id")
        }
        success: ->
          alert("Invited "+$(this).text())
      })
    )
    $("#chat .chat_send").live("click", ->
      message = $("#chat .chat_message").val()
      $.ajax({
        type: "POST",
        url: "/rooms/chat_message",
        data: {
          message: message
        }
      })
      $("#chat .chat_message").val("")
    )
  # Only execute the above code if the page is rooms_join
  if $("#rooms_join").length
    init()

);
