# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  init = ->
    user_channel = client.subscribe("user_" + gon.user_id);
    
    user_channel.bind("message", (data) ->
      info = data.title
      $("#messages_body").prepend("
          <tr>
            <td>
              <img alt='Picture?type=square' src = #{data.image}>
                #{data.title}
                #{data.sender_id}
            </td>
          </tr> ");
    );

  if $('#message').length
    init();
);
