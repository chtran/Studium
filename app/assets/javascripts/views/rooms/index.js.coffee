class Studium.Views.RoomsIndex extends Trunk.Views
  controller: "rooms"
  action: "index"
  channels:
    room_list: Studium.Client.subscribe("presence-rooms")
    user: Studium.Client.subscribe("user_#{gon.user_id}")

  render: ->
    f = this.functions
    # Update room list for the first time
    f.update_room_list()
    f.show_online_users()

  listen: ->
    f = this.functions
    # Update room list whenever there's a rooms_change event
    this.channels.room_list.bind("rooms_change", f.update_room_list)

    this.channels.room_list.bind("update_recent_activities", f.update_recent_activities)

    this.channels.user.bind("invite", f.show_invite)
