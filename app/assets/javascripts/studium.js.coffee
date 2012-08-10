window.Studium =
  Views: {}
  Controllers: {
    rooms: {}
  }
  Client: new Pusher(gon.pusher_key)
  init: ->
    new Studium.Views.RoomsIndex()
    new Studium.Views.RoomsJoin()
    new Studium.Views.RoomsReview()

$(->
  Studium.init()
)
