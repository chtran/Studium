window.APP_NAME = "Studium"
window.Trunk = {}
Trunk.f = {}
Trunk.f.capitalize = (string) ->
  string.charAt(0).toUpperCase()+string.slice(1)

class Trunk.Controllers

class Trunk.Views
  controller: ""
  view: ""
  constructor: ->
    this.functions = window[APP_NAME]["Controllers"][Trunk.f.capitalize(this.controller)+Trunk.f.capitalize(this.action)]
    if this.correct_view()
      this.listen()
      this.render()

  correct_view: ->
    correct_controller = this.controller==gon.current_controller
    correct_action = this.action==gon.current_action or this.action=="all"
    return this.controller=="application" or (correct_controller and correct_action)

  render: ->
  listen: ->

