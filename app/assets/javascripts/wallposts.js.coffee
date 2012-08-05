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
        url : '/wallposts/create_wallpost',
        data:{
          receiver_id: receiver_id,
          content    : $('#accordion-wall textarea').val().toString() 
        }
        success : ->
          $('#accordion-wall textarea').val('')
      })


    profile_channel.bind("update_wallposts", (data)->
      new_post_html = "
        <hr>
        <div>
          <div class = 'row-fluid wallpost-container'>
            <div class = 'span2'>
              <div class = 'thumbnail thumbnail-wall-image'>
                <img alt='Picture?type=square' class='wall-image' src= #{data.sender_image}>
              </div>
            </div>

            <div class = 'span10 wallpost-content-container'>
              <div class = 'arrow-container'>
                <div class = 'arrow'>
                </div>
              </div>

              <div class = 'wallpost'>
                <div class = 'wallpost-content row-fluid'>
                  <div class = 'span9'>
                    <h4>#{data.sender_name}</h4>
                  </div>
                  <div class = 'span3'>
                    <p class = 'time-ago'>#{data.time}</p>
                  </div>
                  <p>#{data.content}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      "
      $('.all-wallposts').prepend($(new_post_html).hide().fadeIn(2000))

    )



)
