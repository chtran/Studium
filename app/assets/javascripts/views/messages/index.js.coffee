class Studium.Views.MessagesIndex extends Trunk.Views
  controller: "messages"
  action: "index"
  channels:
    user: Studium.Client.subscribe("user_#{gon.user_id}")

  render: ->
    f = this.functions
    this.channels.user.bind("message", f.update_message_index)

    available_names = gon.hash_data
    $("#input-receiver").tokenInput(available_names, {
      theme: "facebook"
    })

    $(".new-message").live("click", f.new_message)
