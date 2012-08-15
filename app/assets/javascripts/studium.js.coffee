window.Studium =
  Views: {}
  Controllers: {}
  Client: new Pusher(gon.pusher_key)
  init: ->
    for name,view of Studium.Views
      new view()

$(->
  Studium.init()
)
