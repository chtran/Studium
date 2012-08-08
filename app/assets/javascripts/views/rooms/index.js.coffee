class @RoomsIndex extends Room
  view: -> "index"
  render: ->
    # Update room list for the first time
    this.update_room_list()

    # Update room list whenever there's a rooms_change event
    this.channels().room_list.bind("rooms_change", this.update_room_list)

    this.channels().room_list.bind("update_recent_activities", this.update_recent_activities)

    this.channels().user.bind("invite", this.show_invite)

new RoomsIndex()
