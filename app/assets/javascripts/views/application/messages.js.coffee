class Studium.Views.ApplicationMessages extends Trunk.Views
  controller: "application"
  action: "messages"
  channels:
    user: Studium.Client.subscribe("user_#{gon.user_id}")

  render: ->
    f = this.functions
    $(".message-dropdown").click(f.check_message_read)
    this.channels.user.bind("message", f.update_message_dropdown)

