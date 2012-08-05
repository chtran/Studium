# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(->
  if $('.wall-container').length
    receiver_id = gon.viewed_user_id
    $('.wall-container #post-btn').click ->
      $.ajax({
        type: 'POST',
        url : '/wallposts/create',
        data:{
          receiver_id: receiver_id,
          sender_id  : gon.user_id,
          content    : $('#accordion-wall textarea').val().toString() 
        }
        success : ->
      })



)
