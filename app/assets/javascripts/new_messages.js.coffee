$(->
  init = ->
    user_channel = client.subscribe("user_"+gon.user_id)
    user_channel.bind("message", (data)->
      $(".icon-comment").css('color', '#fff') 

      $("#dropdown-message").prepend("
        <div style='background-color: #eee'>
          <li bgcolor = '#eee'>
            <a href=#{'/messages/' + data.message_id}>
              <div class = 'row-fluid'>
                <div class = 'span3'> 
                  <img alt='Picture?type=square' src = #{data.image}>
                </div>

                <div class = 'span9'>
                  <div>
                    <b>#{data.sender}</b>
                  </div>
                  <small>#{data.body[0..36] + ' ...'}</small>
                </div>
              </div>
            </a>
          </li>
          <li class = 'divider'>
          </li>
        </div>
      ")
    )
    $('.icon-comment').click ->
      $(".icon-comment").css('color', '#999')

  if $("#dropdown-message").length
    init()
)
