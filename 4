$(->

  init = ->
    get_current_user = ->
      $.ajax({
        type: "POST",
        url : "/rooms/show_current_user"
        success: (data) ->
          current_user_id = data.id
      })
    get_current_user()
    user_channel = client.subscribe("user_#{current_user_id}")
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

   
  if $("#dropdown-message").length
    init()
)
