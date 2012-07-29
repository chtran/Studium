# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(->
  init = ->
    user_channel = client.subscribe("user_" + gon.user_id);
    
    user_channel.bind("message", (data) ->
      console.log(data)
      $("#messages_body").prepend("
          <tr>
            <td colspan = '2'>
              <a href ='messages/show/#{data.message_id}'>
                <div class = 'row-fluid'>
                  <div class = 'span1'>
                    <img alt='Picture?type=square' src = #{data.image}>
                  </div>

                  <div class = 'span11 message-body'>
                    <h3 class = 'sender-name'> #{data.sender} </h3>
                    <small class = 'content'> #{data.body[0..36] + ' ...'}</small>
                </div>
              </a>
            </td>
          </tr>");
    );
    
    available_names = gon.hash_data
    $("#input-receiver").tokenInput(available_names, 
      {
        theme: "facebook"
      });

  if $('#message').length
    init();
);
