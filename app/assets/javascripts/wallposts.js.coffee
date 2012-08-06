# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(->
  if $('.wall-container').length
    profile_channel = client.subscribe("profile_"+gon.viewed_user_id)
    receiver_id = gon.viewed_user_id
    $('.wall-container #post-btn').click ->
      $.ajax({
        type: 'POST',
        url: '/wallposts/create_wallpost',
        data:{
          receiver_id: receiver_id,
          content    : $('#accordion-wall textarea').val().toString() 
        },
        success: (data) ->
          $('#accordion-wall textarea').val('')
      })

    profile_channel.bind("update_wallposts", (data)->
      new_post_html = data.wallpost
      $('.all-wallposts').prepend($(new_post_html).hide().fadeIn(1500))
    )
)
