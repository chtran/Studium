window.Studium =
  Views: {}
  Controllers: {}
  Client: new Pusher(gon.pusher_key)
  init: ->
    ###
    new Studium.Views.RoomsIndex()
    new Studium.Views.RoomsJoin()
    new Studium.Views.RoomsReview()
    new Studium.Views.MessagesIndex()
    new Studium.Views.MessagesRead()
    new Studium.Views.ApplicationMessages()
    new Studium.Views.HomepageIndex()
    ###
    for name,view of Studium.Views
      new view()

$(->
  Studium.init()
)
