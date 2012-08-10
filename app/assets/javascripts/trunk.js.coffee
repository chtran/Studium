window.APP_NAME = "Studium"
window.Trunk = {}
Trunk.Helpers = {}

Trunk.Helpers.capitalize = (string) ->
  string.charAt(0).toUpperCase()+string.slice(1)

class Trunk.Controllers

class Trunk.Views
  constructor: ->
    this.functions = window[APP_NAME]["Controllers"][this.controller][this.view]
    if this.correct_view()
      this.listen()
      this.render()

  correct_view: ->
    this.controller==gon.current_controller and this.view==gon.current_action

  render: ->
  listen: ->

