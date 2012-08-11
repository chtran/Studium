class Studium.Views.MessagesRead extends Trunk.Views
  controller: "messages"
  action: "read"
  channels:
    user: Studium.Client.subscribe("user_#{gon.user_id}")

  render: ->
    f = this.functions
    $(".reply-message").live("click", f.reply_message)
