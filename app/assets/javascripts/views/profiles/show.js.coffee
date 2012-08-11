class Studium.Views.ProfilesShow extends Trunk.Views
  controller: "profiles"
  action: "show"

  render: ->
    f = this.functions
    $("#change-status").click(-> f.change_status(gon.user_id))

    $('.status-content textarea').click ->
      $('.status-content textarea').attr('rows', 3)
      event.stopPropagation()
    $(document).click  ->
      $('.status-content textarea').attr('rows', 2)

    $("#add-me").click(f.add_me)
