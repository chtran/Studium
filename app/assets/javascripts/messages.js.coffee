# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

(->
  init = ->
    user_channel = client.subscribe("user_" + gon.user_id)
    
    user_channel.bind("message", (data) ->
      
    )


    $('#new_message').click ->
      $('#new_room').modal();

  if $('#new_message').length
    init();
)
